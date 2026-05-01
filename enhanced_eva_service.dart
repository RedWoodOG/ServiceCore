// Enhanced EVA Service with improved content extraction
// lib/services/enhanced_eva_service.dart

import 'lib/database/app_database.dart';
import 'lib/util/log.dart';
import 'lib/services/eva_service.dart';

class EnhancedEvaService {
  final AppDatabase database;
  
  // Equipment type synonyms for better matching
  static const Map<String, List<String>> equipmentSynonyms = {
    'currency_counter': ['money counter', 'bill counter', 'cash counter', 'note counter'],
    'coin_sorter': ['coin machine', 'change machine', 'coin counter'],
    'atm': ['cash machine', 'automated teller', 'cash dispenser'],
    'check_scanner': ['check reader', 'scanner', 'check processor'],
    'validator': ['bill validator', 'note validator', 'cash validator'],
    'dvr': ['recorder', 'video system', 'camera system'],
    'locks': ['security', 'access control', 'door lock'],
  };

  // Common error keywords for troubleshooting
  static const List<String> errorKeywords = [
    'error', 'fault', 'problem', 'issue', 'jam', 'stuck', 'broken',
    'not working', 'failed', 'malfunction', 'trouble', 'fix', 'repair'
  ];

  // Procedure keywords
  static const List<String> procedureKeywords = [
    'how to', 'procedure', 'steps', 'instructions', 'guide', 'process',
    'cleaning', 'maintenance', 'calibration', 'setup', 'install'
  ];

  EnhancedEvaService(this.database);

  Future<EvaResponse> getResponse(String query, {String? equipmentContext}) async {
    try {
      // 1. Analyze query intent and extract enhanced keywords
      final analysis = _analyzeQuery(query, equipmentContext);
      
      // 2. Multi-stage search for relevant entries
      final searchResults = await _performEnhancedSearch(analysis);
      
      if (searchResults.isEmpty) {
        return _createNoResultsResponse(query, analysis);
      }

      // 3. Enhanced content extraction with better context awareness
      final content = _extractEnhancedContent(searchResults, analysis);
      
      // 4. Generate contextual response
      return _generateContextualResponse(content, analysis, searchResults);
      
    } catch (e, stackTrace) {
      Log.error('EVA enhanced response error: $e');
      Log.error('Stack trace: $stackTrace');
      return EvaResponse(
        'I encountered an error while searching for information. Please try again.',
        sources: [],
      );
    }
  }

  QueryAnalysis _analyzeQuery(String query, String? equipmentContext) {
    final lowerQuery = query.toLowerCase();

    // Determine query intent
    QueryIntent intent = QueryIntent.general;
    if (errorKeywords.any((keyword) => lowerQuery.contains(keyword))) {
      intent = QueryIntent.troubleshooting;
    } else if (procedureKeywords.any((keyword) => lowerQuery.contains(keyword))) {
      intent = QueryIntent.procedure;
    }

    // Extract equipment types mentioned
    final equipmentTypes = <String>[];
    
    // Check for direct equipment type matches
    for (final type in equipmentSynonyms.keys) {
      if (lowerQuery.contains(type.replaceAll('_', ' '))) {
        equipmentTypes.add(type);
      }
      
      // Check synonyms
      for (final synonym in equipmentSynonyms[type]!) {
        if (lowerQuery.contains(synonym)) {
          equipmentTypes.add(type);
          break;
        }
      }
    }

    // Add equipment context if provided
    if (equipmentContext != null && !equipmentTypes.contains(equipmentContext)) {
      equipmentTypes.add(equipmentContext);
    }

    // Extract model/brand information
    final models = _extractModelKeywords(lowerQuery);

    // Enhanced keyword extraction with weighting
    final keywords = _extractWeightedKeywords(lowerQuery, intent);

    return QueryAnalysis(
      originalQuery: query,
      intent: intent,
      equipmentTypes: equipmentTypes,
      models: models,
      keywords: keywords,
      hasUrgencyIndicators: _hasUrgencyWords(lowerQuery),
    );
  }

