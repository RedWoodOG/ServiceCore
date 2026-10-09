import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../util/app_paths.dart';

part 'app_database.g.dart';

// ============================================
// TABLE DEFINITIONS
// ============================================

// Clients table
class Clients extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get themeColor => text()(); // 'red', 'blue', 'yellow'
}

// Sites table
class Sites extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clientId => integer().references(Clients, #id)();
  TextColumn get branchName => text()();
  TextColumn get address => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get region => text()();
}

// Starting Points table
class StartingPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
}

// Users table
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().unique()();
  TextColumn get fullName => text()();
  TextColumn get email => text()();
  TextColumn get role => text()(); // 'admin', 'tech'

  // V3 Additions
  TextColumn get password => text().withDefault(const Constant(''))();
  DateTimeColumn get dateOfBirth => dateTime().nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get phoneNumber => text().nullable()();
  TextColumn get bio => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // PHASE 2: Security & Authentication
  TextColumn get windowsSid => text().nullable()();
  DateTimeColumn get lastLoginAt => dateTime().nullable()();
  IntColumn get loginCount => integer().withDefault(const Constant(0))();
}

// Weather Snapshot table (for offline-first weather display)
class WeatherSnapshot extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get region => text()();
  IntColumn get temperature => integer()();
  TextColumn get condition => text()(); // 'Clear', 'Cloudy', etc.
  DateTimeColumn get fetchedAt => dateTime()();
  TextColumn get source => text()(); // 'api', 'fallback', etc.
  TextColumn get zipCode => text().nullable()(); // Added for auto-update
}

// Traffic Snapshot table (for offline-first traffic display)
class TrafficSnapshot extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get routeLabel => text()();
  IntColumn get etaMinutes => integer()();
  TextColumn get conditionLabel => text()(); // 'Light', 'Moderate', 'Heavy'
  DateTimeColumn get fetchedAt => dateTime()();
  TextColumn get source => text()();
}

// Work Calls table (for KPI cards)
class WorkCalls extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get status => text()(); // 'open', 'completed'
  DateTimeColumn get scheduledAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get workOrderNumber => text().nullable()();
}

// Industry Briefing table (for news feed)
class IndustryBriefing extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get source => text()();
  TextColumn get previewImage => text().nullable()();
  DateTimeColumn get publishedAt => dateTime()();
  DateTimeColumn get fetchedAt => dateTime()();
}

// Company Announcements table (for company feed)
class CompanyAnnouncements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()(); // 'hr', 'safety', 'fleet'
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get actionLabel => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get publishedAt => dateTime()();
  BoolColumn get acknowledged => boolean().withDefault(const Constant(false))();
  DateTimeColumn get acknowledgedAt => dateTime().nullable()();
}

// Operations Domain Model - Work Orders
class WorkOrders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get siteId => integer()(); // References Sites
  TextColumn get status => text()(); // 'open', 'on_hold', 'completed'
  TextColumn get priority => text().nullable()();
  TextColumn get descriptionOfWork => text().nullable()();
  TextColumn get internalNotes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get closedAt => dateTime().nullable()();
  TextColumn get createdBy => text().nullable()();
  TextColumn get assignedTechnician => text().nullable()();

  // PHASE 1 ADDITIONS - Work Order Enhancement
  // Completion tracking
  TextColumn get completionNotes => text().nullable()();
  TextColumn get resolution => text().nullable()();
  BoolColumn get repeatIssue => boolean().withDefault(const Constant(false))();

  // Audit trail
  TextColumn get previousStatus => text().nullable()();
  IntColumn get statusChangedBy => integer().nullable()();
  DateTimeColumn get statusChangedAt => dateTime().nullable()();

  // Workflow
  TextColumn get workflowState => text().withDefault(const Constant('draft'))();
  TextColumn get approvalStatus => text().nullable()();
  IntColumn get approvedBy => integer().nullable()();
  DateTimeColumn get approvedAt => dateTime().nullable()();

  // Optimistic locking
  IntColumn get version => integer().withDefault(const Constant(1))();

  // PHASE 3: Time Tracking & Service Documentation
  // Scheduling
  DateTimeColumn get expectedDate => dateTime().nullable()();
  IntColumn get expectedDurationMinutes => integer().nullable()();

  // Contact Information
  TextColumn get contactPerson => text().nullable()();
  TextColumn get contactPhone => text().nullable()();
  TextColumn get contactEmail => text().nullable()();

  // Billing (optional - shown only when needed)
  TextColumn get billingContactName => text().nullable()();
  TextColumn get billingContactEmail => text().nullable()();
  TextColumn get billingAddress => text().nullable()();

  // Account Numbers (optional dropdowns)
  TextColumn get copsAccount => text().nullable()();
  TextColumn get cmsAccount => text().nullable()();
  TextColumn get alarmNetAccount => text().nullable()();
  TextColumn get ictAccount => text().nullable()();
  TextColumn get alarmDotComAccount => text().nullable()();
  TextColumn get telguardAccount => text().nullable()();
  TextColumn get openEyeLicense => text().nullable()();

  // Service Contract
  BoolColumn get onServiceContract =>
      boolean().withDefault(const Constant(false))();
  TextColumn get contractType => text().nullable()(); // e.g., 'client_standard'

  // Reference/PO
  TextColumn get referenceNumber => text().nullable()();
  TextColumn get poNumber => text().nullable()();
}

// Appointments - Scheduled time blocks for work orders
class Appointments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workOrderId => integer()(); // References WorkOrders
  DateTimeColumn get scheduledStart => dateTime()();
  IntColumn get expectedDurationMinutes => integer().nullable()();
  TextColumn get technician => text().nullable()();
}

// Equipment - Installed equipment at sites with serial numbers
class Equipment extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get siteId => integer()(); // References Sites
  TextColumn get equipmentType =>
      text()(); // 'counter', 'atm', 'dvr', 'lock', etc
  TextColumn get manufacturer => text().nullable()();
  TextColumn get model => text().nullable()();
  TextColumn get serialNumber => text().nullable()();
  BoolColumn get underWarranty =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get underServiceContract =>
      boolean().withDefault(const Constant(false))();
  TextColumn get contractReference => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}

// Work Order Equipment - Junction table for equipment involved in work orders
class WorkOrderEquipment extends Table {
  IntColumn get workOrderId => integer()(); // References WorkOrders
  IntColumn get equipmentId => integer()(); // References Equipment

  @override
  Set<Column> get primaryKey => {workOrderId, equipmentId};
}

// Work Performed - Actual technician work logs (historical record)
class WorkPerformed extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workOrderId => integer()(); // References WorkOrders
  IntColumn get equipmentId => integer().nullable()(); // References Equipment
  TextColumn get technician => text()();
  DateTimeColumn get startedAt => dateTime()();
  IntColumn get durationMinutes => integer().nullable()();
  TextColumn get workDescription => text().nullable()();
  TextColumn get resolution => text().nullable()();
  BoolColumn get repeatIssue => boolean().withDefault(const Constant(false))();
}

