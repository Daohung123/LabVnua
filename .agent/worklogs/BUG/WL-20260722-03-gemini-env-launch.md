# WL-20260722-03 — Gemini `.env` launch fix

- `STATUS:` DONE
- `TYPE:` BUG
- `SCOPE:` AI_ASSISTANT, APP_CONFIGURATION
- `PATTERN:` missing-compile-time-launch-argument
- `TAGS:` gemini, env, dart-define, launch
- `REF:` `docs/checklists/bug/BUG-AI-20260722-gemini-env-launch.md`

## CURRENT

- Ensure a configured local Gemini key reaches the compiled Flutter app without exposing the key.

## CHANGED

- Added the checked-in VS Code `AQEdu (.env)` launch profile and clarified Android Studio/terminal launch requirements.
- Improved the missing-config response so it explains that a complete rerun with `.env` is required.
- Added a safe opt-in compile-time test assertion; it verifies presence only and never logs a credential.

## CHECK

- Current local `.env` was verified as syntactically valid and compiled into the targeted test run without printing its value.
- Scoped analyzer, full test suite, and Android release build with `.env` passed.

## NEXT

1. Stop the old application process and launch via `AQEdu (.env)` or the documented terminal command.
2. On a device, verify a real Gemini request with the permitted local key; diagnose service errors separately from missing compile-time configuration.
