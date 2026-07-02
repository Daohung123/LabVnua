# API Index

## Internal Boundaries
| Boundary | Purpose | Details |
|---|---|---|
| VNUA API helper | Authenticated GET/POST to VNUA portal API. | `.agent/api/internal.md` |
| SQLite services | Local persistence for session, student data, notifications, cached watched data. | `.agent/database/*` |
| Supabase chat repository/service | Chat users, conversations, messages, realtime streams. | `.agent/api/internal.md`, `.agent/api/external.md` |
| Notification/background sync services | Poll academic data, detect changes, show local notifications. | `.agent/api/internal.md` |
| AI assistant controller | Gemini prompt construction and response handling. | `.agent/api/external.md` |

## External Integrations
| Integration | Direction | Purpose | Evidence |
|---|---|---|---|
| VNUA training portal API | App -> external HTTP API | Login and academic data fetch/actions. | `lib/core/constants/api/api_daotao.dart`, `lib/core/services_root/api_daotao/root_daotao/daotao_post_get.dart` |
| Supabase | App <-> external backend/realtime | Chat users, conversations, messages, realtime subscriptions. | `lib/core/services_root/supabase/supabase_config.dart`, `lib/features/chat/services/chat_service.dart` |
| Gemini | App -> external AI API | AI assistant response generation. | `lib/features/ai_assistant/controllers/controller_ai.dart` |
| Local notification platform APIs | App -> OS notification APIs | Local alerts for data changes and chat. | `lib/core/services_root/notification/*`, `lib/features/notification/services/notification_service.dart` |
| Workmanager platform APIs | App -> OS background task APIs | Periodic/one-off background sync. | `lib/features/notification/services/background_sync_service.dart` |

## Contract Gaps
- `OPEN_QUESTION-API-01:` The project has no repo-owned formal API response envelope specification for VNUA portal responses.
- `OPEN_QUESTION-API-02:` The project has no repo-owned Supabase schema/RLS contract.
- `OPEN_QUESTION-API-03:` Markdown API DD package templates are not present in this repository.
