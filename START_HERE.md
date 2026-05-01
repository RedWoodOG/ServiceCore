# 🚀 FSC Portal - Development Branch

**Welcome to the development environment!**

This is a **safe clone** of Offline-Portal where you can experiment, break things, and build new features without risking your stable MVP.

---

## ✅ Clone Status: VERIFIED

```
✓ Directories isolated
✓ Package names different (portal_offline → fsc_portal)
✓ Databases separate (portal_offline.sqlite → fsc_portal_dev.sqlite)
✓ Build artifacts unique (portal_offline.exe → fsc_portal.exe)
```

**You're good to go!**

---

## 🎯 Quick Start

### First Time Setup

```powershell
# 1. Navigate to development directory
cd h:\FSC_Portal\FSC-Portal

# 2. Get dependencies
flutter pub get

# 3. Run in debug mode
flutter run -d windows

# 4. Or build release
flutter build windows --release
```

### Output

- **Executable:** `build\windows\x64\runner\Release\fsc_portal.exe`
- **Database:** `%USERPROFILE%\Documents\fsc_portal_dev.sqlite`

---

## 📁 Directory Structure

```
h:\FSC_Portal\
│
├── Offline-Portal/          ← DO NOT TOUCH
│   └── Your stable MVP (v1.0.0)
│
├── FSC-Portal/              ← WORK HERE
│   └── Development version (v1.1.0+)
│
├── DEVELOPMENT_GUIDE.md     ← Read this for detailed workflow
└── Verify-Clone.ps1         ← Run to verify isolation
```

---

## 🔐 What's Next: Security Implementation

### Phase 1 Goals (2-3 days)

1. **Windows SID Authentication**
   - Auto-detect current Windows user
   - Bind identity to Windows SID
   - No password handling needed

2. **Hybrid Encryption**
   - Master key derived from SID + machine ID
   - Database key stored (encrypted)
   - SQLCipher integration

3. **MKPE Provenance**
   - Audit trail for critical changes
   - Tamper-evident logging
   - Integrity verification

---

## 📋 Important Rules

### ✅ DO:
- Experiment freely in FSC-Portal
- Break things and learn
- Test new features thoroughly
- Ask for help if stuck

### ❌ DON'T:
- Modify Offline-Portal (keep it stable)
- Deploy FSC-Portal to production yet
- Stress about breaking things (you can re-clone)

---

## 🆘 If Something Breaks

**Re-clone from stable:**

```powershell
# Delete broken dev version
Remove-Item h:\FSC_Portal\FSC-Portal -Recurse -Force

# Copy fresh from stable
xcopy "h:\FSC_Portal\Offline-Portal" "h:\FSC_Portal\FSC-Portal" /E /I /H /Y

# Re-run initial setup
cd h:\FSC_Portal\FSC-Portal
flutter pub get
```

---

## 📚 Documentation

- `README.md` - This file (quick start)
- `CLONE_STATUS.md` - Verification details
- `../DEVELOPMENT_GUIDE.md` - Full workflow guide
- `../Offline-Portal/PROJECT_STATUS_REPORT_2026.md` - MVP status

---

## ✨ You Now Have

1. **Stable Production Version**
   - Offline-Portal (frozen at v1.0.0)
   - Ready to deploy anytime
   - Zero risk

2. **Safe Development Environment**
   - FSC-Portal (active development)
   - Isolated database
   - Freedom to experiment

3. **Clear Separation**
   - Different package names
   - Different executables
   - Different databases
   - Can run both simultaneously

---

## 🤝 Ready for Phase 1?

I can begin implementing the security architecture **right now**:

1. Windows SID authentication
2. Hybrid encryption (KDF + SQLCipher)
3. MKPE provenance tracking

**Total time:** 2-3 hours for working implementation  
**Cost:** $0

Want me to start?

---

**Questions?** Check `DEVELOPMENT_GUIDE.md` or ask!
