# Portal Wiring Audit
**Date:** 2025-12-14  
**Status:** Comprehensive audit of wired vs. unwired features

---

## Executive Summary

**Current State:**
- ✅ UI/UX is **complete** and visually polished
- ⚠️ Most dynamic data is **hardcoded/mocked**
- ⚠️ **No backend API integration** exists
- ✅ **Local database** (SQLite via Drift) is functional
- ✅ **Navigation** is wired and working
- ⚠️ **EVA integration** placeholder exists but not connected

---

## Home Dashboard - Detailed Audit

### ✅ WIRED (Working)

| Feature | Status | Implementation | Data Source |
|---------|--------|----------------|-------------|
| **UI Layout** | ✅ Complete | `home_view.dart` | Static Flutter widgets |
| **Navigation** | ✅ Working | `main.dart` | Local state |
| **User Profile** | ✅ Working | `main.dart` + `app_database.dart` | Local SQLite database |
| **Industry Briefing UI** | ✅ Complete | `news_feed.dart` | **Hardcoded list** |
| **Company Feed UI** | ✅ Complete | `home_view.dart` | **Hardcoded cards** |

### ❌ NOT WIRED (Needs Implementation)

| Feature | Current State | Required Backend | Priority |
|---------|---------------|------------------|----------|
| **Weather Data** | 🔴 Hardcoded: "Clear, 72°F", "North Region" | Weather API or backend service | Medium |
| **Traffic Data** | 🔴 Hardcoded: "Traffic is Light", "22 mins to First Stop: Northwind - Bulverde" | Traffic API + Route calculation | Medium |
| **Open Calls Metric** | 🔴 Hardcoded: "6" | Work Order Service: `GET /api/portal/work-orders?status=open&count=true` | **High** |
| **Completed Metric** | 🔴 Hardcoded: "2" | Work Order Service: `GET /api/portal/work-orders?status=completed&today=true&count=true` | **High** |
| **This Week Metric** | 🔴 Hardcoded: "12" | Work Order Service: `GET /api/portal/work-orders?week=true&count=true` | **High** |
| **Industry Briefing Data** | 🔴 Hardcoded news items | RSS feed aggregator or news API | Low |
| **Company Feed Actions** | 🔴 Empty callbacks: `onAction: () {}` | HR/Policy endpoints or local navigation | Medium |

---

## Navigation Screens - Detailed Audit

### ✅ WIRED

| Screen | Status | Data Source | Notes |
|--------|--------|-------------|-------|
| **Locations** | ✅ Wired | Local SQLite (`app_database.dart`) | Fully functional with maps |
| **People** | ✅ Wired | Local SQLite (`app_database.dart`) | Users can be edited |
| **Operations** | ✅ Wired | Local SQLite (`app_database.dart`) | Basic operations view |

### ⚠️ PARTIALLY WIRED

| Screen | Status | Data Source | Missing |
|--------|--------|-------------|---------|
| **Work** | ⚠️ Partial | Local SQLite (Sites only) | Work orders not implemented, shows sites as placeholders |
| **Home** | ⚠️ Partial | See Home Dashboard section above | Metrics hardcoded |

### ❌ NOT WIRED

| Screen | Status | Notes |
|--------|--------|-------|
| **Field Readiness** | ❌ Placeholder | `const Placeholder()` widget only |
| **FLO** | ❌ Placeholder | `const Placeholder()` widget only |
| **Sas** | ❌ Placeholder | `const Placeholder()` widget only |

---

## Backend Integration Status

### ❌ NO API SERVICE EXISTS

**Missing Components:**
1. ❌ No `api_service.dart` or HTTP client wrapper
2. ❌ No base URL configuration
3. ❌ No authentication/authorization headers
4. ❌ No error handling for network requests
5. ❌ No offline/online state detection

**Required API Service Structure:**
```dart
lib/
  services/
    api_service.dart          // ❌ MISSING
    models/
      work_order.dart         // ❌ MISSING
      weather_data.dart       // ❌ MISSING
      traffic_data.dart       // ❌ MISSING
    repositories/
      home_repository.dart    // ❌ MISSING
      work_order_repository.dart // ❌ MISSING
```

---

## Database Integration

### ✅ WIRED (Local SQLite)

| Feature | Status | Implementation |
|---------|--------|----------------|
| **Database Schema** | ✅ Complete | `app_database.dart` via Drift |
| **Tables** | ✅ Working | `Users`, `Clients`, `Sites`, `StartingPoints` |
| **Seeding** | ✅ Working | `seed_service.dart` populates demo data |
| **CRUD Operations** | ✅ Working | Users can be created/read/updated |

### ❌ MISSING (Not in Schema)

