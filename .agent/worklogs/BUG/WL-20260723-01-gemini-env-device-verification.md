# WL-20260723-01 — Gemini `.env` device verification

- `STATUS:` DONE
- `TYPE:` BUG
- `SCOPE:` AI_ASSISTANT, APP_CONFIGURATION
- `PATTERN:` missing-compile-time-launch-argument
- `TAGS:` gemini, env, android, device, dart-define
- `REF:` `docs/checklists/bug/BUG-AI-20260722-gemini-env-launch.md`

## CURRENT

- Verify that the actual Android application receives the local compile-time Gemini configuration and can complete an AI request.

## CHANGED

- Rebuilt the debug APK with the local define file and installed it over the existing debug app without uninstalling or clearing data.
- No source change was required: the configuration path and checked-in launch profile already matched the expected compile-time contract.

## NOTE

- The non-secret compile-time assertion passed, and a harmless live Gemini request passed on the connected Android device.
- The primary configured model returned a temporary service failure and the existing fallback model completed both classification and response. This does not indicate a missing or rejected API key.

## TASK SPLIT

- [x] Verify `.env` syntax/presence without reading its secret value.
- [x] Verify compile-time propagation into `AppEnvironment` and `GeminiAiDataSource`.
- [x] Build, install, and verify a real Android AI request with `.env`.

## NEXT

1. Use `AQEdu (.env)` in VS Code, or the documented Android Studio/terminal define argument, for every fresh app launch.
2. If a future run reports a gateway failure after configuration is present, diagnose the key restrictions, quota, selected model, or network separately.
