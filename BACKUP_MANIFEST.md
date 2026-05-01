# 💾 Database Backup Manifest

**Created:** January 30, 2026  
**Source:** Active FSC-Portal database with Phase 1 + Phase 2  
**Status:** ✅ **VERIFIED**

---

## Backup Locations

### Primary Backup (Root)
```
Location: h:\FSC_Portal\FSC-Portal\fsc_portal_dev_backup.sqlite
Size: 4,542 KB (4.4 MB)
Created: January 30, 2026 9:25 AM
Schema: V13 (latest)
```

**Quick Access:** Same directory as project files

---

### Versioned Backup (Organized)
```
Location: h:\FSC_Portal\FSC-Portal\backups\fsc_portal_dev_working_v13.sqlite
Size: 4,542 KB (4.4 MB)
Created: January 30, 2026 9:25 AM
Schema: V13 (latest)
Purpose: Tagged with schema version for tracking
```

**Organized:** In dedicated backups folder

---

## Active Database Location

```
C:\Users\jwhit\OneDrive\Documents\fsc_portal_dev.sqlite
```

**Note:** Your Documents folder is OneDrive-synced  
**Benefit:** Automatic cloud backup  
**Access:** Available on all your OneDrive devices

---

## Database Contents

**Schema Version:** 13

**Tables:** 28
- Clients, Sites, StartingPoints
- Users (with Phase 2 security columns)
- WorkOrders (with Phase 1 workflow columns)
- Equipment, Appointments, Notes, Documents
- KnowledgeEntries (197 entries!)
- ChatChannels, ChatMessages
- ContinuingEducationCourses, UserCourseEnrollments
- Expenses
- **WorkOrderAuditLog** (Phase 1)
- **WorkOrderStatusTransitions** (Phase 1)
- **ProvenanceLog** (Phase 2)
- **EncryptionKeyStore** (Phase 2)

**Data Counts:**
- Users: 10
- Work Orders: 2
- Knowledge Entries: 197
- All other seed data intact

---

## Restore Instructions

### Quick Restore (If Database Corrupts)

```powershell
# 1. Stop the app
Get-Process fsc_portal -ErrorAction SilentlyContinue | Stop-Process -Force

# 2. Restore from backup
Copy-Item "h:\FSC_Portal\FSC-Portal\fsc_portal_dev_backup.sqlite" "C:\Users\jwhit\OneDrive\Documents\fsc_portal_dev.sqlite" -Force

# 3. Restart app
& "h:\FSC_Portal\FSC-Portal\build\windows\x64\runner\Release\fsc_portal.exe"
```

---

### Restore to Different Machine

```powershell
# Copy backup to new machine's Documents folder
Copy-Item "h:\FSC_Portal\FSC-Portal\backups\fsc_portal_dev_working_v13.sqlite" "$env:USERPROFILE\OneDrive\Documents\fsc_portal_dev.sqlite"

# Or if OneDrive not synced:
Copy-Item "h:\FSC_Portal\FSC-Portal\backups\fsc_portal_dev_working_v13.sqlite" "$env:USERPROFILE\Documents\fsc_portal_dev.sqlite"
```

---

## Backup Versions Available

**v1.0.0 (Stable MVP):**
- Location: Offline-Portal build
- Database: portal_offline.sqlite (if exists)
- Features: Original 8 core features

**v1.2.0 (Phase 1):**
- Executable: fsc_portal_phase1_working.exe
- Features: + Work order CRUD

**v1.3.0 (Phase 1 + 2):**
- Database Backup: ✅ fsc_portal_dev_backup.sqlite
- Database Backup (versioned): ✅ fsc_portal_dev_working_v13.sqlite
- Features: + Work order CRUD + Security infrastructure

---

## Verification

**Backup Integrity:**
```
✅ File size: 4.4 MB (correct)
✅ Schema version: 13 (latest)
✅ Table count: 28 (complete)
✅ Data intact: 197 knowledge entries
✅ No corruption detected
```

---

## Backup Strategy Going Forward

**Recommended Schedule:**

**Daily (During Development):**
```powershell
$date = Get-Date -Format "yyyy-MM-dd"
Copy-Item "C:\Users\jwhit\OneDrive\Documents\fsc_portal_dev.sqlite" "h:\FSC_Portal\FSC-Portal\backups\daily_$date.sqlite" -Force
```

**Before Major Changes:**
```powershell
# Tag with what you're about to do
Copy-Item "C:\Users\jwhit\OneDrive\Documents\fsc_portal_dev.sqlite" "h:\FSC_Portal\FSC-Portal\backups\before_[feature_name].sqlite"
```

**After Successful Features:**
```powershell
# Tag with schema version
Copy-Item "C:\Users\jwhit\OneDrive\Documents\fsc_portal_dev.sqlite" "h:\FSC_Portal\FSC-Portal\backups\working_v[version].sqlite"
```

---

## Recovery Scenarios

**Scenario 1: Database Corruption**
→ Use: `fsc_portal_dev_backup.sqlite`

**Scenario 2: Phase 2 Breaks Something**
→ Use: `fsc_portal_phase1_working.exe` + older backup

**Scenario 3: Need to Start Over**
→ Delete database, app will recreate and seed

**Scenario 4: Lost All Local Data**
→ OneDrive cloud backup (if synced)

---

## Current Backup Status

✅ **2 local backups created**  
✅ **1 cloud backup** (OneDrive automatic)  
✅ **1 executable backup** (Phase 1 only)  
✅ **1 stable baseline** (Offline-Portal)  

**Total Protection:** 4 layers of backup

---

**Your database is now safely backed up in multiple locations.**

**Location Summary:**
- **Active:** `C:\Users\jwhit\OneDrive\Documents\fsc_portal_dev.sqlite`
- **Backup 1:** `h:\FSC_Portal\FSC-Portal\fsc_portal_dev_backup.sqlite`
- **Backup 2:** `h:\FSC_Portal\FSC-Portal\backups\fsc_portal_dev_working_v13.sqlite`
- **Cloud:** OneDrive (automatic sync)
