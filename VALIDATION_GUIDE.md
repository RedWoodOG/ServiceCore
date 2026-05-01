# Phase 1 Validation Guide

**Test Date:** January 30, 2026  
**Version:** FSC-Portal v1.2.0 (with Phase 1 features)  
**Estimated Time:** 15-30 minutes

---

## Quick Validation Checklist

### 1. Application Launch ✅

**Status:** Application should be running now

**Verify:**
- [ ] Window title shows "FSC Portal (Development)"
- [ ] No crash on startup
- [ ] Home dashboard loads
- [ ] Navigation sidebar visible

---

### 2. Database Migration (Automatic)

**What Happens:**
On first launch, database automatically migrates from V11 → V12

**Verify:**
- [ ] No error messages during startup
- [ ] App doesn't freeze or hang
- [ ] Database file created: `C:\Users\jwhit\Documents\fsc_portal_dev.sqlite`

**Check Migration:**
```powershell
# Database should exist
Test-Path "$env:USERPROFILE\Documents\fsc_portal_dev.sqlite"
# Should return: True
```

---

### 3. Navigate to Work Orders

**Steps:**
1. Click "Work Orders" in sidebar
2. View should load with existing work orders

**Verify:**
- [ ] Work order list displays
- [ ] Each card now has a **status badge** (top-right corner)
- [ ] Each card now has an **edit button** (bottom-right corner)

---

### 4. Test Edit Functionality

**Test 1: Basic Edit**

**Steps:**
1. Click **edit button** on any work order
2. Modal bottom sheet should open
3. Modify the "Description of Work" field
4. Click "Save Changes"

**Expected:**
- [ ] Modal closes
- [ ] Green success message appears: "Work order updated successfully"
- [ ] Work order list refreshes
- [ ] Changes are visible in the updated card

**If this works:** ✅ Core edit functionality is working

---

**Test 2: Status Change (Valid Transition)**

**Steps:**
1. Find a work order with status "open"
2. Click edit button
3. Change status dropdown to "assigned"
4. "Reason for Status Change" field should appear (required)
5. Select a technician (required for assigned status)
6. Fill in reason: "Assigning to available tech"
7. Click "Save Changes"

**Expected:**
- [ ] Blue info banner appears: "Status will change from OPEN to ASSIGNED"
- [ ] Save button enabled after reason filled
- [ ] Save succeeds
- [ ] Status badge updates to show "ASSIGNED"
- [ ] Purple icon shows on status badge

**If this works:** ✅ Workflow validation is working

---

**Test 3: Invalid Status Transition**

**Steps:**
1. Find a work order with status "completed"
2. Click edit button
3. Try to change status dropdown to "draft"

**Expected:**
- [ ] "Draft" option is **disabled** (grayed out with block icon)
- [ ] Cannot select invalid status
- [ ] If you somehow select it, red error banner appears

**If this works:** ✅ Transition validation is working

---

**Test 4: Validation Rules**

**Steps:**
1. Find work order with status "in_progress"
2. Click edit button
3. Change status to "completed"
4. **DO NOT** fill in Resolution field
5. Try to click "Save Changes"

**Expected:**
- [ ] Save button is **disabled** (greyed out)
- [ ] Cannot save without resolution

**Then:**
6. Fill in Resolution field: "Replaced card reader"
7. Fill in Reason: "Work finished"
8. Click "Save Changes"

**Expected:**
- [ ] Save button becomes enabled
- [ ] Save succeeds
- [ ] Status changes to "completed"
- [ ] Green checkmark icon on status badge

**If this works:** ✅ Business rule validation is working

---

### 5. Test Concurrent Modification Protection

**This requires two users - skip for now, tested via automated tests**

---

### 6. Test Error Handling

**Test: Empty Description**

**Steps:**
1. Edit a work order
2. Delete all text from "Description of Work"
3. Try to save

**Expected:**
- [ ] Save button is disabled
- [ ] Cannot save with empty description

**If this works:** ✅ Form validation is working

---

### 7. Test Status Badge Visual Indicators

**Verify Different Status Colors:**

Find work orders with different statuses and check badges:

- [ ] **OPEN** - Blue folder icon
- [ ] **ASSIGNED** - Purple person icon
- [ ] **IN PROGRESS** - Orange play icon
- [ ] **ON HOLD** - Red pause icon
- [ ] **COMPLETED** - Green check icon

**If visible:** ✅ Status badges are working

---

### 8. Test Refresh After Edit

**Steps:**
1. Edit a work order
2. Change description from "Old text" to "New text"
3. Save changes
4. Check the work order card in the list

**Expected:**
- [ ] Card updates automatically
- [ ] Shows "New text" immediately
- [ ] No manual refresh needed

**If this works:** ✅ Reactive updates are working

---

## Advanced Testing (Optional)

### Test Audit Trail (Database Level)

**Requires SQL client:**

```sql
-- Connect to database
sqlite3 C:\Users\jwhit\Documents\fsc_portal_dev.sqlite

-- Check audit log
SELECT * FROM work_order_audit_log ORDER BY changed_at DESC LIMIT 10;

-- Check status transitions
SELECT * FROM work_order_status_transitions ORDER BY transitioned_at DESC LIMIT 10;
```

**Expected:**
- Every edit creates audit log entry
- Status changes create transition records
- User ID logged
- Timestamps accurate

---

### Run Automated Tests

```powershell
cd h:\FSC_Portal\FSC-Portal
flutter test
```

**Expected:**
- All 27 tests pass
- No errors or failures
- Performance benchmarks met

---

## Validation Results

### If All Tests Pass

✅ Phase 1 is **FULLY COMPLETE AND VALIDATED**

**You have:**
- Production-ready work order CRUD
- Enforced workflow with validation
- Complete audit trail
- Concurrent edit protection
- Role-based security
- Error recovery

**Next:** Begin Phase 2 (security architecture) or integrate new features

---

### If Tests Fail

**Troubleshooting:**

**Issue:** Edit button doesn't appear  
**Check:** Status badge visible? (Both use Stack overlay)  
**Fix:** Verify work_view.dart modifications applied

**Issue:** Save button always disabled  
**Check:** Form validation logic  
**Fix:** Verify _validateForm() in edit sheet

**Issue:** Status dropdown shows all options  
**Check:** Workflow service integration  
**Fix:** Verify canTransition() method

**Issue:** Save fails silently  
**Check:** Console for error messages  
**Fix:** Verify database migration ran successfully

---

## Success Criteria

**Phase 1 is COMPLETE when:**

- [x] Build succeeds with zero errors ✅
- [x] Application launches ✅
- [ ] Manual tests pass (work in progress)
- [ ] Automated tests pass (pending)
- [ ] No regression in existing features (pending)

---

## Validation Sign-Off

**Tested By:** _______________  
**Date:** _______________  
**Result:** [ ] PASS  [ ] FAIL (with notes)  
**Notes:**

---

**Ready for:** User acceptance testing  
**Next Phase:** Phase 2 - Security Architecture (Windows SID + Encryption)
