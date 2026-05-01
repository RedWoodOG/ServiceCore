// Knowledge Entries Ingestion Script
// Usage: dart run lib/scripts/ingest_knowledge_entries.dart
//
// This script uses the standalone database (no Flutter dependencies).
// It can run as a normal Dart program outside the Flutter runtime.

// ignore_for_file: avoid_print

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:drift/drift.dart' as drift;
import '../database/app_database_standalone.dart';

Future<void> main() async {
  print('=== Knowledge Entries Ingestion ===\n');

  // Path to knowledge entries directory
  final knowledgeDir = r'C:\Portal_Knowledge_Staging\knowledge_entries';

  if (!Directory(knowledgeDir).existsSync()) {
    print('ERROR: Knowledge directory not found: $knowledgeDir');
    exit(1);
  }

  // Initialize standalone database (no Flutter dependencies)
  // Enable debug to see database path
  Platform.environment['DEBUG_DB_PATH'] = 'true';
  final db = StandaloneDatabase();

  try {
    // Clear existing entries (optional - comment out to preserve existing)
    print('Clearing existing knowledge entries...');
    await db.clearAllKnowledgeEntries();

    // Find all .md files recursively
    final mdFiles = <File>[];
    final dir = Directory(knowledgeDir);

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.md')) {
        mdFiles.add(entity);
      }
    }

    print('Found ${mdFiles.length} Markdown files\n');

    int successCount = 0;
    int errorCount = 0;

    for (final file in mdFiles) {
      try {
        final content = await file.readAsString();
        final lines = content.split('\n');

        // Parse YAML frontmatter (between --- lines)
        String? title;
        String? category;
        String bodyMarkdown = '';

        if (lines.isNotEmpty && lines[0].trim() == '---') {
          // Extract YAML frontmatter
          final yamlLines = <String>[];
          int bodyStartIndex = 1;

          for (int i = 1; i < lines.length; i++) {
            if (lines[i].trim() == '---') {
              bodyStartIndex = i + 1;
              break;
            }
            yamlLines.add(lines[i]);
          }

          if (yamlLines.isNotEmpty) {
            final yamlContent = yamlLines.join('\n');
            final doc = loadYaml(yamlContent);

            if (doc is Map) {
              title = doc['title']?.toString();
              category = doc['category']?.toString();
            }
          }

          // Extract body (everything after frontmatter)
          bodyMarkdown = lines.sublist(bodyStartIndex).join('\n').trim();
        } else {
          // No frontmatter - use filename as title, put all content as body
          bodyMarkdown = content;
        }

        // Use filename as title fallback
        title ??= path.basenameWithoutExtension(file.path);

        // Default category if not found
        category ??= 'General';

        final fileName = path.basenameWithoutExtension(file.path);
        final entryId = fileName
            .toLowerCase()
            .replaceAll(' ', '-')
            .replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
        final equipmentType = _guessEquipmentType(file.path);

        // Insert or replace in database
        await db.insertOrReplaceKnowledge(
          KnowledgeEntriesCompanion(
            id: drift.Value(entryId),
            title: drift.Value(title),
            category: drift.Value(category),
            equipmentType: drift.Value(equipmentType),
            content: drift.Value(bodyMarkdown),
            sourceType: const drift.Value('manual_import'),
            sourceFile: drift.Value(path.basename(file.path)),
            version: const drift.Value('1.0.0'),
            status: const drift.Value('active'),
            createdAt: drift.Value(DateTime.now()),
            updatedAt: drift.Value(DateTime.now()),
          ),
        );

        successCount++;
        print('✓ ${path.basename(file.path)}');
      } catch (e) {
        errorCount++;
        print('✗ ${path.basename(file.path)}: $e');
      }
    }

    print('\n=== Ingestion Complete ===');
    print('Success: $successCount');
    print('Errors: $errorCount');
    print('Total: ${mdFiles.length}');
  } finally {
    await db.close();
  }
}

String _guessEquipmentType(String filePath) {
  final lower = filePath.toLowerCase();
  if (lower.contains('coin_sorter') || lower.contains('sorter')) {
    return 'Coin Sorter';
  }
  if (lower.contains('currency_counter') || lower.contains('counter')) {
    return 'Currency Counter';
  }
  if (lower.contains('locks')) return 'Security Locks';
  if (lower.contains('dvr')) return 'Surveillance / DVR';
  if (lower.contains('validator')) return 'Bill Validator';
  if (lower.contains('atm')) return 'ATM / TCR';
  if (lower.contains('check_scanner')) return 'Check Scanner';
  return 'General';
}
