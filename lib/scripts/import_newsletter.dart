// Newsletter Import Script
// Usage: 
//   dart run lib/scripts/import_newsletter.dart --pdf-path "path/to/newsletter.pdf"
//   dart run lib/scripts/import_newsletter.dart -p "path/to/newsletter.pdf"
//
// This script imports newsletter content from a PDF file into the company announcements table.
// It requires Flutter runtime to access the database and PDF parsing.

// ignore_for_file: avoid_print

import 'dart:io';
import 'package:args/args.dart';
import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../services/newsletter_import_service.dart';

void main(List<String> arguments) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Parse command-line arguments
  final parser = ArgParser()
    ..addOption(
      'pdf-path',
      abbr: 'p',
      help: 'Path to the PDF newsletter file to import',
      mandatory: false,
    )
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Show this help message',
      negatable: false,
    );

  ArgResults results;
  try {
    results = parser.parse(arguments);
  } catch (e) {
    print('Error parsing arguments: $e\n');
    print(parser.usage);
    exit(1);
  }

  // Show help if requested
  if (results['help'] == true) {
    print('Newsletter Import Script');
    print('Imports newsletter content from a PDF file into the company announcements table.\n');
    print('Usage:');
    print('  dart run lib/scripts/import_newsletter.dart [options]\n');
    print(parser.usage);
    print('\nExamples:');
    print('  dart run lib/scripts/import_newsletter.dart --pdf-path "C:\\path\\to\\newsletter.pdf"');
    print('  dart run lib/scripts/import_newsletter.dart -p "newsletter.pdf"');
    print('\nEnvironment Variable:');
    print('  PDF_PATH    Alternative way to specify the PDF path');
    print('\nDefault:');
    print('  If no path is provided, uses: C:\\Users\\jwhit\\Downloads\\2026 January Newsletter .pdf');
    exit(0);
  }

  // Get PDF path from arguments, environment variable, or use default
  String? pdfPath = results['pdf-path'] as String?;
  pdfPath ??= Platform.environment['PDF_PATH'];
  
  // Default to the user's specified path if not provided
  pdfPath ??= r'C:\Users\jwhit\Downloads\2026 January Newsletter .pdf';

  if (!File(pdfPath).existsSync()) {
    print('ERROR: PDF file not found: $pdfPath');
    print('\nUsage:');
    print('  dart run lib/scripts/import_newsletter.dart --pdf-path "path/to/newsletter.pdf"');
    print('  dart run lib/scripts/import_newsletter.dart -p "path/to/newsletter.pdf"');
    print('');
    print('Options:');
    print('  --pdf-path, -p    Path to the PDF newsletter file (required if not using default)');
    print('');
    print('Environment Variable:');
    print('  PDF_PATH          Alternative way to specify the PDF path');
    print('');
    print('Default:');
    print('  If no path is provided, uses: C:\\Users\\jwhit\\Downloads\\2026 January Newsletter .pdf');
    exit(1);
  }

  print('=== Newsletter Import Script ===\n');
  print('PDF File: $pdfPath\n');

  // Initialize database (using Flutter's path_provider)
  final db = AppDatabase();

  try {
    print('Extracting text from PDF...');
    final service = NewsletterImportService(db);
    
    print('Parsing newsletter content...');
    final count = await service.importFromPdf(pdfPath);

    print('\n✓ Successfully imported $count announcement(s) into company feed');
    print('\nThe announcements are now visible in the Company Feed section of the home dashboard.');
    
  } catch (e, stackTrace) {
    print('\n✗ ERROR: Failed to import newsletter');
    print('Error: $e');
    print('\nStack trace:');
    print(stackTrace);
    exit(1);
  } finally {
    await db.close();
  }
}
