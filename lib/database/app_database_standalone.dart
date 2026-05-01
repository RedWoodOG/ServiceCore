// Standalone Database for Scripts (No Flutter Dependencies)
// This file is used by standalone Dart scripts that run outside the Flutter runtime.
// Do NOT import Flutter packages here.

// ignore_for_file: avoid_print

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;

part 'app_database_standalone.g.dart';

// Knowledge Entries Table (updated to match app_database.dart v9)
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

  @override
  Set<Column> get primaryKey => {id};
}

// Company Announcements Table
class CompanyAnnouncements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get actionLabel => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get publishedAt => dateTime()();
  BoolColumn get acknowledged => boolean().withDefault(const Constant(false))();
  DateTimeColumn get acknowledgedAt => dateTime().nullable()();
}

@DriftDatabase(tables: [KnowledgeEntries, CompanyAnnouncements])
class StandaloneDatabase extends _$StandaloneDatabase {
  StandaloneDatabase([QueryExecutor? executor])
    : super(executor ?? _openStandaloneConnection());

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 9) {
        // Simple strategy for standalone: drop and recreate if schema changed significantly
        await m.deleteTable('knowledge_entries');
        await m.createTable(knowledgeEntries);
        if (from < 4) {
          await m.createTable(companyAnnouncements);
        }
      }
    },
  );

  // Knowledge Entries Query Methods
  Future<List<KnowledgeEntry>> getAllKnowledgeEntries() =>
      select(knowledgeEntries).get();

  Future<List<KnowledgeEntry>> getKnowledgeEntriesByCategory(String category) =>
      (select(
        knowledgeEntries,
      )..where((k) => k.category.equals(category))).get();

  Future<List<KnowledgeEntry>> searchKnowledge(String keyword) {
    final lowerKeyword = keyword.toLowerCase();
    return (select(knowledgeEntries)..where(
          (k) =>
              k.title.lower().contains(lowerKeyword) |
              k.content.lower().contains(lowerKeyword) |
              k.category.lower().contains(lowerKeyword),
        ))
        .get();
  }

  Future<KnowledgeEntry?> getKnowledgeByTitle(String title) => (select(
    knowledgeEntries,
  )..where((k) => k.title.equals(title))).getSingleOrNull();

  Future<KnowledgeEntry?> getKnowledgeById(String id) => (select(
    knowledgeEntries,
  )..where((k) => k.id.equals(id))).getSingleOrNull();

  Future<void> insertOrReplaceKnowledge(KnowledgeEntriesCompanion entry) =>
      into(knowledgeEntries).insert(entry, mode: InsertMode.replace);

  Future<void> clearAllKnowledgeEntries() => delete(knowledgeEntries).go();

  // Company Announcements Query Methods
  Future<List<CompanyAnnouncement>> getActiveCompanyAnnouncements() =>
      (select(companyAnnouncements)
            ..where((a) => a.active.equals(true))
            ..orderBy([(t) => OrderingTerm.desc(t.publishedAt)]))
          .get();

  Future<void> insertCompanyAnnouncement(
    CompanyAnnouncementsCompanion announcement,
  ) => into(companyAnnouncements).insert(announcement);

  Future<void> clearAllCompanyAnnouncements() =>
      delete(companyAnnouncements).go();
}

LazyDatabase _openStandaloneConnection([String? dbPath]) {
  return LazyDatabase(() async {
    File file;

    if (dbPath != null) {
      file = File(dbPath);
    } else {
      final userProfile =
          Platform.environment['USERPROFILE'] ??
          Platform.environment['HOME'] ??
          '';
      if (userProfile.isEmpty) {
        throw Exception('Could not determine user profile directory.');
      }

      final documentsPath = p.join(userProfile, 'Documents');
      final dbFolder = Directory(documentsPath);

      if (!dbFolder.existsSync()) {
        dbFolder.createSync(recursive: true);
      }

      file = File(p.join(dbFolder.path, 'fsc_portal_dev.sqlite'));

      if (Platform.environment.containsKey('DEBUG_DB_PATH')) {
        print('DEBUG: Standalone database path: ${file.path}');
      }
    }

    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }

    if (Platform.isWindows) {
      final tempDir = Directory(
        Platform.environment['TEMP'] ?? Platform.environment['TMP'] ?? '',
      );
      if (tempDir.existsSync()) {
        sqlite3.tempDirectory = tempDir.path;
      }
    }

    return NativeDatabase.createInBackground(file);
  });
}
