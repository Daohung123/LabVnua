# WL-20260703-07 Task Platform Local

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` TASK_PLATFORM_LOCAL
- `PATTERN:` sqlite-local-first
- `DATE:` 2026-07-03

## Summary

Added local SQLite-backed Todo and local anonymous analytics foundations. Home deadlines now show upcoming local tasks when available while keeping the official deadline source gap visible.

## Files

- `lib/config/config_DB.dart`
- `lib/features/task/models/task_models.dart`
- `lib/features/task/services/local_task_service.dart`
- `lib/features/task/controllers/local_task_controller.dart`
- `lib/features/task/screens/local_task_screen.dart`
- `lib/features/platform/models/analytics_event.dart`
- `lib/features/platform/services/local_analytics_service.dart`
- `lib/features/home/home_view/components/home_models.dart`
- `lib/features/home/home_view/controllers/home_dashboard_controller.dart`
- `lib/features/home/home_view/components/home_schedule_section.dart`
- `lib/features/home/home_view/screens/student_home_view.dart`
- `test/home_dd_home_test.dart`
- `test/source_backed_remaining_test.dart`

## Verification

- Focused source-backed tests passed.
- Full Flutter test suite passed.
- Scoped analyzer passed for touched files.
- Full analyzer remains blocked by existing repo-wide lint debt.

## Follow-Up

- Define online task API, sync conflict policy, and analytics consent/retention before backend integration.
