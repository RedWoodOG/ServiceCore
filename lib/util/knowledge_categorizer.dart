import 'package:path/path.dart' as p;

class KnowledgeCategorizer {
  // ── Equipment type from folder path (highest priority) ──────────
  static String guessEquipmentType(String filePath) {
    // Folder name is the most reliable signal — the staging tree is
    // organised as  knowledge_entries/equipment/<type>/<file>.md
    final segments = p.split(filePath).map((s) => s.toLowerCase()).toList();

    for (final seg in segments) {
      if (seg == 'coin_sorter' || seg == 'coin-sorter') return 'Coin Sorter';
      if (seg == 'currency_counter' || seg == 'currency-counter') {
        return 'Currency Counter';
      }
      if (seg == 'locks') return 'Security Locks';
      if (seg == 'dvr') return 'Surveillance / DVR';
      if (seg == 'validator') return 'Bill Validator';
      if (seg == 'atm') return 'ATM / TCR';
      if (seg == 'check_scanner' || seg == 'check-scanner') {
        return 'Check Scanner';
      }
      if (seg == 'printer' || seg == 'printers') return 'Printers';
      if (seg == '_other') return 'General';
    }

    // Fallback: scan the full path string
    final lower = filePath.toLowerCase();
    if (lower.contains('coin_sorter') || lower.contains('sorter')) {
      return 'Coin Sorter';
    }
    if (lower.contains('currency_counter') || lower.contains('counter')) {
      return 'Currency Counter';
    }
    if (lower.contains('locks') ||
        lower.contains('kaba') ||
        lower.contains('mas-hamilton') ||
        lower.contains('la gard') ||
        lower.contains('lagard')) {
      return 'Security Locks';
    }
    if (lower.contains('dvr') ||
        lower.contains('camera') ||
        lower.contains('cctv')) {
      return 'Surveillance / DVR';
    }
    if (lower.contains('validator') || lower.contains('bill')) {
      return 'Bill Validator';
    }
    if (lower.contains('atm') || lower.contains('tcr')) return 'ATM / TCR';
    if (lower.contains('check_scanner') || lower.contains('scanner')) {
      return 'Check Scanner';
    }
    if (lower.contains('printer') || lower.contains('receipt')) {
      return 'Printers';
    }
    if (lower.contains('pc') ||
        lower.contains('computer') ||
        lower.contains('workstation')) {
      return 'Computing';
    }

    return 'General';
  }

  // ── Content type from filename + body analysis ──────────────────
  static String guessContentType(String fileName, String body) {
    final lowerName = fileName.toLowerCase();
    final lowerBody = body.toLowerCase();

    // Troubleshooting / error resolution
    if (lowerName.contains('fix') ||
        lowerName.contains('clear_error') ||
        lowerName.contains('recover') ||
        lowerName.contains('troubleshoot') ||
        lowerBody.contains('if the error persists') ||
        lowerBody.contains('root cause')) {
      return 'troubleshooting';
    }

    // Calibration / setup
    if (lowerName.contains('calibrat') ||
        lowerName.contains('setup') ||
        lowerName.contains('config') ||
        lowerName.contains('install')) {
      return 'procedure';
    }

    // Cleaning / maintenance
    if (lowerName.contains('clean') ||
        lowerName.contains('mainten') ||
        lowerName.contains('replace') ||
        lowerName.contains('inspect')) {
      return 'procedure';
    }

    // How-to / operational procedure (most common)
    if (lowerName.contains('how_to') ||
        lowerName.contains('how-to') ||
        lowerBody.contains('procedure:') ||
        lowerBody.contains('steps:') ||
        RegExp(r'^\d+\.', multiLine: true).hasMatch(body)) {
      return 'procedure';
    }

    // Change code / security
    if (lowerName.contains('change_code') || lowerName.contains('reset')) {
      return 'procedure';
    }

    // Safety
    if (lowerName.contains('safety') || lowerName.contains('hazard')) {
      return 'safety';
    }

    // Specification / reference
    if (lowerName.contains('spec') || lowerName.contains('datasheet')) {
      return 'specification';
    }

    return 'reference';
  }

  // ── Functional category from content type + path ────────────────
  static String guessCategory(String filePath, {String? contentType}) {
    final lower = filePath.toLowerCase();

    // Use content type if available
    if (contentType != null) {
      switch (contentType) {
        case 'troubleshooting':
          return 'Troubleshooting';
        case 'procedure':
          if (lower.contains('clean') || lower.contains('mainten')) {
            return 'Maintenance';
          }
          if (lower.contains('install') ||
              lower.contains('setup') ||
              lower.contains('config') ||
              lower.contains('calibrat')) {
            return 'Installation & Setup';
          }
          return 'Procedures';
        case 'safety':
          return 'Safety';
        case 'specification':
          return 'Specifications';
      }
    }

    // Path-based fallback
    if (lower.contains('troubleshoot') ||
        lower.contains('fix') ||
        lower.contains('repair') ||
        lower.contains('error') ||
        lower.contains('recover')) {
      return 'Troubleshooting';
    }
    if (lower.contains('install') ||
        lower.contains('setup') ||
        lower.contains('config') ||
        lower.contains('calibrat')) {
      return 'Installation & Setup';
    }
    if (lower.contains('clean') ||
        lower.contains('mainten') ||
        lower.contains('replace') ||
        lower.contains('inspect')) {
      return 'Maintenance';
    }
    if (lower.contains('safety') ||
        lower.contains('hazard') ||
        lower.contains('warning')) {
      return 'Safety';
    }
    if (lower.contains('parts') ||
        lower.contains('inventory') ||
        lower.contains('component')) {
      return 'Parts & Inventory';
    }

    return 'Procedures';
  }