  List<String> _extractModelKeywords(String query) {
    // Common equipment models/brands to look for
    const modelPatterns = [
      'jetscan', 'ih110', 'cummins', 'gloriastar', 'scan coin',
      'tidel', 'mosler', 'diebold', 'ncr', 'wincor', 'hyosung'
    ];

    return modelPatterns.where((model) => query.contains(model)).toList();
  }

  Map<String, double> _extractWeightedKeywords(String query, QueryIntent intent) {
    final words = query.toLowerCase()
        .split(RegExp(r'[\s,]+'))
        .where((w) => w.length > 2)
        .toSet();

    final keywords = <String, double>{};

    for (final word in words) {
      double weight = 1.0;
      
      // Boost technical terms
      if (_isTechnicalTerm(word)) weight += 0.5;
      
      // Boost based on intent
      if (intent == QueryIntent.troubleshooting && errorKeywords.contains(word)) {
        weight += 0.3;
      } else if (intent == QueryIntent.procedure && procedureKeywords.contains(word)) {
        weight += 0.3;
      }
      
      // Reduce weight for common words
      if (_isCommonWord(word)) weight -= 0.3;
      
      if (weight > 0) {
        keywords[word] = weight;
      }
    }

    return keywords;
  }

  bool _isTechnicalTerm(String word) {
    const technicalTerms = {
      'calibration', 'sensor', 'firmware', 'voltage', 'current', 'jam',
      'roller', 'feeder', 'stacker', 'motor', 'belt', 'diagnostic',
      'error', 'code', 'maintenance', 'cleaning', 'alignment'
    };
    return technicalTerms.contains(word);
  }

  bool _isCommonWord(String word) {
    const commonWords = {
      'the', 'and', 'for', 'with', 'how', 'can', 'what', 'when', 'where',
      'machine', 'device', 'system', 'unit'
    };
    return commonWords.contains(word);
  }

  bool _hasUrgencyWords(String query) {
    const urgentWords = ['urgent', 'emergency', 'down', 'broken', 'critical', 'asap'];
    return urgentWords.any((word) => query.contains(word));
  }

  Future<List<ScoredKnowledgeEntry>> _performEnhancedSearch(QueryAnalysis analysis) async {
    final results = <ScoredKnowledgeEntry>[];
    
    // 1. Primary search: Equipment + Intent specific
    if (analysis.equipmentTypes.isNotEmpty) {
      for (final equipType in analysis.equipmentTypes) {
        final categoryFilter = _getCategoryForIntent(analysis.intent);
        final entries = await _searchKnowledgeEntries(
          equipmentType: equipType,
          category: categoryFilter,
          keywords: analysis.keywords.keys.toList(),
        );
        
        for (final entry in entries) {
          final score = _calculateEntryScore(entry, analysis);
          results.add(ScoredKnowledgeEntry(entry, score));
        }
      }
    }
    
    // 2. Fallback search: Broader keyword search
    if (results.length < 3) {
      final broadEntries = await _searchKnowledgeEntries(
        keywords: analysis.keywords.keys.toList(),
      );
      
      for (final entry in broadEntries) {
        // Avoid duplicates
        if (!results.any((r) => r.entry.id == entry.id)) {
          final score = _calculateEntryScore(entry, analysis);
          if (score > 0.3) { // Only include if reasonably relevant
            results.add(ScoredKnowledgeEntry(entry, score));
          }
        }
      }
    }
    
    // Sort by score and return top results
    results.sort((a, b) => b.score.compareTo(a.score));
    return results.take(5).toList();
  }

  String? _getCategoryForIntent(QueryIntent intent) {
    switch (intent) {
      case QueryIntent.troubleshooting:
        return 'Troubleshooting';
      case QueryIntent.procedure:
        return 'Procedures';
      case QueryIntent.general:
        return null; // No filter
    }
  }

