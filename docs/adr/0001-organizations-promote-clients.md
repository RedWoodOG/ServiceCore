# ADR-0001: Make organizations first-class by promoting `clients` in place

## Status

Accepted (owner, 2026-10-09)

## Date

2026-10-09

## Requirements

- **Primary:** R10 in [the overhaul requirements](../requirements/overhaul-requirements.md).
- **Affected:** R1, R6, R8, R9, R12, R19, R20 and R27–R30.

All code citations below were checked at ServiceCore commit `f211688`.

## Context

R10 requires organizations to become "a first-class domain rather than only a loose
client/site grouping, supporting customer hierarchy, contacts, locations, equipment, tickets,
opportunities, and reporting". R20 requires sales and operations to share one customer record,
so customers are not duplicated.

The current schema cannot meet R10:

- **`Clients`** (`lib/database/app_database.dart:15-19`) has three columns: `id`, `name` and
  `themeColor`. It has no parent or hierarchy, no lifecycle status (so a prospect cannot be
  told apart from an active customer), no timestamps and no contacts. `themeColor` is
  required and has no default. Map pins and the map legend derive from it (README,
  Deployments).
- **`Sites`** (`app_database.dart:22-30`) belongs to one client through
  `clientId => integer().references(Clients, #id)()` (line 24). It holds `branchName`,
  `address`, `latitude`, `longitude` and `region`. It has no contact fields.
- Work orders, equipment, notes and documents reach a client only through a site. Each has a
  `siteId` integer with no declared foreign key (`app_database.dart:119`, `:195`, `:243`,
  `:256`). The joins that build `WorkOrderWithDetails` go from work orders to sites to clients
  (`app_database.dart:966-1005` and `:1066-1105`).
- `Sites.clientId` (line 24) is the only declared reference to `clients`. No code in
  `lib/` sets `PRAGMA foreign_keys`, so SQLite does not enforce declared references at
  runtime.
- The schema is at version 15 (`app_database.dart:549`). The migration strategy
  (`app_database.dart:553-739`) runs `createAll` on create. On upgrade it applies a chain of
  `if (from < N)` steps, ending with the v15 knowledge-base step at lines 690-737. There are
  no migration tests under `test/` or `integration_test/`.
- Every `ClientsCompanion.insert` call passes only `name` and `themeColor`. The calls are in
  `lib/database/seed_service.dart` and four test files.

## Options considered

### 1. Keep `clients` and `sites` as they are

- **For:** no migration and no code churn.
- **Against:** fails R10. It has no hierarchy, contacts or prospect state. The sales platform
  (R19) would then need its own customer store, which R20 forbids.
- **Rejected:** it does not meet the requirement.

### 2. Add a new `organizations` table above `clients`

- **For:** the table name matches the domain term, and prospects would live apart from the
  service-side `clients` rows.
- **Against:** two tables would describe one real-world customer. Every existing client
  would need a matching organization row, which is a data copy, plus a new reference from
  `clients` to `organizations`. Code would have to decide which table owns `name` and
  `themeColor`. Prospect-to-customer conversion (AE8) would move data between tables. That is
  the duplication R20 exists to prevent.
- **Rejected:** more migration risk and a second source of truth, for a naming benefit.

### 3. Promote `clients` in place (chosen)

- **For:** additive only, with no data copy. Existing ids, the `sites.client_id` reference,
  the work-order joins, the seed service and the tests keep working. Prospect conversion is a
  status change on the same row, so no record is duplicated.
- **Against:** the SQL table and Dart class keep the name `clients` / `Client` while the
  product and UI say "organization". The `clients` table will also hold prospects and
  inactive organizations, not only current customers.

## Decision

Promote the existing `clients` table to be the organization record, in one additive schema
v16 migration with no data copy:

- Keep the SQL table name `clients` and the Drift class `Clients`.
- Add a nullable, self-referencing **parent id** for customer hierarchy.
- Add a **status** with the values `prospect`, `active` and `inactive`.
- Add **timestamps** (created and updated).
- Add a new **`contacts`** table that belongs to a client.

**Terminology:** in product, UI and requirements text, "organization" means a row in
`clients`. This ADR is the record of that mapping.

## Migration sketch (schema v16)

This is a sketch for the implementation pull request, not final code. Column names and types
may be refined there, provided the change stays additive.

```dart
// Clients: new columns, all nullable or defaulted, so existing rows and every current
// ClientsCompanion.insert(name:, themeColor:) call stay valid.
IntColumn get parentId => integer().nullable().references(Clients, #id)();
TextColumn get status => text().withDefault(const Constant('active'))();
DateTimeColumn get createdAt => dateTime().nullable().clientDefault(() => DateTime.now())();
DateTimeColumn get updatedAt => dateTime().nullable()();

// New table
class Contacts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clientId => integer().references(Clients, #id)();
  TextColumn get name => text()();
  TextColumn get title => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
```

