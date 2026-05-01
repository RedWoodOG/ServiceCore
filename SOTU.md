# State of the Union (SOTU) - Offline Portal
**Last Updated:** January 3, 2025  
**Project:** Offline-Portal - Field Service Application  
**Status:** Beta - Feature Complete, Production Ready

---

## 🎯 Project Overview

**Offline-Portal** is a fully offline-first Flutter application for banking equipment field service technicians. The app runs 100% locally using Drift (SQLite) with reactive data streams, featuring maps, work orders, knowledge base, and an embedded AI assistant (EVA) that can answer questions from the local knowledge base.

---

## ✅ Completed Features

### 1. Database & Data Layer
- **Drift (SQLite) Database** - Fully implemented (Schema Version 8)
  - **Core Tables:**
    - `Clients` - Client companies (Northwind, Lone Star Bank, Gulf Coast Bank)
    - `Sites` - Branch locations with coordinates
    - `StartingPoints` - Starting locations for routing
    - `Users` - Team members with full profiles
    - `WeatherSnapshot` - Cached weather data
    - `TrafficSnapshot` - Cached traffic data
    - `WorkCalls` - Work call tracking for KPIs
    - `IndustryBriefing` - News feed items
    - `CompanyAnnouncements` - Internal company feed
    - `WorkOrders` - Complete work order system
    - `Appointments` - Scheduled appointments
    - `Equipment` - Equipment inventory per site
    - `WorkOrderEquipment` - Equipment linked to work orders
    - `WorkPerformed` - Work performed records
    - `PartsUsed` - Parts inventory tracking
    - `Notes` - General notes system
    - `Documents` - Document/photo storage
    - `KnowledgeEntries` - Knowledge base entries (94+ entries)
    - `ChatChannels` - Chat channels (FLO messaging - currently disabled)
    - `ChatMessages` - Chat messages

- **Reactive Data Streams** - All major queries use `.watch()` for real-time updates
  - `watchActiveCompanyAnnouncements()` - Company feed updates
  - `watchLatestIndustryBriefing()` - News feed updates
  - `watchAllUsers()` - People list updates
  - `watchAllKnowledgeEntries()` - Knowledge base updates
  - `watchDistinctCategories()` - Knowledge categories
  - `watchKnowledgeEntriesByCategory()` - Category-filtered entries

- **Seed Data Service** - Auto-seeding on first launch
  - 3 Clients with theme colors
  - 6+ Sites with coordinates
  - 3 Starting Points
  - 5+ Team members (Demo Technician, Jeremy Bennet, Demo Technician 3, Demo Technician 1, Demo Technician 4)
  - Automatic knowledge base ingestion from `C:\Portal_Knowledge_Staging\knowledge_entries`
  - Weather and traffic snapshots

### 2. Application Shell & Navigation
- **Main Navigation Screen** - Sidebar-based navigation
  - Left sidebar (240px) with logo, nav items, user profile
  - 7 active navigation items: Home, Work, Operations, Locations, People, Knowledge, Settings
  - FLO messaging disabled (removed from navigation)
  - Persistent across all views
  - `NavigationState` ChangeNotifier for programmatic navigation

- **Portal Shell** - Core layout infrastructure
  - Horizontal Row layout
  - Main content area (Expanded, left)
  - EVA panel (right-anchored, persistent)
  - No overlays, drawers, or Stack hacks

### 3. EVA (Embedded Intelligence Assistant)
- **EVA State Management** - Global state via Provider
  - `isExpanded` - Panel expansion state
  - `isThinking` - Processing indicator
  - `hasUnread` - Notification flag
  - Database integration for knowledge base access

- **EVA Panel** - Right-anchored persistent panel
  - Expanded: 400px width
  - Collapsed: 56px rail
  - Header with EVA branding, status, collapse button
  - Conversation canvas with message history
  - Input bar with query processing
  - **Knowledge Base Integration** - EVA can search and answer questions from ingested knowledge entries
  - **IT Support Detection** - Automatically provides contact info for IT support requests

- **EVA Service** (`eva_service.dart`)
  - Keyword-based knowledge search
  - Content extraction from Markdown
  - Answer synthesis from multiple sources
  - Source citation in responses
  - Greeting detection
  - IT support request handling

