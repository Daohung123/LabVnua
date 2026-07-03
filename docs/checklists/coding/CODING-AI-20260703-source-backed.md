# CODING AI Source-Backed Checklist

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` AI_ASSISTANT
- `PATTERN:` source-backed-ai-shell
- `DATE:` 2026-07-03

## Source Inputs

- `.agent/tasks/coding/workflow.md`
- `.agent/tasks/coding/rules.md`
- `docs/checklists/checklist_features.md`
- Existing AI controller and Home shell code.

## Changes

- [x] Replaced the Home shell `Chat` tab with an `AI` tab.
- [x] Added a full-page `AIChatScreen` based on the existing chat interaction pattern.
- [x] Removed the duplicate draggable AI FAB/dialog path from the Home shell.
- [x] Added local AI context selection for notification and schedule-related prompts.
- [x] Kept STT, OS deep links, and external routing out of scope because provider/privacy contracts are unresolved.
- [x] Avoided logging token, cookie, password, prompt secrets, or PII.

## Verification

- [x] `flutter test test\source_backed_remaining_test.dart test\home_dd_home_test.dart`
- [x] `flutter test`
- [x] Scoped `flutter analyze` on touched source/test files passed.
- [x] Full `flutter analyze` still fails on existing repo-wide lint debt unrelated to this slice.

## Open Questions

- `OPEN_QUESTION:` STT provider, quota, permission, and privacy policy are not defined.
- `OPEN_QUESTION:` OS deep-link scheme and AI data-access policy are not approved.
