# PORTAL DESIGN SYSTEM & CONTEXT
> This file is the Source of Truth for all UI generation. 
> ALWAYS reference this file when building widgets.

## 1. BRAND IDENTITY
- **App Name:** Portal (Offline Version)
- **Organization:** Field Service Corporation (FSC)
- **Primary Vibe:** Professional, Enterprise, "Dark Mode" Field Service Application
- **Purpose:** Offline-capable field service management for technicians

## 2. COLOR PALETTE (Strict Adherence)
DO NOT use raw Hex codes. Use `AppColors` from `lib/theme/app_theme.dart`.

| Semantic Name    | Reference Code         | Usage |
| :---             | :---                   | :--- |
| **Primary** | `AppColors.primary`    | "Portal Blue" - Buttons, Active States (#0056D2) |
| **Background** | `AppColors.background` | Main scaffold background (#121212 - Deep Black) |
| **Surface** | `AppColors.surface`    | Card backgrounds (#1E1E1E - Dark Grey) |
| **Sidebar** | `AppColors.sidebarBg`  | Left navigation rail (#121212 - Same as background) |
| **Success** | `AppColors.success`    | Green status indicators (#30D158) |
| **Warning** | `AppColors.warning`    | Yellow alerts (#FFD60A) |
| **Error** | `AppColors.error`      | Red critical states (#FF453A) |
| **Text Primary** | `AppColors.textPrimary`| Headings, High-contrast text (#FFFFFF) |
| **Text Secondary** | `AppColors.textSecondary`| Labels, subtitles (#B3B3B3 - Light Grey) |
| **Text Tertiary** | `AppColors.textTertiary`| Disabled text (#808080 - Medium Grey) |
| **Border** | `AppColors.border`     | Dividers and card borders (#2C2C2C) |
| **Divider** | `AppColors.divider`    | Section dividers (#262626) |
| **Success BG** | `AppColors.successBg`  | Green status card background (#1A3A1A) |
| **Info BG** | `AppColors.infoBg`     | Blue status card background (#1A2A42) |
| **Warning BG** | `AppColors.warningBg`  | Yellow status card background (#3A3A1A) |
| **Error BG** | `AppColors.errorBg`    | Red status card background (#3A1A1A) |
| **Pin: Northwind** | `AppColors.pinNorthwind`   | Map Marker - Blue (#0056D2) |
| **Pin: LoneStar** | `AppColors.pinLoneStar`| Map Marker - Yellow (#FFD60A) |
| **Pin: GulfCoast** | `AppColors.pinGulfCoast`| Map Marker - Red (#FF453A) |
| **Pin: Start** | `AppColors.pinStartPoint`| Map Marker - Green (#30D158) |

## 3. WINDOW ANATOMY (Standard Terminology)
When the user references these terms, they mean:

- **"The Shell"**: The main `Scaffold` containing the Sidebar and Canvas.
- **"Sidebar"**: The left navigation rail. 
    - Width: Fixed 240px (Desktop).
    - Background: Pure black (`AppColors.sidebarBg`)
    - Header: Contains Portal logo (lightning bolt icon) + "Portal" text.
    - Footer: User profile section showing "Admin" and "Offline Mode"
- **"Canvas"**: The main content area to the right of the Sidebar.
    - Background: Deep black (`AppColors.background`)
- **"KPI Card"**: The top-row metric widgets (Icon + Big Number + Label).
    - Background: `AppColors.surface`
    - Border: `AppColors.border`
    - Padding: 24px all sides
    - Icon and trending indicator at top
- **"Action Bar"**: The top-right row of buttons (e.g., "+ New Call", "Time Entry").
    - Style: Blue elevated buttons with white text
- **"Operational Environment"**: The colored status banner cards on the Dashboard.
    - Green for positive status
    - Blue for informational
    - Red for alerts

## 4. TYPOGRAPHY
Always use theme typography, never hardcoded text styles:

- **Page Title**: `Theme.of(context).textTheme.headlineLarge` (32px, bold, white)
- **Section Title**: `Theme.of(context).textTheme.headlineMedium` (20px, bold, white)
- **Body Text**: `Theme.of(context).textTheme.bodyLarge` (16px, white)
- **Subtitle**: `Theme.of(context).textTheme.bodyMedium` (14px, textSecondary)
- **Caption**: `Theme.of(context).textTheme.bodySmall` (12px, textSecondary)

## 5. NAVIGATION STRUCTURE
The Sidebar contains the following menu items (in order):

1. **Home** - Dashboard with metrics and recent activity
2. **Work** - Work orders and site list
3. **Field Readiness** - Safety and preparation tools
4. **Operations** - Inventory and operational data
5. **Locations** - Map view with PM mode
6. **People** - Team and contact management
7. **FLO** - Forms and documentation
8. **Sas** - Analytics and reporting

## 6. COMPONENT PATTERNS

### KPI Card Pattern
```dart
Container(
  padding: EdgeInsets.all(24),
  decoration: BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: AppColors.border),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(iconData, color: accentColor, size: 24),
          Spacer(),
          Icon(Icons.trending_up, color: accentColor, size: 20),
        ],
      ),
      SizedBox(height: 16),
      Text(value, style: headlineLarge),
      SizedBox(height: 4),
      Text(label, style: bodyMedium with textSecondary),
    ],
  ),
)
```

### Status Card Pattern
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: statusColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: statusColor.withOpacity(0.3)),
  ),
  child: Row(
    children: [
      Icon(iconData, color: statusColor, size: 20),
      SizedBox(width: 12),
      Expanded(child: Text(message, style: bodyMedium)),
    ],
  ),
)
```

### Sidebar Nav Item Pattern
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  decoration: BoxDecoration(
    color: isSelected ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
    borderRadius: BorderRadius.circular(8),
  ),
  child: Row(
    children: [
      Icon(
        iconData,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        size: 20,
      ),
      SizedBox(width: 12),
      Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    ],
  ),
)
```

## 7. CODING RULES
1. **Theme First:** Always use `Theme.of(context)` or `AppColors` class. Never hardcode colors.
2. **Typography:** Use `Theme.of(context).textTheme.*` for all text styles.
3. **Icons:** Use `Icon(Icons.x, color: AppColors.primary)`.
4. **Spacing:** Use consistent spacing: 4, 8, 12, 16, 24, 32px multiples.
5. **Border Radius:** Cards: 12px, Buttons: 8px, Status badges: 4px.
6. **Consistency:** All similar components should use the exact same pattern.

## 8. DATABASE CONTEXT
- **Database:** Drift (SQLite) with offline-first architecture
- **Tables:** Clients, Sites, StartingPoints
- **Access:** Use `context.read<AppDatabase>()` to access database
- **Client Colors:** Stored as strings ('blue', 'red', 'yellow') and mapped to AppColors

## 9. MAP SPECIFICATIONS
- **Library:** flutter_map 6.0+
- **Tiles:** OpenStreetMap (offline-capable)
- **Center:** San Antonio area (29.531, -98.432)
- **Zoom:** Default 10.0
- **PM Mode:** Toggle for route planning (Start → Farthest → 5 Closest sites)
- **Route Color:** Purple (#a855f7)

## 10. WHEN BUILDING NEW FEATURES
Always:
1. Read this AI_CONTEXT.md file first
2. Use AppColors for all colors
3. Match existing component patterns
4. Follow the navigation structure
5. Maintain the dark theme aesthetic
6. Test with offline database (no backend calls)
