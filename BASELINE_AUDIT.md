# Baseline Engineering Audit: FSC-Portal

**Date**: 2026-02-07  
**Scope**: `H:\FSC_Portal\FSC-Portal`  
**Auditor**: Warp Agent Mode

---

## Executive Summary

FSC-Portal is a Flutter desktop application for field service technicians with offline-first architecture (Drift/SQLite), OpenStreetMap integration, and an embedded AI assistant (EVA). This audit identified **13 findings** across security, correctness, reliability, observability, and maintainability categories.

---

## Coverage Checklist

### 1. Build and Run Workflow

**Status**: Partially Verified

- `pubspec.yaml` defines package `fsc_portal` with Flutter SDK dependency
- `pubspec.lock` exists with pinned versions (SHA256 hashes present)
- Build scripts present:
  - `build_optimized.ps1` - targets Android APK (flutter build apk --release)
  - `run_build.ps1` - runs Drift code generation (flutter pub run build_runner)
- **Gap**: No CI/CD configuration files found (.github/workflows, azure-pipelines.yml)

### 2. Error Handling Patterns

**Status**: Mixed Quality

- **Good**: `ErrorHandler` class implements retry with exponential backoff (`lib/util/error_handler.dart`)
- **Good**: Custom exceptions defined (`WorkOrderException`, `ValidationException`)
- **Good**: External API calls use timeouts (30 seconds for weather service)
- **Issue**: Some catch blocks swallow exceptions without logging (see F-003)

### 3. Data Validation Boundaries

**Status**: Gaps Identified

- **Issue**: Work order validation lacks input sanitization before SQL operations
- **Issue**: Password comparison uses plaintext equality (see F-001)
- **Good**: Drift ORM provides type-safe queries

### 4. State Management and Concurrency Risks

**Status**: Standard Pattern

- Uses `ChangeNotifier` pattern via `provider` package
- State classes: `EvaState`, `NavigationState`, `AuthProvider`, `ThemeProvider`
- `StreamController.broadcast()` used for message streaming
- **Gap**: No explicit locking for concurrent database writes

### 5. External I/O Boundaries (Network, Filesystem, DB)

**Status**: Mixed

- **Network**: Weather service uses `http` package with timeouts
- **Database**: Drift with 32 tables, schema version 15, migration strategy defined
- **Filesystem**: Receipt scanning saves to local paths
- **Issue**: ONNX FFI bindings completely unimplemented (see F-005)

### 6. Dependency and Version Pinning Risks

**Status**: Adequate

- `pubspec.lock` present with SHA256 checksums
- All packages pinned to specific versions
- 100+ transitive dependencies

### 7. Logging and Observability Gaps

**Status**: Critical Gap

- **Issue**: All logging uses `print()` only in debug mode (see F-004)
- No structured logging framework
- No log levels (info, warn, error)
- No log persistence for production diagnostics
- `KnowledgeQueryLog` table exists for RAG queries but not for general app events

### 8. Test Coverage Shape and Failure Modes

**Status**: Broken

- 3 test files found:
  - `test/widget_test.dart` - **BROKEN** (wrong package import)
  - `test/services/work_order_workflow_service_test.dart` - workflow tests
  - `test/performance/work_order_performance_test.dart` - performance benchmarks
- **Issue**: Widget test imports non-existent package (see F-002)
- **Gap**: No integration tests, no database migration tests

---

## Audit Gaps

Items that could not be verified due to missing artifacts:

1. **CI/CD Pipeline**: No pipeline configuration found
2. **Runtime Logs**: No production log files present
3. **Performance Baselines**: No benchmark results stored
4. **Security Scan Results**: No SAST/DAST reports

---

## Finding Summary by Category

| Category | Count | IDs |
|----------|-------|-----|
| Security | 2 | F-001, F-006 |
| Correctness | 3 | F-002, F-007, F-010 |
| Reliability | 3 | F-005, F-008, F-009 |
| Observability | 1 | F-004 |
| Maintainability | 2 | F-003, F-011 |
| Build/CI | 2 | F-012, F-013 |

---

## Detailed Findings

See `BASELINE_FINDINGS.json` for structured finding data with evidence.
