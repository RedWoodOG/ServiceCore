import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../util/log.dart';

/// Quick script to fix starting point coordinates in existing database
/// Run this once to update coordinates without resetting the database
/// 
/// Usage: Call this function once after app startup (or create a one-time migration)
Future<void> fixStartingPointCoordinates(AppDatabase db) async {
  Log.info('Fixing starting point coordinates...');
  
  try {
    // Get all starting points
    final points = await db.getAllStartingPoints();
    
    // Update Home Base
    final homeBase = points.firstWhere(
      (p) => p.name == "Home Base",
      orElse: () => throw Exception("Home Base starting point not found"),
    );
    
    await (db.update(db.startingPoints)
      ..where((tbl) => tbl.id.equals(homeBase.id))
    ).write(StartingPointsCompanion(
      latitude: const Value(29.4241),  // [redacted-address]
      longitude: const Value(-98.4936),
    ));
    Log.info('✓ Updated DemoUser\'s House: 29.4241, -98.4936');
    
    // Update Office (Shop)
    final office = points.firstWhere(
      (p) => p.name.toLowerCase() == 'office',
      orElse: () => throw Exception('Office starting point not found'),
    );
    
    await (db.update(db.startingPoints)
      ..where((tbl) => tbl.id.equals(office.id))
    ).write(StartingPointsCompanion(
      latitude: const Value(29.5150),  // [redacted-address]
      longitude: const Value(-98.4600),
    ));
    Log.info('✓ Updated Office (Shop): 29.5150, -98.4600');
    
    Log.info('Starting point coordinates fixed successfully!');
  } catch (e) {
    Log.error('Error fixing coordinates', e);
    rethrow;
  }
}
