# BUG-APP-20260703 — Prevent black screen during startup

- `STATUS:` FIXED
- `SCOPE:` Application startup
- `REF:` `AGENTS.md`, `lib/main.dart`, `.agent/architecture/audit.md`
- `PATTERN:` Startup dependency blocks first Flutter frame
- `TAGS:` startup, black-screen, supabase, workmanager, notifications

## BUG
- `SYMPTOM:` The app can remain on a black screen at launch because startup services run before the first Flutter frame.
- `EXPECTED:` The loading, offline, login, or home UI must render even when optional chat, notification, or background-sync setup is unavailable.
- `REPRO:` Run without Supabase Dart defines or trigger an exception in a startup integration before `runApp()`.

## CONTEXT
- The chat feature uses Supabase, but the academic-login flow and offline screen must remain usable without chat configuration.
- Existing notification and WorkManager setup is preserved and now runs after the UI is mounted.

## FINDING
- `CAUSE:` `main()` awaited notification, WorkManager, and Supabase setup before calling `runApp()`. Missing Supabase configuration explicitly threw a `StateError`, preventing Flutter from rendering any screen.
- `AFFECT:` App launch on builds that omit Supabase configuration or encounter a native startup-service failure.

## FIX
- [x] `lib/main.dart` — Render `MaterialApp` first; execute optional startup services in guarded background steps.
- [x] `lib/core/services_root/supabase/supabase_config.dart` — Treat absent Supabase Dart defines as chat unavailable instead of a startup-fatal error; make initialization reusable and concurrency-safe.
- [x] `lib/app.dart` — Guard startup state resolution and initialize chat only after Supabase is ready.
- [x] `lib/features/auth/student/controllers/ctrl_login_Student.dart` — Keep successful VNUA login independent from optional chat initialization.
- [ ] Add/update regression test — Not added because this startup path depends on Flutter/native plugins and the current environment has no Flutter SDK.

## CHECK
- [x] Reproduce before fix — Static trace confirms `SupabaseConfig.init()` could throw before `runApp()`.
- [x] Verify fixed flow — Static check confirms `runApp()` executes before every optional service call and each startup step catches failures.
- [x] Verify negative/edge case — Missing Supabase configuration now returns `false`, skips chat setup, and leaves the app usable.
- [ ] Regression: run on Android/iOS with and without Supabase Dart defines — Requires a local Flutter SDK/device or emulator.

## RESULT
- `FIXED:` Optional startup failures no longer block the first Flutter frame; chat becomes unavailable rather than preventing the app from opening.
- `BLOCKED:` Runtime build/test was not executed because `flutter` is not installed in the current environment.
- `RISK:` Chat screens still require valid Supabase configuration; they should be exercised manually after the startup fix.

## HANDOFF
- `NEXT:` Run `flutter pub get`, `flutter analyze`, `flutter test`, then launch with and without Supabase Dart defines.
- `READ:` `lib/main.dart`
- `SKILL:` NO — first recorded BUG worklog for this pattern.
