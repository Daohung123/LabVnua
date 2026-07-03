# CODING Class Session Local Checklist

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` CLASS_SESSION_LOCAL
- `PATTERN:` schedule-backed-local-detail
- `DATE:` 2026-07-03

## Source Inputs

- `.agent/tasks/coding/workflow.md`
- `.agent/tasks/coding/rules.md`
- `docs/checklists/checklist_features.md`
- Existing schedule item model and Home schedule section.

## Changes

- [x] Added a schedule-backed class session detail screen.
- [x] Opened class session detail from Home schedule cards.
- [x] Rendered subject, teacher, time, date, room, and status from the existing schedule item.
- [x] Added local-only `class_session_notes` SQLite table.
- [x] Added class session note model/service/controller with `session_key`, `owner_hash`, and `sync_status`.
- [x] Added note create/delete UI for class sessions.
- [x] Kept audio recording, transcript, quiz, Q&A, FAQ, roster, export, and contribution scoring blocked on missing contracts.

## Verification

- [x] `flutter test test\source_backed_remaining_test.dart test\home_dd_home_test.dart`
- [x] `flutter test`
- [x] Scoped `flutter analyze` on touched source/test files passed.
- [x] Full `flutter analyze` still fails on existing repo-wide lint debt unrelated to this slice.

## Open Questions

- `OPEN_QUESTION:` Audio provider/storage/retention and permission policy are not defined.
- `OPEN_QUESTION:` Quiz, Q&A, roster, attendance export, and contribution scoring contracts are not available.
