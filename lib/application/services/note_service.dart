import 'package:drift/drift.dart';

import '../../database/app_database.dart';
import '../../util/log.dart';
import '../errors/app_failure.dart';
import '../errors/result.dart';

// ============================================
// COMMAND OBJECTS
// ============================================

class CreateNote {
  const CreateNote({
    required this.siteId,
    required this.noteType,
    required this.noteText,
    this.workOrderId,
  });

  final int siteId;
  final String noteType; // 'poi', 'warning', 'general'
  final String noteText;
  final int? workOrderId;
}

class UpdateNote {
  const UpdateNote({
    required this.noteId,
    this.noteText,
    this.noteType,
  });

  final int noteId;
  final String? noteText;
  final String? noteType;
}

class DeleteNote {
  const DeleteNote({required this.noteId});
  final int noteId;
}

// ============================================
// SERVICE
// ============================================

/// The single write boundary for note operations.
class NoteService {
  NoteService({
    required AppDatabase db,
    required User? currentUser,
  })  : _db = db,
        _currentUser = currentUser;

  final AppDatabase _db;
  final User? _currentUser;

  static const _validNoteTypes = ['poi', 'warning', 'general'];

  /// Creates a new note.
  Future<Result<int>> create(CreateNote cmd) async {
    // Validate
    if (cmd.siteId <= 0) {
      return Err(ValidationFailure('Site is required', field: 'siteId'));
    }
    if (cmd.noteText.trim().isEmpty) {
      return Err(ValidationFailure('Note text is required', field: 'noteText'));
    }
    if (!_validNoteTypes.contains(cmd.noteType)) {
      return Err(ValidationFailure(
        'Invalid note type. Must be one of: ${_validNoteTypes.join(', ')}',
        field: 'noteType',
      ));
    }

    // Verify site exists
    try {
      final site = await _db.getSiteById(cmd.siteId);
      if (site == null) {
        return Err(NotFoundFailure('Site ${cmd.siteId} not found'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to verify site', cause: e, stackTrace: st));
    }

    // Verify work order exists if provided
    if (cmd.workOrderId != null) {
      try {
        final wo = await _db.getWorkOrderById(cmd.workOrderId!);
        if (wo == null) {
          return Err(NotFoundFailure('Work order ${cmd.workOrderId} not found'));
        }
      } catch (e, st) {
        return Err(StorageFailure('Failed to verify work order', cause: e, stackTrace: st));
      }
    }

    // Insert
    try {
      final noteId = await _db.transaction(() async {
        return await _db.into(_db.notes).insert(
          NotesCompanion.insert(
            siteId: cmd.siteId,
            workOrderId: Value(cmd.workOrderId),
            noteType: cmd.noteType,
            noteText: cmd.noteText.trim(),
            createdAt: DateTime.now(),
            createdBy: Value(_currentUser?.fullName ?? 'System'),
          ),
        );
      });

      Log.info('NoteService: Created note $noteId');
      return Ok(noteId);
    } catch (e, st) {
      Log.error('NoteService: Failed to create note', e, st);
      return Err(StorageFailure('Failed to create note', cause: e, stackTrace: st));
    }
  }

  /// Updates an existing note.
  Future<Result<void>> update(UpdateNote cmd) async {
    if (cmd.noteId <= 0) {
      return Err(ValidationFailure('Invalid note ID', field: 'noteId'));
    }

    if (cmd.noteType != null && !_validNoteTypes.contains(cmd.noteType)) {
      return Err(ValidationFailure(
        'Invalid note type. Must be one of: ${_validNoteTypes.join(', ')}',
        field: 'noteType',
      ));
    }

    // Verify exists
    try {
      final note = await (_db.select(_db.notes)..where((t) => t.id.equals(cmd.noteId))).getSingleOrNull();
      if (note == null) {
        return Err(NotFoundFailure('Note ${cmd.noteId} not found'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to fetch note', cause: e, stackTrace: st));
    }

    // Update
    try {
      await _db.transaction(() async {
        await (_db.update(_db.notes)..where((t) => t.id.equals(cmd.noteId))).write(
          NotesCompanion(
            noteText: cmd.noteText != null ? Value(cmd.noteText!.trim()) : const Value.absent(),
            noteType: cmd.noteType != null ? Value(cmd.noteType!) : const Value.absent(),
          ),
        );
      });

      Log.info('NoteService: Updated note ${cmd.noteId}');
      return const Ok(null);
    } catch (e, st) {
      Log.error('NoteService: Failed to update note', e, st);
      return Err(StorageFailure('Failed to update note', cause: e, stackTrace: st));
    }
  }

  /// Deletes a note.
  Future<Result<void>> delete(DeleteNote cmd) async {
    if (cmd.noteId <= 0) {
      return Err(ValidationFailure('Invalid note ID', field: 'noteId'));
    }

    // Verify exists
    try {
      final note = await (_db.select(_db.notes)..where((t) => t.id.equals(cmd.noteId))).getSingleOrNull();
      if (note == null) {
        return Err(NotFoundFailure('Note ${cmd.noteId} not found'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to fetch note', cause: e, stackTrace: st));
    }

    // Delete
    try {
      await (_db.delete(_db.notes)..where((t) => t.id.equals(cmd.noteId))).go();

      Log.info('NoteService: Deleted note ${cmd.noteId}');
      return const Ok(null);
    } catch (e, st) {
      Log.error('NoteService: Failed to delete note', e, st);
      return Err(StorageFailure('Failed to delete note', cause: e, stackTrace: st));
    }
  }
}
