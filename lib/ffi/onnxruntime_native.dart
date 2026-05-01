import 'dart:ffi' as ffi;

// ============================================
// ONNX RUNTIME FFI TYPE DEFINITIONS
// ============================================

/// Status codes from ONNX Runtime C API
enum OrtErrorCode {
  ok(0),
  fail(1),
  invalidArgument(2),
  notImplemented(3),
  internalError(4),
  runtime(5),
  unknown(999);

  final int code;
  const OrtErrorCode(this.code);

  static OrtErrorCode fromCode(int code) {
    try {
      return OrtErrorCode.values.firstWhere((e) => e.code == code);
    } catch (_) {
      return OrtErrorCode.unknown;
    }
  }
}

/// Device type for inference
enum OrtDeviceType {
  cpu(0),
  gpu(1),
  other(2);

  final int value;
  const OrtDeviceType(this.value);
}

/// Opaque pointers to ONNX Runtime objects
typedef OrtEnv = ffi.Opaque;
typedef OrtSession = ffi.Opaque;
typedef OrtSessionOptions = ffi.Opaque;
typedef OrtTensorTypeAndShapeInfo = ffi.Opaque;
typedef OrtValue = ffi.Opaque;
typedef OrtGenerator = ffi.Opaque;
typedef OrtGeneratorParams = ffi.Opaque;

/// C function: OrtStatus* OrtGetApiBase()
typedef NativeGetApiBase = ffi.Pointer<OrtApiStruct> Function();
typedef DartGetApiBase = ffi.Pointer<OrtApiStruct> Function();

/// Opaque type for ORT API structure pointer
final class OrtApiStruct extends ffi.Opaque {}

/// Helper class to wrap ONNX Runtime API functions loaded from DynamicLibrary
/// This is the working implementation that loads functions from the library
class OrtApi {
  final ffi.DynamicLibrary _lib;
  
  OrtApi(this._lib);

  /// Access the underlying library (needed for advanced FFI operations)
  ffi.DynamicLibrary get library => _lib;
  
  // Stub implementations - these would load actual functions from the library
  // For now they throw to indicate the API needs proper integration
  ffi.Pointer<OrtEnv> createEnv(int loggingLevel, ffi.Pointer<ffi.Char> logId) {
    throw UnimplementedError('OrtApi.createEnv needs proper DynamicLibrary integration');
  }

  void releaseEnv(ffi.Pointer<OrtEnv> env) {
    throw UnimplementedError('OrtApi.releaseEnv needs proper DynamicLibrary integration');
  }

  ffi.Pointer<OrtSessionOptions> createSessionOptions() {
    throw UnimplementedError('OrtApi.createSessionOptions needs proper DynamicLibrary integration');
  }

  ffi.Pointer<OrtStatus> sessionOptionsAppendExecutionProvider(
    ffi.Pointer<OrtSessionOptions> options,
    ffi.Pointer<ffi.Char> providerName,
  ) {
    throw UnimplementedError('OrtApi.sessionOptionsAppendExecutionProvider needs proper DynamicLibrary integration');
  }

  void releaseSessionOptions(ffi.Pointer<OrtSessionOptions> options) {
    throw UnimplementedError('OrtApi.releaseSessionOptions needs proper DynamicLibrary integration');
  }

  ffi.Pointer<OrtStatus> createSession(
    ffi.Pointer<OrtEnv> env,
    ffi.Pointer<ffi.Char> modelPath,
    ffi.Pointer<OrtSessionOptions> options,
    ffi.Pointer<ffi.Pointer<OrtSession>> session,
  ) {
    throw UnimplementedError('OrtApi.createSession needs proper DynamicLibrary integration');
  }

  void releaseSession(ffi.Pointer<OrtSession> session) {
    throw UnimplementedError('OrtApi.releaseSession needs proper DynamicLibrary integration');
  }
}

/// ONNX Runtime Status structure
final class OrtStatus extends ffi.Opaque {}

/// GenAI extension function signatures
typedef NativeCreateGenerator = ffi.Pointer<OrtStatus> Function(
  ffi.Pointer<OrtSession> session,
  ffi.Pointer<ffi.Pointer<OrtGenerator>> generator,
);

typedef NativeCreateGeneratorParams = ffi.Pointer<OrtStatus> Function(
  ffi.Pointer<ffi.Pointer<OrtGeneratorParams>> params,
);

typedef NativeGeneratorSetSearchOption = ffi.Pointer<OrtStatus> Function(
  ffi.Pointer<OrtGeneratorParams> params,
  ffi.Pointer<ffi.Char> optionName,
  ffi.Pointer<ffi.Void> optionValue,
);

typedef NativeGeneratorGetOutput = ffi.Pointer<ffi.Uint32> Function(
  ffi.Pointer<OrtGenerator> generator,
);

typedef NativeGeneratorAppendTokenToSequence = ffi.Pointer<OrtStatus> Function(
  ffi.Pointer<OrtGeneratorParams> params,
  ffi.Uint32 tokenId,
);

typedef NativeGeneratorGenerate = ffi.Pointer<OrtStatus> Function(
  ffi.Pointer<OrtGenerator> generator,
  ffi.Pointer<OrtGeneratorParams> params,
);

typedef NativeGeneratorGetSequence = ffi.Pointer<ffi.Uint32> Function(
  ffi.Pointer<OrtGeneratorParams> params,
  ffi.Pointer<ffi.Size> sequenceLength,
);

typedef NativeReleaseGenerator = void Function(
  ffi.Pointer<OrtGenerator> generator,
);

typedef NativeReleaseGeneratorParams = void Function(
  ffi.Pointer<OrtGeneratorParams> params,
);

typedef NativeGetErrorMessage = ffi.Pointer<ffi.Char> Function(
  ffi.Pointer<OrtStatus> status,
);

typedef NativeReleaseStatus = void Function(
  ffi.Pointer<OrtStatus> status,
);

/// Device capability detection
class OrtDeviceInfo {
  final OrtDeviceType type;
  final String name;
  final bool available;

  OrtDeviceInfo({
    required this.type,
    required this.name,
    required this.available,
  });
}

/// Session configuration
class OrtSessionConfig {
  final int threadCount;
  final bool useDirectML;
  final bool useCUDA;
  final int graphOptimizationLevel;

  OrtSessionConfig({
    this.threadCount = 4,
    this.useDirectML = true,
    this.useCUDA = false,
    this.graphOptimizationLevel = 3, // ORT_ENABLE_ALL
  });
}

/// Generator configuration for text generation
class OrtGeneratorConfig {
  final int maxLength;
  final double temperature;
  final double topP;
  final int topK;
  final int repetitionPenalty;
  final List<int> stopTokenIds;

  OrtGeneratorConfig({
    this.maxLength = 100,
    this.temperature = 0.7,
    this.topP = 0.9,
    this.topK = 40,
    this.repetitionPenalty = 1,
    this.stopTokenIds = const [],
  });
}
