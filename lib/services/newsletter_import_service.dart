import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:fsc_portal/database/app_database.dart';
import 'package:drift/drift.dart' as drift;

/// Service to import newsletter content from PDF into company announcements
class NewsletterImportService {
  final AppDatabase _db;

  NewsletterImportService(this._db);

  /// Import announcements from a PDF newsletter file
  /// Returns the number of announcements created
  Future<int> importFromPdf(String pdfPath) async {
    if (!File(pdfPath).existsSync()) {
      throw Exception('PDF file not found: $pdfPath');
    }

    // Extract text from PDF using Syncfusion
    final fileBytes = await File(pdfPath).readAsBytes();
    final PdfDocument pdfDoc = PdfDocument(inputBytes: fileBytes);
    final StringBuffer textBuffer = StringBuffer();

    // Extract text from all pages
    for (int i = 0; i < pdfDoc.pages.count; i++) {
      textBuffer.writeln(
        PdfTextExtractor(
          pdfDoc,
        ).extractText(startPageIndex: i, endPageIndex: i),
      );
    }

    pdfDoc.dispose();
    final text = textBuffer.toString();

    // Parse text into announcements
    final announcements = _parseNewsletterText(text);

    // Insert into database
    int count = 0;
    for (final announcement in announcements) {
      await _db.into(_db.companyAnnouncements).insert(announcement);
      count++;
    }

    return count;
  }

  /// Parse newsletter text into structured announcements
  /// This is a smart parser that looks for common newsletter patterns
  List<CompanyAnnouncementsCompanion> _parseNewsletterText(String text) {
    final announcements = <CompanyAnnouncementsCompanion>[];

    // Split text into sections (look for headings, dates, or numbered items)
    final lines = text
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    String? currentTitle;
    String? currentCategory;
    String? currentActionLabel;
    final List<String> currentBodyLines = [];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // Detect category from keywords
      final category = _detectCategory(line);
      if (category != null) {
        currentCategory = category;
      }

      // Detect if this is a title (short line, possibly all caps, or followed by body)
      if (_isTitle(line, i < lines.length - 1 ? lines[i + 1].trim() : '')) {
        // Save previous announcement if we have one
        if (currentTitle != null && currentBodyLines.isNotEmpty) {
          announcements.add(
            _createAnnouncement(
              title: currentTitle,
              body: currentBodyLines.join(' ').trim(),
              category: currentCategory ?? 'general',
              actionLabel: currentActionLabel,
            ),
          );
        }

        // Start new announcement
        currentTitle = line;
        currentBodyLines.clear();
        currentActionLabel = null;
      } else if (currentTitle != null) {
        // This is body text
        currentBodyLines.add(line);

        // Check for action labels (buttons, links, etc.)
        if (_hasActionLabel(line)) {
          currentActionLabel = _extractActionLabel(line);
        }
      } else if (line.length > 20) {
        // If we don't have a title yet but this looks like content, use first part as title
        if (currentTitle == null) {
          currentTitle = line.length > 60
              ? '${line.substring(0, 60)}...'
              : line;
          currentBodyLines.add(line);
        }
      }
    }

    // Don't forget the last announcement
    if (currentTitle != null && currentBodyLines.isNotEmpty) {
      announcements.add(
        _createAnnouncement(
          title: currentTitle,
          body: currentBodyLines.join(' ').trim(),
          category: currentCategory ?? 'general',
          actionLabel: currentActionLabel,
        ),
      );
    }

    // If we didn't find structured content, create one announcement from all text
    if (announcements.isEmpty && text.trim().isNotEmpty) {
      final firstLine = text.split('\n').first.trim();
      final title = firstLine.length > 80
          ? '${firstLine.substring(0, 80)}...'
          : firstLine;
      final body = text.trim();

      announcements.add(
        _createAnnouncement(title: title, body: body, category: 'general'),
      );
    }

    return announcements;
  }

  /// Detect category from text content
  String? _detectCategory(String text) {
    final lower = text.toLowerCase();

    if (lower.contains('hr') ||
        lower.contains('human resources') ||
        lower.contains('benefits') ||
        lower.contains('enrollment') ||
        lower.contains('insurance') ||
        lower.contains('payroll')) {
      return 'hr';
    }

    if (lower.contains('safety') ||
        lower.contains('hazard') ||
        lower.contains('warning') ||
        lower.contains('advisory') ||
        lower.contains('precaution')) {
      return 'safety';
    }

    if (lower.contains('fleet') ||
        lower.contains('vehicle') ||
        lower.contains('truck') ||
        lower.contains('repair') ||
        lower.contains('maintenance')) {
      return 'fleet';
    }

    return null;
  }

  /// Determine if a line is likely a title
  bool _isTitle(String line, String nextLine) {
    // Titles are usually:
    // - Short (less than 100 chars)
    // - Not a full sentence (no period at end, or very short)
    // - Possibly all caps or title case
    // - Followed by body text

    if (line.length > 100) return false;
    if (line.isEmpty) return false;

    // Check if it looks like a heading (all caps, or title case, or numbered)
    final isNumbered = RegExp(r'^\d+[\.\)]\s').hasMatch(line);
    final isAllCaps = line == line.toUpperCase() && line.length > 5;
    final isTitleCase = _isTitleCase(line);

    // If next line is much longer, this is probably a title
    final isFollowedByBody = nextLine.length > line.length * 1.5;

    return isNumbered || isAllCaps || (isTitleCase && isFollowedByBody);
  }

  /// Check if text is in title case
  bool _isTitleCase(String text) {
    if (text.isEmpty) return false;
    final words = text.split(' ');
    if (words.isEmpty) return false;

    // Most words should start with capital letter
    int capitalized = 0;
    for (final word in words) {
      if (word.isNotEmpty && word[0] == word[0].toUpperCase()) {
        capitalized++;
      }
    }

    return capitalized >= words.length * 0.7; // 70% of words capitalized
  }

  /// Check if line contains an action label
  bool _hasActionLabel(String line) {
    final lower = line.toLowerCase();
    return lower.contains('click here') ||
        lower.contains('learn more') ||
        lower.contains('view') ||
        lower.contains('read more') ||
        lower.contains('acknowledge') ||
        lower.contains('select') ||
        lower.contains('register') ||
        lower.contains('sign up');
  }

  /// Extract action label from text
  String? _extractActionLabel(String line) {
    final lower = line.toLowerCase();

    if (lower.contains('acknowledge')) return 'ACKNOWLEDGE';
    if (lower.contains('select benefits') || lower.contains('select')) {
      return 'SELECT BENEFITS';
    }
    if (lower.contains('view policy') || lower.contains('view')) {
      return 'VIEW POLICY';
    }
    if (lower.contains('learn more')) return 'LEARN MORE';
    if (lower.contains('read more')) return 'READ MORE';
    if (lower.contains('register') || lower.contains('sign up')) {
      return 'REGISTER';
    }

    return null;
  }

  /// Create a CompanyAnnouncementsCompanion from parsed data
  CompanyAnnouncementsCompanion _createAnnouncement({
    required String title,
    required String body,
    required String category,
    String? actionLabel,
  }) {
    // Truncate body if too long (keep first 500 chars)
    final truncatedBody = body.length > 500
        ? '${body.substring(0, 500)}...'
        : body;

    return CompanyAnnouncementsCompanion.insert(
      category: category,
      title: title.length > 100 ? '${title.substring(0, 100)}...' : title,
      body: truncatedBody,
      actionLabel: drift.Value(actionLabel),
      active: const drift.Value(true),
      publishedAt: DateTime.now(),
      acknowledged: const drift.Value(false),
    );
  }
}
