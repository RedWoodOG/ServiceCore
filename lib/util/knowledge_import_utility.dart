import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import 'log.dart';

import 'knowledge_categorizer.dart';

class KnowledgeImportUtility {
  final AppDatabase database;

  KnowledgeImportUtility(this.database);

  /// Import all markdown files from the staging directory
  Future<ImportResult> importFromStaging(String stagingPath) async {
    final stagingDir = Directory(stagingPath);
    final importResult = ImportResult();

    if (!await stagingDir.exists()) {
      throw Exception('Staging directory does not exist: $stagingPath');
    }

    // Find all .md files recursively
    await for (final entity in stagingDir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.md')) {
        // Skip logs and temporary folders
        final lowerPath = entity.path.toLowerCase();
        if (lowerPath.contains('_logs') ||
            lowerPath.contains('_unclassified') ||
            lowerPath.contains('phase4-database') ||
            lowerPath.contains('temp')) {
          continue;
        }

        try {
          await _importSingleFile(entity, importResult);
        } catch (e, stackTrace) {
          importResult.errors.add(ImportError(
            file: entity.path,
            error: e.toString(),
            stackTrace: stackTrace.toString(),
          ));
        }
      }
    }

    return importResult;
  }

  Future<void> _importSingleFile(File file, ImportResult result) async {
    final content = await file.readAsString();
    final parsed = _parseMarkdownWithFrontmatter(content);

    final metadata = Map<String, dynamic>.from(parsed.metadata ?? {});

    final fileName = path.basenameWithoutExtension(file.path);
    metadata['id'] ??= fileName
        .toLowerCase()
        .replaceAll(' ', '-')
        .replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');

    // Title: prefer frontmatter, then first H1, then filename
    if (metadata['title'] == null) {
      final h1Match =
          RegExp(r'^#\s+(.+)$', multiLine: true).firstMatch(parsed.body);
      if (h1Match != null) {
        metadata['title'] = h1Match.group(1);
      } else {
        metadata['title'] = fileName.replaceAll('_', ' ').replaceAll('-', ' ');
      }
    }

    // Always derive equipment type and category from path (most reliable)
    metadata['equipment_type'] =
        KnowledgeCategorizer.guessEquipmentType(file.path);
    final contentType =
        KnowledgeCategorizer.guessContentType(fileName, parsed.body);
    metadata['category'] =
        KnowledgeCategorizer.guessCategory(file.path, contentType: contentType);
    metadata['content_type'] = contentType;
    metadata['equipment_model'] =
        KnowledgeCategorizer.guessEquipmentModel(fileName, parsed.metadata);
    metadata['keywords'] = KnowledgeCategorizer.extractKeywords(
        metadata['title'] as String,
        parsed.body,
        metadata['equipment_type'] as String);
    metadata['summary'] = KnowledgeCategorizer.extractSummary(
        metadata['title'] as String, parsed.body);
    metadata['difficulty'] = KnowledgeCategorizer.guessDifficulty(parsed.body);
    metadata['estimated_time'] = KnowledgeCategorizer.estimateTime(parsed.body);

    metadata['source_type'] ??= 'manual_import';
    metadata['source_file'] ??= path.basename(file.path);
    metadata['version'] ??= '1.0.0';
    metadata['status'] ??= 'active';

    // Check if entry already exists
    final existingEntry = await database.getKnowledgeEntryById(metadata['id']);
    if (existingEntry != null) {
      if (_shouldUpdateEntry(existingEntry, metadata, parsed.body)) {
        await _updateKnowledgeEntry(existingEntry, metadata, parsed.body);
        result.updated.add(file.path);
      } else {
        result.skipped.add('${file.path} - No changes detected');
      }
      return;
    }

    // Create new entry
    await _createKnowledgeEntry(metadata, parsed.body);
    result.created.add(file.path);
  }

  ParsedMarkdown _parseMarkdownWithFrontmatter(String content) {
    final lines = content.split('\n');

    if (lines.isEmpty || lines.first.trim() != '---') {
      return ParsedMarkdown(body: content, metadata: null);
    }

    int endIndex = -1;
    for (int i = 1; i < lines.length; i++) {
      if (lines[i].trim() == '---') {
        endIndex = i;
        break;
      }
    }

    if (endIndex == -1) {
      return ParsedMarkdown(body: content, metadata: null);
    }

    final frontmatterLines = lines.sublist(1, endIndex);
    final bodyLines = lines.sublist(endIndex + 1);

    try {
      final yaml = loadYaml(frontmatterLines.join('\n'));
      final metadata = Map<String, dynamic>.from(yaml);
      final body = bodyLines.join('\n').trim();

      return ParsedMarkdown(body: body, metadata: metadata);
    } catch (e) {
      return ParsedMarkdown(body: content, metadata: null);
    }
  }

  bool _shouldUpdateEntry(
      KnowledgeEntry existing, Map<String, dynamic> metadata, String body) {
    // Compare version strings or content hash
    final newVersion = metadata['version'] as String;
    final existingVersion = existing.version;

    // Simple version comparison - you might want to enhance this
    if (newVersion != existingVersion) return true;

    // Compare body content
    if (existing.content != body) return true;

    // Compare other metadata
    if (existing.title != metadata['title']) return true;
    if (existing.category != metadata['category']) return true;
    if (existing.equipmentType != metadata['equipment_type']) return true;
    if (existing.equipmentModel != metadata['equipment_model']) return true;
    if (existing.sourceType != metadata['source_type']) return true;
    if (existing.sourceFile != metadata['source_file']) return true;
    if (existing.status != metadata['status']) return true;

    return false;
  }

  Future<void> _createKnowledgeEntry(
      Map<String, dynamic> metadata, String body) async {
    final entry = KnowledgeEntriesCompanion(
      id: Value(metadata['id'] as String),
      title: Value(metadata['title'] as String),
      category: Value(metadata['category'] as String),
      equipmentType: Value(metadata['equipment_type'] as String),
      equipmentModel: metadata['equipment_model'] != null
          ? Value(metadata['equipment_model'] as String)
          : const Value.absent(),
      content: Value(body),
      sourceType: Value(metadata['source_type'] as String),
      sourceFile: Value(metadata['source_file'] as String),
      version: Value(metadata['version'] as String),
      status: Value(metadata['status'] as String),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
      contentType: Value(metadata['content_type'] as String? ?? 'reference'),
      difficulty: metadata['difficulty'] != null
          ? Value(metadata['difficulty'] as String)
          : const Value.absent(),
      estimatedTime: metadata['estimated_time'] != null
          ? Value(metadata['estimated_time'] as int)
          : const Value.absent(),
      keywords: Value(metadata['keywords'] as String? ?? ''),
      summary: metadata['summary'] != null
          ? Value(metadata['summary'] as String)
          : const Value.absent(),
    );

    await database.into(database.knowledgeEntries).insert(entry);
  }

  Future<void> _updateKnowledgeEntry(KnowledgeEntry existing,
      Map<String, dynamic> metadata, String body) async {
    final update = KnowledgeEntriesCompanion(
      title: Value(metadata['title'] as String),
      category: Value(metadata['category'] as String),
      equipmentType: Value(metadata['equipment_type'] as String),
      equipmentModel: metadata['equipment_model'] != null
          ? Value(metadata['equipment_model'] as String)
          : const Value.absent(),
      content: Value(body),
      sourceType: Value(metadata['source_type'] as String),
      sourceFile: Value(metadata['source_file'] as String),
      version: Value(metadata['version'] as String),
      status: Value(metadata['status'] as String),
      updatedAt: Value(DateTime.now()),
      contentType: Value(metadata['content_type'] as String? ?? 'reference'),
      difficulty: metadata['difficulty'] != null
          ? Value(metadata['difficulty'] as String)
          : const Value.absent(),
      estimatedTime: metadata['estimated_time'] != null
          ? Value(metadata['estimated_time'] as int)
          : const Value.absent(),
      keywords: Value(metadata['keywords'] as String? ?? ''),
      summary: metadata['summary'] != null
          ? Value(metadata['summary'] as String)
          : const Value.absent(),
    );

    await (database.update(database.knowledgeEntries)
          ..where((k) => k.id.equals(existing.id)))
        .write(update);
  }
}

class ParsedMarkdown {
  final String body;
  final Map<String, dynamic>? metadata;

  ParsedMarkdown({required this.body, this.metadata});
}

class ImportResult {
  final List<String> created = [];
  final List<String> updated = [];
  final List<String> skipped = [];
  final List<ImportError> errors = [];

  void printSummary() {
    Log.info('Import Complete:');
    Log.info('  Created: ${created.length} entries');
    Log.info('  Updated: ${updated.length} entries');
    Log.info('  Skipped: ${skipped.length} entries');
    Log.info('  Errors: ${errors.length} entries');

    if (errors.isNotEmpty) {
      Log.warn('Errors:');
      for (final error in errors) {
        Log.warn('  ${error.file}: ${error.error}');
      }
    }
  }
}

class ImportError {
  final String file;
  final String error;
  final String stackTrace;

  ImportError({
    required this.file,
    required this.error,
    required this.stackTrace,
  });
}
