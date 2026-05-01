# FSC Offline Portal - Project Recovery Manifest (Jan 2026)

## 📍 Project Location & Environment

- **Project Root**: `h:\FSC_Portal\Offline-Portal`
- **Flutter SDK**: `C:\Flutter\flutter\bin\flutter.bat`
- **Current Version**: Flutter 3.38.5 • channel stable
- **Dart SDK**: Dart 3.10.4
- **Last Successful Build**: `h:\FSC_Portal\Offline-Portal\build\windows\x64\runner\Release\portal_offline.exe`

## 🛠 Stability Audit: Failures & Solutions

### 1. Environment: Flutter Command Not Found

- **Failure**: `'flutter' is not recognized as a name of a cmdlet...`
- **Root Cause**: Flutter bin directory not in the system's `PATH` for the current shell session.
- **Fix**: Referenced the absolute path `C:\Flutter\flutter\bin\flutter.bat` for all build and run commands.

### 2. Syntax: Incompatible Color Methods

- **Failure**: `The method 'withValues' isn't defined for the class 'Color'.`
- **Root Cause**: The codebase used `withValues` (introduced in newer Flutter versions), but the environment is running Flutter 3.38.5 / Dart 3.10.4.
- **Fix**: Performed a global migration across the `lib/` directory, replacing `withValues(alpha: X)` with standard `withOpacity(X)`.

### 3. Logic: Missing Logger Members

- **Failure**: `Member not found: 'Log.warn'.`
- **Root Cause**: `WeatherUpdateManager` and other services called `Log.warn()` or `Log.debug()`, but the `lib/util/log.dart` class only implemented `info()` and `error()`.
- **Fix**: Updated `Log` class to include `warn()` and `debug()` static methods.

### 4. UI: Polyline Parameter Conflict

- **Failure**: `No named parameter with the name 'isDotted'.`
- **Root Cause**: `flutter_map` v8.x API differences; `isDotted` is not valid for `Polyline` in the targeted version.
- **Fix**: Removed `isDotted: true` from the `PolylineLayer` in `locations_view.dart`.

## 📦 Core Dependencies (pubspec.yaml)

Ensure these are present if recreating the environment:

| Dependency | Version | Purpose |
| :--- | :--- | :--- |
| `drift` | `^2.20.0` | Local SQLite Database |
| `flutter_map` | `^8.2.2` | GIS & Mapping Engine |
| `latlong2` | `^0.9.1` | Geolocation Math |
| `provider` | `^6.1.2` | State Management |
| `intl` | `^0.20.2` | Localization & Date Formatting |
| `flutter_markdown`| `^0.6.18`| Knowledge Base Rendering |
| `syncfusion_flutter_pdf` | `^28.1.36` | Document Exporting |
| `sqlite3_flutter_libs` | `^0.5.24` | Native SQLite Binaries |

## 🧠 Agentic Architecture (3-Layer Pattern)

The project follows the "Agents.md" specification for autonomous operations:

1. **Layer 1: Directive** (`/directives`) - Markdown-based instructions for agents.
2. **Layer 2: Orchestration** (Dart Services) - `WeatherUpdateManager`, `KnowledgeImportUtility`.
3. **Layer 3: Execution** (`/execution`) - External scripts for heavy lifting.

### Execution Layer Dependencies (Python)

Located in `h:\FSC_Portal\Offline-Portal\execution\requirements.txt`:

- `requests` (API calls)
- `pyyaml` (Frontmatter parsing)
- `pandas` (Data processing)
- `openpyxl` (Excel handling)

## 🚀 Build & Run Commands

Use these commands to reproduce the project state:

**Clean & Rebuild (Release):**

```powershell
& "C:\Flutter\flutter\bin\flutter.bat" clean
& "C:\Flutter\flutter\bin\flutter.bat" build windows
```

**Run Locally:**

```powershell
& "C:\Flutter\flutter\bin\flutter.bat" run -d windows
```

---
*Manifest Generated on 2026-01-09 - Status: **GOLD STABLE***
