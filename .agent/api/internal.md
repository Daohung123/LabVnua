# Internal API and Service Boundaries

## VNUA Portal API Helper
| Field | Notes |
|---|---|
| Source | `lib/core/services_root/api_daotao/root_daotao/daotao_post_get.dart` |
| Purpose | Login, create authenticated API helper, make GET/POST calls against VNUA portal API base. |
| Auth | Builds cookie and bearer token from login flow; do not copy values into docs. |
| Request/response source | Endpoint constants in `lib/core/constants/api/api_daotao.dart`; response parsing in service/model files under `lib/core/services_root/api_daotao/` and `lib/features/*`. |
| Consumers | Auth, schedule, scores, notifications, information, tuition, training program, prerequisites, course registration. |

## Login and Session Flow
| Field | Notes |
|---|---|
| Source | `lib/features/auth/student/controllers/ctrl_login_student.dart`, `lib/core/services_root/api_daotao/auth/check_login.dart`, `lib/core/services_root/api_daotao/auth/re_login.dart` |
| Purpose | Authenticate student, store session locally, restore current session. |
| Storage | Platform secure storage; no credentials are stored in SQLite. |
| Risk | Database encryption key and credential material must never be logged or included in AI context. |

## Supabase Chat Service
| Field | Notes |
|---|---|
| Source | `lib/features/chat/services/chat_service.dart`, `lib/features/chat/repository/chat_repository.dart` |
| Purpose | Ensure/search users, load/stream threads, load/stream messages, send messages, ensure conversations. |
| Tables referenced | `users`, `conversations`, `messages` |
| Auth/config | Supabase client initialized from `SUPABASE_URL` and `SUPABASE_ANON_KEY` through `AppEnvironment`. |
| Tests | `test/chat_service_test.dart` covers `generateConversationId`. |

## Data-Change and Background Sync
| Field | Notes |
|---|---|
| Source | `lib/features/notification/services/background_sync_service.dart`, `lib/features/notification/services/data_change_detector_service.dart`, `lib/core/services_root/sqlite/notification/data_change_sqlite.dart` |
| Purpose | Poll watched academic data, compare hashes, store history/cache, show local notifications. |
| Idempotency evidence | `change_id` unique value and conflict ignore on insert. |
| Scheduling | Workmanager periodic task and one-off task. |

## AI Assistant Controller
| Field | Notes |
|---|---|
| Source | `lib/features/ai_assistant/data/repositories/gemini_ai_assistant_repository.dart` |
| Purpose | Classifies typed AI work, loads only allowlisted local context, and returns typed text/speech/navigation results. |
| Config | `GEMINI_API_KEY` via `AppEnvironment`: `flutter_dotenv` runtime `.env` first, `String.fromEnvironment` fallback. |
| Constraint | Do not copy prompt-included user/private data into worklogs. |

## Local-first API Rules
- `ApiReadResourceRegistry` classifies endpoints by semantic read/mutation, including POST reads.
- Only valid reads are cached/snapshotted; a mutation error is rethrown and is never satisfied from cache.
- `PortalReadSyncCoordinator` refreshes the complete student read manifest, verifies the encrypted SQLite snapshot after each response, then records full-sync state in `portal_sync_state`.
- Student feature read services use `PortalLocalReadStore`; course-registration action remains online-only and refreshes dependent snapshots after success.

## UI/Design Component Boundary
| Field | Notes |
|---|---|
| Source | `lib/core/theme/README.md`, `lib/core/widgets/README.md` |
| Purpose | Prefer theme component system; legacy widgets retained for compatibility. |
| Guidance | Use `lib/core/theme/app_components.dart` for new UI where feasible. |
