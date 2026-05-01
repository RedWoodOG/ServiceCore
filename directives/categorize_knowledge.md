# Directive: Categorize Knowledge Base

## Goal

Enhance the organization of the knowledge base by moving beyond simple path-based guessing to precise, granular categorization.

## Inputs

- Raw knowledge entries from `C:\Portal_Knowledge_Staging\knowledge_entries`.
- Current list of categories in the database.

## Tools/Scripts

- `execution/categorize_entries_llm.py` (optional, uses LLM if available)
- `execution/categorize_entries_rules.py` (fallback rule-based)

## Logic

1. Scan all `.md` files in the knowledge staging directory.
2. For each file, analyze the frontmatter and the content of the first 500 characters.
3. Identify:
    - **Equipment Type**: (e.g., NCR ATM, Diebold ATM, Kisan Currency Counter, American Vault Pneumatics, JetSort Coin Sorter, La Gard Locks, March DVR, Dahua DVR, Hitachi Currency Counter, Hamilton Air, Audio Systems, Epson Validator, Bavis Pneumatics, Nautlius Hyosung)
    - **Service Type**: (Maintenance, Troubleshooting, Reference, Installation)
    - **Priority**: (High, Standard)
4. Map these to the `Category` field in the database.
5. Ensure "Equipment Type" is displayed in the UI (requires UI update).

## Edge Cases

- **Mixed Content**: If an entry covers multiple topics, use the most specific equipment category.
- **Uncategorized**: Use "General Support" as a fallback.

## Desired Output

- Updated classification in the `KnowledgeEntries` table.
- A summary report in `.tmp/categorization_audit.md`.