// Parts Used - Parts consumed during work
class PartsUsed extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workPerformedId => integer()(); // References WorkPerformed
  TextColumn get partNumber => text().nullable()();
  TextColumn get description => text().nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
}

// Notes - POIs, warnings, internal notes
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get siteId => integer()(); // References Sites
  IntColumn get workOrderId => integer().nullable()(); // References WorkOrders
  TextColumn get noteType => text()(); // 'poi', 'warning', 'general'
  TextColumn get noteText => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get createdBy => text().nullable()();
}

// Documents - Attachments tied to work orders
class Documents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workOrderId =>
      integer().nullable()(); // Made nullable to allow Site docs
  IntColumn get siteId =>
      integer().nullable()(); // [NEW] Link docs to Sites (SAS)
  TextColumn get fileName => text()();
  TextColumn get filePath => text()();
  DateTimeColumn get uploadedAt => dateTime()();
  TextColumn get uploadedBy => text().nullable()();
}

// Knowledge Entries - Read-only reference content from Markdown files
class KnowledgeEntries extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get category => text()();
  TextColumn get equipmentType => text()();
  TextColumn get equipmentModel => text().nullable()();
  TextColumn get content => text()();
  TextColumn get sourceType => text()();
  TextColumn get sourceFile => text()();
  TextColumn get version => text()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  // V15: Enhanced technical knowledge base
  TextColumn get contentType => text().withDefault(const Constant(
      'reference'))(); // procedure, troubleshooting, specification, howto, reference, safety
  TextColumn get difficulty =>
      text().nullable()(); // beginner, intermediate, advanced
  IntColumn get estimatedTime => integer().nullable()(); // minutes
  TextColumn get keywords => text()
      .withDefault(const Constant(''))(); // comma-separated search keywords
  TextColumn get summary =>
      text().nullable()(); // short description for quick answers
  TextColumn get preconditions =>
      text().withDefault(const Constant('[]'))(); // JSON array of prerequisites
  TextColumn get tags =>
      text().withDefault(const Constant('[]'))(); // JSON array for filtering
  DateTimeColumn get lastReviewedAt =>
      dateTime().nullable()(); // audit trail for accuracy
  BoolColumn get isDeprecated => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================
// V15: ENHANCED KNOWLEDGE BASE TABLES
// ============================================

// Knowledge Procedures - Step-by-step instructions
class KnowledgeProcedures extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get knowledgeEntryId => text().references(KnowledgeEntries, #id)();
  IntColumn get stepNumber => integer()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get warnings =>
      text().withDefault(const Constant('[]'))(); // JSON array of cautions
  TextColumn get expectedResult => text().nullable()();
  TextColumn get commonMistakes => text().nullable()();
}

// Knowledge Troubleshooting - Diagnostic content
class KnowledgeTroubleshooting extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get knowledgeEntryId => text().references(KnowledgeEntries, #id)();
  TextColumn get symptom => text()(); // What the user observes
  TextColumn get rootCause => text()();
  TextColumn get diagnosticSteps =>
      text().withDefault(const Constant('[]'))(); // JSON array
  TextColumn get resolution => text()();
  TextColumn get preventionTips => text().nullable()();
  TextColumn get relatedIssues => text()
      .withDefault(const Constant('[]'))(); // JSON array of related issue IDs
}

// Equipment Specifications - Detailed hardware info
class EquipmentSpecs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get knowledgeEntryId => text().references(KnowledgeEntries, #id)();
  TextColumn get equipmentType => text()();
  TextColumn get manufacturer => text().nullable()();
  TextColumn get model => text()();
  TextColumn get serialNumberPattern =>
      text().nullable()(); // Regex for validation
  TextColumn get specifications => text().withDefault(
      const Constant('{}'))(); // JSON (voltage, dimensions, weight, etc.)
  TextColumn get compatibility => text().withDefault(
      const Constant('[]'))(); // JSON array of compatible parts/versions
  DateTimeColumn get eolDate => dateTime().nullable()(); // End of life date
  TextColumn get supportUrl => text().nullable()();
}

// Knowledge Relationships - Link related content
class KnowledgeRelationships extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fromEntryId => text().references(KnowledgeEntries, #id)();
  TextColumn get toEntryId => text().references(KnowledgeEntries, #id)();
  TextColumn get relationshipType =>
      text()(); // prerequisite, related, alternative, deeperdive, seeAlso
  TextColumn get description => text().nullable()();
}

// Knowledge Search Index - Semantic search support
class KnowledgeSearchIndex extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get knowledgeEntryId => text().references(KnowledgeEntries, #id)();
  TextColumn get queryVariation => text()(); // Different ways to ask for this
  TextColumn get synonyms => text()
      .withDefault(const Constant('[]'))(); // JSON array of alternative terms
  TextColumn get context => text().nullable()(); // When this applies
  RealColumn get weight =>
      real().withDefault(const Constant(1.0))(); // Search result ranking weight
}

// Knowledge Query Log - Learning from user queries
class KnowledgeQueryLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get query => text()();
  TextColumn get matchedEntryId =>
      text().nullable().references(KnowledgeEntries, #id)();
  BoolColumn get wasHelpful => boolean().nullable()();
  IntColumn get timeSpentSeconds => integer().nullable()();
  DateTimeColumn get queriedAt => dateTime()();
  IntColumn get userId => integer().nullable()();
}

// Chat Channels - Offline-first messaging channels
class ChatChannels extends Table {
  TextColumn get id => text()(); // 'general', 'site_123', etc.
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Chat Messages - Offline-first messages
class ChatMessages extends Table {
  TextColumn get id => text()();
  TextColumn get channelId => text().references(ChatChannels, #id)();
  TextColumn get senderId => text()();
  TextColumn get senderName => text().nullable()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get attachmentsJson => text().withDefault(const Constant('[]'))();
  TextColumn get reactionsJson => text().withDefault(const Constant('{}'))();

  // Status tracking for offline sync
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// Continuing Education Courses
class ContinuingEducationCourses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get provider => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category =>
      text()(); // 'Technical', 'Safety', 'Compliance', 'HR'
  IntColumn get durationHours => integer().nullable()();
  TextColumn get externalUrl => text().nullable()();
}

// User Course Enrollments
class UserCourseEnrollments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  IntColumn get courseId => integer()();
  DateTimeColumn get enrolledAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get status => text()(); // 'enrolled', 'in_progress', 'completed'
}

// Expenses
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer()();
  DateTimeColumn get expenseDate => dateTime()();
  TextColumn get category =>
      text()(); // 'fuel', 'tolls', 'parking', 'meals', 'parts', 'other'
  RealColumn get amount => real()();
  TextColumn get description => text().nullable()();
  TextColumn get receiptPath => text().nullable()();
  IntColumn get workOrderId => integer().nullable()();
}

// PHASE 1: Work Order Audit Log
class WorkOrderAuditLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workOrderId => integer()();
  IntColumn get userId => integer()();
  TextColumn get action =>
      text()(); // 'create', 'update', 'status_change', 'complete', 'delete'
  TextColumn get fieldChanged => text().nullable()();
  TextColumn get oldValue => text().nullable()();
  TextColumn get newValue => text().nullable()();
  TextColumn get changeReason => text().nullable()();
  TextColumn get ipAddress => text().nullable()(); // Future: when online
  DateTimeColumn get changedAt => dateTime().withDefault(currentDateAndTime)();
}

