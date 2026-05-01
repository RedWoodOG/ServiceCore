import 'dart:io';

import 'package:drift/drift.dart';

import '../../database/app_database.dart';
import '../../util/log.dart';
import '../../util/knowledge_categorizer.dart';
import '../errors/app_failure.dart';
import '../errors/result.dart';

// ============================================
// COMMAND OBJECTS
// ============================================

class CreateKnowledgeEntry {
  const CreateKnowledgeEntry({
    required this.id,
    required this.title,
    required this.category,
    required this.equipmentType,
    required this.content,
    this.equipmentModel,
    this.contentType = 'reference',
    this.difficulty,
    this.estimatedTime,
    this.keywords,
    this.summary,
  });

  final String id;
  final String title;
  final String category;
  final String equipmentType;
  final String content;
  final String? equipmentModel;
  final String contentType;
  final String? difficulty;
  final int? estimatedTime;
  final String? keywords;
  final String? summary;
}

class UpdateKnowledgeEntry {
  const UpdateKnowledgeEntry({
    required this.entryId,
    this.title,
    this.category,
    this.equipmentType,
    this.content,
    this.equipmentModel,
    this.status,
  });

  final String entryId;
  final String? title;
  final String? category;
  final String? equipmentType;
  final String? content;
  final String? equipmentModel;
  final String? status;
}

class IngestKnowledgeBundle {
  const IngestKnowledgeBundle({
    required this.directoryPath,
    this.clearExisting = false,
  });

  final String directoryPath;
  final bool clearExisting;
}

// ============================================
// SERVICE
// ============================================

/// The single write boundary for knowledge base operations.
class KnowledgeService {
  KnowledgeService({
    required AppDatabase db,
    required User? currentUser,
  })  : _db = db,
        _currentUser = currentUser;

  final AppDatabase _db;
  // ignore: unused_field - reserved for future permission checks
  final User? _currentUser;

