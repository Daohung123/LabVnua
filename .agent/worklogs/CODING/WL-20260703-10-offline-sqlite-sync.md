# WL-20260703-10 Offline SQLite Sync

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` PLATFORM_OFFLINE_SQLITE
- `PATTERN:` sqlite-cache-first-daotao
- `DATE:` 2026-07-03

## Summary

Implemented daotao read-response caching in SQLite, offline startup access for local-session users, and a Home sync button. Schedule display now reads from SQLite/cache; daotao API helper saves valid JSON responses immediately and falls back to cached responses when network calls fail.

## Files

- `lib/config/config_DB.dart`
- `lib/core/services_root/sqlite/api_cache/api_response_cache.dart`
- `lib/core/services_root/api_daotao/root_daotao/daotao_post_get.dart`
- `lib/config/syncData.dart`
- `lib/app.dart`
- `lib/features/schedure/controllers/ctrl_schedure.dart`
- `lib/features/home/home_view/controllers/home_dashboard_controller.dart`
- `lib/features/home/home_view/screens/student_home_view.dart`
- `test/home_dd_home_test.dart`
- `test/source_backed_remaining_test.dart`
- `docs/checklists/coding/CODING-OFFLINE-SQLITE-SYNC-20260703.md`
- `docs/checklists/checklist_features.md`
- `docs/checklists/checklist_question.md`

## Verification

- Focused Home/source-backed tests passed.
- Scoped analyzer passed for touched offline/cache/Home files.
- Full analyzer remains blocked by 599 existing repo-wide issues.

## Follow-Up

- Manual smoke test on device after one successful sync: enable airplane mode, relaunch app, verify Home and cached daotao screens remain usable.
- Define mutation conflict policy before adding offline queues for daotao write actions.
