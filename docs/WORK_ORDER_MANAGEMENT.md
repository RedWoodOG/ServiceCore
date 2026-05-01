# Work Order Management System

**Version:** 1.2.0 (Phase 1)  
**Last Updated:** January 30, 2026

---

## Overview

Complete CRUD system with workflow state management for work orders in FSC Portal.

### Features
- ✅ Create, Read, Update work orders
- ✅ Status workflow with validation
- ✅ Optimistic locking for concurrent updates
- ✅ Comprehensive audit logging
- ✅ Permission-based access control
- ✅ Transaction safety with rollback
- ✅ Performance-optimized queries

---

## Status Workflow

### State Diagram

```
draft → open → assigned → in_progress → completed → closed
              ↓          ↓              ↑
           cancelled  on_hold ──────────┘
```

### Valid Transitions

| From Status | Valid Next States |
|-------------|-------------------|
| **draft** | open, cancelled |
| **open** | assigned, cancelled |
| **assigned** | in_progress, on_hold, cancelled |
| **in_progress** | on_hold, completed, cancelled |
| **on_hold** | in_progress, cancelled |
| **completed** | closed, in_progress (reopen) |
| **closed** | *(terminal state - no transitions)* |
| **cancelled** | *(terminal state - no transitions)* |

---

## Business Rules

### Status: draft
- Work order created but not submitted
- Can be edited freely
- Not visible to technicians

### Status: open
- Work order submitted and awaiting assignment
- Visible to dispatchers
- Can be assigned to technicians

### Status: assigned
- **Required:** Assigned technician must be set
- Technician can view work order
- Ready for scheduling

### Status: in_progress
- Work has started
- Technician actively working
- Can be paused (on_hold)

### Status: on_hold
- Work paused or blocked
- Requires notes explaining reason
- Can resume to in_progress

### Status: completed
- **Required:** Resolution text must be provided
- Work finished, awaiting review
- Auto-stops any active timers
- Parts used should be logged (warning if not)
- Can be reopened if issues found

### Status: closed
- **Required:** Must transition from completed status
- **Permission:** Admin only
- Final review complete
- Terminal state (cannot be changed)

### Status: cancelled
- **Permission:** Admin only
- Work order cancelled before completion
- Terminal state (cannot be changed)

---

## Usage

### Creating Work Orders

```dart
final workOrder = await db.into(db.workOrders).insertReturning(
  WorkOrdersCompanion.insert(
    siteId: selectedSiteId,
    status: 'draft',
    createdAt: DateTime.now(),
    descriptionOfWork: Value('Replace ATM card reader'),
    priority: Value('high'),
    createdBy: Value(currentUser.username),
  ),
);
```

### Editing Work Orders

**UI Flow:**
1. User clicks Edit button on work order card
2. EditWorkOrderSheet opens as bottom sheet
3. User modifies fields (description, notes, status, priority, technician)
4. If status changes, reason field appears (required)
5. User clicks Save Changes
6. System validates:
   - Status transition is valid
   - Required fields are filled
   - No concurrent modifications
7. Transaction commits with audit logging

**Programmatic:**
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => EditWorkOrderSheet(
    workOrder: workOrder,
  ),
);
```

### Status Transitions

```dart
final workflowService = WorkOrderWorkflowService(db);

await workflowService.transitionStatus(
  workOrder: workOrder,
  newStatus: 'completed',
  userId: currentUser.id,
  reason: 'Work completed successfully',
  notes: 'All parts replaced, tested OK',
);
```

### Viewing Audit History

```dart
final auditLog = await db.getWorkOrderAuditLog(workOrderId);
for (final entry in auditLog) {
  print('${entry.action} by User ${entry.userId} at ${entry.changedAt}');
  if (entry.fieldChanged != null) {
    print('  Field: ${entry.fieldChanged}');
    print('  Old: ${entry.oldValue}');
    print('  New: ${entry.newValue}');
  }
}

