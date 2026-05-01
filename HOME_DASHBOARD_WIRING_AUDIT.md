# Home Dashboard - Complete Wiring Audit

**Date:** 2025-12-21  
**Screen:** Home View (`lib/features/home/home_view.dart`)  
**Audit Type:** End-to-End Data Flow Analysis  

---

## Executive Summary

**FINDING: The UI is complete. The data pipelines are STATIC.**

Every visible element on the Home dashboard renders correctly, but **none of them update dynamically**. All data is:
- Loaded once on screen init
- Sourced from static seed data
- Never refreshed
- Never updated from external sources

This is **by design for offline-first**, but there are **NO refresh mechanisms** for when connectivity exists.

---

## Component-by-Component Analysis

### 1. **Header Bar - Weather Widget**

**Location:** Top-left of Morning Briefing card  
**Current Behavior:**
- Displays: "Clear, 72°F" (or similar)
- Source: `weather_snapshot` table (single row)
- Loaded: Once on `initState()` via `_loadLocalData()`
- Updates: **NEVER**

**Data Flow:**
```
initState() → _loadLocalData() → db.getLatestWeather() → weather_snapshot table → setState() → Widget renders
```

**Query Definition:**
```dart
// lib/database/app_database.dart:281-283
Future<WeatherSnapshotData?> getLatestWeather() =>
    (select(weatherSnapshot)..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)]))
        .getSingleOrNull();
```

**Wiring Status:** ⚠️ **PARTIAL**

**What Works:**
- ✅ Reads from local database
- ✅ Displays cached data
- ✅ Shows "As of X time ago" when stale (>1 hour)

**What's Missing:**
- ❌ No HTTP fetch mechanism
- ❌ No background refresh timer
- ❌ No connectivity check
- ❌ No periodic update worker
- ❌ No manual refresh action

**Intended Behavior:**
```
On Startup (if online):
  → Fetch weather from API
  → Cache in weather_snapshot
  → Display fresh data

Every 15-30 minutes (if online):
  → Background refresh
  → Update cache
  → Notify UI to re-render

On Screen Resume:
  → Check cache age
  → Refresh if stale
```

**Required Fix:**
1. Create `WeatherService` with HTTP client
2. Add method: `fetchAndCacheWeather()`
3. Call on app startup
4. Add periodic refresh (Timer or WorkManager)
5. Update `_loadLocalData()` to be reactive (Stream or periodic polling)

---

### 2. **Header Bar - Traffic Widget**

**Location:** Top-right of Morning Briefing card  
**Current Behavior:**
- Displays: "Traffic is Light, 22 mins to First Stop: Northwind - Bulverde"
- Source: `traffic_snapshot` table (single row)
- Loaded: Once on `initState()` via `_loadLocalData()`
- Updates: **NEVER**

**Data Flow:**
```
initState() → _loadLocalData() → db.getLatestTraffic() → traffic_snapshot table → setState() → Widget renders
```

**Query Definition:**
```dart
// lib/database/app_database.dart:289-291
Future<TrafficSnapshotData?> getLatestTraffic() =>
    (select(trafficSnapshot)..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)]))
        .getSingleOrNull();
```

**Wiring Status:** ⚠️ **PARTIAL**

**What Works:**
- ✅ Reads from local database
- ✅ Displays cached route/ETA
- ✅ Color-codes traffic condition (green=light, orange=moderate)

**What's Missing:**
- ❌ No Google Maps API / traffic service integration
- ❌ No route calculation based on current location
- ❌ No real-time traffic updates
- ❌ No refresh mechanism
- ❌ No "first stop" dynamic determination

**Intended Behavior:**
```
On Startup (if online):
  → Get current location
  → Fetch first work order for today
  → Calculate route and traffic
  → Cache in traffic_snapshot
  → Display ETA

Every 10-15 minutes:
  → Refresh traffic conditions
  → Update ETA if changed
  → Notify UI
```

**Required Fix:**
1. Create `TrafficService` with Google Maps API / traffic API
2. Add method: `fetchRouteAndTraffic(origin, destination)`
3. Integrate with work order schedule
4. Add location services
5. Add periodic refresh

---

### 3. **KPI Cards - Open Calls**

**Location:** First card in 3-card row  
**Current Behavior:**
- Displays: "6" (or similar count)
- Source: `work_calls` + `work_orders` tables
- Loaded: Once on `initState()` via `_loadLocalData()`
- Updates: **NEVER**

