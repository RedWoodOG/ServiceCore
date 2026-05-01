# Update Starting Points - Instructions

**Date:** December 10, 2025  
**Issue:** Starting point coordinates were incorrect  
**Fixed:** Updated seed_service.dart with correct coordinates

---

## Coordinates Updated

### Home Base
- **Address:** [redacted-address]
- **Old Coordinates:** 29.418, -98.693
- **New Coordinates:** 29.4241, -98.4936

### Shop (Office)
- **Address:** [redacted-address]
- **Old Coordinates:** 29.531, -98.432
- **New Coordinates:** 29.5150, -98.4600

---

## How to Apply the Fix

The seed service has been updated with the correct coordinates. However, since your database is already seeded, you have two options:

### Option 1: Reset Database (Recommended for Development)

**This will delete all data and reseed with correct coordinates:**

1. Close the application if it's running
2. Delete the SQLite database file:
   - Location: `%APPDATA%\portal_offline\` or similar
   - Or check the database path in your app logs
3. Restart the application
4. Database will auto-seed with correct coordinates

**OR** manually delete the database file. The path is typically:
- Windows: `C:\Users\[YourUsername]\AppData\Roaming\portal_offline\app_database.db`
- Or check console output for database path on first launch

### Option 2: Update Existing Database (Preserves Data)

If you want to keep existing data, you can update the coordinates directly:

1. **Using SQLite Browser or Command Line:**
   ```sql
   -- Update Home Base
   UPDATE starting_points 
   SET latitude = 29.4241, longitude = -98.4936 
   WHERE name = "Home Base";
   
   -- Update Office (Shop)
   UPDATE starting_points 
   SET latitude = 29.5150, longitude = -98.4600 
   WHERE name = 'Office';
   ```

2. **Or create a quick update script** (see below)

### Option 3: Quick Update Script

Create a temporary script to update the database:

```dart
// Run this once in your app or create a separate script
final db = AppDatabase();
final points = await db.getAllStartingPoints();

// Update Home Base
final homeBase = points.firstWhere((p) => p.name == "Home Base");
await (db.update(db.startingPoints)
  ..where((tbl) => tbl.id.equals(homeBase.id))
).write(StartingPointsCompanion(
  latitude: const Value(29.4241),
  longitude: const Value(-98.4936),
));

// Update Office (Shop)
final office = points.firstWhere((p) => p.name == 'Office');
await (db.update(db.startingPoints)
  ..where((tbl) => tbl.id.equals(office.id))
).write(StartingPointsCompanion(
  latitude: const Value(29.5150),
  longitude: const Value(-98.4600),
));
```

---

## Verification

After updating:

1. Restart the application
2. Navigate to **Locations** view
3. Verify starting points are now at correct locations:
   - Home Base should be at [redacted-address]
   - Office (Shop) should be at [redacted-address]
4. Test PM Mode routing to ensure routes calculate correctly

---

## Files Modified

- ✅ `lib/database/seed_service.dart` - Updated coordinates in seed data

---

## Notes

- The seed service will use correct coordinates for all future database initializations
- Existing databases need to be updated manually or reset
- Coordinates are in decimal degrees (WGS84)
- Latitude: 29.4241 (North)
- Longitude: -98.4936 (West, negative)

---

**Status:** ✅ Seed service updated. Database needs to be reset or manually updated to apply changes.
