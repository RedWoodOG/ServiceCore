import 'app_failure.dart';

/// A result type that represents either success [Ok] or failure [Err].
///
/// Usage:
/// ```dart
/// final result = await workOrderService.create(cmd);
/// switch (result) {
///   case Ok(value: final id):
///     print('Created work order $id');
///   case Err(failure: final f):
///     showError(f.message);
/// }
/// ```
///
/// Or with helper methods:
/// ```dart
/// result.when(
///   ok: (id) => print('Created $id'),
///   err: (f) => showError(f.message),
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// Returns true if this is [Ok].
  bool get isOk => this is Ok<T>;

  /// Returns true if this is [Err].
  bool get isErr => this is Err<T>;

  /// Returns the value if [Ok], throws if [Err].
  T get valueOrThrow {
    switch (this) {
      case Ok(value: final v):
        return v;
      case Err(failure: final f):
        throw StateError('Called valueOrThrow on Err: ${f.message}');
    }
  }

  /// Returns the value if [Ok], or null if [Err].
  T? get valueOrNull {
    switch (this) {
      case Ok(value: final v):
        return v;
      case Err():
        return null;
    }
  }

  /// Returns the failure if [Err], or null if [Ok].
  AppFailure? get failureOrNull {
    switch (this) {
      case Ok():
        return null;
      case Err(failure: final f):
        return f;
    }
  }

  /// Pattern match on the result.
  R when<R>({
    required R Function(T value) ok,
    required R Function(AppFailure failure) err,
  }) {
    switch (this) {
      case Ok(value: final v):
        return ok(v);
      case Err(failure: final f):
        return err(f);
    }
  }

  /// Transform the success value.
  Result<R> map<R>(R Function(T value) transform) {
    switch (this) {
      case Ok(value: final v):
        return Ok(transform(v));
      case Err(failure: final f):
        return Err(f);
    }
  }

  /// Chain another Result-returning operation.
  Future<Result<R>> flatMap<R>(Future<Result<R>> Function(T value) transform) async {
    switch (this) {
      case Ok(value: final v):
        return transform(v);
      case Err(failure: final f):
        return Err(f);
    }
  }
}

/// Success result containing a value.
class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;

  @override
  String toString() => 'Ok($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Ok<T> && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Failure result containing an [AppFailure].
class Err<T> extends Result<T> {
  const Err(this.failure);

  final AppFailure failure;

  @override
  String toString() => 'Err($failure)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Err<T> && failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}

/// Extension for converting futures to Result.
extension FutureResultExtension<T> on Future<T> {
  /// Wraps this future in a Result, catching exceptions as StorageFailure.
  Future<Result<T>> toResult([String? context]) async {
    try {
      return Ok(await this);
    } on Exception catch (e, st) {
      final msg = context != null ? '$context: $e' : e.toString();
      return Err(StorageFailure(msg, cause: e, stackTrace: st));
    }
  }
}

/// Convenience constructors.
extension ResultConstructors on Never {
  /// Create a success result.
  static Result<T> ok<T>(T value) => Ok(value);

  /// Create a failure result.
  static Result<T> err<T>(AppFailure failure) => Err(failure);
}
