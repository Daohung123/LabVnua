# CODING Daotao Local-First Sync — 2026-07-23

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` DAOTAO_LOCAL_FIRST_SYNC
- `REF:` User-approved SQLite local-first implementation plan
- `PATTERN:` sqlite-local-first-slice
- `TAGS:` sqlite, daotao, sync, offline, workmanager

## GOAL

- [x] Every supported Daotao semantic read is persisted as the latest encrypted owner-scoped SQLite snapshot before any feature UI consumes it.
- [x] A new account cannot enter Home until the full student read manifest is persisted and validated locally.
- [x] Android schedules a Wi-Fi/unmetered full refresh every hour; iOS uses the same best-effort task with a Wi-Fi guard.

## CONTEXT

- Existing `ApiHelper` already writes valid read responses to owner-scoped SQLite, but most feature services still fetch directly and Home opens before sync completes.
- Course registration action remains a network-only mutation and must refresh dependent read snapshots after a successful result.
- Snapshot retention is latest-per-request until logout; explicit logout deletes the account database and key.

## PLAN

- [x] Load coding workflow, local-first skill, database/API context, and relevant worklogs.
- [x] Add owner-scoped portal sync state and snapshot metadata reads through a schema migration.
- [x] Add a full student read-manifest coordinator, local snapshot repositories, and legacy local projections.
- [x] Route student feature reads through SQLite and keep course-registration action online-only with refresh invalidation.
- [x] Gate first login/startup until full local sync succeeds; preserve same-user cache on re-login.
- [x] Replace periodic background polling with hourly unmetered full sync and foreground due-sync.
- [x] Add focused tests and run formatter, analyzer, and test suite.
- [x] Update database docs, checklist, worklog, and skill counter.

## FILES

- [x] `lib/config/config_db.dart` — schema migration and portal sync state.
- [x] `lib/core/database/` — snapshot/state repositories and full-sync coordinator.
- [x] `lib/features/` — local read services/controllers and app readiness gate.
- [x] `lib/features/notification/services/background_sync_service.dart` — scheduled full sync.
- [x] `test/` — local-first sync, repository, and scheduler coverage.

## CHECK

- [x] Build/lint: formatter and scoped analyzer pass; full analyzer reports 353 pre-existing repo-wide issues outside this slice.
- [x] Data path: validated API read -> encrypted owner-scoped SQLite -> repository -> UI/AI.
- [x] Privacy: no credential, raw payload, chat, contact, financial, or analytics data sent to AI or handoff docs.
- [x] Unit/API test: snapshot/coordinator/scheduler-focused tests and all 74 `flutter test` cases pass.
- [ ] Manual flow: first sync, offline relaunch, hourly Wi-Fi refresh, and course-register refresh on devices.
- [x] Regression: automated chat, local-data, existing data-change, logout, and account-switch coverage pass.

## RESULT

- `DONE:` Database v8 sync state, full validated portal manifest, SQLite-only student reads, first-sync gate, and hourly Wi-Fi scheduler implemented.
- `BLOCKED:` ->
- `RISK:` iOS background execution remains OS best-effort; Android periodic work is inexact by platform design.

## HANDOFF

- `NEXT:` Run Android/iOS device smoke tests for first sync, offline restart, and background scheduling.
- `READ:` `lib/core/database/api_read_snapshot_store.dart`
- `SKILL:` YES — reuse the local-first API snapshot pattern without adding mutation fallback.
