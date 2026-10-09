import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servicecore/application/application.dart';
import 'package:servicecore/database/app_database.dart';

/// Regression tests for [WorkOrderService.saveEdit].
///
/// These cover the two defects that made the edit sheet unusable:
///  * a rejected status transition used to leave the field update committed and
///    the row's version bumped, so every retry failed as a phantom conflict;
///  * a `completed` work order could not be reopened, even though the workflow
///    explicitly allows `completed -> in_progress`.
void main() {
  late AppDatabase db;
  late User testUser;
  late Site testSite;
  late WorkOrderService service;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());

    testUser = await db.into(db.users).insertReturning(
          UsersCompanion.insert(
            username: 'testuser',
            fullName: 'Test User',
            email: 'test@test.com',
            role: 'admin',
          ),
        );

    final client = await db.into(db.clients).insertReturning(
          ClientsCompanion.insert(name: 'Test Client', themeColor: 'blue'),
        );

    testSite = await db.into(db.sites).insertReturning(
          SitesCompanion.insert(
            clientId: client.id,
            branchName: 'Test Branch',
            address: '123 Test St',
            latitude: 40.7128,
            longitude: -74.0060,
            region: 'Northeast',
          ),
        );

    service = WorkOrderService(db: db, currentUser: testUser);
  });

  tearDown(() async => db.close());

  Future<WorkOrder> createWorkOrder({
    String status = 'open',
    String description = 'Original description',
    String? technician,
  }) async {
    final result = await service.create(CreateWorkOrder(
      siteId: testSite.id,
      status: status,
      descriptionOfWork: description,
      assignedTechnician: technician,
    ));
    return (await db.getWorkOrderById((result as Ok<int>).value))!;
  }

  group('saveEdit — atomicity', () {
    test('rolls the field update back when the transition is rejected',
        () async {
      // 'open' -> 'assigned' is a legal transition, but the workflow rejects it
      // when no technician is assigned. That rejection happens *after* the
      // field write, which is exactly the case that used to leave a partial
      // commit behind.
      final wo = await createWorkOrder();
      expect(wo.version, 1);

      final result = await service.saveEdit(
        fieldUpdate: UpdateWorkOrder(
          workOrderId: wo.id,
          expectedVersion: wo.version,
          descriptionOfWork: 'Edited description',
          internalNotes: '',
          assignedTechnician: null,
        ),
        transition: TransitionWorkOrder(
          workOrderId: wo.id,
          newStatus: 'assigned',
        ),
      );

      expect(result.isErr, isTrue);

      final after = await db.getWorkOrderById(wo.id);
      expect(after!.descriptionOfWork, 'Original description',
          reason: 'field update must roll back with the failed transition');
      expect(after.version, 1,
          reason: 'a rolled-back save must not consume the version');
      expect(after.status, 'open');
    });

    test('a retry after a rejected transition succeeds', () async {
      // The regression: the first attempt bumped the version, so the second
      // attempt — still holding the original version — failed forever.
      final wo = await createWorkOrder();

      final failed = await service.saveEdit(
        fieldUpdate: UpdateWorkOrder(
          workOrderId: wo.id,
          expectedVersion: wo.version,
          descriptionOfWork: 'Edited description',
          internalNotes: '',
          assignedTechnician: null,
        ),
        transition:
            TransitionWorkOrder(workOrderId: wo.id, newStatus: 'assigned'),
      );
      expect(failed.isErr, isTrue);

      // Same expectedVersion as before — the user has not reloaded anything.
      final retry = await service.saveEdit(
        fieldUpdate: UpdateWorkOrder(
          workOrderId: wo.id,
          expectedVersion: wo.version,
          descriptionOfWork: 'Edited description',
          internalNotes: '',
          assignedTechnician: 'Tech One',
        ),
        transition:
            TransitionWorkOrder(workOrderId: wo.id, newStatus: 'assigned'),
      );

      expect(retry.isOk, isTrue,
          reason: 'retry must not fail as a phantom conflict');

      final after = await db.getWorkOrderById(wo.id);
      expect(after!.descriptionOfWork, 'Edited description');
      expect(after.status, 'assigned');
    });

    test('applies field update and transition together on success', () async {
      final wo = await createWorkOrder(technician: 'Tech One');

      final result = await service.saveEdit(
        fieldUpdate: UpdateWorkOrder(
          workOrderId: wo.id,
          expectedVersion: wo.version,
          descriptionOfWork: 'Edited description',
          internalNotes: 'Some notes',
          assignedTechnician: 'Tech One',
        ),
        transition:
            TransitionWorkOrder(workOrderId: wo.id, newStatus: 'assigned'),
      );

      expect(result.isOk, isTrue);
      final after = await db.getWorkOrderById(wo.id);
      expect(after!.descriptionOfWork, 'Edited description');
      expect(after.internalNotes, 'Some notes');
      expect(after.status, 'assigned');
    });

    test('rejects a stale expectedVersion', () async {
      final wo = await createWorkOrder();
      final result = await service.saveEdit(
        fieldUpdate: UpdateWorkOrder(
          workOrderId: wo.id,
          expectedVersion: wo.version + 5,
          descriptionOfWork: 'Edited',
          internalNotes: '',
        ),
      );
      expect(result.isErr, isTrue);
      expect((result as Err<void>).failure, isA<ConflictFailure>());
    });

    test('no-op when neither a field update nor a transition is given',
        () async {
      expect((await service.saveEdit()).isOk, isTrue);
    });
  });

  group('saveEdit — lock semantics', () {
    test('a completed work order can be reopened', () async {
      // The workflow declares completed -> in_progress ("can reopen if
      // needed"). The UI used to make it unreachable.
      final wo = await createWorkOrder(status: 'completed');

      final result = await service.saveEdit(
        transition:
            TransitionWorkOrder(workOrderId: wo.id, newStatus: 'in_progress'),
      );

      expect(result.isOk, isTrue);
      expect((await db.getWorkOrderById(wo.id))!.status, 'in_progress');
    });

    test('fields of a completed work order cannot be edited in place',
        () async {
      final wo = await createWorkOrder(status: 'completed');

      final result = await service.saveEdit(
        fieldUpdate: UpdateWorkOrder(
          workOrderId: wo.id,
          expectedVersion: wo.version,
          descriptionOfWork: 'Edited',
          internalNotes: '',
        ),
      );

      expect(result.isErr, isTrue);
      expect((result as Err<void>).failure, isA<ConflictFailure>());
      expect(result.failure.message, contains('Reopen'));
    });

    test('a closed work order rejects everything', () async {
      var wo = await createWorkOrder(status: 'completed');
      // 'closed' requires a resolution-bearing completed record.
      await db.updateWorkOrderWithLock(
        WorkOrdersCompanion(
          id: Value(wo.id),
          resolution: const Value('Done'),
          version: Value(wo.version),
        ),
      );
      wo = (await db.getWorkOrderById(wo.id))!;

      expect(
        (await service.saveEdit(
          transition:
              TransitionWorkOrder(workOrderId: wo.id, newStatus: 'closed'),
        ))
            .isOk,
        isTrue,
      );

      final result = await service.saveEdit(
        transition: TransitionWorkOrder(
          workOrderId: wo.id,
          newStatus: 'in_progress',
        ),
      );
      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isA<ConflictFailure>());
    });
  });
}
