# Database Overview

## Local Data Store
- The app uses SQLCipher through `sqflite_sqlcipher`.
- User data database files are named `aqedu_<owner_hash>.db`; the database key is held in `flutter_secure_storage`.
- The legacy `auth.db` is isolated and is not a UI/AI source. It is not copied into the encrypted store.
- Database setup is centralized in `lib/config/config_db.dart`.

Evidence: `pubspec.yaml`, `lib/config/config_db.dart`

## Access Method
- `DataBaseConfig.database` opens the database and creates or upgrades schema.
- Feature services use `DataBaseConfig` directly or through small service classes under `lib/core/services_root/sqlite/` and feature service folders.

Evidence: `lib/config/config_db.dart`, `lib/core/services_root/sqlite/*`, `lib/features/*/services/*`

## Data Ownership
| Data area | Tables | Primary code owner by path |
|---|---|---|
| Secure session | platform secure storage | `lib/core/security/secure_session_store.dart` |
| Portal notifications | `notifications` | `lib/core/services_root/sqlite/notification/notification_sqlite.dart`, `lib/features/notification/services/service_sql_notification_student.dart` |
| Student profile | `student_data` | `lib/core/services_root/sqlite/infomationStudent/information_sqlite.dart`, `lib/features/infor/services/service_sqlite_information_student.dart` |
| Data-change history and cache | `notification_history`, `cached_*`, `thoi_khoa_bieu` | `lib/core/services_root/sqlite/notification/data_change_sqlite.dart`, `lib/features/notification/services/background_sync_service.dart` |
| Chat notifications | `chat_notifications` | `lib/core/services_root/notification/notification_manager.dart`, `lib/features/chat/services/chat_notification_service.dart` |

Evidence: `lib/config/config_db.dart`, related service paths above

## Conventions
- Owner isolation is enforced by an encrypted database per owner hash; new snapshot, AI-turn, and chat-cache tables also carry `owner_hash`.
- Raw API snapshots are local-only and are never sent to Gemini. UI/AI uses projections/allowlists.
- Some change/cache operations use SQLite transactions.
- Data-change IDs and payload hashes use SHA-256 in the detector service.
- Soft-delete and tenant conventions are not evidenced for local SQLite.

Evidence: `lib/core/services_root/sqlite/notification/data_change_sqlite.dart`, `lib/features/notification/services/data_change_detector_service.dart`

## External Schema Gap
- Supabase chat tables are referenced in Dart as `users`, `conversations`, and `messages`.
- No repo-owned Supabase SQL schema, migration, RLS policy, or table definition file was found.

Evidence: `lib/features/chat/services/chat_service.dart`

## OPEN_QUESTION
- `OPEN_QUESTION-DB-01:` Supabase table schema, indexes, constraints, and RLS/authorization policies are not available in this repository.
- `OPEN_QUESTION-DB-02:` The intended secure-storage policy for `session.pass`, cookies, and tokens is not documented.
