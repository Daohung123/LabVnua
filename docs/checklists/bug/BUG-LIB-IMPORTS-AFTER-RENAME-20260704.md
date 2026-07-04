# BUG-LIB-IMPORTS-AFTER-RENAME-20260704 - broken imports after lib file rename

- `STATUS:` VERIFIED
- `SCOPE:` lib/test import graph after Dart file normalization
- `REF:` user request 2026-07-04
- `PATTERN:` renamed Dart files leave stale imports/exports
- `TAGS:` flutter, imports, rename, analyzer, tests

## BUG
- `SYMPTOM:` Flutter build/test cannot resolve Dart files after snake_case file renames.
- `EXPECTED:` All Dart imports/exports point to existing snake_case files and existing tests keep passing.
- `REPRO:` Run stale-reference scan and `flutter test` after renaming files under `lib`.

## CONTEXT
- A previous CODING pass normalized file names under `lib`.
- Preserve existing app behavior, database schema, API contracts, and clean-architecture changes already present in the worktree.

## FINDING
- `CAUSE:` Stale imports/exports still reference old mixed-case Dart filenames such as `Session.dart`, `config_DB.dart`, and `Schedure_Student.dart`.
- `AFFECT:` Core SQLite/API helpers, auth, schedule, home, AI assistant, notification, widgets, and tests.

## FIX
- [x] Update stale Dart imports/exports to snake_case file names.
- [x] Run formatting for touched Dart sources.
- [x] Add/update regression checks for import boundary and file naming where relevant.

## CHECK
- [x] Reproduce before fix with stale-reference scan and Flutter tests.
- [x] Verify fixed flow with `flutter test`.
- [x] Verify scoped edge case: no invalid Dart filenames remain under `lib`.
- [x] Regression: `flutter analyze` reviewed with `ERROR_COUNT=0`.

## RESULT
- `FIXED:` Unified stale mixed-case imports/exports after file normalization; duplicate analyzer identities for `SessionModel`, `TkbResponse`, and `ThoiKhoaBieu` are removed.
- `BLOCKED:` -
- `RISK:` Full analyzer still reports 559 warning/info issues from existing lint debt; no analyzer errors remain.

## HANDOFF
- `NEXT:` Optional separate lint-debt cleanup for warning/info analyzer issues.
- `READ:` `lib`/`test` import scan output.
- `SKILL:` NO - one-off cleanup until pattern repeats.
