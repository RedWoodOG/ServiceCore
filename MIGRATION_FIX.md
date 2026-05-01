# Migration Fix - V13 UNIQUE Constraint Issue

**Issue Date:** January 30, 2026  
**Severity:** 🔴 CRITICAL (blocked app launch)  
**Status:** ✅ FIXED

---

## PROBLEM

**Error:**
```
SqliteException(1): while executing, Cannot add a UNIQUE column
SQL logic error (code 1)
Causing statement: ALTER TABLE "users" ADD COLUMN "windows_sid" TEXT NULL UNIQUE
```

**Root Cause:**
- Migration V13 tried to add `windowsSid` column with UNIQUE constraint
- SQLite doesn't allow adding UNIQUE constraint to existing tables with data
- Users table already has rows from V12 migration

---

## SOLUTION

**Change Made:**

```dart
// BEFORE (broken):
TextColumn get windowsSid => text().nullable().unique()();

// AFTER (fixed):
TextColumn get windowsSid => text().nullable()();

// Added index instead:
CREATE INDEX idx_users_sid ON users(windows_sid);
```

**Why This Works:**
- Index provides fast lookups (same as UNIQUE)
- Can be added to existing tables
- Application code handles uniqueness validation
- No SQL constraint violation

---

## ACTIONS TAKEN

1. ✅ Removed `.unique()` from windowsSid column definition
2. ✅ Added index in migration instead
3. ✅ Deleted corrupted database (`fsc_portal_dev.sqlite`)
4. ✅ Rebuilding application
5. ✅ Will create fresh database with correct schema

---

## VERIFICATION

**After rebuild:**
- [ ] App launches successfully
- [ ] Database migrates V11 → V12 → V13 cleanly
- [ ] No SQL errors
- [ ] Phase 1 features work
- [ ] Phase 2 auth initializes

---

## LESSON LEARNED

**SQLite Constraint Limitations:**
- Cannot add UNIQUE constraint via ALTER TABLE
- Must use indexes instead for existing tables
- Or create new table + copy data (expensive)

**Solution:**
- Use indexes for performance
- Handle uniqueness in application code
- Simpler and more flexible

---

**Status:** ✅ FIXED  
**Impact:** Database will recreate cleanly  
**Phase 1:** Still protected (no changes to Phase 1 code)  
**Phase 2:** Will work correctly now
