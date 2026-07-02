# Project Map

## Components
| Component | Root paths | Evidence |
|---|---|---|
| Flutter mobile/web app | `lib/`, `android/`, `ios/`, `web/` | `pubspec.yaml`, `android/app/src/main/AndroidManifest.xml`, `ios/Runner/Info.plist`, `web/manifest.json` |
| Shared app core | `lib/core/`, `lib/config/` | `README.md`, `lib/core/theme/README.md`, `lib/config/config_DB.dart` |
| Feature modules | `lib/features/` | `README.md`, `lib/features/*` |
| Documentation and DD sources | `docs/` | `docs/repository-audit.md`, `docs/base/*`, `docs/auth/*` |
| Automated tests | `test/` | `test/chat_service_test.dart` |

## Technology Stack
| Area | Verified stack | Evidence |
|---|---|---|
| App framework | Flutter / Dart SDK `^3.9.2` | `pubspec.yaml` |
| State style | Flutter widgets, controllers, services, repositories; no dedicated external state-management package listed | `pubspec.yaml`, `README.md`, `lib/features/*` |
| HTTP | `http` package for VNUA portal calls | `pubspec.yaml`, `lib/core/services_root/api_daotao/root_daotao/daotao_post_get.dart` |
| Local database | `sqflite` with `path` | `pubspec.yaml`, `lib/config/config_DB.dart` |
| Realtime backend | `supabase_flutter` | `pubspec.yaml`, `lib/core/services_root/supabase/supabase_config.dart` |
| AI integration | `google_generative_ai` with Gemini key via dart define | `pubspec.yaml`, `lib/core/constants/api/api_daotao.dart`, `lib/features/ai_assistant/controllers/controller_ai.dart` |
| Notifications/background work | `flutter_local_notifications`, `workmanager` | `pubspec.yaml`, `lib/features/notification/services/background_sync_service.dart` |
| QR scanning | `mobile_scanner` | `pubspec.yaml`, `README.md`, `lib/features/qr_code/screens/view_qr_code.dart` |
| Network checks | `connectivity_plus` | `pubspec.yaml`, `lib/app.dart` |

## Entry Points
| Entry point | Role | Evidence |
|---|---|---|
| `lib/main.dart` | Initializes Flutter binding, HTTP override, notifications, Workmanager sync, Supabase, then renders `MyWidget`. | `lib/main.dart` |
| `lib/app.dart` | Checks connectivity and login state, then routes to loading, no-network, home, or role selection screens. | `lib/app.dart` |
| `lib/features/home/home_screen/screens/student_home_screen_view.dart` | Main authenticated shell with home, study, chat, other, settings tabs and AI dialog. | `lib/features/home/home_screen/screens/student_home_screen_view.dart` |
| `android/app/src/main/AndroidManifest.xml` | Android app label, launcher activity, camera/internet/network/notification permissions. | `android/app/src/main/AndroidManifest.xml` |
| `web/manifest.json` | Web app manifest still names `aqedu` and has template description. | `web/manifest.json` |

## Commands
| Command | Purpose | Evidence |
|---|---|---|
| `flutter pub get` | Install Flutter dependencies. | `README.md`, `pubspec.yaml` |
| `flutter run --dart-define=GEMINI_API_KEY=... --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...` | Run app with required client config keys. | `README.md`, `.env.example`, `lib/core/constants/api/*.dart` |
| `flutter test` | Run automated tests. | `README.md`, `test/chat_service_test.dart` |
| `flutter analyze` | Run analyzer using Flutter lints. | `analysis_options.yaml` |

