/// Text-generation capability for EVA, the in-app assistant.
///
/// EVA works without a model: it falls back to intent routing and keyword search
/// over the local knowledge base. A provider is an *optional upgrade* that adds
/// synthesis on top of retrieval, so every implementation is allowed to report
/// [isAvailable] as `false` and callers must handle that.
///
/// This interface exists because generation is the one part of the app that is
/// genuinely platform-dependent. On-device inference through native FFI is not
/// portable across Windows, Android and iOS; a hosted model needs a network the
/// app is explicitly designed to survive without. Keeping that behind a seam
/// means the rest of the codebase compiles and runs identically everywhere.
abstract class AssistantModelProvider {
  /// Prepares the provider. Must not throw: implementations report failure by
  /// leaving [isAvailable] false.
  Future<void> initialize();

  /// Whether [generate] can currently produce tokens.
  bool get isAvailable;

  /// Streams response tokens. Emits nothing when the provider is unavailable.
  Stream<String> generate({
    required String systemPrompt,
    required String userQuery,
    required List<String> context,
    int maxTokens,
    double temperature,
    double topP,
  });
}

/// The default provider: no generation capability.
///
/// This is the honest description of every platform today. On-device ONNX
/// inference was wired up for Windows but never functioned — it was disabled
/// behind a permanently-false availability flag, and the code path that "streamed
/// tokens" actually emitted canned strings. That has been removed rather than
/// carried forward, because a fake generator is worse than none: it produces
/// confident text that no model wrote.
///
/// Replace this with a real implementation — hosted or on-device — by passing one
/// to [EvaService]. Nothing else needs to change.
class UnavailableAssistantModelProvider implements AssistantModelProvider {
  const UnavailableAssistantModelProvider();

  @override
  Future<void> initialize() async {}

  @override
  bool get isAvailable => false;

  @override
  Stream<String> generate({
    required String systemPrompt,
    required String userQuery,
    required List<String> context,
    int maxTokens = 200,
    double temperature = 0.3,
    double topP = 0.9,
  }) async* {
    // Intentionally empty: callers fall back to retrieval-only answers.
  }
}