**Data Flow:**
```
initState() → _loadLocalData() → db.getOpenCallsCount() → 
  (work_calls WHERE status='open' + work_orders WHERE status='open') → 
  setState() → Widget renders
```

**Query Definition:**
```dart
// lib/database/app_database.dart:297-306
Future<int> getOpenCallsCount() async {
  final workCallsResult = await (select(workCalls)
        ..where((w) => w.status.equals('open')))
      .get();
  final workOrdersResult = await (select(workOrders)
        ..where((w) => w.status.equals('open')))
      .get();
  return workCallsResult.length + workOrdersResult.length;
}
```

**Wiring Status:** ⚠️ **PARTIAL**

**What Works:**
- ✅ Queries local database
- ✅ Combines work_calls and work_orders
- ✅ Accurate count based on DB state

**What's Missing:**
- ❌ **No reactivity** - Widget doesn't subscribe to DB changes
- ❌ **No refresh** - Count only updates on screen navigation
- ❌ When work orders change elsewhere in app, this card doesn't update
- ❌ No Stream-based query
- ❌ No change listener

**Intended Behavior:**
```
On DB Change (work order status update):
  → Database emits change event
  → Home screen receives notification
  → Re-query getOpenCallsCount()
  → Update widget
  
OR

Continuous Stream:
  → Convert query to Stream<int>
  → Widget rebuilds automatically on DB changes
```

**Required Fix:**
1. Convert query to Stream: `Stream<int> watchOpenCallsCount()`
2. Use `StreamBuilder` in home_view.dart
3. OR: Implement ChangeNotifier for database state
4. OR: Add manual refresh on screen focus

---

### 4. **KPI Cards - Completed Today**

**Location:** Second card in 3-card row  
**Current Behavior:**
- Displays: "12" (or similar)
- Source: `work_calls` + `work_orders` (completed today)
- Loaded: Once on `initState()`
- Updates: **NEVER**

**Wiring Status:** ⚠️ **PARTIAL** (Same issues as Open Calls)

**What's Missing:**
- ❌ No reactivity
- ❌ No refresh
- ❌ Count doesn't update when work is completed

**Required Fix:** Same as Open Calls (Stream-based query)

---

### 5. **KPI Cards - This Week**

**Location:** Third card in 3-card row  
**Current Behavior:**
- Displays: Weekly completion count
- Source: `work_calls` + `work_orders` (completed this week)
- Loaded: Once on `initState()`
- Updates: **NEVER**

**Wiring Status:** ⚠️ **PARTIAL** (Same issues as Open Calls)

**What's Missing:**
- ❌ No reactivity
- ❌ No refresh
- ❌ Doesn't update as work is completed

**Required Fix:** Same as Open Calls (Stream-based query)

---

### 6. **Industry Briefing Feed**

**Location:** Horizontal scrolling news cards  
**Current Behavior:**
- Displays: 5 news items from seed data
- Source: `industry_briefing` table
- Loaded: Once on `initState()` via `_loadBriefings()`
- Updates: **NEVER**

**Data Flow:**
```
initState() → _loadBriefings() → db.getLatestIndustryBriefing(limit: 5) → 
  industry_briefing table → setState() → Widget renders
```

**Query Definition:**
```dart
// lib/database/app_database.dart:353-357
Future<List<IndustryBriefingData>> getLatestIndustryBriefing({int limit = 5}) =>
    (select(industryBriefing)
          ..orderBy([(t) => OrderingTerm.desc(t.publishedAt)])
          ..limit(limit))
        .get();
```

**Wiring Status:** ❌ **MISSING**

**What Works:**
- ✅ Reads from local database
- ✅ Displays cached news
- ✅ Handles empty state

**What's Missing:**
- ❌ **No news fetcher** - No HTTP service to pull real news
- ❌ **No RSS parser** - Can't consume news feeds
- ❌ **No content scraper** - Can't fetch article data
- ❌ **No refresh mechanism**
- ❌ **No background update worker**
- ❌ Data is 100% static seed content

**Intended Behavior:**
```
On Startup (if online):
  → Fetch industry news from RSS/API
  → Parse articles
  → Insert into industry_briefing table
  → Display fresh content

Every 4-6 hours:
  → Background refresh
  → Update cache
  → Show notification if new articles

Manual Refresh:
  → Pull-to-refresh gesture
  → Fetches latest news
```

