# Portal Offline - Cursor AI Development Guide
**Comprehensive Guide for Building Features Following Project Patterns**

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture Principles](#architecture-principles)
3. [Module Structure & Rules](#module-structure--rules)
4. [File Organization Patterns](#file-organization-patterns)
5. [Database Patterns](#database-patterns)
6. [UI/UX Patterns](#uiux-patterns)
7. [State Management](#state-management)
8. [Theme System](#theme-system)
9. [Step-by-Step Feature Development](#step-by-step-feature-development)
10. [Code Examples & Templates](#code-examples--templates)
11. [Testing & Verification](#testing--verification)
12. [Common Patterns Reference](#common-patterns-reference)

---

## Project Overview

**Portal Offline** is a Flutter desktop application (Windows primary) for field service management in the financial equipment industry. It's an offline-first application using SQLite (Drift) with reactive streams.

**Key Technologies:**
- Flutter 3.38.5 / Dart 3.10.4
- Drift (SQLite ORM) with reactive queries
- Provider for state management
- Material Design with custom dark theme
- Offline-first architecture (no backend)

**Primary Use Case:**
Field service technicians servicing ATMs, currency counters, check scanners, and similar equipment at client sites. Clients are deployment data, not part of the product.

---

## Architecture Principles

### 1. Modular Feature-Based Architecture

Each feature is a **self-contained module** in its own directory under `lib/features/`.

**Core Principle:** Features should be independent and removable without breaking other features.

```
lib/
  features/
    home/           - Dashboard with KPIs and feeds
    work/           - Work order management
    operations/     - Client and site management
    locations/      - Map view with routing
    people/         - Team directory
    knowledge/      - Knowledge base (REFERENCE MODULE)
    settings/       - Application settings
```

### 2. Offline-First Design

- All data stored locally in SQLite
- No network dependencies for core functionality
- Reactive UI updates via Drift streams
- Seed data on first launch

### 3. Single Responsibility Principle

Each file has ONE clear purpose:
- `*_home_view.dart` - Main view for the feature
- `*_card.dart` - Reusable card widget
- `*_detail_view.dart` - Detail modal/sheet
- `*_sheet.dart` - Bottom sheet forms

### 4. Reactive Data Flow

```
Database (Drift) 
    ↓ (Stream)
StreamBuilder 
    ↓ (UI Update)
Widget Tree
```

Never store state in widgets - always use streams from database.

---

## Module Structure & Rules

### The Golden Rules

✅ **DO:**
- Create separate files for each component (views, cards, forms)
- Use StreamBuilder for lists and reactive data
- Import only from: `../../theme/`, `../../database/`, `../../util/`
- Use Provider to access AppDatabase: `context.watch<AppDatabase>()`
- Follow theme constants (AppColors, AppTypography, AppLayout)
- Use FutureBuilder for one-time data fetches
- Group related functionality in the same module directory

❌ **DON'T:**
- Import from other feature modules (no cross-feature imports)
- Store state in StatefulWidget (use database streams)
- Hardcode colors, fonts, or spacing
- Mix business logic with UI code
- Create monolithic files (split into multiple files)
- Use setState for data that should come from database

### Reference Module: Knowledge

**Location:** `lib/features/knowledge/`

This is the **canonical example** of proper module structure:

```
knowledge/
  ├── knowledge_home_view.dart        - Main view with category list
  ├── knowledge_category_view.dart    - Filtered by category
  ├── knowledge_entry_view.dart       - Single entry detail
  └── knowledge_equipment_view.dart   - Filtered by equipment
```

**Study this module when building new features!**

### Standard Module Pattern

For a new feature called "example":

```
features/
  example/
    ├── example_home_view.dart      - Main entry point
    ├── example_card.dart           - Reusable list item widget
    ├── example_detail_view.dart    - Detail modal/sheet
    ├── create_example_sheet.dart   - Creation form (if needed)
    └── edit_example_sheet.dart     - Edit form (if needed)
```

**Naming Convention:**
- Main view: `{feature}_home_view.dart`
- Cards: `{item}_card.dart`
- Details: `{item}_detail_view.dart`
- Forms: `create_{item}_sheet.dart` or `edit_{item}_sheet.dart`

---

## File Organization Patterns

### Project Structure

```
lib/
  ├── main.dart                      - App entry point
  ├── app_shell/                     - Shell infrastructure
  │   ├── portal_shell.dart          - Layout wrapper
  │   ├── eva_panel.dart             - AI assistant panel
  │   ├── eva_state.dart             - EVA state management
  │   └── navigation_state.dart      - Navigation state
  ├── database/                      - Data layer
  │   ├── app_database.dart          - Drift schema & queries
  │   ├── app_database.g.dart        - Generated code
  │   └── seed_service.dart         - Demo data seeding
  ├── features/                      - Feature modules
  │   └── [feature]/                 - Individual features
  ├── services/                      - Business logic services
  │   ├── eva_service.dart           - AI assistant logic
  │   ├── weather_service.dart       - Weather API
  │   └── storage_service.dart       - File operations
  ├── theme/                         - Design system
  │   └── app_theme.dart             - All theme constants
  ├── util/                          - Utilities
  │   └── log.dart                   - Logging
  └── widgets/                       - Shared widgets
      ├── news_card.dart
      └── news_feed.dart
```

### Import Order

Always organize imports in this order:

```dart
// 1. Flutter SDK
import 'package:flutter/material.dart';

// 2. External packages
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// 3. Internal - database
import '../../database/app_database.dart';

// 4. Internal - theme
import '../../theme/app_theme.dart';

// 5. Internal - same module
import 'example_card.dart';
import 'example_detail_view.dart';
```

---

## Database Patterns

### Drift Schema Structure

**Location:** `lib/database/app_database.dart`

**Current Schema Version:** 11

### Table Definition Pattern

```dart
// Table name should be plural
class ExampleItems extends Table {
  // Primary key - always auto-increment
  IntColumn get id => integer().autoIncrement()();
  
  // Required fields
  TextColumn get name => text()();
  TextColumn get status => text()(); // Use text for enums
  
  // Optional fields - use nullable()
  TextColumn get description => text().nullable()();
  IntColumn get count => integer().nullable()();
  
  // Foreign keys - reference other tables
  IntColumn get userId => integer()(); // References Users
  
  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  
  // Booleans with defaults
  BoolColumn get active => boolean().withDefault(const Constant(true))();
}
```

### Query Method Patterns

**Always add queries to the AppDatabase class:**

```dart
// Pattern 1: Get all items (reactive stream)
Stream<List<ExampleItem>> watchAllExampleItems() =>
    (select(exampleItems)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

// Pattern 2: Get filtered items (reactive stream)
Stream<List<ExampleItem>> watchExampleItemsByStatus(String status) =>
    (select(exampleItems)
      ..where((t) => t.status.equals(status))
      ..orderBy([(t) => OrderingTerm.asc(t.name)]))
    .watch();

// Pattern 3: Get single item (one-time fetch)
Future<ExampleItem?> getExampleItemById(int id) =>
    (select(exampleItems)..where((t) => t.id.equals(id))).getSingleOrNull();

// Pattern 4: Insert item
Future<void> insertExampleItem(ExampleItemsCompanion item) =>
    into(exampleItems).insert(item, mode: InsertMode.insertOrReplace);

// Pattern 5: Update item
Future<void> updateExampleItem(ExampleItemsCompanion item) =>
    update(exampleItems).replace(item);

// Pattern 6: Delete item
Future<void> deleteExampleItem(int id) =>
    (delete(exampleItems)..where((t) => t.id.equals(id))).go();

// Pattern 7: Search
Future<List<ExampleItem>> searchExampleItems(String query) {
  final lowerQuery = query.toLowerCase();
  return (select(exampleItems)
    ..where((t) => 
        t.name.lower().contains(lowerQuery) |
        t.description.lower().contains(lowerQuery))
    ..orderBy([(t) => OrderingTerm.asc(t.name)]))
  .get();
}
```

### Adding a New Table

**Step 1:** Define table class
```dart
class NewFeature extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  // ... other columns
}
```

**Step 2:** Add to @DriftDatabase annotation
```dart
@DriftDatabase(tables: [
  // ... existing tables,
  NewFeature, // ADD HERE
])
```

**Step 3:** Increment schema version
```dart
@override
int get schemaVersion => 12; // Was 11, now 12
```

**Step 4:** Add migration logic
```dart
@override
MigrationStrategy get migration => MigrationStrategy(
  // ...
  onUpgrade: (Migrator m, int from, int to) async {
    // ... existing migrations
    if (from < 12) {
      // V12: Add NewFeature table
      await m.createTable(newFeature);
    }
  },
);
```

**Step 5:** Add query methods
```dart
// Add after existing query methods
Stream<List<NewFeatureData>> watchAllNewFeature() => 
    (select(newFeature)).watch();
```

**Step 6:** Regenerate Drift code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Seed Data Pattern

**Location:** `lib/database/seed_service.dart`

```dart
Future<void> seedExampleItems(AppDatabase db) async {
  // Check if already seeded
  final existing = await db.select(db.exampleItems).get();
  if (existing.isNotEmpty) {
    Log.info('Example items already seeded');
    return;
  }

  Log.info('Seeding example items...');

  // Insert items
  await db.into(db.exampleItems).insert(
    ExampleItemsCompanion.insert(
      name: 'Example 1',
      status: 'active',
      description: Value('Description here'),
    ),
  );

  await db.into(db.exampleItems).insert(
    ExampleItemsCompanion.insert(
      name: 'Example 2',
      status: 'inactive',
    ),
  );

  Log.info('Example items seeded successfully');
}

// Then add to main seedDatabase function:
Future<void> seedDatabase(AppDatabase database) async {
  // ... existing seed calls
  await seedExampleItems(database);
}
```

---

## UI/UX Patterns

### View Structure Pattern

Every `*_home_view.dart` should follow this structure:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/app_database.dart';
import '../../theme/app_theme.dart';

class ExampleHomeView extends StatefulWidget {
  const ExampleHomeView({super.key});

  @override
  State<ExampleHomeView> createState() => _ExampleHomeViewState();
}

class _ExampleHomeViewState extends State<ExampleHomeView> {
  // Local state only for UI (filters, search, etc.)
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. HEADER
          _buildHeader(),
          
          // 2. FILTERS/SEARCH (optional)
          _buildFilters(),
          
          // 3. CONTENT (StreamBuilder)
          Expanded(
            child: StreamBuilder<List<ExampleItem>>(
              stream: db.watchAllExampleItems(),
              builder: (context, snapshot) {
                // Handle loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                // Handle error
                if (snapshot.hasError) {
                  return _buildErrorState(snapshot.error.toString());
                }
                
                // Handle empty
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }
                
                // Build list
                final items = snapshot.data!;
                return _buildItemList(items);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.category, color: AppColors.primary, size: 32),
          const SizedBox(width: 16),
          Text('Example Feature', style: AppTypography.headlineLarge),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Search bar, filter chips, etc.
        ],
      ),
    );
  }

  Widget _buildItemList(List<ExampleItem> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ExampleCard(
          item: items[index],
          onTap: () => _showDetail(items[index]),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Items will appear here when added',
            style: AppTypography.bodyText.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Error loading data',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: AppTypography.bodyText.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDetail(ExampleItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExampleDetailView(item: item),
    );
  }
}
```

### Card Widget Pattern

```dart
import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../theme/app_theme.dart';

class ExampleCard extends StatelessWidget {
  final ExampleItem item;
  final VoidCallback? onTap;

  const ExampleCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppLayout.radiusMD),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppLayout.radiusMD),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppLayout.radiusSM),
                  ),
                  child: Icon(
                    Icons.star,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: AppTypography.headlineSmall,
                      ),
                      if (item.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.description!,
                          style: AppTypography.bodyText.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### Detail Modal Pattern

```dart
import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../theme/app_theme.dart';

class ExampleDetailView extends StatelessWidget {
  final ExampleItem item;

  const ExampleDetailView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              _buildHeader(context),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Detail content here
                    _DetailRow(
                      icon: Icons.label,
                      label: 'Name',
                      value: item.name,
                    ),
                    // More details...
                  ],
                ),
              ),
              // Actions
              _buildActions(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name,
              style: AppTypography.headlineSmall.copyWith(fontSize: 20),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Action here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Action'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTypography.bodyText.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## State Management

### Use Provider for Shared State

The app uses Provider for dependency injection. Access shared state like this:

```dart
// Access database
final db = context.watch<AppDatabase>();

// Access EVA state
final evaState = context.watch<EvaState>();

// Access navigation state
final navState = context.watch<NavigationState>();
```

**Rule:** Use `context.watch<T>()` in build methods for reactive updates.

### Local UI State Pattern

```dart
class _ExampleViewState extends State<ExampleView> {
  // UI state - search, filters, selections
  String _searchQuery = '';
  int? _selectedId;
  bool _showFilters = false;
  
  // NO data state - that comes from database streams
  
  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();
    
    // Data comes from database stream, not local state
    return StreamBuilder<List<Item>>(
      stream: db.watchItems(),
      builder: (context, snapshot) {
        // Use snapshot.data, not local state
      },
    );
  }
}
```

---

## Theme System

**Location:** `lib/theme/app_theme.dart`

### Always Use Theme Constants

**Colors:**
```dart
AppColors.background      // #121212 - Deep black
AppColors.surface         // #1E1E1E - Dark grey
AppColors.primary         // #0056D2 - Portal blue
AppColors.textPrimary     // #FFFFFF - White
AppColors.textSecondary   // #B0B0B0 - Light grey
AppColors.border          // #2E2E2E - Border grey
AppColors.error           // #F44336 - Red
```

**Typography:**
```dart
AppTypography.headlineLarge    // 32px bold
AppTypography.headlineSmall    // 20px bold (use with fontSize override for 24px)
AppTypography.bodyText         // 14px normal
AppTypography.labelLarge       // 14px medium
AppTypography.timestamp        // 12px
```

**Layout:**
```dart
AppLayout.sidebarWidth      // 240px
AppLayout.headerHeight      // 72px
AppLayout.navIconSize       // 20px
AppLayout.logoSize          // 32px
AppLayout.spacingSM         // 8px
AppLayout.spacingMD         // 16px
AppLayout.spacingLG         // 24px
AppLayout.radiusSM          // 4px
AppLayout.radiusMD          // 8px
AppLayout.radiusLG          // 12px
```

**Components:**
```dart
AppComponents.cardDecoration       // Standard card style
AppComponents.navItemActiveDecoration
AppComponents.navItemInactiveDecoration
AppComponents.buttonPrimary
```

**Usage Example:**
```dart
Container(
  padding: EdgeInsets.all(AppLayout.spacingMD),
  decoration: BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppLayout.radiusMD),
    border: Border.all(color: AppColors.border, width: 1),
  ),
  child: Text(
    'Example',
    style: AppTypography.headlineSmall.copyWith(
      color: AppColors.textPrimary,
    ),
  ),
)
```

---

## Step-by-Step Feature Development

### Complete Workflow for Adding a New Feature

**Example:** Adding a "Tasks" feature

#### Step 1: Plan the Module

**Define:**
- What data needs to be stored? (tasks table)
- What views are needed? (home, card, detail, create)
- What queries are needed? (watch all, by status, by user)

#### Step 2: Add Database Table

**Edit:** `lib/database/app_database.dart`

```dart
// Add table definition
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get status => text()(); // 'pending', 'completed'
  IntColumn get userId => integer()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Add to @DriftDatabase annotation
@DriftDatabase(tables: [
  // ... existing,
  Tasks,
])

// Increment schema version
int get schemaVersion => 12;

// Add migration
if (from < 12) {
  await m.createTable(tasks);
}

// Add query methods
Stream<List<Task>> watchAllTasks() =>
    (select(tasks)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

Stream<List<Task>> watchTasksByStatus(String status) =>
    (select(tasks)..where((t) => t.status.equals(status))).watch();

Future<void> insertTask(TasksCompanion task) =>
    into(tasks).insert(task);
```

**Regenerate:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Step 3: Add Seed Data

**Edit:** `lib/database/seed_service.dart`

```dart
Future<void> seedTasks(AppDatabase db) async {
  final existing = await db.select(db.tasks).get();
  if (existing.isNotEmpty) return;

  await db.into(db.tasks).insert(
    TasksCompanion.insert(
      title: 'Example Task',
      status: 'pending',
      userId: 1,
    ),
  );
}

// Add to seedDatabase()
await seedTasks(database);
```

#### Step 4: Create Module Directory

```bash
mkdir lib/features/tasks
```

#### Step 5: Create Home View

**File:** `lib/features/tasks/tasks_home_view.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/app_database.dart';
import '../../theme/app_theme.dart';
import 'task_card.dart';
import 'task_detail_view.dart';

class TasksHomeView extends StatefulWidget {
  const TasksHomeView({super.key});

  @override
  State<TasksHomeView> createState() => _TasksHomeViewState();
}

class _TasksHomeViewState extends State<TasksHomeView> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.task, color: AppColors.primary, size: 32),
                const SizedBox(width: 16),
                Text('Tasks', style: AppTypography.headlineLarge),
              ],
            ),
          ),
          
          // Filter chips
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: ['All', 'Pending', 'Completed'].map((f) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(f),
                    selected: _filter == f,
                    onSelected: (selected) {
                      setState(() => _filter = f);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Task list
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: _filter == 'All'
                  ? db.watchAllTasks()
                  : db.watchTasksByStatus(_filter.toLowerCase()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final tasks = snapshot.data!;
                
                if (tasks.isEmpty) {
                  return Center(
                    child: Text('No tasks', style: AppTypography.bodyText),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      task: tasks[index],
                      onTap: () => _showDetail(tasks[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show create task sheet
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDetail(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskDetailView(task: task),
    );
  }
}
```

#### Step 6: Create Card Widget

**File:** `lib/features/tasks/task_card.dart`

```dart
import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppLayout.radiusMD),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppLayout.radiusMD),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  task.status == 'completed'
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: task.status == 'completed'
                      ? Colors.green
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.title, style: AppTypography.headlineSmall),
                      if (task.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description!,
                          style: AppTypography.bodyText.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

#### Step 7: Create Detail View

**File:** `lib/features/tasks/task_detail_view.dart`

```dart
import 'package:flutter/material.dart';
import '../../database/app_database.dart';
import '../../theme/app_theme.dart';

class TaskDetailView extends StatelessWidget {
  final Task task;

  const TaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: AppTypography.headlineSmall.copyWith(fontSize: 20),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Divider(color: AppColors.border, height: 1),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    if (task.description != null)
                      Text(task.description!, style: AppTypography.bodyText),
                    // More details...
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

#### Step 8: Add to Navigation

**Edit:** `lib/main.dart`

```dart
// Add import
import 'features/tasks/tasks_home_view.dart';

// Add to _screens
const TasksHomeView(),

// Add to _navItems
{'icon': Icons.task, 'label': 'Tasks'},
```

#### Step 9: Test

```bash
flutter run -d windows
```

---

## Code Examples & Templates

### Template: Complete Feature Module

Use this as a starting template for any new feature:

```
features/
  example/
    ├── example_home_view.dart
    ├── example_card.dart
    └── example_detail_view.dart
```

All files are available in the previous sections as copy-paste templates.

### Common Widgets Library

**Status Badge:**
```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  decoration: BoxDecoration(
    color: color.withValues(alpha: 0.2),
    borderRadius: BorderRadius.circular(4),
    border: Border.all(color: color),
  ),
  child: Text(
    label.toUpperCase(),
    style: AppTypography.timestamp.copyWith(
      color: color,
      fontWeight: FontWeight.bold,
    ),
  ),
)
```

**Loading Indicator:**
```dart
const Center(child: CircularProgressIndicator())
```

**Error Display:**
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.error_outline, size: 64, color: AppColors.error),
      const SizedBox(height: 16),
      Text('Error', style: AppTypography.headlineSmall),
      Text(error, style: AppTypography.bodyText),
    ],
  ),
)
```

**Empty State:**
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.inbox, size: 64, color: AppColors.textSecondary),
      const SizedBox(height: 16),
      Text('No items', style: AppTypography.headlineSmall),
      Text('Items will appear here', style: AppTypography.bodyText),
    ],
  ),
)
```

---

## Testing & Verification

### Pre-Launch Checklist

Before running the app, verify:

- [ ] All imports use relative paths (`../../`)
- [ ] No cross-module imports (features importing from other features)
- [ ] All colors use AppColors constants
- [ ] All text styles use AppTypography constants
- [ ] All spacing uses AppLayout constants
- [ ] Database schema version incremented
- [ ] Migration added for new tables
- [ ] Query methods added to database
- [ ] Seed data added (if applicable)
- [ ] Build runner executed
- [ ] Navigation updated in main.dart

### Build & Run

```bash
# Clean build
flutter clean
flutter pub get

