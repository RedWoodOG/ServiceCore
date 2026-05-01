# Five-Protocol Enforcing Audit Summary

**Run ID**: ENFORCING-2026-02-07-001  
**Target**: FSC-Portal (H:\FSC_Portal\FSC-Portal)  
**Date**: 2026-02-07  

---

## Record Counts by Protocol

| Protocol | FAIL | AUDIT_GAP | INVALID_RECORD | Total |
|----------|------|-----------|----------------|-------|
| LCE | 6 | 0 | 0 | 6 |
| RLDF_VISUAL | 0 | 3 | 0 | 3 |
| VCE | 0 | 4 | 0 | 4 |
| STRUCTURAL | 0 | 4 | 0 | 4 |
| BEHAVIORAL | 0 | 5 | 0 | 5 |
| **TOTAL** | **6** | **16** | **0** | **22** |

---

## Protocol Results

### LCE (Linguistic Coherence Evaluation)
**Domain**: Source code as authored artifact  
**Status**: 6 FAIL records emitted

#### Top 10 FAIL Claims (LCE)

1. **LCE-001**: Logging utility functions use Log.info/warn/error/debug pattern but auth_provider.dart and theme_provider.dart deviate by using debugPrint() directly.

2. **LCE-002**: Custom exception classes follow 'message' field + toString() pattern but EncryptionException deviates by not including stack trace parameter in constructor.

3. **LCE-003**: Error catch blocks with Log calls include exception variable but multiple catch blocks silently swallow exceptions without any logging.

4. **LCE-004**: StatefulWidget classes follow dispose() pattern with super.dispose() call but some widgets with TextEditingController do not override dispose().

5. **LCE-005**: Test file imports package using 'package:fsc_portal/...' pattern but widget_test.dart imports using obsolete 'package:portal_offline/...' name.

6. **LCE-006**: Database migration uses sequential 'if (from < N)' pattern but version 2->3 migration uses 'else if' breaking the chain for fresh installs.

---

### RLDF Visual (Visual Composition Evaluation)
**Domain**: Rendered screenshots as perceived spatial composition  
**Status**: 3 AUDIT_GAP records (no screenshots available)

All findings are AUDIT_GAPs due to missing runtime artifacts:
- RLDF-GAP-001: No rendered screenshots available
- RLDF-GAP-002: Visual rhythm/spacing not evaluable
- RLDF-GAP-003: Color contrast not evaluable

---

### VCE (Veracity and Coherence Evaluation)
**Domain**: UI truth claims vs system-accessible source-of-truth  
**Status**: 4 AUDIT_GAP records (no runtime state observable)

All findings are AUDIT_GAPs due to missing runtime artifacts:
- VCE-GAP-001: UI content claims not evaluable
- VCE-GAP-002: Weather staleness not verifiable
- VCE-GAP-003: Work order status not verifiable
- VCE-GAP-004: Auth state display not verifiable

---

### Structural Coherence (Accessibility + Information Architecture)
**Domain**: DOM + accessibility tree + computed properties  
**Status**: 4 AUDIT_GAP records (no a11y tree available)

All findings are AUDIT_GAPs due to missing runtime artifacts:
- STRUCT-GAP-001: DOM/a11y tree not available
- STRUCT-GAP-002: Keyboard focus order not verifiable
- STRUCT-GAP-003: Semantic labels not verifiable
- STRUCT-GAP-004: Heading hierarchy not verifiable

---

### Behavioral Coherence (Interaction Integrity)
**Domain**: Action → state transition → render updates over time  
**Status**: 5 AUDIT_GAP records (no interaction traces available)

All findings are AUDIT_GAPs due to missing runtime artifacts:
- BEHAV-GAP-001: Interaction traces not available
- BEHAV-GAP-002: Login flow not verifiable
- BEHAV-GAP-003: Work order status transition not verifiable
- BEHAV-GAP-004: EVA streaming not verifiable
- BEHAV-GAP-005: Weather auto-refresh not verifiable

---

## Execution Notes

### Artifacts Available
- Full source code access (lib/, test/, pubspec.yaml, etc.)
- Build configuration files
- Database schema definitions

### Artifacts Missing (causing AUDIT_GAPs)
- **Screenshots**: No rendered UI captures provided
- **DOM/Accessibility Tree**: Flutter desktop; requires runtime inspection
- **Interaction Traces**: No automated testing instrumentation
- **State Snapshots**: No runtime database state observable
- **Timestamps**: No UI/source-of-truth comparison data

### Cross-Domain Bleed Prevention
All records were validated against cross-domain evidence rules:
- LCE records contain only source-level pattern evidence
- RLDF/VCE/STRUCTURAL/BEHAVIORAL gaps correctly emit missing-artifact notices
- No INVALID_RECORD rejections required

---

## Artifact Requirements for Full Protocol Coverage

To resolve AUDIT_GAPs and enable FAIL emission for non-LCE protocols:

| Protocol | Required Artifacts |
|----------|-------------------|
| RLDF_VISUAL | Screenshots with pixel measurements, bounding boxes |
| VCE | UI capture + database query results with timestamps |
| STRUCTURAL | Flutter accessibility tree dump (via Semantics debugger) |
| BEHAVIORAL | Interaction traces with state_before/state_after snapshots |

---

## Files Generated

```
audit/
├── LCE_FINDINGS.json
├── RLDF_VISUAL_FINDINGS.json
├── VCE_FINDINGS.json
├── STRUCTURAL_FINDINGS.json
├── BEHAVIORAL_FINDINGS.json
└── PROTOCOL_SUMMARY.md
```
