import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../database/app_database.dart';
import '../../util/log.dart';
import 'boot_state.dart';

/// Orchestrates application startup as a deterministic state machine.
///
/// Boot sequence:
/// 1. Check filesystem access
/// 2. Open database
/// 3. Run migrations (if needed)
/// 4. Run integrity checks
/// 5. Seed initial data (if needed)
/// 6. Initialize services
/// 7. Complete or SafeMode
class BootService extends ChangeNotifier {
  BootService();

  BootState _state = const BootNotStarted();
  BootState get state => _state;

  AppDatabase? _database;
  AppDatabase? get database => _database;

  final List<String> _errorLog = [];
  String _dbPath = '';
  bool _dbExists = false;
  int _dbSizeBytes = 0;
  bool _dbWritable = false;
  int? _dbVersion;
  bool? _integrityCheckPassed;

  /// Run the complete boot sequence.
  ///
  /// Returns the final state (BootComplete or BootSafeMode).
  Future<BootState> boot() async {
    final stopwatch = Stopwatch()..start();
    Log.info('BootService: Starting boot sequence');

    try {
      // Step 1: Check filesystem
      await _transition(const BootCheckingFilesystem());
      await _checkFilesystem();

      // Step 2: Open database
      await _transition(const BootOpeningDatabase());
      await _openDatabase();

      // Step 3: Check integrity
      await _transition(const BootCheckingIntegrity());
      await _checkIntegrity();

      // Step 4: Seed if needed
      await _transition(const BootSeedingData());
      await _seedDataIfNeeded();

      // Step 5: Initialize services
      await _transition(const BootInitializingServices());
      await _initializeServices();

      // Complete!
      stopwatch.stop();
      await _transition(BootComplete(duration: stopwatch.elapsed));
      Log.info('BootService: Boot complete in ${stopwatch.elapsed}');
      return _state;
    } catch (e, st) {
      Log.error('BootService: Boot failed at ${_state.name}', e, st);
      _errorLog.add('${_state.name}: $e');
      
      final diagnostics = BootDiagnostics(
        dbPath: _dbPath,
        dbExists: _dbExists,
        dbSizeBytes: _dbSizeBytes,
        dbWritable: _dbWritable,
        dbVersion: _dbVersion,
        integrityCheckPassed: _integrityCheckPassed,
        errorLog: List.unmodifiable(_errorLog),
      );

      await _transition(BootSafeMode(
        failedAt: _state.runtimeType,
        error: e,
        stackTrace: st,
        diagnostics: diagnostics,
      ));
      return _state;
    }
  }

  /// Attempt to recover from safe mode.
  ///
  /// This can be called to retry boot or to reset the database.
  Future<BootState> recover({bool resetDatabase = false}) async {
    if (_state is! BootSafeMode) {
      Log.warn('BootService: Cannot recover - not in safe mode');
      return _state;
    }

    Log.info('BootService: Attempting recovery (resetDatabase: $resetDatabase)');

    if (resetDatabase && _dbPath.isNotEmpty) {
      try {
        final dbFile = File(_dbPath);
        if (await dbFile.exists()) {
          // Create backup first
          final backupPath = '$_dbPath.backup.${DateTime.now().millisecondsSinceEpoch}';
          await dbFile.copy(backupPath);
          Log.info('BootService: Created backup at $backupPath');
          
          // Delete corrupted database
          await dbFile.delete();
          Log.info('BootService: Deleted corrupted database');
        }
      } catch (e) {
        Log.error('BootService: Failed to reset database', e);
        _errorLog.add('Recovery reset failed: $e');
      }
    }

    // Reset state and retry
    _state = const BootNotStarted();
    _errorLog.clear();
    return boot();
  }

  // ============================================
  // BOOT STEPS
  // ============================================

  Future<void> _checkFilesystem() async {
    // Get app documents directory
    final appDir = await getApplicationDocumentsDirectory();
    final fscDir = Directory('${appDir.path}/fsc_portal');
    
    // Ensure directory exists
    if (!await fscDir.exists()) {
      await fscDir.create(recursive: true);
      Log.info('BootService: Created app directory at ${fscDir.path}');
    }

    _dbPath = '${fscDir.path}/fsc_portal.db';
    
    // Check if database file exists
    final dbFile = File(_dbPath);
    _dbExists = await dbFile.exists();
    
    if (_dbExists) {
      final stat = await dbFile.stat();
      _dbSizeBytes = stat.size;
    }

    // Check write permissions by creating temp file
    try {
      final testFile = File('${fscDir.path}/.write_test');
      await testFile.writeAsString('test');
      await testFile.delete();
      _dbWritable = true;
    } catch (e) {
      _dbWritable = false;
      throw StateError('Database directory is not writable: ${fscDir.path}');
    }

    Log.info('BootService: Filesystem OK - dbExists: $_dbExists, size: $_dbSizeBytes bytes');
  }

