# Architecture Overview

## Shape
LabVnua is a Flutter application package named `aqedu`. The app targets mobile and web platform folders and is branded in the Android manifest as `EduAI`.

Evidence: `pubspec.yaml`, `README.md`, `android/app/src/main/AndroidManifest.xml`, `web/manifest.json`

## Runtime Flow
1. `lib/main.dart` initializes Flutter bindings, installs a global HTTP override, initializes notifications, registers Workmanager background sync, initializes Supabase, starts an immediate background sync, and calls `runApp`.
2. `lib/app.dart` checks connectivity using `connectivity_plus`.
3. If offline, the app shows `NoWifiScreen`.
4. If online, the app checks the stored session and attempts login restore.
5. Authenticated users enter `HomeScreen`; unauthenticated users enter `RoleView`.

Evidence: `lib/main.dart`, `lib/app.dart`

## Dependency Direction
- User-facing modules live under `lib/features/`.
- Shared constants, theme, widgets, screens, API wrappers, SQLite services, notification utilities, and Supabase setup live under `lib/core/` and `lib/config/`.
- Features call shared core services and their own services/controllers/models.
- There is no repo evidence for a strict layered architecture with enforced boundaries.

Evidence: `README.md`, `lib/features/*`, `lib/core/*`, `docs/repository-audit.md`

## Data and Integrations
- Local persistence uses SQLite through `sqflite`; schema creation is centralized in `lib/config/config_DB.dart`.
- VNUA portal API calls use `http` through `ApiHelper` and endpoint constants.
- Supabase is used for chat users, conversations, messages, and realtime subscriptions.
- Gemini is used by the AI assistant through `google_generative_ai`.
- Workmanager and local notifications support background data-change checks.

Evidence: `pubspec.yaml`, `lib/config/config_DB.dart`, `lib/core/services_root/api_daotao/root_daotao/daotao_post_get.dart`, `lib/features/chat/services/chat_service.dart`, `lib/features/ai_assistant/controllers/controller_ai.dart`, `lib/features/notification/services/background_sync_service.dart`

## Verification Strategy
- Current automated coverage is minimal and focused on a pure chat helper.
- Use `flutter test` for regression checks and `flutter analyze` for analyzer/lint checks.

Evidence: `README.md`, `test/chat_service_test.dart`, `analysis_options.yaml`

## OPEN_QUESTION
- `OPEN_QUESTION-ARCH-01:` There is no repo-owned Supabase SQL schema or migration source, so table constraints, policies, indexes, and RLS behavior are not verified.
- `OPEN_QUESTION-ARCH-02:` The approved production architecture target is not documented beyond feature-first Flutter organization.
