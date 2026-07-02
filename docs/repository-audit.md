# Repository Audit

## Verified Project Facts

- `pubspec.yaml` identifies the package as `aqedu`, version `1.0.0+1`, using Dart SDK `^3.9.2`.
- The app is a Flutter project with Android, iOS, and web platform folders.
- The app entry point initializes notifications, background sync, Supabase, connectivity checks, and then renders `MyWidget`.
- Student login is implemented through VNUA training portal API calls and stores a session model locally.
- Implemented feature folders include authentication, student home, schedule, score data, tuition, course registration, training program, prerequisite subjects, personal information, notifications, AI assistant, realtime chat, and QR code scanning.
- SQLite is used for local session, schedule, information, notification, and data-change storage.
- Supabase is used for realtime chat users, conversations, messages, and subscriptions.
- The AI assistant uses the Google Generative AI SDK and can include notification data from local SQLite when the prompt is notification-related.
- `flutter_local_notifications` and `workmanager` are used for local notification channels and periodic background sync.
- `mobile_scanner` is used by the QR scanner screen.

## Not Enough Evidence For Public README Claims

- Production readiness, store release, deployed demo, active user counts, or uptime.
- A completed teacher workflow. The role selector shows a teacher option, but only the student path is wired to the login flow.
- Completed campus utilities, attendance result, exam schedule, online tuition payment, survey, feedback, and support features where handlers are empty or not wired.
- Clean Architecture as a strict architecture claim. The repository is feature-first with controllers/services/models, but not a fully evidenced Clean Architecture implementation.
- Real screenshots. Existing assets are app images/logos/icons, not verified screenshots.

## Files Or Content To Clean

- `README.md`: contained Flutter template text, personal rename notes, hard reset commands, and `scrcpy`; replace completely.
- `fixlog.txt`: one-line personal fix note, unreferenced by source; remove from public repository.
- `test/test_project.dart`: empty tracked file that is not picked up by Flutter test discovery; replace with a real `*_test.dart` file.
- `EduAI.md`: untracked internal draft with broad claims; leave untouched but do not publish as-is without verifying each claim.
- `lib/core/constants/api/api_daotao.dart`: contained a hardcoded Gemini API key; move to compile-time configuration.
- `lib/core/constants/api/supabase_key.dart`: contained Supabase client values; move to compile-time configuration.
- `pubspec.lock`: already modified before this task; leave untouched to avoid mixing unrelated dependency changes.

## Planned Changes

- Replace `README.md` with a concise English portfolio README based on verified code.
- Add GitHub metadata and profile improvement notes under `docs/`.
- Add `.env.example` with empty keys only.
- Update `.gitignore` to ignore real local environment files while allowing `.env.example`.
- Update `pubspec.yaml` description from the Flutter template text to a project-specific description.
- Add a minimal test file so `flutter test` has a valid `*_test.dart` target.
- Run formatting and verification commands, then record any remaining baseline issues.
