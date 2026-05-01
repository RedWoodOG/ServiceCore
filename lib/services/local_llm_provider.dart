import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../util/log.dart';

/// LocalLLMProvider for Phi-3 Mini inference
/// Synthesizes conversational responses using local on-device LLM
class LocalLLMProvider {
  static LocalLLMProvider? _instance;

  late String _modelCachePath;
  late String _modelPath;
  bool _initialized = false;
  bool _available = false;

  // Temporarily disabled ONNX Runtime due to FFI compatibility issues
  // final OnnxruntimeFFI _onnx = OnnxruntimeFFI.instance;

  LocalLLMProvider._();

  static LocalLLMProvider get instance {
    _instance ??= LocalLLMProvider._();
    return _instance!;
  }

  /// Initialize LocalLLMProvider
  /// Download model if not cached, initialize ONNX Runtime
  Future<void> initialize({bool forceDownload = false}) async {
    try {
      if (_initialized) {
        Log.debug('LocalLLMProvider already initialized');
        return;
      }

      _modelCachePath =
          '${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}portal_offline${Platform.pathSeparator}models';

      // Ensure model cache directory exists
      final cacheDir = Directory(_modelCachePath);
      if (!cacheDir.existsSync()) {
        cacheDir.createSync(recursive: true);
        Log.info('Created model cache directory: $_modelCachePath');
      }

      _modelPath =
          '$_modelCachePath${Platform.pathSeparator}phi-3-mini-4k-instruct${Platform.pathSeparator}model.onnx';

      // Check if model exists
      if (!File(_modelPath).existsSync() || forceDownload) {
        Log.info('Model not found or forced download, will be downloaded on first use');
      }

      // Initialize ONNX Runtime
      // Temporarily disabled due to FFI compatibility issues
      // await _onnx.initialize();
      _initialized = true;
      _available = false; // Set to false since ONNX is disabled

      Log.info('LocalLLMProvider initialized (ONNX Runtime temporarily disabled)');
    } catch (e) {
      Log.error('LocalLLMProvider initialization failed: $e');
      _initialized = true;
      _available = false;
    }
  }

  /// Generate response using Phi-3 Mini
  /// Returns a stream of tokens as they're generated
  Stream<String> generate({
    required String systemPrompt,
    required String userQuery,
    required List<String> context,
    int maxTokens = 200,
    double temperature = 0.3,
    double topP = 0.9,
  }) async* {
    try {
      if (!_available) {
        Log.warn('LocalLLMProvider not available, returning empty stream');
        return;
      }

      // Build the full prompt with context
      final contextStr = context.isNotEmpty ? context.join('\n') : '';
      final fullPrompt = _buildPrompt(
        systemPrompt: systemPrompt,
        context: contextStr,
        userQuery: userQuery,
      );

      Log.debug('Generating response for: ${userQuery.substring(0, 50)}...');

      // For now, simulate token streaming
      // In production, this would call ONNX Runtime GenAI APIs
      yield* _simulateGeneration(fullPrompt, maxTokens);
    } catch (e) {
      Log.error('Error generating response: $e');
      yield 'Error: Unable to generate response at this time.';
    }
  }

  /// Build Phi-3 chat prompt
  String _buildPrompt({
    required String systemPrompt,
    required String context,
    required String userQuery,
  }) {
    final buffer = StringBuffer();

    buffer.write('<|system|>\n');
    buffer.write(systemPrompt);
    buffer.write('<|end|>\n');

    if (context.isNotEmpty) {
      buffer.write('<|user|>\n');
      buffer.write('Context from knowledge base:\n');
      buffer.write(context);
      buffer.write('\n\nQuestion: ');
      buffer.write(userQuery);
      buffer.write('<|end|>\n');
    } else {
      buffer.write('<|user|>\n');
      buffer.write(userQuery);
      buffer.write('<|end|>\n');
    }

    buffer.write('<|assistant|>\n');

    return buffer.toString();
  }

  /// Simulate token generation (placeholder for actual ONNX inference)
  Stream<String> _simulateGeneration(String prompt, int maxTokens) async* {
    // Simulate realistic response generation
    final responses = [
      'Based on the knowledge base, ',
      'I found the following information: ',
      'Here\'s what I can help with: ',
    ];

    final selectedResponse = responses[prompt.hashCode % responses.length];

    // Yield the response in chunks to simulate streaming
    final words = selectedResponse.split(' ');
    for (final word in words) {
      await Future.delayed(const Duration(milliseconds: 50));
      yield '$word ';
    }

    // Add a sample answer
    yield 'You can refer to the knowledge base for more detailed information.';
  }

  /// Check if LLM is available
  bool get isAvailable => _available;

  /// Get device type
  String get device => 'cpu'; // Hardcoded since ONNX is disabled

  /// Shutdown provider
  Future<void> shutdown() async {
    try {
      // _onnx.shutdown(); // Disabled
      _available = false;
      Log.info('LocalLLMProvider shutdown');
    } catch (e) {
      Log.error('Error during LocalLLMProvider shutdown: $e');
    }
  }

  /// Download model from HuggingFace (async, non-blocking)
  Future<void> downloadModel() async {
    try {
      if (File(_modelPath).existsSync()) {
        Log.debug('Model already exists: $_modelPath');
        return;
      }

      Log.info('Starting model download in background...');
      // Model download would happen here in production
      // For now, this is a placeholder
    } catch (e) {
      Log.error('Model download failed: $e');
    }
  }

  /// Get model cache path
  String get modelCachePath => _modelCachePath;

  /// Get model file path
  String get modelPath => _modelPath;
}
