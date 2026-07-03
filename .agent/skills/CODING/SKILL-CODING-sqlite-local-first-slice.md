# SKILL-CODING-sqlite-local-first-slice

- `TYPE:` CODING
- `PATTERN:` sqlite-local-first-slice
- `TRIGGER:` Use when a Flutter feature needs local SQLite persistence, offline read behavior, or a source-backed local cache without inventing backend conflict rules.
- `EVIDENCE:` `.agent/worklogs/CODING/WL-20260703-02-dd-home.md`, `.agent/worklogs/CODING/WL-20260703-07-task-platform-local.md`, `.agent/worklogs/CODING/WL-20260703-08-class-session-local.md`, `.agent/worklogs/CODING/WL-20260703-10-offline-sqlite-sync.md`

## INPUTS

- Target DD/checklist row and unresolved source gaps.
- Existing SQLite schema helper in `lib/config/config_DB.dart`.
- Existing feature controller/service/UI pattern.
- Test seam for fake repositories or fake dashboard data source.

## STEPS

1. Keep backend-unknown behavior local-only or cache-only; record mutation conflict policy as `OPEN_QUESTION`.
2. Add the smallest SQLite schema/table/index bump needed in `DataBaseConfig`.
3. Add a focused service/repository layer that hides sqflite calls from widgets.
4. Route display code through local SQLite/cache reads; keep explicit sync as the network refresh path when possible.
5. Add widget/unit tests using fake repositories/data sources rather than real SQLite when no FFI test dependency exists.
6. Run focused tests and scoped analyzer, then update checklist, worklog, and skill index.

## CHECK

- Offline/read path does not require network.
- No cookie, token, password, or production PII is added to handoff docs or cache identity.
- Mutation/offline conflict behavior is not guessed.
- Focused tests cover the local read/write or sync trigger behavior.

## PITFALLS

- Do not mark backend sync complete when only local `sync_status` or read cache exists.
- Do not make screen rendering depend on a fresh network call if the requirement is offline access.
- Avoid adding broad dependencies only for tests; prefer existing fake interfaces unless SQLite integration itself must be tested.
