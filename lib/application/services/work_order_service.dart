import 'package:drift/drift.dart';

import '../../database/app_database.dart';
import '../../services/work_order_workflow_service.dart';
import '../../util/log.dart';
import '../errors/app_failure.dart';
import '../errors/result.dart';

// ============================================
// COMMAND OBJECTS (input DTOs)
// ============================================

/// Command to create a new work order.
class CreateWorkOrder {
  const CreateWorkOrder({
    required this.siteId,
    required this.status,
    this.priority,
    this.descriptionOfWork,
    this.internalNotes,
    this.assignedTechnician,
  });

  final int siteId;
  final String status;
  final String? priority;
  final String? descriptionOfWork;
  final String? internalNotes;
  final String? assignedTechnician;
}

/// Command to update an existing work order (optimistic locking).
class UpdateWorkOrder {
  const UpdateWorkOrder({
    required this.workOrderId,
    required this.expectedVersion,
    required this.descriptionOfWork,
    required this.internalNotes,
    this.resolution,
    this.priority,
    this.assignedTechnician,
  });

  final int workOrderId;
  /// Version from the last read [WorkOrder]; must match DB row for update to apply.
  final int expectedVersion;
  final String descriptionOfWork;
  final String internalNotes;
  final String? resolution;
  final String? priority;
  final String? assignedTechnician;
}

/// Command to transition work order status.
class TransitionWorkOrder {
  const TransitionWorkOrder({
    required this.workOrderId,
    required this.newStatus,
    this.reason,
    this.notes,
  });

  final int workOrderId;
  final String newStatus;
  final String? reason;
  final String? notes;
}

/// Command to add a note to a work order.
class AddWorkOrderNote {
  const AddWorkOrderNote({
    required this.workOrderId,
    required this.noteText,
    required this.noteType,
  });

  final int workOrderId;
  final String noteText;
  final String noteType;
}

/// Command to link equipment to a work order.
class LinkEquipment {
  const LinkEquipment({
    required this.workOrderId,
    required this.equipmentId,
  });

  final int workOrderId;
  final int equipmentId;
}

// ============================================
// SERVICE IMPLEMENTATION
// ============================================

/// The single write boundary for all work order operations.
///
/// UI code must call this service for any work order mutations.
/// Direct database access for writes is prohibited.
class WorkOrderService {
  WorkOrderService({
    required AppDatabase db,
    required User? currentUser,
  })  : _db = db,
        _currentUser = currentUser,
        _workflowService = WorkOrderWorkflowService(db);

  final AppDatabase _db;
  final User? _currentUser;
  final WorkOrderWorkflowService _workflowService;

  // ============================================
  // CREATE
  // ============================================

