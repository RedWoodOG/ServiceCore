// Verification Script - Check if knowledge entries are in the database
// Usage: dart run lib/scripts/verify_knowledge_entries.dart

// ignore_for_file: avoid_print

import 'dart:io';
import '../database/app_database_standalone.dart';

Future<void> main() async {
  print('=== Knowledge Entries Verification ===\n');

  final db = StandaloneDatabase();
  
  try {
    // Get all knowledge entries
    final entries = await db.getAllKnowledgeEntries();
    
    print('Total entries in database: ${entries.length}\n');
    
    if (entries.isEmpty) {
      print('⚠️  WARNING: No entries found in database!');
      print('\nPossible issues:');
      print('1. Ingestion script may not have run successfully');
      print('2. Database path mismatch between script and app');
      print('3. Database file may be locked or corrupted');
    } else {
      print('✓ Entries found! Categories:');
      
      // Group by category
      final categories = <String, int>{};
      for (final entry in entries) {
        categories[entry.category] = (categories[entry.category] ?? 0) + 1;
      }
      
      categories.forEach((category, count) {
        print('  - $category: $count entries');
      });
      
      print('\nSample entries (first 5):');
      for (var i = 0; i < entries.length && i < 5; i++) {
        final entry = entries[i];
        print('  ${i + 1}. ${entry.title} (${entry.category})');
      }
      
      if (entries.length > 5) {
        print('  ... and ${entries.length - 5} more');
      }
    }
    
    // Check database file path
    print('\n=== Database Info ===');
    final userProfile = Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'] ?? '';
    if (userProfile.isNotEmpty) {
      // Check multiple possible locations
      final possiblePaths = [
        '$userProfile\\Documents\\portal_offline.sqlite',
        '$userProfile\\AppData\\Roaming\\portal_offline.sqlite',
        '$userProfile\\AppData\\Local\\portal_offline\\portal_offline.sqlite',
      ];
      
      bool found = false;
      for (final dbPath in possiblePaths) {
        final dbFile = File(dbPath);
        if (dbFile.existsSync()) {
          final size = dbFile.lengthSync();
          print('Database file found: $dbPath');
          print('File size: ${(size / 1024).toStringAsFixed(2)} KB');
          print('File exists: ✓');
          found = true;
          
          // Check if this is the one we're using
          if (dbPath.contains('Documents')) {
            print('(This matches the expected Documents path)');
          }
          break;
        }
      }
      
      if (!found) {
        print('Database file NOT FOUND in any expected location:');
        for (final path in possiblePaths) {
          print('  - $path');
        }
      }
    } else {
      print('Could not determine database path');
    }
    
  } catch (e, stackTrace) {
    print('✗ ERROR: $e');
    print('\nStack trace:');
    print(stackTrace);
  } finally {
    await db.close();
  }
}