  /// Creates a new knowledge entry.
  Future<Result<String>> create(CreateKnowledgeEntry cmd) async {
    // Validate
    if (cmd.id.trim().isEmpty) {
      return Err(ValidationFailure('ID is required', field: 'id'));
    }
    if (cmd.title.trim().isEmpty) {
      return Err(ValidationFailure('Title is required', field: 'title'));
    }
    if (cmd.category.trim().isEmpty) {
      return Err(ValidationFailure('Category is required', field: 'category'));
    }
    if (cmd.content.trim().isEmpty) {
      return Err(ValidationFailure('Content is required', field: 'content'));
    }

    // Check for duplicate
    try {
      final existing = await _db.getKnowledgeEntryById(cmd.id);
      if (existing != null) {
        return Err(ConflictFailure('Knowledge entry with ID "${cmd.id}" already exists'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to check for existing entry', cause: e, stackTrace: st));
    }

    // Insert
    try {
      final now = DateTime.now();
      await _db.transaction(() async {
        await _db.into(_db.knowledgeEntries).insert(
          KnowledgeEntriesCompanion.insert(
            id: cmd.id.trim(),
            title: cmd.title.trim(),
            category: cmd.category.trim(),
            equipmentType: cmd.equipmentType.trim(),
            equipmentModel: Value(cmd.equipmentModel?.trim()),
            content: cmd.content,
            sourceType: 'manual_entry',
            sourceFile: 'user_created',
            version: '1.0.0',
            status: 'active',
            createdAt: now,
            updatedAt: now,
            contentType: Value(cmd.contentType),
            difficulty: Value(cmd.difficulty),
            estimatedTime: Value(cmd.estimatedTime),
            keywords: Value(cmd.keywords ?? ''),
            summary: Value(cmd.summary),
          ),
        );
      });

      Log.info('KnowledgeService: Created entry "${cmd.id}"');
      return Ok(cmd.id);
    } catch (e, st) {
      Log.error('KnowledgeService: Failed to create entry', e, st);
      return Err(StorageFailure('Failed to create knowledge entry', cause: e, stackTrace: st));
    }
  }

  /// Updates an existing knowledge entry.
  Future<Result<void>> update(UpdateKnowledgeEntry cmd) async {
    if (cmd.entryId.trim().isEmpty) {
      return Err(ValidationFailure('Entry ID is required', field: 'entryId'));
    }

    // Verify exists
    KnowledgeEntry? existing;
    try {
      existing = await _db.getKnowledgeEntryById(cmd.entryId);
      if (existing == null) {
        return Err(NotFoundFailure('Knowledge entry "${cmd.entryId}" not found'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to fetch entry', cause: e, stackTrace: st));
    }

    // Update with version bump
    try {
      final currentVersion = existing.version;
      final versionParts = currentVersion.split('.');
      final newPatch = int.tryParse(versionParts.last) ?? 0;
      final newVersion = '${versionParts.sublist(0, versionParts.length - 1).join('.')}.${newPatch + 1}';

      await _db.transaction(() async {
        await (_db.update(_db.knowledgeEntries)..where((t) => t.id.equals(cmd.entryId))).write(
          KnowledgeEntriesCompanion(
            title: cmd.title != null ? Value(cmd.title!.trim()) : const Value.absent(),
            category: cmd.category != null ? Value(cmd.category!.trim()) : const Value.absent(),
            equipmentType: cmd.equipmentType != null ? Value(cmd.equipmentType!.trim()) : const Value.absent(),
            content: cmd.content != null ? Value(cmd.content!) : const Value.absent(),
            equipmentModel: cmd.equipmentModel != null ? Value(cmd.equipmentModel!.trim()) : const Value.absent(),
            status: cmd.status != null ? Value(cmd.status!) : const Value.absent(),
            version: Value(newVersion),
            updatedAt: Value(DateTime.now()),
          ),
        );
      });

      Log.info('KnowledgeService: Updated entry "${cmd.entryId}" to version $newVersion');
      return const Ok(null);
    } catch (e, st) {
      Log.error('KnowledgeService: Failed to update entry', e, st);
      return Err(StorageFailure('Failed to update knowledge entry', cause: e, stackTrace: st));
    }
  }

  /// Ingests a bundle of markdown files from a directory.
  ///
  /// This is the single blessed path for bulk knowledge import.
  Future<Result<int>> ingestMarkdownBundle(IngestKnowledgeBundle cmd) async {
    final dir = Directory(cmd.directoryPath);
    if (!await dir.exists()) {
      return Err(ValidationFailure('Directory does not exist: ${cmd.directoryPath}'));
    }

    // Clear if requested
    if (cmd.clearExisting) {
      try {
        await _db.clearAllKnowledgeEntries();
        Log.info('KnowledgeService: Cleared existing knowledge entries');
      } catch (e, st) {
        return Err(StorageFailure('Failed to clear existing entries', cause: e, stackTrace: st));
      }
    }

    // Find markdown files
    final mdFiles = <File>[];
    try {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.md')) {
          // Skip logs and temp folders
          final lowerPath = entity.path.toLowerCase();
          if (!lowerPath.contains('_logs') &&
              !lowerPath.contains('_unclassified') &&
              !lowerPath.contains('temp')) {
            mdFiles.add(entity);
          }
        }
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to scan directory', cause: e, stackTrace: st));
    }

    if (mdFiles.isEmpty) {
      return Err(ValidationFailure('No markdown files found in ${cmd.directoryPath}'));
    }

    // Process files
    int successCount = 0;
    final errors = <String>[];

    for (final file in mdFiles) {
      try {
        final content = await file.readAsString();
        final fileName = file.path.split(Platform.pathSeparator).last;
        final baseName = fileName.replaceAll('.md', '');
        
        // Generate ID from filename
        final id = baseName
            .toLowerCase()
            .replaceAll(' ', '-')
            .replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');

        // Extract title from content or use filename
        String title = baseName.replaceAll('_', ' ').replaceAll('-', ' ');
        final h1Match = RegExp(r'^#\s+(.+)$', multiLine: true).firstMatch(content);
        if (h1Match != null) {
          title = h1Match.group(1) ?? title;
        }

        // Guess metadata
        final equipmentType = KnowledgeCategorizer.guessEquipmentType(file.path);
        final category = KnowledgeCategorizer.guessCategory(file.path);

        // Insert or update
        final existing = await _db.getKnowledgeEntryById(id);
        final now = DateTime.now();

        if (existing != null) {
          // Update if content changed
          if (existing.content != content) {
            await (_db.update(_db.knowledgeEntries)..where((t) => t.id.equals(id))).write(
              KnowledgeEntriesCompanion(
                content: Value(content),
                updatedAt: Value(now),
              ),
            );
          }
        } else {
          // Insert new
          await _db.into(_db.knowledgeEntries).insert(
            KnowledgeEntriesCompanion.insert(
              id: id,
              title: title,
              category: category,
              equipmentType: equipmentType,
              content: content,
              sourceType: 'bundle_import',
              sourceFile: fileName,
              version: '1.0.0',
              status: 'active',
              createdAt: now,
              updatedAt: now,
            ),
          );
        }

        successCount++;
      } catch (e) {
        errors.add('${file.path}: $e');
      }
    }

    if (errors.isNotEmpty) {
      Log.warn('KnowledgeService: ${errors.length} errors during import');
      for (final error in errors.take(5)) {
        Log.warn('  $error');
      }
    }

    Log.info('KnowledgeService: Ingested $successCount of ${mdFiles.length} files');
    return Ok(successCount);
  }
}
