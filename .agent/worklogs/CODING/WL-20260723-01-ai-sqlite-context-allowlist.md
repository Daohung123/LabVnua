# WL-20260723-01 — AI SQLite context allowlist

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` AI_ASSISTANT, LOCAL_FIRST_SECURITY
- `PATTERN:` sqlite-local-first-slice
- `TAGS:` ai, sqlite, privacy, allowlist, context
- `REF:` `docs/checklists/coding/CODING-AI-VOICE-LOCAL-FIRST-20260722.md`

## CURRENT

- Allow the AI assistant to read only approved academic projections from the encrypted, owner-scoped SQLite database.

## CHANGED

- Added a fixed read-only SQLite reader for score, tuition, and Todo projections; it maps known fields and ignores malformed cache rows.
- Extended AI context assembly to include those projections only after the typed context registry permits their key.
- Wrapped every local section as untrusted reference data, normalized text, surfaced available freshness timestamps, and stated when the requested cache has not synced.
- Added unit coverage for projection fields, malformed rows, timestamps, allowlist enforcement, and non-SQLite read denial.

## NOTE

- The encrypted database is selected by the authenticated owner hash before the reader opens it. The reader never accesses raw snapshots, chat cache, profile/contact data, AI turns, session data, credentials, or audio.
- Tuition keeps all approved fields for every cached tuition row. Other projections have fixed context limits to keep prompts bounded.

## TASK SPLIT

- [x] Implement read-only typed local projections.
- [x] Gate every read behind the context allowlist and injection boundary.
- [x] Run scoped analyzer, focused tests, and full test suite.
- [ ] Smoke-test questions about scores, tuition, and Todo through Gemini/STT/TTS on Android and iOS hardware.

## NEXT

1. On an authenticated physical device with synced data, ask by text and voice about scores, tuition, and Todo; confirm the response and TTS use the local projection.
2. Keep any future AI context key in `AiContextRegistry` and add a typed projection plus privacy test before enabling it.
