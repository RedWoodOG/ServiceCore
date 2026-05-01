import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../util/log.dart';
import 'auth_service.dart';

/// MKPE Provenance Service - Truth Protection (not secrecy)
///
/// This service creates a tamper-evident audit trail for critical records.
/// It does NOT encrypt data - it proves data integrity and attribution.
class ProvenanceService {
  final AppDatabase db;
  final AuthService authService;

  ProvenanceService(this.db, this.authService);

  /// Record change with cryptographic proof
  /// Creates a hash-chained audit entry
  Future<void> recordChange({
    required String recordType,
    required int recordId,
    required String action,
    required Map<String, dynamic> recordState,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Compute content hash (SHA-256)
      final contentHash = _computeHash(recordState);

      // Get previous hash for chaining (links to last state)
      final previousHash = await _getPreviousHash(recordType, recordId);

      // Get current Windows user
      final sid = authService.getWindowsSID();
      final userName = authService.getWindowsUsername();

      // Record provenance entry
      await db
          .into(db.provenanceLog)
          .insert(
            ProvenanceLogCompanion.insert(
              recordType: recordType,
              recordId: recordId,
              action: action,
              contentHash: contentHash,
              previousHash: Value(previousHash),
              userSid: sid,
              userName: userName,
              timestamp: Value(DateTime.now()),
              changeMetadata: Value(
                metadata != null ? jsonEncode(metadata) : null,
              ),
            ),
          );

      Log.info(
        'Provenance recorded: $recordType#$recordId - $action by $userName',
      );
    } catch (e, stackTrace) {
      // IMPORTANT: Don't fail the operation if provenance fails
      // Provenance is for integrity, not functionality
      Log.error('Failed to record provenance (non-fatal)', e, stackTrace);
    }
  }

  /// Compute SHA-256 hash of record state
  /// Deterministic hashing ensures same state always produces same hash
  String _computeHash(Map<String, dynamic> state) {
    // Sort keys alphabetically for deterministic hashing
    final sorted = Map.fromEntries(
      state.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );

    // Convert to JSON (deterministic format)
    final json = jsonEncode(sorted);
    final bytes = utf8.encode(json);

    // Compute SHA-256 hash
    final digest = sha256.convert(bytes);

    return digest.toString();
  }

  /// Get previous hash for chaining
  /// Returns null if this is the first entry
  Future<String?> _getPreviousHash(String recordType, int recordId) async {
    final previous =
        await (db.select(db.provenanceLog)
              ..where((log) => log.recordType.equals(recordType))
              ..where((log) => log.recordId.equals(recordId))
              ..orderBy([(log) => OrderingTerm.desc(log.timestamp)])
              ..limit(1))
            .getSingleOrNull();

    return previous?.contentHash;
  }

  /// Verify integrity of provenance chain
  /// Returns true if chain is intact, false if tampering detected
  Future<bool> verifyIntegrity(String recordType, int recordId) async {
    final chain =
        await (db.select(db.provenanceLog)
              ..where((log) => log.recordType.equals(recordType))
              ..where((log) => log.recordId.equals(recordId))
              ..orderBy([(log) => OrderingTerm.asc(log.timestamp)]))
            .get();

    if (chain.isEmpty) {
      Log.info('No provenance history for $recordType#$recordId');
      return true; // No history yet is valid
    }

    // Verify chain integrity
    for (int i = 1; i < chain.length; i++) {
      final current = chain[i];
      final previous = chain[i - 1];

      if (current.previousHash != previous.contentHash) {
        Log.error(
          'TAMPERING DETECTED: Provenance chain broken at index $i for $recordType#$recordId',
        );
        Log.error('  Expected previous: ${previous.contentHash}');
        Log.error('  Found previous: ${current.previousHash}');
        return false; // Chain broken - tampering detected
      }
    }

    Log.info(
      'Provenance chain verified: $recordType#$recordId (${chain.length} entries, all valid)',
    );
    return true; // Chain intact
  }

  /// Get full provenance history for a record
  Future<List<ProvenanceLogData>> getProvenanceHistory(
    String recordType,
    int recordId,
  ) =>
      (db.select(db.provenanceLog)
            ..where((log) => log.recordType.equals(recordType))
            ..where((log) => log.recordId.equals(recordId))
            ..orderBy([(log) => OrderingTerm.desc(log.timestamp)]))
          .get();

  /// Get provenance for all records of a type
  Future<List<ProvenanceLogData>> getProvenanceByType(String recordType) =>
      (db.select(db.provenanceLog)
            ..where((log) => log.recordType.equals(recordType))
            ..orderBy([(log) => OrderingTerm.desc(log.timestamp)]))
          .get();

  /// Get provenance by user (Windows SID)
  Future<List<ProvenanceLogData>> getProvenanceByUser(String userSid) =>
      (db.select(db.provenanceLog)
            ..where((log) => log.userSid.equals(userSid))
            ..orderBy([(log) => OrderingTerm.desc(log.timestamp)]))
          .get();

  /// Verify entire database provenance (expensive operation)
  Future<Map<String, bool>> verifyAllIntegrity() async {
    final results = <String, bool>{};

    // Get all unique record types
    final allLogs = await db.select(db.provenanceLog).get();
    final recordTypes = <String, Set<int>>{};

    for (final log in allLogs) {
      recordTypes.putIfAbsent(log.recordType, () => <int>{});
      recordTypes[log.recordType]!.add(log.recordId);
    }

    // Verify each record
    for (final entry in recordTypes.entries) {
      for (final recordId in entry.value) {
        final key = '${entry.key}#$recordId';
        results[key] = await verifyIntegrity(entry.key, recordId);
      }
    }

    final total = results.length;
    final valid = results.values.where((v) => v).length;

    Log.info(
      'Verified $valid/$total records - ${valid == total ? "ALL VALID" : "TAMPERING DETECTED"}',
    );

    return results;
  }

  /// Export provenance bundle for external verification
  Future<String> exportProvenanceBundle(String recordType, int recordId) async {
    final history = await getProvenanceHistory(recordType, recordId);
    final integrity = await verifyIntegrity(recordType, recordId);

    final bundle = {
      'record_type': recordType,
      'record_id': recordId,
      'export_date': DateTime.now().toIso8601String(),
      'integrity_verified': integrity,
      'chain_length': history.length,
      'provenance_chain': history
          .map(
            (entry) => {
              'action': entry.action,
              'content_hash': entry.contentHash,
              'previous_hash': entry.previousHash,
              'user_sid': entry.userSid,
              'user_name': entry.userName,
              'timestamp': entry.timestamp.toIso8601String(),
              'metadata': entry.changeMetadata,
            },
          )
          .toList(),
    };

    return jsonEncode(bundle);
  }
}

/// Custom exception for provenance errors
class ProvenanceException implements Exception {
  final String message;
  ProvenanceException(this.message);
  @override
  String toString() => 'ProvenanceException: $message';
}
