# Create Module DD From Template

Create a complete Design Description package for **one software module**.

## Input

- `MODULE_CODE`: `<e.g. LEARN, AUTH, PROFILE>`
- `MODULE_NAME`: `<business module name>`
- `TECHNICAL_NAME`: `<snake_case module name>`
- `TARGET_DIR`: `docs/DD/DD_<MODULE_CODE>/`
- `TEMPLATE_DIR`: `<path>/DD_Module_Template`
- `SOURCE_BD`: `<BD/BRD path and section>`
- `RELATED_SOURCES`: `<related DD, checklist, issue, ADR, diagram, existing code path>`
- `RELEASE_SCOPE`: `<MVP / V1 / V2 / Sprint>`

## Task

1. Read only sources relevant to this module.
2. Copy `TEMPLATE_DIR` into `TARGET_DIR`.
3. Fill the copied template with module-specific DD.
4. Preserve folder structure, headings, tables, anchors, checklist items, Mermaid blocks, and section order exactly.

## Required Structure

```text
DD_<MODULE_CODE>/
├── README.md
├── Overall.md
├── List_Features.md
├── Function_List.md
├── Views.md
├── Import_File.md
├── diagrams/
│   └── README.md
├── assets/
│   └── README.md
└── history/
    └── README.md
```

## Rules

- One folder equals one module.
- Do not rename, remove, merge, reorder, or add top-level template files.
- Replace applicable placeholders; use `N/A` only when inapplicable.
- Use `OPEN_QUESTION` for unknown rules; do not invent behavior.
- Do not modify application code during DD work.
- Keep the template's language, headings, and Markdown structure. Fill content in the language required by the project; default to English for agent documentation.
- Define each business rule fully only in `Overall.md`; reference its ID elsewhere.
- Do not add out-of-scope behavior.
- Do not include secrets, credentials, private keys, or production PII.

## Traceability IDs

```text
[MODULE_CODE]             e.g. LEARN
[MODULE]-Fxx              Feature
[MODULE]-FNxx             Function / use case
[MODULE]-Vxx              View
[MODULE]-BRxx             Business rule
[MODULE]-APIxx            API / event integration
[MODULE]-E-<name>         Entity / table
[MODULE]-ADRxx            Design decision
[MODULE]-RISKxx           Risk / assumption / open question
```

Every referenced ID must exist. Do not create dangling references.

## Minimum Content

- `Overall.md`: metadata, goals/non-goals, boundary, ownership, context, actors/permissions, feature index, flows, states, business rules, data, integrations, NFR, risks/open questions/ADRs, traceability, approval.
- `List_Features.md`: inventory, dependencies, one complete feature block per feature, rules/functions/views/entities/APIs/events/risks/acceptance criteria, happy/alternate/error flows, idempotency, tests.
- `Function_List.md`: project dependency direction, one function/use-case block per responsibility, I/O, permissions, validation, rules, transaction, side effects, resilience, security, imports, tests.
- `Views.md`: inventory/navigation, one block per view, layout, data source, validation, action mapping, cache/fetch, copy, UX/accessibility, permissions, and required UI states.
- `Import_File.md`: actual dependencies, significant file/layer mapping, allowed/forbidden imports, exports, contracts, config key names, flags, timeout/retry/fallback, test mapping.
- `diagrams/`, `assets/`, `history/`: retain template structure; add only evidence-based relevant assets/diagrams/history.

## Quality Gate

- No applicable placeholder remains.
- No ID is duplicate, missing, or dangling.
- Every feature links to at least one function; every user-facing feature links to at least one view.
- Functions define I/O, authorization, errors, side effects, and tests.
- Views include required UI states and action mapping.
- Rules are defined once and referenced consistently.
- API/entity/state/role/permission descriptions agree across files.
- Import rules follow the verified project architecture.
- Unknowns are `OPEN_QUESTION`.
- The package structure matches the approved template exactly.

## Final Response

```text
STATUS: DONE | BLOCKED
TARGET: <TARGET_DIR>
FILES: <created/updated files>
OPEN_QUESTIONS: <count and IDs, or ->
```

## LabVnua Template Note

`OPEN_QUESTION-DD-02`: This repository currently has Excel DD templates under `docs/base/`, but no repo-owned Markdown module DD folder template matching the structure above. Do not invent one during DD work.