### 4. Views & Features

#### Home View (`home_view.dart`)
- **Header** - Portal branding with user profile
- **Weather Section** - Editable weather display with API integration
  - Manual entry or fetch from API by zip code
  - Uses `wttr.in` API (no API key required)
  - Cached in `WeatherSnapshot` table
- **KPI Cards** - Reactive metrics
  - Open Calls (from `WorkCalls` table)
  - Completed (today's completed calls)
  - This Week (weekly call count)
  - All update reactively via StreamBuilder
- **Quick Actions** - Four action buttons
  - **Scan Receipt** - Image picker, receipt metadata, links to site/work order
  - **New Note** - Create notes with type, content, optional site/work order linking
  - **Map View** - Navigate to Locations view
  - **Contact IT** - Opens EVA with pre-filled IT support query
- **Industry Briefing** - Reactive news feed
  - Horizontal scrolling news cards
  - Featured card (300px) + standard cards (160px)
  - Gradient overlays for text readability
  - Updates reactively from `IndustryBriefing` table
  - Visual indicators: item count and "Updated Xm ago" timestamp
- **Company Feed** - Reactive internal announcements
  - HR, Safety, Fleet categories
  - Action buttons (Select Benefits, Acknowledge, View Policy)
  - Updates reactively from `CompanyAnnouncements` table
  - Visual indicators: item count and "Updated Xm ago" timestamp
  - Create new announcements via modal sheet
  - Import from PDF newsletter via modal sheet

#### Work View (`work_view.dart`)
- **Work Order List** - Displays all work orders
  - Status badges (Open, In Progress, Completed, On Hold)
  - Priority indicators
  - Site and client information
  - Assigned technician
  - Description and notes
- **Create Work Order** - Comprehensive form (`create_work_order_sheet.dart`)
  - Client selection (required)
  - Site selection or creation
  - Status, Priority, Description
  - Assigned Technician
  - Internal Notes, Special Instructions
  - Checklist items
  - Customer/Internal Reference numbers
  - Equipment selection (existing or new)
  - Photo/document attachments
  - New site creation with optional coordinates
  - Links to Operations view for site management

#### Locations View (`locations_view.dart`)
- **OpenStreetMap Integration** - `flutter_map` with dark theme
- **Site Markers** - Color-coded by client theme
- **Starting Point Selection** - Dropdown for routing origin
- **PM Routing Algorithm** - Farthest First routing
- **Polyline Visualization** - Route visualization
- **Site Detail Sheet** - Modal with site information, equipment list, documents

#### Operations View (`operations_view.dart`)
- **Client Management** - List of all clients
  - Client filter dropdown
  - Client detail view showing all sites
  - Site cards with address, region, coordinates
  - Equipment count per site
  - Active equipment list with warranty/service contract badges
- **Color-coded Client Themes** - Visual organization

#### People View (`people_view.dart`)
- **User Grid** - Reactive list of all team members
- **User Cards** - Display name, role, email, phone
- **User Details Dialog** - View and edit user information
  - Editable fields: Full Name, Email, Phone, Role, Location, Bio, Date of Birth
  - Updates saved to database
- **Default User** - Demo Technician (Senior Systems Engineer)
  - Email: [redacted-email]
  - Phone: (210) 937-2876

#### Knowledge View (`knowledge_home_view.dart`)
- **Category List** - Reactive list of all knowledge categories
- **Search Functionality** - Search across all entries
- **Category View** - Filtered entries by category
- **Entry View** - Full Markdown rendering
- **Empty State** - Helpful instructions for ingestion
- **Automatic Ingestion** - Runs on app startup from `C:\Portal_Knowledge_Staging\knowledge_entries`
  - Always clears and re-ingests for consistency
  - Verbose logging for troubleshooting

#### Settings View (`settings_view.dart`)
- **Category-based Settings** - Toggle between categories
  - Knowledge Base category
  - General category (placeholder for future settings)
- **Knowledge Base Management**
  - Manual ingestion button (runs ingestion script)
  - Refresh button (UI refresh)
  - Statistics display (entry count, categories, last updated)
- **Settings Icon** - Dedicated navigation item

### 5. Quick Actions Implementation

#### Scan Receipt (`scan_receipt_sheet.dart`)
- Image picker (camera/gallery)
- Receipt metadata: amount, category, date, vendor
- Optional site/work order linking
- Saves image to `portal_offline/receipts/`
- Creates document record in `Documents` table
- Creates note with receipt metadata

#### New Note (`new_note_sheet.dart`)
- Note content (required)
- Note type dropdown
- Optional site/work order linking
- Saves to `Notes` table

#### Map View
- Programmatic navigation to Locations view (index 3)
- Uses `NavigationState` for navigation

#### Contact IT
- Opens EVA panel
- Pre-fills query with IT support request
- EVA responds with contact information

### 6. Work Order System

#### Work Order Creation (`create_work_order_sheet.dart`)
- **Client Selection** - Required, dropdown of all clients
- **Site Selection** - Choose existing site or create new
  - New site creation:
    - Branch name, address, region (required)
    - Latitude/longitude (optional, defaults provided)
    - Automatically added to Operations view under selected client
- **Work Order Details**
  - Status: Open, In Progress, Completed, On Hold
  - Priority: Low, Medium, High, Critical
  - Description of Work (required)
  - Assigned Technician (dropdown)
  - Internal Notes, Special Instructions
  - Checklist (multi-line)
  - Customer Reference, Internal Reference
- **Equipment Management**
  - Select existing equipment from site
  - Add new equipment (serial number, model, manufacturer)
  - Equipment automatically linked to work order
- **Photo/Document Attachments**
  - Image picker for photos
  - File picker for documents
  - Saves to `portal_offline/documents/`
  - Creates records in `Documents` table
  - Links to work order

### 7. Weather API Integration

#### Weather Service (`weather_service.dart`)
- **wttr.in API Integration** - Simple, no API key required
- **Fetch by Zip Code** - 5-digit US zip code validation
- **Returns:** Region, Temperature (°F), Condition
- **Error Handling** - Graceful fallback to manual entry
- **Timeout Protection** - 10-second timeout

#### Weather Edit Sheet (`edit_weather_sheet.dart`)
- **API Fetch Section** - Zip code input with fetch button
- **Manual Entry Section** - Direct editing of weather data
- **Auto-fill** - API data populates form fields
- **Validation** - Zip code format validation

### 8. UI/UX & Theming
- **Comprehensive Theme System** (`app_theme.dart`)
  - `AppPalette` - Color primitives (deepBlack, darkGrey, portalBlue, etc.)
  - `AppColors` - Semantic color mapping
  - `AppLayout` - Layout dimensions (sidebarWidth, headerHeight, spacing, radius)
  - `AppTypography` - Font sizes, weights, predefined TextStyles
  - `AppComponents` - Pre-defined BoxDecoration and ButtonStyle
  - `AppIcons` - Icon sizes and colors
  - `AppSpacing` - SizedBox helpers
  - `AppTheme.darkTheme` - Complete ThemeData

- **Design System**
  - Deep black background (#121212)
  - Dark grey surfaces (#1E1E1E)
  - Portal blue primary (#0056D2)
  - Consistent spacing and border radius
  - Glassmorphism-ready components

- **Reactive UI Updates**
  - All feeds use `StreamBuilder` for automatic updates
  - Visual indicators show update timestamps
  - Animated transitions with `AnimatedSwitcher`
  - No manual refresh needed for most features

### 9. Services & Utilities

#### Newsletter Import Service (`newsletter_import_service.dart`)
- PDF parsing for company announcements
- Extracts announcements from PDF newsletters
- Creates `CompanyAnnouncement` records

#### Storage Service (`storage_service.dart`)
- File system operations
- Receipt storage
- Document storage
- Photo storage

#### Log Utility (`util/log.dart`)
- Centralized logging
- Info, error, debug levels

### 10. Scripts & Tools

#### Knowledge Base Scripts
- `ingest_knowledge_entries.dart` - Standalone ingestion script
- `force_ingest_knowledge.dart` - Force clear and re-ingest
- `verify_knowledge_entries.dart` - Verification script

#### Database Scripts
- `fix_starting_points.dart` - Coordinate fixes
- `update_starting_points.dart` - Starting point updates
- `import_newsletter.dart` - Newsletter import script

---

## 🏗️ Architecture

### File Structure
```
lib/
 ├─ app_shell/              # Application shell infrastructure
 │   ├─ portal_shell.dart   # Core layout (Row with EVA on right)
 │   ├─ eva_panel.dart      # Full EVA panel (400px expanded)
 │   ├─ eva_collapse_rail.dart  # Collapsed rail (56px)
 │   ├─ eva_state.dart      # Global EVA state management
 │   └─ navigation_state.dart  # Navigation state management
 ├─ database/               # Data layer
 │   ├─ app_database.dart   # Drift schema & queries (v8)
 │   ├─ app_database.g.dart # Generated code
 │   ├─ app_database_standalone.dart  # Standalone script DB
 │   └─ seed_service.dart   # Demo data seeding + auto-ingestion
 ├─ features/               # Feature modules
 │   ├─ home/               # Home dashboard
 │   │   ├─ home_view.dart
 │   │   ├─ create_announcement_sheet.dart
 │   │   ├─ edit_weather_sheet.dart
 │   │   ├─ import_newsletter_sheet.dart
 │   │   ├─ new_note_sheet.dart
 │   │   └─ scan_receipt_sheet.dart
 │   ├─ work/               # Work orders
 │   │   ├─ work_view.dart
 │   │   └─ create_work_order_sheet.dart
 │   ├─ locations/          # Map view
 │   │   ├─ locations_view.dart
 │   │   └─ site_detail_sheet.dart
 │   ├─ operations/         # Operations (database-connected)
 │   │   └─ operations_view.dart
 │   ├─ people/             # People management
 │   │   ├─ people_view.dart
 │   │   ├─ user_card.dart
 │   │   └─ user_details_dialog.dart
 │   ├─ knowledge/          # Knowledge base
 │   │   ├─ knowledge_home_view.dart
 │   │   ├─ knowledge_category_view.dart
 │   │   └─ knowledge_entry_view.dart
 │   └─ settings/          # Settings
 │       └─ settings_view.dart
 ├─ services/               # Business logic services
 │   ├─ eva_service.dart    # EVA query processing
 │   ├─ weather_service.dart  # Weather API integration
 │   ├─ newsletter_import_service.dart
 │   └─ storage_service.dart
 ├─ widgets/                # Reusable widgets
 │   ├─ news_card.dart      # Company feed cards
 │   └─ news_feed.dart      # Industry briefing feed
 ├─ theme/                  # Theming system
 │   └─ app_theme.dart      # Complete design system
 ├─ scripts/                # Standalone scripts
 │   ├─ ingest_knowledge_entries.dart
 │   ├─ force_ingest_knowledge.dart
 │   ├─ verify_knowledge_entries.dart
 │   └─ import_newsletter.dart
 ├─ util/                   # Utilities
 │   └─ log.dart            # Logging utility
 └─ main.dart               # App entry point
```

### State Management
- **Provider** - For database and EVA state
- **Drift** - Reactive database queries with `.watch()` streams
- **ChangeNotifier** - EVA and Navigation state management
- **StreamBuilder** - Reactive UI updates throughout

### Dependencies
- `drift: ^2.20.0` - SQLite database
- `flutter_map: ^8.2.2` - OpenStreetMap integration
- `provider: ^6.1.2` - State management
- `url_launcher: ^6.3.0` - External navigation
- `http: ^1.2.0` - HTTP client for weather API
- `image_picker: ^1.2.1` - Image capture
- `file_picker: ^10.3.8` - File selection
- `syncfusion_flutter_pdf: ^28.1.36` - PDF processing
- `flutter_markdown: ^0.6.18` - Markdown rendering
- `yaml: ^3.1.2` - YAML frontmatter parsing
- `rxdart: ^0.27.7` - Reactive extensions

---

## 🚧 Current Status

### Working Features
✅ Complete database schema (v8) with 20+ tables  
✅ Reactive data streams for all major features  
✅ Navigation and shell layout  
✅ EVA panel with knowledge base integration  
✅ Home view with reactive KPIs and feeds  
✅ Work order creation and management  
✅ Locations view with map and routing  
✅ Operations view with client/site management  
✅ People view with editable user profiles  
✅ Knowledge base with 94+ entries  
✅ Settings view with knowledge base management  
✅ Quick actions (Scan Receipt, New Note, Map View, Contact IT)  
✅ Weather API integration (wttr.in)  
✅ Company announcements and industry briefing feeds  
✅ Equipment and document management  
✅ Site creation from work orders  
✅ Theme system synchronized with Portal app  
✅ Asset management  

### Known Limitations
- FLO messaging (chat) is disabled (removed from navigation)
- Weather API requires internet connection (falls back to manual entry)
- Knowledge base ingestion path is hardcoded to `C:\Portal_Knowledge_Staging\knowledge_entries`
- Some hardcoded user IDs in chat service (non-blocking, chat disabled)
- No real-time sync with external services (offline-first design)

---

## 📋 Recent Updates (January 2025)

### Major Features Added
1. **Reactive Feeds** - All feeds now update automatically using StreamBuilder
2. **Knowledge Base Integration** - EVA can answer questions from ingested knowledge
3. **Settings View** - Dedicated settings section with knowledge base management
4. **Quick Actions** - Four action buttons on home page
5. **Work Order Creation** - Comprehensive work order form with equipment and photos
6. **People Management** - Editable user profiles with all fields
7. **Weather API** - Fetch weather by zip code using wttr.in API
8. **Site Creation** - Create new sites from work order form
9. **Equipment Management** - Add equipment to sites and link to work orders
10. **Document Management** - Photo/document attachments for work orders and receipts

### Technical Improvements
- Database schema upgraded to version 8
- All major queries converted to reactive streams
- Visual indicators for feed updates (timestamps, counts)
- Error handling and validation throughout
- Standalone database script for ingestion
- Automatic knowledge base ingestion on startup

---

## 🔧 Technical Details

### Database Schema (Version 8)
- **20+ Tables** covering all application features
- **Reactive Queries** - All major queries use `.watch()` for streams
- **Migration Strategy** - Handles schema upgrades gracefully
- **Standalone Support** - Separate database class for scripts

### Platform Support
- ✅ Windows (primary, fully tested)
- ⚠️ Android/iOS (compatible but not tested)

### Build Status
- ✅ Compiles without errors
- ✅ No critical warnings
- ⚠️ Minor deprecation warnings (withOpacity)
- ✅ All dependencies resolved

### API Integrations
- **wttr.in Weather API** - No API key required, simple HTTP GET
- **OpenStreetMap** - Via flutter_map package
- **Google Maps** - External navigation via url_launcher

---

## 📝 Notes

- EVA is **right-anchored** and **persistent** across all views
- All feeds are **reactive** and update automatically
- Knowledge base **auto-ingests** on app startup
- Weather can be **fetched from API** or entered manually
- Work orders can **create new sites** that appear in Operations
- People profiles are **fully editable**
- Settings view provides **knowledge base management**
- Application is **offline-first** with local data only
- FLO messaging is **disabled** (removed from navigation)

---

## 🎯 Next Steps (Optional Enhancements)

### Potential Future Features
- [ ] Real-time sync with backend API (when available)
- [ ] Advanced routing algorithms (TSP, genetic algorithms)
- [ ] Photo annotation and markup
- [ ] Offline map tile caching
- [ ] Push notifications (when online)
- [ ] Advanced search in knowledge base
- [ ] Export work orders to PDF
- [ ] Analytics and reporting dashboard
- [ ] Multi-language support
- [ ] Dark/light theme toggle

---

**Status:** ✅ **BETA - PRODUCTION READY**

The application is feature-complete and ready for production deployment. All core functionality is implemented, tested, and working. The application operates fully offline with local SQLite database and reactive UI updates. EVA intelligence is integrated with the knowledge base, and all major workflows are functional.

**Last Major Update:** January 3, 2025 - Weather API integration, People management, Work order enhancements