# Regenerate Drift code
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run -d windows
```

### Common Build Errors & Fixes

**Error:** `The method 'watchExample' isn't defined`
**Fix:** Run build_runner again after adding query methods

**Error:** `Type 'ExampleData' not found`
**Fix:** Run build_runner to generate data classes

**Error:** `SchemaVerificationException`
**Fix:** Delete database file and restart app, or increment schema version

**Error:** `Import errors`
**Fix:** Check relative import paths (`../../`)

### Manual Testing Checklist

After app launches:

- [ ] New navigation item appears
- [ ] Clicking navigation item opens the view
- [ ] Header displays correctly
- [ ] Data loads (no infinite loading spinner)
- [ ] Empty state shows if no data
- [ ] Cards display properly
- [ ] Clicking card opens detail view
- [ ] Detail view displays all information
- [ ] Close button works
- [ ] Search/filters work (if applicable)
- [ ] No console errors
- [ ] Theme colors are correct (no hardcoded colors)

---

## Common Patterns Reference

### Pattern: Fetching Related Data

```dart
// In a card widget, fetch related data
FutureBuilder<Site?>(
  future: db.getSiteById(equipment.siteId),
  builder: (context, siteSnapshot) {
    if (!siteSnapshot.hasData) {
      return Text('Loading...', style: AppTypography.bodyText);
    }
    
    final site = siteSnapshot.data!;
    
    // Can nest another FutureBuilder if needed
    return FutureBuilder<Client?>(
      future: db.getClientById(site.clientId),
      builder: (context, clientSnapshot) {
        if (!clientSnapshot.hasData) {
          return Text(site.branchName);
        }
        
        return Text('${clientSnapshot.data!.name} - ${site.branchName}');
      },
    );
  },
)
```

