import '../database/app_database.dart';
import '../util/log.dart';
import 'dart:convert';
import 'local_llm_provider.dart';

class EvaResponse {
  final String text;
  final List<KnowledgeEntry> sources;
  final String queryType; // troubleshooting, howto, reference, etc.
  final List<String>? suggestions; // Follow-up suggestions
  final bool isStreaming; // Whether response is being streamed

  EvaResponse(this.text, {
    this.sources = const [],
    this.queryType = 'reference',
    this.suggestions,
    this.isStreaming = false,
  });
}

class EvaService {
  final AppDatabase _db;
  final LocalLLMProvider _llm = LocalLLMProvider.instance;
  bool _llmInitialized = false;

  EvaService(this._db) {
    // Initialize LLM provider asynchronously
    _initializeLLM();
  }

  Future<void> _initializeLLM() async {
    try {
      await _llm.initialize();
      _llmInitialized = _llm.isAvailable;
      Log.info('EVA: LLM provider initialized (available: $_llmInitialized)');
    } catch (e) {
      Log.warn('EVA: Failed to initialize LLM provider: $e');
      _llmInitialized = false;
    }
  }

  /// Process a user query and return a structured response
  /// If LLM is available, uses it for synthesis; otherwise falls back to keyword matching
  Future<EvaResponse> processQuery(String query) async {
    Log.info('EVA: Processing query: "$query"');
    
    // Log the query for learning
    _logQuery(query);
    
    // Handle greetings
    if (_isGreeting(query)) {
      return EvaResponse(
        "Hey there! I'm EVA, your Embedded Intelligence Assistant. I'm here to help with:"
        "\n• **How-to guides** - Step-by-step procedures\n"
        "• **Troubleshooting** - Help diagnosing and fixing issues\n"
        "• **Equipment specs** - Technical specifications and compatibility\n"
        "• **Safety procedures** - Important safety information\n"
        "\nJust ask me a question about what you're working on!",
        queryType: 'greeting',
      );
    }
    
    // Handle IT support requests
    if (_isITSupportRequest(query)) {
      return EvaResponse(
        "For IT support, please contact:\n\n"
        "**Demo Technician**\n"
        "Email: demotech@example.com\n"
        "Phone: (210) 937-2876\n\n"
        "In the meantime, I can help you search the knowledge base for IT-related procedures or troubleshooting guides. What's the issue?",
        queryType: 'itsupport',
      );
    }
    
    // Detect query intent
    final intent = _detectIntent(query);
    
    // Try LLM synthesis first if available
    if (_llmInitialized) {
      try {
        return await _synthesizeWithLLM(query, intent);
      } catch (e) {
        Log.warn('LLM synthesis failed, falling back to intent-based routing: $e');
      }
    }
    
    // Fallback: Route to intent-based handlers
    if (intent == 'troubleshooting') {
      return _handleTroubleshooting(query);
    } else if (intent == 'procedure') {
      return _handleProcedure(query);
    } else if (intent == 'specification') {
      return _handleSpecification(query);
    }
    
    // Default: General knowledge search
    return _handleGeneralQuery(query);
  }

  /// Synthesize response using LLM with RAG context
  Future<EvaResponse> _synthesizeWithLLM(String query, String intent) async {
    try {
      // Retrieve context from knowledge base
      final context = await _retrieveContext(query);
      final contextStrings =
          context.map((e) => '${e.title}\n${e.summary ?? e.content.substring(0, 200)}...').toList();

      // Build system prompt
      const systemPrompt =
          'You are EVA, an embedded field service assistant. '
          'Answer questions about field service operations, equipment, procedures, and troubleshooting. '
          'Base your answers ONLY on the provided context. '
          'If uncertain, say: "I don\'t have information about that in the knowledge base." '
          'Keep responses under 200 words. Use a professional, helpful tone.';

      // Stream tokens from LLM
      final responseBuffer = StringBuffer();
      await _llm
          .generate(
            systemPrompt: systemPrompt,
            userQuery: query,
            context: contextStrings,
            maxTokens: 200,
            temperature: 0.3,
          )
          .forEach((token) {
            responseBuffer.write(token);
          });

      return EvaResponse(
        responseBuffer.toString(),
        sources: context.take(3).toList(),
        queryType: intent,
        isStreaming: false,
      );
    } catch (e) {
      Log.error('LLM synthesis error: $e');
      rethrow;
    }
  }

