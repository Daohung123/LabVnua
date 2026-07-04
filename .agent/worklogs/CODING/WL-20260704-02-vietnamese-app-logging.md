# WL-20260704-02 Vietnamese App Logging

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` App-wide runtime observability
- `PATTERN:` debug-only-vietnamese-logging-helper
- `TAGS:` logging, debug, privacy, app-runtime, user-actions
- `REF:` `docs/checklists/coding/CODING-VIETNAMESE-APP-LOGGING-20260704.md`

## CURRENT
- Runtime logs now use a shared debug-only `AppLog` helper with Vietnamese block formatting, aligned labels, separators, and sensitive-key redaction.

## CHANGED
- Added `lib/core/logging/app_log.dart` and `test/app_log_test.dart`.
- Replaced direct runtime `print`/`debugPrint` usage under `lib` with `AppLog`.
- Added logs for startup, login/session, API/cache, SQLite, sync, home/dashboard, notification, chat, AI, and prerequisite flows.
- Left model-only mapping files uninstrumented directly; their parse/load results are logged by services/controllers.

## NOTE
- `AppLog` uses `print` internally only in debug mode.
- Sensitive keys such as password, token, cookie, authorization, secret, and API key are redacted before printing.
- Existing repo-wide analyzer debt remains outside this change.

## TASK SPLIT
- `[x]` Create checklist and implement shared logging helper.
- `[x]` Add focused logging tests.
- `[x]` Replace old direct logs and instrument major runtime boundaries.
- `[x]` Run format/tests/analyze and record results.

## VERIFY
- `flutter test test\app_log_test.dart` passed.
- `flutter test` passed.
- `flutter analyze` still fails with 361 pre-existing lint/analyzer issues, with no remaining direct `print`/`debugPrint` outside `AppLog`.

## NEXT
1. Manually run the app in debug and review log volume on login, dashboard sync, notification, chat, and AI flows.
2. Consider a feature-level verbosity flag if console noise is too high.
