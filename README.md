# FSC Portal (Development Branch)

**Canonical working directory:** `H:\FSC-Portal\FSC-Portal` — open this folder in your IDE; run all Flutter commands here.

**Version:** 1.1.0 (Development)  
**Base:** Cloned from Offline-Portal 1.0.0 (Stable MVP)  
**Purpose:** Active development for security features and improvements

**Connectivity:** **Offline-capable, not offline-only** — core workflows must work without a network (local DB); online features (sync, APIs, fleet, updates) are required when connected, with clear behavior when disconnected. See `../DEVELOPMENT_GUIDE.md` (*Connectivity model*).

---

## ⚠️ IMPORTANT

**This is the DEVELOPMENT branch.**

- ✅ Safe to experiment
- ✅ Security features being added
- ✅ Breaking changes allowed
- ⚠️ Not for production deployment

**For stable deployment, use:** `H:\FSC-Portal\Offline-Portal`

---

## Current Development Focus

### Phase 1: Security Architecture (In Progress)

**Implementing:**
1. Windows SID-based authentication
2. Hybrid encryption (KDF + SQLCipher)
3. MKPE provenance tracking
4. Key management and recovery

**Status:** Not yet started (clone just created)

---

## Directory Structure

```
H:\FSC-Portal\
├── Offline-Portal/     ← STABLE MVP (v1.0.0) - DO NOT MODIFY
└── FSC-Portal/         ← DEVELOPMENT (v1.1.0) - CANONICAL WORKDIR (this repo)
```

---

## Development Rules

### ✅ DO:
- Experiment with new features
- Test security implementations
- Refactor and improve
- Break things and fix them

### ❌ DON'T:
- Deploy this to production
- Copy changes back to Offline-Portal without testing
- Delete the Offline-Portal directory

---

## Database Isolation

**Development database will be separate:**

- Stable: `%USERPROFILE%\Documents\portal_offline.sqlite`
- Development: `%USERPROFILE%\Documents\fsc_portal_dev.sqlite`

This ensures no interference with your stable deployment.

---

## How to Work

### Running Development Version

```powershell
cd H:\FSC-Portal\FSC-Portal
flutter run -d windows
```

### Building Development Version

```powershell
cd H:\FSC-Portal\FSC-Portal
flutter build windows --release
```

Output: `build\windows\x64\runner\Release\fsc_portal.exe`

### Testing Changes

1. Make changes in FSC-Portal
2. Test thoroughly
3. When stable, decide if you want to merge to Offline-Portal
4. Keep Offline-Portal frozen until you're ready

---

## Version History

### v1.1.0 (In Development)
- Cloned from Offline-Portal v1.0.0
- Prepared for security enhancements
- Database renamed for isolation

### v1.0.0 (Stable - Offline-Portal)
- MVP release
- 8 core features functional
- Production-ready build
- See: `../Offline-Portal/PROJECT_STATUS_REPORT_2026.md`

---

## Next Steps

1. ✅ Clone created (DONE)
2. ⏳ Implement Windows SID authentication
3. ⏳ Add hybrid encryption layer
4. ⏳ Build MKPE provenance system
5. ⏳ Test thoroughly
6. ⏳ Decide if/when to merge back

---

**Questions?** Check the documentation in `../Offline-Portal/` for base functionality.
