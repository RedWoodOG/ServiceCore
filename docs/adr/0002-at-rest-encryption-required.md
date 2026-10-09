# ADR-0002: At-rest database encryption is required for the first release

## Status

Accepted (owner, 2026-10-09)

## Date

2026-10-09

## Requirements

- **Primary:** R17 and R18 (local backup and recovery) in
  [the overhaul requirements](../requirements/overhaul-requirements.md).
- **Affected:** R36 (local truth must not be corrupted).

All code citations below were checked at ServiceCore commit `f211688`.

## Context

### The database is plaintext today

- `_openConnection` (`lib/database/app_database.dart:1671-1683`) opens
  `fsc_portal_dev.sqlite` in the application documents directory (line 1674). It returns
  `NativeDatabase.createInBackground(file)` (line 1681) with no key and no setup callback.
- `pubspec.yaml` depends on `sqlite3` (line 15) and `sqlite3_flutter_libs` (line 16). It has
  no SQLCipher or other cipher library.
- `lib/main.dart:106` labels the startup database "Temporary database for auth (will be
  replaced with encrypted one)". Line 118 says the key step "doesn't encrypt yet, just
  prepares". Line 119 calls `getKeyFingerprint()`, which is the only caller of the key code.
- `EncryptionService.getDatabaseKey` (`lib/services/encryption_service.dart:59-89`) creates
  and stores a database key. Its only caller is `getKeyFingerprint` (lines 255-268).
  - `exportDatabaseKey` (lines 155-196) and `importDatabaseKey` (lines 199-244) have no
    callers in `lib/`, `test/` or `integration_test/`.
- The `EncryptionKeyStore` table (`app_database.dart:490-499`) is created by the v13
  migration step (line 639). No other code reads or writes it.
- **No backup of the live database exists.** The only copy mechanism is boot safe-mode
  recovery. It copies a file to `<path>.backup.<milliseconds>` and deletes the original
  (`lib/application/boot/boot_service.dart:107-125`). The file is
  `fsc_portal/fsc_portal.db` (lines 140 and 148), not the live database, and the copy is
  plaintext.

### How the existing key is derived and stored

- **The database key** is 32 bytes from `Random.secure()`, base64-encoded
  (`encryption_service.dart:92-102`). It is wrapped with AES-256-GCM under a master key
  (lines 105-126). The wrapped key is stored in `FlutterSecureStorage` under
  `fsc_portal_db_key_encrypted` (lines 12, 62, 75). The comment at line 15 describes the
  Windows store as DPAPI-backed. On Android, encrypted shared preferences are used (line 17).
- **The master key** is never stored. It is re-derived on each use with Argon2id (64 MiB of
  memory, 3 iterations, parallelism 4, 32-byte output). The input is `"<SID>|<MachineGuid>"`
  and the fixed salt is `fsc_portal_v1_2026_security` (`encryption_service.dart:13`,
  `:26-55`).
- **The SID** is read through PowerShell
  (`WindowsIdentity.GetCurrent().User.Value`, `lib/services/auth_service.dart:13-36`).
  - If that fails, a pseudo-SID is built from `USERDOMAIN\USERNAME@COMPUTERNAME` using Dart's
    `String.hashCode` (`auth_service.dart:39-50`).
- **The MachineGuid** is read through PowerShell from
  `HKLM\SOFTWARE\Microsoft\Cryptography` (`auth_service.dart:70-92`).
  - If that fails, it becomes `MACHINE-<COMPUTERNAME>` (`auth_service.dart:95-99`).
- **Key export and import** already exist as functions but nothing calls them.
  - Export (`encryption_service.dart:155-196`) wraps the database key with a key derived from
    an admin password. The derivation is PBKDF2-HMAC-SHA256 with 100,000 iterations and the
    fixed salt `fsc_export_salt_v1`. The wrap is AES-256-GCM.
  - Import (lines 199-244) unwraps the export and re-wraps the key under the current
    machine's master key, then overwrites the stored entry (lines 229-233).

### What that means for encryption

