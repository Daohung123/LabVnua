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

## RESULT

- `FIXED:` A supported VS Code F5 path now includes the `.env` define; terminal/Android Studio instructions and the UI message explain the required full rebuild.
- `BLOCKED:` -
- `RISK:` Android Studio users must still set the documented Additional run args. Actual Gemini service access also depends on a valid, permitted key and network/device availability.

## HANDOFF

- `NEXT:` Stop any old app process, select `AQEdu (.env)` in VS Code or rerun from the project root, then install the rebuilt APK if testing release.
- `READ:` `.vscode/launch.json`
- `SKILL:` NO — one verified configuration-launch incident is not enough evidence for a reusable skill.
