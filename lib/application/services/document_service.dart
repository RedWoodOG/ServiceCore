import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../database/app_database.dart';
import '../../util/log.dart';
import '../errors/app_failure.dart';
import '../errors/result.dart';

// ============================================
// COMMAND OBJECTS
// ============================================

class AttachDocument {
  const AttachDocument({
    required this.sourceFilePath,
    required this.fileName,
    this.workOrderId,
    this.siteId,
  }) : assert(workOrderId != null || siteId != null,
            'Either workOrderId or siteId must be provided');

  final String sourceFilePath;
  final String fileName;
  final int? workOrderId;
  final int? siteId;
}

class AttachPhoto {
  const AttachPhoto({
    required this.sourceFilePath,
    required this.workOrderId,
    this.siteId,
  });

  final String sourceFilePath;
  final int workOrderId;
  final int? siteId;
}

class DeleteDocument {
  const DeleteDocument({required this.documentId});
  final int documentId;
}

// ============================================
// SERVICE
// ============================================

/// The single write boundary for document/file attachment operations.
class DocumentService {
  DocumentService({
    required AppDatabase db,
    required User? currentUser,
  })  : _db = db,
        _currentUser = currentUser;

  final AppDatabase _db;
  final User? _currentUser;

  /// Attaches a document to a work order or site.
  Future<Result<int>> attachDocument(AttachDocument cmd) async {
    // Validate source file exists
    final sourceFile = File(cmd.sourceFilePath);
    if (!await sourceFile.exists()) {
      return Err(ValidationFailure('Source file not found: ${cmd.sourceFilePath}'));
    }

    // Validate at least one parent
    if (cmd.workOrderId == null && cmd.siteId == null) {
      return Err(ValidationFailure('Either workOrderId or siteId is required'));
    }

    // Verify parent entities exist
    try {
      if (cmd.workOrderId != null) {
        final wo = await _db.getWorkOrderById(cmd.workOrderId!);
        if (wo == null) {
          return Err(NotFoundFailure('Work order ${cmd.workOrderId} not found'));
        }
      }
      if (cmd.siteId != null) {
        final site = await _db.getSiteById(cmd.siteId!);
        if (site == null) {
          return Err(NotFoundFailure('Site ${cmd.siteId} not found'));
        }
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to verify parent entities', cause: e, stackTrace: st));
    }

    // Create storage directory
    String targetDir;
    try {
      final appDir = await getApplicationDocumentsDirectory();
      if (cmd.workOrderId != null) {
        targetDir = path.join(appDir.path, 'portal_offline', 'work_orders', cmd.workOrderId.toString());
      } else {
        targetDir = path.join(appDir.path, 'portal_offline', 'sites', cmd.siteId.toString());
      }
      
      final dir = Directory(targetDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to create storage directory', cause: e, stackTrace: st));
    }

    // Copy file to storage
    String targetPath;
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(cmd.sourceFilePath);
      final safeName = cmd.fileName.replaceAll(RegExp(r'[^\w\-.]'), '_');
      final targetFileName = '${timestamp}_$safeName$extension';
      targetPath = path.join(targetDir, targetFileName);

      await sourceFile.copy(targetPath);
    } catch (e, st) {
      return Err(StorageFailure('Failed to copy file', cause: e, stackTrace: st));
    }

    // Insert database record
    try {
      final documentId = await _db.transaction(() async {
        return await _db.into(_db.documents).insert(
          DocumentsCompanion.insert(
            workOrderId: Value(cmd.workOrderId),
            siteId: Value(cmd.siteId),
            fileName: cmd.fileName,
            filePath: targetPath,
            uploadedAt: DateTime.now(),
            uploadedBy: Value(_currentUser?.fullName ?? 'System'),
          ),
        );
      });

      Log.info('DocumentService: Attached document $documentId');
      return Ok(documentId);
    } catch (e, st) {
      // Clean up copied file on DB failure
      try {
        await File(targetPath).delete();
      } catch (_) {}
      
      Log.error('DocumentService: Failed to attach document', e, st);
      return Err(StorageFailure('Failed to save document record', cause: e, stackTrace: st));
    }
  }

  /// Attaches a photo to a work order.
  Future<Result<int>> attachPhoto(AttachPhoto cmd) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = path.extension(cmd.sourceFilePath);
    
    return attachDocument(AttachDocument(
      sourceFilePath: cmd.sourceFilePath,
      fileName: 'photo_$timestamp$extension',
      workOrderId: cmd.workOrderId,
      siteId: cmd.siteId,
    ));
  }

  /// Deletes a document and its file.
  Future<Result<void>> delete(DeleteDocument cmd) async {
    if (cmd.documentId <= 0) {
      return Err(ValidationFailure('Invalid document ID'));
    }

    // Fetch document to get file path
    Document? doc;
    try {
      doc = await (_db.select(_db.documents)..where((t) => t.id.equals(cmd.documentId))).getSingleOrNull();
      if (doc == null) {
        return Err(NotFoundFailure('Document ${cmd.documentId} not found'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to fetch document', cause: e, stackTrace: st));
    }

    // Delete file
    try {
      final file = File(doc.filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      Log.warn('DocumentService: Could not delete file ${doc.filePath}: $e');
      // Continue with DB deletion even if file deletion fails
    }

    // Delete database record
    try {
      await (_db.delete(_db.documents)..where((t) => t.id.equals(cmd.documentId))).go();
      
      Log.info('DocumentService: Deleted document ${cmd.documentId}');
      return const Ok(null);
    } catch (e, st) {
      Log.error('DocumentService: Failed to delete document', e, st);
      return Err(StorageFailure('Failed to delete document', cause: e, stackTrace: st));
    }
  }
}
