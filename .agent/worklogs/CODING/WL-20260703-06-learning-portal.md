# WL-20260703-06 Learning Portal

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` LEARNING_PORTAL
- `PATTERN:` catalog-driven-local-ui
- `DATE:` 2026-07-03

## Summary

Refactored the learning portal into a catalog-driven UI with search, grouped functions, item counts, and empty state while preserving existing academic navigation targets.

## Files

- `lib/features/home/study_view/screens/study_view.dart`
- `lib/features/home/home_view/components/home_shortcut_catalog.dart`
- `test/source_backed_remaining_test.dart`

## Verification

- Focused source-backed tests passed.
- Full Flutter test suite passed.
- Scoped analyzer passed for touched files.
- Full analyzer remains blocked by existing repo-wide lint debt.

## Follow-Up

- Add official course material/deadline metrics only after the source contract is available.
