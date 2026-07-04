# CODING-CLEAN-ARCHITECTURE-20260704 — Clean Architecture refactor

- `STATUS:` DONE
- `SCOPE:` CLEAN_ARCHITECTURE_REFACTOR
- `REF:` user plan 2026-07-04
- `PATTERN:` feature-first-clean-architecture-migration
- `TAGS:` clean-architecture, manual-di, boundaries, flutter, tests

## GOAL
- [x] Add a manual DI composition root without adding dependencies.
- [x] Move tested active feature logic behind domain repositories and use cases.
- [x] Keep current behavior, database schema, API contracts, auth/session policy, and offline sync policy unchanged.
- [x] Add architecture boundary tests for new domain/data/presentation folders.
- [x] Keep `flutter test` passing.

## CONTEXT
- Current repo is feature-first Flutter, not strict Clean Architecture.
- Existing SQLite schema remains in `lib/config/config_DB.dart`.
- Full `flutter analyze` has known baseline debt; do not introduce new scoped failures.

## PLAN
- [x] Read coding workflow, rules, recent worklogs, project map, and matching SQLite skill.
- [x] Create core DI/infrastructure wrappers.
- [x] Migrate task local-first slice to domain/data/presentation.
- [x] Migrate class-session local notes slice to domain/data/presentation.
- [x] Migrate platform analytics interface away from presentation importing data directly.
- [x] Migrate AI tested seam to domain/data/presentation.
- [x] Add and run architecture boundary tests.
- [x] Update related docs/checklists/worklog.

## FILES
- [x] `lib/core/di/app_dependencies.dart` — manual composition root.
- [x] `lib/core/database/app_database.dart` — SQLite wrapper around existing config.
- [x] `lib/core/config`, `lib/core/network`, `lib/core/integrations` — wrappers for existing env/API/integration seams.
- [x] `lib/features/{ai_assistant,class_session,platform,task}/domain` — entities, repositories, usecases.
- [x] `lib/features/{ai_assistant,class_session,platform,task}/data` — datasource/repository implementations.
- [x] `lib/features/{ai_assistant,class_session,task}/presentation` — controllers/screens.
- [x] `test/architecture_boundary_test.dart` — layer boundary checks.

## CHECK
- [x] `dart format` on touched Dart files.
- [x] `flutter test` — 28 tests passed.
- [x] Scoped `flutter analyze` on new/touched architecture paths — no issues.
- [x] Full `flutter analyze` — still fails on existing repo-wide lint debt, now 592 issues.
- [ ] Manual smoke remains recommended for app startup/login/home/offline/chat/AI.

## RESULT
- `DONE:` Added manual DI and core wrappers; migrated task, class-session notes, platform analytics, and AI assistant into domain/data/presentation boundaries; updated home callers and tests.
- `BLOCKED:` -
- `RISK:` Wider legacy feature modules still contain pre-existing controller/service/model folders; migrate them in follow-up slices to avoid behavior changes without test coverage.

## HANDOFF
- `NEXT:` Continue migrating schedule, notification, auth/session, chat, tuition, score, course-register, and student-info modules with dedicated tests.
- `READ:` `docs/checklists/coding/CODING-CLEAN-ARCHITECTURE-20260704.md`
- `SKILL:` NO — refactor pattern not yet repeated three times in completed worklogs.
