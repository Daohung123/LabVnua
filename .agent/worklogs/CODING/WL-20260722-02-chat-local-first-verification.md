# WL-20260722-02 — Chat local-first verification

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` CHAT_CACHE, AI_ASSISTANT
- `PATTERN:` sqlite-local-first-slice
- `TAGS:` chat, realtime, sqlite, voice, release
- `REF:` `docs/checklists/coding/CODING-AI-VOICE-LOCAL-FIRST-20260722.md`

## CURRENT
- Complete remaining local-first cache and verification work.

## CHANGED
- Chat repository now persists remote/realtime thread/message results then emits a re-read of owner-scoped SQLite.
- Remote failures retain local reads; sending remains online-only with no outbox.
- Added tests for typed AI actions, voice TTS ordering/failure fallback, and Chat local-first behavior.

## NOTE
- Existing Dart Chat models define only local serialization; Supabase schema/RLS remains an external contract to verify before production rollout.

## TASK SPLIT
- [x] Realtime-to-local Chat cache wiring
- [x] AI/voice/cache automated tests
- [x] Android release APK build
- [ ] Real-device Android/iOS SQLCipher and voice smoke test

## NEXT
1. Verify SQLCipher open/logout/account-switch and Vietnamese STT/TTS on Android and iOS hardware.
2. Confirm Supabase RLS behavior in the target environment.
