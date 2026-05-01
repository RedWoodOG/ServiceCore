// Work Order Status and Workflow Enums
//
// Type-safe enums for work order states with database string conversion.
// Use these instead of raw strings for compile-time safety.

/// Primary work order status values
enum WorkOrderStatus {
  draft,
  open,
  onHold,
  completed,
}

/// Extended workflow states (for advanced workflow management)
enum WorkflowState {
  draft,
  submitted,
  assigned,
  inProgress,
  onHold,
  pendingReview,
  approved,
  rejected,
  closed,
  cancelled,
}

/// Work order priority levels
enum WorkOrderPriority {
  low,
  normal,
  high,
  urgent,
}

/// Note types for work order notes
enum NoteType {
  general,
  poi,
  warning,
}

// ============================================
// EXTENSIONS FOR DATABASE STRING CONVERSION
// ============================================

extension WorkOrderStatusX on WorkOrderStatus {
  /// Convert enum to database string value
  String get dbValue {
    switch (this) {
      case WorkOrderStatus.draft:
        return 'draft';
      case WorkOrderStatus.open:
        return 'open';
      case WorkOrderStatus.onHold:
        return 'on_hold';
      case WorkOrderStatus.completed:
        return 'completed';
    }
  }

  /// Display label for UI
  String get label {
    switch (this) {
      case WorkOrderStatus.draft:
        return 'Draft';
      case WorkOrderStatus.open:
        return 'Open';
      case WorkOrderStatus.onHold:
        return 'On Hold';
      case WorkOrderStatus.completed:
        return 'Completed';
    }
  }

  /// Parse from database string value
  static WorkOrderStatus fromDbValue(String value) {
    switch (value.toLowerCase()) {
      case 'draft':
        return WorkOrderStatus.draft;
      case 'open':
        return WorkOrderStatus.open;
      case 'on_hold':
        return WorkOrderStatus.onHold;
      case 'completed':
        return WorkOrderStatus.completed;
      default:
        return WorkOrderStatus.open; // Default fallback
    }
  }

  /// Check if status is terminal (no further transitions)
  bool get isTerminal => this == WorkOrderStatus.completed;

  /// Check if status is active (work in progress)
  bool get isActive =>
      this == WorkOrderStatus.open || this == WorkOrderStatus.onHold;
}

extension WorkOrderPriorityX on WorkOrderPriority {
  /// Convert enum to database string value
  String get dbValue {
    switch (this) {
      case WorkOrderPriority.low:
        return 'low';
      case WorkOrderPriority.normal:
        return 'normal';
      case WorkOrderPriority.high:
        return 'high';
      case WorkOrderPriority.urgent:
        return 'urgent';
    }
  }

  /// Display label for UI
  String get label {
    switch (this) {
      case WorkOrderPriority.low:
        return 'Low';
      case WorkOrderPriority.normal:
        return 'Normal';
      case WorkOrderPriority.high:
        return 'High';
      case WorkOrderPriority.urgent:
        return 'Urgent';
    }
  }

  /// Parse from database string value
  static WorkOrderPriority fromDbValue(String? value) {
    if (value == null) return WorkOrderPriority.normal;
    switch (value.toLowerCase()) {
      case 'low':
        return WorkOrderPriority.low;
      case 'normal':
        return WorkOrderPriority.normal;
      case 'high':
        return WorkOrderPriority.high;
      case 'urgent':
        return WorkOrderPriority.urgent;
      default:
        return WorkOrderPriority.normal;
    }
  }
}

extension NoteTypeX on NoteType {
  /// Convert enum to database string value
  String get dbValue {
    switch (this) {
      case NoteType.general:
        return 'general';
      case NoteType.poi:
        return 'poi';
      case NoteType.warning:
        return 'warning';
    }
  }

  /// Parse from database string value
  static NoteType fromDbValue(String value) {
    switch (value.toLowerCase()) {
      case 'general':
        return NoteType.general;
      case 'poi':
        return NoteType.poi;
      case 'warning':
        return NoteType.warning;
      default:
        return NoteType.general;
    }
  }
}

// ============================================
// STATUS FILTER HELPER
// ============================================

/// All available status filter options (including 'all')
class StatusFilter {
  static const String all = 'all';

  static List<String> get values => [
        all,
        WorkOrderStatus.open.dbValue,
        WorkOrderStatus.onHold.dbValue,
        WorkOrderStatus.completed.dbValue,
      ];

  static String labelFor(String value) {
    if (value == all) return 'All';
    return WorkOrderStatusX.fromDbValue(value).label;
  }
}
