# Quick Actions Functionality Specification

## Overview
The Home page Quick Actions panel provides fast access to common field service tasks. Each action should be functional and integrated with the existing database schema.

---

## 1. Scan Receipt

### Purpose
Capture and store expense receipts for reimbursement or expense tracking.

### Functionality
1. **Camera/Image Picker**
   - Open device camera to take photo of receipt
   - OR open image picker to select existing photo from gallery
   - Support for multiple images (front/back of receipt)

2. **Receipt Processing**
   - Save image(s) to local storage
   - Create a Document entry in the `documents` table
   - Link to current user and optionally to:
     - Active work order (if on a job)
     - Site (if at a location)
     - Or standalone (general expense)

3. **Metadata Capture** (Optional modal/form)
   - Amount (if OCR available, otherwise manual entry)
   - Date of receipt
   - Category (fuel, meals, supplies, etc.)
   - Vendor/merchant name
   - Notes

4. **Storage**
   - Images saved to: `%USERPROFILE%\Documents\portal_offline\receipts\`
   - Database entry in `documents` table with:
     - `fileName`: Original filename or generated name
     - `filePath`: Full path to saved image
     - `workOrderId`: Optional (if on a job)
     - `siteId`: Optional (if at a location)
     - `uploadedAt`: Timestamp
     - `uploadedBy`: Current user

### User Flow
1. User taps "Scan Receipt"
2. Modal appears: "Take Photo" or "Choose from Gallery"
3. User captures/selects image
4. Optional: Quick metadata form (amount, date, category)
5. Receipt saved and confirmation shown
6. Receipt appears in Documents section (future: Expenses view)

---

## 2. New Note

### Purpose
Quickly create notes for sites, work orders, or general observations.

### Functionality
1. **Note Creation Modal**
   - Opens a bottom sheet with note input form
   - Fields:
     - Note text (required, multiline)
     - Note type dropdown: "General", "POI" (Point of Interest), "Warning"
     - Link to Site (optional dropdown - select from recent sites or search)
     - Link to Work Order (optional dropdown - select from open work orders)
     - Tags/keywords (optional)

2. **Database Storage**
   - Creates entry in `notes` table:
     - `siteId`: Selected site (required - use first site if none selected)
     - `workOrderId`: Selected work order (optional)
     - `noteType`: Selected type
     - `noteText`: Note content
     - `createdAt`: Current timestamp
     - `createdBy`: Current user

3. **Smart Context** (Optional enhancement)
   - If user is viewing a site/work order, pre-populate the link
   - Show recent notes in the modal for reference

### User Flow
1. User taps "New Note"
2. Bottom sheet opens with note form
3. User enters note text and selects type
4. Optionally links to site/work order
5. Note saved and confirmation shown
6. Note appears in Operations view under relevant site/work order

---

## 3. Map View

### Purpose
Quick access to the map view showing all sites and locations.

### Functionality
1. **Navigation**
   - Switch to Locations view (index 3 in main navigation)
   - The Locations view already contains a full interactive map with:
     - All sites displayed as colored markers (by client)
     - Starting points displayed as home icons
     - PM Mode for route planning
     - Interactive markers - tap to see site details
     - Route visualization (when PM Mode is enabled)

2. **Map Features** (Already in Locations view)
   - OpenStreetMap tile layer
   - Site markers colored by client (Northwind=blue, LoneStar=yellow, GulfCoast=red)
   - Starting point markers (green home icons)
   - PM Route polyline (purple line connecting sites)
   - Site detail sheets on marker tap
   - PM Mode toggle for route calculation

### User Flow
1. User taps "Map View" quick action
2. Main navigation switches to Locations view (index 3)
3. User sees the full map with:
   - All sites as colored markers
   - Starting points
   - Can enable PM Mode to see optimized routes
   - Can tap any site marker to see details
   - Can interact with map controls

### Implementation
- Create `NavigationState` ChangeNotifier (similar to `EvaState`)
- Provide it at app root level
- HomeView can call `navigationState.navigateToLocations()` to switch to index 3
- MainNavigationScreen listens to NavigationState and updates `_selectedIndex`
- The map is already fully functional in LocationsView - just need to navigate there

---

## 4. Contact IT

### Purpose
Quick access to IT support resources and knowledge base.

### Functionality
1. **Knowledge Base Search**
   - Open Knowledge Base view
   - Pre-populate search with "IT" or "support" keywords
   - Show IT-related categories (if they exist)
   - OR open EVA panel with pre-filled query: "IT support" or "technical help"

2. **Alternative: Support Contact** (If email/contact info available)
   - Show IT support contact information
   - Email: `it-support@fsc.com` (or from user profile/settings)
   - Phone: IT support number
   - Quick actions:
     - "Send Email" - Opens email client
     - "Call Support" - Opens phone dialer
     - "Search Knowledge Base" - Opens KB with IT filter

3. **EVA Integration** (Recommended)
   - Open EVA panel (if collapsed, expand it)
   - Pre-fill query: "I need IT support" or "technical issue"
   - EVA searches knowledge base and provides relevant articles
   - User can ask follow-up questions

### User Flow
1. User taps "Contact IT"
2. **Option A (EVA Integration):**
   - EVA panel expands (if collapsed)
   - Query pre-filled: "I need IT support"
   - EVA searches knowledge base and responds
   - User can continue conversation

3. **Option B (Knowledge Base):**
   - Navigate to Knowledge Base
   - Search pre-filled with "IT" or "support"
   - Show IT-related articles

4. **Option C (Contact Info):**
   - Show modal with IT contact information
   - Quick actions: Email, Call, Search KB

---

## Implementation Priority

### Phase 1 (Essential)
1. **New Note** - Uses existing `notes` table, straightforward implementation
2. **Map View** - Navigate to Locations view (assumes map exists there)

### Phase 2 (Moderate)
3. **Contact IT** - EVA integration or Knowledge Base search
4. **Scan Receipt** - Requires image picker/camera, file storage, Documents table integration

---

## Technical Requirements

### Dependencies Needed
- **Scan Receipt**: `image_picker` package for camera/gallery access
- **Map View**: Map integration (if not already in Locations view)
- **New Note**: No new dependencies (uses existing database)
- **Contact IT**: No new dependencies (uses existing EVA/Knowledge Base)

### Database Tables Used
- `notes` - For New Note
- `documents` - For Scan Receipt
- `sites` - For Map View and note linking
- `workOrders` - For note linking
- `knowledgeEntries` - For Contact IT

---

## User Experience Considerations

1. **Offline-First**: All actions should work offline
   - Receipts saved locally, synced later
   - Notes saved immediately to local database
   - Map uses cached location data
   - IT support uses local knowledge base

2. **Quick Access**: Actions should be fast
   - Minimal taps to complete action
   - Pre-fill context when possible
   - Show immediate feedback

3. **Context Awareness**: 
   - If user is viewing a site, pre-link notes/receipts
   - If user has active work order, pre-link documents
   - Show relevant quick actions based on current context
