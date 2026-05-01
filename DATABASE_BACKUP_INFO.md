# Database Backup Information

**Backup Date:** January 30, 2026  
**Purpose:** Preserve working Phase 1 + Phase 2 database

---

## Active Database Location

**Primary (OneDrive Synced):**
```
C:\Users\jwhit\OneDrive\Documents\fsc_portal_dev.sqlite
```

**Why OneDrive:**
- Your Windows Documents folder is synced to OneDrive
- `getApplicationDocumentsDirectory()` returns OneDrive path
- Automatic cloud backup (bonus!)

---

## Backup Locations

**Project Directory Backups:**

1. **Root Backup:**
   ```
   h:\FSC_Portal\FSC-Portal\fsc_portal_dev_backup.sqlite
   ```
   - Quick access
   - Same directory as project

2. **Versioned Backup:**
   ```
   h:\FSC_Portal\FSC-Portal\backups\fsc_portal_dev_working_v13.sqlite
   ```
   - Organized in backups folder
   - Version tagged (v13)

---

## Database Details

**Schema Version:** 13 (V13)

**Tables:** 28 total
- Original: 20 tables (V11)
- Phase 1: +2 tables (audit log, status transitions)
- Phase 2: +2 tables (provenance log, encryption key store)
- Supporting: 4 tables (continuing education, expenses, equipment)

**Data:**
- Users: 10
- Work Orders: 2
- Knowledge Entries: 197
- Plus all other seeded data

**Features:**
- ✅ Phase 1: Work order CRUD with workflow
- ✅ Phase 2: Security columns and tables

---

## Restore Procedures

### If Active Database Corrupts

**Option 1: Restore from project backup**
```powershell
# Stop app
Get-Process fsc_portal | Stop-Process -Force

# Copy backup to active location
Copy-Item "h:\FSC_Portal\FSC-Portal\fsc_portal_dev_backup.sqlite" "C:\Users\jwhit\OneDrive\Documents\fsc_portal_dev.sqlite" -Force

# Restart app
```

**Option 2: Use versioned backup**
```powershell
Copy-Item "h:\FSC_Portal\FSC-Portal\backups\fsc_portal_dev_working_v13.sqlite" "C:\Users\jwhit\OneDrive\Documents\fsc_portal_dev.sqlite" -Force
```

---

### If Need to Revert to Phase 1 Only

**Use Phase 1 working exe:**
```powershell
.\fsc_portal_phase1_working.exe
```

**Or restore Offline-Portal database:**
```powershell
# If you have portal_offline.sqlite with Phase 1 data
Copy-Item "C:\Users\jwhit\OneDrive\Documents\portal_offline.sqlite" "C:\Users\jwhit\OneDrive\Documents\fsc_portal_dev.sqlite" -Force
```

---

## Backup Schedule Recommendation

**After major changes:**
1. Stop app
2. Copy database to backup
3. Tag with version/date
4. Document what changed

**Example:**
```powershell
$date = Get-Date -Format "yyyy-MM-dd_HHmm"
Copy-Item "C:\Users\jwhit\OneDrive\Documents\fsc_portal_dev.sqlite" "h:\FSC_Portal\FSC-Portal\backups\fsc_portal_dev_$date.sqlite"
```

---

## Important Notes

**OneDrive Sync:**
- Your database is automatically backed up to cloud ✅
- Can access from other devices (if OneDrive synced)
- May have sync delays (few seconds)

**Multiple Databases:**
- `C:\Users\jwhit\Documents\` - Local (not used)
- `C:\Users\jwhit\OneDrive\Documents\` - Active (OneDrive synced)
- App uses OneDrive location

**File Locking:**
- Database locked while app running
- Must close app before copying
- SQLite journal files (.sqlite-shm, .sqlite-wal) created during use

---

## Database Validation

**To check database health:**
```powershell
sqlite3 "C:\Users\jwhit\OneDrive\Documents\fsc_portal_dev.sqlite" "PRAGMA integrity_check;"
```

Expected output: `ok`

**To check schema version:**
```powershell
sqlite3 "C:\Users\jwhit\OneDrive\Documents\fsc_portal_dev.sqlite" "PRAGMA user_version;"
```

Expected: `13`

---

## Backup Verified

✅ Backup created successfully  
✅ Schema version: 13  
✅ All tables present  
✅ Data intact  
✅ Multiple restore points available  

**Your database is now safely backed up in the project directory.**

---

**Last Updated:** January 30, 2026  
**Backups Created:** 2  
**Status:** ✅ PROTECTED