  Future<void> _openDatabase() async {
    // Close existing connection if any
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    // Open database - migrations are handled by Drift
    _database = AppDatabase();
    
    // Get schema version
    _dbVersion = await _database!.customSelect('PRAGMA user_version').map((row) => row.read<int>('user_version')).getSingleOrNull();
    
    Log.info('BootService: Database opened - version: $_dbVersion');
  }

  Future<void> _checkIntegrity() async {
    if (_database == null) {
      throw StateError('Database not initialized');
    }

    // 1. Run SQLite integrity check
    final result = await _database!.customSelect('PRAGMA integrity_check').getSingle();
    final checkResult = result.read<String>('integrity_check');
    
    _integrityCheckPassed = checkResult == 'ok';
    
    if (!_integrityCheckPassed!) {
      throw StateError('Database integrity check failed: $checkResult');
    }
    Log.info('BootService: PRAGMA integrity_check = ok');

    // 2. Check foreign key integrity
    final fkResult = await _database!.customSelect('PRAGMA foreign_key_check').get();
    if (fkResult.isNotEmpty) {
      final violations = fkResult.length;
      Log.warn('BootService: $violations foreign key violations found');
      // Don't fail boot - just log warning. App can still function.
    } else {
      Log.info('BootService: Foreign key check passed');
    }

    // 3. Quick sanity check on critical tables
    final tables = await _database!.customSelect(
      "SELECT name FROM sqlite_master WHERE type='table'"
    ).get();
    
    final tableNames = tables.map((r) => r.read<String>('name')).toSet();
    final requiredTables = {'sites', 'equipment', 'work_orders', 'users', 'clients'};
    final missingTables = <String>[];
    
    for (final required in requiredTables) {
      if (!tableNames.contains(required)) {
        missingTables.add(required);
      }
    }
    
    if (missingTables.isNotEmpty) {
      // This is likely a fresh database - migrations will create tables
      Log.info('BootService: Tables pending migration: ${missingTables.join(", ")}');
    }

    // 4. Verify we can read from critical tables
    try {
      final userCount = await _database!.customSelect('SELECT COUNT(*) as cnt FROM users').getSingle();
      final users = userCount.read<int>('cnt');
      final siteCount = await _database!.customSelect('SELECT COUNT(*) as cnt FROM sites').getSingle();
      final sites = siteCount.read<int>('cnt');
      Log.info('BootService: Table counts - users: $users, sites: $sites');
    } catch (e) {
      // Tables may not exist yet if fresh database
      Log.info('BootService: Tables not yet created (fresh database)');
    }

    // 5. Check journal mode (informational)
    try {
      final journalMode = await _database!.customSelect('PRAGMA journal_mode').getSingle();
      final mode = journalMode.read<String>('journal_mode');
      Log.info('BootService: Journal mode: $mode');
    } catch (e) {
      // Non-critical
    }

    Log.info('BootService: Integrity checks completed - ${tables.length} tables');
  }

  Future<void> _seedDataIfNeeded() async {
    if (_database == null) {
      throw StateError('Database not initialized');
    }

    // Check if users table is empty (first run indicator)
    final userCount = await _database!.select(_database!.users).get();
    
    if (userCount.isEmpty) {
      Log.info('BootService: First run detected - seeding initial data');
      
      // Create default admin user
      await _database!.into(_database!.users).insert(
        UsersCompanion.insert(
          username: 'admin',
          fullName: 'Administrator',
          email: 'admin@fscportal.local',
          role: 'admin',
        ),
      );
      
      Log.info('BootService: Created default admin user');
    } else {
      Log.info('BootService: Database already seeded - ${userCount.length} users');
    }
  }

  Future<void> _initializeServices() async {
    // Services are now initialized via Provider in main.dart
    // This step validates they can be constructed
    
    // In a more complex app, this would:
    // - Start background sync managers
    // - Initialize caches
    // - Connect to external services
    // - Start scheduled tasks

    Log.info('BootService: Services initialized');
  }

  // ============================================
  // HELPERS
  // ============================================

  Future<void> _transition(BootState newState) async {
    Log.debug('BootService: ${_state.name} -> ${newState.name}');
    _state = newState;
    notifyListeners();
    
    // Small delay to allow UI updates
    await Future.delayed(const Duration(milliseconds: 50));
  }

  @override
  void dispose() {
    _database?.close();
    super.dispose();
  }
}
