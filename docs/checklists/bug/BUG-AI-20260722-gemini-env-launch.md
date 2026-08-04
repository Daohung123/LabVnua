# BUG-AI-20260722 — Gemini key not compiled from `.env`

- `STATUS:` VERIFIED
- `SCOPE:` AI_ASSISTANT, APP_CONFIGURATION
- `REF:` `docs/BD/AI_fisrt.md`
- `PATTERN:` missing-compile-time-launch-argument
- `TAGS:` gemini, env, dart-define, vscode, launch

## BUG

- `SYMPTOM:` AI reports that Gemini is not configured although the local `.env` contains a key.
- `EXPECTED:` A run or build launched with the project `.env` passes the non-empty key and model to `GeminiAiDataSource`.
- `REPRO:` Update `.env`, then use an IDE default Run/F5 action or an older APK that was built without `--dart-define-from-file=.env`.

## CONTEXT

- `.env` is deliberately a compile-time Flutter define, not a runtime asset.
- No key value, raw define, or build output containing a credential is recorded here.

## FINDING

- `CAUSE:` The repository had no checked-in IDE launch configuration passing the define. Dart defines are fixed at compilation, so hot reload/restart and a previously built APK cannot receive a later `.env` edit.
- `AFFECT:` VS Code/IDE launch behavior, Android/iOS build commands, and the AI configuration error message.

## FIX

- [x] `.vscode/launch.json` — add the `AQEdu (.env)` Flutter launch configuration with `--dart-define-from-file=.env`.
- [x] `README.md` — document full rerun behavior and Android Studio additional run args.
- [x] `gemini_ai_data_source.dart` — show an actionable compile-time configuration recovery message.
- [x] `app_environment_test.dart` — add a non-secret opt-in assertion that verifies a local `.env` was compiled into a test run.

## CHECK

- [x] Verify local `.env` format and key/model presence without printing values.
- [x] Verify the opt-in compile-time assertion with `--dart-define-from-file=.env`.
- [x] Regression: scoped analyzer and full `flutter test --dart-define-from-file=.env` pass.
- [x] Regression: Android release build with `.env` passes with build output redacted.
- [x] Android device verification: install a newly built debug APK with `.env`, submit a harmless AI request, and confirm the request/response phases complete without the missing-configuration event.

## RESULT

- `FIXED:` A supported VS Code F5 path now includes the `.env` define; terminal/Android Studio instructions and the UI message explain the required full rebuild. A newly installed Android debug build was also verified to reach Gemini successfully.
- `BLOCKED:` -
- `RISK:` Android Studio users must still set the documented Additional run args. The configured primary model returned a temporary service error during device verification, but the configured fallback answered successfully; that is a model/service condition, not a missing-key condition.

## HANDOFF

- `NEXT:` Stop any old app process and rerun from the project root so runtime `.env` is loaded; Dart defines remain an optional fallback.
- `READ:` `lib/core/config/app_environment.dart`, `.vscode/launch.json`
- `SKILL:` NO — one verified configuration-launch incident is not enough evidence for a reusable skill.

## FOLLOW-UP 2026-07-23 — Runtime `.env` Load

- `SYMPTOM:` A debug APK built without `--dart-define-from-file=.env` still showed the missing `GEMINI_API_KEY`/`GEMINI_MODEL` AI bubble on a real Android device.
- `CAUSE:` The app only read Gemini config from compile-time defines, so a normal debug build had no runtime path to the local `.env`.
- `FIXED:` Added `flutter_dotenv: ^6.0.1`, registered `.env` as a Flutter asset, loaded it before `runApp`, and centralized Gemini/Supabase config in `AppEnvironment` with Dart-define fallback.
- [x] `flutter pub get`
- [x] `flutter analyze` scoped to touched config/AI files
- [x] `flutter test test/app_environment_test.dart test/gemini_ai_repository_test.dart test/gemini_live_smoke_test.dart`
- [x] `flutter test test/gemini_live_smoke_test.dart --dart-define=RUN_LIVE_GEMINI_SMOKE=true`
- [x] `flutter test`
- [x] Android `220333QPG`: build debug APK without `.env` dart-define, install over existing app data, submit an AI prompt, and confirm Gemini request/response logs complete without the missing-config event.
- `RISK:` `.env` is bundled as a mobile asset; values remain client-side config and must not be treated as durable secrets.
