import 'package:drift/drift.dart';

import '../../database/app_database.dart';
import '../../util/log.dart';
import '../errors/app_failure.dart';
import '../errors/result.dart';

// ============================================
// COMMAND OBJECTS
// ============================================

class CreateEquipment {
  const CreateEquipment({
    required this.siteId,
    required this.equipmentType,
    this.manufacturer,
    this.model,
    this.serialNumber,
    this.underWarranty = false,
    this.underServiceContract = false,
  });

  final int siteId;
  final String equipmentType;
  final String? manufacturer;
  final String? model;
  final String? serialNumber;
  final bool underWarranty;
  final bool underServiceContract;
}

class UpdateEquipment {
  const UpdateEquipment({
    required this.equipmentId,
    this.equipmentType,
    this.manufacturer,
    this.model,
    this.serialNumber,
    this.underWarranty,
    this.underServiceContract,
  });

  final int equipmentId;
  final String? equipmentType;
  final String? manufacturer;
  final String? model;
  final String? serialNumber;
  final bool? underWarranty;
  final bool? underServiceContract;
}

class RetireEquipment {
  const RetireEquipment({required this.equipmentId, this.reason});
  final int equipmentId;
  final String? reason;
}

// ============================================
// SERVICE
// ============================================

/// The single write boundary for equipment operations.
class EquipmentService {
  EquipmentService({
    required AppDatabase db,
    required User? currentUser,
  })  : _db = db,
        _currentUser = currentUser;

  final AppDatabase _db;
  // ignore: unused_field - reserved for future permission checks
  final User? _currentUser;

  /// Creates new equipment.
  Future<Result<int>> create(CreateEquipment cmd) async {
    // Validate
    if (cmd.siteId <= 0) {
      return Err(ValidationFailure('Site is required', field: 'siteId'));
    }
    if (cmd.equipmentType.trim().isEmpty) {
      return Err(ValidationFailure('Equipment type is required', field: 'equipmentType'));
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

    // Insert
    try {
      final equipmentId = await _db.transaction(() async {
        return await _db.into(_db.equipment).insert(
          EquipmentCompanion.insert(
            siteId: cmd.siteId,
            equipmentType: cmd.equipmentType.trim(),
            manufacturer: Value(cmd.manufacturer?.trim()),
            model: Value(cmd.model?.trim()),
            serialNumber: Value(cmd.serialNumber?.trim()),
            underWarranty: Value(cmd.underWarranty),
            underServiceContract: Value(cmd.underServiceContract),
            active: const Value(true),
          ),
        );
      });

      Log.info('EquipmentService: Created equipment $equipmentId');
      return Ok(equipmentId);
    } catch (e, st) {
      if (e.toString().contains('UNIQUE constraint')) {
        return Err(ConflictFailure('Equipment with this serial number already exists'));
      }
      Log.error('EquipmentService: Failed to create equipment', e, st);
      return Err(StorageFailure('Failed to create equipment', cause: e, stackTrace: st));
    }
  }

  /// Updates existing equipment.
  Future<Result<void>> update(UpdateEquipment cmd) async {
    if (cmd.equipmentId <= 0) {
      return Err(ValidationFailure('Invalid equipment ID', field: 'equipmentId'));
    }

    // Verify exists
    try {
      final equipment = await _db.getEquipmentById(cmd.equipmentId);
      if (equipment == null) {
        return Err(NotFoundFailure('Equipment ${cmd.equipmentId} not found'));
      }
      if (!equipment.active) {
        return Err(ConflictFailure('Cannot update retired equipment'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to fetch equipment', cause: e, stackTrace: st));
    }

    // Update
    try {
      await _db.transaction(() async {
        await (_db.update(_db.equipment)..where((t) => t.id.equals(cmd.equipmentId))).write(
          EquipmentCompanion(
            equipmentType: cmd.equipmentType != null ? Value(cmd.equipmentType!.trim()) : const Value.absent(),
            manufacturer: cmd.manufacturer != null ? Value(cmd.manufacturer!.trim()) : const Value.absent(),
            model: cmd.model != null ? Value(cmd.model!.trim()) : const Value.absent(),
            serialNumber: cmd.serialNumber != null ? Value(cmd.serialNumber!.trim()) : const Value.absent(),
            underWarranty: cmd.underWarranty != null ? Value(cmd.underWarranty!) : const Value.absent(),
            underServiceContract: cmd.underServiceContract != null ? Value(cmd.underServiceContract!) : const Value.absent(),
          ),
        );
      });

      Log.info('EquipmentService: Updated equipment ${cmd.equipmentId}');
      return const Ok(null);
    } catch (e, st) {
      Log.error('EquipmentService: Failed to update equipment', e, st);
      return Err(StorageFailure('Failed to update equipment', cause: e, stackTrace: st));
    }
  }

  /// Retires equipment (soft deactivate).
  Future<Result<void>> retire(RetireEquipment cmd) async {
    if (cmd.equipmentId <= 0) {
      return Err(ValidationFailure('Invalid equipment ID', field: 'equipmentId'));
    }

    // Verify exists and is active
    try {
      final equipment = await _db.getEquipmentById(cmd.equipmentId);
      if (equipment == null) {
        return Err(NotFoundFailure('Equipment ${cmd.equipmentId} not found'));
      }
      if (!equipment.active) {
        return Err(ConflictFailure('Equipment is already retired'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to fetch equipment', cause: e, stackTrace: st));
    }

    // Retire
    try {
      await _db.transaction(() async {
        await (_db.update(_db.equipment)..where((t) => t.id.equals(cmd.equipmentId))).write(
          const EquipmentCompanion(active: Value(false)),
        );
      });

      Log.info('EquipmentService: Retired equipment ${cmd.equipmentId}${cmd.reason != null ? " - ${cmd.reason}" : ""}');
      return const Ok(null);
    } catch (e, st) {
      Log.error('EquipmentService: Failed to retire equipment', e, st);
      return Err(StorageFailure('Failed to retire equipment', cause: e, stackTrace: st));
    }
  }
}
