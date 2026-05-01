# Offline-Portal - Verification Testing Document

**Date:** December 10, 2025  
**Tester:** [Your Name]  
**Build Version:** 1.0.0+1  
**Executable:** `build\windows\x64\runner\Release\portal_offline.exe`

---

## Pre-Testing Checklist

- [ ] Executable exists and is accessible
- [ ] Database should auto-seed on first launch
- [ ] No external dependencies required (offline-first)
- [ ] Windows 10/11 compatible

---

## Test Execution Log

### Test Session 1: Initial Launch

**Date/Time:** December 10, 2025

**Issue Found:** Starting point coordinates were incorrect
- Home Base: Was 29.418, -98.693 → Fixed to 29.4241, -98.4936
- Office (Shop): Was 29.531, -98.432 → Fixed to 29.5150, -98.4600

**Fix Applied:** 
- ✅ Updated seed_service.dart with correct coordinates
- ✅ Added automatic fix script (runs on app startup)
- ✅ Coordinates will auto-update on next app launch

**Date/Time:** _______________

#### Application Startup
- [ ] Application launches without errors
- [ ] No red error screens
- [ ] Database initializes correctly
- [ ] Seed data loads (3 clients, 6 sites, users, knowledge entries)
- [ ] Startup time: ________ seconds

**Observations:**
```
[Document any errors, warnings, or unexpected behavior]
```

---

## Feature-by-Feature Verification

### 1. Main Navigation & Shell

#### 1.1 Sidebar Navigation
- [ ] Sidebar displays correctly (240px width)
- [ ] Logo loads (or shows fallback icon)
- [ ] All 9 navigation items visible
- [ ] Navigation items highlight when selected
- [ ] User profile displays in sidebar footer
- [ ] User profile shows correct name/role

**Issues Found:**
```
[Document any issues]
```

#### 1.2 Portal Shell Layout
- [ ] Main content area displays on left
- [ ] EVA panel/rail visible on right
- [ ] Layout responsive to window resize
- [ ] No layout overflow errors

**Issues Found:**
```
[Document any issues]
```

---

### 2. EVA Panel

#### 2.1 EVA Collapsed State (Default)
- [ ] EVA rail visible (56px width)
- [ ] EVA icon displays
- [ ] Clicking rail expands panel
- [ ] Unread indicator works (if applicable)

**Issues Found:**
```
[Document any issues]
```

#### 2.2 EVA Expanded State
- [ ] Panel expands to 400px width
- [ ] Header displays "EVA" and "Embedded Intelligence"
- [ ] Collapse button works
- [ ] Empty state message shows ("EVA is ready")
- [ ] Input field is visible
- [ ] Send button is visible
- [ ] Input field accepts text (but no action - expected)
- [ ] Send button click does nothing (expected - structural only)

**Issues Found:**
```
[Document any issues]
```

**Expected Behavior (v1.0):**
- ✅ Panel structure works
- ❌ No conversation history (by design)
- ❌ No LLM responses (by design)
- ✅ Input field is structural only

---

### 3. Home View

#### 3.1 Header
- [ ] Portal branding displays
- [ ] User avatar/icon visible

#### 3.2 Morning Briefing
- [ ] Weather section displays
  - [ ] Condition text visible
  - [ ] Temperature visible
  - [ ] Region visible
  - [ ] Timestamp visible (if data >1 hour old)
- [ ] Traffic section displays
  - [ ] Traffic condition visible
  - [ ] Route/ETA visible
- [ ] Data loads from database (not empty)

**Issues Found:**
```
[Document any issues]
```

#### 3.3 KPI Cards
- [ ] Open Calls card displays
  - [ ] Number updates in real-time (if data changes)
  - [ ] Icon displays
  - [ ] Label correct
- [ ] Completed card displays
  - [ ] Number updates in real-time
  - [ ] Icon displays
  - [ ] Label correct
- [ ] This Week card displays
  - [ ] Number updates in real-time
  - [ ] Icon displays
  - [ ] Label correct

**Test Data Changes:**
- [ ] Create a work order → Open Calls increases
- [ ] Complete a work order → Completed increases
- [ ] Verify real-time updates work

**Issues Found:**
```
[Document any issues]
```

#### 3.4 Industry Briefing
- [ ] Section header displays
- [ ] News cards display horizontally
- [ ] Featured card (first) is wider (300px)
- [ ] Standard cards are narrower (160px)
- [ ] Images load (or show fallback)
- [ ] Gradient overlays visible
- [ ] Text readable over images
- [ ] Source and time ago display
- [ ] Horizontal scrolling works
- [ ] At least 5 news items display (if data available)

