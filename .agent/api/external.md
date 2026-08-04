# External API and Integration Notes

## VNUA Training Portal API
| Field | Notes |
|---|---|
| Direction | App -> VNUA portal HTTP API |
| Purpose | Login and fetch or act on academic data. |
| Base/source | `lib/core/constants/api/api_daotao.dart` |
| Auth | Cookie plus bearer token assembled by `ApiHelper.login`. |
| Request source | `lib/core/services_root/api_daotao/*` |
| Response source | Feature models/services under `lib/features/*` and API wrappers under `lib/core/services_root/api_daotao/*` |
| Contract gap | `OPEN_QUESTION-API-01`: no repo-owned response envelope or external API spec. |

## Supabase
| Field | Notes |
|---|---|
| Direction | App <-> Supabase database/realtime |
| Purpose | Realtime chat users, conversations, messages. |
| Config keys | `SUPABASE_URL`, `SUPABASE_ANON_KEY` through `AppEnvironment` runtime `.env` with Dart-define fallback |
| Init source | `lib/core/services_root/supabase/supabase_config.dart` |
| Table usage source | `lib/features/chat/services/chat_service.dart` |
| Contract gap | `OPEN_QUESTION-API-02`: no repo-owned SQL schema, RLS, or migration file. |

## Gemini
| Field | Notes |
|---|---|
| Direction | App -> Google Generative AI |
| Purpose | AI assistant responses. |
| Config key | `GEMINI_API_KEY` through `AppEnvironment` runtime `.env` with Dart-define fallback |
| Source | `lib/features/ai_assistant/controllers/controller_ai.dart`, `lib/core/constants/api/api_daotao.dart` |
| Safety note | Do not log prompts or local notification exports into worklogs. |

## Local Notifications
| Field | Notes |
|---|---|
| Direction | App -> OS notification APIs |
| Purpose | Notification channels, local notification display, notification routing. |
| Source | `lib/core/services_root/notification/*`, `lib/features/notification/services/notification_service.dart` |
| Platform permissions | Android declares `POST_NOTIFICATIONS`, `INTERNET`, `ACCESS_NETWORK_STATE`, `CAMERA`. |
| Evidence | `android/app/src/main/AndroidManifest.xml` |

## Workmanager
| Field | Notes |
|---|---|
| Direction | App -> OS background task scheduler |
| Purpose | Periodic and one-off background data-change sync. |
| Source | `lib/features/notification/services/background_sync_service.dart` |
| Constraints | Network-connected background sync. |