**Required Fix:**
1. Create `NewsService` class
2. Add RSS feed parser (or use API like NewsAPI)
3. Method: `fetchIndustryNews() → List<NewsArticle>`
4. Method: `cacheNews(articles) → insert into industry_briefing`
5. Add startup fetch call
6. Add background refresh (WorkManager)
7. Add manual refresh action

**Severity:** **HIGH** - This is the most obviously static element. Users will immediately notice it never changes.

---

### 7. **Company Feed Cards**

**Location:** Horizontal scrolling announcement cards  
**Current Behavior:**
- Displays: 3 company announcements (HR, Safety, Fleet)
- Source: `company_announcements` table
- Loaded: Once on `initState()` via `_loadLocalData()`
- Updates: Only when "Acknowledge" action is clicked

**Data Flow:**
```
initState() → _loadLocalData() → db.getActiveCompanyAnnouncements() → 
  company_announcements table → setState() → Widget renders
```

**Query Definition:**
```dart
// lib/database/app_database.dart:363-367
Future<List<CompanyAnnouncement>> getActiveCompanyAnnouncements() =>
    (select(companyAnnouncements)
          ..where((a) => a.active.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.publishedAt)]))
        .get();
```

**Wiring Status:** ⚠️ **PARTIAL**

**What Works:**
- ✅ Reads from local database
- ✅ Displays announcements
- ✅ Action buttons work (Acknowledge, View)
- ✅ Updates local acknowledged state
- ✅ Re-loads after action (`_loadLocalData()`)

