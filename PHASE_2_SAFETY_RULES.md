# Phase 2: Security Architecture - Safety Rules

**CRITICAL:** Phase 1 is working and validated. These rules ensure we don't break it.

---

## 🔒 PROTECTED PHASE 1 FILES

**DO NOT MODIFY (unless absolutely necessary):**

1. `lib/services/work_order_workflow_service.dart` ✅ Working
2. `lib/services/security_service.dart` ✅ Working  
3. `lib/util/error_handler.dart` ✅ Working
4. `lib/features/work/edit_work_order_sheet.dart` ✅ Working
5. `lib/features/work/work_order_status_badge.dart` ✅ Working
6. `lib/features/work/work_view.dart` (edit button integration) ✅ Working

**Phase 1 Database Schema (V12):**
- WorkOrders table enhancements
- WorkOrderAuditLog table
- WorkOrderStatusTransitions table
- Migration V11→V12

---

## ✅ PHASE 2 STRATEGY (ADDITIVE ONLY)

### Create NEW Files

**Services (all new):**
```
lib/services/
  ├── auth_service.dart (NEW)
  ├── encryption_service.dart (NEW)
  ├── provenance_service.dart (NEW)
  └── key_management_service.dart (NEW)
```

**Models (if needed):**
```
lib/models/
  └── auth_models.dart (NEW)
```

### Modify EXISTING Files (Carefully)

**lib/database/app_database.dart:**
- ✅ ADD new tables (ProvenanceLog)
- ✅ ADD new columns to Users (windowsSid, lastLoginAt)
- ✅ ADD new query methods
- ❌ DO NOT modify Phase 1 migration (V11→V12)
- ❌ DO NOT modify Phase 1 query methods
- ✅ CREATE new migration (V12→V13)

**lib/main.dart:**
- ✅ ADD auth initialization BEFORE database open
- ✅ ADD encryption setup
- ❌ DO NOT modify existing provider setup
- ❌ DO NOT change navigation structure

---

## 🧪 TESTING PROTOCOL

**After EVERY Phase 2 change:**

```powershell
# 1. Build
flutter build windows --release

# 2. Verify zero errors
# Should complete successfully

# 3. Launch
.\build\windows\x64\runner\Release\fsc_portal.exe

# 4. Test Phase 1 features FIRST
# - Navigate to Work Orders
# - Click edit button
# - Verify edit still works

# 5. Then test new Phase 2 feature
```

**If Phase 1 breaks at ANY point:**
- STOP
- Rollback the change
- Fix in isolation
- Re-test

---

## 🔄 ROLLBACK CAPABILITY

**Working Phase 1 Backup:**
```
h:\FSC_Portal\FSC-Portal\fsc_portal_phase1_working.exe
```

**If FSC-Portal breaks:**
```powershell
# Use the working backup
.\fsc_portal_phase1_working.exe

# Or restore from Offline-Portal + Phase 1 files
```

---

## 📋 PHASE 2 IMPLEMENTATION ORDER

**Safe Implementation Sequence:**

**Step 1: Database Schema (Additive)**
- Add `windowsSid` to Users table
- Create ProvenanceLog table
- Migration V12→V13
- ✅ Test: Phase 1 still works

**Step 2: Auth Service (New File)**
- Create auth_service.dart
- Windows SID resolution
- User binding
- ✅ Test: Phase 1 still works

**Step 3: Encryption Service (New File)**
- Create encryption_service.dart
- Master key derivation
- Database key management
- ✅ Test: Phase 1 still works (unencrypted)

**Step 4: Wire Auth (Modify main.dart)**
- Add auth check on startup
- ✅ Test: Phase 1 still works

**Step 5: Enable Encryption (Modify database)**
- Switch to encrypted database
- ✅ Test: Phase 1 still works (with encryption)

**Step 6: Provenance Service (New File)**
- Create provenance_service.dart
- Hook into Phase 1 audit log
- ✅ Test: Phase 1 + Phase 2 both work

---

## ⚠️ RED FLAGS (Stop Immediately If You See)

**During Phase 2 implementation:**

- ❌ Edit button disappears from work order cards
- ❌ Status badges don't render
- ❌ Edit modal fails to open
- ❌ Save changes fails
- ❌ Status workflow stops validating
- ❌ Work order queries fail
- ❌ Compilation errors in Phase 1 files

**If ANY of these occur:**
1. Stop immediately
2. Identify the breaking change
3. Rollback that specific change
4. Fix in isolation
5. Re-test Phase 1
6. Then proceed

---

## ✅ GREEN LIGHTS (Safe to Continue)

**Phase 2 is safe if:**

- ✅ All Phase 1 files unchanged (or only additive changes)
- ✅ Work Orders view still loads
- ✅ Edit button still works
- ✅ Status workflow still validates
- ✅ Audit logging still functions
- ✅ No new compilation errors
- ✅ Tests still pass

---

## 📸 CHECKPOINT SNAPSHOT

**What We're Protecting:**

```
✅ Working Features:
  - Edit work orders
  - Status workflow (8 states)
  - Optimistic locking
  - Audit trail
  - Security permissions
  - Status badges
  - Error recovery

✅ Validated By:
  - Build successful (0 errors)
  - User tested and confirmed
  - Application stable
  - Features operational

✅ Backup Created:
  - fsc_portal_phase1_working.exe (79 KB)
  - Can restore anytime
  - Offline-Portal v1.0.0 still untouched
```

---

## PHASE 2 PROMISE

**I will:**
- Create NEW files for security features
- Make only ADDITIVE database changes
- Test Phase 1 after EVERY change
- Stop if anything breaks
- Rollback immediately if regression detected
- Maintain working state throughout

**You can trust:**
- Phase 1 will keep working
- No functionality will be lost
- Rollback is always available
- Stable MVP (Offline-Portal) remains untouched

---

## READY FOR PHASE 2

**Protected:** Phase 1 working implementation  
**Backup:** Working executable saved  
**Safety Net:** Offline-Portal v1.0.0 still frozen  
**Rollback:** Multiple restore options available  

**Status:** 🟢 **SAFE TO PROCEED WITH PHASE 2**

---

**Lock Confirmed:**  
- Phase 1: PROTECTED ✅
- Backup: CREATED ✅
- Safety: VERIFIED ✅
- Ready: YES ✅

**Beginning Phase 2: Security Architecture (with Phase 1 protection active)**

---

**If anything breaks Phase 1, we stop and fix it immediately. No exceptions.**
