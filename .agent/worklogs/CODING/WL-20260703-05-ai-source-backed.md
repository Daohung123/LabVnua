# WL-20260703-05 AI Source-Backed

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` AI_ASSISTANT
- `PATTERN:` source-backed-ai-shell
- `DATE:` 2026-07-03

## Summary

Replaced the Home shell Chat tab with an AI tab and full-page AI chat screen, removed the duplicate AI FAB, and expanded AI context selection to local notifications and schedule cache when prompts are relevant.

## Files

- `lib/features/home/home_screen/screens/student_home_screen_view.dart`
- `lib/features/home/home_view/components/home_shortcut_catalog.dart`
- `lib/features/ai_assistant/controllers/controller_ai.dart`
- `lib/features/ai_assistant/screens/ai_chat_screen.dart`
- `lib/features/ai_assistant/services/ai_context_service.dart`
- `test/source_backed_remaining_test.dart`

## Verification

- Focused source-backed tests passed.
- Full Flutter test suite passed.
- Scoped analyzer passed for touched files.
- Full analyzer remains blocked by existing repo-wide lint debt.

## Follow-Up

- Resolve STT provider/privacy and deep-link route contracts before adding voice or OS link behavior.
