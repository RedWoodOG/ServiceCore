/// The boot state machine for FSC-Portal startup.
///
/// Boot is deterministic: each state represents a checkpoint in the
/// startup sequence. If any checkpoint fails, boot transitions to
/// SafeMode with diagnostics.
sealed class BootState {
  const BootState();
}

/// Initial state before boot begins.
class BootNotStarted extends BootState {
  const BootNotStarted();
}

/// Checking filesystem and database file accessibility.
class BootCheckingFilesystem extends BootState {
  const BootCheckingFilesystem();
}

/// Opening and validating the database connection.
class BootOpeningDatabase extends BootState {
  const BootOpeningDatabase();
}

/// Running schema migrations if needed.
class BootRunningMigrations extends BootState {
  const BootRunningMigrations({
    required this.fromVersion,
    required this.toVersion,
  });

  final int fromVersion;
  final int toVersion;
}

/// Running integrity checks on database.
class BootCheckingIntegrity extends BootState {
  const BootCheckingIntegrity();
}

/// Seeding initial data if database is empty.
class BootSeedingData extends BootState {
  const BootSeedingData();
}

/// Initializing background services and managers.
class BootInitializingServices extends BootState {
  const BootInitializingServices();
}

/// Boot completed successfully, app is ready.
class BootComplete extends BootState {
  const BootComplete({
    required this.duration,
  });

  final Duration duration;
}

/// Boot failed, entering safe mode.
class BootSafeMode extends BootState {
  const BootSafeMode({
    required this.failedAt,
    required this.error,
    required this.stackTrace,
    required this.diagnostics,
  });

  final Type failedAt;
  final Object error;
  final StackTrace stackTrace;
  final BootDiagnostics diagnostics;
}

/// Diagnostic information collected during boot.
class BootDiagnostics {
  const BootDiagnostics({
    required this.dbPath,
    required this.dbExists,
    required this.dbSizeBytes,
    required this.dbWritable,
    required this.dbVersion,
    required this.integrityCheckPassed,
    required this.errorLog,
  });

  final String dbPath;
  final bool dbExists;
  final int dbSizeBytes;
  final bool dbWritable;
  final int? dbVersion;
  final bool? integrityCheckPassed;
  final List<String> errorLog;

  Map<String, dynamic> toJson() => {
    'dbPath': dbPath,
    'dbExists': dbExists,
    'dbSizeBytes': dbSizeBytes,
    'dbWritable': dbWritable,
    'dbVersion': dbVersion,
    'integrityCheckPassed': integrityCheckPassed,
    'errorLog': errorLog,
  };
}

/// Extension for state names (useful for logging).
extension BootStateExtension on BootState {
  String get name {
    return switch (this) {
      BootNotStarted() => 'NotStarted',
      BootCheckingFilesystem() => 'CheckingFilesystem',
      BootOpeningDatabase() => 'OpeningDatabase',
      BootRunningMigrations() => 'RunningMigrations',
      BootCheckingIntegrity() => 'CheckingIntegrity',
      BootSeedingData() => 'SeedingData',
      BootInitializingServices() => 'InitializingServices',
      BootComplete() => 'Complete',
      BootSafeMode() => 'SafeMode',
    };
  }

  bool get isTerminal => this is BootComplete || this is BootSafeMode;
  bool get isInProgress => !isTerminal && this is! BootNotStarted;
}
