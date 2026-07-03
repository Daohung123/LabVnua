# CODING-HOME-20260703-dd-home - DD_HOME Source-Backed MVP

- `STATUS:` DONE
- `SCOPE:` HOME
- `REF:` `docs/DD/DD_HOME/`
- `PATTERN:` DD-backed Flutter home dashboard implementation
- `TAGS:` home, dashboard, schedule, shortcuts, notifications

## GOAL
- [x] Home dashboard renders today's schedule before other Home sections.
- [x] Schedule section uses existing schedule controller data and supports loading, empty, and error states.
- [x] Deadline section does not invent data and shows the approved empty/disabled source gap.
- [x] Notification preview uses existing notification cache/controller data.
- [x] Shortcut grid uses a typed catalog, edit mode, max-8 enforcement, and local SQLite persistence.
- [x] Shortcut profile storage uses a hash-derived profile id and does not store raw user identifiers in checklist/worklog.

## CONTEXT
- `DD_HOME` marks deadline/submission source, analytics shortcut suggestions, and advertising/event source as `OPEN_QUESTION`.
- Current source-backed integrations exist for student schedule and notification cache.
- Current authenticated shell remains the existing student `HomeScreen`; teacher-specific Home behavior is not resolved.

## PLAN
- [x] Read `docs/DD/DD_HOME/` and current Home/schedule/notification/DB code.
- [x] Add Home dashboard data source/controller and typed shortcut models.
- [x] Add SQLite `home_shortcuts` migration and shortcut service.
- [x] Replace Home body with schedule, deadline, shortcuts, and notification sections.
- [x] Add focused HOME widget tests.
- [x] Run relevant tests/analyzer.
- [x] Update checklist, worklog, and skill index.

## FILES
- [x] `lib/features/home/home_view/screens/student_home_view.dart` - Home dashboard composition and injected controller.
- [x] `lib/features/home/home_view/controllers/home_dashboard_controller.dart` - source-backed loading and section-level error isolation.
- [x] `lib/features/home/home_view/components/home_models.dart` - typed shortcut and dashboard state models.
- [x] `lib/features/home/home_view/components/home_shortcut_catalog.dart` - fixed shortcut catalog to existing screens.
- [x] `lib/features/home/home_view/components/home_schedule_section.dart` - today's schedule and deadline empty state UI.
- [x] `lib/features/home/home_view/components/home_notification_section.dart` - notification preview UI.
- [x] `lib/features/home/home_view/components/home_quick_actions.dart` - editable shortcut grid.
- [x] `lib/features/home/home_view/services/home_shortcut_service.dart` - SQLite shortcut persistence.
- [x] `lib/config/config_DB.dart` - database version 4 and `home_shortcuts` table.
- [x] `test/home_dd_home_test.dart` - focused HOME widget tests.

## CHECK
- [x] Test: `flutter test test\home_dd_home_test.dart`
- [x] Test: `flutter test`
- [x] Scoped lint: `flutter analyze lib\config\config_DB.dart lib\features\home\home_view\components\home_models.dart lib\features\home\home_view\components\home_shortcut_catalog.dart lib\features\home\home_view\components\home_quick_actions.dart lib\features\home\home_view\components\home_schedule_section.dart lib\features\home\home_view\components\home_notification_section.dart lib\features\home\home_view\components\index.dart lib\features\home\home_view\controllers\home_dashboard_controller.dart lib\features\home\home_view\services\home_shortcut_service.dart lib\features\home\home_view\screens\student_home_view.dart test\home_dd_home_test.dart`
- [ ] Full lint: `flutter analyze` still fails with 648 repo-wide pre-existing issues outside HOME scope.
- [ ] Manual flow: login -> Home -> view schedule/notification preview -> edit shortcuts -> restart app and confirm shortcut order.
- [x] Regression: existing `flutter test` suite passes, including DD_AUTH tests.

## RESULT
- `DONE:` Implemented source-backed `DD_HOME` MVP with schedule-first Home dashboard, deadline empty state, notification preview, editable shortcut grid, SQLite persistence, and focused tests.
- `BLOCKED:` -
- `RISK:` Deadline/submission, analytics suggestions, teacher Home behavior, and advertising/event source remain intentionally unimplemented pending approved contracts.

## HANDOFF
- `NEXT:` Validate manual Home shortcut persistence on a device/emulator with an authenticated session.
- `READ:` `docs/DD/DD_HOME/README.md`
- `SKILL:` NO - second coding worklog; pattern not repeated three times yet.
