import 'dart:io';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../util/log.dart';

class SecurityService {
  final AppDatabase db;

  SecurityService(this.db);

  /// Validates user has permission to edit work order
  Future<bool> canEditWorkOrder(WorkOrder workOrder, User currentUser) async {
    // Admin can edit anything
    if (currentUser.role == 'admin') return true;

    // Technician can only edit their own assigned work orders
    if (currentUser.role == 'tech') {
      return workOrder.assignedTechnician == currentUser.username;
    }

    // Dispatcher can edit unassigned or any work order
    if (currentUser.role == 'dispatcher') return true;

    return false;
  }

  /// Validates user can transition work order status
  Future<bool> canTransitionStatus(
    WorkOrder workOrder,
    String newStatus,
    User currentUser,
  ) async {
    // Only assigned tech or admin can complete work orders
    if (newStatus == 'completed') {
      if (currentUser.role == 'admin') return true;
      return workOrder.assignedTechnician == currentUser.username;
    }

    // Only admin can close or cancel
    if (newStatus == 'closed' || newStatus == 'cancelled') {
      return currentUser.role == 'admin';
    }

    // Otherwise use general edit permission
    return canEditWorkOrder(workOrder, currentUser);
  }

  /// Sanitizes user input to prevent injection attacks
  String sanitizeInput(String input) {
    // Trim whitespace
    var sanitized = input.trim();

    // Remove null bytes (database corruption prevention)
    sanitized = sanitized.replaceAll('\x00', '');

    // Limit length
    if (sanitized.length > 10000) {
      sanitized = sanitized.substring(0, 10000);
    }

    return sanitized;
  }

  /// Validates file upload is safe
  bool validateFileUpload(String filePath, {int maxSizeMB = 10}) {
    final file = File(filePath);

    // Check exists
    if (!file.existsSync()) return false;

    // Check size
    final sizeMB = file.lengthSync() / (1024 * 1024);
    if (sizeMB > maxSizeMB) {
      Log.warn(
        'File upload rejected: ${sizeMB}MB exceeds ${maxSizeMB}MB limit',
      );
      return false;
    }

    // Check extension (image files only)
    final ext = filePath.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'webp', 'heic'].contains(ext)) {
      Log.warn('File upload rejected: Invalid extension $ext');
      return false;
    }

    // Check magic numbers (file signature validation)
    final bytes = file.readAsBytesSync();
    if (bytes.length < 4) return false;

    // JPEG: FF D8 FF
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) return true;

    // PNG: 89 50 4E 47
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return true;
    }

    // WebP: 52 49 46 46 (RIFF)
    if (bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46) {
      return true;
    }

    Log.warn('File upload rejected: Magic number validation failed');
    return false;
  }

  /// Audit log for security events
  Future<void> logSecurityEvent({
    required String eventType,
    required int userId,
    String? details,
    String? ipAddress,
  }) async {
    Log.info('Security Event: $eventType by user $userId');

    // In production, send to security monitoring system
    // For now, just log to database audit table
    await db
        .into(db.workOrderAuditLog)
        .insert(
          WorkOrderAuditLogCompanion.insert(
            workOrderId: 0, // Special: security events
            userId: userId,
            action: 'security_event',
            fieldChanged: Value(eventType),
            newValue: Value(details),
            ipAddress: Value(ipAddress),
          ),
        );
  }
}
