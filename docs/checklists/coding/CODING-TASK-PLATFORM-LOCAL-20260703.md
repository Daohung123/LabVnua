# CODING Task Platform Local Checklist

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` TASK_PLATFORM_LOCAL
- `PATTERN:` sqlite-local-first
- `DATE:` 2026-07-03

## Source Inputs

- `.agent/tasks/coding/workflow.md`
- `.agent/tasks/coding/rules.md`
- `docs/checklists/checklist_features.md`
- Existing SQLite helper and Home dashboard code.

## Changes

- [x] Bumped local SQLite schema to version 5.
- [x] Added local-only `tasks` and `analytics_events` tables.
- [x] Added task model/service/controller for offline Todo CRUD with `sync_status=pending`.
- [x] Added Todo UI from the Learning portal, including create, complete/reopen, delete, loading, empty, and error states.
- [x] Wired upcoming local tasks with due date into the Home deadline section.
- [x] Added local anonymous analytics event model/service/validator.
- [x] Kept analytics backend, consent/retention, dashboard, and task sync/conflict policy out of scope.

## Verification

- [x] `flutter test test\source_backed_remaining_test.dart test\home_dd_home_test.dart`
- [x] `flutter test`
- [x] Scoped `flutter analyze` on touched source/test files passed.
- [x] Full `flutter analyze` still fails on existing repo-wide lint debt unrelated to this slice.

## Open Questions

- `OPEN_QUESTION:` Official task sync API, conflict handling, and online task source are not defined.
- `OPEN_QUESTION:` Analytics provider, consent, retention, and server taxonomy are not approved.