  /// Retrieve relevant context from knowledge base
  Future<List<KnowledgeEntry>> _retrieveContext(String query) async {
    try {
      final searchResults = await _db.searchByQueryVariation(query);
      var results = <KnowledgeEntry>[];

      if (searchResults.isNotEmpty) {
        final entryIds = searchResults.map((s) => s.knowledgeEntryId).toSet();
        for (var id in entryIds) {
          final entry = await _db.getKnowledgeEntryById(id);
          if (entry != null && !entry.isDeprecated) {
            results.add(entry);
          }
        }
      }

      if (results.isEmpty) {
        results = await _db.searchKnowledge(query);
      }

      return results.take(5).toList();
    } catch (e) {
      Log.warn('Context retrieval failed: $e');
      return [];
    }
  }

  /// Detect the user's intent from their query
  String _detectIntent(String query) {
    final lower = query.toLowerCase();
    
    // Troubleshooting indicators
    if (_containsAny(lower, ['fix', 'problem', 'issue', 'broken', 'not working', "doesn't work", 'error', 'wrong', 'failed', 'crash', 'hang', 'slow', 'help', 'wrong', 'troubleshoot', 'diagnose', 'what\'s wrong']) &&
        !_containsAny(lower, ['how to', 'procedure', 'steps', 'guide'])) {
      return 'troubleshooting';
    }
    
    // Procedure/How-to indicators
    if (_containsAny(lower, ['how to', 'how do i', 'how can i', 'procedure', 'steps', 'guide', 'install', 'setup', 'configure', 'replace', 'change', 'connect', 'set up'])) {
      return 'procedure';
    }
    
    // Specification/Information indicators
    if (_containsAny(lower, ['specs', 'specifications', 'voltage', 'dimensions', 'weight', 'compatible', 'compatibility', 'supported', 'version', 'model', 'serial', 'what is'])) {
      return 'specification';
    }
    
    return 'reference';
  }
  
