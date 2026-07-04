# Bug Rules

## Verified Rules
| Rule | Source |
|---|---|
| Authentication and session restore depend on VNUA login and local SQLite session storage. | `lib/features/auth/student/controllers/ctrl_login_student.dart`, `lib/core/services_root/api_daotao/auth/check_login.dart`, `lib/config/config_db.dart` |
| Background sync uses Workmanager and compares cached watched data. | `lib/features/notification/services/background_sync_service.dart`, `lib/features/notification/services/data_change_detector_service.dart` |
| Chat realtime behavior depends on Supabase channels and table changes. | `lib/features/chat/services/chat_service.dart` |
| Known architecture risks are recorded in `.agent/architecture/audit.md`. | `.agent/architecture/audit.md` |

## Recommendations
- Capture the exact screen, role, network state, config-key presence, and data source involved in the bug.
- Do not treat visible placeholder actions as bugs unless expected behavior source says they should work.
- For API symptoms, distinguish VNUA API response shape issues from parsing/model bugs.
- For local database bugs, identify table and migration/version impact before changing schema.

## OPEN_QUESTION
- `OPEN_QUESTION-BUG-01:` No formal issue tracker, severity rubric, or production incident process is documented in the repo.
