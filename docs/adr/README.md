# Architecture Decision Records

Each record captures one significant ServiceCore decision: its context, the options considered,
what was decided, and what it leaves open. Requirements IDs (R1–R36) refer to
[the overhaul requirements](../requirements/overhaul-requirements.md).

| ADR | Title | Status | Date |
| :--- | :--- | :--- | :--- |
| [0001](0001-organizations-promote-clients.md) | Make organizations first-class by promoting `clients` in place (R10) | Accepted (owner) | 2026-10-09 |
| [0002](0002-at-rest-encryption-required.md) | At-rest database encryption is required for the first release | Accepted (owner) | 2026-10-09 |

**Template:** name new records `NNNN-short-title.md` with the next number. Use the headings
of ADR-0001: Status, Date, Requirements, Context, Options considered, Decision, Consequences,
and What this ADR does NOT decide. Never rewrite an accepted decision; supersede it with a new
ADR and update both statuses.
