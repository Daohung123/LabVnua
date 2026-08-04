# BUG-COURSE-REGISTER-HOME-SHELL-20260804 — Fix course registration, logout and mobile shell overlap

- `STATUS:` FIXED
- `SCOPE:` course_register, home_shell, settings/auth
- `REF:` user report 2026-08-04
- `PATTERN:` flutter-widget-invalid-state-and-bottom-overlay
- `TAGS:` flutter, dropdown, logout, bottom-navigation, safe-area

## BUG
- `SYMPTOM:` Course registration UI may not render; logout is difficult to find; floating mobile controls can cover actions near the bottom of a page.
- `EXPECTED:` Course registration always renders loading/content/empty/error states, logout is visible and confirmed, and mobile navigation/FAB never overlays page actions.
- `REPRO:` Open course registration with a default filter excluded from the dropdown or missing local snapshots; scroll Settings/other pages to the last action on a short mobile viewport.

## CONTEXT
- Student authenticated flow under `HomeScreen`.
- Preserve local-first reads and online-only course registration mutations.

## FINDING
- `CAUSE:` The selected course filter was not validated against the displayed dropdown items, which can trigger a Flutter assertion and prevent rendering. Local-load failures were collapsed into empty data. The mobile voice FAB used a fixed bottom offset, and logout navigation was duplicated without a shared confirmation flow.
- `AFFECT:` Course registration view/controller, mobile home shell, Settings and Home avatar menu.

## FIX
- [x] `lib/features/course_register/controllers/ctrl_courses_register.dart` — add coordinated local-load and course-registration refresh fallback.
- [x] `lib/features/course_register/screens/view_courses_register.dart` — deduplicate/validate filter values and add loading/content/empty/error/retry states.
- [x] `lib/features/home/home_screen/screens/student_home_screen_view.dart` — move mobile navigation to `Scaffold.bottomNavigationBar`, reserve shadow/FAB clearance and remove the fixed `bottom: 98` offset.
- [x] `lib/features/home/setting/controllers/student_logout_flow.dart` — shared confirmation, session cleanup, failure handling and navigation reset.
- [x] `lib/features/home/setting/screens/view_student_setting.dart` — AppBar logout action, reachable bottom logout button, loading lock and safe bottom padding.
- [x] `lib/features/home/home_view/components/home_app_bar.dart` — reuse the shared logout flow while preserving test callbacks.
- [x] Add regression tests for filter safety, course-register error UI, Settings logout visibility and shell source constraints.

## CHECK
- [x] Reproduce before fix by source trace: invalid dropdown value and fixed overlay offset confirmed.
- [x] Source-level verification: changed Dart files have balanced delimiters, no tabs/trailing whitespace and no new secret literals.
- [x] Verify negative/edge case in tests: hidden/duplicate/empty filters and loader failure are covered.
- [x] Regression definitions retained: avatar logout callback remains injectable; course registration mutation remains online-only.
- [ ] Run `flutter analyze` and `flutter test` on a machine with Flutter SDK.
- [ ] Device smoke test on a short Android viewport and gesture-navigation device.

## RESULT
- `FIXED:` Course registration no longer passes an invalid value to the dropdown; missing local data triggers a scoped refresh and failures show a retry UI. Logout is immediately visible in Settings and shared across entry points. Mobile navigation is layout-reserved and the voice FAB has explicit content clearance.
- `BLOCKED:` Flutter/Dart executables are unavailable in the current execution environment, so automated Flutter tests could not be executed here.
- `RISK:` Final pixel-level behavior still requires device verification, especially with large text scale and landscape orientation.

## HANDOFF
- `NEXT:` Run `flutter analyze`, `flutter test test/course_register_view_test.dart test/home_shell_layout_test.dart test/auth_dd_auth_test.dart`, then smoke-test on device.
- `READ:` `lib/features/course_register/screens/view_courses_register.dart`
- `SKILL:` NO — one-off fix until repeated evidence exists.
