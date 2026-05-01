# Operations Data Model + Offline Wiring - COMPLETE ✅

**Date:** 2025-12-14  
**Status:** Operations domain model fully implemented and wired offline-first

---

## Executive Summary

✅ **Complete Operations domain model** replaces shallow `work_calls` scaffolding  
✅ **8 new tables** added to support full service workflow  
✅ **Operations tab** wired to real work orders with detail views  
✅ **EVA read access** implemented for all Operations data  
✅ **Offline-first** - all queries from local SQLite only  
✅ **Backward compatible** - `work_calls` preserved, no breaking changes

---

## Schema Migration (v4 → v5)

### New Tables Added

1. **`work_orders`** - Service tickets (the spine)
   - `id`, `site_id`, `status`, `priority`, `description_of_work`, `internal_notes`
   - `created_at`, `closed_at`, `created_by`, `assigned_technician`

2. **`appointments`** - Scheduled time blocks
   - `id`, `work_order_id`, `scheduled_start`, `expected_duration_minutes`, `technician`

3. **`equipment`** - Installed equipment with serial tracking
   - `id`, `site_id`, `equipment_type`, `manufacturer`, `model`, `serial_number`
   - `under_warranty`, `under_service_contract`, `contract_reference`, `active`

4. **`work_order_equipment`** - Junction table (many-to-many)
   - `work_order_id`, `equipment_id` (composite primary key)

5. **`work_performed`** - Historical technician work logs
   - `id`, `work_order_id`, `equipment_id`, `technician`, `started_at`
   - `duration_minutes`, `work_description`, `resolution`, `repeat_issue`

6. **`parts_used`** - Parts consumed during work
   - `id`, `work_performed_id`, `part_number`, `description`, `quantity`

7. **`notes`** - POIs, warnings, internal notes
   - `id`, `site_id`, `work_order_id`, `note_type`, `note_text`
   - `created_at`, `created_by`

8. **`documents`** - Attachments tied to work orders
   - `id`, `work_order_id`, `file_name`, `file_path`, `uploaded_at`, `uploaded_by`

### Migration Strategy

- ✅ Schema version incremented: 4 → 5
- ✅ Migration path: `if (from < 5)` adds all new tables
- ✅ `work_calls` table preserved (not deleted)
- ✅ Existing data intact
- ✅ App continues to run after migration

---

## Database Queries Added

### Work Orders
- `getAllWorkOrders()` - List all work orders
- `getWorkOrdersBySite(siteId)` - Work orders for a site
- `getWorkOrderById(id)` - Single work order
- `getWorkOrdersByStatus(status)` - Filter by status
- `insertWorkOrder()`, `updateWorkOrder()`

### Equipment
- `getEquipmentBySite(siteId)` - Equipment at a site
- `getEquipmentById(id)` - Single equipment record
- `getEquipmentBySerial(serialNumber)` - **Global serial search**
- `searchEquipment(query)` - Search by serial/model/manufacturer
- `getEquipmentByWorkOrder(workOrderId)` - Equipment involved in work order

### Service History
- `getWorkPerformedByWorkOrder(workOrderId)` - Work logs for a work order
- `getWorkPerformedBySite(siteId)` - All work history for a site
- `getNotesBySite(siteId)` - Site notes
- `getNotesByWorkOrder(workOrderId)` - Work order notes

### Related Data
- `getAppointmentsByWorkOrder(workOrderId)` - Scheduled appointments
- `getPartsUsedByWorkPerformed(workPerformedId)` - Parts consumed
- `getDocumentsByWorkOrder(workOrderId)` - Attachments

---

## UI Wiring

### Operations Tab (`work_view.dart`)

**Before:** Showed sites as placeholders  
**After:** Shows real work orders with full detail

**Features:**
- ✅ Lists all work orders from `work_orders` table
- ✅ Filter by status (All, Open, On Hold, Completed)
- ✅ Work order cards show:
  - Status badge (color-coded)
  - Priority badge
  - Site name and client
  - Description of work
  - Equipment involved (chip tags)
  - Assigned technician
  - Created date

**Work Order Detail Dialog:**
- ✅ Full work order information
- ✅ Linked equipment list
- ✅ Appointments schedule
- ✅ Work performed history (with technician, time, description, resolution)
- ✅ Repeat issue flagging
- ✅ Notes (POIs, warnings, general)
- ✅ Internal notes

