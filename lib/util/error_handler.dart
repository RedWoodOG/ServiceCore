import 'dart:async';
import 'log.dart';

class ErrorHandler {
  /// Retry logic with exponential backoff
  static Future<T> retryOperation<T>({
    required Future<T> Function() operation,
    int maxAttempts = 3,
    Duration initialDelay = const Duration(milliseconds: 500),
    String? operationName,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (attempt < maxAttempts) {
      attempt++;

      try {
        return await operation();
      } catch (e, stackTrace) {
        if (attempt >= maxAttempts) {
          Log.error(
            '${operationName ?? "Operation"} failed after $maxAttempts attempts: $e',
            e,
            stackTrace,
          );
          rethrow;
        }

        Log.warn(
          '${operationName ?? "Operation"} attempt $attempt failed: $e. Retrying in ${delay.inMilliseconds}ms...',
        );

        await Future.delayed(delay);
        delay *= 2; // Exponential backoff
      }
    }

    throw Exception('Should never reach here');
  }

  /// Graceful degradation wrapper
  static Future<T?> withGracefulDegradation<T>({
    required Future<T> Function() operation,
    T? fallbackValue,
    String? operationName,
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      Log.error(
        '${operationName ?? "Operation"} failed, using fallback: $e',
        e,
        stackTrace,
      );
      return fallbackValue;
    }
  }

  /// Timeout wrapper
  static Future<T> withTimeout<T>({
    required Future<T> Function() operation,
    Duration timeout = const Duration(seconds: 30),
    String? operationName,
  }) async {
    try {
      return await operation().timeout(timeout);
    } on TimeoutException {
      Log.error(
        '${operationName ?? "Operation"} timed out after ${timeout.inSeconds}s',
      );
      throw OperationTimeoutException(
        '${operationName ?? "Operation"} timed out',
      );
    }
  }
}

class OperationTimeoutException implements Exception {
  final String message;
  OperationTimeoutException(this.message);
  @override
  String toString() => message;
}
