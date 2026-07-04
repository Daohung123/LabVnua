# CODING-VIETNAMESE-APP-LOGGING-20260704 - Vietnamese runtime logging

- `STATUS:` DONE
- `SCOPE:` App-wide runtime observability
- `REF:` user request 2026-07-04
- `PATTERN:` shared debug-only logging helper
- `TAGS:` logging, debug, vietnamese, privacy, observability

## GOAL
- [x] Add a shared `AppLog` helper that uses `print` internally, runs only in debug, and formats logs in Vietnamese blocks.
- [x] Replace direct runtime `print`/`debugPrint` usage with `AppLog`.
- [x] Add clear logs for user actions, screen lifecycle, app startup, API, SQLite/cache, sync, notification, chat, AI, and error flows.
- [x] Keep sensitive data redacted.

## CONTEXT
- Existing logs are scattered across startup, API, services, and UI with mixed `print`/`debugPrint` usage.
- `flutter_lints` enables `avoid_print`; direct `print` calls should be isolated inside the shared helper.
- Product behavior, API contracts, local SQLite schema, and auth/session policy must not change.

## PLAN
- [x] Read current logging, UI action, API, SQLite, notification, chat, and AI entrypoints.
- [x] Implement `AppLog`.
- [x] Add unit coverage for Vietnamese format, separators, redaction, and truncation.
- [x] Replace existing direct logs and instrument major runtime flows.
- [x] Update related docs/checklists.

## FILES
- [x] `lib/core/logging/app_log.dart` - shared debug-only logging helper.
- [x] `test/app_log_test.dart` - logging helper tests.
- [x] `lib/**/*.dart` runtime entrypoints - call `AppLog` at meaningful runtime boundaries.

## CHECK
- [x] Build/lint: `flutter analyze` reviewed; still fails on 361 existing repo-wide lint issues unrelated to logging policy.
- [x] Unit/API test: `flutter test`
- [x] Manual flow: log format reviewed through widget/unit test console output.
- [x] Regression: ensure no direct `print`/`debugPrint` remains outside `AppLog`.

## RESULT
- `DONE:` Added debug-only Vietnamese block logging, replaced direct runtime prints/debugPrints, instrumented major runtime flows, and added logging tests.
- `BLOCKED:` -
- `RISK:` Broad instrumentation can be noisy; model-only files are intentionally logged through their callers rather than every mapper call. Analyzer remains red from pre-existing lint debt.

## HANDOFF
- `NEXT:` Optional follow-up: tune log volume per feature after manual device review.
- `READ:` `lib/core/logging/app_log.dart`
- `SKILL:` NO - one-off logging policy until repeated.
