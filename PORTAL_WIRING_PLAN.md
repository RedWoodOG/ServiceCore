# Portal Wiring Implementation Plan
**Date:** 2025-12-14  
**Objective:** Wire up all unwired features, prioritizing high-impact items

---

## Implementation Phases

### Phase 1: Foundation (API Service Layer)
**Priority:** 🔴 **CRITICAL**  
**Estimated Time:** 2-3 hours

#### Tasks

1. **Create API Service Infrastructure**
   ```
   lib/
     services/
       api_service.dart          # HTTP client wrapper
       api_config.dart           # Base URL, endpoints config
       api_exceptions.dart       # Error handling
   ```

2. **Implementation Steps:**
   - Add `http` package to `pubspec.yaml`
   - Create `ApiService` class with base methods:
     - `get(String endpoint)` 
     - `post(String endpoint, Map body)`
     - `put(String endpoint, Map body)`
     - `delete(String endpoint)`
   - Add error handling (network, 4xx, 5xx)
   - Add request/response logging
   - Add base URL configuration (environment-based)

3. **Configuration:**
   ```dart
   // api_config.dart
   class ApiConfig {
     static const String baseUrl = 'http://localhost:3000';
     static const String apiPrefix = '/api/portal';
     static Duration timeout = Duration(seconds: 30);
   }
   ```

4. **Testing:**
   - Test connectivity to `fsc-enterprise-core` backend
   - Verify endpoints respond (Location, Equipment services)
   - Test error handling (offline, 404, 500)

---

### Phase 2: Work Orders (High Priority)
**Priority:** 🔴 **HIGH**  
**Estimated Time:** 4-5 hours

#### Tasks

1. **Backend: Create Work Order Service**
   - Location: `fsc-enterprise-core/src/services/work-orders/`
   - Endpoints needed:
     ```
     GET    /api/portal/work-orders                    # List with filters
     GET    /api/portal/work-orders/:id                # Single work order
     GET    /api/portal/work-orders/metrics            # Dashboard counts
     POST   /api/portal/work-orders                    # Create
     PUT    /api/portal/work-orders/:id                # Update
     ```

2. **Frontend: Database Schema**
   ```dart
   // Add to app_database.dart
   class WorkOrders extends Table {
     IntColumn get id => integer().autoIncrement()();
     TextColumn get workOrderNumber => text().unique()();
     IntColumn get siteId => integer().references(Sites, #id)();
     TextColumn get status => text()(); // open, completed, in_progress
     TextColumn get priority => text()(); // low, medium, high, urgent
     DateTimeColumn get createdAt => dateTime()();
     DateTimeColumn get completedAt => dateTime().nullable()();
     // ... other fields
   }
   ```

3. **Frontend: Data Models**
   ```dart
   lib/
     models/
       work_order.dart          # WorkOrder data class
       work_order_metrics.dart  # Dashboard metrics model
   ```

4. **Frontend: Repository Pattern**
   ```dart
   lib/
     repositories/
       work_order_repository.dart
         - getWorkOrders(filters)
         - getWorkOrder(id)
         - getMetrics()  // For dashboard
         - createWorkOrder(data)
         - updateWorkOrder(id, data)
         - syncWithBackend()  // Offline-first sync
   ```

5. **Frontend: Update Work View**
   - Replace placeholder with actual work orders list
   - Add filtering (status, priority, date)
   - Add work order detail view
   - Wire to repository

6. **Frontend: Update Home Dashboard**
   - Replace hardcoded metrics with API calls
   - Use `WorkOrderRepository.getMetrics()`
   - Add loading states
   - Add error handling

---

### Phase 3: Dashboard Metrics (High Priority)
**Priority:** 🔴 **HIGH**  
**Estimated Time:** 3-4 hours

#### Tasks

1. **Create Dashboard Service (Backend)**
   ```
   GET /api/portal/dashboard/metrics
   
   Response:
   {
     "openCalls": 6,
     "completedToday": 2,
     "thisWeek": 12,
     "lastUpdated": "2025-12-14T19:30:00Z"
   }
   ```

2. **Create Home Repository**
   ```dart
   lib/
     repositories/
       home_repository.dart
         - getDashboardMetrics()
         - getWeather(region)
         - getTraffic(route)
         - cacheMetrics()  // For offline
   ```

3. **Update Home View**
   - Convert `HomeView` from `StatelessWidget` to `StatefulWidget`
   - Add state management (Provider or Riverpod)
   - Add loading states for metrics
   - Replace hardcoded values:
     ```dart
     // Before:
     _buildKpiCard(context, "Open Calls", "6", ...)
     
     // After:
     _buildKpiCard(context, "Open Calls", "${metrics.openCalls}", ...)
     ```

4. **Add Refresh Logic**
   - Pull-to-refresh on dashboard
   - Auto-refresh every 5 minutes when visible
   - Show last updated timestamp

---

### Phase 4: Weather & Traffic (Medium Priority)
**Priority:** 🟡 **MEDIUM**  
**Estimated Time:** 2-3 hours

#### Tasks

1. **Weather Integration Options:**
   - **Option A:** Use public API (OpenWeatherMap, Weather.gov)
   - **Option B:** Create backend service that proxies weather API
   - **Option C:** Simple hardcoded lookup table (quick win)

2. **Traffic Integration:**
   - **Option A:** Use Google Maps Directions API
   - **Option B:** Use backend route calculation service
   - **Option C:** Calculate from cached routes (offline-first)

3. **Implementation:**
   ```dart
   // Add to home_repository.dart
   Future<WeatherData> getWeather(String region);
   Future<TrafficData> getTraffic({
     required LatLng start,
     required LatLng end,
   });
   ```

4. **Update Morning Briefing Widget**
   - Replace hardcoded strings
   - Add loading indicator
   - Show cached data if API fails