**Data Source:** All queries from local SQLite, no network calls

---

## Home Dashboard KPIs (Enhanced)

**Updated to query both:**
- `work_calls` table (legacy support)
- `work_orders` table (new Operations model)

**Methods:**
- `getOpenCallsCount()` - Counts open from both tables
- `getCompletedCallsCount()` - Counts completed today from both tables
- `getWeeklyCallsCount()` - Counts completed this week from both tables

**Result:** KPIs reflect total work load across both data models

---

## EVA Read Access

### New Methods in `EvaState`

1. **`getWorkOrderContext(workOrderId)`**
   - Returns full work order with site, equipment, work performed, notes
   - EVA can answer: "What was done on work order X?"

2. **`getSiteServiceHistory(siteId)`**
   - Returns all work performed at a site
   - EVA can answer: "What was done at this location?"

3. **`getEquipmentBySerial(serialNumber)`**
   - Returns equipment details with site and work order count
   - EVA can answer: "What work was done on serial number X?"

### EVA Capabilities

EVA can now answer:
- ✅ "What was done here last time?"
- ✅ "Is this a repeat issue?"
- ✅ "Which serial number was worked on?"
- ✅ "Show me service history for this equipment"
- ✅ "What parts were used on work order X?"

**All queries:** Read-only, local SQLite only, no network calls

---

## Seed Data

**Operations Model Seed Data:**

1. **Equipment:**
   - 1 Magner 305 CDS counter
   - Serial: MAG-305-12345
   - Linked to first site

2. **Work Order (Open):**
   - Status: open
   - Priority: high
   - Description: "Coin sorter not dispensing properly"
   - Assigned: Tech 1
   - Linked to equipment

3. **Appointment:**
   - Scheduled 2 hours from now
   - Duration: 60 minutes
   - Technician: Tech 1

4. **Work Order (Completed):**
   - Status: completed
   - Priority: medium
   - Description: "Routine maintenance and calibration"
   - Closed last week

5. **Work Performed:**
   - Technician: Tech 1
   - Duration: 90 minutes
   - Description: "Calibrated coin sensors, cleaned sorting mechanism"
   - Resolution: "Equipment operating normally after calibration"
   - Repeat issue: false

6. **Parts Used:**
   - Part number: MAG-305-SENSOR-01
   - Description: Replacement sensor
   - Quantity: 1

7. **Note:**
   - Type: poi (point of interest)
   - Text: "Equipment performs better after morning hours"
   - Created by: Tech 1

---

## Files Modified

### Database Schema
- `lib/database/app_database.dart` - Added 8 new tables, queries, migration to v5

### Seed Data
- `lib/database/seed_service.dart` - Added Operations model seed data

### UI Components
- `lib/features/work/work_view.dart` - Completely rewired to use real work orders
- `lib/features/home/home_view.dart` - KPIs now query both work_calls and work_orders

### EVA Integration
- `lib/app_shell/eva_state.dart` - Added 3 new read access methods for Operations data

---

## Definition of "Done" ✅

✅ Schema migrated successfully (v4 → v5)  
✅ App launches with no errors  
✅ Operations tab renders real work orders data  
✅ Work order detail view shows all related data  
✅ Location history is queryable  
✅ EVA can reason over work history  
✅ No backend dependency introduced  
✅ All queries from local SQLite  
✅ App works fully offline

---

## Query Examples (EVA Can Answer)

**Q: "What was done at Northwind Bulverde last time?"**  
A: EVA calls `getSiteServiceHistory(siteId)` → Returns work performed with technician, description, resolution

**Q: "Is work order 1 a repeat issue?"**  
A: EVA calls `getWorkOrderContext(1)` → Checks `workPerformed[].repeatIssue` flag

**Q: "Which serial number was worked on in work order 2?"**  
A: EVA calls `getWorkOrderContext(2)` → Returns equipment array with serial numbers

**Q: "Show me all work done on MAG-305-12345"**  
A: EVA calls `getEquipmentBySerial("MAG-305-12345")` → Returns equipment + work order count, can drill into history

---

**Operations Data Model: COMPLETE**  
**Location-centric, equipment-tracked, offline-first service workflow**