- **The key is bound to one Windows user on one machine.** The wrapped key lives in secure
  storage, outside the database file. On another machine, or under another Windows user, the
  master key is different. A copy of the database file alone cannot be opened there, and
  neither can a copy of the stored entry.
- **The derivation inputs can change on the same machine.** If PowerShell fails on one launch
  and succeeds on the next, the SID or MachineGuid input changes, and so does the master key.
  - Today such a failure is harmless. `getKeyFingerprint` catches it and returns `ERROR`
    (`encryption_service.dart:265-267`), and `main.dart` treats the security setup as
    non-fatal.
  - Once the database is encrypted, the same failure would lock the user out.
- **The fallback SID may not be stable.** Dart does not document `String.hashCode` as stable
  across SDK releases, so an SDK upgrade could change it. This needs verification before
  data depends on it.
- **On Android (a supported target), both inputs fall back.** PowerShell is not available,
  so the master key comes from environment values that are probably constant. Protection
  there would rest on the platform secure storage.
  - This is inferred from the code; it has not been run on a device.

## Options considered

### 1. Defer encryption beyond the first release

- **For:** no work now.
- **Against:** field laptops carry customer site, equipment and expense data in a readable
  file. The README already lists the lack of encryption as a known issue.
- **Rejected by the owner.**

### 2. Encrypt the database first, then add backup later

- **For:** delivers the security property sooner.
- **Against:** a machine-bound key with no tested backup or recovery path turns a lost
  laptop, a reimage or a changed SID into permanent data loss.
- **Rejected:** encryption without recovery trades a confidentiality risk for an
  availability risk.

### 3. Rely on operating-system disk encryption only (for example BitLocker)

- **For:** no application change.
- **Against:** it depends on each deployment's configuration and cannot be checked by the
  app. It does not protect backups copied to other media, and it does not meet the owner's
  requirement.
- **Rejected.**

### 4. Require encryption for the first release, delivered with backup and recovery (chosen)

## Decision

- **Required for the first release.** The live database must be encrypted at rest in the
  first market-ready release.
- **Delivered with backup and recovery.** Encryption ships together with local backup and
  recovery (R17–R18; delivery milestone M3, "local backup/restore with key-escrow design").
  No build may encrypt the database without a tested backup and key-recovery path, and no
  backup may be written as plaintext.
- **Use the existing key.** The database key is the one `EncryptionService.getDatabaseKey`
  already generates and stores under `fsc_portal_db_key_encrypted`. A second database key is
  not introduced.
- **Provide key recovery.** A backup restored on a new machine, under a new Windows user or
  after a reinstall must open. The existing password-protected export and import
  (`encryption_service.dart:155-244`) is the starting point. This ADR requires the capability
  and leaves the user experience to M3.

## Key-recovery requirements

The M3 implementation must meet all of these:

1. **Cross-machine restore works.** A backup made on machine A opens on a clean machine B
   after an admin supplies the recovery secret, without developer tools.
2. **Recovery material exists before it is needed.** It is created when encryption is first
   enabled, or with the first backup, not on demand after a loss.
3. **Backups do not carry an open key.** The recovery material is never stored beside a
   backup in any form that opens it without the recovery secret.
4. **Restore checks the key before replacing anything.** For example, the backup manifest
   records a key fingerprint and restore compares it. `EncryptionKeyStore.keyFingerprint`
   (`app_database.dart:494-495`) exists for this purpose.
5. **The loss rule is stated to admins in the UI.** If both the machine-bound key and the
   recovery secret are lost, the data cannot be recovered.
6. **The path is tested.** At least one test covers backup, move to a clean machine or
   profile, and restore.

## Consequences

- **Backups must not be plaintext.**
  - A file copy of an encrypted database stays encrypted. Any method that exports or
    rewrites the database must produce ciphertext under the same key or a recovery-wrapped
    key; for example, a `VACUUM INTO` approach needs an explicit check.
  - Backups that include attachments, receipts and configuration (see Dependencies in the
    requirements) are encrypted as a whole.
  - The safe-mode copy (`boot_service.dart:107-125`) must target the live database. It is
    then encrypted by construction.
