# WL-20260722-03 — AI voice and Gemini configuration reliability

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` AI_ASSISTANT, APP_CONFIGURATION
- `PATTERN:` typed-voice-gateway-reliability
- `TAGS:` ai, voice, stt, tts, gemini, env, timeout
- `REF:` `docs/checklists/coding/CODING-AI-VOICE-LOCAL-FIRST-20260722.md`

## CURRENT

- Restore the Vietnamese STT → AI response flow and make Gemini configuration explicit and safe.

## CHANGED

- Final speech transcripts now render, auto-submit once, and always clear processing state through `try/catch/finally`.
- STT forwards status and asynchronous errors to Vietnamese UI state; Stop submits the latest non-empty transcript.
- Gemini uses compile-time `.env` defines, a configurable model, typed configuration/service/timeout failures, and safe phase logging.
- Voice navigation waits for TTS completion; a manual action is exposed only if TTS cannot complete.

## CHECK

- Scoped analyzer, focused voice/Gemini tests, and full `flutter test --dart-define-from-file=.env` passed.
- Android `flutter build apk --release --dart-define-from-file=.env` passed.

## NEXT

1. On Android and iOS hardware, verify microphone permission, installed `vi-VN` recognition/voice, transcript visibility, actual Gemini response, and SQLCipher open/logout behavior.
2. Keep the local `.env` secret-free in source control; production needs restricted credentials or a backend proxy.
