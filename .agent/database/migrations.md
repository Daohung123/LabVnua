# Database Migrations

## Current Workflow
- SQLite schema is created in `openDatabase` callbacks inside `lib/config/config_DB.dart`.
- Current encrypted database version is `8`.
- `onCreate` creates base, feature, cache, local-first snapshot, AI-turn, chat-cache, and portal sync-state tables.
- `onUpgrade` adds the local-first tables at version 7 and owner-scoped portal sync state at version 8. Legacy `auth.db` is isolated rather than copied or deleted automatically.

Evidence: `lib/config/config_DB.dart`

## Migration Locations
| Migration type | Location | Evidence |
|---|---|---|
| SQLite create/upgrade | `lib/config/config_DB.dart` | `lib/config/config_DB.dart` |
| Separate migration files | Not found in repo discovery | `rg --files` discovery |
| Supabase migrations | Not found in repo discovery | `lib/features/chat/services/chat_service.dart`, `docs/` |

## Rules for Future Agents
- Do not change SQLite schema without a `BUG` or `CODING` checklist that names the affected table and migration path.
- If adding local tables or columns, update `.agent/database/schema.md`, `.agent/database/migrations.md`, and relevant tests/checklists.
- Do not infer Supabase migrations from Dart table use; require a repo-owned SQL/schema source or record `OPEN_QUESTION`.
- Validate SQLCipher release builds on Android and iOS before treating a persistence change as production-ready.

## OPEN_QUESTION
- `OPEN_QUESTION-DB-04:` No approved migration policy for destructive local schema changes is documented.
- `OPEN_QUESTION-DB-05:` No repo-owned Supabase migration workflow is documented.
