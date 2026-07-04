# WL-20260704-01 Clean Architecture Refactor

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` CLEAN_ARCHITECTURE_REFACTOR
- `PATTERN:` feature-first-clean-architecture-migration
- `TAGS:` clean-architecture, manual-di, boundaries, sqlite, ai
- `REF:` `docs/checklists/coding/CODING-CLEAN-ARCHITECTURE-20260704.md`

## CURRENT
- Added a Clean Architecture foundation and migrated tested feature slices without changing product behavior, schema, auth/session policy, API contracts, or offline sync policy.

## CHANGED
- `lib/core/di`, `lib/core/database`, `lib/core/config`, `lib/core/network`, `lib/core/integrations` — added manual DI and infrastructure wrappers around existing services.
- `lib/features/task` — moved local Todo entity/repository/usecase/datasource/controller/screen into domain/data/presentation layers.
- `lib/features/class_session` — moved local text-note entity/repository/usecase/datasource/controller/screen into domain/data/presentation layers.
- `lib/features/platform` — moved analytics event validation and local SQLite analytics repository behind a domain repository/usecase.
- `lib/features/ai_assistant` — moved AI context selection, SQLite context loading, Gemini calls, repository/usecase, controller, and screen into domain/data/presentation layers.
- `test/architecture_boundary_test.dart` — added boundary checks for new domain/data/presentation folders.

## NOTE
- Remaining legacy modules still use older controller/service/model folder patterns and should be migrated in follow-up slices with focused tests.
- Full analyzer remains blocked by existing repo-wide lint debt; scoped analyzer on new/touched architecture paths passed.
- No backend contracts, mutation conflict policy, role routing, audio/STT, task online sync, attendance, residence, or analytics backend behavior was added.

## TASK SPLIT
- `[x]` Manual DI composition root and core wrappers.
- `[x]` Task, class-session notes, platform analytics, and AI assistant migration.
- `[x]` Boundary test and test import updates.
- `[x]` Checklist and worklog update.
- `[ ]` Follow-up migration for schedule, notification, auth/session, chat, tuition, score, course-register, and student-info.

## NEXT
1. Pick one remaining module with tests or add tests first.
2. Move that module through domain repository, usecase, data repository/datasource, and presentation controller/screen.