  /// Creates a new work order.
  ///
  /// Returns the new work order ID on success.
  Future<Result<int>> create(CreateWorkOrder cmd) async {
    // 1. Validate inputs
    final validationError = _validateCreate(cmd);
    if (validationError != null) {
      return Err(validationError);
    }

    // 2. Check permissions (placeholder - permissive for now)
    final permissionError = _checkCreatePermission();
    if (permissionError != null) {
      return Err(permissionError);
    }

    // 3. Verify site exists
    try {
      final site = await _db.getSiteById(cmd.siteId);
      if (site == null) {
        return Err(NotFoundFailure('Site ${cmd.siteId} not found'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to verify site', cause: e, stackTrace: st));
    }

    // 4. Execute in transaction
    try {
      final now = DateTime.now();
      final createdBy = _currentUser?.fullName ?? 'System';

      final workOrderId = await _db.transaction(() async {
        final id = await _db.into(_db.workOrders).insert(
          WorkOrdersCompanion.insert(
            siteId: cmd.siteId,
            status: cmd.status,
            priority: Value(cmd.priority),
            descriptionOfWork: Value(cmd.descriptionOfWork),
            internalNotes: Value(cmd.internalNotes),
            assignedTechnician: Value(cmd.assignedTechnician),
            createdAt: now,
            createdBy: Value(createdBy),
          ),
        );
        return id;
      });

      Log.info('WorkOrderService: Created work order $workOrderId');
      return Ok(workOrderId);
    } catch (e, st) {
      Log.error('WorkOrderService: Failed to create work order', e, st);
      return Err(StorageFailure('Failed to create work order', cause: e, stackTrace: st));
    }
  }

  // ============================================
  // UPDATE
  // ============================================

  /// Updates an existing work order's editable fields.
  Future<Result<void>> update(UpdateWorkOrder cmd) async {
    // 1. Validate inputs
    if (cmd.workOrderId <= 0) {
      return Err(ValidationFailure('Invalid work order ID', field: 'workOrderId'));
    }

    // 2. Check permissions
    final permissionError = await _checkUpdatePermission(cmd.workOrderId);
    if (permissionError != null) {
      return Err(permissionError);
    }

    // 3. Verify work order exists
    WorkOrder? existing;
    try {
      existing = await _db.getWorkOrderById(cmd.workOrderId);
      if (existing == null) {
        return Err(NotFoundFailure('Work order ${cmd.workOrderId} not found'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to fetch work order', cause: e, stackTrace: st));
    }

    final wo = existing;

    // 4. Check if work order is editable (not in terminal state)
    if (_isNonEditableStatus(wo.status)) {
      return Err(ConflictFailure('Cannot edit work order in this state'));
    }

    if (cmd.expectedVersion != wo.version) {
      return Err(
        ConflictFailure(
          'Work order was modified elsewhere. Refresh and try again.',
        ),
      );
    }

    final trimmedDesc = cmd.descriptionOfWork.trim();
    if (trimmedDesc.isEmpty) {
      return Err(ValidationFailure('Description is required', field: 'descriptionOfWork'));
    }

    // 5. Execute update with optimistic locking (version bump) + audit in one transaction
    try {
      final success = await _db.transaction(() async {
        final ok = await _db.updateWorkOrderWithLock(
          WorkOrdersCompanion(
            id: Value(cmd.workOrderId),
            siteId: Value(wo.siteId),
            descriptionOfWork: Value(trimmedDesc),
            internalNotes: Value(cmd.internalNotes.trim()),
            resolution: Value(
              cmd.resolution?.trim().isEmpty ?? true ? null : cmd.resolution?.trim(),
            ),
            priority: Value(cmd.priority),
            assignedTechnician: Value(cmd.assignedTechnician),
            version: Value(cmd.expectedVersion),
          ),
        );
        if (!ok) return false;
        await _db.into(_db.workOrderAuditLog).insert(
              WorkOrderAuditLogCompanion.insert(
                workOrderId: cmd.workOrderId,
                userId: _currentUser?.id ?? 0,
                action: 'update',
                changeReason: const Value('User edited work order'),
              ),
            );
        return true;
      });

      if (!success) {
        return Err(
          ConflictFailure(
            'Work order was modified elsewhere. Refresh and try again.',
          ),
        );
      }

      Log.info('WorkOrderService: Updated work order ${cmd.workOrderId}');
      return const Ok(null);
    } catch (e, st) {
      Log.error('WorkOrderService: Failed to update work order', e, st);
      return Err(StorageFailure('Failed to update work order', cause: e, stackTrace: st));
    }
  }

  static bool _isNonEditableStatus(String status) {
    const blocked = {'completed', 'closed', 'cancelled'};
    return blocked.contains(status.toLowerCase());
  }

  // ============================================
  // TRANSITION
  // ============================================

  /// Transitions work order to a new status.
  ///
  /// Enforces workflow rules via [WorkOrderWorkflowService].
  Future<Result<void>> transition(TransitionWorkOrder cmd) async {
    // 1. Validate inputs
    if (cmd.workOrderId <= 0) {
      return Err(ValidationFailure('Invalid work order ID', field: 'workOrderId'));
    }
    if (cmd.newStatus.isEmpty) {
      return Err(ValidationFailure('New status is required', field: 'newStatus'));
    }

    // 2. Check permissions
    final permissionError = await _checkUpdatePermission(cmd.workOrderId);
    if (permissionError != null) {
      return Err(permissionError);
    }

    // 3. Fetch current work order
    WorkOrder? workOrder;
    try {
      workOrder = await _db.getWorkOrderById(cmd.workOrderId);
      if (workOrder == null) {
        return Err(NotFoundFailure('Work order ${cmd.workOrderId} not found'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to fetch work order', cause: e, stackTrace: st));
    }

    // 4. Check transition validity
    if (!_workflowService.canTransition(workOrder.status, cmd.newStatus)) {
      return Err(ConflictFailure(
        'Cannot transition from ${workOrder.status} to ${cmd.newStatus}',
      ));
    }

    // 5. Execute transition via workflow service
    try {
      await _workflowService.transitionStatus(
        workOrder: workOrder,
        newStatus: cmd.newStatus,
        userId: _currentUser?.id ?? 0,
        notes: cmd.notes,
        reason: cmd.reason,
      );

      Log.info('WorkOrderService: Transitioned work order ${cmd.workOrderId} to ${cmd.newStatus}');
      return const Ok(null);
    } on InvalidStatusTransitionException catch (e) {
      return Err(ConflictFailure(e.message));
    } on WorkOrderNotFoundException catch (e) {
      return Err(NotFoundFailure(e.message));
    } on ConcurrentModificationException catch (e) {
      return Err(ConflictFailure(e.message));
    } on ValidationException catch (e) {
      return Err(ValidationFailure(e.message));
    } catch (e, st) {
      Log.error('WorkOrderService: Failed to transition work order', e, st);
      return Err(StorageFailure('Failed to transition work order', cause: e, stackTrace: st));
    }
  }

  // ============================================
  // ADD NOTE
  // ============================================

  /// Adds a note to a work order.
  Future<Result<int>> addNote(AddWorkOrderNote cmd) async {
    // 1. Validate inputs
    if (cmd.workOrderId <= 0) {
      return Err(ValidationFailure('Invalid work order ID', field: 'workOrderId'));
    }
    if (cmd.noteText.trim().isEmpty) {
      return Err(ValidationFailure('Note text is required', field: 'noteText'));
    }

    // 2. Check permissions
    final permissionError = await _checkUpdatePermission(cmd.workOrderId);
    if (permissionError != null) {
      return Err(permissionError);
    }

    // 3. Verify work order exists
    try {
      final workOrder = await _db.getWorkOrderById(cmd.workOrderId);
      if (workOrder == null) {
        return Err(NotFoundFailure('Work order ${cmd.workOrderId} not found'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to verify work order', cause: e, stackTrace: st));
    }

    // 4. Insert note (using Notes table with workOrderId)
    try {
      // Get site ID from work order for the note
      final workOrder = await _db.getWorkOrderById(cmd.workOrderId);
      if (workOrder == null) {
        return Err(NotFoundFailure('Work order ${cmd.workOrderId} not found'));
      }

      final noteId = await _db.transaction(() async {
        return await _db.into(_db.notes).insert(
          NotesCompanion.insert(
            siteId: workOrder.siteId,
            workOrderId: Value(cmd.workOrderId),
            noteType: cmd.noteType,
            noteText: cmd.noteText.trim(),
            createdAt: DateTime.now(),
            createdBy: Value(_currentUser?.fullName ?? 'System'),
          ),
        );
      });

      Log.info('WorkOrderService: Added note $noteId to work order ${cmd.workOrderId}');
      return Ok(noteId);
    } catch (e, st) {
      Log.error('WorkOrderService: Failed to add note', e, st);
      return Err(StorageFailure('Failed to add note', cause: e, stackTrace: st));
    }
  }

  // ============================================
  // LINK EQUIPMENT
  // ============================================

  /// Links equipment to a work order.
  Future<Result<void>> linkEquipment(LinkEquipment cmd) async {
    // 1. Validate inputs
    if (cmd.workOrderId <= 0) {
      return Err(ValidationFailure('Invalid work order ID', field: 'workOrderId'));
    }
    if (cmd.equipmentId <= 0) {
      return Err(ValidationFailure('Invalid equipment ID', field: 'equipmentId'));
    }

    // 2. Check permissions
    final permissionError = await _checkUpdatePermission(cmd.workOrderId);
    if (permissionError != null) {
      return Err(permissionError);
    }

    // 3. Verify both exist
    try {
      final workOrder = await _db.getWorkOrderById(cmd.workOrderId);
      if (workOrder == null) {
        return Err(NotFoundFailure('Work order ${cmd.workOrderId} not found'));
      }

      final equipment = await _db.getEquipmentById(cmd.equipmentId);
      if (equipment == null) {
        return Err(NotFoundFailure('Equipment ${cmd.equipmentId} not found'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to verify entities', cause: e, stackTrace: st));
    }

    // 4. Create link
    try {
      await _db.transaction(() async {
        await _db.linkEquipmentToWorkOrder(cmd.workOrderId, cmd.equipmentId);
      });

      Log.info('WorkOrderService: Linked equipment ${cmd.equipmentId} to work order ${cmd.workOrderId}');
      return const Ok(null);
    } catch (e, st) {
      // Check for duplicate
      if (e.toString().contains('UNIQUE constraint')) {
        return Err(ConflictFailure('Equipment already linked to this work order'));
      }
      Log.error('WorkOrderService: Failed to link equipment', e, st);
      return Err(StorageFailure('Failed to link equipment', cause: e, stackTrace: st));
    }
  }

  // ============================================
  // VALIDATION HELPERS
  // ============================================

  ValidationFailure? _validateCreate(CreateWorkOrder cmd) {
    if (cmd.siteId <= 0) {
      return ValidationFailure('Site is required', field: 'siteId');
    }
    if (cmd.status.isEmpty) {
      return ValidationFailure('Status is required', field: 'status');
    }
    // Validate status is a known value
    final validStatuses = ['draft', 'open', 'on_hold', 'completed'];
    if (!validStatuses.contains(cmd.status)) {
      return ValidationFailure('Invalid status: ${cmd.status}', field: 'status');
    }
    return null;
  }

  // ============================================
  // PERMISSION HELPERS (placeholder - permissive for now)
  // ============================================

  AppFailure? _checkCreatePermission() {
    // TODO: Implement role-based permission checks
    // For now, all authenticated users can create
    if (_currentUser == null) {
      return const UnauthorizedFailure('Authentication required');
    }
    return null;
  }

  Future<AppFailure?> _checkUpdatePermission(int workOrderId) async {
    // TODO: Implement role-based permission checks
    // - Tech can only edit own assigned work orders
    // - Dispatcher can edit any
    // - Manager/Admin can edit any
    if (_currentUser == null) {
      return const UnauthorizedFailure('Authentication required');
    }
    return null;
  }
}