**What's Missing:**
- ❌ **No sync mechanism** - Announcements are static seed data
- ❌ **No fetch from company server** - Can't pull new announcements
- ❌ **No push notifications** - Can't receive urgent alerts
- ❌ **No periodic refresh**
- ❌ Acknowledged state only local (doesn't sync back to server)

**Intended Behavior:**
```
On Startup (if online):
  → Fetch active company announcements
  → Cache in company_announcements
  → Display

When announcement acknowledged:
  → Update local DB
  → Sync acknowledgment to server
  → Remove from active feed

Periodic Check:
  → Every 1-2 hours
  → Fetch new announcements
  → Show notification badge
```

**Required Fix:**
1. Create `CompanyAnnouncementsService`
2. Method: `fetchAnnouncements() → List<Announcement>`
3. Method: `syncAcknowledgment(id)`
4. Add startup fetch
5. Add periodic check
6. Add push notification support (optional)

---

## Summary Table

| Component | Data Source | Current Behavior | Intended Behavior | Wiring Status | Severity |
|-----------|-------------|------------------|-------------------|---------------|----------|
| **Weather Widget** | `weather_snapshot` | Static seed data | Live API + periodic refresh | ⚠️ PARTIAL | MEDIUM |
| **Traffic Widget** | `traffic_snapshot` | Static seed data | Google Maps API + real-time | ⚠️ PARTIAL | MEDIUM |
| **Open Calls KPI** | `work_calls` + `work_orders` | One-time load, no reactivity | Stream-based, auto-updates | ⚠️ PARTIAL | LOW |
| **Completed KPI** | `work_calls` + `work_orders` | One-time load, no reactivity | Stream-based, auto-updates | ⚠️ PARTIAL | LOW |
| **Weekly KPI** | `work_calls` + `work_orders` | One-time load, no reactivity | Stream-based, auto-updates | ⚠️ PARTIAL | LOW |
| **Industry Briefing** | `industry_briefing` | Static seed data, never updates | RSS/API fetch + periodic refresh | ❌ MISSING | **HIGH** |
| **Company Feed** | `company_announcements` | Static seed data | Server sync + push notifications | ⚠️ PARTIAL | MEDIUM |

---

## Root Causes

### 1. **No HTTP Services**
There is **no networking layer** in the application. No HTTP client, no API services, no fetch logic.

**Files Missing:**
- `lib/services/weather_service.dart`
- `lib/services/traffic_service.dart`
- `lib/services/news_service.dart`
- `lib/services/announcements_service.dart`

### 2. **No Refresh Mechanisms**
Even if services existed, there are no triggers to call them:
- No startup fetch calls
- No background workers
- No periodic timers
- No pull-to-refresh gestures
- No manual refresh buttons

### 3. **No Reactivity**
The UI does not subscribe to database changes. It loads once and goes static.

**Solution:** Convert queries to Streams:
```dart
// Instead of:
Future<int> getOpenCallsCount()

// Use:
Stream<int> watchOpenCallsCount()
```

Then use `StreamBuilder` in widgets.

### 4. **No Connectivity Awareness**
The app doesn't check if it's online before attempting fetches.

**Solution:** Add connectivity package:
```dart
import 'package:connectivity_plus/connectivity_plus.dart';

if (await isOnline()) {
  fetchWeather();
} else {
  useCachedWeather();
}
```

---

## Architecture Gap: The Missing Layer

```
Current Architecture:
┌─────────────────┐
│   UI (Widgets)  │
└────────┬────────┘
         │ (One-time load)
         ↓
┌─────────────────┐
│ Local Database  │  ← Static seed data
└─────────────────┘

Missing Layer:
┌─────────────────┐
│   UI (Widgets)  │  ← StreamBuilder (reactive)
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  Data Services  │  ← NEW: Handles fetch/sync
│  (HTTP clients) │
└────────┬────────┘
         │
    ┌────┴────┐
    ↓         ↓
┌─────────┐ ┌───────────┐
│ Network │ │   Local   │
│  APIs   │ │  Database │
└─────────┘ └───────────┘
```

**What's Needed:**
1. **Data Services** - Classes that fetch from network, cache locally
2. **Background Workers** - Periodic refresh jobs
3. **Reactive Queries** - Stream-based DB access
4. **Connectivity Layer** - Online/offline detection

---

## Deployment Impact

### Can Deploy Now?
**Yes**, but with clear disclaimers:

✅ **For Internal Alpha:**
- App works fully offline
- All features functional
- Data displays correctly
- No crashes or errors

❌ **For Production:**
- Users will immediately notice static data
- "Offline-first" will appear as "offline-only"
- No live updates damages credibility
- Appears unfinished

### User Experience

**What users will see:**
- Weather always says same temperature
- Traffic always shows same route
- News never changes
- KPIs don't update when work is done
- Announcements never refresh

**What users will think:**
- "Is this broken?"
- "Why doesn't it update?"
- "Is my internet working?"
- "Is this just a demo?"

---

## Recommendation

### Short Term (Alpha Deployment)
**Keep as-is** with clear labeling:
- Add banner: "Alpha Version - Static Demo Data"
- Document known limitations
- Gather feedback on workflows (not data freshness)

### Phase 2 (Production Readiness)
**Implement in order:**

1. **Week 1: Reactive KPIs**
   - Convert work order queries to Streams
   - KPIs update when work is completed
   - **Effort:** 4-6 hours

2. **Week 2: Weather + Traffic**
   - Add HTTP services
   - Fetch on startup (if online)
   - Cache locally
   - **Effort:** 1-2 days

3. **Week 3: Industry Briefing**
   - Add NewsAPI or RSS parser
   - Implement background refresh
   - **Effort:** 2-3 days

4. **Week 4: Company Feed**
   - Add company API integration
   - Implement sync logic
   - **Effort:** 2-3 days

**Total Phase 2 Effort:** 1-2 weeks for complete wiring

---

## Technical Debt Score

| Category | Status | Debt Level |
|----------|--------|------------|
| Data Fetching | Missing | **HIGH** |
| Reactivity | Partial | MEDIUM |
| Caching | Complete | LOW |
| Error Handling | Missing | MEDIUM |
| Connectivity | Missing | MEDIUM |
| Background Refresh | Missing | **HIGH** |

**Overall Debt:** **MEDIUM-HIGH** - Functional but static

---

## Conclusion

**The UI is production-ready. The data layer is alpha-grade.**

Every widget is correctly implemented. The architecture is sound. The database works perfectly.

What's missing is **the final mile**: connecting the beautiful UI to live data sources.

**This is not a bug. This is incomplete wiring.**

The application works exactly as coded. It just hasn't been coded to update dynamically yet.

---

**Audit Completed By:** AI Development Assistant  
**Methodology:** Source code analysis, data flow tracing, architectural review  
**Classification:** WIRING GAP (Not a defect)  
**Priority:** Phase 2 Implementation  

**END OF AUDIT**
