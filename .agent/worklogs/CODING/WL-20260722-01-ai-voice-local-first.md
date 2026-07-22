# WL-20260722-01 — AI voice local-first security

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` AI_ASSISTANT, LOCAL_FIRST_SECURITY
- `PATTERN:` sqlite-local-first-slice
- `TAGS:` ai, voice, sqlcipher, secure-storage, cache
- `REF:` `docs/checklists/coding/CODING-AI-VOICE-LOCAL-FIRST-20260722.md`

## CURRENT
- Implement Vietnamese voice AI and encrypted owner-scoped local persistence.

## CHANGED
- Secure session storage and SQLCipher owner-scoped databases replace the SQLite credential session source.
- Read API registry, snapshot cache, typed AI classifier/context/navigation contracts, and voice UI/FAB were added.
- Android/iOS speech declarations and implementation/docs were updated.

## NOTE
- Cache fallback is read-only; AI receives only local allowlisted academic context. Legacy `auth.db` remains isolated.

## TASK SPLIT
- [x] Secure local persistence and session storage
- [x] AI text/voice/navigation flow
- [x] Focused analyzer and full test suite
- [ ] Real-device/release SQLCipher and voice smoke test (Android release build exceeded the 120s workspace limit; iOS requires macOS/device)
- [ ] Supabase realtime cache integration after schema/RLS contract is supplied

## NEXT
1. Run Android and iOS real-device release smoke tests.
2. Add chat local repository wiring when the Supabase contract is available.