- **Existing installs need a one-time file conversion.** Installs at schema v15 have a
  plaintext `fsc_portal_dev.sqlite`. The first build that encrypts must:
  - detect a plaintext file;
  - write an encrypted copy and verify it opens with the stored key;
  - swap the copies atomically;
  - remove the plaintext original only after verification.
  This is a file-level conversion, separate from the Drift `schemaVersion`. It must be ordered
  explicitly against the v16 schema migration ([ADR-0001](0001-organizations-promote-clients.md)).
  Leftover plaintext copies, such as earlier `*.backup.*` files, must be found and handled.
  Deletion on SSDs is not guaranteed to be secure, and the admin-facing notes must say so.
- **The do-not-rename identifiers become load-bearing for data**, not just for keys:
  - `fsc_portal_v1_2026_security`: the master-key salt. Changing it changes the master key,
    so the stored key cannot be unwrapped and the database cannot be opened.
  - `fsc_portal_db_key_encrypted`: the secure-storage entry. Renaming it causes a new random
    key to be generated, which cannot open the existing database.
  - `fsc_export_salt_v1`: the export salt. Changing it makes earlier recovery exports
    unusable.
  - `fsc_portal_dev.sqlite`: the live database path.
  - The Argon2id parameters (lines 33-38) and the `"<SID>|<MachineGuid>"` input format
    (line 41) are equally load-bearing, although the README's do-not-rename table does not
    list them.
- **Losing the key now costs the data.** At `f211688`, losing the stored key loses nothing.
  After this decision it loses the database unless recovery material exists, so
  `deleteStoredKeys` (`encryption_service.dart:247-252`) becomes destructive and must not be
  reachable without safeguards.
- **The README must change when encryption ships.** Its Known issues entry and Security note
  are rewritten in the same pull request.

## Open questions for implementation

1. **Cipher library.** Candidates include SQLCipher (for example through
   `sqlcipher_flutter_libs`, with `PRAGMA key` set in the `NativeDatabase` setup callback)
   and SQLite3 Multiple Ciphers. Confirm Windows and Android support; Windows is the primary
   target. Follow the chosen library's guidance on replacing `sqlite3_flutter_libs`. Confirm
   the CI test runner (Ubuntu) can load it. None of this was evaluated for this ADR.
2. **Key format.** Decide whether to pass the stored 256-bit key as a raw key or as a
   passphrase. A raw key skips the cipher's own key derivation when the database opens.
3. **Rekeying.** Decide when the key rotates (suspected compromise, admin change) and how
   (`PRAGMA rekey` or equivalent). Old backups still need old keys, so recovery material
   must be versioned or keep a key history. `EncryptionKeyStore` could hold that history.
4. **Machine binding.** Resolve the instability described in Context: PowerShell failures,
   the `String.hashCode` fallback, SID changes after a domain migration, MachineGuid changes
   after a reimage, and constant inputs on Android. Options include keeping the
   SID/MachineGuid wrap, relying on DPAPI or platform secure storage alone, or adding a
   recovery-secret wrap.
5. **Export format.** Exports use one fixed PBKDF2 salt for every install. Consider a random
   salt per export in a versioned format, while still reading existing `fsc_export_salt_v1`
   exports.
6. **Performance.** Measure page-encryption overhead on the large knowledge tables. Search is
   a substring scan, so it reads many pages. Also measure the Argon2id 64 MiB derivation,
   which already runs on every startup. Use `perf`-tagged tests on target hardware.
7. **Conversion mechanics.** Plan for free disk space (about twice the database size), crash
   safety part-way through, and rollback.
8. **Where the recovery secret lives.** Options include an admin password, a printed
   recovery key and organizational escrow. This is an M3 user-experience decision.

## What this ADR does NOT decide

- The cipher library, key format or rekeying policy (open questions above).
- Encryption of attachments, receipts or configuration files at rest in the live
  `portal_offline/` directory. Only their inclusion in encrypted backups is decided.
- Server-side or sync encryption (R36).
- The recovery user experience and where the recovery secret is held.
- The release number of the "first release". The next release number is the owner's
  decision (CHANGELOG versioning note).
