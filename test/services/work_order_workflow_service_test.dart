import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:fsc_portal/database/app_database.dart';
import 'package:fsc_portal/services/work_order_workflow_service.dart';

void main() {
  late AppDatabase db;
  late WorkOrderWorkflowService service;

  setUp(() async {
    // Create in-memory database for testing
    db = AppDatabase.forTesting(NativeDatabase.memory());
    service = WorkOrderWorkflowService(db);

    // Seed test data
    await db
        .into(db.users)
        .insert(
          UsersCompanion.insert(
            username: 'tech1',
            fullName: 'Test Technician',
            email: 'tech1@test.com',
            role: 'tech',
          ),
        );

    // Seed a test client and site
    final client = await db
        .into(db.clients)
        .insertReturning(
          ClientsCompanion.insert(name: 'Test Client', themeColor: 'blue'),
        );

    await db
        .into(db.sites)
        .insert(
          SitesCompanion.insert(
            clientId: client.id,
            branchName: 'Test Branch',
            address: '123 Test St',
            latitude: 0.0,
            longitude: 0.0,
            region: 'Test',
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  group('Status Transition Validation', () {
    test('allows valid transition from open to assigned', () {
      expect(service.canTransition('open', 'assigned'), true);
    });

    test('blocks invalid transition from completed to draft', () {
      expect(service.canTransition('completed', 'draft'), false);
    });

    test('allows reopening completed work orders', () {
      expect(service.canTransition('completed', 'in_progress'), true);
    });

    test('prevents any transition from closed status', () {
      expect(service.canTransition('closed', 'in_progress'), false);
      expect(service.canTransition('closed', 'open'), false);
    });
  });

  group('Business Rule Validation', () {
    test('requires technician for assigned status', () async {
      final workOrder = await db
          .into(db.workOrders)
          .insertReturning(
            WorkOrdersCompanion.insert(
              siteId: 1,
              status: 'open',
              descriptionOfWork: const Value('Test work'),
              assignedTechnician: const Value(null),
            ),
          );

      expect(
        () async => await service.transitionStatus(
          workOrder: workOrder,
          newStatus: 'assigned',
          userId: 1,
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('requires resolution for completed status', () async {
      final workOrder = await db
          .into(db.workOrders)
          .insertReturning(
            WorkOrdersCompanion.insert(
              siteId: 1,
              status: 'in_progress',
              descriptionOfWork: const Value('Test work'),
              assignedTechnician: const Value('tech1'),
            ),
          );

      expect(
        () async => await service.transitionStatus(
          workOrder: workOrder,
          newStatus: 'completed',
          userId: 1,
        ),
        throwsA(isA<ValidationException>()),
      );
    });

    test('allows completion with valid resolution', () async {
      final workOrder = await db
          .into(db.workOrders)
          .insertReturning(
            WorkOrdersCompanion.insert(
              siteId: 1,
              status: 'in_progress',
              descriptionOfWork: const Value('Test work'),
              assignedTechnician: const Value('tech1'),
              resolution: const Value('Replaced faulty component'),
            ),
          );

      await service.transitionStatus(
        workOrder: workOrder,
        newStatus: 'completed',
        userId: 1,
      );

      final updated = await db.getWorkOrderById(workOrder.id);
      expect(updated!.status, 'completed');
    });
  });

  group('Optimistic Locking', () {
    test('prevents concurrent modifications', () async {
      final workOrder = await db
          .into(db.workOrders)
          .insertReturning(
            WorkOrdersCompanion.insert(
              siteId: 1,
              status: 'open',
              descriptionOfWork: const Value('Test work'),
              version: const Value(1),
            ),
          );

      // Simulate another user modifying the work order
      await db
          .update(db.workOrders)
          .replace(workOrder.copyWith(status: 'assigned', version: 2));

      // Original user tries to update with stale version
      expect(
        () async => await service.transitionStatus(
          workOrder: workOrder, // Still has version 1
          newStatus: 'in_progress',
          userId: 1,
        ),
        throwsA(isA<ConcurrentModificationException>()),
      );
    });

    test('increments version on successful update', () async {
      final workOrder = await db
          .into(db.workOrders)
          .insertReturning(
            WorkOrdersCompanion.insert(
              siteId: 1,
              status: 'open',
              descriptionOfWork: const Value('Test work'),
              assignedTechnician: const Value('tech1'),
              version: const Value(1),
            ),
          );

      await service.transitionStatus(
        workOrder: workOrder,
        newStatus: 'assigned',
        userId: 1,
      );

      final updated = await db.getWorkOrderById(workOrder.id);
      expect(updated!.version, 2);
    });
  });

  group('Audit Logging', () {
    test('logs status transitions', () async {
      final workOrder = await db
          .into(db.workOrders)
          .insertReturning(
            WorkOrdersCompanion.insert(
              siteId: 1,
              status: 'open',
              descriptionOfWork: const Value('Test work'),
              assignedTechnician: const Value('tech1'),
            ),
          );

      await service.transitionStatus(
        workOrder: workOrder,
        newStatus: 'assigned',
        userId: 1,
        notes: 'Assigning to technician',
      );

      final transitions = await service.getTransitionHistory(workOrder.id);
      expect(transitions.length, 1);
      expect(transitions.first.fromStatus, 'open');
      expect(transitions.first.toStatus, 'assigned');
      expect(transitions.first.notes, 'Assigning to technician');
    });

    test('creates audit log entry for all changes', () async {
      final workOrder = await db
          .into(db.workOrders)
          .insertReturning(
            WorkOrdersCompanion.insert(
              siteId: 1,
              status: 'open',
              descriptionOfWork: const Value('Test work'),
              assignedTechnician: const Value('tech1'),
            ),
          );

      await service.transitionStatus(
        workOrder: workOrder,
        newStatus: 'assigned',
        userId: 1,
        reason: 'Scheduled assignment',
      );

      final auditLog = await db.getWorkOrderAuditLog(workOrder.id);
      expect(auditLog.length, 1);
      expect(auditLog.first.action, 'status_change');
      expect(auditLog.first.userId, 1);
      expect(auditLog.first.changeReason, 'Scheduled assignment');
    });
  });

  group('Transaction Safety', () {
    test('rolls back on error', () async {
      final workOrder = await db
          .into(db.workOrders)
          .insertReturning(
            WorkOrdersCompanion.insert(
              siteId: 1,
              status: 'in_progress',
              descriptionOfWork: const Value('Test work'),
            ),
          );

      // This should fail due to missing resolution
      try {
        await service.transitionStatus(
          workOrder: workOrder,
          newStatus: 'completed',
          userId: 1,
        );
      } catch (e) {
        // Expected to fail
      }

      // Verify work order status hasn't changed
      final unchanged = await db.getWorkOrderById(workOrder.id);
      expect(unchanged!.status, 'in_progress');

      // Verify no audit log entry created
      final auditLog = await db.getWorkOrderAuditLog(workOrder.id);
      expect(auditLog.length, 0);
    });
  });

  group('Edge Cases', () {
    test('handles non-existent work order gracefully', () async {
      final fakeWorkOrder = WorkOrder(
        id: 99999,
        siteId: 1,
        status: 'open',
        descriptionOfWork: 'Fake',
        createdAt: DateTime.now(),
        version: 1,
      );

      expect(
        () async => await service.transitionStatus(
          workOrder: fakeWorkOrder,
          newStatus: 'assigned',
          userId: 1,
        ),
        throwsA(isA<WorkOrderNotFoundException>()),
      );
    });

    test('handles invalid status gracefully', () async {
      final workOrder = await db
          .into(db.workOrders)
          .insertReturning(
            WorkOrdersCompanion.insert(
              siteId: 1,
              status: 'open',
              descriptionOfWork: const Value('Test work'),
            ),
          );

      expect(
        () async => await service.transitionStatus(
          workOrder: workOrder,
          newStatus: 'invalid_status',
          userId: 1,
        ),
        throwsA(isA<InvalidStatusTransitionException>()),
      );
    });
  });
}
