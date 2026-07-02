# Create API DD Package From Template

Create a complete API Detail Design package for **one API operation only**.

## Input

- `API_CODE`: `<e.g. LEARN-PROGRESS-001>`
- `MODULE_CODE`: `<e.g. LEARN>`
- `API_NAME`: `<short API name>`
- `TARGET_DIR`: `docs/api-dd/<module-code-lowercase>/<api-code-lowercase>/`
- `TEMPLATE_DIR`: `<path-to>/Study2Work_API_DD_Template`
- `BUSINESS_SOURCE`: `<BD path / section>`
- `RELATED_SOURCES`: `<DD, API checklist, issue, diagram, ADR, existing code paths>`

## Task

1. Read only the relevant source files.
2. Copy `TEMPLATE_DIR` into `TARGET_DIR`.
3. Fill the copied template for this API operation.
4. Preserve the template structure exactly.

## Required Structure

```text
<TARGET_DIR>/
├── README.md
├── HUONG_DAN_NHAP_LIEU_DD.md
├── API_DD_CHECKLIST.md
├── 01_Overview/Overview.md
├── 02_History/History.md
├── 03_Request/Request.md
├── 04_Response/Response.md
├── 05_DataMapping/DataMapping.md
└── 06_Error/Error.md
```

## Rules

- One package equals one API operation.
- Do not rename, remove, merge, reorder, or add template files, headings, table columns, rows, or sections.
- Replace applicable placeholders. Use `N/A` only when genuinely inapplicable.
- Use `OPEN_QUESTION` for unknown behavior; never invent business rules.
- Keep template guidance files unchanged unless the approved project standard changed.
- Use English for DD content.
- Use `camelCase` JSON fields, `snake_case` database fields, UUID IDs, and ISO-8601 UTC timestamps unless project conventions prove otherwise.
- Use the project's verified response envelope. If none is verified, write `OPEN_QUESTION`; do not invent one.
- JSON examples must be valid.
- Define authentication, authorization, scope/ownership, validation, transaction behavior, data access, audit/event behavior, and errors when applicable.
- Do not include secrets, private data, raw credentials, passwords, tokens, OTPs, or hidden tests.
- Do not add behavior not approved by the source requirement.

## Minimum Content

- `01_Overview/Overview.md`: identity, business goal, scope, source trace, preconditions, postconditions, authorization/scope, ownership, async work, open questions.
- `02_History/History.md`: initial `v0.1` history entry; append future changes only.
- `03_Request/Request.md`: headers, path/query/body fields, validation order, valid request example.
- `04_Response/Response.md`: response matrix, success/error envelopes, field definitions, pagination/async behavior if applicable.
- `05_DataMapping/DataMapping.md`: runtime flow, reads/writes, repositories, transaction/idempotency/concurrency, audit/events/jobs, derived tests.
- `06_Error/Error.md`: stable error catalog, HTTP status, business code, safe message, retry policy, log level, test references.
- `API_DD_CHECKLIST.md`: update every applicable item.

## Quality Gate

- No applicable placeholder remains.
- Method, endpoint, actor, auth, permission, and scope are consistent across all files.
- Request fields, validation, and errors agree.
- Examples match field tables.
- Data mapping lists verified reads/writes and transaction boundaries.
- Every error has a safe message and test reference.
- Unknowns are `OPEN_QUESTION`.
- The output structure remains exactly identical to the approved template.

## Final Response

```text
STATUS: DONE | BLOCKED
TARGET: <TARGET_DIR>
FILES: <created/updated files>
OPEN_QUESTIONS: <count and IDs, or ->
```

## LabVnua Template Note

`OPEN_QUESTION-DD-01`: This repository does not currently contain a repo-owned Markdown API DD package template matching the required `Study2Work_API_DD_Template` structure. Do not use outside-repo templates as LabVnua truth unless a future task explicitly imports or approves them.