  Future<List<KnowledgeEntry>> _searchKnowledgeEntries({
    String? equipmentType,
    String? category,
    List<String> keywords = const [],
  }) async {
    var query = database.select(database.knowledgeEntries)
      ..where((k) => k.status.equals('approved'));

    if (equipmentType != null) {
      query = query..where((k) => k.equipmentType.equals(equipmentType));
    }

    if (category != null) {
      query = query..where((k) => k.category.equals(category));
    }

    final results = await query.get();

    if (keywords.isEmpty) return results;

    // Filter by keyword relevance
    return results.where((entry) {
      final content = '${entry.title} ${entry.content}'.toLowerCase();
      return keywords.any((keyword) => content.contains(keyword));
    }).toList();
  }

  double _calculateEntryScore(KnowledgeEntry entry, QueryAnalysis analysis) {
    double score = 0.0;
    final content = '${entry.title} ${entry.content}'.toLowerCase();
    
    // 1. Equipment type match
    if (analysis.equipmentTypes.contains(entry.equipmentType)) {
      score += 2.0;
    }
    
    // 2. Category alignment with intent
    final expectedCategory = _getCategoryForIntent(analysis.intent);
    if (expectedCategory != null && entry.category == expectedCategory) {
      score += 1.5;
    }
    
    // 3. Model/brand mentions
    for (final model in analysis.models) {
      if (content.contains(model)) {
        score += 1.0;
      }
    }
    
    // 4. Weighted keyword matching
    for (final keywordEntry in analysis.keywords.entries) {
      final keyword = keywordEntry.key;
      final weight = keywordEntry.value;
      
      // Title matches are worth more
      if (entry.title.toLowerCase().contains(keyword)) {
        score += weight * 1.5;
      } else if (content.contains(keyword)) {
        score += weight;
      }
    }
    
    // 5. Urgency boost for troubleshooting
    if (analysis.hasUrgencyIndicators && entry.category == 'Troubleshooting') {
      score += 0.5;
    }
    
    // 6. Recency bonus (newer content is slightly preferred)
    final age = DateTime.now().difference(entry.updatedAt).inDays;
    if (age < 30) {
      score += 0.2;
    } else if (age < 90) {
      score += 0.1;
    }
    
    return score;
  }

  String _extractEnhancedContent(List<ScoredKnowledgeEntry> results, QueryAnalysis analysis) {
    if (results.isEmpty) return 'No relevant information found.';

    final bestResult = results.first;
    final entry = bestResult.entry;
    
    // Use enhanced extraction for the best match
    return _extractRelevantContentEnhanced(entry.content, analysis);
  }

  String _extractRelevantContentEnhanced(String markdown, QueryAnalysis analysis) {
    if (markdown.isEmpty) return 'No content available.';

    final lines = markdown.split('\n');
    final scoredSections = <ScoredSection>[];

    // Score sections based on keyword density and relevance
    for (int i = 0; i < lines.length; i++) {
      final sectionLines = _extractSection(lines, i, 5); // 5-line sections
      final sectionText = sectionLines.join(' ').toLowerCase();
      
      double sectionScore = 0.0;
      
      // Score based on weighted keywords
      for (final entry in analysis.keywords.entries) {
        final keyword = entry.key;
        final weight = entry.value;
        
        if (sectionText.contains(keyword)) {
          sectionScore += weight * _countOccurrences(sectionText, keyword);
        }
      }
      
      // Boost for section headers
      if (lines[i].startsWith('#') || lines[i].startsWith('**')) {
        sectionScore += 0.5;
      }
      
      if (sectionScore > 0) {
        scoredSections.add(ScoredSection(
          startLine: i,
          lines: sectionLines,
          score: sectionScore,
        ));
      }
    }

    // Sort by relevance and combine top sections
    scoredSections.sort((a, b) => b.score.compareTo(a.score));
    
    final selectedSections = scoredSections.take(2).toList();
    final content = selectedSections
        .map((section) => section.lines.join('\n'))
        .join('\n\n---\n\n');
    
    // Smart truncation at sentence boundaries
    return _truncateAtSentenceBoundary(content, 1000);
  }