### Pattern: Search Implementation

```dart
class _ExampleViewState extends State<ExampleView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();

    return Scaffold(
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
          
          // Results
          Expanded(
            child: StreamBuilder<List<Item>>(
              stream: db.watchAllItems(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                var items = snapshot.data!;
                
                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  items = items.where((item) {
                    final searchIn = [
                      item.name,
                      item.description ?? '',
                    ].join(' ').toLowerCase();
                    return searchIn.contains(_searchQuery);
                  }).toList();
                }
                
                // Build filtered list
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ItemCard(item: items[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

### Pattern: Filter Chips

```dart
class _ExampleViewState extends State<ExampleView> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Active', 'Inactive', 'Pending'];

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
```

### Pattern: Grouped Lists

```dart
// In StreamBuilder builder:
final items = snapshot.data!;

// Group by category
final grouped = <String, List<Item>>{};
for (final item in items) {
  grouped.putIfAbsent(item.category, () => []).add(item);
}

// Build grouped list
return ListView.builder(
  padding: const EdgeInsets.all(16),
  itemCount: grouped.length,
  itemBuilder: (context, index) {
    final category = grouped.keys.elementAt(index);
    final categoryItems = grouped[category]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category header
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12, top: 16),
          child: Text(
            '$category (${categoryItems.length})',
            style: AppTypography.headlineSmall,
          ),
        ),
        // Category items
        ...categoryItems.map((item) => ItemCard(item: item)),
      ],
    );
  },
);
```

### Pattern: Action Buttons in Detail View

```dart
// At bottom of detail modal
Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    border: Border(
      top: BorderSide(color: AppColors.border, width: 1),
    ),
  ),
  child: Row(
    children: [
      Expanded(
        child: OutlinedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            // Secondary action
          },
          icon: const Icon(Icons.edit),
          label: const Text('Edit'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.border),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
            // Primary action
          },
          icon: const Icon(Icons.check),
          label: const Text('Complete'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    ],
  ),
)
```

---

## Summary: Key Principles

1. **Modular Architecture** - Each feature is self-contained
2. **No Cross-Module Imports** - Features don't import from each other
3. **Use Theme Constants** - Never hardcode colors, fonts, spacing
4. **Reactive Data** - StreamBuilder for lists, FutureBuilder for one-time
5. **Provider for Shared State** - `context.watch<AppDatabase>()`
6. **Follow Knowledge Module** - It's the canonical example
7. **Separate Files** - One component per file
8. **Database First** - Add tables, then queries, then UI
9. **Test Incrementally** - Build, run, verify after each step
10. **Reference This Guide** - Come back when building new features

---

**This guide should be your primary reference when building any new feature in Portal Offline. Follow these patterns and your code will integrate seamlessly with the existing application.**