// PHASE 1: Work Order Status Transitions
class WorkOrderStatusTransitions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workOrderId => integer()();
  TextColumn get fromStatus => text()();
  TextColumn get toStatus => text()();
  IntColumn get changedBy => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get transitionedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// PHASE 2: Provenance Log (MKPE - Truth Protection)
class ProvenanceLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get recordType => text()(); // 'work_order', 'knowledge_entry', etc
  IntColumn get recordId => integer()();
  TextColumn get action => text()(); // 'create', 'update', 'delete'
  TextColumn get contentHash => text()(); // SHA-256 hash
  TextColumn get previousHash =>
      text().nullable()(); // Chain link for integrity
  TextColumn get userSid => text()(); // Windows SID
  TextColumn get userName => text()(); // Display name
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  TextColumn get changeMetadata => text().nullable()(); // JSON metadata
}

// PHASE 2: Encryption Key Store (for backup/recovery)
class EncryptionKeyStore extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get keyPurpose => text()(); // 'database', 'export', etc
  TextColumn get encryptedKey => text()(); // Encrypted with master key
  TextColumn get keyFingerprint =>
      text()(); // SHA-256 of key (for verification)
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastAccessedAt => dateTime().nullable()();
  IntColumn get accessCount => integer().withDefault(const Constant(0))();
}

// ============================================
// DATABASE CLASS
// ============================================

