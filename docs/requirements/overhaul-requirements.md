---
title: ServiceCore Overhaul Requirements
date: 2026-05-01
topic: servicecore-overhaul
status: accepted
accepted: 2026-10-09
accepted_by: owner
updated: 2026-10-09
decisions_resolved: 2026-05-03
owner_decisions: 2026-10-09
merged_from:
  - "Local draft, last edited 2026-05-07 (unpushed working copy; merge base)"
  - "GitHub version, updated 2026-05-03 (FSC-Portal repository, commit 0f0fc73)"
roadmap_note: "2026-05-03: GPS/fleet integration deferred until live system access; hybrid offline+online and program updates first. Reaffirmed by owner decision 2026-10-09: R32 is deferred; R31 and R33 proceed without a GPS vendor."
---

# ServiceCore Overhaul Requirements

> **Status: Accepted** (owner, 2026-10-09).
> This document merges two versions of the overhaul requirements brief, per owner decision of
> 2026-10-09: the local draft last edited 2026-05-07 (the merge base) and the GitHub version
> updated 2026-05-03. [Appendix A](#appendix-a-merge-record) records how each section was
> reconciled.
>
> **Origin:** the brief was written in May 2026 for FSC Portal, the predecessor product from
> which ServiceCore was extracted. Where the text names the product, it now says ServiceCore.

**Related decisions:** [ADR-0001](../adr/0001-organizations-promote-clients.md) (R10:
organizations promote `clients` in place) and
[ADR-0002](../adr/0002-at-rest-encryption-required.md) (at-rest database encryption is
required for the first release).

**Reading the annotations.** A dated heading such as "(2026-05-03)" marks content added in
that revision. "**Owner decision 2026-10-09**" marks a change this merge makes on the owner's
authority. "*Merge note*" marks an editorial reconciliation that changes no requirement.

---

## Problem Frame

ServiceCore needs to move from a mostly functional offline desktop tool into a fully wired operations platform for field service, dispatch, **inventory and parts logistics**, **dispatcher visibility of technicians and vehicles**, sales (after core field maturity), knowledge, equipment, expenses, location intelligence, and local AI assistance. The current repo shows strong building blocks: a Flutter offline-first app, Drift/SQLite database, knowledge base search, work order services, operations views, equipment views, expense schema, and EVA assistant shell. The gap is that several modules are unfinished, inconsistently wired, or not yet cohesive enough for daily operational use.

This document turns the requested "Landing Pad" and overall improvement effort into a formal product requirements brief. It defines what needs to be fixed or expanded before detailed implementation planning. It intentionally avoids code-level decisions, but it does ground scope in existing repository signals such as `lib/database/app_database.dart`, `lib/features/expenses/expenses_home_view.dart`, `lib/features/operations/operations_view.dart`, `lib/services/eva_service.dart`, and `docs/WORK_ORDER_MANAGEMENT.md`.

*Merge note:* both source versions prefixed these paths with `FSC-Portal/`, the app's folder in
the predecessor monorepo. Paths in this document are relative to the ServiceCore repository
root.

---

## Current Product Signals

These signals were observed on 2026-05-03 in the predecessor monorepo. Each "*At `f211688`*"
note was checked against ServiceCore commit `f211688`. Text without such a note is historical
and has not been re-verified.

- The active portal appears to be a Flutter offline-first app under `FSC-Portal/`, with desktop support and an existing local database. *At `f211688`: ServiceCore is that app, extracted as its own repository. It targets Windows (primary) and Android and has no iOS runner (README).*
- `PROJECT_STATUS_REPORT_2026.md` describes the app as beta with strong core modules, but explicitly calls out partial work in EVA, work order editing, equipment management, and expenses. *At `f211688`: this report is not in the repository; session-artifact documents were removed at extraction (CHANGELOG).*
- `docs/WORK_ORDER_MANAGEMENT.md` documents a mature work order workflow model with state transitions, audit logging, permissions, and optimistic locking. *At `f211688`: present. Its permission matrix is marked as not enforced at this revision (CHANGELOG, Documentation corrections).*
- `lib/database/app_database.dart` already contains core local data tables for clients, sites, users, work orders, equipment, knowledge entries, expenses, audit logs, documents, and related operational data. *At `f211688`: confirmed; the table list is at lines 506-540 and the schema version is 15 (line 549).*
- `lib/features/expenses/expenses_home_view.dart` is still a placeholder, even though the database has an `Expenses` table. *At `f211688`: no longer a placeholder. The view saves expenses through `ExpenseService.create` (line 296). README Known issues records an amount-parsing defect in it.*
- `lib/services/local_llm_provider.dart` currently treats ONNX inference as disabled, so EVA falls back to search and scripted/intention-based behavior rather than a working embedded model. *At `f211688`: the file and the ONNX path were removed; EVA answers by retrieval only (CHANGELOG, #1).*
- `Offline-Portal/KNOWLEDGE_BASE_ARCHITECTURE.md` and related knowledge documents describe a more organized knowledge base model that should inform cleanup and taxonomy decisions. *At `f211688`: these documents are not in this repository.*

---

## Product Thesis

The upgraded ServiceCore should become the local-first operating system for field service work:

- The Landing Pad gives every role a clear "what needs attention now" view.
- Dispatchers can triage, assign, and monitor tickets without losing context.
- Technicians can find locations, equipment, work orders, knowledge, expenses, and backup state from one coherent workflow.
- Managers can trust the database as the source of truth for organizations, locations, equipment, work, expenses, and sales activity.
- EVA stays small, local, useful, and grounded in the deployment's own data instead of trying to become a general chatbot.

### Hybrid connectivity (2026-05-03)

**“Offline” describes how the product must run in the field, not a refusal to go online.** The same build must remain **local-first and offline-capable** for core workflows (local DB, capture, navigation, audit) and must **use the network when available** for sync, server APIs, fleet/telematics, messaging integrations, and software updates—without treating disconnected use as a broken or “lite” mode. Planning and UX must label what requires connectivity versus what works air-gapped.

---

## Actors

- A1. Field Technician: Uses the portal in the field to view assigned work, location data, equipment history, knowledge articles, expenses, and EVA help.
- A2. Dispatcher: Creates, triages, schedules, assigns, and monitors tickets and technician workload.
- A3. Operations Manager: Oversees organizations, locations, equipment health, work order metrics, expenses, and reporting.
- A4. Sales User: Manages prospects, customers, opportunities, proposals, and handoff into operations.
- A5. Admin / System Owner: Configures users, data imports, backups, permissions, integrations, and local deployment.
- A6. EVA Assistant: Local embedded assistant that searches, summarizes, and guides users using approved local data.
- A7. Mobile User: Uses iOS or Android app surfaces for field capture, dispatch updates, location access, and expenses.
- A8. Fleet / Telematics Provider (external): Supplies **vehicle** position and status via the company’s existing GPS or fleet platform when integrated; treated as an optional adapter, not a hard dependency for running the portal. *Not integrated until R32 is undeferred; see [Roadmap sequencing](#roadmap-sequencing-owner-direction-2026).*

---

## Key Flows

- F1. Landing Pad Daily Start
  - **Trigger:** A user opens the portal.
  - **Actors:** A1, A2, A3, A4, A6
  - **Steps:** The portal identifies role context, loads local data, shows urgent work, stale records, alerts, tickets, upcoming jobs, expense drafts, backup status, and EVA suggestions.
  - **Outcome:** The user knows what to do next within 30 seconds.
  - **Covered by:** R1, R2, R3, R18, R20

- F2. Ticket Dispatch Lifecycle
  - **Trigger:** A new service request or ticket enters the system.
  - **Actors:** A2, A1, A3
  - **Steps:** Dispatcher creates or receives ticket, attaches organization/location/equipment, sets priority, assigns technician, tracks status, handles blockers, and closes the loop with notes and audit history.
  - **Outcome:** Work is traceable from request to completion with no orphaned ticket state.
  - **Covered by:** R10, R11, R12, R13

- F3. Location and Equipment Lookup
  - **Trigger:** A user searches for a branch, organization, machine, serial number, route, or service history.
  - **Actors:** A1, A2, A3, A6
  - **Steps:** User searches or opens map/list, filters by organization/region/equipment, reviews validated location details, sees equipment installed at the site, and can launch related work or knowledge.
  - **Outcome:** Location and equipment data is accurate, navigable, and operationally useful.
  - **Covered by:** R6, R7, R8, R9, R10, R27
  - *Merge note:* the GitHub version listed R19 here in place of R10 and R27. The local list is kept because this flow has no sales step and filters by organization (R10).

- F4. Expense Capture and Report Submission
  - **Trigger:** A technician needs to record field expenses.
  - **Actors:** A1, A3
  - **Steps:** User enters expense, attaches receipt, links work order/location when relevant, saves draft offline, submits report, manager reviews, export/report is generated.
  - **Outcome:** Expenses are complete, auditable, and connected to work activity.
  - **Covered by:** R14, R15, R16

- F5. Knowledge Search and EVA Help
  - **Trigger:** A user asks a question, searches documentation, or opens equipment-specific help.
  - **Actors:** A1, A2, A3, A6
  - **Steps:** EVA retrieves local knowledge, filters by context, summarizes only grounded content, cites source entries, suggests next actions, and gracefully falls back when no answer exists.
  - **Outcome:** Users get fast, trustworthy local help without needing a large cloud model.
  - **Covered by:** R4, R5, R21, R22

- F6. Local Backup and Recovery
  - **Trigger:** App starts, app exits, scheduled backup time arrives, or admin requests backup.
  - **Actors:** A5
  - **Steps:** Portal checks backup configuration, creates versioned local backup, verifies integrity, records metadata, exposes recovery path, and warns when backup health is poor.
  - **Outcome:** Installed systems can recover from local database corruption, accidental deletion, or machine failure scenarios.
  - **Covered by:** R17, R18
  - **Owner decision 2026-10-09:** backups are not plaintext, and a restore on a different machine must open (ADR-0002).

- F7. Dispatcher Reroute With Field and Vehicle Awareness
  - **Trigger:** Traffic, SLA risk, cancellation, or new urgent work requires changing today’s assignments.
  - **Actors:** A2, A1, A3, A8 (optional)
  - **Steps:** Dispatcher views queue and **live or last-known** technician/vehicle positions from **allowed sources**: authenticated field session (e.g. mobile sign-in / policy-governed phone telemetry) and/or **fleet GPS integration** (vehicle-centric when phones are off). Dispatcher reassigns or reorders work; system records rationale and notifies affected technicians per policy.
  - **Outcome:** Rerouting decisions use the best available picture of **where people and vehicles are**, without assuming phones are powered or apps foregrounded.
  - **Covered by:** R12, R31, R32, R33
  - **Owner decision 2026-10-09:** until R32 is undeferred, this flow uses field-session and manual check-in positions only (R31, R33). The fleet GPS source is added when R32 is undeferred.

- F8. Parts on Truck and Peer Swap (Beat Freight)
  - **Trigger:** A job needs a part that is not on the primary truck or warehouse SLA is too slow.
  - **Actors:** A1, A2, A3
  - **Steps:** System shows **who nearby** (from R33 location model) may carry compatible stock; request/approve **transfer** between trucks or from branch stock; inventory quantities and audit trail update on both sides; optional link to work order and equipment asset.
  - **Outcome:** Field teams resolve part constraints with **peer or branch swaps** faster than waiting on freight when geography and policy allow.
  - **Covered by:** R28, R29, R30, R33

- F9. Branch Equipment Truth (Photos, Serial, Replace vs Repair)
  - **Trigger:** Technician or manager needs to decide service approach at a branch.
  - **Actors:** A1, A2, A3, A6
  - **Steps:** User opens **branch/site equipment** list or detail: photos, description, manufacturer/model/**serial**, service history, linked knowledge; disposition guidance favors **replacement** when policy, age, failure class, or documented standard says so—reducing repeated “band-aid” service on the same asset.
  - **Outcome:** Equipment records are **evidence-rich** and aligned to operational standards, not minimal rows that invite guesswork.
  - **Covered by:** R6, R7, R9, R27

---

## Requirements

**Landing Pad and UI/UX**

- R1. The portal must provide a redesigned Landing Pad that acts as the primary role-aware starting point for field technicians, dispatchers, operations managers, sales users, and admins.
- R2. The UI must be cleaned up into a consistent visual system across dashboard, work, operations, locations, equipment, knowledge, expenses, settings, and EVA surfaces.
- R3. Every primary module shown in navigation must be wired to live local data, useful empty states, loading states, error states, and clear next actions.

**Knowledge Base**

- R4. The knowledge base must be cleaned up, deduplicated, categorized, and organized around the actual field-service taxonomy: equipment, service procedure, troubleshooting, safety, manufacturer, model, and difficulty.
- R5. Knowledge search must support both browsing and task-based retrieval, with source visibility, stale-content indicators, and a review workflow for deprecated or low-quality entries.

**Locations and Location Data**

- R6. Location data must be updated, validated, and normalized so each location has trustworthy organization, address, coordinates, region, contact, notes, and service metadata.
- R7. Location views must support practical field workflows: map browsing, list filtering, route context, site detail, equipment at site, service history, and launch-to-navigation.
- R8. Location imports or edits must prevent duplicate branches, bad coordinates, missing organization links, and ambiguous names.

**Equipment and Organizations**

- R9. Equipment data must be fully wired to organizations, locations, work orders, knowledge entries, warranty/service-contract status, service history, and active/retired state.
- R10. Organization data must become a first-class domain rather than only a loose client/site grouping, supporting customer hierarchy, contacts, locations, equipment, tickets, opportunities, and reporting.
  - **Owner decision 2026-10-09:** organizations are delivered by promoting the existing `clients` table in place. Schema v16 adds a parent link, a status (prospect, active or inactive), timestamps and a `contacts` table, with no data copy. See [ADR-0001](../adr/0001-organizations-promote-clients.md).

**Operations and Ticketing**

- R11. The ticketing/work order system must be reconfigured into a complete operational workflow for intake, triage, assignment, status transitions, notes, attachments, equipment links, and closure.
- R12. Dispatchers must have a dedicated dispatch view for queue management, technician workload, SLA/priority visibility, scheduling, and ticket reassignment.
- R13. Work orders must preserve auditability: who changed what, when, why, from which status, and with which linked assets or expenses.

**Expenses**

- R14. The expense report system must be fully wired from placeholder state to working feature: create, edit, attach receipt, categorize, link to work/location, submit, approve/reject, export, and search.
- R15. Expenses must support offline drafting and later reconciliation without duplicate reports or lost receipt paths.
- R16. Expense reporting must have enough validation to prevent incomplete reports, unsupported categories, orphaned receipts, or unreviewable submissions.

**Local Backup and Recovery**

- R17. The installed app must create local backups on the machine where it is installed, with configurable location, retention, integrity checks, and recovery visibility.
  - **Owner decision 2026-10-09:** at-rest database encryption is required for the first release and is delivered with backup and recovery. Backups must not be plaintext, and a restore on another machine must open through a key-recovery path. See [ADR-0002](../adr/0002-at-rest-encryption-required.md).
- R18. Backup health must appear in admin/settings and surface warnings on the Landing Pad when backups are stale, failing, or unconfigured.

**Sales Platform**

- R19. A sales platform must be added or scoped to manage leads, prospects, organizations, contacts, opportunities, proposal status, follow-ups, and handoff from sales to operations.
- R20. Sales data must connect to organization/location data so customers are not duplicated between sales and operations.

**Mobile Apps**

- R21. iOS and Android app requirements must be defined from the same product model, prioritizing field capture, dispatch updates, expense receipts, location lookup, and offline access.
- R22. Mobile scope must not fork core business logic away from the local-first portal model; it should reuse shared data contracts and role flows where possible.

**EVA Local Embedded AI**

- R23. EVA must either be repaired or redesigned as a small local assistant focused on search, summarization, contextual guidance, and field-service help.
- R24. EVA must remain small enough to run practically on installed machines and must never require a large always-online cloud model for core help/search.
- R25. EVA answers must be grounded in the deployment's local content, show sources when possible, and admit uncertainty when the knowledge base lacks an answer.

**Integrations**

- R26. Teams integration and/or Flowspace integration must be evaluated as optional communication/orchestration layers, not assumed as mandatory dependencies until a clear operational workflow is chosen.

**Branch equipment evidence and disposition (2026-05-03)**

- R27. Branch and site **equipment records** must support **multiple photos**, structured identity (manufacturer, model, **serial number**, asset tag), rich description, and tight linkage to organization/location and work history so dispatch and field staff share one **equipment truth**.
- R28. **Inventory management** must be first-class: parts catalog (SKU or internal part id), quantities, locations (**branch**, **warehouse**, **truck/van**), reservations against work orders where applicable, and auditable adjustments (receive, transfer, consume, return).
- R29. **Truck/van stock** must be assignable **per technician and/or per vehicle**, with explicit ownership or custody rules so dispatch and inventory views stay consistent.
- R30. **Peer parts transfer** workflows must support locate-nearby-candidates (using the unified location model), request/approve/deny, execution with **two-sided inventory** updates, and ticket/equipment linkage for postmortems and warranty.

**Technician presence and fleet GPS (2026-05-03)**

- R31. **Field technician authentication** (including mobile or field-issued sign-in) must tie a live session to an identity dispatch can trust for **status and optional location sharing**, governed by **written policy** (what is collected, retention, consent, employer notice). Design must assume phones may be off or unavailable.
  - **Owner decision 2026-10-09:** proceeds without a GPS vendor. R31 does not depend on R32.
- R32. **Fleet GPS adapter**: the product must support an **integration path** to the company’s existing **vehicle** tracking system (vendor API TBD in planning) so **vehicle last-known or live positions** can feed dispatch when integrated—reducing sole reliance on technician phones.
  - **Owner decision 2026-10-09: deferred.** R32 remains a requirement, but it is roadmap-only until there is live access to the production GPS/fleet system and its vendor, API, authentication and vehicle-to-technician mapping are recorded. It is not a current sprint commitment. Inventory, the equipment dossier and dispatch UX without third-party GPS proceed without blocking on it. See [Roadmap sequencing](#roadmap-sequencing-owner-direction-2026).
- R33. **Unified dispatch location model** must store **source**, **timestamp**, and **accuracy/confidence** for each reading (e.g. manual check-in, phone policy, vehicle telematics) and present them clearly to dispatchers so they do not confuse vehicle with person without explicit UI semantics.
  - **Owner decision 2026-10-09:** proceeds without a GPS vendor. Until R32 is undeferred, readings come from manual check-in and policy-governed phone sources. Vehicle telematics stays a listed source type.

**Sales timing reinforcement (2026-05-03)**

- R34. The **sales platform** (R19–R20) remains **after core field workflows are complete** and **after** the inventory / parts / fleet-visibility tranche (R27–R33) unless leadership explicitly overrides; sales handoff must still reuse organization records (R20) when it ships.
  - *Merge note:* whether this gate waits for deferred R32 is an open point; see [Open point for owner confirmation](#open-point-for-owner-confirmation).

**Competitive benchmarking (2026-05-03)**

- R35. Maintain a **living competitive matrix** comparing this portal’s intended capabilities to publicly documented SMB and mid-market field-service and adjacent products, on dimensions aligned to **R1–R36**. **Artifact:** `docs/research/competitive-field-service-matrix.md`. Update on a defined cadence (e.g. quarterly) or when GTM positioning changes.
  - *At `f211688`, this artifact is not yet in the ServiceCore repository.*

**Platform and connectivity (2026-05-03)**

- R36. The portal must implement **hybrid operation**: core field workflows function **without** network access on the local database, and **connected** features (sync, remote APIs, push/pull configuration, optional cloud-assisted processing) activate when service and credentials allow. Users see explicit **connectivity state**; sync and remote writes must be **safe to retry** and must not corrupt local truth when offline.
  - *Merge note:* both versions carry R36 with this text. The GitHub version adds that the number R36 was chosen to avoid colliding with drafts that use R27 for branch-equipment scope; this merge keeps R27–R35 as above.

---

## Acceptance Examples

- AE1. **Covers R1, R3.** Given a dispatcher opens the portal, when the Landing Pad loads, they see unassigned tickets, high-priority work, technician workload, backup warnings, and clear shortcuts into dispatch actions.
- AE2. **Covers R4, R5, R23, R25.** Given a technician asks EVA about a machine issue, when relevant knowledge exists, EVA returns a concise answer with source entries and suggested follow-up actions.
- AE3. **Covers R6, R7, R8.** Given an admin imports updated branch data, when duplicates or invalid coordinates are detected, the system flags them for review instead of silently creating bad locations.
- AE4. **Covers R9, R10.** Given an operations manager opens an organization, they can see all related locations, equipment, open tickets, recent service, expenses, and sales context.
- AE5. **Covers R11, R12, R13.** Given a dispatcher reassigns a high-priority ticket, when the change is saved, the ticket history records the reassignment, reason, actor, timestamp, and affected technician.
- AE6. **Covers R14, R15, R16.** Given a technician creates an expense report offline with receipt photos, when connectivity or sync returns, the report remains intact and does not duplicate receipts or amounts.
- AE7. **Covers R17, R18.** Given the local backup job fails for multiple days, when an admin opens the app, backup health is visibly degraded and recovery guidance is available.
- AE8. **Covers R19, R20.** Given a sales user converts a prospect into an active customer, when operations receives the handoff, the organization record is reused rather than duplicated.
- AE9. **Covers R21, R22.** Given a technician uses the mobile app, they can view assigned work, update status, capture receipts/photos, and use essential location data without relying on a separate business model.
- AE10. **Covers R24, R25.** Given the local AI model is unavailable or too heavy for a machine, EVA still provides useful deterministic knowledge search and does not block core portal workflows.
- AE11. **Covers R27, R9.** Given a branch has ten ATMs on site, when a technician opens the equipment list, they see serial-identified rows with photos and descriptions sufficient to choose **replace vs repair** per documented standard.
- AE12. **Covers R28–R30, R33.** Given a tech needs a control board not on their truck, when dispatch searches nearby inventory, the system suggests another tech or branch with stock and completes an approved transfer with full audit and updated quantities.
- AE13. **Covers R31–R33.** Given fleet GPS is integrated and a technician’s phone is off, when dispatch opens the map, they still see **vehicle** position from telematics (if available) and clear labeling that **person** position is stale or unknown.
  - **Owner decision 2026-10-09:** the vehicle-position part of this example becomes testable only after R32 is undeferred. The labeling of stale or unknown person positions (R31, R33) is testable now.
- AE14. **Covers R35.** Given a release milestone, when reviewers open the competitive matrix, each major capability area maps to **parity / ahead / behind / not applicable** with citations or dated notes.
- AE15. **Covers R36.** Given the device has no network, when a technician completes a work order update and captures photos, the data persists locally and queues for sync without error loops. When the network returns, sync reconciles without duplicate tickets or lost attachments.
  - *Merge note:* the GitHub version numbers this example AE15 and the local draft numbers the same text AE16. AE15 is used here; AE16 is an alias for it and must not be reused.

---

## Success Criteria

- The portal feels like one cohesive operations system instead of separate partially wired modules.
- Every navigation destination either performs useful work or clearly explains what is missing and how the user proceeds.
- Locations, organizations, equipment, work orders, expenses, and knowledge entries share consistent relationships.
- A dispatcher can run daily ticket flow from the portal without external spreadsheets.
- A technician can complete a normal field-service loop: review job, open location, inspect equipment history, use knowledge/EVA, update ticket, attach evidence, and submit expenses.
- An admin can trust backup status and recover from local data loss.
- EVA is useful even when local LLM inference is unavailable, and better when a small model is working.
- The next implementation plan can split this into phased work without inventing product behavior.
- Dispatchers can reroute work using **vehicle and/or technician** situational awareness when integrations and policy allow, without assuming phones are always on.
- Inventory and truck stock support **operational part swaps** that are faster than freight when another tech or branch can supply the part.
- Branch equipment views are **photo- and serial-complete** enough to reduce repeated substandard repairs on the same asset.
- Connected features measurably improve operations when online, while **offline mode remains trustworthy** for the same core jobs (no mandatory “find Wi‑Fi to finish”).

---

## Scope Boundaries

### Deferred for later

- Full cloud multi-tenant SaaS architecture is not required for the first overhaul pass.
- Advanced AI agent autonomy is deferred until EVA search/help is reliable, grounded, and small.
- Full ERP/accounting integration is deferred until expense reporting and sales records work locally.
- Full route optimization beyond practical dispatch/location improvements is deferred unless it becomes a top operational bottleneck.
- **Replacing** a third-party fleet platform is out of scope; **R32** is adapter-only. Deep telematics features (engine diagnostics, fuel tax) stay with the fleet vendor unless explicitly added later.
- **Owner decision 2026-10-09:** the R32 fleet GPS adapter itself is deferred until there is live access to the production GPS/fleet system (see [Roadmap sequencing](#roadmap-sequencing-owner-direction-2026)).

### Outside this product's identity

- The portal should not become a generic CRM disconnected from ServiceCore field operations.
- EVA should not become a general-purpose chatbot with unbounded internet answers.
- Mobile apps should not become separate products with separate business rules.
- Teams or Flowspace should not become required just to operate the local portal.
- The product must not be designed or marketed as **offline-only**; “offline” means **offline-capable** with optional **online augmentation**.

---

## Key Decisions

- Treat this as a platform overhaul, not a visual-only refresh: UI improvement must happen alongside wiring and data integrity work.
- Keep local-first behavior as a core product constraint: backup, offline drafts, and embedded help matter because the portal may run on installed machines in field-service contexts.
- Make organizations, locations, equipment, work orders, and expenses the central operational graph.
- Repair the current work order/ticketing surface before adding complex dispatch features, because dispatch depends on reliable ticket lifecycle data.
- Build Sales and Dispatcher platforms as role-specific workspaces inside the same portal model, not disconnected apps.
- Evaluate Teams and Flowspace after core operational flows are reliable, because integration should amplify workflows rather than compensate for missing ones.
- Redesign EVA around grounded retrieval first, with local LLM synthesis as an enhancement, not a dependency.
- **Sales (R19–R20)** ships **after** core field service maturity **and** the **inventory + dispatch visibility** tranche (R27–R33), per stakeholder direction (2026-05-03); R34 captures this ordering.
- **Technician and vehicle location** capabilities must be **policy- and contract-aware**; legal review for employee tracking and client site rules is assumed before production rollout of R31–R33.
- **Hybrid connectivity (R36):** ship **local-first** behavior first where gaps exist, then add **online** paths (sync, APIs) with conflict handling—both are first-class product requirements, not an either/or.
- **Owner decision 2026-10-09, fleet GPS:** R32 is deferred until there is live access to the production GPS/fleet system; R31 and R33 proceed without a GPS vendor.
- **Owner decision 2026-10-09, organizations (R10):** promote `clients` in place in an additive schema v16 migration ([ADR-0001](../adr/0001-organizations-promote-clients.md)).
- **Owner decision 2026-10-09, at-rest encryption:** required for the first release and delivered with backup and recovery ([ADR-0002](../adr/0002-at-rest-encryption-required.md)).

---

## Dependencies / Assumptions

- The existing Flutter/Drift local database remains the near-term source of truth unless implementation planning decides otherwise.
- Current partial features in ServiceCore are preferred over starting from a blank app, but modules may need overhaul when wiring is incomplete or data models are insufficient.
- Existing work order workflow documentation is a strong starting point and should not be thrown away without a specific reason.
- The sales platform, dispatcher platform, and mobile apps need product-level scope refinement before implementation.
- Local backup must account for database files, attachments/receipts, imported knowledge, and configuration, not just schema data.
- EVA model choice must be validated against machine constraints, installation size, startup time, memory use, and answer usefulness.
- **Fleet GPS integration (R32)** depends on API access, credentials, rate limits, and mapping from provider **vehicle ids** to portal users/vehicles; multiple providers may require a small adapter interface in planning. *Deferred until live system access (owner decision 2026-10-09).*
- **R35** depends on someone owning research updates; stale competitor data is worse than none for licensing conversations.

---

## Risks

- **Over-scope risk:** This is large enough to become several projects. Mitigation: split into phased implementation plans after this requirements doc.
- **Data migration risk:** Equipment, organization, location, and expense overhaul may require schema changes. Mitigation: characterize current data and add migration tests before changing persisted tables.
- **UX polish without wiring risk:** A nicer interface could hide incomplete data flows. Mitigation: require each UI upgrade to include data, empty, error, and action states.
- **AI complexity risk:** Local LLM work can consume time without improving field outcomes. Mitigation: make retrieval/search quality the baseline and treat model synthesis as optional.
- **Mobile divergence risk:** iOS/Android apps could fork business logic. Mitigation: define shared data contracts and role flows before building mobile screens.
- **Integration distraction risk:** Teams or Flowspace could become premature architecture. Mitigation: evaluate only after dispatch/workflow events are reliable in the portal.
- **Employee privacy / compliance risk:** Phone or vehicle tracking (R31–R33) can create labor-law or policy violations if rolled out without disclosure and controls. Mitigation: product defaults to least collection; admin-configurable modes; audit who saw what location data.
- **Telematics vendor lock-in risk:** Fleet APIs differ and churn. Mitigation: adapter boundary, contract tests against recorded fixtures, documented fallback to manual status and phone-sourced data only.

---

## Resolved Before Planning (2026-05-03; extended 2026-10-09)

These decisions unblock `docs/plans/` implementation planning. They follow **Recommended Phasing**, **Key Decisions**, and **Scope Boundaries** already stated in this document. The first three rows date from 2026-05-03; the last three were added by owner decision on 2026-10-09.

| Topic | Decision | Rationale |
| :--- | :--- | :--- |
| **R19–R20 Sales platform** | **Phase-two implementation** (after operations/ticketing and shared org/location graph are stable); **sequenced after** the **inventory + fleet/dispatch visibility** tranche (**R27–R33**, **R34**). | Original rationale unchanged. **2026-05-03:** Stakeholder direction—ship sales **after most field service is complete** and **after** inventory, truck stock, technician presence, and optional vehicle GPS integration, so CRM does not outrun operational truth. |
| **R21–R22 Mobile apps** | **Not required for the first market-ready release** of the local-first desktop portal; **mobile is Phase 7** after desktop/local stability. | Aligns with phased roadmap and **Mobile divergence risk** mitigation: define shared data contracts and role flows during desktop phases; ship iOS/Android once core workflows are proven. **R21–R22** remain in scope as **requirements to specify**, not as gate for first desktop GA. |
| **R26 Flowspace vs Teams** | **No default preference**; **evaluate both during integration planning** (Phase 8) against the same event set once core portal workflows emit reliable signals. | Matches **Key Decisions** (integrations amplify, not compensate) and **Scope Boundaries** (Teams/Flowspace not required to operate locally). Selection criteria: fit for dispatch/work-order events, admin burden, licensing, and customer constraints—documented in the Phase 8 plan. |
| **R31–R33 Technician presence and fleet GPS** (2026-10-09) | **R32 (fleet GPS adapter) stays a requirement but is deferred** until there is live access to the production GPS/fleet system and its vendor, API, authentication and vehicle-to-technician mapping are recorded. **R31** (field technician sessions) and **R33** (unified location model with source, timestamp and confidence) **proceed without a GPS vendor** in Phase 3c. | **Owner decision 2026-10-09.** Reconciles this table with the GitHub version's `roadmap_note` and **Roadmap sequencing** (2026-05-03). Inventory, the equipment dossier and dispatch UX without third-party GPS proceed without blocking on telematics. |
| **R10 Organizations** (2026-10-09) | **Promote `clients` in place.** Keep the SQL table `clients`; add a nullable self-referencing parent link, a status (prospect, active, inactive), timestamps and a new `contacts` table in one additive schema v16 migration, with no data copy. | **Owner decision 2026-10-09.** Resolves the R6–R10 question under **Deferred to Planning**. See [ADR-0001](../adr/0001-organizations-promote-clients.md). |
| **At-rest database encryption** (2026-10-09) | **Required for the first release.** Delivered with local backup and recovery (R17–R18; delivery milestone M3), using the database key the app already generates, with a key-recovery path so a restore on a new machine opens. | **Owner decision 2026-10-09.** The database is plaintext at `f211688`. See [ADR-0002](../adr/0002-at-rest-encryption-required.md). |

### Optional override

If business reality changes (e.g. signed OEM requires mobile day one, or sales-led GTM), revise this section and re-sequence phases in `docs/plans/` rather than silently diverging from the table above.

### Open point for owner confirmation

- **Does the R34 sales gate wait for deferred R32?** R34 and the Sales row above sequence sales after the R27–R33 tranche. Roadmap sequencing says that inventory, the equipment dossier, dispatch UX without third-party GPS "and other overhaul items" proceed without blocking on telematics. Read together, they suggest the sales gate covers R27–R31 and R33 but not deferred R32. That reading is this merge's interpretation; the owner decision of 2026-10-09 does not state it. R34 is unchanged until the owner confirms or corrects it.

## Outstanding Questions

### Resolve Before Planning (all resolved)

The GitHub version listed these three questions as open. The local draft resolved them on 2026-05-03 (table above), so they are kept here only as a record.

- [Affects R19, R20][User decision] Should the Sales Platform be a first-class module in this overhaul, or a phase-two module after operations/ticketing is stabilized? **Resolved 2026-05-03:** phase two, sequenced after the inventory and dispatch-visibility tranche (R34).
- [Affects R21, R22][User decision] Are iOS/Android apps required for the first market-ready release, or should mobile be planned after the desktop/local portal is stable? **Resolved 2026-05-03:** not required for the first market-ready release; mobile is Phase 7.
- [Affects R26][User decision] Should Flowspace be treated as the preferred integration target over Microsoft Teams, or should both be compared during planning? **Resolved 2026-05-03:** no default preference; evaluate both in Phase 8.

### Deferred to Planning

- [Affects R6-R10][Technical] Determine whether the existing `clients` and `sites` model is enough or whether a dedicated organizations model is required. **Resolved 2026-10-09 (owner):** promote `clients` in place; see [ADR-0001](../adr/0001-organizations-promote-clients.md).
- [Affects R11-R13][Technical] Determine how much of the documented work order workflow is implemented versus only documented.
- [Affects R14-R16][Technical] Determine whether expense receipts should be stored as local file paths, managed documents, or backup-aware attachments.
- [Affects R17-R18][Technical] Determine which local backup format and retention strategy best fits installed-machine use. **Constrained 2026-10-09 (owner):** backups must not be plaintext and must restore on another machine ([ADR-0002](../adr/0002-at-rest-encryption-required.md)). Format and retention remain open.
- [Affects R23-R25][Needs research] Compare viable small local EVA strategies: improved FTS/ranking, embeddings, tiny ONNX model, llama.cpp-compatible local model, or hybrid retrieval plus deterministic templates.

---

## Roadmap sequencing (owner direction, 2026)

- **Primary now:** Make **offline** and **online/hybrid** behavior reliable end-to-end (**R36**), and **refresh the rest of the program** (navigation, modules, data wiring, expenses, knowledge, operations—per phases below). This is the gating work.
- **Fleet / vehicle GPS and deep dispatcher map from telematics:** **Roadmap only** until the team can work **in front of the production GPS/fleet system** and record vendor, API, auth, and how vehicles map to techs. Do not treat GPS integration as a current sprint commitment; competitor research still informs **future** parity.
- Inventory, equipment dossier, dispatch UX without third-party GPS, and other overhaul items proceed **without** blocking on telematics.
- **Reconciled by owner decision 2026-10-09:** **R32** (fleet GPS adapter) stays a requirement and is the item deferred above. **R31** (field technician sessions) and **R33** (unified location model with source, timestamp and confidence) are not telematics; they proceed without a GPS vendor in Phase 3c. The phase order below, including Phases 3b, 3c and 5b, is unchanged.

---

## Recommended Phasing

- Phase 1: Stabilize foundation and UX shell: Landing Pad, navigation consistency, module status, shared empty/error/loading states, and backup visibility.
- Phase 2: Data integrity pass: organizations, locations, equipment, work order links, seed/import cleanup, and duplicate prevention. (Organizations per [ADR-0001](../adr/0001-organizations-promote-clients.md).)
- Phase 3: Operations and dispatch: ticket lifecycle, dispatcher workspace, assignment, audit, attachments, and service history.
- **Phase 3b (2026-05-03): Inventory, truck/van stock, and branch equipment evidence** — R27–R30: parts catalog, custody by tech/vehicle, transfers and peer swaps with audit, **photos and serial-rich** equipment at branches/sites, tie-in to work orders and equipment graph.
- **Phase 3c (2026-05-03; amended by owner decision 2026-10-09): Dispatcher field and vehicle visibility** — R31 and R33 proceed without a GPS vendor: authenticated field/mobile sessions for technicians, optional policy-governed phone telemetry, the unified location model with source, timestamp and confidence, and unified map semantics and reroute UX (extends R12) built on manual check-in and phone sources. **R32 (fleet GPS adapter for vehicle positions) is deferred**: it stays a requirement but is roadmap-only until there is live access to the production GPS/fleet system. Phase 3c does not block on telematics.
- Phase 4: Expenses: receipt capture, reports, approval, exports, and work/location linkage.
- Phase 5: Knowledge and EVA: taxonomy cleanup, review workflow, improved search, small local assistant strategy, and source-grounded responses.
- **Phase 5b (2026-05-03): Competitive benchmarking upkeep** — R35: refresh `docs/research/competitive-field-service-matrix.md` on cadence; feed gaps into backlog.
- Phase 6: Sales platform: prospect/customer/opportunity flow and handoff into organizations/operations (**after 3b–3c** per R34 unless overridden).
- Phase 7: Mobile apps: iOS/Android field workflows using shared product model (field sign-in and telemetry policies should align with R31–R33).
- Phase 8: Integrations: Flowspace and/or Teams notifications, handoffs, and workflow events; **fleet telematics** may share adapter work with Phase 3c or move here if decoupling is cleaner—decide in `docs/plans/`. Whichever phase hosts it, R32 stays deferred until live system access (owner decision 2026-10-09).

---

## Next Steps

-> Create a structured implementation plan in `docs/plans/` that splits this overhaul into reviewable phases and implementation units. Use these as fixed inputs: **Resolved Before Planning (2026-05-03; extended 2026-10-09)**, **Roadmap sequencing**, **R27–R35 / Phase 3b–3c / 5b**, and ADR-0001 and ADR-0002.
-> Seed and maintain **`docs/research/competitive-field-service-matrix.md`** (R35) as the single place for “compare to other programs on the web.”

*Merge note:* the GitHub version's next step began "Resolve the three product questions above". It is superseded, because those questions were resolved on 2026-05-03.

---

## Appendix A: Merge record

Sources: the local draft (last edited 2026-05-07, front matter `updated: 2026-05-03`) and the
GitHub version (FSC-Portal commit `0f0fc73`, `updated: 2026-05-03`). The local draft is the
base. Nothing from either version was dropped; superseded items are kept and marked.

| Section | Source | Resolution |
| :--- | :--- | :--- |
| Front matter | Both | Local `decisions_resolved` and GitHub `roadmap_note` both kept. Status set to accepted (owner, 2026-10-09). `topic` renamed to `servicecore-overhaul`. |
| Title, product name | Both | "FSC Portal" renamed to ServiceCore; origin noted once in the header. |
| Problem Frame | Local adds inventory, technician/vehicle visibility, sales timing | Local text kept. Path prefix `FSC-Portal/` removed. |
| Current Product Signals | Both (identical) | Kept as a dated snapshot with "*At `f211688`*" notes. |
| Product Thesis, Hybrid connectivity | Both (identical) | Kept. "FSC data" generalized. |
| Actors A1–A7 | Both | Kept. |
| Actor A8 | Local only | Kept, with R32 deferral note. |
| Flows F1, F2, F4, F5, F6 | Both (identical) | Kept. F6 annotated with ADR-0002. |
| Flow F3 | Both, different "Covered by" | Local list (R10, R27) kept; the GitHub R19 is recorded in a merge note. |
| Flows F7–F9 | Local only | Kept. F7 annotated with R32 deferral. |
| Requirements R1–R26 | Both (identical) | Kept. R10 and R17 annotated with ADR-0001 and ADR-0002. R25 "FSC content" generalized. |
| Requirements R27–R35 | Local only | Kept. R31, R32, R33 annotated with the owner decision; R34 and R35 annotated. |
| Requirement R36 | Both | Text identical. The GitHub numbering note is kept as a merge note. |
| Acceptance Examples AE1–AE10 | Both (identical) | Kept. |
| Acceptance Examples AE11–AE14 | Local only | Kept. AE13 annotated with R32 deferral. |
| AE15 (GitHub) / AE16 (local) | Both, same text, different numbers | Kept once as AE15; AE16 recorded as an alias. |
| Success Criteria | Local adds 3 | Union of both. |
| Scope Boundaries | Local adds the fleet-platform bullet | Union of both, plus the R32 deferral bullet. "FSC field operations" generalized. |
| Key Decisions | Local adds sales sequencing and location policy | Union of both, plus three owner decisions of 2026-10-09. |
| Dependencies / Assumptions | Local adds R32 and R35 dependencies | Union of both. R32 dependency annotated as deferred. |
| Risks | Local adds privacy and telematics lock-in | Union of both. |
| Resolved Before Planning | Local only | Kept; three rows added by owner decision 2026-10-09. |
| Outstanding Questions: Resolve Before Planning | GitHub only (3 open questions) | Superseded by the Resolved table; kept with resolutions. |
| Outstanding Questions: Deferred to Planning | Both (identical) | Kept. The R6–R10 item is resolved by ADR-0001; the R17–R18 item is constrained by ADR-0002. |
| Roadmap sequencing (owner direction, 2026) | GitHub only | Kept; reconciliation bullet added. "you" changed to "the team". |
| Recommended Phasing | Local adds 3b, 3c, 5b and notes on 6–8 | Local kept. Phase 3c rewritten for the R32 deferral; Phase 2 and Phase 8 annotated. |
| Next Steps | Both, different | Local kept and extended. The GitHub step is superseded and recorded in a merge note. |

**De-identification.** Neither version names a customer, bank, branch, or person, and neither
contains credentials. The only identifying changes are the product rename and these generalized
phrases: "approved FSC data" (A6), "grounded in FSC data" (Product Thesis), "local FSC content"
(R25), "FSC field operations" (Scope Boundaries), and the `FSC-Portal/` path prefixes.

**Open editorial item (not changed).** In both versions, F5 (Knowledge Search and EVA Help)
lists R21 and R22, the mobile requirements, under "Covered by". It does not list the EVA
requirements R23–R25. The mapping is kept as written until the owner corrects it.
