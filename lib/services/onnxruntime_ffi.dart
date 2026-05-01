import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import '../ffi/onnxruntime_native.dart';
import '../util/log.dart';

/// ONNX Runtime FFI wrapper for Phi-3 inference
class OnnxruntimeFFI {
  static OnnxruntimeFFI? _instance;
  late ffi.DynamicLibrary _lib;
  ffi.Pointer<OrtApiStruct>? _apiPtr;
  late OrtApi _api;
  ffi.Pointer<OrtEnv>? _env;
  final Map<String, ffi.Pointer<OrtSession>> _sessions = {};
  OrtDeviceType _detectedDevice = OrtDeviceType.cpu;

  OnnxruntimeFFI._();

  static OnnxruntimeFFI get instance {
    _instance ??= OnnxruntimeFFI._();
    return _instance!;
  }

  /// Initialize ONNX Runtime with device detection
  Future<void> initialize({
    String? runtimePath,
    bool preferDirectML = true,
  }) async {
    try {
      // Load the ONNX Runtime DLL
      _loadLibrary(runtimePath);
      Log.info('ONNX Runtime library loaded');

      // Get API base
      final getApiBase =
          _lib.lookup<ffi.NativeFunction<NativeGetApiBase>>('OrtGetApiBase');
      final getApiBareFunc = getApiBase.asFunction<DartGetApiBase>();
      _apiPtr = getApiBareFunc();

      if (_apiPtr == ffi.nullptr) {
        throw Exception('Failed to get ONNX Runtime API base');
      }
      
      // Create API helper wrapper
      _api = OrtApi(_lib);

      // Create environment
      final envIdStr = 'eva_onnx_env'.toNativeUtf8();
      _env = _api.createEnv(0, envIdStr.cast());
      malloc.free(envIdStr);

      if (_env == ffi.nullptr) {
        throw Exception('Failed to create ONNX Runtime environment');
      }

      Log.info('ONNX Runtime initialized');

      // Detect device
      _detectedDevice = await _detectDevice(preferDirectML: preferDirectML);
      Log.info('Detected device: ${_detectedDevice.name}');
    } catch (e) {
      Log.error('ONNX Runtime initialization failed: $e');
      rethrow;
    }
  }

  /// Load the ONNX Runtime DLL
  void _loadLibrary(String? customPath) {
    try {
      if (Platform.isWindows) {
        if (customPath != null && File(customPath).existsSync()) {
          _lib = ffi.DynamicLibrary.open(customPath);
        } else {
          // Try standard Windows paths
          const standardPaths = [
            'onnxruntime.dll',
            'C:\\Program Files\\ONNX Runtime\\lib\\onnxruntime.dll',
            r'C:\Program Files (x86)\ONNX Runtime\lib\onnxruntime.dll',
          ];

          for (final path in standardPaths) {
            try {
              _lib = ffi.DynamicLibrary.open(path);
              Log.debug('Loaded ONNX Runtime from: $path');
              return;
            } catch (_) {
              continue;
            }
          }

          throw Exception(
            'Could not find onnxruntime.dll in standard Windows paths',
          );
        }
      } else {
        throw UnsupportedError('ONNX Runtime FFI only supports Windows');
      }
    } catch (e) {
      Log.error('Failed to load ONNX Runtime library: $e');
      rethrow;
    }
  }

  /// Detect available device (DirectML or CPU)
  Future<OrtDeviceType> _detectDevice({
    bool preferDirectML = true,
  }) async {
    try {
      if (!preferDirectML) {
        return OrtDeviceType.cpu;
      }

      // Try to detect DirectML device availability
      // For now, assume DirectML is available on Windows 10+
      if (Platform.isWindows) {
        try {
          // Check Windows version (DirectML available on 10+)
          final kernelVersion = _getWindowsKernelVersion();
          if (kernelVersion >= 10) {
            Log.debug('DirectML available on Windows $kernelVersion');
            return OrtDeviceType.gpu;
          }
        } catch (e) {
          Log.debug('DirectML detection failed, falling back to CPU: $e');
        }
      }

      return OrtDeviceType.cpu;
    } catch (e) {
      Log.warn('Device detection error: $e');
      return OrtDeviceType.cpu;
    }
  }

  /// Get Windows kernel version
  int _getWindowsKernelVersion() {
    // Windows 10 = build 10000+, Windows 11 = build 22000+
    // For simplicity, assume Windows 10+ if on Windows
    return 10;
  }

  /// Create or get a session for a model
  Future<ffi.Pointer<OrtSession>> createSession(
    String modelPath, {
    OrtSessionConfig? config,
  }) async {
    try {
      if (_env == ffi.nullptr) {
        throw Exception('ONNX Runtime not initialized');
      }

      config ??= OrtSessionConfig();

      // Create session options
      final sessionOptions = _api.createSessionOptions();
      if (sessionOptions == ffi.nullptr) {
        throw Exception('Failed to create session options');
      }

      // Append execution provider based on detected device
      if (_detectedDevice == OrtDeviceType.gpu && config.useDirectML) {
        final providerStr = 'DmlExecutionProvider'.toNativeUtf8();
        final status =
            _api.sessionOptionsAppendExecutionProvider(sessionOptions, providerStr.cast());
        malloc.free(providerStr);

        if (status != ffi.nullptr) {
          Log.warn('DirectML execution provider append failed, using CPU');
        }
      }

      // Create session
      final modelPathStr = modelPath.toNativeUtf8();
      final sessionPtrPtr = malloc<ffi.Pointer<OrtSession>>();

      final status = _api.createSession(_env!, modelPathStr.cast(), sessionOptions, sessionPtrPtr);
      malloc.free(modelPathStr);

      if (status != ffi.nullptr) {
        throw Exception('Failed to create ONNX session');
      }

      final session = sessionPtrPtr.value;
      malloc.free(sessionPtrPtr);

      if (session == ffi.nullptr) {
        throw Exception('Session pointer is null');
      }

      _sessions[modelPath] = session;
      Log.info('Created ONNX session for: $modelPath');

      // Release session options
      _api.releaseSessionOptions(sessionOptions);

      return session;
    } catch (e) {
      Log.error('Failed to create ONNX session: $e');
      rethrow;
    }
  }

  /// Release a session
  void releaseSession(String modelPath) {
    try {
      final session = _sessions.remove(modelPath);
      if (session != ffi.nullptr && session != null) {
        _api.releaseSession(session);
        Log.debug('Released ONNX session: $modelPath');
      }
    } catch (e) {
      Log.warn('Error releasing ONNX session: $e');
    }
  }

  /// Get device type
  OrtDeviceType get device => _detectedDevice;

  /// Check if initialized
  bool get isInitialized => _env != ffi.nullptr;

  /// Shutdown ONNX Runtime
  void shutdown() {
    try {
      // Release all sessions
      for (final modelPath in List.from(_sessions.keys)) {
        releaseSession(modelPath);
      }
      _sessions.clear();

      // Release environment
      if (_env != ffi.nullptr && _env != null) {
        _api.releaseEnv(_env!);
        _env = ffi.nullptr;
        Log.info('ONNX Runtime shutdown');
      }
    } catch (e) {
      Log.error('Error during ONNX Runtime shutdown: $e');
    }
  }

  /// Get native library for GenAI functions
  ffi.DynamicLibrary get lib => _lib;

  /// Get API structure pointer (for advanced use)
  ffi.Pointer<OrtApiStruct>? get apiPtr => _apiPtr;
  
  /// Get API helper
  OrtApi get api => _api;
}