---

### Phase 5: Company Feed Actions (Medium Priority)
**Priority:** 🟡 **MEDIUM**  
**Estimated Time:** 1-2 hours

#### Tasks

1. **Create Notification Model**
   ```dart
   lib/
     models/
       company_notification.dart
         - id, title, body, type, actionRequired
         - actionUrl, actionLabel
         - acknowledged, acknowledgedAt
   ```

2. **Create Notification Repository**
   ```dart
   lib/
     repositories/
       notification_repository.dart
         - getCompanyFeed()
         - acknowledgeNotification(id)
         - markAsRead(id)
   ```

3. **Update Home View Company Feed**
   - Replace hardcoded `NewsCard` widgets
   - Fetch from repository
   - Wire action buttons:
     - `SELECT BENEFITS` → Navigate to benefits screen or external URL
     - `ACKNOWLEDGE` → Call `acknowledgeNotification()`
     - `VIEW POLICY` → Navigate to policy modal or document

4. **Add Backend Endpoint (if needed)**
   ```
   GET    /api/portal/notifications/company
   POST   /api/portal/notifications/:id/acknowledge
   ```

---

### Phase 6: Industry Briefing (Low Priority)
**Priority:** 🟢 **LOW**  
**Estimated Time:** 2-3 hours

#### Tasks

1. **Backend: News Feed Service**
   ```
   GET /api/portal/news/industry
   
   Response:
   {
     "items": [
       {
         "id": "...",
         "source": "Fenco Solutions",
         "headline": "...",
         "imageUrl": "...",
         "timeAgo": "2h ago",
         "publishedAt": "2025-12-14T17:00:00Z"
       }
     ]
   }
   ```

2. **Frontend: News Repository**
   ```dart
   lib/
     repositories/
       news_repository.dart
         - getIndustryBriefing()
         - refreshNews()
   ```

3. **Update News Feed Widget**
   - Replace hardcoded `NewsItem` list
   - Add pull-to-refresh
   - Add loading state
   - Cache last fetched data

---

### Phase 7: EVA Integration (Phase 4 Continuation)
**Priority:** 🔴 **HIGH** (After Phase 4.2-4.3 complete)  
**Estimated Time:** 4-5 hours

#### Tasks

1. **Create EVA Service**
   ```dart
   lib/
     services/
       eva_service.dart
         - queryKnowledgeBase(question)
         - getAnswer(question)
         - citeSource(answerId)
   ```

2. **Update EVA Panel**
   - Add chat input field
   - Add message history
   - Wire to `EvaService`
   - Display knowledge entries from Phase 4 database

3. **Backend: EVA Endpoint**
   ```
   POST /api/portal/eva/query
   
   Request: { "question": "How do I start a batch on JetSort 2000?" }
   Response: {
     "answer": "...",
     "source": "knowledge_entries",
     "entryId": "550e8400-...",
     "confidence": 0.95
   }
   ```

4. **Knowledge Base Integration**
   - Connect to Phase 4 knowledge database
   - Implement query logic (simple text search initially)
   - Return formatted answer with source citation

---

## Implementation Order (Recommended)

### Sprint 1: Critical Foundation (Week 1)
1. ✅ Phase 1: API Service Layer
2. ✅ Phase 2: Work Orders (Backend + Frontend)
3. ✅ Phase 3: Dashboard Metrics

### Sprint 2: Enhanced Features (Week 2)
4. ✅ Phase 4: Weather & Traffic
5. ✅ Phase 5: Company Feed Actions
6. ✅ Phase 6: Industry Briefing

### Sprint 3: EVA Integration (Week 3)
7. ✅ Phase 7: EVA Backend Connection
8. ✅ Complete Phase 4.2-4.3 (Knowledge Base Ingestion)

---

## Dependencies

### Required Packages (Add to pubspec.yaml)

```yaml
dependencies:
  http: ^1.2.0              # For API calls
  connectivity_plus: ^5.0.0 # For offline/online detection
  shared_preferences: ^2.2.0 # For caching preferences
  # Optional:
  dio: ^5.4.0               # Alternative to http (more features)
```

### Backend Dependencies

- ✅ `fsc-enterprise-core` backend running on `localhost:3000`
- ⚠️ Dashboard service needs to be created
- ⚠️ Work Order service needs to be created
- ⚠️ Notification service needs to be created (or use existing)

---

## Testing Strategy

### Unit Tests
- API service error handling
- Repository data transformation
- Model serialization/deserialization

### Integration Tests
- API connectivity
- Database operations
- Offline/online sync

### Manual Testing Checklist
- [ ] Dashboard metrics update correctly
- [ ] Work orders load from backend
- [ ] Weather/traffic display (or show cached)
- [ ] Company feed actions work
- [ ] EVA queries return answers
- [ ] Offline mode works (cached data)
- [ ] Error messages are user-friendly

---

## Success Criteria

### Phase 1-3 Complete
- ✅ All hardcoded metrics replaced with API data
- ✅ Work orders display from backend
- ✅ Dashboard auto-refreshes
- ✅ Error handling works (shows cached data if offline)

### Phase 4-6 Complete
- ✅ Weather/traffic show real data (or graceful fallback)
- ✅ Company feed actions functional
- ✅ Industry briefing pulls from backend (or RSS)

### Phase 7 Complete
- ✅ EVA can answer questions from knowledge base
- ✅ EVA cites sources correctly
- ✅ EVA handles "no answer found" gracefully

---

## Notes

- **Offline-First:** All repositories should cache data locally
- **Error Handling:** Always show cached data if API fails
- **User Feedback:** Loading indicators, error messages, success confirmations
- **Performance:** Debounce API calls, cache aggressively
- **Security:** Store API keys securely, use environment variables
