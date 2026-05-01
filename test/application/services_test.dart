import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:fsc_portal/database/app_database.dart';
import 'package:fsc_portal/application/application.dart';

void main() {
  late AppDatabase db;
  late User testUser;
  late Site testSite;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());

    // Seed test user
    testUser = await db.into(db.users).insertReturning(
          UsersCompanion.insert(
            username: 'testuser',
            fullName: 'Test User',
            email: 'test@test.com',
            role: 'admin',
          ),
        );

    // Seed test client and site
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
  });

  tearDown(() async {
    await db.close();
  });

  // ============================================
  // NOTE SERVICE TESTS
  // ============================================
  group('NoteService', () {
    late NoteService noteService;

    setUp(() {
      noteService = NoteService(db: db, currentUser: testUser);
    });

    group('create', () {
      test('creates note with valid data', () async {
        final result = await noteService.create(CreateNote(
          siteId: testSite.id,
          noteType: 'general',
          noteText: 'This is a test note',
        ));

        expect(result, isA<Ok<int>>());
        final noteId = (result as Ok<int>).value;
        expect(noteId, greaterThan(0));

        // Verify in database
        final note = await (db.select(db.notes)..where((t) => t.id.equals(noteId))).getSingleOrNull();
        expect(note, isNotNull);
        expect(note!.noteText, 'This is a test note');
        expect(note.noteType, 'general');
        expect(note.createdBy, 'Test User');
      });

      test('rejects empty note text', () async {
        final result = await noteService.create(CreateNote(
          siteId: testSite.id,
          noteType: 'general',
          noteText: '   ',
        ));

        expect(result, isA<Err<int>>());
        final err = result as Err<int>;
        expect(err.failure, isA<ValidationFailure>());
        expect((err.failure as ValidationFailure).field, 'noteText');
      });

      test('rejects invalid note type', () async {
        final result = await noteService.create(CreateNote(
          siteId: testSite.id,
          noteType: 'invalid_type',
          noteText: 'Test note',
        ));

        expect(result, isA<Err<int>>());
        final err = result as Err<int>;
        expect(err.failure, isA<ValidationFailure>());
        expect((err.failure as ValidationFailure).field, 'noteType');
      });

      test('rejects non-existent site', () async {
        final result = await noteService.create(CreateNote(
          siteId: 99999,
          noteType: 'general',
          noteText: 'Test note',
        ));

        expect(result, isA<Err<int>>());
        final err = result as Err<int>;
        expect(err.failure, isA<NotFoundFailure>());
      });

      test('accepts optional work order link', () async {
        // Create a work order first
        final wo = await db.into(db.workOrders).insertReturning(
              WorkOrdersCompanion.insert(
                siteId: testSite.id,
                status: 'open',
                createdAt: DateTime.now(),
              ),
            );

        final result = await noteService.create(CreateNote(
          siteId: testSite.id,
          noteType: 'poi',
          noteText: 'Work order related note',
          workOrderId: wo.id,
        ));

        expect(result, isA<Ok<int>>());
        final noteId = (result as Ok<int>).value;

        final note = await (db.select(db.notes)..where((t) => t.id.equals(noteId))).getSingleOrNull();
        expect(note!.workOrderId, wo.id);
      });
    });

    group('update', () {
      test('updates existing note', () async {
        // Create a note first
        final createResult = await noteService.create(CreateNote(
          siteId: testSite.id,
          noteType: 'general',
          noteText: 'Original text',
        ));
        final noteId = (createResult as Ok<int>).value;

        // Update it
        final result = await noteService.update(UpdateNote(
          noteId: noteId,
          noteText: 'Updated text',
          noteType: 'warning',
        ));

        expect(result, isA<Ok<void>>());

        // Verify
        final note = await (db.select(db.notes)..where((t) => t.id.equals(noteId))).getSingleOrNull();
        expect(note!.noteText, 'Updated text');
        expect(note.noteType, 'warning');
      });

      test('rejects non-existent note', () async {
        final result = await noteService.update(UpdateNote(
          noteId: 99999,
          noteText: 'Updated text',
        ));

        expect(result, isA<Err<void>>());
        expect((result as Err<void>).failure, isA<NotFoundFailure>());
      });
    });

    group('delete', () {
      test('deletes existing note', () async {
        final createResult = await noteService.create(CreateNote(
          siteId: testSite.id,
          noteType: 'general',
          noteText: 'To be deleted',
        ));
        final noteId = (createResult as Ok<int>).value;

        final result = await noteService.delete(DeleteNote(noteId: noteId));
        expect(result, isA<Ok<void>>());

        // Verify deleted
        final note = await (db.select(db.notes)..where((t) => t.id.equals(noteId))).getSingleOrNull();
        expect(note, isNull);
      });
    });
  });

  // ============================================
  // ANNOUNCEMENT SERVICE TESTS
  // ============================================
  group('AnnouncementService', () {
    late AnnouncementService announcementService;

    setUp(() {
      announcementService = AnnouncementService(db: db, currentUser: testUser);
    });

    group('create', () {
      test('creates announcement with valid data', () async {
        final result = await announcementService.create(CreateAnnouncement(
          category: 'safety',
          title: 'Safety Alert',
          body: 'Please wear hard hats in construction zones.',
        ));

        expect(result, isA<Ok<int>>());
        final id = (result as Ok<int>).value;

        final announcement = await (db.select(db.companyAnnouncements)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();
        expect(announcement, isNotNull);
        expect(announcement!.title, 'Safety Alert');
        expect(announcement.category, 'safety');
        expect(announcement.active, true);
      });

      test('rejects empty title', () async {
        final result = await announcementService.create(CreateAnnouncement(
          category: 'hr',
          title: '',
          body: 'Some body text',
        ));

        expect(result, isA<Err<int>>());
        expect((result as Err<int>).failure, isA<ValidationFailure>());
      });

      test('rejects invalid category', () async {
        final result = await announcementService.create(CreateAnnouncement(
          category: 'invalid',
          title: 'Test',
          body: 'Body',
        ));

        expect(result, isA<Err<int>>());
        final err = result as Err<int>;
        expect(err.failure, isA<ValidationFailure>());
        expect((err.failure as ValidationFailure).field, 'category');
      });
    });

    group('acknowledge', () {
      test('acknowledges announcement', () async {
        final createResult = await announcementService.create(CreateAnnouncement(
          category: 'hr',
          title: 'Policy Update',
          body: 'New policy details...',
        ));
        final id = (createResult as Ok<int>).value;

        final result = await announcementService.acknowledge(
          AcknowledgeAnnouncement(announcementId: id),
        );

        expect(result, isA<Ok<void>>());

        final announcement = await (db.select(db.companyAnnouncements)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();
        expect(announcement!.acknowledged, true);
        expect(announcement.acknowledgedAt, isNotNull);
      });

      test('is idempotent (acknowledging twice succeeds)', () async {
        final createResult = await announcementService.create(CreateAnnouncement(
          category: 'fleet',
          title: 'Fleet Update',
          body: 'Vehicle maintenance schedule',
        ));
        final id = (createResult as Ok<int>).value;

        await announcementService.acknowledge(AcknowledgeAnnouncement(announcementId: id));
        final result = await announcementService.acknowledge(
          AcknowledgeAnnouncement(announcementId: id),
        );

        expect(result, isA<Ok<void>>());
      });
    });
  });

  // ============================================
  // LOCATION SERVICE TESTS
  // ============================================
  group('LocationService', () {
    late LocationService locationService;

    setUp(() {
      locationService = LocationService(db: db, currentUser: testUser);
    });

    group('create', () {
      test('creates location with valid data', () async {
        final result = await locationService.create(CreateSite(
          clientId: testSite.clientId,
          branchName: 'New Branch',
          address: '456 New St',
          latitude: 34.0522,
          longitude: -118.2437,
          region: 'West',
        ));

        expect(result, isA<Ok<int>>());
        final siteId = (result as Ok<int>).value;

        final site = await db.getSiteById(siteId);
        expect(site, isNotNull);
        expect(site!.branchName, 'New Branch');
        expect(site.region, 'West');
      });

      test('rejects empty branch name', () async {
        final result = await locationService.create(CreateSite(
          clientId: testSite.clientId,
          branchName: '',
          address: '456 New St',
          latitude: 34.0522,
          longitude: -118.2437,
          region: 'West',
        ));

        expect(result, isA<Err<int>>());
        expect((result as Err<int>).failure, isA<ValidationFailure>());
      });

      test('rejects invalid coordinates', () async {
        final result = await locationService.create(CreateSite(
          clientId: testSite.clientId,
          branchName: 'Test',
          address: 'Address',
          latitude: 100.0, // Invalid - must be -90 to 90
          longitude: -118.2437,
          region: 'West',
        ));

        expect(result, isA<Err<int>>());
        final err = result as Err<int>;
        expect(err.failure, isA<ValidationFailure>());
        expect((err.failure as ValidationFailure).field, 'latitude');
      });

      test('rejects non-existent client', () async {
        final result = await locationService.create(CreateSite(
          clientId: 99999,
          branchName: 'Test Branch',
          address: 'Address',
          latitude: 40.0,
          longitude: -74.0,
          region: 'East',
        ));

        expect(result, isA<Err<int>>());
        expect((result as Err<int>).failure, isA<NotFoundFailure>());
      });
    });

    group('archive', () {
      test('archive returns not-implemented error (soft delete pending)', () async {
        final createResult = await locationService.create(CreateSite(
          clientId: testSite.clientId,
          branchName: 'To Archive',
          address: 'Address',
          latitude: 40.0,
          longitude: -74.0,
          region: 'East',
        ));
        final siteId = (createResult as Ok<int>).value;

        // Archive not yet implemented - returns validation error
        final result = await locationService.archive(ArchiveSite(siteId: siteId));
        expect(result, isA<Err<void>>());
      });
    });
  });

  // ============================================
  // EQUIPMENT SERVICE TESTS
  // ============================================
  group('EquipmentService', () {
    late EquipmentService equipmentService;

    setUp(() {
      equipmentService = EquipmentService(db: db, currentUser: testUser);
    });

    group('create', () {
      test('creates equipment with valid data', () async {
        final result = await equipmentService.create(CreateEquipment(
          siteId: testSite.id,
          equipmentType: 'HVAC',
          manufacturer: 'Carrier',
          model: 'XR15',
          serialNumber: 'SN123456',
        ));

        expect(result, isA<Ok<int>>());
        final equipId = (result as Ok<int>).value;

        final equip = await (db.select(db.equipment)..where((t) => t.id.equals(equipId))).getSingleOrNull();
        expect(equip, isNotNull);
        expect(equip!.manufacturer, 'Carrier');
        expect(equip.model, 'XR15');
      });

      test('rejects empty equipment type', () async {
        final result = await equipmentService.create(CreateEquipment(
          siteId: testSite.id,
          equipmentType: '',
          manufacturer: 'Test',
          model: 'Model',
          serialNumber: 'SN123',
        ));

        expect(result, isA<Err<int>>());
        expect((result as Err<int>).failure, isA<ValidationFailure>());
      });

      test('rejects non-existent site', () async {
        final result = await equipmentService.create(CreateEquipment(
          siteId: 99999,
          equipmentType: 'HVAC',
          manufacturer: 'Test',
          model: 'Model',
          serialNumber: 'SN123',
        ));

        expect(result, isA<Err<int>>());
        expect((result as Err<int>).failure, isA<NotFoundFailure>());
      });
    });

    group('retire', () {
      test('retires equipment (sets active=false)', () async {
        final createResult = await equipmentService.create(CreateEquipment(
          siteId: testSite.id,
          equipmentType: 'HVAC',
          manufacturer: 'Old Brand',
          model: 'Obsolete',
          serialNumber: 'SN-OLD',
        ));
        final equipId = (createResult as Ok<int>).value;

        final result = await equipmentService.retire(RetireEquipment(
          equipmentId: equipId,
          reason: 'End of life - replaced with newer model',
        ));

        expect(result, isA<Ok<void>>());

        final equip = await (db.select(db.equipment)..where((t) => t.id.equals(equipId))).getSingleOrNull();
        expect(equip!.active, false); // Equipment uses 'active' flag for retirement
      });

      test('cannot retire already retired equipment', () async {
        final createResult = await equipmentService.create(CreateEquipment(
          siteId: testSite.id,
          equipmentType: 'HVAC',
          manufacturer: 'Test',
          model: 'Model',
          serialNumber: 'SN123',
        ));
        final equipId = (createResult as Ok<int>).value;

        // Retire once
        await equipmentService.retire(RetireEquipment(equipmentId: equipId));

        // Try to retire again - should fail
        final result = await equipmentService.retire(RetireEquipment(equipmentId: equipId));
        expect(result, isA<Err<void>>());
        expect((result as Err<void>).failure, isA<ConflictFailure>());
      });
    });
  });

  // ============================================
  // WORK ORDER SERVICE TESTS
  // ============================================
  group('WorkOrderService', () {
    late WorkOrderService workOrderService;

    setUp(() {
      workOrderService = WorkOrderService(db: db, currentUser: testUser);
    });

    group('create', () {
      test('creates work order with valid data', () async {
        final result = await workOrderService.create(CreateWorkOrder(
          siteId: testSite.id,
          status: 'open',
          descriptionOfWork: 'Fix broken HVAC unit',
          priority: 'high',
        ));

        expect(result, isA<Ok<int>>());
        final woId = (result as Ok<int>).value;

        final wo = await db.getWorkOrderById(woId);
        expect(wo, isNotNull);
        expect(wo!.descriptionOfWork, 'Fix broken HVAC unit');
        expect(wo.priority, 'high');
        expect(wo.status, 'open');
      });

      test('rejects invalid status', () async {
        final result = await workOrderService.create(CreateWorkOrder(
          siteId: testSite.id,
          status: 'invalid_status',
          descriptionOfWork: 'Test',
        ));

        expect(result, isA<Err<int>>());
        expect((result as Err<int>).failure, isA<ValidationFailure>());
      });

      test('accepts any priority value (validation is lenient)', () async {
        // WorkOrderService currently allows any priority value
        // This test documents current behavior
        final result = await workOrderService.create(CreateWorkOrder(
          siteId: testSite.id,
          status: 'open',
          descriptionOfWork: 'Test',
          priority: 'custom_priority',
        ));

        expect(result, isA<Ok<int>>());
      });
    });

    group('transition', () {
      test('allows valid status transition', () async {
        final createResult = await workOrderService.create(CreateWorkOrder(
          siteId: testSite.id,
          status: 'open',
          descriptionOfWork: 'Test work order',
          assignedTechnician: 'testuser',
        ));
        final woId = (createResult as Ok<int>).value;

        final result = await workOrderService.transition(TransitionWorkOrder(
          workOrderId: woId,
          newStatus: 'assigned',
        ));

        expect(result, isA<Ok<void>>());

        final wo = await db.getWorkOrderById(woId);
        expect(wo!.status, 'assigned');
      });

      test('rejects invalid transition', () async {
        final createResult = await workOrderService.create(CreateWorkOrder(
          siteId: testSite.id,
          status: 'open',
          descriptionOfWork: 'Test',
        ));
        final woId = (createResult as Ok<int>).value;

        // Can't go directly from open to completed
        final result = await workOrderService.transition(TransitionWorkOrder(
          workOrderId: woId,
          newStatus: 'completed',
        ));

        expect(result, isA<Err<void>>());
        // Invalid transitions return ConflictFailure
        expect((result as Err<void>).failure, isA<ConflictFailure>());
      });
    });

    group('addNote', () {
      test('adds note to work order', () async {
        final createResult = await workOrderService.create(CreateWorkOrder(
          siteId: testSite.id,
          status: 'open',
          descriptionOfWork: 'Test',
        ));
        final woId = (createResult as Ok<int>).value;

        final result = await workOrderService.addNote(AddWorkOrderNote(
          workOrderId: woId,
          noteText: 'Technician arrived on site',
          noteType: 'general',
        ));

        expect(result, isA<Ok<int>>());
      });
    });
  });
}
