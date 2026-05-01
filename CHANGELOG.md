# Changelog

All notable changes to FSC Portal will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
