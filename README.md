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
- **Security:** `flutter_secure_storage` + `cryptography` for at-rest DB encryption

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
| `fsc_portal_v1_2026_security` | `services/encryption_service.dart` | Key-derivation salt. Changing it makes every encrypted database undecryptable. |
| `fsc_portal_db_key_encrypted` | `services/encryption_service.dart` | Secure-storage key holding the DB key. Renaming orphans the key; the database cannot be opened. |
| `fsc_export_salt_v1` | `services/encryption_service.dart` | Nonce for encrypted exports. Changing it breaks decryption of prior exports. |
| `fsc_portal_dev.sqlite`, `fsc_portal/`, `fsc_portal.db` | `main.dart`, `database/`, `application/boot/` | On-disk database paths. Renaming orphans existing databases. |
| `portal_offline/` | `document_service.dart`, `expenses_home_view.dart`, `local_llm_provider.dart` | On-disk directories for attachments, receipts and models. |
| `admin@fscportal.local` | `application/boot/boot_service.dart` | Seeded admin account identity. |

Renaming these is a **data migration**, not a find-and-replace. Do it deliberately, with
a migration path, or not at all.

## Known issues

See `docs/` and the issue tracker. Notably: `FeedbackCaptureService.capturePortal`
reads `RenderObject.debugNeedsPaint`, which is assert-only and throws in release builds —
the AI feedback capture works in debug and fails when shipped.