## Module Map
| Module | Root path | Responsibility | Evidence |
|---|---|---|---|
| Auth/student login | `lib/features/auth/`, `lib/core/services_root/api_daotao/auth/` | Student role selection, login, session restore. | `lib/features/auth/student/controllers/ctrl_login_Student.dart`, `lib/app.dart` |
| Home shell | `lib/features/home/` | Main navigation, dashboards, settings, study tab, AI entry. | `lib/features/home/home_screen/screens/student_home_screen_view.dart` |
| Schedule | `lib/features/schedure/`, `lib/core/services_root/api_daotao/schedure/` | Schedule fetch, models, views, local schedule storage. | `lib/features/schedure/*`, `lib/core/services_root/sqlite/schedure/schedure_sqlite.dart` |
| Scores | `lib/features/score_data/`, `lib/core/services_root/api_daotao/score/` | Score lookup and analysis. | `lib/features/score_data/*`, `lib/core/services_root/api_daotao/score/getScoreResponse.dart` |
| Tuition | `lib/features/tuition/`, `lib/core/services_root/api_daotao/tuition/` | Tuition data fetch and display. | `lib/features/tuition/*`, `lib/core/services_root/api_daotao/tuition/getTuition.dart` |
| Course registration | `lib/features/course_register/`, `lib/core/services_root/api_daotao/course_Register/` | Course registration filters, classes, action, results. | `lib/features/course_register/*`, `lib/core/constants/api/api_daotao.dart` |
| Training program | `lib/features/program_training/` | Training program display. | `lib/features/program_training/*` |
| Prerequisite subjects | `lib/features/prerequisite_subjects/` | Prerequisite subject lookup. | `lib/features/prerequisite_subjects/*` |
| Student information | `lib/features/infor/`, `lib/core/services_root/sqlite/infomationStudent/` | Student profile fetch/cache/display. | `lib/features/infor/*`, `lib/config/config_DB.dart` |
| Notifications/data changes | `lib/features/notification/`, `lib/core/services_root/notification/` | Portal notifications, local notifications, data-change detection, background sync. | `lib/features/notification/services/background_sync_service.dart`, `lib/config/config_DB.dart` |
| Chat | `lib/features/chat/`, `lib/core/services_root/supabase/` | Supabase users, conversations, messages, realtime subscriptions, chat notifications. | `lib/features/chat/services/chat_service.dart`, `test/chat_service_test.dart` |
| AI assistant | `lib/features/ai_assistant/` | Gemini chat dialog and optional notification context. | `lib/features/ai_assistant/controllers/controller_ai.dart` |
| QR code | `lib/features/qr_code/` | QR scanning screen. | `lib/features/qr_code/screens/view_qr_code.dart` |

## Documentation Map
| Path | Content | Evidence |
|---|---|---|
| `README.md` | Product overview, setup, configuration, test command, roadmap. | `README.md` |
| `docs/repository-audit.md` | Existing verified facts, cleanup notes, verification notes. | `docs/repository-audit.md` |
| `docs/github-metadata.md` | Suggested GitHub description/topics. | `docs/github-metadata.md` |
| `docs/github-profile-improvements.md` | Prior repository cleanup summary and verification notes. | `docs/github-profile-improvements.md` |
| `docs/base/` | Excel DD templates and Vietnamese DD guidance. | `docs/base/*` |
| `docs/auth/` | Auth DD Excel documents. | `docs/auth/*` |

## Testing Map
| Test area | Current evidence | Evidence |
|---|---|---|
| Unit tests | `generateConversationId` tests for stable ordering and empty participant rejection. | `test/chat_service_test.dart` |
| Test command | `flutter test`. | `README.md` |
| Analyzer | Flutter lints included. | `analysis_options.yaml` |
| Coverage gaps | README states automated coverage is minimal. | `README.md` |

## Configuration Key Names Only
| Key | Mechanism | Purpose | Evidence |
|---|---|---|---|
| `GEMINI_API_KEY` | `String.fromEnvironment`, `--dart-define` | Enables AI assistant. | `.env.example`, `README.md`, `lib/core/constants/api/api_daotao.dart` |
| `SUPABASE_URL` | `String.fromEnvironment`, `--dart-define` | Supabase project URL. | `.env.example`, `README.md`, `lib/core/constants/api/supabase_key.dart` |
| `SUPABASE_ANON_KEY` | `String.fromEnvironment`, `--dart-define` | Supabase anonymous client key. | `.env.example`, `README.md`, `lib/core/constants/api/supabase_key.dart` |

## Known Architecture Constraints
| Constraint | Evidence |
|---|---|
| Feature-first Flutter structure with shared core utilities; not strict Clean Architecture. | `README.md`, `docs/repository-audit.md`, `lib/features/*`, `lib/core/*` |
| SQLite schema is created in code through `openDatabase`; no separate migration directory is present. | `lib/config/config_DB.dart`, `rg --files` discovery |
| Supabase schema is referenced from Dart table names, but no repo-owned SQL schema was found. | `lib/features/chat/services/chat_service.dart`, `rg --files docs lib` |
| Several visible UI actions and teacher role path are placeholders or not wired to completed flows. | `lib/features/auth/student/screens/role_view.dart`, `lib/features/home/study_view/screens/study_view.dart`, `docs/repository-audit.md` |
| Client app requires Supabase configuration at startup; missing keys throw before `runApp`. | `lib/main.dart`, `lib/core/services_root/supabase/supabase_config.dart` |
