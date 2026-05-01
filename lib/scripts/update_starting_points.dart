// ignore_for_file: avoid_print

import 'package:drift/drift.dart';
import '../database/app_database.dart';

/// Script to update starting point coordinates
/// Run this after fixing coordinates in seed_service.dart
/// 
/// Usage: This is a utility script - coordinates should be updated
/// in seed_service.dart first, then database can be reset or manually updated
Future<void> updateStartingPoints(AppDatabase db) async {
  print('Updating starting point coordinates...');
  
  // Get all starting points
  final points = await db.getAllStartingPoints();
  
  // Find and update "Office" (shop)
  final office = points.firstWhere(
    (p) => p.name.toLowerCase() == 'office',
    orElse: () => throw Exception('Office starting point not found'),
  );
  
  // TODO: Replace with correct shop coordinates
  await (db.update(db.startingPoints)
    ..where((tbl) => tbl.id.equals(office.id))
  ).write(StartingPointsCompanion(
    latitude: const Value(29.531), // REPLACE WITH CORRECT LATITUDE
    longitude: const Value(-98.432), // REPLACE WITH CORRECT LONGITUDE
  ));
  print('✓ Updated Office (shop) coordinates');
  
  // Find and update your house
  // TODO: Determine which house is yours and update accordingly
  // Example: "Home Base" or "Home Base 2"
  final myHouse = points.firstWhere(
    (p) => p.name.toLowerCase().contains('DemoUser'), // OR 'DemoUser2' - adjust as needed
    orElse: () => throw Exception('House starting point not found'),
  );
  
  // TODO: Replace with correct house coordinates
  await (db.update(db.startingPoints)
    ..where((tbl) => tbl.id.equals(myHouse.id))
  ).write(StartingPointsCompanion(
    latitude: const Value(29.418), // REPLACE WITH CORRECT LATITUDE
    longitude: const Value(-98.693), // REPLACE WITH CORRECT LONGITUDE
  ));
  print('✓ Updated house coordinates');
  
  print('Starting points updated successfully!');
}
