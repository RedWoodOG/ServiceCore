# Quick Testing Guide - Offline-Portal

**For:** Manual verification testing  
**Time Required:** 15-30 minutes  
**Prerequisites:** Application executable exists and launches

---

## Step 1: Launch Application

1. Navigate to: `H:\FSC_Portal\Offline-Portal\build\windows\x64\runner\Release\`
2. Double-click `portal_offline.exe`
3. **OR** run from terminal:
   ```powershell
   cd H:\FSC_Portal\Offline-Portal
   .\build\windows\x64\runner\Release\portal_offline.exe
   ```

**Expected:**
- Application window opens
- No error dialogs
- Database initializes (may take 1-2 seconds on first launch)
- Home view displays

**If errors occur:** Note them in VERIFICATION_TESTING.md

---

## Step 2: Quick Visual Check

### Navigation Sidebar (Left)
- [ ] Logo/icon visible at top
- [ ] 9 navigation items listed
- [ ] User profile at bottom (shows name/role)
- [ ] Sidebar is 240px wide

### Main Content Area (Center)
- [ ] Home view displays (should be default)
- [ ] Content fills available space

### EVA Panel (Right)
- [ ] EVA rail visible (56px wide, vertical bar)
- [ ] EVA icon visible
- [ ] Click it to expand (should become 400px panel)

---

## Step 3: Test Each Navigation Item

### Home (Default View)
**Check:**
- [ ] Header with "PORTAL" branding
- [ ] Morning Briefing section (Weather + Traffic)
- [ ] 3 KPI cards (Open Calls, Completed, This Week)
- [ ] Industry Briefing (horizontal scrolling news)
- [ ] Company Feed (horizontal scrolling announcements)

**Time:** 2 minutes

---

### Work
**Check:**
- [ ] Filter chips at top (All, Open, On Hold, Completed)
- [ ] Work orders list displays
- [ ] Each work order shows: Status, Site, Client, Equipment
- [ ] Click a work order → Details dialog opens
- [ ] Details show: Description, Equipment, Appointments, Work Performed, Notes

**Time:** 3 minutes

---

### Field Readiness
**Expected:** Placeholder only (gray/empty)
- [ ] Placeholder displays
- [ ] No functionality (expected)

**Time:** 10 seconds

---

### Operations
**Check:**
- [ ] Header with "Operations" title
- [ ] Client filter dropdown (top-right)
- [ ] 3 client cards display (Northwind, Lone Star Bank, Gulf Coast Bank)
- [ ] Each card shows site count
- [ ] Click a client → Details view shows all sites
- [ ] Site cards show: Branch name, Address, Region, Coordinates
- [ ] Back button works

**Time:** 2 minutes

---

### Locations
**Check:**
- [ ] Map displays (OpenStreetMap)
- [ ] 6 site markers visible (colored by client)
- [ ] 3 starting point markers visible (green home icons)
- [ ] PM Mode toggle (top-right panel)
- [ ] Turn on PM Mode:
  - [ ] Starting point dropdown appears
  - [ ] Select a starting point
  - [ ] Purple route line appears
  - [ ] Route shows: Start → Farthest → 5 Closest
- [ ] Legend visible (bottom-left)

**Time:** 3 minutes

---

### People
**Check:**
- [ ] "People" title displays
- [ ] Users display in grid (3 columns)
- [ ] User cards show: Avatar, Name, Role, Email
- [ ] Click a user card → Details dialog opens
- [ ] Dialog shows full user information

**Time:** 2 minutes

---

### Knowledge
**Check:**
- [ ] "Knowledge Base" title
- [ ] Search box at top
- [ ] Type in search → Results appear
- [ ] Clear search → Category list appears
- [ ] Click a category → Category view opens
- [ ] Click an entry → Entry view opens
- [ ] Entry view shows markdown content (formatted text)

**Time:** 3 minutes

---

### FLO
**Expected:** Placeholder only
- [ ] Placeholder displays
- [ ] No functionality (expected)

**Time:** 10 seconds

---

### Sas
**Expected:** Placeholder only
- [ ] Placeholder displays
- [ ] No functionality (expected)

**Time:** 10 seconds

---

## Step 4: Test EVA Panel

### Collapsed State (Default)
- [ ] EVA rail visible on right (56px)
- [ ] EVA icon visible
- [ ] Click to expand

### Expanded State
- [ ] Panel expands to 400px
- [ ] Header shows "EVA" and "Embedded Intelligence"
- [ ] Empty state message: "EVA is ready"
- [ ] Input field at bottom
- [ ] Send button visible
- [ ] Type in input → Text appears (but no action - expected)
- [ ] Click send → Nothing happens (expected - structural only)
- [ ] Click collapse button → Panel collapses

**Time:** 1 minute

---

## Step 5: Test Data Connectivity

### Verify Database Data
**Check that seed data loaded:**
- [ ] Operations view shows 3 clients
- [ ] Locations view shows 6 sites
- [ ] Locations view shows 3 starting points
- [ ] People view shows users
- [ ] Knowledge view shows categories and entries
- [ ] Work view shows work orders (if seeded)

**If data missing:**
- Check console for database errors
- Database may need manual seeding

**Time:** 2 minutes

---

## Step 6: Test Interactive Features

### Real-Time Updates (Home View KPIs)
- [ ] Note current "Open Calls" number
- [ ] (If possible) Create a work order in database
- [ ] Verify number updates automatically
- [ ] Repeat for "Completed" and "This Week"

**Note:** May require database manipulation to test fully

**Time:** 2 minutes

### Navigation Buttons (Work View)
- [ ] Find a work order with "Navigate" button
- [ ] Click "Navigate"
- [ ] Verify external app opens (Google Maps, if implemented)

**Time:** 1 minute

### Action Buttons (Home View - Company Feed)
- [ ] Find a Safety announcement with "ACKNOWLEDGE" button
- [ ] Click "ACKNOWLEDGE"
- [ ] Verify snackbar message appears
- [ ] Verify announcement updates (may need refresh)

**Time:** 1 minute

---

## Step 7: Error Scenarios

### Test Error Handling
- [ ] Resize window to very small → Check for overflow
- [ ] Navigate rapidly between views → Check for crashes
- [ ] Test with empty database (if possible) → Check empty states
- [ ] Check console for errors/warnings

**Time:** 2 minutes

---

## Step 8: Performance Check

### Startup
- [ ] Time from launch to first view: ________ seconds
- [ ] Time for database initialization: ________ seconds

### Runtime
- [ ] View switching is smooth (no lag)
- [ ] Map tiles load quickly
- [ ] Lists scroll smoothly
- [ ] Dialogs open/close quickly

### Memory
- [ ] Check Task Manager → Memory usage reasonable
- [ ] No memory leaks after extended use

**Time:** 2 minutes

---

## Step 9: Document Findings

### Use VERIFICATION_TESTING.md
1. Open `VERIFICATION_TESTING.md`
2. Fill in checkboxes as you test
3. Document any issues in "Issues Found" sections
4. Note console errors/warnings
5. Record performance metrics
6. Add screenshots if helpful

### Quick Issue Template
```
**Issue:** [Brief description]
**Location:** [Which view/feature]
**Steps to Reproduce:** [How to trigger]
**Expected:** [What should happen]
**Actual:** [What actually happens]
**Severity:** [Critical / High / Medium / Low]
```

---

## Common Issues & Solutions

### Application Won't Launch
- **Check:** Flutter runtime dependencies installed
- **Check:** Windows version compatibility
- **Check:** Console for error messages

### Database Errors
- **Check:** SQLite libraries linked correctly
- **Check:** Database file permissions
- **Check:** Seed data script ran

### Map Won't Load
- **Check:** Internet connection (for OpenStreetMap tiles)
- **Check:** Map controller initialization
- **Check:** Console for network errors

### Views Show Empty/No Data
- **Check:** Database seeded correctly
- **Check:** Database queries in console
- **Check:** Seed service ran on first launch

---

## Testing Checklist Summary

**Quick Pass (5 minutes):**
- [ ] App launches
- [ ] All 9 navigation items accessible
- [ ] Home view displays data
- [ ] No red error screens
- [ ] EVA panel expands/collapses

**Full Pass (15-30 minutes):**
- [ ] Complete VERIFICATION_TESTING.md
- [ ] Test all implemented views
- [ ] Test all interactive features
- [ ] Verify database connectivity
- [ ] Test error scenarios
- [ ] Check performance

---

## Next Steps After Testing

1. **Review Findings:**
   - Compile all issues
   - Prioritize by severity
   - Document in issue tracker (if available)

2. **Update Documentation:**
   - Update SOTU.md with test results
   - Update FINISH_LINE.md if Phase 2 complete
   - Note any new issues found

3. **Plan Fixes:**
   - Address critical issues first
   - Schedule fixes for non-critical issues
   - Plan enhancements based on findings

---

**Happy Testing!** 🚀

If you encounter any issues not covered here, document them in VERIFICATION_TESTING.md for follow-up.
