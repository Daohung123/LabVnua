# WL-20260723-02 — Daotao full local-first sync

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` DAOTAO_LOCAL_FIRST_SYNC
- `PATTERN:` sqlite-local-first-slice
- `TAGS:` sqlite, daotao, sync, offline, workmanager
- `REF:` `docs/checklists/coding/CODING-DAOTAO-LOCAL-FIRST-SYNC-20260723.md`

## CURRENT

- Make the Daotao student read manifest durable in encrypted owner-scoped SQLite and prevent UI reads from calling the portal directly.

## CHANGED

- Added database version 8 portal sync state and per-resource result records; raw read snapshots remain latest-per-request and owner-scoped.
- Added a full student read coordinator that validates each saved snapshot, projects schedule/profile/notifications locally, and marks initial sync complete only after every resource succeeds.
- Moved student feature read services to local snapshot repositories; course-registration mutation remains online-only and refreshes its dependent reads after success.
- Added initial sync gate, same-user session preservation, hourly unmetered Workmanager registration, Wi-Fi guard, and local data-change polling after refresh.
- Added focused coordinator/snapshot/scheduler tests; scoped analyzer and all 74 full-suite tests pass.

## NOTE

- A failed refresh keeps the previously completed snapshot marker so users with a prior full sync can continue offline; the failed resource is recorded for the next retry.
- iOS periodic scheduling and Wi-Fi enforcement remain best-effort under operating-system background limits.

## TASK SPLIT

- [x] Schema, local repositories, and full read manifest.
- [x] UI readiness gate and mutation refresh behavior.
- [x] Background scheduling and automated verification.
- [ ] Device smoke test for first sync, offline relaunch, Android hourly Wi-Fi work, and iOS background behavior.

## NEXT

1. On an authenticated Android device, complete first sync, relaunch offline, then verify the hourly Wi-Fi task updates SQLite before feature views reload.
2. On iOS, verify first-sync gating and document the observed best-effort background behavior.
