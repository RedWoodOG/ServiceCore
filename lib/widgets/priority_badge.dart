import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/work_order_enums.dart';

/// A badge widget displaying priority level with consistent styling.
class PriorityBadge extends StatelessWidget {
  final String priority;
  final bool small;

  const PriorityBadge({
    super.key,
    required this.priority,
    this.small = false,
  });

  /// Create from enum (preferred)
  factory PriorityBadge.fromEnum({
    Key? key,
    required WorkOrderPriority priority,
    bool small = false,
  }) {
    return PriorityBadge(
      key: key,
      priority: priority.dbValue,
      small: small,
    );
  }

  @override
  Widget build(BuildContext context) {
    final parsed = WorkOrderPriorityX.fromDbValue(priority);
    final color = _getColor(context, parsed);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        parsed.label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: small ? 10 : 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getColor(BuildContext context, WorkOrderPriority priority) {
    final statusColors = Theme.of(context).extension<StatusColors>()!;
    switch (priority) {
      case WorkOrderPriority.low:
        return Colors.grey;
      case WorkOrderPriority.normal:
        return Theme.of(context).colorScheme.primary;
      case WorkOrderPriority.high:
        return statusColors.warning;
      case WorkOrderPriority.urgent:
        return Theme.of(context).colorScheme.error;
    }
  }
}
