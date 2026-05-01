/// Application failure taxonomy.
///
/// Every service operation that can fail returns a typed [AppFailure].
/// This enables consistent error handling across the entire application.
sealed class AppFailure {
  const AppFailure(this.message, {this.cause, this.stackTrace});

  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => '$runtimeType: $message';
}

/// Input validation failed (bad data from user/caller).
/// Examples: empty required field, invalid email format, negative quantity.
class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message, {super.cause, super.stackTrace, this.field});

  /// The specific field that failed validation, if applicable.
  final String? field;
}

/// User does not have permission to perform this action.
/// Examples: tech trying to delete a client, non-admin editing users.
class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure(super.message, {super.cause, super.stackTrace});
}

/// Requested entity does not exist.
/// Examples: work order ID not found, site deleted before update.
class NotFoundFailure extends AppFailure {
  const NotFoundFailure(super.message, {super.cause, super.stackTrace});
}

/// Operation conflicts with current state.
/// Examples: invalid status transition, duplicate record, optimistic lock fail.
class ConflictFailure extends AppFailure {
  const ConflictFailure(super.message, {super.cause, super.stackTrace});
}

/// Storage layer failure (disk full, file locked, cannot open).
/// User may be able to retry after freeing space or closing other apps.
class StorageFailure extends AppFailure {
  const StorageFailure(super.message, {super.cause, super.stackTrace});
}

/// Data integrity failure (corruption detected).
/// Requires recovery action: restore backup or start fresh.
class CorruptionFailure extends AppFailure {
  const CorruptionFailure(super.message, {super.cause, super.stackTrace});
}

/// External service failure (weather API, PDF parsing, etc.).
/// The app can continue operating; this is a degraded state.
class ExternalFailure extends AppFailure {
  const ExternalFailure(super.message, {super.cause, super.stackTrace});
}

/// Operation was cancelled (user cancelled, timeout, etc.).
class CancelledFailure extends AppFailure {
  const CancelledFailure(super.message, {super.cause, super.stackTrace});
}

/// Extension for creating failures from exceptions.
extension AppFailureFromException on Exception {
  AppFailure toStorageFailure([String? context]) {
    final msg = context != null ? '$context: $this' : toString();
    return StorageFailure(msg, cause: this);
  }

  AppFailure toExternalFailure([String? context]) {
    final msg = context != null ? '$context: $this' : toString();
    return ExternalFailure(msg, cause: this);
  }
}
