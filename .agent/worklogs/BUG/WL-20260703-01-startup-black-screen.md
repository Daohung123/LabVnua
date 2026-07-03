# WL-20260703-01 — prevent startup black screen

- `STATUS:` DONE
- `TYPE:` BUG
- `SCOPE:` Application startup
- `PATTERN:` Optional integration blocks first Flutter frame
- `TAGS:` startup, black-screen, supabase, workmanager, notifications
- `REF:` `docs/checklists/bug/BUG-APP-20260703-startup-black-screen.md`

## CURRENT
- Keep the app renderable when optional Supabase, notification, or background-sync initialization cannot complete.

## CHANGED
- `lib/main.dart` — Rendered the app before optional startup work and isolated each service failure.
- `lib/core/services_root/supabase/supabase_config.dart` — Made missing Supabase configuration non-fatal and initialization safe to reuse.
- `lib/app.dart` — Added protected startup state resolution and guarded chat startup.
- `lib/features/auth/student/controllers/ctrl_login_Student.dart` — Decoupled successful VNUA login from chat initialization.

## NOTE
- Chat remains optional at application launch; valid Supabase Dart defines are still required to use chat.
- The runtime verification commands must be run on a machine that has Flutter installed.

## TASK SPLIT
- [x] Read BUG workflow, project map, architecture, and startup source.
- [x] Identify the first-frame blocker and apply scoped changes.
- [x] Record checklist and handoff.
- [ ] Run Flutter analyzer, tests, and device launch verification.

## NEXT
1. Run analyzer/tests and launch without Supabase Dart defines.
2. Launch with valid Supabase Dart defines and verify chat initialization after login.
