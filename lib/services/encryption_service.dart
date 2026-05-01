import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../util/log.dart';
import 'auth_service.dart';

class EncryptionService {
  final AuthService authService;

  static const String _dbKeyStorageKey = 'fsc_portal_db_key_encrypted';
  static const String _appSalt = 'fsc_portal_v1_2026_security';

  // Windows DPAPI storage (hardware-backed if TPM available)
  static const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    wOptions: WindowsOptions(useBackwardCompatibility: false),
  );

  EncryptionService(this.authService);

  /// Derive master key from Windows identity (KDF approach)
  /// This key is NEVER stored - always derived on-demand
  Future<SecretKey> deriveMasterKey() async {
    final sid = authService.getWindowsSID();
    final machineId = authService.getMachineGUID();

    Log.info('Deriving master key from SID + Machine ID');

    // Use Argon2id (OWASP recommended for key derivation)
    final argon2 = Argon2id(
      memory: 65536, // 64MB (OWASP minimum)
      iterations: 3, // OWASP recommendation for 64MB
      parallelism: 4,
      hashLength: 32, // 256 bits
    );

    // Combine SID + Machine ID for input
    final input = '$sid|$machineId';

    try {
      final masterKey = await argon2.deriveKey(
        secretKey: SecretKey(utf8.encode(input)),
        nonce: utf8.encode(_appSalt),
      );

      Log.info('Master key derived successfully (256-bit Argon2id)');
      return masterKey;
    } catch (e, stackTrace) {
      Log.error('Master key derivation failed', e, stackTrace);
      rethrow;
    }
  }

  /// Get or create database encryption key
  /// This key IS stored (encrypted by master key)
  Future<String> getDatabaseKey() async {
    try {
      // Try to read existing encrypted key from Windows DPAPI storage
      var encryptedDbKey = await storage.read(key: _dbKeyStorageKey);

      if (encryptedDbKey == null) {
        Log.info('No database key found, generating new 256-bit key');

        // First run: generate cryptographically secure random key
        final dbKey = _generateSecureRandomKey(32); // 256 bits

        // Encrypt it with master key (derived from SID + Machine ID)
        final masterKey = await deriveMasterKey();
        encryptedDbKey = await _encryptDatabaseKey(dbKey, masterKey);

        // Store encrypted key in Windows DPAPI (hardware-backed)
        await storage.write(key: _dbKeyStorageKey, value: encryptedDbKey);

        Log.info('Database key generated and stored (encrypted by master key)');
        return dbKey;
      } else {
        // Decrypt stored key using master key
        Log.info('Decrypting stored database key');
        final masterKey = await deriveMasterKey();
        return await _decryptDatabaseKey(encryptedDbKey, masterKey);
      }
    } catch (e, stackTrace) {
      Log.error('Database key retrieval failed', e, stackTrace);
      throw EncryptionException('Failed to get database encryption key: $e');
    }
  }

  /// Generate cryptographically secure random key
  String _generateSecureRandomKey(int bytes) {
    final random = Random.secure();
    final keyBytes = Uint8List(bytes);

    for (int i = 0; i < bytes; i++) {
      keyBytes[i] = random.nextInt(256);
    }

    // Return as base64 for storage
    return base64Encode(keyBytes);
  }

  /// Encrypt database key with master key (AES-256-GCM)
  Future<String> _encryptDatabaseKey(String dbKey, SecretKey masterKey) async {
    try {
      final cipher = AesGcm.with256bits();

      final secretBox = await cipher.encrypt(
        utf8.encode(dbKey),
        secretKey: masterKey,
      );

      // Combine nonce + ciphertext + MAC for storage
      final combined = Uint8List.fromList([
        ...secretBox.nonce,
        ...secretBox.cipherText,
        ...secretBox.mac.bytes,
      ]);

      return base64Encode(combined);
    } catch (e, stackTrace) {
      Log.error('Database key encryption failed', e, stackTrace);
      throw EncryptionException('Failed to encrypt database key: $e');
    }
  }

  /// Decrypt database key with master key
  Future<String> _decryptDatabaseKey(
    String encryptedKey,
    SecretKey masterKey,
  ) async {
    try {
      final combined = base64Decode(encryptedKey);

      // Extract components (AES-GCM: 12-byte nonce, ciphertext, 16-byte MAC)
      final nonce = combined.sublist(0, 12);
      final mac = Mac(combined.sublist(combined.length - 16));
      final cipherText = combined.sublist(12, combined.length - 16);

      final secretBox = SecretBox(cipherText, nonce: nonce, mac: mac);

      final cipher = AesGcm.with256bits();
      final decrypted = await cipher.decrypt(secretBox, secretKey: masterKey);

      return utf8.decode(decrypted);
    } catch (e, stackTrace) {
      Log.error('Database key decryption failed', e, stackTrace);
      throw EncryptionException('Failed to decrypt database key: $e');
    }
  }

  /// Export database key (admin function, password-protected)
  /// This allows recovery if hardware changes
  Future<String> exportDatabaseKey(String adminPassword) async {
    Log.info('Exporting database key (admin operation)');

    try {
      // Get database key
      final dbKey = await getDatabaseKey();

      // Derive export key from admin password (PBKDF2)
      final pbkdf2 = Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: 100000, // NIST recommendation
        bits: 256,
      );

      final exportKey = await pbkdf2.deriveKey(
        secretKey: SecretKey(utf8.encode(adminPassword)),
        nonce: utf8.encode('fsc_export_salt_v1'),
      );

      // Encrypt database key with export key
      final cipher = AesGcm.with256bits();
      final secretBox = await cipher.encrypt(
        utf8.encode(dbKey),
        secretKey: exportKey,
      );

      // Combine for transport
      final combined = Uint8List.fromList([
        ...secretBox.nonce,
        ...secretBox.cipherText,
        ...secretBox.mac.bytes,
      ]);

      final exportedKey = base64Encode(combined);

      Log.info('Database key exported successfully (password-protected)');
      return exportedKey;
    } catch (e, stackTrace) {
      Log.error('Database key export failed', e, stackTrace);
      throw EncryptionException('Failed to export database key: $e');
    }
  }

  /// Import database key (recovery function)
  Future<void> importDatabaseKey(
    String encryptedExport,
    String adminPassword,
  ) async {
    Log.info('Importing database key (recovery operation)');

    try {
      // Derive export key from admin password
      final pbkdf2 = Pbkdf2(
        macAlgorithm: Hmac.sha256(),
        iterations: 100000,
        bits: 256,
      );

      final exportKey = await pbkdf2.deriveKey(
        secretKey: SecretKey(utf8.encode(adminPassword)),
        nonce: utf8.encode('fsc_export_salt_v1'),
      );

      // Decrypt the export
      final combined = base64Decode(encryptedExport);
      final nonce = combined.sublist(0, 12);
      final mac = Mac(combined.sublist(combined.length - 16));
      final cipherText = combined.sublist(12, combined.length - 16);

      final secretBox = SecretBox(cipherText, nonce: nonce, mac: mac);
      final cipher = AesGcm.with256bits();
      final dbKeyBytes = await cipher.decrypt(secretBox, secretKey: exportKey);
      final dbKey = utf8.decode(dbKeyBytes);

      // Re-encrypt with current master key and store
      final masterKey = await deriveMasterKey();
      final encryptedDbKey = await _encryptDatabaseKey(dbKey, masterKey);

      await storage.write(key: _dbKeyStorageKey, value: encryptedDbKey);

      Log.info(
        'Database key imported and re-encrypted with current master key',
      );
    } catch (e, stackTrace) {
      Log.error('Database key import failed', e, stackTrace);
      throw EncryptionException(
        'Failed to import database key (wrong password?): $e',
      );
    }
  }

  /// Delete stored keys (for testing or reset)
  Future<void> deleteStoredKeys() async {
    Log.warn(
      'Deleting stored encryption keys - database will become inaccessible',
    );
    await storage.delete(key: _dbKeyStorageKey);
  }

  /// Get key fingerprint for verification (doesn't reveal key)
  Future<String> getKeyFingerprint() async {
    try {
      final dbKey = await getDatabaseKey();
      final bytes = utf8.encode(dbKey);

      // Use SHA-256 for fingerprint
      final algorithm = Sha256();
      final hash = await algorithm.hash(bytes);

      return base64Encode(hash.bytes);
    } catch (e) {
      return 'ERROR';
    }
  }
}

/// Custom exception for encryption errors
class EncryptionException implements Exception {
  final String message;
  EncryptionException(this.message);
  @override
  String toString() => 'EncryptionException: $message';
}