```dart
// schemaVersion 15 -> 16; add Contacts to the @DriftDatabase tables list.
if (from < 16) {
  // V16: organizations (ADR-0001). Additive only; no data copy.
  await m.addColumn(clients, clients.parentId);
  await m.addColumn(clients, clients.status);
  await m.addColumn(clients, clients.createdAt);
  await m.addColumn(clients, clients.updatedAt);
  await m.createTable(contacts);
  await m.database.customStatement(
    'CREATE INDEX idx_clients_parent ON clients(parent_id)',
  );
  await m.database.customStatement(
    'CREATE INDEX idx_contacts_client ON contacts(client_id)',
  );
}
```

Notes for the implementer:

- **Existing rows become `active`** through the column default. Every client in a v15
  database is being serviced today, so this sketch assumes that is the right backfill.
  Confirm it in the implementation pull request.
- **Timestamps are nullable and have no SQL default.** SQLite's `ALTER TABLE ... ADD COLUMN`
  does not accept `CURRENT_TIMESTAMP` or an expression as a default, so Drift's
  `currentDateAndTime` cannot be used for an added column. Rows that existed before v16 keep
  `NULL` (creation time unknown). New rows get a value from `clientDefault`, which Drift
  applies in Dart at insert time.
- **Status values are validated in the application layer**, or with a Drift enum column.
  Adding a SQL `CHECK` constraint through `ALTER TABLE` is optional and must be tested
  against existing rows.
- **The hierarchy must not contain cycles.** SQLite cannot enforce this, so the service that
  sets `parentId` must reject a row as its own ancestor. Roll-up queries can use
  `WITH RECURSIVE`.
- **Self-reference in Drift codegen:** confirm that `references(Clients, #id)` inside
  `Clients` generates correctly. If it does not, declare the column without `references` and
  enforce the link in the service layer.
- **Migration test:** add a v15-to-v16 test that opens a v15 database with clients, sites
  and work orders, upgrades it, and checks that every row and id survives, existing clients
  read as `active`, and `contacts` exists and is empty. No migration tests exist today.

## Consequences

- **R1 (Landing Pad):** role-aware cards can group work by organization, including parent
  roll-ups. Operations cards must filter on `status` so prospects do not appear as service
  customers. Sales cards can show prospects.
- **R12 (dispatch view):** queue filters and groupings by organization go through
  work orders, then sites, then clients and their parents. Work orders keep `siteId` with no
  declared foreign key, so nothing changes in `work_orders`. This ADR does not decide whether
  work can be raised against a prospect or inactive organization; that is an R11/R12 product
  rule.
- **R20 (no duplicate customers):** a sales prospect is a `clients` row with
  `status = 'prospect'`. Converting it to a customer changes `status` to `active` on the same
  row and keeps its id, which satisfies AE8. Future sales tables (R19: opportunities,
  proposals, follow-ups) reference `clients.id`; this ADR does not define them.
  - **Prospect creation still needs a `themeColor`.** It is a required column. Either the
    sales flow supplies one, or a later additive migration gives it a default.
- **R27–R30 (equipment, inventory, peer transfer):** equipment stays site-scoped
  (`equipment.site_id`, `app_database.dart:195`). Organization views of equipment and stock
  reach it through sites and the parent chain. Inventory locations of type "branch" (R28) map
  to sites.
  - This ADR does not model warehouses, trucks or the service company's own stock locations.
  - R28 planning should not store the company's own warehouses or vans as `clients` rows.
  - Peer-transfer audit (R30) links to work orders and equipment and is unaffected.
- **R6 and R8 (location data):** the new `contacts` table gives organizations contacts. Site-
  level contacts (R6 "contact" per location) are not decided here; see below.
- **Code:** Drift code generation must be re-run (`app_database.g.dart`). Existing inserts
  compile unchanged because every new column is nullable or defaulted.
- **Naming debt:** `Client` in code and "organization" in the product will coexist. Renaming
  the table or classes later would be a data migration, not a find-and-replace.

## What this ADR does NOT decide

- Renaming the `clients` table, the `Clients` class or the `Client` row type to
  "organization".
- Lead, opportunity, proposal or follow-up tables for the sales platform (R19).
- Whether a contact can also be attached to a site, which the R6 per-location contact needs.
- Turning on `PRAGMA foreign_keys`. Enabling it could fail on existing orphan rows and needs
  its own assessment.
- Rules for hierarchy depth, or for what a parent organization may own.
- How existing duplicate clients are found and merged (R8).
- Identifiers for sync across devices (R36). Integer autoincrement ids remain.
- At-rest encryption, which is covered by [ADR-0002](0002-at-rest-encryption-required.md).
  The v16 schema migration and the plaintext-to-encrypted file conversion must be ordered
  explicitly in the implementation plan.
