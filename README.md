# ServiceCore

Field service portal for equipment-servicing operations — work orders, sites, expenses,
photo attachments, dispatch mapping, and continuing-education tracking.

Built and owned by VyreVault Studios. Customers are **deployments**, not forks.

## What it is

A **local-first Flutter application**. All core field workflows run with no network:
work orders, site data, expenses and attachments live in a local SQLite database via
Drift. Network is used opportunistically — weather, map tiles, news, external course
links — and every one of those paths degrades to a local experience when the device is
offline.

- **Targets:** Windows (primary) and Android. No iOS/macOS/web.
- **Storage:** Drift + SQLite, migrations in `lib/database/app_database.dart`
- **State:** `provider`
- **Maps:** `flutter_map` v8 + OSM/Carto raster tiles
- **Security:** the database is **not encrypted at rest** (see [Known issues](#known-issues)).
  `flutter_secure_storage` + `cryptography` generate and store a database key. Today that
  key feeds only a startup key fingerprint and the password-protected key export/import
  methods in `lib/services/encryption_service.dart`, which no other code calls.

## Layout

```
lib/
  application/   services (work orders, expenses, documents), boot, error types
  database/      Drift schema, migrations, seed
  features/      one directory per screen area
  providers/     app-wide ChangeNotifiers (auth, theme, reachability)
  services/      integrations (weather, workflow, encryption, LLM)
  theme/         palette, typography, asset resolution
docs/            development guide, design system, security audit
```

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # Drift codegen
flutter run -d windows
```

## Deployments

Client identity is **data, not code**. A deployment supplies:

- **Clients and sites** — rows in the `clients` / `sites` tables. Each client carries a
  `themeColor`; map pins and the map legend derive from it. There are no per-client
  constants in the product.
- **Branding** — `assets/logo.webp`, `assets/logo-{dark,light}.svg`, and the palette in
  `lib/theme/app_theme.dart`.
- **Seed data** — `lib/database/seed_service.dart` ships a small synthetic demo set
  (three example clients, eight demo technicians). Replace it per deployment; do not
  commit real client rosters, site lists, or staff records to this repository.

## Identifiers that must not be renamed

Several strings look like leftover branding but are load-bearing. Changing any of them
breaks or destroys data in existing installs:

| Identifier | Location | Why |
|---|---|---|
| `fsc_portal_v1_2026_security` | `services/encryption_service.dart` | Key-derivation salt for the master key that wraps the stored database key. Changing it makes the stored key undecryptable unless the original value is restored or a prior key export is imported. No database is encrypted at this revision, so no data is lost today. Once encryption is enabled, it would make the encrypted database unreadable. |
| `fsc_portal_db_key_encrypted` | `services/encryption_service.dart` | Secure-storage entry holding the stored database key. Renaming orphans that key: the next read generates a new random key that does not match earlier key exports. No database is encrypted at this revision. Once encryption is enabled, the encrypted database could not be opened with the new key. |
| `fsc_export_salt_v1` | `services/encryption_service.dart` | Nonce for encrypted exports. Changing it breaks decryption of prior exports. |
| `fsc_portal_dev.sqlite` | `main.dart`, `database/` | On-disk path of the live database. Renaming orphans existing databases. |
| `fsc_portal/`, `fsc_portal.db` | `application/boot/` | Path that boot checks and that safe-mode recovery backs up and deletes. It is not the live database (see Known issues). Renaming it orphans any file already at that path. |
| `portal_offline/` | `util/app_paths.dart` (`AppPaths.appDirName`) | On-disk directory for attachments and receipts. |
| `admin@fscportal.local` | `application/boot/boot_service.dart` | Seeded admin account identity. |

Renaming these is a **data migration**, not a find-and-replace. Do it deliberately, with
a migration path, or not at all.

## Known issues

See `docs/` and the issue tracker. The items below were checked against the source at
this revision.

- **The database is not encrypted at rest.** `AppDatabase` opens
  `fsc_portal_dev.sqlite` in the application documents directory with a plain
  `NativeDatabase.createInBackground`
  (`lib/database/app_database.dart:1664-1676`). `pubspec.yaml` ships `sqlite3_flutter_libs`
  and no SQLCipher, and `lib/main.dart:118` says the key step "doesn't encrypt yet".
  `EncryptionService.getDatabaseKey` (`lib/services/encryption_service.dart:59`) creates
  and stores a key, but it is used only for the startup fingerprint (`lib/main.dart:119`)
  and the key export/import methods (`lib/services/encryption_service.dart:155-244`).
- **Expense amounts: a comma is dropped, not read as a decimal separator.** `12,50` is
  saved as `1250` (`lib/features/expenses/expenses_home_view.dart:269`). A thousands
  separator such as `1,234.50` parses as intended.
- **Safe-mode recovery targets the wrong file.** Boot checks, backs up and deletes
  `fsc_portal/fsc_portal.db` under the application documents directory
  (`lib/application/boot/boot_service.dart:106-146`), but the live database is
  `fsc_portal_dev.sqlite` directly in that directory (`lib/database/app_database.dart:1667`).
  Recovery therefore cannot repair the real database.
- **Search is a case-insensitive substring match, not a full-text index.**
  `searchKnowledge` (`lib/database/app_database.dart:1401-1413`) and `searchWorkOrders`
  (`lib/database/app_database.dart:1166-1177`) lowercase the query and apply `contains`
  to lowercased columns.
