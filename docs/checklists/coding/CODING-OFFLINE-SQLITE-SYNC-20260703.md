# CODING Offline SQLite Sync Checklist

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` PLATFORM_OFFLINE_SQLITE
- `PATTERN:` sqlite-cache-first-daotao
- `DATE:` 2026-07-03

## Source Inputs

- `.agent/tasks/coding/workflow.md`
- `.agent/tasks/coding/rules.md`
- `docs/checklists/checklist_features.md`
- `docs/checklists/checklist_question.md`
- Existing daotao `ApiHelper`, SQLite config, Home dashboard, and schedule controller.

## Changes

- [x] Added SQLite schema v6 table `api_response_cache` for raw daotao response caching by method, path, and normalized request body.
- [x] Updated `ApiHelper.get/post` so successful JSON responses are saved immediately to SQLite, returned from the SQLite row, and reused when network calls fail.
- [x] Expanded `syncData()` to sync notifications, student information, schedule, scores, tuition, training program, prerequisite subjects, course register filters/classes/results.
- [x] Kept mutation-style course registration action out of offline queue scope because conflict policy is not defined.
- [x] Allowed app startup without network when a local SQLite session exists.
- [x] Added Home "Đồng bộ dữ liệu" button with loading state, snackbar result, and dashboard refresh.
- [x] Changed schedule controller display reads to SQLite/cache rather than direct API calls.
- [x] Avoided storing cookie/token/password in `api_response_cache`; request identity uses method/path/body only.

## Verification

- [x] `dart format` on touched Dart files.
- [x] Scoped `flutter analyze` on offline/cache/Home touched files passed.
- [x] `flutter test test\home_dd_home_test.dart test\source_backed_remaining_test.dart` passed.

## Residual Questions

- `OPEN_QUESTION:` Offline queue/conflict policy for daotao mutation actions is still not defined.
- `OPEN_QUESTION:` Full `flutter analyze` remains blocked by 599 existing repo-wide issues outside this slice.
