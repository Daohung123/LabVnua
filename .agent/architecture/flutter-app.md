# Flutter App Architecture

## Root and Responsibility
- Root: `lib/`
- Responsibility: Flutter client for VNUA students with authentication, academic data screens, notifications, chat, QR scanning, and AI assistant.

Evidence: `README.md`, `pubspec.yaml`, `lib/main.dart`

## Folder Structure
| Path | Responsibility | Evidence |
|---|---|---|
| `lib/main.dart` | Startup bootstrap and `runApp`. | `lib/main.dart` |
| `lib/app.dart` | Connectivity and login-state routing. | `lib/app.dart` |
| `lib/config/` | Database config, HTTP override, sync helper. | `lib/config/config_db.dart`, `lib/config/http_override.dart`, `lib/config/sync_data.dart` |
| `lib/core/constants/` | API constants, UI strings/assets/colors/sizes. | `lib/core/constants/api/api_daotao.dart`, `lib/core/constants/readme_constants.txt` |
| `lib/core/services_root/` | Shared API, SQLite, notification, and Supabase services. | `lib/core/services_root/*` |
| `lib/core/theme/` | Centralized design tokens and reusable theme components. | `lib/core/theme/README.md`, `lib/core/theme/app_theme.dart` |
| `lib/core/widgets/` | Legacy and shared widgets. | `lib/core/widgets/README.md` |
| `lib/features/` | Feature-first modules with screens, controllers, services, models, widgets, repositories. | `README.md`, `lib/features/*` |
| `assets/` | App images/icons loaded through Flutter asset config. | `pubspec.yaml`, `assets/*` |
| `test/` | Automated Flutter tests. | `test/chat_service_test.dart` |

## Entry Points
- `main()` in `lib/main.dart`
- `MyWidget` in `lib/app.dart`
- `HomeScreen` in `lib/features/home/home_screen/screens/student_home_screen_view.dart`

Evidence: `lib/main.dart`, `lib/app.dart`, `lib/features/home/home_screen/screens/student_home_screen_view.dart`

## Technology and Dependencies
- Flutter SDK and Dart SDK `^3.9.2`.
- Notable packages: `http`, `sqflite`, `supabase_flutter`, `google_generative_ai`, `flutter_local_notifications`, `workmanager`, `mobile_scanner`, `connectivity_plus`, `intl`, `crypto`.

Evidence: `pubspec.yaml`

## Runtime Flow
1. Startup initializes platform services and external config.
2. Connectivity gate runs before login check.
3. Session restore calls VNUA login flow using locally stored session fields.
4. Authenticated user enters tab shell with student home, study, chat, other, and settings.
5. Background sync watches academic data changes and can emit local notifications.
6. Chat uses Supabase database operations and realtime channels.

Evidence: `lib/main.dart`, `lib/app.dart`, `lib/features/auth/student/controllers/ctrl_login_student.dart`, `lib/features/home/home_screen/screens/student_home_screen_view.dart`, `lib/features/notification/services/background_sync_service.dart`, `lib/features/chat/services/chat_service.dart`

## Dependency Direction
- Feature UI should prefer feature-local controllers/services/models and shared core services.
- Shared UI should prefer `lib/core/theme/app_components.dart` for new theme-based components.
- `lib/core/widgets/README.md` marks most legacy widgets as deprecated in favor of `lib/core/theme/app_components.dart`.

Evidence: `lib/core/theme/README.md`, `lib/core/widgets/README.md`

## Module Boundaries
- Academic features call VNUA portal API wrappers and map responses into feature models.
- Chat feature owns Supabase chat models, repository, service, realtime connection, and widgets.
- Notification feature owns data-change detection, background sync, notification screens, and local notification orchestration.
- AI assistant feature owns Gemini prompt construction and dialog UI.

Evidence: `lib/features/course_register/*`, `lib/features/chat/*`, `lib/features/notification/*`, `lib/features/ai_assistant/*`

## Testing Location
- Tests live in `test/`.
- Current test file: `test/chat_service_test.dart`.

Evidence: `test/chat_service_test.dart`

## Key Commands
- `flutter pub get`
- `flutter run --dart-define=GEMINI_API_KEY=... --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...`
- `flutter test`
- `flutter analyze`

Evidence: `README.md`, `analysis_options.yaml`

## Important Constraints
- Do not copy secret values into docs or logs.
- Do not assume all visible menu entries are completed features.
- Do not assume Supabase schema details beyond table names and fields directly referenced in Dart.
- Preserve Vietnamese user-facing copy unless a task explicitly changes localization/content.

Evidence: `.env.example`, `docs/repository-audit.md`, `lib/features/home/study_view/screens/study_view.dart`, `lib/features/chat/services/chat_service.dart`
