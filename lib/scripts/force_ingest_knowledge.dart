// Force Knowledge Ingestion - Direct Database Insert
// This script uses the standalone database but prints the exact path
// Usage: dart run lib/scripts/force_ingest_knowledge.dart

// ignore_for_file: avoid_print

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:drift/drift.dart' as drift;
import '../database/app_database_standalone.dart';

Future<void> main() async {
  print('=== FORCE Knowledge Entries Ingestion ===\n');

  // Path to knowledge entries directory
  final knowledgeDir = r'C:\Portal_Knowledge_Staging\knowledge_entries';

  if (!Directory(knowledgeDir).existsSync()) {
    print('ERROR: Knowledge directory not found: $knowledgeDir');
    exit(1);
  }

  // Get the exact database path
  final userProfile =
      Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'] ?? '';
  if (userProfile.isEmpty) {
    print('ERROR: Could not determine user profile');
    exit(1);
  }

  final dbPath = path.join(userProfile, 'Documents', 'portal_offline.sqlite');
  print('Using database: $dbPath');

  final dbFile = File(dbPath);
  if (!dbFile.existsSync()) {
    print('WARNING: Database file does not exist. It will be created.');
  } else {
    final size = dbFile.lengthSync();
    print('Database exists: ${(size / 1024).toStringAsFixed(2)} KB\n');
  }

  // Initialize standalone database
  final db = StandaloneDatabase();

  try {
    // Clear existing entries
    print('Clearing existing knowledge entries...');
    await db.clearAllKnowledgeEntries();
    print('✓ Cleared\n');

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

        // Parse YAML frontmatter
        String? title;
        String? category;
        String bodyMarkdown = '';

        if (lines.isNotEmpty && lines[0].trim() == '---') {
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

          bodyMarkdown = lines.sublist(bodyStartIndex).join('\n').trim();
        } else {
          bodyMarkdown = content;
        }

        title ??= path.basenameWithoutExtension(file.path);
        category ??= 'General';

        final fileName = path.basenameWithoutExtension(file.path);
        final entryId = fileName
            .toLowerCase()
            .replaceAll(' ', '-')
            .replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
        final equipmentType = _guessEquipmentType(file.path);

        // Insert into database
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
        if (successCount % 20 == 0) {
          print('  Processed $successCount/$mdFiles.length...');
        }
      } catch (e) {
        errorCount++;
        print('✗ ${path.basename(file.path)}: $e');
      }
    }

    print('\n=== Ingestion Complete ===');
    print('Success: $successCount');
    print('Errors: $errorCount');
    print('Total: ${mdFiles.length}');

    // Verify
    final allEntries = await db.getAllKnowledgeEntries();
    print('\n✓ VERIFICATION: ${allEntries.length} entries in database');

    if (allEntries.isNotEmpty) {
      final categories = allEntries.map((e) => e.category).toSet().toList()
        ..sort();
      print(
          'Categories (${categories.length}): ${categories.take(10).join(", ")}${categories.length > 10 ? "..." : ""}');
      print('\n✓ Database file: $dbPath');
      print(
          '✓ File size: ${(File(dbPath).lengthSync() / 1024).toStringAsFixed(2)} KB');
      print('\n✓ SUCCESS! Restart your Flutter app to see the entries.');
    } else {
      print('\n✗ ERROR: No entries found after insertion!');
    }
  } catch (e, stackTrace) {
    print('\n✗ ERROR: $e');
    print('\nStack trace:');
    print(stackTrace);
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