  // ── Extract equipment model from frontmatter or filename ────────
  static String? guessEquipmentModel(
      String fileName, Map<dynamic, dynamic>? metadata) {
    // Prefer frontmatter
    if (metadata != null && metadata['equipment_model'] != null) {
      final model = metadata['equipment_model'].toString();
      if (model.isNotEmpty && model.toLowerCase() != 'other') return model;
    }

    // Extract from filename patterns like: coin_sorter_clean_sensors_mach6.md
    final lower = fileName.toLowerCase();

    // Known model patterns
    final modelPatterns = <RegExp, String>{
      RegExp(r'jetsort\s*2000'): 'JetSort 2000',
      RegExp(r'jetsort'): 'JetSort',
      RegExp(r'mach\s*6'): 'Mach 6',
      RegExp(r'magner'): 'Magner',
      RegExp(r'lpc3'): 'LPC3',
      RegExp(r'ih[-_]?110'): 'Hitachi iH-110',
      RegExp(r'jetscan|ifx'): 'JetScan iFX',
      RegExp(r'la\s*gard|lagard|39e'): 'La Gard 39E',
      RegExp(r'kaba|mas[-_]?hamilton'): 'Kaba Mas',
      RegExp(r'cencon'): 'Cencon',
      RegExp(r'hikvision'): 'Hikvision',
      RegExp(r'march'): 'March Networks',
      RegExp(r'exacq'): 'Exacq',
      RegExp(r'openpath'): 'OpenPath',
    };

    for (final entry in modelPatterns.entries) {
      if (entry.key.hasMatch(lower)) return entry.value;
    }

    return null;
  }

  // ── Extract keywords from title and body ────────────────────────
  static String extractKeywords(
      String title, String body, String equipmentType) {
    final keywords = <String>{};

    // Add equipment type tokens
    for (final word in equipmentType.toLowerCase().split(RegExp(r'[\s/]+'))) {
      if (word.length > 2) keywords.add(word);
    }

    // Add significant title words
    final stopWords = {
      'how',
      'to',
      'the',
      'a',
      'an',
      'on',
      'in',
      'for',
      'of',
      'and',
      'or',
      'is',
      'at',
      'by',
      'from',
      'with'
    };
    for (final word in title.toLowerCase().split(RegExp(r'[\s_\-]+'))) {
      if (word.length > 2 && !stopWords.contains(word)) {
        keywords.add(word);
      }
    }

    // Extract bold terms from body (often key concepts)
    final boldPattern = RegExp(r'\*\*([^*]+)\*\*');
    for (final match in boldPattern.allMatches(body)) {
      final term = match.group(1)!.toLowerCase().trim();
      if (term.length > 2 && term.length < 40) {
        keywords.add(term);
      }
    }

    return keywords.take(20).join(',');
  }

  // ── Generate a short summary from the body ──────────────────────
  static String? extractSummary(String title, String body) {
    // Try to find the first meaningful paragraph (skip headings, blank lines)
    final lines = body.split('\n');
    final buffer = StringBuffer();

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        if (buffer.isNotEmpty) break; // End of first paragraph
        continue;
      }
      if (trimmed.startsWith('#') || trimmed.startsWith('---')) continue;
      if (trimmed.startsWith('**') && trimmed.endsWith('**')) {
        continue; // Skip bold-only headings
      }
      if (trimmed.startsWith('**') && trimmed.endsWith(':')) {
        continue; // Skip label lines like **Procedure:**
      }

      buffer.write('${buffer.isEmpty ? '' : ' '}$trimmed');
      if (buffer.length > 150) break;
    }

    final summary = buffer.toString().trim();
    if (summary.isEmpty || summary == title) return null;
    return summary.length > 200 ? '${summary.substring(0, 197)}...' : summary;
  }

  // ── Guess difficulty from content complexity ────────────────────
  static String guessDifficulty(String body) {
    final lower = body.toLowerCase();
    final stepCount =
        RegExp(r'^\d+\.', multiLine: true).allMatches(body).length;

    // Advanced indicators
    if (lower.contains('calibration') ||
        lower.contains('firmware') ||
        lower.contains('diagnostic') ||
        lower.contains('pincode') ||
        lower.contains('pin code') ||
        stepCount > 10) {
      return 'advanced';
    }

    // Intermediate indicators
    if (lower.contains('disassembl') ||
        lower.contains('remove the') ||
        lower.contains('replace the') ||
        stepCount > 5) {
      return 'intermediate';
    }

    return 'beginner';
  }

  // ── Estimate time in minutes from step count ────────────────────
  static int? estimateTime(String body) {
    final stepCount =
        RegExp(r'^\d+\.', multiLine: true).allMatches(body).length;
    if (stepCount == 0) return null;
    // Rough estimate: 2 minutes per step, minimum 5 minutes
    return (stepCount * 2).clamp(5, 60);
  }
}