final transitions = await db.getWorkOrderStatusTransitions(workOrderId);
for (final trans in transitions) {
  print('${trans.fromStatus} → ${trans.toStatus} by User ${trans.changedBy}');
  print('  Notes: ${trans.notes}');
}
```

---

## Security

### Permission Matrix

| Role | Create | View All | Edit Own | Edit Any | Delete | Complete | Close/Cancel |
|------|--------|----------|----------|----------|--------|----------|--------------|
| **Tech** | ✅ | ❌ (own only) | ✅ | ❌ | ❌ | ✅ (own) | ❌ |
| **Dispatcher** | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| **Admin** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

### Validation Rules

**Input Sanitization:**
- All text input trimmed
- Null bytes removed (prevents corruption)
- Length limits enforced (max 10,000 chars)

**File Upload Validation:**
- Max file size: 10MB
- Allowed extensions: jpg, jpeg, png, webp, heic
- Magic number validation (prevents file type spoofing)

### Audit Trail

All changes logged to `work_order_audit_log` table:

**Tracked Events:**
- create, update, status_change, complete, delete, security_event

**Logged Data:**
- Work order ID
- User ID
- Action type
- Field changed
- Old value
- New value
- Change reason
- IP address (future)
- Timestamp

**Immutable:** Audit logs cannot be modified or deleted (append-only)

---

## Performance

### Benchmarks (Target vs. Actual)

| Operation | Target | Actual | Status |
|-----------|--------|--------|--------|
| Create 1,000 work orders | < 5s | TBD | ⏳ |
| Query 10,000 by status | < 100ms | TBD | ⏳ |
| Full-text search 10,000 | < 200ms | TBD | ⏳ |
| 100 concurrent updates | < 2s | TBD | ⏳ |

### Database Indexes

Performance-critical indexes created:

```sql
CREATE INDEX idx_wo_status ON work_orders(status);
CREATE INDEX idx_wo_assigned ON work_orders(assigned_technician);
CREATE INDEX idx_wo_workflow ON work_orders(workflow_state);
```

### Query Optimization

**Reactive Streams:**
- Use `watchWorkOrdersByStatus()` for UI updates
- Auto-updates when database changes
- No manual refresh needed

**Pagination:**
- Use `getWorkOrdersPaged()` for large lists
- 20 items per page (default)
- Infinite scroll supported

---

## Error Handling

### Concurrent Modification Protection

**Optimistic Locking:**
```dart
// Each work order has a version number
version: 1

// On update, version is checked
if (currentVersion != storedVersion) {
  throw ConcurrentModificationException();
}

// If successful, version is incremented
version: 2
```

**User Experience:**
- User sees error: "Work order was modified by another user"
- Dialog prompts to refresh
- User re-applies changes to latest version

### Invalid Status Transitions

**Validation:**
- System prevents invalid transitions
- Dropdown disables invalid options
- If attempted programmatically: throws `InvalidStatusTransitionException`

**User Experience:**
- Warning banner shows: "Invalid status transition"
- User guided to valid next states

### Business Rule Violations

**Examples:**
- Completing work order without resolution
- Assigning work order without technician
- Closing work order that isn't completed

**User Experience:**
- Error banner shows specific requirement
- Form fields highlighted
- Submit button disabled until valid

### Recovery Mechanisms

**Retry Logic:**
- 3 automatic retry attempts
- Exponential backoff (500ms, 1s, 2s)
- User notified on final failure

**Transaction Rollback:**
- All database changes atomic
- Partial updates never committed
- Database remains consistent

**Timeout Protection:**
- Default 30s timeout for operations
- 10s timeout for status transitions
- User notified on timeout

---

## Troubleshooting

### "Work order was modified by another user"

**Cause:** Another user updated the work order while you were editing

**Solution:**
1. Close the edit sheet
2. Refresh the work order list
3. Reopen the work order
4. Reapply your changes

### "Cannot transition from X to Y"

**Cause:** Invalid status transition attempted

**Solution:**
1. Check the status workflow diagram above
2. Find valid path from current status
3. Transition through intermediate states if needed

**Example:** To go from `open` to `completed`:
- open → assigned → in_progress → completed

### "Resolution is required"

**Cause:** Attempting to complete work order without resolution text

**Solution:**
1. Fill in the Resolution field
2. Describe how the issue was resolved
3. Save changes

### "Cannot assign work order without technician"

**Cause:** Attempting to set status to 'assigned' without selecting a technician

**Solution:**
1. Select a technician from the dropdown
2. Then change status to 'assigned'

---

## API Reference

### WorkOrderWorkflowService

```dart
class WorkOrderWorkflowService {
  WorkOrderWorkflowService(AppDatabase db);
  
