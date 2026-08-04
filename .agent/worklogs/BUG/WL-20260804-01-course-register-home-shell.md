# WL-20260804-01 — Course registration and mobile shell UI fix

- `STATUS:` DONE
- `TYPE:` BUG
- `SCOPE:` COURSE_REGISTER_HOME_SHELL_LOGOUT
- `PATTERN:` flutter-widget-invalid-state-and-bottom-overlay
- `TAGS:` flutter, course-register, dropdown, logout, safe-area
- `REF:` `docs/checklists/bug/BUG-COURSE-REGISTER-HOME-SHELL-20260804.md`

## CURRENT
- Fix the non-rendering course-registration UI, expose a reliable logout action, and prevent mobile navigation/FAB controls from covering bottom-page actions.

## CHANGED
- `lib/features/course_register/` — added safe filter resolution, explicit view states, local-read refresh fallback and structured error logging.
- `lib/features/home/home_screen/screens/student_home_screen_view.dart` — moved mobile navigation into Scaffold layout and reserved content clearance for shadows/FAB.
- `lib/features/home/setting/` and `home_app_bar.dart` — added a shared confirmed logout flow and visible Settings logout actions.
- `test/course_register_view_test.dart`, `test/home_shell_layout_test.dart` — added focused regression coverage.

## NOTE
- Course registration mutations remain online-only and still refresh local read snapshots after success.
- The mobile body now ends above the bottom navigation; the voice FAB no longer relies on a device-specific fixed offset.
- Flutter/Dart executables were unavailable, so verification was limited to source/delimiter/whitespace/secret checks and test definition review.

## TASK SPLIT
- `[x]` Trace the render and overlap causes.
- `[x]` Implement safe course-register load/render behavior.
- `[x]` Centralize and expose logout.
- `[x]` Correct mobile shell layout reservation.
- `[x]` Add regression tests and source-level checks.
- `[ ]` Run Flutter analyzer/tests and device smoke testing in a Flutter-enabled environment.

## NEXT
1. Run focused and full Flutter test suites.
2. Verify Settings logout and the last interactive element on 320–390 px mobile widths.