| Entity | Needed For | Priority |
|--------|------------|----------|
| **Work Orders** | Work view, Home metrics | **High** |
| **Equipment** | Equipment tracking | **High** |
| **Service History** | History timeline | Medium |
| **Photos** | Photo attachments | Medium |
| **Weather Cache** | Offline weather display | Low |
| **Traffic Cache** | Offline traffic display | Low |

---

## EVA Integration

### ⚠️ PARTIALLY WIRED

| Component | Status | Implementation |
|-----------|--------|----------------|
| **EVA Panel UI** | ✅ Complete | `eva_panel.dart`, `eva_collapse_rail.dart` |
| **EVA State** | ✅ Initialized | `eva_state.dart` with ChangeNotifier |
| **EVA Visibility** | ✅ Working | Collapse/expand functionality works |
| **EVA Chat Interface** | ❌ Not Implemented | No input field, no chat history |
| **EVA Backend Connection** | ❌ Not Implemented | No API calls to EVA service |
| **Knowledge Base Query** | ❌ Not Implemented | Phase 4.3 not started |

**Current State:**
- EVA panel exists as UI shell only
- `EvaState` exists but has no methods for querying
- No connection to knowledge database (Phase 4)
- "EVA" label visible in bottom right (from screenshot)

---

## Action Button Functionality

### ❌ ALL UNWIRED

| Button | Location | Current State | Required Action |
|--------|----------|---------------|-----------------|
| **SELECT BENEFITS** | Company Feed > HR: Open Enrollment | `onAction: () {}` | Navigate to benefits page or external URL |
| **ACKNOWLEDGE** | Company Feed > Safety: Black Ice | `onAction: () {}` | Mark notification as acknowledged (store in DB) |
| **VIEW POLICY** | Company Feed > Fleet: Repair Policy | `onAction: () {}` | Navigate to policy document or modal |
| **View All** | Industry Briefing | No action handler | Navigate to full news feed screen |

---

## Data Flow Analysis

### Current Data Flow (Home Dashboard)

```
home_view.dart
  ├─> Weather/Traffic: Hardcoded strings
  ├─> Metrics (Open Calls, Completed, This Week): Hardcoded numbers
  ├─> Industry Briefing: Hardcoded NewsItem list in news_feed.dart
  └─> Company Feed: Hardcoded NewsCard widgets
```

### Required Data Flow (After Wiring)

```
home_view.dart
  ├─> HomeRepository (NEW)
  │     ├─> API Service (NEW)
  │     │     ├─> GET /api/portal/dashboard/metrics
  │     │     ├─> GET /api/portal/weather
  │     │     └─> GET /api/portal/traffic
  │     └─> Local SQLite cache (for offline)
  ├─> NewsRepository (NEW)
  │     └─> GET /api/portal/news/industry
  └─> CompanyFeedRepository (NEW)
        └─> GET /api/portal/notifications/company
```

---

## Backend Services Status

### ✅ AVAILABLE (From fsc-enterprise-core)

Based on codebase search:

| Service | Status | Endpoints Available |
|---------|--------|---------------------|
| **Location Service** | ✅ Implemented | `/api/portal/locations/*` |
| **Equipment Service** | ✅ Implemented | `/api/portal/equipment/*` |
| **Operations Service** | ✅ Implemented | `/api/portal/operations/*` |

### ❌ MISSING (Required for Home Dashboard)

| Service | Endpoint Needed | Priority |
|---------|-----------------|----------|
| **Dashboard Service** | `GET /api/portal/dashboard/metrics` | **High** |
| **Weather Service** | `GET /api/portal/weather?region=...` | Medium |
| **Traffic Service** | `GET /api/portal/traffic?route=...` | Medium |
| **News/Feed Service** | `GET /api/portal/notifications/company` | Low |
| **Work Order Service** | `GET /api/portal/work-orders?*` | **High** |

---

## Summary Statistics

### Wired vs. Unwired

| Category | Wired | Partially Wired | Unwired | Total |
|----------|-------|-----------------|---------|-------|
| **UI Components** | 15 | 0 | 0 | 15 |
| **Data Sources** | 3 (Local DB) | 1 (Work view) | 8 (Home dashboard) | 12 |
| **Backend Services** | 3 | 0 | 5 | 8 |
| **Action Handlers** | 0 | 0 | 4 | 4 |
| **Navigation Screens** | 3 | 2 | 3 | 8 |

### Critical Gaps

1. **🔴 No API Service Layer** - Cannot connect to backend
2. **🔴 Home Dashboard Metrics** - All hardcoded
3. **🔴 Work Orders** - Not in database schema, no service
4. **🔴 EVA Backend** - No connection to knowledge base
5. **🔴 Action Buttons** - All empty handlers

---

## Next Steps

See `PORTAL_WIRING_PLAN.md` for detailed implementation plan.