  List<String> _extractSection(List<String> lines, int start, int maxLines) {
    final end = (start + maxLines).clamp(0, lines.length);
    return lines.sublist(start, end);
  }

  int _countOccurrences(String text, String pattern) {
    return pattern.allMatches(text).length;
  }

  String _truncateAtSentenceBoundary(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    
    final truncated = text.substring(0, maxLength);
    final lastPeriod = truncated.lastIndexOf('.');
    final lastNewline = truncated.lastIndexOf('\n');
    
    final cutPoint = lastPeriod > lastNewline && lastPeriod > maxLength * 0.8
        ? lastPeriod + 1
        : maxLength;
    
    return '${text.substring(0, cutPoint).trim()}...';
  }

  EvaResponse _generateContextualResponse(
    String content,
    QueryAnalysis analysis,
    List<ScoredKnowledgeEntry> results,
  ) {
    final sources = results.map((r) => r.entry).take(3).toList();
    
    // Add contextual prefix based on intent
    String response = content;
    if (analysis.hasUrgencyIndicators) {
      response = "🚨 **Priority Response** 🚨\n\n$response";
    }
    
    if (analysis.intent == QueryIntent.troubleshooting) {
      response = "**Troubleshooting Guidance:**\n\n$response";
    } else if (analysis.intent == QueryIntent.procedure) {
      response = "**Procedure:**\n\n$response";
    }
    
    return EvaResponse(
      response,
      sources: sources,
    );
  }

  double _calculateConfidence(List<ScoredKnowledgeEntry> results, QueryAnalysis analysis) {
    if (results.isEmpty) return 0.0;
    
    final topScore = results.first.score;
    final avgScore = results.map((r) => r.score).reduce((a, b) => a + b) / results.length;
    
    // High confidence if top result significantly better than average
    final scoreRatio = avgScore > 0 ? topScore / avgScore : 1.0;
    
    double confidence = (topScore * 0.7 + scoreRatio * 0.3).clamp(0.0, 1.0);
    
    // Boost if equipment type was specifically identified
    if (analysis.equipmentTypes.isNotEmpty) {
      confidence += 0.1;
    }
    
    // Reduce if query was very broad
    if (analysis.keywords.length < 2) {
      confidence -= 0.2;
    }
    
    return confidence.clamp(0.0, 1.0);
  }

  EvaResponse _createNoResultsResponse(String query, QueryAnalysis analysis) {
    String suggestion = "I couldn't find specific information for your query.";
    
    if (analysis.equipmentTypes.isNotEmpty) {
      suggestion += " Try asking about general procedures for ${analysis.equipmentTypes.first.replaceAll('_', ' ')} equipment.";
    } else {
      suggestion += " Try being more specific about the equipment type or problem you're experiencing.";
    }
    
    return EvaResponse(
      suggestion,
      sources: [],
    );
  }
}

// Supporting classes
class QueryAnalysis {
  final String originalQuery;
  final QueryIntent intent;
  final List<String> equipmentTypes;
  final List<String> models;
  final Map<String, double> keywords;
  final bool hasUrgencyIndicators;

  QueryAnalysis({
    required this.originalQuery,
    required this.intent,
    required this.equipmentTypes,
    required this.models,
    required this.keywords,
    required this.hasUrgencyIndicators,
  });
}

enum QueryIntent { troubleshooting, procedure, general }

class ScoredKnowledgeEntry {
  final KnowledgeEntry entry;
  final double score;

  ScoredKnowledgeEntry(this.entry, this.score);
}

class ScoredSection {
  final int startLine;
  final List<String> lines;
  final double score;

  ScoredSection({
    required this.startLine,
    required this.lines,
    required this.score,
  });
}
