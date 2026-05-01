---
description: Install Modular Features (Continuing Education, Equipment, Expenses) for Portal Offline
---

This workflow guides you through the installation of the modular features as per the January 14, 2026 installation guide.

### Prerequisites

- Ensure Flutter SDK is at `C:\Flutter\flutter\bin\flutter.bat`.
- Ensure you have the updated database and module files (currently expected at `/mnt/user-data/outputs/`).

### STEP 1: Stop the Running App

Close any active Flutter app sessions.

### STEP 2: Update Database File

// turbo

1. Backup the current database:

   ```powershell
   Copy-Item "lib\database\app_database.dart" "lib\database\app_database.dart.backup"
   ```

2. Replace content of `lib\database\app_database.dart` with content from `app_database_updated.dart`.
   *(Manual Step: If files are at /mnt/user-data/outputs/, copy them over.)*

### STEP 3: Regenerate Drift Code

// turbo

```powershell
& "C:\Flutter\flutter\bin\flutter.bat" pub run build_runner build --delete-conflicting-outputs
```

### STEP 4: Create Module Directories

// turbo

```powershell
New-Item -Path "lib\features\continuing_education" -ItemType Directory -Force
New-Item -Path "lib\features\equipment" -ItemType Directory -Force
New-Item -Path "lib\features\expenses" -ItemType Directory -Force
```

### STEP 5: Copy Module Files

Copy the `.dart` files from the respective output folders to:

- `lib\features\continuing_education\`
- `lib\features\equipment\`
- `lib\features\expenses\`

### STEP 6: Add Seed Data

Edit `lib\database\seed_service.dart`:

1. Add `seedContinuingEducationCourses(AppDatabase db)` function.
2. Call it within `seedDatabase()`.

### STEP 7: Update Navigation

Edit `lib\main.dart`:

1. Add module imports.
2. Add views to `_screens`.
3. Add items to `_navItems`.

### STEP 8: Fix Missing Query Method

Edit `lib/database/app_database.dart`:

1. Add `getWorkOrdersForEquipment(int equipmentId)` method.

### STEP 9: Build and Run

// turbo

```powershell
& "C:\Flutter\flutter\bin\flutter.bat" run -d windows
```
