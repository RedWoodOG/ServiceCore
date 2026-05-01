import 'package:drift/drift.dart';

import '../../database/app_database.dart';
import '../../util/log.dart';
import '../errors/app_failure.dart';
import '../errors/result.dart';

// ============================================
// COMMAND OBJECTS
// ============================================

class CreateSite {
  const CreateSite({
    required this.clientId,
    required this.branchName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.region,
  });

  final int clientId;
  final String branchName;
  final String address;
  final double latitude;
  final double longitude;
  final String region;
}

class UpdateSite {
  const UpdateSite({
    required this.siteId,
    this.branchName,
    this.address,
    this.latitude,
    this.longitude,
    this.region,
  });

  final int siteId;
  final String? branchName;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? region;
}

class ArchiveSite {
  const ArchiveSite({required this.siteId});
  final int siteId;
}

// ============================================
// SERVICE
// ============================================

/// The single write boundary for site/location operations.
class LocationService {
  LocationService({
    required AppDatabase db,
    required User? currentUser,
  })  : _db = db,
        _currentUser = currentUser;

  final AppDatabase _db;
  // ignore: unused_field - reserved for future permission checks
  final User? _currentUser;

  /// Creates a new site.
  Future<Result<int>> create(CreateSite cmd) async {
    // Validate
    if (cmd.clientId <= 0) {
      return Err(ValidationFailure('Client is required', field: 'clientId'));
    }
    if (cmd.branchName.trim().isEmpty) {
      return Err(ValidationFailure('Branch name is required', field: 'branchName'));
    }
    if (cmd.address.trim().isEmpty) {
      return Err(ValidationFailure('Address is required', field: 'address'));
    }
    if (cmd.latitude < -90 || cmd.latitude > 90) {
      return Err(ValidationFailure('Invalid latitude', field: 'latitude'));
    }
    if (cmd.longitude < -180 || cmd.longitude > 180) {
      return Err(ValidationFailure('Invalid longitude', field: 'longitude'));
    }

    // Verify client exists
    try {
      final client = await _db.getClientById(cmd.clientId);
      if (client == null) {
        return Err(NotFoundFailure('Client ${cmd.clientId} not found'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to verify client', cause: e, stackTrace: st));
    }

    // Insert
    try {
      final siteId = await _db.transaction(() async {
        return await _db.into(_db.sites).insert(
          SitesCompanion.insert(
            clientId: cmd.clientId,
            branchName: cmd.branchName.trim(),
            address: cmd.address.trim(),
            latitude: cmd.latitude,
            longitude: cmd.longitude,
            region: cmd.region.trim(),
          ),
        );
      });

      Log.info('LocationService: Created site $siteId');
      return Ok(siteId);
    } catch (e, st) {
      if (e.toString().contains('UNIQUE constraint')) {
        return Err(ConflictFailure('Site with this name already exists for this client'));
      }
      Log.error('LocationService: Failed to create site', e, st);
      return Err(StorageFailure('Failed to create site', cause: e, stackTrace: st));
    }
  }

  /// Updates an existing site.
  Future<Result<void>> update(UpdateSite cmd) async {
    if (cmd.siteId <= 0) {
      return Err(ValidationFailure('Invalid site ID', field: 'siteId'));
    }

    // Verify exists
    try {
      final site = await _db.getSiteById(cmd.siteId);
      if (site == null) {
        return Err(NotFoundFailure('Site ${cmd.siteId} not found'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to fetch site', cause: e, stackTrace: st));
    }

    // Validate coordinates if provided
    if (cmd.latitude != null && (cmd.latitude! < -90 || cmd.latitude! > 90)) {
      return Err(ValidationFailure('Invalid latitude', field: 'latitude'));
    }
    if (cmd.longitude != null && (cmd.longitude! < -180 || cmd.longitude! > 180)) {
      return Err(ValidationFailure('Invalid longitude', field: 'longitude'));
    }

    // Update
    try {
      await _db.transaction(() async {
        await (_db.update(_db.sites)..where((t) => t.id.equals(cmd.siteId))).write(
          SitesCompanion(
            branchName: cmd.branchName != null ? Value(cmd.branchName!.trim()) : const Value.absent(),
            address: cmd.address != null ? Value(cmd.address!.trim()) : const Value.absent(),
            latitude: cmd.latitude != null ? Value(cmd.latitude!) : const Value.absent(),
            longitude: cmd.longitude != null ? Value(cmd.longitude!) : const Value.absent(),
            region: cmd.region != null ? Value(cmd.region!.trim()) : const Value.absent(),
          ),
        );
      });

      Log.info('LocationService: Updated site ${cmd.siteId}');
      return const Ok(null);
    } catch (e, st) {
      Log.error('LocationService: Failed to update site', e, st);
      return Err(StorageFailure('Failed to update site', cause: e, stackTrace: st));
    }
  }

  /// Archives a site (soft delete).
  Future<Result<void>> archive(ArchiveSite cmd) async {
    if (cmd.siteId <= 0) {
      return Err(ValidationFailure('Invalid site ID', field: 'siteId'));
    }

    // Check for active work orders
    try {
      final workOrders = await _db.getWorkOrdersBySite(cmd.siteId);
      final activeOrders = workOrders.where((wo) => wo.status != 'completed' && wo.status != 'cancelled');
      if (activeOrders.isNotEmpty) {
        return Err(ConflictFailure('Cannot archive site with ${activeOrders.length} active work orders'));
      }
    } catch (e, st) {
      return Err(StorageFailure('Failed to check work orders', cause: e, stackTrace: st));
    }

    // TODO: Implement soft delete when schema supports it
    // For now, just log the intent
    Log.warn('LocationService: Archive requested for site ${cmd.siteId} - soft delete not yet implemented');
    return Err(ValidationFailure('Archive not yet implemented'));
  }
}
