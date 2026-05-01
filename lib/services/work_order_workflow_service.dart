import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../util/log.dart';

enum WorkOrderStatus {
  draft, // Initial creation, not submitted
  open, // Submitted, awaiting assignment
  assigned, // Assigned to technician
  inProgress, // Work started
  onHold, // Paused/blocked
  completed, // Work done, awaiting review
  closed, // Reviewed and finalized
  cancelled, // Cancelled before completion
}

class WorkOrderWorkflowService {
  final AppDatabase db;

  WorkOrderWorkflowService(this.db);

  // Define valid state transitions
  static const Map<String, List<String>> _validTransitions = {
    'draft': ['open', 'cancelled'],
    'open': ['assigned', 'cancelled'],
    'assigned': ['in_progress', 'on_hold', 'cancelled'],
    'in_progress': ['on_hold', 'completed', 'cancelled'],
    'on_hold': ['in_progress', 'cancelled'],
    'completed': ['closed', 'in_progress'], // Can reopen if needed
    'closed': [], // Terminal state
    'cancelled': [], // Terminal state
  };

  /// Validates if transition is allowed
  bool canTransition(String fromStatus, String toStatus) {
    final validNext = _validTransitions[fromStatus] ?? [];
    return validNext.contains(toStatus);
  }

  /// Performs status transition with validation and audit logging
  Future<void> transitionStatus({
    required WorkOrder workOrder,
    required String newStatus,
    required int userId,
    String? notes,
    String? reason,
  }) async {
    // Validation
    if (!canTransition(workOrder.status, newStatus)) {
      throw InvalidStatusTransitionException(
        'Cannot transition from ${workOrder.status} to $newStatus',
      );
    }

    // Optimistic locking check
    final current = await db.getWorkOrderById(workOrder.id);
    if (current == null) {
      throw WorkOrderNotFoundException('Work order ${workOrder.id} not found');
    }

    if (current.version != workOrder.version) {
      throw ConcurrentModificationException(
        'Work order was modified by another user. Please refresh and try again.',
      );
    }

    // Business rule validations
    await _validateBusinessRules(workOrder, newStatus);

    // Perform transition in transaction
    await db.transaction(() async {
      // Update work order
      await db
          .update(db.workOrders)
          .replace(
            current.copyWith(
              status: newStatus,
              previousStatus: Value(workOrder.status),
              statusChangedBy: Value(userId),
              statusChangedAt: Value(DateTime.now()),
              version: current.version + 1,
            ),
          );

      // Log transition
      await db
          .into(db.workOrderStatusTransitions)
          .insert(
            WorkOrderStatusTransitionsCompanion.insert(
              workOrderId: workOrder.id,
              fromStatus: workOrder.status,
              toStatus: newStatus,
              changedBy: userId,
              notes: Value(notes),
            ),
          );

      // Audit log
      await db
          .into(db.workOrderAuditLog)
          .insert(
            WorkOrderAuditLogCompanion.insert(
              workOrderId: workOrder.id,
              userId: userId,
              action: 'status_change',
              fieldChanged: Value('status'),
              oldValue: Value(workOrder.status),
              newValue: Value(newStatus),
              changeReason: Value(reason),
            ),
          );
    });

    Log.info(
      'Work order ${workOrder.id} transitioned from ${workOrder.status} to $newStatus',
    );
  }

  /// Business rule validations
  Future<void> _validateBusinessRules(
    WorkOrder workOrder,
    String newStatus,
  ) async {
    switch (newStatus) {
      case 'assigned':
        if (workOrder.assignedTechnician == null) {
          throw ValidationException(
            'Cannot assign work order without technician',
          );
        }
        break;

      case 'completed':
        // Must have resolution
        if (workOrder.resolution == null || workOrder.resolution!.isEmpty) {
          throw ValidationException(
            'Resolution is required to complete work order',
          );
        }

        // Verify required fields based on work order type
        final parts = await db.watchPartsUsedForWorkOrder(workOrder.id);
        if (parts.isEmpty) {
          Log.warn(
            'Work order ${workOrder.id} completed without parts logged',
          );
        }
              break;

      case 'closed':
        if (workOrder.status != 'completed') {
          throw ValidationException(
            'Work order must be completed before closing',
          );
        }
        break;
    }
  }

  /// Get transition history for work order
  Future<List<WorkOrderStatusTransition>> getTransitionHistory(
    int workOrderId,
  ) async {
    return db.getWorkOrderStatusTransitions(workOrderId);
  }
}

// Custom exceptions
class InvalidStatusTransitionException implements Exception {
  final String message;
  InvalidStatusTransitionException(this.message);
  @override
  String toString() => message;
}

class WorkOrderNotFoundException implements Exception {
  final String message;
  WorkOrderNotFoundException(this.message);
  @override
  String toString() => message;
}

class ConcurrentModificationException implements Exception {
  final String message;
  ConcurrentModificationException(this.message);
  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
  @override
  String toString() => message;
}
