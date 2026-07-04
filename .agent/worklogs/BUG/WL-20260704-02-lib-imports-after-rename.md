# WL-20260704-02 - fix stale imports after lib file rename

- `STATUS:` DONE
- `TYPE:` BUG
- `SCOPE:` lib/test import graph after Dart file normalization
- `PATTERN:` renamed Dart files leave stale imports/exports
- `TAGS:` flutter, imports, analyzer, tests
- `REF:` `docs/checklists/bug/BUG-LIB-IMPORTS-AFTER-RENAME-20260704.md`

## CURRENT
- Restore a single canonical Dart library identity after snake_case file renames under `lib`.

## CHANGED
- `lib` and `test` Dart imports/exports - Replaced stale mixed-case filenames with canonical snake_case paths.
- `lib/core/widgets/README.md` - Updated stale file-name references in shared widget docs.
- `docs/checklists/bug/BUG-LIB-IMPORTS-AFTER-RENAME-20260704.md` - Recorded repro, fix, and verification.

## NOTE
- No database schema, API contract, session behavior, routing, or product flow was changed.
- Full analyzer still reports existing warning/info lint debt, but machine analyzer reports zero errors.

## TASK SPLIT
- `[x]` Read BUG workflow/rules, nearest bug worklog, and provided analyzer diagnostics.
- `[x]` Reproduce stale mixed-case import references and duplicate type identity symptoms.
- `[x]` Update stale references and format touched Dart files.
- `[x]` Verify no invalid Dart filenames remain under `lib`.
- `[x]` Verify `flutter test` passes and analyzer has `ERROR_COUNT=0`.

## NEXT
1. Optional separate cleanup for analyzer warning/info debt.
2. Restart the IDE Dart analysis server if it still shows stale diagnostics for removed mixed-case URIs.
