import 'package:drift/drift.dart';

import '../../database/app_database.dart';
import '../../util/log.dart';
import '../errors/app_failure.dart';
import '../errors/result.dart';

// ============================================
// COMMAND OBJECTS
// ============================================

class CreateAnnouncement {
  const CreateAnnouncement({
    required this.category,
    required this.title,
    required this.body,
    this.actionLabel,
    this.active = true,
  });

  final String category; // 'hr', 'safety', 'fleet'
  final String title;
  final String body;
  final String? actionLabel;
  final bool active;
}

class UpdateAnnouncement {
  const UpdateAnnouncement({
    required this.announcementId,
    this.title,
    this.body,
    this.category,
    this.actionLabel,
    this.active,
  });

  final int announcementId;
  final String? title;
  final String? body;
  final String? category;
  final String? actionLabel;
  final bool? active;
}

class AcknowledgeAnnouncement {
  const AcknowledgeAnnouncement({required this.announcementId});
  final int announcementId;
}

class DeleteAnnouncement {
  const DeleteAnnouncement({required this.announcementId});
  final int announcementId;
}

// ============================================
// SERVICE
// ============================================

/// The single write boundary for company announcement operations.
class AnnouncementService {
  // ignore: avoid_unused_constructor_parameters
  AnnouncementService({
    required AppDatabase db,
    User? currentUser, // Reserved for future permission checks
  }) : _db = db;

  final AppDatabase _db;

  static const _validCategories = ['hr', 'safety', 'fleet', 'general'];

  /// Creates a new announcement.
  Future<Result<int>> create(CreateAnnouncement cmd) async {
    // Validate
    if (cmd.title.trim().isEmpty) {
      return Err(ValidationFailure('Title is required', field: 'title'));
    }
    if (cmd.body.trim().isEmpty) {
      return Err(ValidationFailure('Body is required', field: 'body'));
    }
    if (!_validCategories.contains(cmd.category)) {
      return Err(ValidationFailure(
        'Invalid category. Must be one of: ${_validCategories.join(', ')}',
        field: 'category',
      ));
    }

    // Insert
    try {
      final id = await _db.transaction(() async {
        return await _db.into(_db.companyAnnouncements).insert(
          CompanyAnnouncementsCompanion.insert(
            category: cmd.category,
            title: cmd.title.trim(),
            body: cmd.body.trim(),
            actionLabel: Value(cmd.actionLabel?.trim()),
            active: Value(cmd.active),
            publishedAt: DateTime.now(),
          ),
        );
      });

      Log.info('AnnouncementService: Created announcement $id');
      return Ok(id);
    } catch (e, st) {
      Log.error('AnnouncementService: Failed to create announcement', e, st);
      return Err(StorageFailure('Failed to create announcement', cause: e, stackTrace: st));
    }
  }

  /// Updates an existing announcement.
  Future<Result<void>> update(UpdateAnnouncement cmd) async {
    if (cmd.announcementId <= 0) {
      return Err(ValidationFailure('Invalid announcement ID', field: 'announcementId'));
    }

    if (cmd.category != null && !_validCategories.contains(cmd.category)) {
      return Err(ValidationFailure(
        'Invalid category. Must be one of: ${_validCategories.join(', ')}',
        field: 'category',
      ));
    }

    // Verify exists
    try {
      final existing = await (_db.select(_db.companyAnnouncements)
            ..where((t) => t.id.equals(cmd.announcementId)))
          .getSingleOrNull();
      if (existing == null) {
        return Err(NotFoundFailure('Announcement ${cmd.announcementId} not found'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to fetch announcement', cause: e, stackTrace: st));
    }

    // Update
    try {
      await _db.transaction(() async {
        await (_db.update(_db.companyAnnouncements)
              ..where((t) => t.id.equals(cmd.announcementId)))
            .write(
          CompanyAnnouncementsCompanion(
            title: cmd.title != null ? Value(cmd.title!.trim()) : const Value.absent(),
            body: cmd.body != null ? Value(cmd.body!.trim()) : const Value.absent(),
            category: cmd.category != null ? Value(cmd.category!) : const Value.absent(),
            actionLabel: cmd.actionLabel != null ? Value(cmd.actionLabel!.trim()) : const Value.absent(),
            active: cmd.active != null ? Value(cmd.active!) : const Value.absent(),
          ),
        );
      });

      Log.info('AnnouncementService: Updated announcement ${cmd.announcementId}');
      return const Ok(null);
    } catch (e, st) {
      Log.error('AnnouncementService: Failed to update announcement', e, st);
      return Err(StorageFailure('Failed to update announcement', cause: e, stackTrace: st));
    }
  }

  /// Acknowledges an announcement for the current user.
  Future<Result<void>> acknowledge(AcknowledgeAnnouncement cmd) async {
    if (cmd.announcementId <= 0) {
      return Err(ValidationFailure('Invalid announcement ID', field: 'announcementId'));
    }

    // Verify exists
    try {
      final existing = await (_db.select(_db.companyAnnouncements)
            ..where((t) => t.id.equals(cmd.announcementId)))
          .getSingleOrNull();
      if (existing == null) {
        return Err(NotFoundFailure('Announcement ${cmd.announcementId} not found'));
      }
      if (existing.acknowledged) {
        // Already acknowledged - idempotent success
        return const Ok(null);
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to fetch announcement', cause: e, stackTrace: st));
    }

    // Mark as acknowledged
    try {
      await _db.transaction(() async {
        await (_db.update(_db.companyAnnouncements)
              ..where((t) => t.id.equals(cmd.announcementId)))
            .write(
          CompanyAnnouncementsCompanion(
            acknowledged: const Value(true),
            acknowledgedAt: Value(DateTime.now()),
          ),
        );
      });

      Log.info('AnnouncementService: Acknowledged announcement ${cmd.announcementId}');
      return const Ok(null);
    } catch (e, st) {
      Log.error('AnnouncementService: Failed to acknowledge announcement', e, st);
      return Err(StorageFailure('Failed to acknowledge announcement', cause: e, stackTrace: st));
    }
  }

  /// Deletes an announcement.
  Future<Result<void>> delete(DeleteAnnouncement cmd) async {
    if (cmd.announcementId <= 0) {
      return Err(ValidationFailure('Invalid announcement ID', field: 'announcementId'));
    }

    // Verify exists
    try {
      final existing = await (_db.select(_db.companyAnnouncements)
            ..where((t) => t.id.equals(cmd.announcementId)))
          .getSingleOrNull();
      if (existing == null) {
        return Err(NotFoundFailure('Announcement ${cmd.announcementId} not found'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to fetch announcement', cause: e, stackTrace: st));
    }

    // Delete
    try {
      await (_db.delete(_db.companyAnnouncements)..where((t) => t.id.equals(cmd.announcementId))).go();

      Log.info('AnnouncementService: Deleted announcement ${cmd.announcementId}');
      return const Ok(null);
    } catch (e, st) {
      Log.error('AnnouncementService: Failed to delete announcement', e, st);
      return Err(StorageFailure('Failed to delete announcement', cause: e, stackTrace: st));
    }
  }
}
