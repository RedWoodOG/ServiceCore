# Phase 2: Security Architecture - Implementation Plan

**Start Date:** January 30, 2026  
**Target:** FSC-Portal v1.3.0  
**Current Schema:** V12  
**Target Schema:** V13  
**Estimated Time:** 2-3 hours  
**Risk Level:** 🟢 LOW (Phase 1 protected)

---

## CRITICAL CONSTRAINTS

### Phase 1 Protection Rules

**MUST MAINTAIN:**
- ✅ Edit work orders functionality
- ✅ Status workflow validation
- ✅ Audit trail system
- ✅ All existing features

**FORBIDDEN:**
- ❌ Breaking Phase 1 code
- ❌ Modifying validated workflow logic
- ❌ Removing Phase 1 functionality

**STRATEGY:**
- Create NEW files (don't modify Phase 1)
- Additive database changes only
- Test Phase 1 after every step

---

## ARCHITECTURE OVERVIEW

### Three Security Layers (Architect's Design)

```
Layer 1: IDENTITY (Windows SID)
  ↓
Layer 2: ENCRYPTION (Hybrid KDF + SQLCipher)
  ↓
Layer 3: PROVENANCE (MKPE Audit Trail)
```

**All three layers are INDEPENDENT** - can be implemented separately and tested independently.

---

## IMPLEMENTATION SEQUENCE

### Part 1: Database Schema (V12 → V13) [30 min]

**Goal:** Add schema support for security features without breaking Phase 1

**Changes:**
1. Add columns to Users table:
   - `windowsSid TEXT UNIQUE` - Windows Security Identifier
   - `lastLoginAt DATETIME` - Last login timestamp
   - `loginCount INTEGER DEFAULT 0` - Login tracking

2. Create ProvenanceLog table:
   ```dart
   class ProvenanceLog extends Table {
     IntColumn get id => integer().autoIncrement()();
     TextColumn get recordType => text()(); // 'work_order', 'knowledge_entry', etc
     IntColumn get recordId => integer()();
     TextColumn get action => text()(); // 'create', 'update', 'delete'
     TextColumn get contentHash => text()(); // SHA-256 hash
     TextColumn get previousHash => text().nullable()(); // Chain link
     TextColumn get userSid => text()(); // Windows SID
     TextColumn get userName => text()(); // Display name
     DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
     TextColumn get changeMetadata => text().nullable()(); // JSON
   }
   ```

3. Create EncryptionKeyStore table (for key backup):
   ```dart
   class EncryptionKeyStore extends Table {
     IntColumn get id => integer().autoIncrement()();
     TextColumn get keyPurpose => text()(); // 'database', 'export', etc
     TextColumn get encryptedKey => text()(); // Encrypted with master key
     TextColumn get keyFingerprint => text()(); // SHA-256 of key (for verification)
     DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
     DateTimeColumn get lastAccessedAt => dateTime().nullable()();
     IntColumn get accessCount => integer().withDefault(const Constant(0))();
   }
   ```

4. Update schemaVersion: 12 → 13

5. Add migration V12→V13

**Testing After Part 1:**
- Build succeeds
- App launches
- **Phase 1 edit work orders still works** ✅

---

### Part 2: Windows SID Authentication [45 min]

**Goal:** Implement Windows identity resolution (no passwords)

**New File:** `lib/services/auth_service.dart`

```dart
import 'package:win32/win32.dart';
import 'package:ffi/ffi.dart';
import '../database/app_database.dart';
import '../util/log.dart';

class AuthService {
  final AppDatabase db;
  
  AuthService(this.db);
  
  /// Get current Windows user SID
  String getWindowsSID() {
    final TOKEN_QUERY = 0x0008;
    final TokenUser = 1;
    
    // Get current process token
    final hToken = calloc<IntPtr>();
    try {
      final result = OpenProcessToken(
        GetCurrentProcess(),
        TOKEN_QUERY,
        hToken,
      );
      
      if (result == 0) {
        throw Exception('Failed to open process token');
      }
      
      // Get token information (user SID)
      final pTokenUser = calloc<DWORD>();
      final returnLength = calloc<DWORD>();
      
      try {
        GetTokenInformation(
          hToken.value,
          TokenUser,
          pTokenUser,
          0,
          returnLength,
        );
        
        final tokenUser = calloc<BYTE>(returnLength.value);
        try {
          GetTokenInformation(
            hToken.value,
            TokenUser,
            tokenUser,
            returnLength.value,
            returnLength,
          );
          
          // Convert SID to string
          final pSidString = calloc<Pointer<Utf16>>();
          try {
            ConvertSidToStringSid(
              tokenUser.cast(),
              pSidString,
            );
            
            return pSidString.value.toDartString();
          } finally {
            LocalFree(pSidString.value.cast());
            free(pSidString);
          }
        } finally {
          free(tokenUser);
        }
      } finally {
        free(pTokenUser);
        free(returnLength);
      }
    } finally {
      CloseHandle(hToken.value);
      free(hToken);
    }
  }
  
  /// Get current Windows username
  String getWindowsUsername() {
    final maxLength = 256;
    final username = wsalloc(maxLength);
    final size = calloc<DWORD>()..value = maxLength;
    
    try {
      final result = GetUserName(username, size);
      if (result == 0) {
        throw Exception('Failed to get username');
      }
      return username.toDartString();
    } finally {
      free(username);
      free(size);
    }
  }
  
  /// Get or create user based on Windows SID
  Future<User> authenticateWindowsUser() async {
    final sid = getWindowsSID();
    final username = getWindowsUsername();
    
    Log.info('Authenticating Windows user: $username (SID: $sid)');
    
    // Check if user exists
    var user = await db.getUserBySID(sid);
    
    if (user == null) {
      // Create new user from Windows identity
      Log.info('Creating new user from Windows identity: $username');
      
      final userId = await db.into(db.users).insert(
        UsersCompanion.insert(
          username: username,
          fullName: username, // Can be updated later
          email: '$username@local',
          role: 'tech', // Default role, admin can change
          windowsSid: Value(sid),
          lastLoginAt: Value(DateTime.now()),
          loginCount: const Value(1),
        ),
      );
      
      user = await db.getUserById(userId);
    } else {
      // Update login tracking
      await db.update(db.users).replace(
        user.copyWith(
          lastLoginAt: Value(DateTime.now()),
          loginCount: user.loginCount + 1,
        ),
      );
      
      user = await db.getUserBySID(sid);
    }
    
    Log.info('User authenticated: ${user!.fullName} (ID: ${user.id})');
    return user;
  }
  
  /// Get machine GUID (for key derivation)
  String getMachineGUID() {
    // Read from Windows registry
    // HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography\MachineGuid
    
    final hKey = calloc<IntPtr>();
    final guidBuffer = wsalloc(256);
    final bufferSize = calloc<DWORD>()..value = 512;
    
    try {
      // Open registry key
      final result = RegOpenKeyEx(
        HKEY_LOCAL_MACHINE,
        TEXT('SOFTWARE\\Microsoft\\Cryptography'),
        0,
        KEY_READ,
        hKey,
      );
      
      if (result != ERROR_SUCCESS) {
        Log.warn('Could not read MachineGuid from registry, using fallback');
        return 'FALLBACK-MACHINE-ID';
      }
      
      // Read MachineGuid value
      final valueResult = RegQueryValueEx(
        hKey.value,
        TEXT('MachineGuid'),
        nullptr,
        nullptr,
        guidBuffer.cast(),
        bufferSize,
      );
      
      if (valueResult != ERROR_SUCCESS) {
        return 'FALLBACK-MACHINE-ID';
      }
      
      return guidBuffer.toDartString();
    } finally {
      if (hKey.value != 0) {
        RegCloseKey(hKey.value);
      }
      free(hKey);
      free(guidBuffer);
      free(bufferSize);
    }
  }
}
```

**Dependencies to Add:**
```yaml
dependencies:
  win32: ^5.5.0  # Windows API access
  ffi: ^2.1.0    # Already included
```

**Testing After Part 2:**
- Build succeeds
- App launches
- **Phase 1 still works** ✅
- Auth service resolves SID (verify in logs)

---

### Part 3: Hybrid Encryption Service [60 min]

**Goal:** Implement master key derivation + database key storage

**New File:** `lib/services/encryption_service.dart`

```dart
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../util/log.dart';
import 'auth_service.dart';

class EncryptionService {
  final AuthService authService;
  
  static const String _dbKeyStorageKey = 'db_key_encrypted';
  static const String _appSalt = 'fsc_portal_v1_2026';
  
  EncryptionService(this.authService);
  
  /// Derive master key from Windows identity (KDF)
  Future<SecretKey> deriveMasterKey() async {
    final sid = authService.getWindowsSID();
    final machineId = authService.getMachineGUID();
    
    Log.info('Deriving master key from SID + Machine ID');
    
    // Use Argon2id (best practice for key derivation)
    final argon2 = Argon2id(
      memory: 65536,     // 64MB
      iterations: 3,      // OWASP recommendation
      parallelism: 4,
      hashLength: 32,     // 256 bits
    );
    
    final masterKey = await argon2.deriveKey(
      secretKey: SecretKey(utf8.encode(sid + machineId)),
      nonce: utf8.encode(_appSalt),
    );
    
    Log.info('Master key derived successfully');
    return masterKey;
  }
  
  /// Get or create database encryption key
  Future<String> getDatabaseKey() async {
    const storage = FlutterSecureStorage(
      wOptions: WindowsOptions(useBackwardCompatibility: false),
    );
    
    // Try to read existing encrypted key
    var encryptedDbKey = await storage.read(key: _dbKeyStorageKey);
    
    if (encryptedDbKey == null) {
      Log.info('No database key found, generating new key');
      
      // First run: generate random database key
      final dbKey = _generateSecureRandomKey(32); // 256 bits
      
      // Encrypt it with master key
      final masterKey = await deriveMasterKey();
      encryptedDbKey = await _encryptDatabaseKey(dbKey, masterKey);
      
      // Store encrypted key
      await storage.write(key: _dbKeyStorageKey, value: encryptedDbKey);
      
      Log.info('Database key generated and stored (encrypted)');
      return dbKey;
    } else {
      // Decrypt stored key using master key
      Log.info('Decrypting stored database key');
      final masterKey = await deriveMasterKey();
      return await _decryptDatabaseKey(encryptedDbKey, masterKey);
    }
  }
  
  /// Generate cryptographically secure random key
  String _generateSecureRandomKey(int bytes) {
    final random = Random.secure();
    final keyBytes = Uint8List(bytes);
    for (int i = 0; i < bytes; i++) {
      keyBytes[i] = random.nextInt(256);
    }
    return base64Encode(keyBytes);
  }
  
  /// Encrypt database key with master key
  Future<String> _encryptDatabaseKey(String dbKey, SecretKey masterKey) async {
    final cipher = AesCtr.with256bits(macAlgorithm: Hmac.sha256());
    
    final secretBox = await cipher.encrypt(
      utf8.encode(dbKey),
      secretKey: masterKey,
    );
    
    // Combine nonce + ciphertext + MAC
    final combined = Uint8List.fromList([
      ...secretBox.nonce,
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ]);
    
    return base64Encode(combined);
  }
  
  /// Decrypt database key with master key
  Future<String> _decryptDatabaseKey(String encryptedKey, SecretKey masterKey) async {
    final combined = base64Decode(encryptedKey);
    
    // Extract components
    final nonce = combined.sublist(0, 12);
    final mac = Mac(combined.sublist(combined.length - 32));
    final cipherText = combined.sublist(12, combined.length - 32);
    
    final secretBox = SecretBox(cipherText, nonce: nonce, mac: mac);
    
    final cipher = AesCtr.with256bits(macAlgorithm: Hmac.sha256());
    final decrypted = await cipher.decrypt(secretBox, secretKey: masterKey);
    
    return utf8.decode(decrypted);
  }
  
  /// Export database key (admin function, password-protected)
  Future<String> exportDatabaseKey(String adminPassword) async {
    Log.info('Exporting database key (admin operation)');
    
    // Get database key
    final dbKey = await getDatabaseKey();
    
    // Encrypt with admin password (for transport/backup)
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 256,
    );
    
    final exportKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(adminPassword)),
      nonce: utf8.encode('export_salt'),
    );
    
    final cipher = AesCtr.with256bits(macAlgorithm: Hmac.sha256());
    final secretBox = await cipher.encrypt(
      utf8.encode(dbKey),
      secretKey: exportKey,
    );
    
    final combined = Uint8List.fromList([
      ...secretBox.nonce,
      ...secretBox.cipherText,
      ...secretBox.mac.bytes,
    ]);
    
    return base64Encode(combined);
  }
  
  /// Import database key (recovery function)
  Future<void> importDatabaseKey(String encryptedExport, String adminPassword) async {
    Log.info('Importing database key (recovery operation)');
    
    // Decrypt with admin password
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: 256,
    );
    
    final exportKey = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(adminPassword)),
      nonce: utf8.encode('export_salt'),
    );
    
    final combined = base64Decode(encryptedExport);
    final nonce = combined.sublist(0, 12);
    final mac = Mac(combined.sublist(combined.length - 32));
    final cipherText = combined.sublist(12, combined.length - 32);
    
    final secretBox = SecretBox(cipherText, nonce: nonce, mac: mac);
    final cipher = AesCtr.with256bits(macAlgorithm: Hmac.sha256());
    final dbKey = await cipher.decrypt(secretBox, secretKey: exportKey);
    final dbKeyString = utf8.decode(dbKey);
    
    // Re-encrypt with current master key and store
    final masterKey = await deriveMasterKey();
    final encryptedDbKey = await _encryptDatabaseKey(dbKeyString, masterKey);
    
    const storage = FlutterSecureStorage(
      wOptions: WindowsOptions(useBackwardCompatibility: false),
    );
    await storage.write(key: _dbKeyStorageKey, value: encryptedDbKey);
    
    Log.info('Database key imported successfully');
  }
}
```

**Dependencies to Add:**
```yaml
dependencies:
  cryptography: ^2.7.0  # Argon2, AES, etc
  flutter_secure_storage: ^9.2.2  # Windows DPAPI wrapper
  flutter_secure_storage_windows: ^3.1.2  # Windows implementation
```

**Testing After Part 2:**
- Build succeeds
- Auth service resolves SID
- Encryption service generates keys
- **Phase 1 still works** ✅
- No encryption active yet (additive only)

---

### Part 3: MKPE Provenance Service [45 min]

**Goal:** Implement tamper-evident change tracking

**New File:** `lib/services/provenance_service.dart`

```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../util/log.dart';
import 'auth_service.dart';

class ProvenanceService {
  final AppDatabase db;
  final AuthService authService;
  
  ProvenanceService(this.db, this.authService);
  
  /// Record change with cryptographic proof
  Future<void> recordChange({
    required String recordType,
    required int recordId,
    required String action,
    required Map<String, dynamic> recordState,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Compute content hash
      final contentHash = _computeHash(recordState);
      
      // Get previous hash (for chaining)
      final previousHash = await _getPreviousHash(recordType, recordId);
      
      // Get current Windows user
      final sid = authService.getWindowsSID();
      final userName = authService.getWindowsUsername();
      
      // Record provenance
      await db.into(db.provenanceLog).insert(
        ProvenanceLogCompanion.insert(
          recordType: recordType,
          recordId: recordId,
          action: action,
          contentHash: contentHash,
          previousHash: Value(previousHash),
          userSid: sid,
          userName: userName,
          timestamp: Value(DateTime.now()),
          changeMetadata: Value(metadata != null ? jsonEncode(metadata) : null),
        ),
      );
      
      Log.info('Provenance recorded: $recordType#$recordId - $action');
    } catch (e, stackTrace) {
      Log.error('Failed to record provenance', e, stackTrace);
      // Don't fail the operation if provenance fails
    }
  }
  
  /// Compute SHA-256 hash of record state
  String _computeHash(Map<String, dynamic> state) {
    // Sort keys for deterministic hashing
    final sorted = Map.fromEntries(
      state.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    
    final json = jsonEncode(sorted);
    final bytes = utf8.encode(json);
    final hash = sha256.convert(bytes);
    
    return hash.toString();
  }
  
  /// Get previous hash for chaining
  Future<String?> _getPreviousHash(String recordType, int recordId) async {
    final previous = await (db.select(db.provenanceLog)
      ..where((log) => log.recordType.equals(recordType))
      ..where((log) => log.recordId.equals(recordId))
      ..orderBy([(log) => OrderingTerm.desc(log.timestamp)])
      ..limit(1))
    .getSingleOrNull();
    
    return previous?.contentHash;
  }
  
  /// Verify integrity of provenance chain
  Future<bool> verifyIntegrity(String recordType, int recordId) async {
    final chain = await (db.select(db.provenanceLog)
      ..where((log) => log.recordType.equals(recordType))
      ..where((log) => log.recordId.equals(recordId))
      ..orderBy([(log) => OrderingTerm.asc(log.timestamp)]))
    .get();
    
    if (chain.isEmpty) return true; // No history yet
    
    // Verify chain integrity
    for (int i = 1; i < chain.length; i++) {
      if (chain[i].previousHash != chain[i - 1].contentHash) {
        Log.error('Provenance chain broken at index $i for $recordType#$recordId');
        return false; // Chain broken - tampering detected
      }
    }
    
    Log.info('Provenance chain verified: $recordType#$recordId (${chain.length} entries)');
    return true; // Chain intact
  }
  
  /// Get full provenance history
  Future<List<ProvenanceLogData>> getProvenanceHistory(String recordType, int recordId) =>
      (db.select(db.provenanceLog)
        ..where((log) => log.recordType.equals(recordType))
        ..where((log) => log.recordId.equals(recordId))
        ..orderBy([(log) => OrderingTerm.desc(log.timestamp)]))
      .get();
}
```

**Dependencies to Add:**
```yaml
dependencies:
  crypto: ^3.0.3  # SHA-256 hashing
```

**Integration Points (Careful - Don't Break Phase 1):**

**In WorkOrderWorkflowService (ADD provenance hooks):**
```dart
// Add after successful status transition
if (_provenanceService != null) {
  await _provenanceService.recordChange(
    recordType: 'work_order',
    recordId: workOrder.id,
    action: 'status_change',
    recordState: {
      'id': workOrder.id,
      'status': newStatus,
      'previous_status': workOrder.status,
      'version': current.version + 1,
    },
    metadata: {
      'user_id': userId,
      'reason': reason,
      'notes': notes,
    },
  );
}
```

**Testing After Part 3:**
- Build succeeds
- **Phase 1 still works** ✅
- Provenance logs created (optional, doesn't break if fails)
- Chain verification works

---

### Part 4: Wire Authentication [30 min]

**Goal:** Initialize auth on startup without breaking existing flow

**Modify:** `lib/main.dart`

**Changes (ADDITIVE):**
```dart
// Add imports at top
import 'services/auth_service.dart';
import 'services/encryption_service.dart';
import 'services/provenance_service.dart';

// In main() function, BEFORE database init
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ... existing error handling ...

  // PHASE 2: Initialize authentication
  User? currentUser;
  AuthService? authService;
  
  try {
    final database = AppDatabase(); // Temporary for auth
    authService = AuthService(database);
    currentUser = await authService.authenticateWindowsUser();
    Log.info('Authenticated as: ${currentUser.fullName}');
    await database.close();
  } catch (e, stackTrace) {
    Log.error('Authentication failed, using fallback', e, stackTrace);
    // Fallback: continue with default user (don't break app)
  }

  // Initialize database (existing code unchanged)
  final database = AppDatabase();
  
  // ... rest of existing code ...
  
  // PHASE 2: Add auth service to providers
  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        ChangeNotifierProvider(create: (_) => evaState),
        ChangeNotifierProvider(create: (_) => NavigationState()),
        // PHASE 2 ADDITIONS
        if (authService != null)
          Provider<AuthService>.value(value: authService),
        if (currentUser != null)
          Provider<User>.value(value: currentUser),
      ],
      child: const PortalOfflineApp(),
    ),
  );
}
```

**Testing After Part 4:**
- Build succeeds
- Auth runs on startup
- Logs show Windows user detected
- **Phase 1 still works** ✅
- If auth fails, app still launches (graceful degradation)

---

### Part 5: Enable Database Encryption [45 min]

**Goal:** Switch to SQLCipher with encrypted database

**Dependencies:**
```yaml
dependencies:
  sqlcipher_flutter_libs: ^0.6.0
```

**Modify:** `lib/database/app_database.dart`

**Changes (in _openConnection function):**
```dart
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'fsc_portal_dev.sqlite'));
    
    // PHASE 2: Use SQLCipher instead of SQLite
    // Apply SQLCipher workaround
    applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
    
    // Open with SQLCipher
    final db = sqlite3.open(file.path);
    
    // PHASE 2: Set encryption key
    try {
      final authService = AuthService(this); // Temporary
      final encryptionService = EncryptionService(authService);
      final dbKey = await encryptionService.getDatabaseKey();
      
      db.execute("PRAGMA key = 'x$dbKey'");
      db.execute("PRAGMA cipher_page_size = 4096");
      db.execute("PRAGMA kdf_iter = 256000");
      
      Log.info('Database opened with encryption');
    } catch (e) {
      Log.error('Encryption setup failed, using unencrypted database', e, null);
      // Graceful degradation: continue without encryption
    }
    
    // ... rest of existing code unchanged ...
    
    return NativeDatabase.opened(db);
  });
}
```

**CRITICAL:** This is the most risky step. Must test carefully.

**Testing After Part 5:**
- Build succeeds
- Database opens (encrypted)
- **Phase 1 MUST still work** ✅
- If encryption fails, fallback to unencrypted (graceful)
- Data migrates to encrypted database

---

## SAFETY CHECKPOINTS

**After EACH part:**

```powershell
# 1. Build
flutter build windows --release

# 2. Should see: "Built fsc_portal.exe"
# If errors: STOP and fix

# 3. Launch
.\build\windows\x64\runner\Release\fsc_portal.exe

# 4. Test Phase 1 FIRST
# - Navigate to Work Orders
# - Click edit button
# - Verify edit still works

# 5. If Phase 1 broken: ROLLBACK IMMEDIATELY
```

---

## ROLLBACK STRATEGY

**If Phase 2 breaks Phase 1:**

**Option A: Use backup exe**
```powershell
.\fsc_portal_phase1_working.exe
```

**Option B: Restore from Offline-Portal**
```powershell
# Delete broken FSC-Portal
Remove-Item h:\FSC_Portal\FSC-Portal\lib\services\auth_service.dart
Remove-Item h:\FSC_Portal\FSC-Portal\lib\services\encryption_service.dart
Remove-Item h:\FSC_Portal\FSC-Portal\lib\services\provenance_service.dart

# Restore database file to V12
# Rebuild
flutter build windows --release
```

---

## ESTIMATED TIMELINE

**Part 1:** Database Schema - 30 min  
**Part 2:** Auth Service - 45 min  
**Part 3:** Provenance Service - 45 min  
**Part 4:** Wire Auth - 30 min  
**Part 5:** Enable Encryption - 45 min  

**Total:** ~3 hours

**With testing checkpoints:** ~4 hours

---

## SUCCESS CRITERIA

**Phase 2 is complete when:**

✅ Windows SID authentication working  
✅ User auto-login on startup  
✅ Database encrypted with SQLCipher  
✅ Master key derived from SID  
✅ Database key stored (encrypted)  
✅ Provenance logging working  
✅ Key export/import working  
✅ **Phase 1 features STILL working** ← CRITICAL  

---

## READY TO BEGIN

**Protected:** Phase 1 working implementation locked  
**Backup:** fsc_portal_phase1_working.exe created  
**Safety:** Offline-Portal v1.0.0 still untouched  
**Strategy:** Additive changes only  
**Checkpoints:** Test after each part  

**Status:** 🟢 **SAFE TO BEGIN PHASE 2**

---

**Shall I begin Part 1 (Database Schema for security features)?**
