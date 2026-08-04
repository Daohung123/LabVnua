# WL-20260723-02 - Gemini runtime dotenv configuration

- `STATUS:` DONE
- `TYPE:` BUG
- `SCOPE:` AI_ASSISTANT, APP_CONFIGURATION
- `PATTERN:` missing-runtime-env-asset
- `TAGS:` gemini, env, flutter_dotenv, android, device
- `REF:` `docs/checklists/bug/BUG-AI-20260722-gemini-env-launch.md`

## CURRENT

- Fix the AI assistant configuration bubble on Android debug builds that are not launched with `--dart-define-from-file=.env`.

## CHANGED

- Added `flutter_dotenv: ^6.0.1` and registered `.env` as a Flutter asset.
- Loaded `.env` before `runApp`, then routed Gemini and Supabase config through `AppEnvironment`.
- Kept Dart defines as fallback for existing CI/build flows and updated the AI configuration message.
- Updated README and agent config notes from compile-time-only to runtime `.env` plus fallback.

## CHECK

- Scoped analyzer passed for touched config, Supabase, AI datasource, and env tests.
- Focused env/repository tests passed, full `flutter test` passed, and the optional live Gemini smoke passed using runtime `.env`.
- Android `220333QPG` was tested with a debug APK built without `.env` dart-define; an AI prompt reached Gemini and produced an answer without the missing-config event.

## NEXT

1. Keep `.env` local and ignored; do not commit real client keys.
2. Restrict Gemini client keys for mobile use or move production AI calls behind a backend proxy.