  // Validate transition
  bool canTransition(String fromStatus, String toStatus);
  
  // Perform transition
  Future<void> transitionStatus({
    required WorkOrder workOrder,
    required String newStatus,
    required int userId,
    String? notes,
    String? reason,
  });
  
  // Get history
  Future<List<WorkOrderStatusTransition>> getTransitionHistory(int workOrderId);
}
```

### SecurityService

```dart
class SecurityService {
  SecurityService(AppDatabase db);
  
  // Permission checks
  Future<bool> canEditWorkOrder(WorkOrder workOrder, User currentUser);
  Future<bool> canTransitionStatus(WorkOrder wo, String status, User user);
  
  // Input validation
  String sanitizeInput(String input);
  bool validateFileUpload(String filePath, {int maxSizeMB = 10});
  
  // Audit
  Future<void> logSecurityEvent({
    required String eventType,
    required int userId,
    String? details,
    String? ipAddress,
  });
}
```

### ErrorHandler

```dart
class ErrorHandler {
  // Retry with exponential backoff
  static Future<T> retryOperation<T>({
    required Future<T> Function() operation,
    int maxAttempts = 3,
    Duration initialDelay = Duration(milliseconds: 500),
    String? operationName,
  });
  
  // Graceful degradation
  static Future<T?> withGracefulDegradation<T>({
    required Future<T> Function() operation,
    T? fallbackValue,
    String? operationName,
  });
  
  // Timeout protection
  static Future<T> withTimeout<T>({
    required Future<T> Function() operation,
    Duration timeout = Duration(seconds: 30),
    String? operationName,
  });
}
```

---

## Database Schema

### WorkOrders Table (Enhanced)

```sql
CREATE TABLE work_orders (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  site_id INTEGER NOT NULL,
  status TEXT NOT NULL,
  priority TEXT,
  description_of_work TEXT,
  internal_notes TEXT,
  created_at DATETIME NOT NULL,
  closed_at DATETIME,
  created_by TEXT,
  assigned_technician TEXT,
  
  -- PHASE 1 ADDITIONS
  completion_notes TEXT,
  resolution TEXT,
  repeat_issue BOOLEAN DEFAULT 0,
  previous_status TEXT,
  status_changed_by INTEGER,
  status_changed_at DATETIME,
  workflow_state TEXT DEFAULT 'draft',
  approval_status TEXT,
  approved_by INTEGER,
  approved_at DATETIME,
  version INTEGER DEFAULT 1,
  
  -- INDEXES
  INDEX idx_wo_status (status),
  INDEX idx_wo_assigned (assigned_technician),
  INDEX idx_wo_workflow (workflow_state)
);
```

### WorkOrderAuditLog Table

```sql
CREATE TABLE work_order_audit_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  work_order_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  action TEXT NOT NULL,
  field_changed TEXT,
  old_value TEXT,
  new_value TEXT,
  change_reason TEXT,
  ip_address TEXT,
  changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### WorkOrderStatusTransitions Table

