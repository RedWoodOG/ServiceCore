import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../util/log.dart';

/// LLM configuration loaded from assets/config/model_config.json
class LLMConfig {
  final String modelName;
  final String modelVersion;
  final String modelFormat;
  
  final ModelPaths paths;
  final InferenceSettings inferenceSettings;
  final DevicePreferences devicePreferences;
  final RAGSettings ragSettings;
  final BehaviorSettings behavior;
  final Map<String, String> systemPrompts;
  final FeatureFlags featureFlags;
  
  LLMConfig({
    required this.modelName,
    required this.modelVersion,
    required this.modelFormat,
    required this.paths,
    required this.inferenceSettings,
    required this.devicePreferences,
    required this.ragSettings,
    required this.behavior,
    required this.systemPrompts,
    required this.featureFlags,
  });
  
  /// Load configuration from assets
  static Future<LLMConfig> load() async {
    try {
      final configJson = await rootBundle.loadString('assets/config/model_config.json');
      final config = json.decode(configJson) as Map<String, dynamic>;
      
      return LLMConfig(
        modelName: config['model_name'] as String,
        modelVersion: config['model_version'] as String,
        modelFormat: config['model_format'] as String,
        paths: ModelPaths.fromJson(config['paths'] as Map<String, dynamic>),
        inferenceSettings: InferenceSettings.fromJson(config['inference_settings'] as Map<String, dynamic>),
        devicePreferences: DevicePreferences.fromJson(config['device_preferences'] as Map<String, dynamic>),
        ragSettings: RAGSettings.fromJson(config['rag_settings'] as Map<String, dynamic>),
        behavior: BehaviorSettings.fromJson(config['behavior'] as Map<String, dynamic>),
        systemPrompts: (config['system_prompts'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, v as String),
        ),
        featureFlags: FeatureFlags.fromJson(config['feature_flags'] as Map<String, dynamic>),
      );
    } catch (e) {
      Log.error('Failed to load LLM config: $e');
      rethrow;
    }
  }
  
  /// Get system prompt for a specific intent
  String getSystemPrompt(String intent) {
    return systemPrompts[intent] ?? systemPrompts['default']!;
  }
  
  /// Resolve model path (expand environment variables)
  Future<String> resolveModelPath() async {
    try {
      // Get documents directory
      final docsDir = await getApplicationDocumentsDirectory();
      
      // Replace %DOCUMENTS% placeholder
      var modelDir = paths.modelCacheDir.replaceAll(
        '%DOCUMENTS%',
        docsDir.path.replaceAll('\\', '/'),
      );
      
      // Build full model path
      final fullPath = '$modelDir/${paths.modelNameInCache}';
      final modelPath = fullPath.replaceAll('/', Platform.pathSeparator);
      
      // Check if model exists in cache
      if (await Directory(modelPath).exists()) {
        Log.info('Model found in cache: $modelPath');
        return modelPath;
      }
      
      // Try fallback paths
      for (final fallbackPath in paths.fallbackPaths) {
        final expandedPath = _expandPath(fallbackPath);
        if (await Directory(expandedPath).exists()) {
          Log.info('Model found in fallback path: $expandedPath');
          return expandedPath;
        }
      }
      
      Log.warn('Model not found in any configured paths');
      return modelPath; // Return cache path as default
      
    } catch (e) {
      Log.error('Error resolving model path: $e');
      rethrow;
    }
  }
  
  /// Expand path variables like ./ and %VARIABLE%
  String _expandPath(String path) {
    var expanded = path;
    
    // Expand ./
    if (expanded.startsWith('./')) {
      expanded = '${Directory.current.path}${Platform.pathSeparator}${expanded.substring(2)}';
    }
    
    // Expand environment variables (Windows style)
    final envVarPattern = RegExp(r'%(\w+)%');
    expanded = expanded.replaceAllMapped(envVarPattern, (match) {
      final varName = match.group(1)!;
      return Platform.environment[varName] ?? match.group(0)!;
    });
    
    return expanded.replaceAll('/', Platform.pathSeparator);
  }
}

