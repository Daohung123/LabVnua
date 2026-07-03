# CODING-AUTH-20260703-dd-auth - DD_AUTH MVP

- `STATUS:` DONE
- `SCOPE:` AUTH
- `REF:` `docs/DD/DD_AUTH/`
- `PATTERN:` DD-backed Flutter auth UI implementation
- `TAGS:` auth, login, session, avatar-menu, flutter

## GOAL
- [x] Unauthenticated users enter `LoginScreen` directly without manual role selection.
- [x] Login screen keeps email/password fallback and shows VNied as a disabled OAuth2 stub.
- [x] Successful login routes to existing `HomeScreen` until role routing contract is approved.
- [x] Home header avatar dropdown exposes settings, disabled change-password, and logout.
- [x] Logout deletes session and stops chat realtime/notification services.
- [x] SQLite session count check reads the actual count value.

## CONTEXT
- `DD_AUTH` defines VNied OAuth2, secure storage, and role routing as `OPEN_QUESTION`; do not invent contracts.
- Current app uses VNUA email/password login through `ctrl_login` and stores session in SQLite.
- Current authenticated home shell has only a student `HomeScreen`.

## PLAN
- [x] Read `docs/DD/DD_AUTH/` and current auth/home/session code.
- [x] Implement auth entry, login UI stub, session check fix, and logout cleanup.
- [x] Add avatar dropdown to `HomeAppBar`.
- [x] Add focused widget tests.
- [x] Run `flutter test` and `flutter analyze`.
- [x] Update checklist, worklog, and skill index.

## FILES
- [x] `lib/app.dart` - route unauthenticated users to `LoginScreen`.
- [x] `lib/features/auth/student/screens/student_login_view.dart` - optional login handler and VNied disabled stub.
- [x] `lib/features/home/home_view/components/home_app_bar.dart` - avatar dropdown and logout/settings actions.
- [x] `lib/features/home/setting/controllers/controller_settings.dart` - logout cleanup.
- [x] `lib/features/home/setting/screens/view_student_setting.dart` - route logout to `LoginScreen`.
- [x] `lib/core/services_root/sqlite/sessions/core_service_session.dart` - correct count check.
- [x] `test/auth_dd_auth_test.dart` - focused widget tests.

## CHECK
- [x] Scoped lint: `flutter analyze lib\app.dart lib\features\auth\student\screens\student_login_view.dart lib\features\home\home_view\components\home_app_bar.dart lib\features\home\setting\controllers\controller_settings.dart lib\features\home\setting\screens\view_student_setting.dart lib\core\services_root\sqlite\sessions\core_service_session.dart test\auth_dd_auth_test.dart`
- [x] Test: `flutter test`
- [ ] Full lint: `flutter analyze` fails with 649 repo-wide issues outside this AUTH scope.
- [ ] Manual flow: open app unauthenticated -> login -> home -> avatar logout -> login
- [x] Regression: settings logout returns to `LoginScreen` by code path and widget coverage.

## RESULT
- `DONE:` Implemented DD_AUTH MVP source-backed auth routing, disabled VNied stub, avatar menu/logout, session count fix, and focused tests.
- `BLOCKED:` -
- `RISK:` VNied OAuth2, secure storage, and role routing remain intentionally unimplemented pending approved contracts. Full repo analyzer remains blocked by existing non-AUTH lint debt.

## HANDOFF
- `NEXT:` Resolve VNied OAuth2, secure storage, and role routing contracts before expanding AUTH.
- `READ:` `docs/DD/DD_AUTH/README.md`
- `SKILL:` NO - first coding worklog for this pattern.