**Issues Found:**
```
[Document any issues]
```

#### 3.5 Company Feed
- [ ] Section header displays
- [ ] Announcement cards display
- [ ] Cards scroll horizontally
- [ ] Icons display correctly (HR, Safety, Fleet)
- [ ] Colors match categories
- [ ] Action buttons work:
  - [ ] Safety "ACKNOWLEDGE" updates database
  - [ ] Benefits/Policy "VIEW" shows dialog
- [ ] Empty state shows if no announcements

**Issues Found:**
```
[Document any issues]
```

---

### 4. Work View

#### 4.1 Filter Chips
- [ ] All filter chip visible
- [ ] "All" selected by default
- [ ] Clicking filter updates list
- [ ] Selected filter highlighted
- [ ] Filtering works correctly:
  - [ ] "All" shows all work orders
  - [ ] "Open" shows only open
  - [ ] "On Hold" shows only on hold
  - [ ] "Completed" shows only completed

**Issues Found:**
```
[Document any issues]
```

#### 4.2 Work Orders List
- [ ] Work orders display in list
- [ ] Status badges show correct colors
- [ ] Priority badges display (if applicable)
- [ ] Work order ID displays (WO-###)
- [ ] Site name displays
- [ ] Client name displays with correct color
- [ ] Description displays (truncated if long)
- [ ] Equipment chips display
- [ ] Assigned technician displays (if applicable)
- [ ] Date displays correctly formatted
- [ ] Empty state shows if no work orders

**Issues Found:**
```
[Document any issues]
```

#### 4.3 Work Order Details Dialog
- [ ] Clicking work order opens dialog
- [ ] Dialog displays at 600px width
- [ ] Work order ID displays
- [ ] Site information displays
- [ ] Status and priority badges display
- [ ] Description displays (full text)
- [ ] Equipment list displays
- [ ] Appointments display (if any)
- [ ] Work Performed history displays:
  - [ ] Technician name
  - [ ] Start time
  - [ ] Work description
  - [ ] Resolution
  - [ ] Repeat issue indicator (if applicable)
- [ ] Notes display (if any)
- [ ] Internal notes display (if any)
- [ ] Close button works
- [ ] Dialog scrolls if content is long

**Issues Found:**
```
[Document any issues]
```

#### 4.4 Navigation Buttons
- [ ] "Navigate" buttons visible on work orders
- [ ] Clicking opens external Google Maps (if implemented)
- [ ] URL launcher works correctly

**Issues Found:**
```
[Document any issues]
```

---

### 5. Locations View

#### 5.1 Map Display
- [ ] Map loads (OpenStreetMap tiles)
- [ ] Map centers on San Antonio area
- [ ] Map zoom controls work
- [ ] Map panning works
- [ ] No map loading errors

**Issues Found:**
```
[Document any issues]
```

#### 5.2 Site Markers
- [ ] All 6 sites display as markers
- [ ] Site markers colored by client:
  - [ ] Northwind sites = blue
  - [ ] Lone Star Bank sites = yellow
  - [ ] Gulf Coast Bank sites = red
- [ ] Site branch names display on markers
- [ ] Markers positioned correctly

**Issues Found:**
```
[Document any issues]
```

#### 5.3 Starting Points
- [ ] Starting points display as green home icons
- [ ] All 3 starting points visible:
  - [ ] Home Base
  - [ ] Office
  - [ ] Home Base 2
- [ ] Selected starting point highlighted

**Issues Found:**
```
[Document any issues]
```

#### 5.4 PM Mode
- [ ] PM Mode toggle visible (top-right panel)
- [ ] Toggle switches on/off
- [ ] Starting point dropdown appears when PM mode on
- [ ] Dropdown lists all starting points
- [ ] Selecting starting point updates route
- [ ] Route polyline displays (purple line)
- [ ] Route shows: Start → Farthest → 5 Closest
- [ ] Route updates when starting point changes
- [ ] Toggling PM mode off removes route

**Route Verification:**
- [ ] Route starts at selected starting point
- [ ] Route goes to farthest site first
- [ ] Route then goes to 5 closest sites
- [ ] Route line is visible and correct

**Issues Found:**
```
[Document any issues]
```

#### 5.5 Legend
- [ ] Legend displays (bottom-left)
- [ ] All legend items visible:
  - [ ] Starting Points (green)
  - [ ] Northwind Sites (blue)
  - [ ] Lone Star Bank Sites (yellow)
  - [ ] Gulf Coast Bank Sites (red)
  - [ ] PM Route (purple, if PM mode on)
- [ ] Colors match actual markers

**Issues Found:**
```
[Document any issues]
```

---

### 6. Operations View

#### 6.1 Header
- [ ] Operations title displays
- [ ] Client filter dropdown visible
- [ ] Dropdown lists all clients
- [ ] "All Clients" option available

**Issues Found:**
```
[Document any issues]
```

#### 6.2 Clients List View
- [ ] All 3 clients display:
  - [ ] Northwind
  - [ ] Lone Star Bank
  - [ ] Gulf Coast Bank
- [ ] Client cards show:
  - [ ] Client name
  - [ ] Site count (e.g., "2 locations")
  - [ ] Theme color indicator
- [ ] Client icons colored correctly
- [ ] Clicking client shows details
- [ ] Loading indicator shows while loading
- [ ] Empty state shows if no clients

**Issues Found:**
```
[Document any issues]
```

#### 6.3 Client Details View
- [ ] Back button works
- [ ] Client header displays:
  - [ ] Client name
  - [ ] Client icon with theme color
- [ ] Sites list displays all sites for client
- [ ] Site cards show:
  - [ ] Branch name
  - [ ] Address
  - [ ] Region
  - [ ] Coordinates (lat/long)
- [ ] Loading indicator shows while loading
- [ ] Empty state shows if no sites

**Issues Found:**
```
[Document any issues]
```

**Note:** This view has NO map functionality (by design per SOTU.md)

---

### 7. People View

#### 7.1 User List
- [ ] "People" title displays
- [ ] Users display in grid (3 columns)
- [ ] All seed users visible
- [ ] Loading indicator shows while loading
- [ ] Empty state shows if no users
- [ ] Error message shows if database error

**Issues Found:**
```
[Document any issues]
```

#### 7.2 User Cards
- [ ] User cards display:
  - [ ] Avatar with initial
  - [ ] Full name
  - [ ] Role
  - [ ] Email
  - [ ] Location (if available)
- [ ] Cards styled correctly
- [ ] Clicking card opens details dialog

**Issues Found:**
```
[Document any issues]
```

#### 7.3 User Details Dialog
- [ ] Dialog opens on card click
- [ ] Full user information displays
- [ ] Edit functionality works (if implemented)
- [ ] Dialog closes correctly

**Issues Found:**
```
[Document any issues]
```

---

### 8. Knowledge Base

#### 8.1 Knowledge Home View
- [ ] "Knowledge Base" title displays
- [ ] Search box visible
- [ ] Search works as you type
- [ ] Search results display
- [ ] Clear button works
- [ ] Category list displays (when not searching)
- [ ] Categories show correct count
- [ ] Clicking category navigates to category view
- [ ] Loading indicator shows while loading
- [ ] Empty state shows helpful message

**Search Testing:**
- [ ] Search by keyword returns results
- [ ] Search results show title, category, tags
- [ ] Clicking result opens entry view
- [ ] Empty search shows category list

**Issues Found:**
```
[Document any issues]
```

#### 8.2 Knowledge Category View
- [ ] Category name displays
- [ ] Entries in category list
- [ ] Entry cards show title, category, tags
- [ ] Clicking entry opens entry view
- [ ] Back navigation works

**Issues Found:**
```
[Document any issues]
```

#### 8.3 Knowledge Entry View
- [ ] Entry title displays
- [ ] Category badge displays
- [ ] Tags display (if available)
- [ ] Markdown content renders correctly:
  - [ ] Headers (H1, H2, H3, H4)
  - [ ] Paragraphs
  - [ ] Lists (bulleted, numbered)
  - [ ] Code blocks
  - [ ] Inline code
  - [ ] Bold/italic text
  - [ ] Links
- [ ] Content scrolls if long
- [ ] Loading indicator shows while loading
- [ ] Error state shows if entry not found
- [ ] Dark theme styling applied

**Markdown Rendering Test:**
- [ ] Test with various markdown elements
- [ ] Verify styling matches dark theme
- [ ] Check code block formatting

**Issues Found:**
```
[Document any issues]
```

---

### 9. Stubbed Views (Placeholders)

#### 9.1 Field Readiness
- [ ] Navigation item exists
- [ ] Clicking shows placeholder
- [ ] Placeholder displays (empty/gray)

**Expected:** Placeholder only - no functionality

#### 9.2 FLO
- [ ] Navigation item exists
- [ ] Clicking shows placeholder
- [ ] Placeholder displays (empty/gray)

**Expected:** Placeholder only - no functionality

#### 9.3 Sas
- [ ] Navigation item exists
- [ ] Clicking shows placeholder
- [ ] Placeholder displays (empty/gray)

**Expected:** Placeholder only - no functionality

**Issues Found:**
```
[Document any issues]
```

---

## Data Verification

### Database Seeding
- [ ] Database initializes on first launch
- [ ] Seed data loads automatically
- [ ] Verify data exists:
  - [ ] 3 Clients (Northwind, Lone Star Bank, Gulf Coast Bank)
  - [ ] 6 Sites (2 per client)
  - [ ] 3 Starting Points
  - [ ] Users (at least 1)
  - [ ] 94 Knowledge entries
  - [ ] Work orders (if seeded)
  - [ ] Weather snapshot (if seeded)
  - [ ] Traffic snapshot (if seeded)
  - [ ] Industry briefing entries (if seeded)
  - [ ] Company announcements (if seeded)

**Database Location:**
- [ ] SQLite database file created
- [ ] Database persists between launches
- [ ] No database errors in console

---

## Performance Testing

### Startup Performance
- [ ] Application launches in < 3 seconds
- [ ] Database initialization completes quickly
- [ ] First view loads promptly

### Runtime Performance
- [ ] Navigation between views is smooth
- [ ] No lag when switching views
- [ ] Map loads tiles quickly
- [ ] Lists scroll smoothly
- [ ] Dialogs open/close quickly
- [ ] No memory leaks (check Task Manager)

**Performance Metrics:**
- Startup time: ________ seconds
- View switch time: ________ seconds
- Map load time: ________ seconds

---

## Error Handling Testing

### Expected Error Scenarios
- [ ] Missing image assets show fallback
- [ ] Empty database shows appropriate empty states
- [ ] Invalid navigation doesn't crash app
- [ ] Database errors show user-friendly messages
- [ ] No red error screens
- [ ] Console errors documented (if any)

**Errors Encountered:**
```
[Document any errors, including stack traces if available]
```

---

## UI/UX Observations

### Visual Design
- [ ] Dark theme applied consistently
- [ ] Colors match design system
- [ ] Typography consistent
- [ ] Spacing consistent
- [ ] Icons display correctly
- [ ] No visual glitches

### Responsiveness
- [ ] Window resize works
- [ ] Content adapts to window size
- [ ] No overflow errors
- [ ] Scrollbars appear when needed

### Accessibility
- [ ] Text is readable
- [ ] Contrast is adequate
- [ ] Interactive elements are clickable
- [ ] Focus indicators visible (if applicable)

**UI/UX Issues:**
```
[Document any visual or usability issues]
```

---

## Console Output Review

### Expected Console Messages
- [ ] Database initialization messages
- [ ] Seed data loading messages
- [ ] No error stack traces
- [ ] No warning messages (or acceptable warnings)

**Console Output:**
```
[Paste relevant console output here]
```

---

## Critical Issues Found

### Blocking Issues
```
[List any issues that prevent the app from functioning]
```

### Non-Blocking Issues
```
[List issues that don't prevent functionality but should be fixed]
```

### Suggestions for Improvement
```
[List suggestions for enhancements]
```

---

## Test Summary

### Overall Assessment
- [ ] Application is functional
- [ ] All implemented features work as expected
- [ ] Database operations work correctly
- [ ] UI is responsive and polished
- [ ] Ready for alpha deployment

### Test Results Summary

| Feature | Status | Notes |
|---------|--------|-------|
| Main Navigation | ⬜ Pass / ⬜ Fail | |
| EVA Panel | ⬜ Pass / ⬜ Fail | |
| Home View | ⬜ Pass / ⬜ Fail | |
| Work View | ⬜ Pass / ⬜ Fail | |
| Locations View | ⬜ Pass / ⬜ Fail | |
| Operations View | ⬜ Pass / ⬜ Fail | |
| People View | ⬜ Pass / ⬜ Fail | |
| Knowledge Base | ⬜ Pass / ⬜ Fail | |
| Database | ⬜ Pass / ⬜ Fail | |
| Performance | ⬜ Pass / ⬜ Fail | |

### Final Notes

```
[Any final observations, recommendations, or next steps]
```

---

**Test Completed By:** _______________  
**Date:** _______________  
**Signature:** _______________