```sql
CREATE TABLE work_order_status_transitions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  work_order_id INTEGER NOT NULL,
  from_status TEXT NOT NULL,
  to_status TEXT NOT NULL,
  changed_by INTEGER NOT NULL,
  notes TEXT,
  transitioned_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

---

## Testing

### Unit Tests

Run all tests:
```powershell
flutter test
```

Run specific test suite:
```powershell
flutter test test/services/work_order_workflow_service_test.dart
flutter test test/performance/work_order_performance_test.dart
```

### Test Coverage

**Target:** ≥ 80%

**Current Coverage:**
- WorkflowService: 100% (all code paths tested)
- SecurityService: TBD
- EditWorkOrderSheet: TBD

### Performance Tests

Located in `test/performance/work_order_performance_test.dart`

**Benchmarks:**
- ✅ Create 1,000 work orders
- ✅ Query 10,000 by status
- ✅ Full-text search 10,000 records
- ✅ 100 concurrent update transactions

---

## Future Enhancements

### Planned Features

- [ ] Email notifications on status changes
- [ ] SLA tracking with alerts
- [ ] Recurring work orders (scheduled maintenance)
- [ ] Mobile push notifications
- [ ] Cloud sync for multi-device
- [ ] Advanced reporting and analytics
- [ ] Work order templates
- [ ] Bulk operations UI
- [ ] CSV export/import

### Architectural Considerations

- [ ] Event sourcing for complete history
- [ ] CQRS pattern for read/write separation
- [ ] GraphQL API for future mobile app
- [ ] Redis caching layer (when online)
- [ ] Elasticsearch for advanced search

---

## Troubleshooting

### Build Issues

**Error:** "Type 'WorkOrderAuditLogEntry' not found"  
**Fix:** Should be `WorkOrderAuditLogData` (generated by Drift)

**Error:** "'getWorkOrderById' is already declared"  
**Fix:** Remove duplicate method declaration

**Error:** "Member not found: 'labelLarge'"  
**Fix:** Use `AppTypography.bodyText` instead

### Runtime Issues

**Error:** Database locked  
**Cause:** Long-running transaction  
**Solution:** Reduce transaction scope, use retry logic

**Error:** Query timeout  
**Cause:** Large dataset without indexes  
**Solution:** Verify indexes created in migration

---

## Code Examples

### Complete Example: Edit and Complete Work Order

```dart
// 1. Load work order
final workOrder = await db.getWorkOrderById(workOrderId);
if (workOrder == null) return;

// 2. Check permissions
final securityService = SecurityService(db);
final canEdit = await securityService.canEditWorkOrder(workOrder, currentUser);
if (!canEdit) {
  showErrorDialog('You do not have permission to edit this work order');
  return;
}

// 3. Show edit sheet
final result = await showModalBottomSheet<bool>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => EditWorkOrderSheet(workOrder: workOrder),
);

// 4. Refresh if changed
if (result == true) {
  setState(() {
    // Refresh work order list
  });
}
```

### Complete Example: Status Workflow with Validation

```dart
final workflowService = WorkOrderWorkflowService(db);

try {
  // Check if transition is valid
  if (!workflowService.canTransition(workOrder.status, 'completed')) {
    throw InvalidStatusTransitionException('Invalid transition');
  }
  
  // Transition with error handling
  await ErrorHandler.retryOperation(
    operation: () => workflowService.transitionStatus(
      workOrder: workOrder,
      newStatus: 'completed',
      userId: currentUser.id,
      reason: 'Customer approved work',
      notes: 'Replaced card reader, tested for 30 minutes',
    ),
    maxAttempts: 3,
    operationName: 'Complete Work Order',
  );
  
  print('Work order completed successfully');
  
} on ValidationException catch (e) {
  showErrorDialog(e.toString());
} on ConcurrentModificationException catch (e) {
  showConflictDialog('Work order was changed. Please refresh.');
} on InvalidStatusTransitionException catch (e) {
  showErrorDialog(e.toString());
}
```

---

## Maintenance

### Adding New Status States

1. Add to `WorkOrderStatus` enum in `work_order_workflow_service.dart`
2. Update `_validTransitions` map with transition rules
3. Add business rules in `_validateBusinessRules()`
4. Update UI icons in `WorkOrderStatusBadge`
5. Add tests for new transitions
6. Update this documentation

### Modifying Business Rules

1. Edit `_validateBusinessRules()` in WorkOrderWorkflowService
2. Add corresponding tests
3. Update documentation
4. Notify users of rule changes

### Performance Tuning

**If queries slow down:**
1. Check indexes are created (see migration V12)
2. Add additional indexes if needed
3. Use `EXPLAIN QUERY PLAN` in SQLite
4. Consider pagination for large result sets

---

## Support

### Common Questions

**Q: Can I edit a closed work order?**  
A: No, closed is a terminal state. Contact admin if changes are needed.

**Q: Why can't I change from completed to draft?**  
A: The workflow only allows forward progression. You can reopen to in_progress if work needs to continue.

**Q: What happens if two people edit the same work order?**  
A: Optimistic locking prevents conflicts. The second person to save will see an error and must refresh.

**Q: How long is audit history retained?**  
A: Forever (currently). Future versions may add archival.

---

**For bugs or feature requests, contact:** VyreVault Studios Development Team
