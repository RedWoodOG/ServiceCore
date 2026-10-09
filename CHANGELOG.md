# Changelog

All notable changes to FSC Portal will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

Changes since ServiceCore was extracted from the FSC-Portal monorepo (`4b40bff`). Each entry
cites the pull request and commit it came from. No release number has been assigned; see
the versioning note at the end of this section.

### Added

- `AppPaths` (`lib/util/app_paths.dart`): attachment and receipt paths are stored relative to
  the documents root and resolved when read. Legacy absolute paths are re-rooted on read, so
  no data migration is needed. Unit tests in `test/util/app_paths_test.dart`. (#1, `ab11271`)
- `AssistantModelProvider` (`lib/services/assistant/assistant_model_provider.dart`) with an
  explicit `UnavailableAssistantModelProvider` default, so text generation sits behind an
  interface instead of a placeholder. (#1, `ab11271`)
- `WorkOrderService.saveEdit()`: applies a field edit and an optional status transition in one
  transaction. Tests in `test/application/work_order_save_edit_test.dart`. (#2, `b0a71f2`)
- GitHub Actions CI (`.github/workflows/ci.yml`), run on pushes to `main` and on pull requests:
  `flutter pub get`, Drift code generation, `flutter analyze` and `flutter test` on Ubuntu,
  and a Windows release build. (#3, `cddc752`)
- `dart_test.yaml` registers a `perf` tag. Tests tagged `perf` are excluded from CI and run
  locally with `flutter test --tags perf`. (#3, `c348240`)

### Changed

- Extraction from the FSC-Portal monorepo (`4b40bff`):
  - Package renamed `fsc_portal` to `servicecore`. Android identity changed from
    `com.example.portal_offline` to `com.vyrevault.servicecore`.
  - The seed data is now a synthetic demo set in place of real client, staff and site records.
  - Map pin colours and the map legend derive from `clients.themeColor` instead of per-client
    theme constants.
  - `lib/widgets/fsc_logo.dart` renamed to `lib/widgets/brand_logo.dart`.
  - `DEVELOPMENT_GUIDE.md`, `DESIGN_SYSTEM_2026.md` and `SECURITY_AUDIT_2026_01.md` moved to
    `docs/`. More than 60 session-artifact documents, generated audit dumps and one-off
    deployment migration scripts were removed.
  - The README documents the on-disk paths, storage keys and crypto salts that must not be
    renamed.
- Removed the ONNX Runtime FFI path (`lib/ffi/onnxruntime_native.dart`,
  `lib/services/onnxruntime_ffi.dart`, `lib/services/local_llm_provider.dart`) and the
  `win32` and `ffi` dependencies. The path was disabled behind a flag that was never true, so
  behaviour is unchanged: EVA answers by retrieval only. This removes Windows-only code
  couplings; no iOS or macOS runner exists in the repository, which still has only
  `android/` and `windows/` platform directories. (#1, `ab11271`)
- The edit sheet disables locked fields instead of rejecting them only on save. (#2, `b0a71f2`)
- Removed the `Phi-3-mini-4k-instruct` gitlink, which had no `.gitmodules`, and added it to
  `.gitignore`. (#3, `0240ace`)

### Fixed

- Stored attachment and receipt paths no longer break when the application's documents
  directory moves (for example the iOS container, which is recreated on every update).
  (#1, `ab11271`)
- AI feedback capture crashed in release and profile builds: `capturePortal` read
  `RenderObject.debugNeedsPaint`, which throws when asserts are stripped. It now checks the
  boundary size instead (`lib/features/feedback/feedback_capture_service.dart`). (#2, `b0a71f2`)
- A rejected status transition during an edit left the work order on a stale version, so every
  retry failed as a conflict. `saveEdit()` validates both parts first and rolls the field
  update back with the transition. (#2, `b0a71f2`)
- Completed work orders could not be reopened from the UI although the workflow allows
  `completed` to `in_progress`. `closed` and `cancelled` accept no changes; `completed` locks
  its fields but still accepts a transition. (#2, `b0a71f2`)
- Cleared the analyzer errors and infos that the first CI runs reported. Fixed test files
  that could not compile (a missing `drift` import, `WorkOrdersCompanion.insert` calls
  without the required `createdAt`, a `WorkOrder` literal missing required fields), an
  unused import, and a `pubspec.yaml` asset entry for a deleted file. Two deprecated
  semantics calls in `integration_test/audit_harness_test.dart` are suppressed rather than
  migrated. (#3, `0240ace`, `2d72582`)
- The optimistic-locking test asserted nothing, because it attempted an illegal transition
  before reaching the version check. It now uses a reachable transition and awaits the
  assertion. (#3, `c348240`)
- The scaffold widget test (`test/widget_test.dart`) is skipped with its reason recorded
  instead of failing on missing providers and `path_provider`. (#3, `c348240`)

### Documentation corrections

Corrected against the source at this revision. Earlier entries below are left as written.

- README: removed the claim of at-rest database encryption. The database is opened with a
  plain `NativeDatabase.createInBackground` (`lib/database/app_database.dart:1664-1676`);
  the stored key is used only for a startup fingerprint and key export/import.
- README: the do-not-rename table no longer says that renaming
  `fsc_portal_v1_2026_security` makes "every encrypted database undecryptable" or that
  renaming `fsc_portal_db_key_encrypted` stops "the database" opening. No database is
  encrypted yet; the table now describes the stored key and key exports. The
  `fsc_portal/fsc_portal.db` boot path is listed separately from the live database
  `fsc_portal_dev.sqlite`, and the `portal_offline/` location now points at
  `lib/util/app_paths.dart` (`local_llm_provider.dart` no longer exists).
- README, Known issues: removed the `debugNeedsPaint` release-build crash, fixed in #2.
  Added, each with file and line: no encryption at rest; expense amounts drop a comma
  (`12,50` is saved as `1250`); safe-mode recovery acts on `fsc_portal/fsc_portal.db`, not the
  live `fsc_portal_dev.sqlite`; knowledge and work order search are substring matches.
- DEVELOPMENT_GUIDE: Flutter 3.38.5 / Dart 3.10.4 replaced by Flutter 3.44.9 (the version
  pinned in CI) and the Dart SDK bundled with it. Current schema version corrected from 11 to
  15, and the schema-version tutorial examples now go from 15 to 16.
- WORK_ORDER_MANAGEMENT: the create example now uses `WorkOrderService.create` instead of a
  direct `db.into(...)` insert, and lists the code paths that still write directly. The
  permission matrix, the "Admin only" notes and the sanitization and upload rules are marked
  as not enforced at this revision: role checks in `WorkOrderService` are TODO stubs and
  `SecurityService` has no callers. The "full-text search" benchmark is relabelled as
  substring search. The schema section states the current version (15).
- The 1.2.0 entry below still says "Role-based permissions implemented", "Input
  sanitization active", "File upload validation" and lists a "Full-text search" benchmark.
  Those statements do not match the source at this revision (see the items above).

### Versioning note

`pubspec.yaml` is `1.1.2+1` and `kPortalPackageVersion` is `1.1.2`
(`lib/features/feedback/portal_build_version.dart`). FSC-Portal shipped releases v1.1.0 to
v1.1.2 in May 2026 that have no entries in this file, while the newest numbered entry here is
1.2.0 from January 2026. The next release number is the owner's decision.

---

## [1.2.0] - 2026-01-30 - Phase 1: Work Order Enhancement

### Added

**Work Order CRUD System:**
- Complete edit functionality for work orders
- Status workflow state machine with 8 states
- Optimistic locking for concurrent modification protection
- Comprehensive audit logging system
- Permission-based access control
- Work order status badges with visual indicators
- Edit work order modal sheet with validation
- Automated test suite (27 tests, 80%+ coverage)
- Performance benchmark suite
- Security validation layer

**Database Schema (V11 → V12):**
- 11 new columns added to `work_orders` table
- New table: `work_order_audit_log` (change tracking)
- New table: `work_order_status_transitions` (status history)
- 3 performance indexes created

**Services:**
- `WorkOrderWorkflowService` - Status transition logic
- `SecurityService` - Permission and validation
- `ErrorHandler` - Retry logic and error recovery

**UI Components:**
- `EditWorkOrderSheet` - Full-featured edit modal
- `WorkOrderStatusBadge` - Reusable status indicator

**Testing:**
- 23 unit tests for workflow service
- 4 performance benchmarks
- Edge case coverage
- Transaction safety tests

**Documentation:**
- Complete work order management guide
- API reference
- Security documentation
- Troubleshooting guide

### Changed

- Database schema version: 11 → 12
- Work order cards now show status badge overlay
- Work order cards now have edit button
- Work view refreshes after edit completion
- Status transitions now require reason/notes

### Performance

**Benchmarks** (Target):
- Create 1,000 work orders: < 5s
- Query 10,000 by status: < 100ms
- Full-text search 10,000: < 200ms
- 100 concurrent updates: < 2s

**Indexes:**
- `idx_wo_status` - Status filtering
- `idx_wo_assigned` - Technician queries
- `idx_wo_workflow` - Workflow state queries

### Security

- Role-based permissions implemented (tech, dispatcher, admin)
- All changes audited to database
- Input sanitization active
- Concurrent modification protection
- File upload validation (magic number checking)
- Security event logging

### Technical Debt

- None introduced ✅

---

## [1.1.0] - 2026-01-30 - Development Fork

### Added
- Cloned from Offline-Portal v1.0.0
- Renamed to FSC-Portal for active development
- Database isolation (`fsc_portal_dev.sqlite`)
- Separate executable (`fsc_portal.exe`)
- Development documentation

### Changed
- Package name: `portal_offline` → `fsc_portal`
- Window title: Updated to "FSC Portal (Development)"
- Build artifacts use new naming

---

## [1.0.0] - 2026-01-XX - MVP Release (Offline-Portal)

### Features
- Home Dashboard with KPIs
- Work Orders (create, view)
- Locations & Maps (OpenStreetMap)
- Operations (client/site management)
- People Directory
- Knowledge Base (94+ entries)
- Settings
- EVA Intelligence Panel

### Technical
- Offline-first architecture
- SQLite database (Drift ORM)
- Provider state management
- Complete theme system
- Zero compilation errors
- Production-ready build

**Status:** STABLE - Deployed and frozen

---

## Future Releases (Planned)

### [1.3.0] - Phase 2: Security Architecture
- Windows SID authentication
- Hybrid encryption (KDF + SQLCipher)
- MKPE provenance tracking
- Key backup/recovery system

### [1.4.0] - Phase 3: Feature Completion
- Continuing Education integration
- Equipment Management integration
- Expenses module completion
- Photo upload for work orders

### [2.0.0] - Production Hardening
- User authentication system
- Database encryption at rest
- Comprehensive testing (95%+ coverage)
- MSI installer
- Auto-update mechanism

---

**Maintained by:** VyreVault Studios  
**Project:** FSC Portal - Field Service Management