@DriftDatabase(
  tables: [
    Clients,
    Sites,
    StartingPoints,
    Users,
    WeatherSnapshot,
    TrafficSnapshot,
    WorkCalls,
    IndustryBriefing,
    CompanyAnnouncements,
    WorkOrders,
    Appointments,
    Equipment,
    WorkOrderEquipment,
    WorkPerformed,
    PartsUsed,
    Notes,
    Documents,
    KnowledgeEntries,
    KnowledgeProcedures,
    KnowledgeTroubleshooting,
    EquipmentSpecs,
    KnowledgeRelationships,
    KnowledgeSearchIndex,
    KnowledgeQueryLog,
    ChatChannels,
    ChatMessages,
    ContinuingEducationCourses,
    UserCourseEnrollments,
    Expenses,
    WorkOrderAuditLog,
    WorkOrderStatusTransitions,
    ProvenanceLog,
    EncryptionKeyStore,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Testing constructor
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 15;

  // Migration Strategy
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(users);
          }
          if (from < 3) {
            await m.addColumn(users, users.password);
            await m.addColumn(users, users.dateOfBirth);
            await m.addColumn(users, users.location);
            await m.addColumn(users, users.phoneNumber);
            await m.addColumn(users, users.bio);
          }
          if (from < 4) {
            await m.createTable(weatherSnapshot);
            await m.createTable(trafficSnapshot);
            await m.createTable(workCalls);
            await m.createTable(industryBriefing);
            await m.createTable(companyAnnouncements);
          }
          if (from < 5) {
            await m.createTable(workOrders);
            await m.createTable(appointments);
            await m.createTable(equipment);
            await m.createTable(workOrderEquipment);
            await m.createTable(workPerformed);
            await m.createTable(partsUsed);
            await m.createTable(notes);
            await m.createTable(documents);
          }
          if (from < 6) {
            await m.createTable(knowledgeEntries);
          }
          if (from < 7) {
            await m.createTable(chatChannels);
            await m.createTable(chatMessages);
          }
          if (from < 11) {
            // V11: Add Continuing Education and Expenses tables
            await m.createTable(continuingEducationCourses);
            await m.createTable(userCourseEnrollments);
            await m.createTable(expenses);
          }
          if (from < 12) {
            // V12: Work Order Enhancement - Add new columns to WorkOrders
            await m.addColumn(workOrders, workOrders.completionNotes);
            await m.addColumn(workOrders, workOrders.resolution);
            await m.addColumn(workOrders, workOrders.repeatIssue);
            await m.addColumn(workOrders, workOrders.previousStatus);
            await m.addColumn(workOrders, workOrders.statusChangedBy);
            await m.addColumn(workOrders, workOrders.statusChangedAt);
            await m.addColumn(workOrders, workOrders.workflowState);
            await m.addColumn(workOrders, workOrders.approvalStatus);
            await m.addColumn(workOrders, workOrders.approvedBy);
            await m.addColumn(workOrders, workOrders.approvedAt);
            await m.addColumn(workOrders, workOrders.version);

            // Create new audit tables
            await m.createTable(workOrderAuditLog);
            await m.createTable(workOrderStatusTransitions);

            // Create indexes for performance
            await m.database.customStatement(
              'CREATE INDEX idx_wo_status ON work_orders(status)',
            );
            await m.database.customStatement(
              'CREATE INDEX idx_wo_assigned ON work_orders(assigned_technician)',
            );
            await m.database.customStatement(
              'CREATE INDEX idx_wo_workflow ON work_orders(workflow_state)',
            );
          }
          if (from < 13) {
            // V13: Security Architecture - Windows Auth & MKPE Provenance

            // Add security columns to Users table (nullable, no unique constraint)
            await m.addColumn(users, users.windowsSid);
            await m.addColumn(users, users.lastLoginAt);
            await m.addColumn(users, users.loginCount);

            // Create provenance log table
            await m.createTable(provenanceLog);

            // Create encryption key store table
            await m.createTable(encryptionKeyStore);

            // Create indexes for provenance queries
            await m.database.customStatement(
              'CREATE INDEX idx_prov_record ON provenance_log(record_type, record_id)',
            );
            await m.database.customStatement(
              'CREATE INDEX idx_prov_user ON provenance_log(user_sid)',
            );
            await m.database.customStatement(
              'CREATE INDEX idx_prov_timestamp ON provenance_log(timestamp)',
            );

            // Create index on windowsSid for fast lookups (instead of UNIQUE constraint)
            await m.database.customStatement(
              'CREATE INDEX idx_users_sid ON users(windows_sid)',
            );
          }
          if (from < 14) {
            // V14: Phase 3 - Time Tracking & Service Documentation
            // Add scheduling fields
            await m.addColumn(workOrders, workOrders.expectedDate);
            await m.addColumn(workOrders, workOrders.expectedDurationMinutes);

            // Add contact information fields
            await m.addColumn(workOrders, workOrders.contactPerson);
            await m.addColumn(workOrders, workOrders.contactPhone);
            await m.addColumn(workOrders, workOrders.contactEmail);

            // Add billing fields (optional)
            await m.addColumn(workOrders, workOrders.billingContactName);
            await m.addColumn(workOrders, workOrders.billingContactEmail);
            await m.addColumn(workOrders, workOrders.billingAddress);

            // Add account number fields (optional)
            await m.addColumn(workOrders, workOrders.copsAccount);
            await m.addColumn(workOrders, workOrders.cmsAccount);
            await m.addColumn(workOrders, workOrders.alarmNetAccount);
            await m.addColumn(workOrders, workOrders.ictAccount);
            await m.addColumn(workOrders, workOrders.alarmDotComAccount);
            await m.addColumn(workOrders, workOrders.telguardAccount);
            await m.addColumn(workOrders, workOrders.openEyeLicense);

            // Add service contract fields
            await m.addColumn(workOrders, workOrders.onServiceContract);
            await m.addColumn(workOrders, workOrders.contractType);

            // Add reference/PO fields
            await m.addColumn(workOrders, workOrders.referenceNumber);
            await m.addColumn(workOrders, workOrders.poNumber);
          }
          if (from < 15) {
            // V15: Enhanced Technical Knowledge Base
            // Add new fields to KnowledgeEntries
            await m.addColumn(knowledgeEntries, knowledgeEntries.contentType);
            await m.addColumn(knowledgeEntries, knowledgeEntries.difficulty);
            await m.addColumn(knowledgeEntries, knowledgeEntries.estimatedTime);
            await m.addColumn(knowledgeEntries, knowledgeEntries.keywords);
            await m.addColumn(knowledgeEntries, knowledgeEntries.summary);
            await m.addColumn(knowledgeEntries, knowledgeEntries.preconditions);
            await m.addColumn(knowledgeEntries, knowledgeEntries.tags);
            await m.addColumn(
                knowledgeEntries, knowledgeEntries.lastReviewedAt);
            await m.addColumn(knowledgeEntries, knowledgeEntries.isDeprecated);

            // Create new knowledge base tables
            await m.createTable(knowledgeProcedures);
            await m.createTable(knowledgeTroubleshooting);
            await m.createTable(equipmentSpecs);
            await m.createTable(knowledgeRelationships);
            await m.createTable(knowledgeSearchIndex);
            await m.createTable(knowledgeQueryLog);

            // Create indexes for performance
            await m.database.customStatement(
              'CREATE INDEX idx_knowledge_content_type ON knowledge_entries(content_type)',
            );
            await m.database.customStatement(
              'CREATE INDEX idx_knowledge_keywords ON knowledge_entries(keywords)',
            );
            await m.database.customStatement(
              'CREATE INDEX idx_procedures_entry ON knowledge_procedures(knowledge_entry_id)',
            );
            await m.database.customStatement(
              'CREATE INDEX idx_troubleshooting_entry ON knowledge_troubleshooting(knowledge_entry_id)',
            );
            await m.database.customStatement(
              'CREATE INDEX idx_equipment_specs_entry ON equipment_specs(knowledge_entry_id)',
            );
            await m.database.customStatement(
              'CREATE INDEX idx_relationships ON knowledge_relationships(from_entry_id, to_entry_id)',
            );
            await m.database.customStatement(
              'CREATE INDEX idx_search_index_entry ON knowledge_search_index(knowledge_entry_id)',
            );
            await m.database.customStatement(
              'CREATE INDEX idx_query_log_entry ON knowledge_query_log(matched_entry_id)',
            );
          }
        },
      );

  // ============================================
  // CLIENT QUERIES
  // ============================================

  Future<List<Client>> getAllClients() => select(clients).get();

  Future<Client?> getClientById(int id) =>
      (select(clients)..where((c) => c.id.equals(id))).getSingleOrNull();

  // ============================================
  // SITE QUERIES
  // ============================================

  Future<List<Site>> getAllSites() => select(sites).get();

  Future<List<Site>> getSitesByClient(int clientId) =>
      (select(sites)..where((s) => s.clientId.equals(clientId))).get();

  Future<Site?> getSiteById(int id) =>
      (select(sites)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<List<StartingPoint>> getAllStartingPoints() =>
      select(startingPoints).get();

  // ============================================
  // USER QUERIES
  // ============================================

  Future<List<User>> getAllUsers() => select(users).get();

  Future<User?> getUserById(int id) =>
      (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();

  Future<User?> getUserByUsername(String username) => (select(
        users,
      )..where((u) => u.username.equals(username)))
          .getSingleOrNull();

  Stream<List<User>> watchAllUsers() =>
      (select(users)..orderBy([(t) => OrderingTerm.asc(t.fullName)])).watch();

  Future<void> updateUser(UsersCompanion user) =>
      (update(users)..where((u) => u.id.equals(user.id.value))).write(user);

  // PHASE 2: Security queries
  Future<User?> getUserBySID(String sid) =>
      (select(users)..where((u) => u.windowsSid.equals(sid))).getSingleOrNull();

  // ============================================
  // WEATHER QUERIES
  // ============================================

  Future<WeatherSnapshotData?> getLatestWeather() => (select(weatherSnapshot)
        ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
        ..limit(1))
      .getSingleOrNull();

  Stream<WeatherSnapshotData?> watchLatestWeather() => (select(weatherSnapshot)
        ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
        ..limit(1))
      .watchSingleOrNull();

  Future<void> insertWeather(WeatherSnapshotCompanion weather) =>
      into(weatherSnapshot).insert(weather, mode: InsertMode.replace);

  // ============================================
  // TRAFFIC QUERIES
  // ============================================

  Future<TrafficSnapshotData?> getLatestTraffic() => (select(trafficSnapshot)
        ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
        ..limit(1))
      .getSingleOrNull();

  Future<void> insertTraffic(TrafficSnapshotCompanion traffic) =>
      into(trafficSnapshot).insert(traffic, mode: InsertMode.replace);

  // ============================================
  // WORK CALLS QUERIES
  // ============================================

  Future<int> getOpenCallsCount() => (select(
        workCalls,
      )..where((w) => w.status.equals('open')))
          .get()
          .then((calls) => calls.length);

  Future<int> getCompletedCallsCount() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return (select(workCalls)
          ..where(
            (w) =>
                w.status.equals('completed') &
                w.completedAt.isBiggerThanValue(startOfDay),
          ))
        .get()
        .then((calls) => calls.length);
  }

  Future<int> getWeeklyCallsCount() {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return (select(workCalls)
          ..where(
            (w) =>
                w.status.equals('completed') &
                w.completedAt.isBiggerThanValue(weekAgo),
          ))
        .get()
        .then((calls) => calls.length);
  }

  Stream<int> watchOpenCallsCount() {
    return watchWorkCalls().map((calls) {
      return calls.where((c) => c.status == 'open').length;
    });
  }

  Stream<int> watchCompletedCallsCount() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return watchWorkCalls().map((calls) {
      return calls
          .where(
            (c) =>
                c.status == 'completed' &&
                c.completedAt != null &&
                c.completedAt!.isAfter(startOfDay),
          )
          .length;
    });
  }

  Stream<int> watchWeeklyCallsCount() {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return watchWorkCalls().map((calls) {
      return calls
          .where(
            (c) =>
                c.status == 'completed' &&
                c.completedAt != null &&
                c.completedAt!.isAfter(weekAgo),
          )
          .length;
    });
  }

  Future<void> insertWorkCall(WorkCallsCompanion workCall) =>
      into(workCalls).insert(workCall);

  Stream<List<WorkCall>> watchWorkCalls() => (select(
        workCalls,
      )..orderBy([(t) => OrderingTerm.desc(t.scheduledAt)]))
          .watch();

  // ============================================
  // INDUSTRY BRIEFING QUERIES
  // ============================================

  Future<List<IndustryBriefingData>> getLatestIndustryBriefing({
    int limit = 5,
  }) =>
      (select(industryBriefing)
            ..orderBy([(t) => OrderingTerm.desc(t.publishedAt)])
            ..limit(limit))
          .get();

  Stream<List<IndustryBriefingData>> watchLatestIndustryBriefing({
    int limit = 5,
  }) =>
      (select(industryBriefing)
            ..orderBy([(t) => OrderingTerm.desc(t.publishedAt)])
            ..limit(limit))
          .watch();

  Future<void> insertIndustryBriefing(IndustryBriefingCompanion briefing) =>
      into(industryBriefing).insert(briefing);

  // ============================================
  // COMPANY ANNOUNCEMENTS QUERIES
  // ============================================

  Stream<List<CompanyAnnouncement>> watchActiveCompanyAnnouncements() =>
      (select(companyAnnouncements)
            ..where((a) => a.active.equals(true))
            ..orderBy([(t) => OrderingTerm.desc(t.publishedAt)]))
          .watch();

  Future<List<CompanyAnnouncement>> getActiveCompanyAnnouncements() =>
      (select(companyAnnouncements)
            ..where((a) => a.active.equals(true))
            ..orderBy([(t) => OrderingTerm.desc(t.publishedAt)]))
          .get();

  Future<void> insertCompanyAnnouncement(
    CompanyAnnouncementsCompanion announcement,
  ) =>
      into(companyAnnouncements).insert(announcement);

  Future<void> updateAnnouncementAcknowledged(int id, bool acknowledged) =>
      (update(companyAnnouncements)..where((a) => a.id.equals(id))).write(
        CompanyAnnouncementsCompanion(
          acknowledged: Value(acknowledged),
          acknowledgedAt: Value(acknowledged ? DateTime.now() : null),
        ),
      );

  // ============================================
  // WORK ORDERS QUERIES
  // ============================================

  Future<List<WorkOrderWithDetails>> getWorkOrdersWithDetails({
    String? statusFilter,
  }) async {
    final query = select(workOrders)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

    if (statusFilter != null && statusFilter != 'all') {
      query.where((w) => w.status.equals(statusFilter));
    }

    final orders = await query.get();
    if (orders.isEmpty) return [];

    // Batch fetch all sites in one query
    final siteIds = orders.map((o) => o.siteId).toSet().toList();
    final sitesResult =
        await (select(sites)..where((s) => s.id.isIn(siteIds))).get();
    final sitesMap = {for (final s in sitesResult) s.id: s};

    // Batch fetch all clients in one query
    final clientIds = sitesResult.map((s) => s.clientId).toSet().toList();
    final clientsResult =
        await (select(clients)..where((c) => c.id.isIn(clientIds))).get();
    final clientsMap = {for (final c in clientsResult) c.id: c};

    // Batch fetch all equipment links in one query
    final orderIds = orders.map((o) => o.id).toList();
    final equipmentLinks = await (select(workOrderEquipment)
          ..where((w) => w.workOrderId.isIn(orderIds)))
        .get();
    final equipmentIds =
        equipmentLinks.map((l) => l.equipmentId).toSet().toList();
    final equipmentResult = equipmentIds.isEmpty
        ? <EquipmentData>[]
        : await (select(equipment)..where((e) => e.id.isIn(equipmentIds)))
            .get();
    final equipmentMap = {for (final e in equipmentResult) e.id: e};

    // Build equipment-per-order lookup
    final orderEquipmentMap = <int, List<EquipmentData>>{};
    for (final link in equipmentLinks) {
      final eq = equipmentMap[link.equipmentId];
      if (eq != null) {
        orderEquipmentMap.putIfAbsent(link.workOrderId, () => []).add(eq);
      }
    }

    // Build results
    final results = <WorkOrderWithDetails>[];
    for (final order in orders) {
      final site = sitesMap[order.siteId];
      if (site == null) continue;

      final client = clientsMap[site.clientId];
      if (client == null) continue;

      results.add(
        WorkOrderWithDetails(
          workOrder: order,
          site: site,
          client: client,
          equipment: orderEquipmentMap[order.id] ?? [],
        ),
      );
    }

    return results;
  }

  Future<void> insertWorkOrder(WorkOrdersCompanion workOrder) =>
      into(workOrders).insert(workOrder);

  Future<WorkOrder?> getWorkOrderById(int id) =>
      (select(workOrders)..where((w) => w.id.equals(id))).getSingleOrNull();

  Future<List<WorkOrder>> getAllWorkOrders() => (select(
        workOrders,
      )..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<WorkOrder>> getWorkOrdersBySite(int siteId) => (select(workOrders)
        ..where((w) => w.siteId.equals(siteId))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .get();

  Future<List<WorkOrder>> getWorkOrdersPaged({
    required int limit,
    required int offset,
    String? status,
  }) {
    final query = select(workOrders)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(limit, offset: offset);

    if (status != null && status != 'all') {
      query.where((w) => w.status.equals(status));
    }

    return query.get();
  }

  Future<List<WorkOrderWithDetails>> getWorkOrdersWithDetailsPaged({
    required int limit,
    required int offset,
    String? status,
  }) async {
    final orders = await getWorkOrdersPaged(
      limit: limit,
      offset: offset,
      status: status,
    );
    if (orders.isEmpty) return [];

    // Batch fetch all sites in one query
    final siteIds = orders.map((o) => o.siteId).toSet().toList();
    final sitesResult =
        await (select(sites)..where((s) => s.id.isIn(siteIds))).get();
    final sitesMap = {for (final s in sitesResult) s.id: s};

    // Batch fetch all clients in one query
    final clientIds = sitesResult.map((s) => s.clientId).toSet().toList();
    final clientsResult =
        await (select(clients)..where((c) => c.id.isIn(clientIds))).get();
    final clientsMap = {for (final c in clientsResult) c.id: c};

    // Batch fetch all equipment links in one query
    final orderIds = orders.map((o) => o.id).toList();
    final equipmentLinks = await (select(workOrderEquipment)
          ..where((w) => w.workOrderId.isIn(orderIds)))
        .get();
    final equipmentIds =
        equipmentLinks.map((l) => l.equipmentId).toSet().toList();
    final equipmentResult = equipmentIds.isEmpty
        ? <EquipmentData>[]
        : await (select(equipment)..where((e) => e.id.isIn(equipmentIds)))
            .get();
    final equipmentMap = {for (final e in equipmentResult) e.id: e};

    // Build equipment-per-order lookup
    final orderEquipmentMap = <int, List<EquipmentData>>{};
    for (final link in equipmentLinks) {
      final eq = equipmentMap[link.equipmentId];
      if (eq != null) {
        orderEquipmentMap.putIfAbsent(link.workOrderId, () => []).add(eq);
      }
    }

    // Build results
    final results = <WorkOrderWithDetails>[];
    for (final order in orders) {
      final site = sitesMap[order.siteId];
      if (site == null) continue;

      final client = clientsMap[site.clientId];
      if (client == null) continue;

      results.add(
        WorkOrderWithDetails(
          workOrder: order,
          site: site,
          client: client,
          equipment: orderEquipmentMap[order.id] ?? [],
        ),
      );
    }

    return results;
  }

  Future<void> linkEquipmentToWorkOrder(int workOrderId, int equipmentId) =>
      into(workOrderEquipment).insert(
        WorkOrderEquipmentCompanion.insert(
          workOrderId: workOrderId,
          equipmentId: equipmentId,
        ),
      );

  // ============================================
  // PHASE 1: ENHANCED WORK ORDER QUERIES
  // ============================================

  /// Update work order with optimistic locking
  Future<bool> updateWorkOrderWithLock(WorkOrdersCompanion workOrder) async {
    final updated = await (update(workOrders)
          ..where(
            (wo) =>
                wo.id.equals(workOrder.id.value) &
                wo.version.equals(workOrder.version.value),
          ))
        .write(
      workOrder.copyWith(version: Value(workOrder.version.value + 1)),
    );

    return updated > 0;
  }

  /// Watch work orders by status with reactive updates
  Stream<List<WorkOrder>> watchWorkOrdersByStatus(String status) =>
      (select(workOrders)
            ..where((wo) => wo.status.equals(status))
            ..orderBy([(wo) => OrderingTerm.desc(wo.createdAt)]))
          .watch();

  /// Watch work orders assigned to technician
  Stream<List<WorkOrder>> watchWorkOrdersByTechnician(String technician) =>
      (select(workOrders)
            ..where((wo) => wo.assignedTechnician.equals(technician))
            ..orderBy([(wo) => OrderingTerm.desc(wo.createdAt)]))
          .watch();

  /// Get work orders requiring approval
  Future<List<WorkOrder>> getWorkOrdersRequiringApproval() =>
      (select(workOrders)
            ..where(
              (wo) =>
                  wo.approvalStatus.equals('pending') |
                  wo.approvalStatus.isNull(),
            ))
          .get();

  /// Search work orders with full-text search
  Future<List<WorkOrder>> searchWorkOrders(String query) {
    final lowerQuery = query.toLowerCase();
    return (select(workOrders)
          ..where(
            (wo) =>
                wo.descriptionOfWork.lower().contains(lowerQuery) |
                wo.internalNotes.lower().contains(lowerQuery) |
                wo.resolution.lower().contains(lowerQuery),
          )
          ..orderBy([(wo) => OrderingTerm.desc(wo.createdAt)]))
        .get();
  }

  /// Get audit log for work order
  Future<List<WorkOrderAuditLogData>> getWorkOrderAuditLog(int workOrderId) =>
      (select(workOrderAuditLog)
            ..where((log) => log.workOrderId.equals(workOrderId))
            ..orderBy([(log) => OrderingTerm.desc(log.changedAt)]))
          .get();

  /// Get status transition history for work order
  Future<List<WorkOrderStatusTransition>> getWorkOrderStatusTransitions(
    int workOrderId,
  ) =>
      (select(workOrderStatusTransitions)
            ..where((t) => t.workOrderId.equals(workOrderId))
            ..orderBy([(t) => OrderingTerm.desc(t.transitionedAt)]))
          .get();

  /// Batch operations for performance
  Future<void> batchUpdateWorkOrderStatus(
    List<int> workOrderIds,
    String newStatus,
    int userId,
  ) async {
    await transaction(() async {
      for (final id in workOrderIds) {
        final wo = await getWorkOrderById(id);
        if (wo != null) {
          await update(workOrders).replace(
            wo.copyWith(
              status: newStatus,
              statusChangedBy: Value(userId),
              statusChangedAt: Value(DateTime.now()),
              version: wo.version + 1,
            ),
          );
        }
      }
    });
  }

  /// Watch parts used for a work order
  Future<List<PartsUsedData>> watchPartsUsedForWorkOrder(
    int workOrderId,
  ) async {
    // First get work performed entries for this work order
    final workPerformedEntries = await (select(
      workPerformed,
    )..where((wp) => wp.workOrderId.equals(workOrderId)))
        .get();

    if (workPerformedEntries.isEmpty) return [];

    // Get parts for all work performed entries
    final workPerformedIds = workPerformedEntries.map((wp) => wp.id).toList();
    return (select(
      partsUsed,
    )..where((p) => p.workPerformedId.isIn(workPerformedIds)))
        .get();
  }

  // ============================================
  // EQUIPMENT QUERIES
  // ============================================

  Future<List<EquipmentData>> getAllEquipment() => select(equipment).get();

  Stream<List<EquipmentData>> watchAllEquipment() => (select(
        equipment,
      )..orderBy([(t) => OrderingTerm.asc(t.equipmentType)]))
          .watch();

  Future<List<EquipmentData>> getEquipmentBySite(int siteId) =>
      (select(equipment)..where((e) => e.siteId.equals(siteId))).get();

  Future<List<EquipmentData>> getEquipmentByWorkOrder(int workOrderId) async {
    final equipmentIds = await (select(workOrderEquipment)
          ..where((w) => w.workOrderId.equals(workOrderId)))
        .get()
        .then((list) => list.map((e) => e.equipmentId).toList());

    if (equipmentIds.isEmpty) return [];

    return (select(equipment)..where((e) => e.id.isIn(equipmentIds))).get();
  }

  Stream<List<String>> watchDistinctEquipmentTypes() {
    return watchAllEquipment().map((equipment) {
      return equipment.map((e) => e.equipmentType).toSet().toList()..sort();
    });
  }

  Future<EquipmentData?> getEquipmentById(int id) =>
      (select(equipment)..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<EquipmentData?> getEquipmentBySerial(String serialNumber) => (select(
        equipment,
      )..where((e) => e.serialNumber.equals(serialNumber)))
          .getSingleOrNull();

  Future<List<WorkPerformedData>> getWorkPerformedByWorkOrder(
    int workOrderId,
  ) =>
      (select(workPerformed)
            ..where((w) => w.workOrderId.equals(workOrderId))
            ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
          .get();

  Future<List<WorkPerformedData>> getWorkPerformedBySite(int siteId) async {
    final workOrders = await getWorkOrdersBySite(siteId);
    final workOrderIds = workOrders.map((wo) => wo.id).toList();
    if (workOrderIds.isEmpty) return [];

    return (select(workPerformed)
          ..where((w) => w.workOrderId.isIn(workOrderIds))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
  }

  Future<List<Note>> getNotesByWorkOrder(int workOrderId) => (select(notes)
        ..where((n) => n.workOrderId.equals(workOrderId))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .get();

  // ============================================
  // APPOINTMENTS QUERIES
  // ============================================

  Future<List<Appointment>> getAppointmentsByWorkOrder(int workOrderId) =>
      (select(appointments)
            ..where((a) => a.workOrderId.equals(workOrderId))
            ..orderBy([(t) => OrderingTerm.asc(t.scheduledStart)]))
          .get();

  Future<void> insertAppointment(AppointmentsCompanion appointment) =>
      into(appointments).insert(appointment);

  // ============================================
  // DOCUMENTS QUERIES
  // ============================================

  Future<List<Document>> getDocumentsBySite(int siteId) => (select(documents)
        ..where((d) => d.siteId.equals(siteId))
        ..orderBy([(t) => OrderingTerm.desc(t.uploadedAt)]))
      .get();

  Future<void> insertDocument(DocumentsCompanion document) =>
      into(documents).insert(document);

  // ============================================
  // SITE UPDATE QUERIES
  // ============================================

  Future<void> updateSite(SitesCompanion site) =>
      (update(sites)..where((s) => s.id.equals(site.id.value))).write(site);

  // ============================================
  // KNOWLEDGE ENTRIES QUERIES
  // ============================================

  Future<List<KnowledgeEntry>> getAllKnowledgeEntries() => (select(
        knowledgeEntries,
      )..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .get();

  Future<List<KnowledgeEntry>> getKnowledgeEntriesByCategory(String category) =>
      (select(knowledgeEntries)
            ..where((k) => k.category.equals(category))
            ..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .get();

  Future<List<String>> getDistinctCategories() async {
    final entries = await getAllKnowledgeEntries();
    return entries.map((e) => e.category).toSet().toList()..sort();
  }

  Stream<List<KnowledgeEntry>> watchAllKnowledgeEntries() => (select(
        knowledgeEntries,
      )..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Stream<List<String>> watchDistinctCategories() {
    return watchAllKnowledgeEntries().map((entries) {
      return entries.map((e) => e.category).toSet().toList()..sort();
    });
  }

  Stream<List<String>> watchDistinctKnowledgeEquipmentTypes() {
    return watchAllKnowledgeEntries().map((entries) {
      return entries.map((e) => e.equipmentType).toSet().toList()..sort();
    });
  }

  // Returns a map of group name → entry count for the home view
  Stream<Map<String, int>> watchKnowledgeGroupCounts(
      {required bool byEquipment}) {
    return watchAllKnowledgeEntries().map((entries) {
      final counts = <String, int>{};
      for (final e in entries) {
        final key = byEquipment ? e.equipmentType : e.category;
        counts[key] = (counts[key] ?? 0) + 1;
      }
      return Map.fromEntries(
        counts.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      );
    });
  }

  Stream<List<KnowledgeEntry>> watchKnowledgeEntriesByCategory(
    String category,
  ) =>
      (select(knowledgeEntries)
            ..where((k) => k.category.equals(category))
            ..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .watch();

  Stream<List<KnowledgeEntry>> watchKnowledgeEntriesByEquipment(
    String equipmentType,
  ) =>
      (select(knowledgeEntries)
            ..where((k) => k.equipmentType.equals(equipmentType))
            ..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .watch();

  Future<List<KnowledgeEntry>> searchKnowledge(String keyword) {
    final lowerKeyword = keyword.toLowerCase();
    return (select(knowledgeEntries)
          ..where(
            (k) =>
                k.title.lower().contains(lowerKeyword) |
                k.content.lower().contains(lowerKeyword) |
                k.category.lower().contains(lowerKeyword) |
                k.equipmentType.lower().contains(lowerKeyword) |
                k.keywords.lower().contains(lowerKeyword),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.title)]))
        .get();
  }

  Future<KnowledgeEntry?> getKnowledgeByTitle(String title) => (select(
        knowledgeEntries,
      )..where((k) => k.title.equals(title)))
          .getSingleOrNull();

  Future<KnowledgeEntry?> getKnowledgeEntryById(String id) => (select(
        knowledgeEntries,
      )..where((k) => k.id.equals(id)))
          .getSingleOrNull();

  Future<void> insertOrReplaceKnowledge(KnowledgeEntriesCompanion entry) =>
      into(knowledgeEntries).insert(entry, mode: InsertMode.replace);

  Future<void> clearAllKnowledgeEntries() => delete(knowledgeEntries).go();

  // ============================================
  // V15: ENHANCED KNOWLEDGE BASE QUERIES
  // ============================================

  // Procedures queries
  Future<List<KnowledgeProcedure>> getProceduresByEntry(String entryId) =>
      (select(knowledgeProcedures)
            ..where((p) => p.knowledgeEntryId.equals(entryId))
            ..orderBy([(p) => OrderingTerm.asc(p.stepNumber)]))
          .get();

  Future<void> insertProcedure(KnowledgeProceduresCompanion procedure) =>
      into(knowledgeProcedures).insert(procedure);

  // Troubleshooting queries
  Future<KnowledgeTroubleshootingData?> getTroubleshootingByEntry(
    String entryId,
  ) =>
      (select(knowledgeTroubleshooting)
            ..where((t) => t.knowledgeEntryId.equals(entryId))
            ..limit(1))
          .getSingleOrNull();

  Future<KnowledgeTroubleshootingData?> searchTroubleshootingBySymptom(
    String symptom,
  ) {
    final lowerSymptom = symptom.toLowerCase();
    return (select(knowledgeTroubleshooting)
          ..where((t) => t.symptom.lower().contains(lowerSymptom))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> insertTroubleshooting(
    KnowledgeTroubleshootingCompanion troubleshooting,
  ) =>
      into(knowledgeTroubleshooting).insert(troubleshooting);

  // Equipment Specs queries
  Future<EquipmentSpec?> getEquipmentSpecsByEntry(String entryId) =>
      (select(equipmentSpecs)
            ..where((e) => e.knowledgeEntryId.equals(entryId))
            ..limit(1))
          .getSingleOrNull();

  Future<EquipmentSpec?> getEquipmentSpecsByModel(String model) =>
      (select(equipmentSpecs)
            ..where((e) => e.model.equals(model))
            ..limit(1))
          .getSingleOrNull();

  Future<void> insertEquipmentSpecs(
    EquipmentSpecsCompanion specs,
  ) =>
      into(equipmentSpecs).insert(specs);

  // Knowledge Relationships queries
  Future<List<KnowledgeRelationship>> getRelatedContent(String entryId) =>
      (select(knowledgeRelationships)
            ..where((r) => r.fromEntryId.equals(entryId)))
          .get();

  Future<List<KnowledgeRelationship>> getRelatedContentByType(
    String entryId,
    String relationshipType,
  ) =>
      (select(knowledgeRelationships)
            ..where(
              (r) =>
                  r.fromEntryId.equals(entryId) &
                  r.relationshipType.equals(relationshipType),
            ))
          .get();

  Future<void> insertRelationship(
    KnowledgeRelationshipsCompanion relationship,
  ) =>
      into(knowledgeRelationships).insert(relationship);

  // Knowledge Search Index queries
  Future<List<KnowledgeSearchIndexData>> getSearchIndexByEntry(
    String entryId,
  ) =>
      (select(knowledgeSearchIndex)
            ..where((s) => s.knowledgeEntryId.equals(entryId)))
          .get();

  Future<List<KnowledgeSearchIndexData>> searchByQueryVariation(
    String query,
  ) {
    final lowerQuery = query.toLowerCase();
    return (select(knowledgeSearchIndex)
          ..where((s) => s.queryVariation.lower().contains(lowerQuery))
          ..orderBy([(s) => OrderingTerm.desc(s.weight)]))
        .get();
  }

  Future<void> insertSearchIndex(
    KnowledgeSearchIndexCompanion searchIndex,
  ) =>
      into(knowledgeSearchIndex).insert(searchIndex);

  // Knowledge Query Log queries
  Future<List<KnowledgeQueryLogData>> getQueryLogs({
    int limit = 100,
  }) =>
      (select(knowledgeQueryLog)
            ..orderBy([(q) => OrderingTerm.desc(q.queriedAt)])
            ..limit(limit))
          .get();

  Future<List<KnowledgeQueryLogData>> getQueryLogsByEntry(String entryId) =>
      (select(knowledgeQueryLog)
            ..where((q) => q.matchedEntryId.equals(entryId))
            ..orderBy([(q) => OrderingTerm.desc(q.queriedAt)]))
          .get();

  Future<void> insertQueryLog(
    KnowledgeQueryLogCompanion queryLog,
  ) =>
      into(knowledgeQueryLog).insert(queryLog);

  Future<void> updateQueryLogHelpful(int id, bool wasHelpful) =>
      (update(knowledgeQueryLog)..where((q) => q.id.equals(id))).write(
        KnowledgeQueryLogCompanion(wasHelpful: Value(wasHelpful)),
      );

  // ============================================
  // CHAT QUERIES
  // ============================================

  Stream<List<ChatChannel>> watchChannels() => (select(
        chatChannels,
      )..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
          .watch();

  Stream<List<ChatMessage>> watchMessages(String channelId) =>
      (select(chatMessages)
            ..where((m) => m.channelId.equals(channelId))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch();

  Future<void> insertChannel(ChatChannelsCompanion channel) =>
      into(chatChannels).insert(channel, mode: InsertMode.insertOrReplace);

  Future<void> insertMessage(ChatMessagesCompanion message) =>
      into(chatMessages).insert(message, mode: InsertMode.insertOrReplace);

  Future<void> markMessageSynced(String id) =>
      (update(chatMessages)..where((m) => m.id.equals(id))).write(
        ChatMessagesCompanion(isSynced: const Value(true)),
      );

  // ============================================
  // CONTINUING EDUCATION QUERIES
  // ============================================

  Stream<List<ContinuingEducationCourse>> watchAllCourses() => (select(
        continuingEducationCourses,
      )..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .watch();

  Stream<List<ContinuingEducationCourse>> watchCoursesByCategory(
    String category,
  ) =>
      (select(continuingEducationCourses)
            ..where((c) => c.category.equals(category))
            ..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .watch();

  Future<ContinuingEducationCourse?> getCourseById(int id) => (select(
        continuingEducationCourses,
      )..where((c) => c.id.equals(id)))
          .getSingleOrNull();

  Stream<List<UserCourseEnrollment>> watchUserEnrollments(int userId) =>
      (select(userCourseEnrollments)
            ..where((e) => e.userId.equals(userId))
            ..orderBy([(t) => OrderingTerm.desc(t.enrolledAt)]))
          .watch();

  Future<UserCourseEnrollment?> getUserEnrollment(int userId, int courseId) =>
      (select(userCourseEnrollments)
            ..where(
              (e) => e.userId.equals(userId) & e.courseId.equals(courseId),
            ))
          .getSingleOrNull();

  Future<void> insertCourse(ContinuingEducationCoursesCompanion course) =>
      into(continuingEducationCourses).insert(course);

  Future<void> insertOrUpdateEnrollment(
    UserCourseEnrollmentsCompanion enrollment,
  ) =>
      into(
        userCourseEnrollments,
      ).insert(enrollment, mode: InsertMode.insertOrReplace);

  // ============================================
  // EXPENSES QUERIES (STUB - to be expanded later)
  // ============================================

  Stream<List<Expense>> watchUserExpenses(int userId) => (select(expenses)
        ..where((e) => e.userId.equals(userId))
        ..orderBy([(t) => OrderingTerm.desc(t.expenseDate)]))
      .watch();

  Future<void> insertExpense(ExpensesCompanion expense) =>
      into(expenses).insert(expense);
}

// ============================================
// DATA CLASSES FOR JOINED QUERIES
// ============================================

class WorkOrderWithDetails {
  final WorkOrder workOrder;
  final Site site;
  final Client client;
  final List<EquipmentData> equipment;

  WorkOrderWithDetails({
    required this.workOrder,
    required this.site,
    required this.client,
    this.equipment = const [],
  });
}

// ============================================
// DATABASE CONNECTION
// ============================================

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(AppPaths.liveDatabasePathIn(dbFolder));

    // Setup sqlite3 for Windows
    if (Platform.isWindows) {
      sqlite3.tempDirectory = (await getTemporaryDirectory()).path;
    }

    return NativeDatabase.createInBackground(file);
  });
}