class ModelPaths {
  final String modelCacheDir;
  final String modelNameInCache;
  final List<String> fallbackPaths;
  
  ModelPaths({
    required this.modelCacheDir,
    required this.modelNameInCache,
    required this.fallbackPaths,
  });
  
  factory ModelPaths.fromJson(Map<String, dynamic> json) {
    return ModelPaths(
      modelCacheDir: json['model_cache_dir'] as String,
      modelNameInCache: json['model_name_in_cache'] as String,
      fallbackPaths: (json['fallback_paths'] as List).cast<String>(),
    );
  }
}

class InferenceSettings {
  final int maxTokens;
  final double temperature;
  final double topP;
  final int topK;
  final double repetitionPenalty;
  final int contextWindow;
  
  InferenceSettings({
    required this.maxTokens,
    required this.temperature,
    required this.topP,
    required this.topK,
    required this.repetitionPenalty,
    required this.contextWindow,
  });
  
  factory InferenceSettings.fromJson(Map<String, dynamic> json) {
    return InferenceSettings(
      maxTokens: json['max_tokens'] as int,
      temperature: (json['temperature'] as num).toDouble(),
      topP: (json['top_p'] as num).toDouble(),
      topK: json['top_k'] as int,
      repetitionPenalty: (json['repetition_penalty'] as num).toDouble(),
      contextWindow: json['context_window'] as int,
    );
  }
}

class DevicePreferences {
  final bool preferDirectML;
  final bool fallbackToCPU;
  final int cpuThreads;
  
  DevicePreferences({
    required this.preferDirectML,
    required this.fallbackToCPU,
    required this.cpuThreads,
  });
  
  factory DevicePreferences.fromJson(Map<String, dynamic> json) {
    return DevicePreferences(
      preferDirectML: json['prefer_directml'] as bool,
      fallbackToCPU: json['fallback_to_cpu'] as bool,
      cpuThreads: json['cpu_threads'] as int,
    );
  }
}

class RAGSettings {
  final int maxContextEntries;
  final int contextMaxTokens;
  final bool enableSemanticSearch;
  
  RAGSettings({
    required this.maxContextEntries,
    required this.contextMaxTokens,
    required this.enableSemanticSearch,
  });
  
  factory RAGSettings.fromJson(Map<String, dynamic> json) {
    return RAGSettings(
      maxContextEntries: json['max_context_entries'] as int,
      contextMaxTokens: json['context_max_tokens'] as int,
      enableSemanticSearch: json['enable_semantic_search'] as bool,
    );
  }
}

class BehaviorSettings {
  final bool enableStreaming;
  final bool gracefulFallback;
  final bool logQueries;
  final bool cacheResponses;
  
  BehaviorSettings({
    required this.enableStreaming,
    required this.gracefulFallback,
    required this.logQueries,
    required this.cacheResponses,
  });
  
  factory BehaviorSettings.fromJson(Map<String, dynamic> json) {
    return BehaviorSettings(
      enableStreaming: json['enable_streaming'] as bool,
      gracefulFallback: json['graceful_fallback'] as bool,
      logQueries: json['log_queries'] as bool,
      cacheResponses: json['cache_responses'] as bool,
    );
  }
}

class FeatureFlags {
  final bool enableLLM;
  final bool enableConversationHistory;
  final bool enableMultiTurn;
  final bool enableModelDownload;
  
  FeatureFlags({
    required this.enableLLM,
    required this.enableConversationHistory,
    required this.enableMultiTurn,
    required this.enableModelDownload,
  });
  
  factory FeatureFlags.fromJson(Map<String, dynamic> json) {
    return FeatureFlags(
      enableLLM: json['enable_llm'] as bool,
      enableConversationHistory: json['enable_conversation_history'] as bool,
      enableMultiTurn: json['enable_multi_turn'] as bool,
      enableModelDownload: json['enable_model_download'] as bool,
    );
  }
}
