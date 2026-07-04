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
| Storage | SQLite `session` table. |
| Risk | Session table includes sensitive fields; see `.agent/architecture/audit.md`. |

## Supabase Chat Service
| Field | Notes |
|---|---|
| Source | `lib/features/chat/services/chat_service.dart`, `lib/features/chat/repository/chat_repository.dart` |
| Purpose | Ensure/search users, load/stream threads, load/stream messages, send messages, ensure conversations. |
| Tables referenced | `users`, `conversations`, `messages` |
| Auth/config | Supabase client initialized from `SUPABASE_URL` and `SUPABASE_ANON_KEY`. |
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
| Source | `lib/features/ai_assistant/controllers/controller_ai.dart` |
| Purpose | Builds Gemini prompt, optionally adds exported notification data when query is notification-related, returns AI text. |
| Config | `GEMINI_API_KEY` via `String.fromEnvironment`. |
| Constraint | Do not copy prompt-included user/private data into worklogs. |

## UI/Design Component Boundary
| Field | Notes |
|---|---|
| Source | `lib/core/theme/README.md`, `lib/core/widgets/README.md` |
| Purpose | Prefer theme component system; legacy widgets retained for compatibility. |
| Guidance | Use `lib/core/theme/app_components.dart` for new UI where feasible. |
