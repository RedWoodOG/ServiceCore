import 'package:flutter/material.dart';
import '../../models/work_order_enums.dart';

/// A badge widget displaying work order status with icon and color.
///
/// Accepts either a [WorkOrderStatus] enum or a database string value.
class WorkOrderStatusBadge extends StatelessWidget {
  final String status;
  final bool small;

  const WorkOrderStatusBadge({
    super.key,
    required this.status,
    this.small = false,
  });

  /// Create from enum (preferred)
  factory WorkOrderStatusBadge.fromEnum({
    Key? key,
    required WorkOrderStatus status,
    bool small = false,
  }) {
    return WorkOrderStatusBadge(
      key: key,
      status: status.dbValue,
      small: small,
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: config.color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: small ? 12 : 14, color: config.color),
          SizedBox(width: small ? 4 : 6),
          Text(
            config.label,
            style: TextStyle(
              fontSize: small ? 10 : 12,
              fontWeight: FontWeight.bold,
              color: config.color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    // Try to parse as WorkOrderStatus first
    final parsed = WorkOrderStatusX.fromDbValue(status);
    switch (parsed) {
      case WorkOrderStatus.draft:
        return _StatusConfig(Icons.edit_note, Colors.grey, parsed.label.toUpperCase());
      case WorkOrderStatus.open:
        return _StatusConfig(Icons.folder_open, Colors.blue, parsed.label.toUpperCase());
      case WorkOrderStatus.onHold:
        return _StatusConfig(Icons.pause_circle, Colors.red, parsed.label.toUpperCase());
      case WorkOrderStatus.completed:
        return _StatusConfig(Icons.check_circle, Colors.green, parsed.label.toUpperCase());
    }
  }
}

class _StatusConfig {
  final IconData icon;
  final Color color;
  final String label;

  _StatusConfig(this.icon, this.color, this.label);
}