  /// Helper to check if string contains any of the keywords
  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((k) => text.contains(k));
  }
  
  /// Handle troubleshooting queries with diagnostic approach
  Future<EvaResponse> _handleTroubleshooting(String query) async {
    final doc = await _db.searchTroubleshootingBySymptom(query);
    
    if (doc != null) {
      final buffer = StringBuffer();
      
      buffer.writeln('**Let\'s diagnose this issue:**\n');
      buffer.writeln('**Symptom:** ${doc.symptom}\n');
      buffer.writeln('**Root Cause:** ${doc.rootCause}\n');
      buffer.writeln('**Solution:**\n${doc.resolution}\n');
      
      if (doc.preventionTips != null && doc.preventionTips!.isNotEmpty) {
        buffer.writeln('\n**How to prevent this in the future:**\n${doc.preventionTips}');
      }
      
      // Get related knowledge entry for full context
      final entry = await _db.getKnowledgeEntryById(doc.knowledgeEntryId);
      final sources = entry != null ? [entry] : <KnowledgeEntry>[];
      
      final suggestions = <String>[];
      if (doc.relatedIssues.isNotEmpty) {
        try {
          final relatedIds = jsonDecode(doc.relatedIssues) as List;
          if (relatedIds.isNotEmpty) {
            suggestions.add('Related issues: ${relatedIds.take(3).join(", ")}');
          }
        } catch (_) {}
      }
      
      return EvaResponse(
        buffer.toString(),
        sources: sources,
        queryType: 'troubleshooting',
        suggestions: suggestions.isEmpty ? null : suggestions,
      );
    }
    
    // Fallback to general search
    return _handleGeneralQuery(query);
  }
  
  /// Handle procedure/how-to queries with step-by-step guidance
  Future<EvaResponse> _handleProcedure(String query) async {
    final results = await _db.searchKnowledge(query);
    final procedureDocs = results.where((e) => e.contentType == 'procedure').toList();
    
    if (procedureDocs.isNotEmpty) {
      final entry = procedureDocs.first;
      final procedures = await _db.getProceduresByEntry(entry.id);
      
      if (procedures.isNotEmpty) {
        final buffer = StringBuffer();
        
        if (entry.summary != null && entry.summary!.isNotEmpty) {
          buffer.writeln('**${entry.title}**\n');
          buffer.writeln('${entry.summary}\n');
        }
        
        if (entry.preconditions.isNotEmpty && entry.preconditions != '[]') {
          buffer.writeln('**Before you begin:**\n');
          try {
            final preconds = jsonDecode(entry.preconditions) as List;
            for (var p in preconds) {
              buffer.writeln('✓ $p');
            }
          } catch (_) {}
          buffer.writeln('');
        }
        
        buffer.writeln('**Steps:**\n');
        for (var proc in procedures) {
          buffer.writeln('**${proc.stepNumber}. ${proc.title}**');
          buffer.writeln('${proc.description}\n');
          
          if (proc.warnings.isNotEmpty && proc.warnings != '[]') {
            try {
              final warns = jsonDecode(proc.warnings) as List;
              for (var w in warns) {
                buffer.writeln('⚠️ **Warning:** $w');
              }
            } catch (_) {}
          }
          
          if (proc.expectedResult != null && proc.expectedResult!.isNotEmpty) {
            buffer.writeln('✍️ **Expected result:** ${proc.expectedResult}');
          }
          
          buffer.writeln('');
        }
        
        if (entry.estimatedTime != null && entry.estimatedTime! > 0) {
          buffer.writeln('\n⏱️ Estimated time: ${entry.estimatedTime} minutes');
        }
        
        return EvaResponse(
          buffer.toString(),
          sources: [entry],
          queryType: 'procedure',
        );
      }
    }
    
    // Fallback to general search
    return _handleGeneralQuery(query);
  }
  
  /// Handle specification queries with equipment details
  Future<EvaResponse> _handleSpecification(String query) async {
    final spec = await _db.getEquipmentSpecsByModel(query);
    
    if (spec != null) {
      final buffer = StringBuffer();
      
      buffer.writeln('**Equipment: ${spec.model}**\n');
      
      if (spec.manufacturer != null) {
        buffer.writeln('**Manufacturer:** ${spec.manufacturer}\n');
      }
      
      // Parse specifications JSON
      if (spec.specifications.isNotEmpty && spec.specifications != '{}') {
        buffer.writeln('**Specifications:**\n');
        try {
          final specsData = jsonDecode(spec.specifications) as Map<String, dynamic>;
          specsData.forEach((key, value) {
            buffer.writeln('- **$key:** $value');
          });
        } catch (_) {
          buffer.writeln(spec.specifications);
        }
        buffer.writeln('');
      }
      
      // Parse compatibility
      if (spec.compatibility.isNotEmpty && spec.compatibility != '[]') {
        buffer.writeln('**Compatible With:**\n');
        try {
          final compat = jsonDecode(spec.compatibility) as List;
          for (var c in compat) {
            buffer.writeln('- $c');
          }
        } catch (_) {}
        buffer.writeln('');
      }
      
      if (spec.eolDate != null) {
        buffer.writeln('**End of Life:** ${spec.eolDate}');
      }
      
      if (spec.supportUrl != null && spec.supportUrl!.isNotEmpty) {
        buffer.writeln('\n[External Documentation](${spec.supportUrl})');
      }
      
      final entry = await _db.getKnowledgeEntryById(spec.knowledgeEntryId);
      return EvaResponse(
        buffer.toString(),
        sources: entry != null ? [entry] : <KnowledgeEntry>[],
        queryType: 'specification',
      );
    }
    
    // Fallback to general search
    return _handleGeneralQuery(query);
  }
  
  /// General knowledge search with semantic enhancement
  Future<EvaResponse> _handleGeneralQuery(String query) async {
    // First try search index for better semantic matching
    final searchResults = await _db.searchByQueryVariation(query);
    var results = <KnowledgeEntry>[];
    
    if (searchResults.isNotEmpty) {
      // Get actual knowledge entries from search index results
      final entryIds = searchResults.map((s) => s.knowledgeEntryId).toSet();
      for (var id in entryIds) {
        final entry = await _db.getKnowledgeEntryById(id);
        if (entry != null && !entry.isDeprecated) {
          results.add(entry);
        }
      }
    }
    
    // Fallback to full-text search if no semantic matches
    if (results.isEmpty) {
      results = await _db.searchKnowledge(query);
    }
    
    if (results.isEmpty) {
      return EvaResponse(
        "I couldn't find any matching documents. Here's what you could try:\n"
        "• Search for a specific equipment model or type\n"
        "• Use more general keywords (e.g., 'lock' instead of 'digital lock model X')\n"
        "• Check the Knowledge section to browse by category\n"
        "• If you're experiencing an issue, describe the problem and I'll help troubleshoot",
        queryType: 'reference',
        suggestions: ['Browse Knowledge Categories', 'Ask a troubleshooting question'],
      );
    }

    final topResults = results.take(5).toList();
    final synthesizedAnswer = _synthesizeAnswer(query, topResults);
    
    // Get related content suggestions
    final suggestions = <String>[];
    if (topResults.isNotEmpty) {
      final relatedContent = await _db.getRelatedContent(topResults.first.id);
      if (relatedContent.isNotEmpty) {
        suggestions.add('Related: ${relatedContent.take(2).map((r) => r.relationshipType).join(", ")}');
      }
    }
    
    return EvaResponse(
      synthesizedAnswer,
      sources: topResults.take(3).toList(),
      queryType: 'reference',
      suggestions: suggestions.isEmpty ? null : suggestions,
    );
  }
  
  /// Log query for learning and analytics
  void _logQuery(String query) async {
    try {
      // This will be used to improve EVA's understanding over time
      // In a future update, we can use this data for analytics
      Log.debug('Query logged: $query');
    } catch (_) {}
  }

  /// Check if query is a greeting
  bool _isGreeting(String query) {
    final lower = query.toLowerCase().trim();
    return lower.contains('hello') || 
           lower.contains('hi') || 
           lower.contains('hey') ||
           lower == 'eva' ||
           lower.startsWith('what can you') ||
           lower.startsWith('who are you') ||
           lower == 'help';
  }
  
  /// Check if query is an IT support request
  bool _isITSupportRequest(String query) {
    final lower = query.toLowerCase().trim();
    return lower.contains('it support') ||
           lower.contains('contact it') ||
           lower.contains('it help') ||
           lower.contains('technical support') ||
           lower.contains('tech support') ||
           lower.contains('i need it') ||
           lower.contains('it department') ||
           (lower.contains('support') && (lower.contains('need') || lower.contains('help')));
  }

  /// Synthesize an answer from multiple knowledge entries
  String _synthesizeAnswer(String query, List<KnowledgeEntry> entries) {
    if (entries.isEmpty) return '';
    
    final buffer = StringBuffer();
    
    // If single result, provide direct answer
    if (entries.length == 1) {
      final entry = entries.first;
      buffer.writeln('Based on **${entry.title}** (${entry.category}):\n');
      buffer.writeln(_extractRelevantContent(entry.content, query));
      return buffer.toString();
    }
    
    // Multiple results - synthesize
    buffer.writeln('I found ${entries.length} relevant documents. Here\'s what I found:\n');
    
    for (var i = 0; i < entries.length && i < 3; i++) {
      final entry = entries[i];
      buffer.writeln('**${entry.title}** (${entry.category}):');
      buffer.writeln(_extractRelevantContent(entry.content, query));
      if (i < entries.length - 1 && i < 2) {
        buffer.writeln('\n---\n');
      }
    }
    
    if (entries.length > 3) {
      buffer.writeln('\n*...and ${entries.length - 3} more matching documents.*');
    }
    
    return buffer.toString();
  }

  /// Extract relevant content from markdown body
  /// Tries to find sections containing query keywords, otherwise returns first meaningful chunk
  String _extractRelevantContent(String markdown, String query) {
    if (markdown.isEmpty) return 'No content available.';
    
    final queryWords = query.toLowerCase().split(' ').where((w) => w.length > 2).toList();
    
    // Try to find a section containing query keywords
    final lines = markdown.split('\n');
    int bestStart = 0;
    int bestScore = 0;
    
    // Score each potential starting point
    for (int i = 0; i < lines.length; i++) {
      int score = 0;
      final lineLower = lines[i].toLowerCase();
      
      for (final word in queryWords) {
        if (lineLower.contains(word)) {
          score += 2; // Higher weight for title/header matches
        }
      }
      
      // Check next few lines too
      for (int j = i + 1; j < lines.length && j < i + 5; j++) {
        final nextLineLower = lines[j].toLowerCase();
        for (final word in queryWords) {
          if (nextLineLower.contains(word)) {
            score += 1;
          }
        }
      }
      
      if (score > bestScore) {
        bestScore = score;
        bestStart = i;
      }
    }
    
    // Extract content starting from best match
    final startIndex = bestScore > 0 ? bestStart : 0;
    final relevantLines = lines.skip(startIndex).take(20).toList(); // ~20 lines max
    var content = relevantLines.join('\n').trim();
    
    // Clean up markdown headers if we're starting mid-document
    if (startIndex > 0 && content.startsWith('#')) {
      // Remove leading headers
      content = content.split('\n').skipWhile((line) => line.trim().startsWith('#')).join('\n');
    }
    
    // Limit length and add ellipsis if truncated
    const maxLength = 800;
    if (content.length > maxLength) {
      // Try to cut at sentence boundary
      final truncated = content.substring(0, maxLength);
      final lastPeriod = truncated.lastIndexOf('.');
      final lastNewline = truncated.lastIndexOf('\n');
      final cutPoint = lastPeriod > lastNewline ? lastPeriod + 1 : maxLength;
      content = '${content.substring(0, cutPoint).trim()}...';
    }
    
    return content.isEmpty ? '${markdown.substring(0, markdown.length > 500 ? 500 : markdown.length)}...' : content;
  }
}
