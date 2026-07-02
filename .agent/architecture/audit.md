# Architecture Audit

## ARCH-ISSUE-01 - Global TLS certificate validation override
- `SEVERITY:` HIGH
- `EVIDENCE:` `lib/config/http_override.dart` - `badCertificateCallback` returns `true` for all certificates.
- `IMPACT:` The app can accept invalid TLS certificates globally, increasing man-in-the-middle risk.
- `RECOMMENDATION:` Replace the global override with a scoped, documented certificate strategy or remove it after validating the VNUA endpoint behavior.
- `STATUS:` OPEN

## ARCH-ISSUE-02 - Sensitive session fields stored in SQLite
- `SEVERITY:` HIGH
- `EVIDENCE:` `lib/config/config_DB.dart` - `session` table includes `user`, `pass`, `cookie`, and `token` columns.
- `IMPACT:` Local database compromise may expose credentials or active session material.
- `RECOMMENDATION:` Review whether password persistence is required; consider secure storage and token-only refresh behavior.
- `STATUS:` OPEN

## ARCH-ISSUE-03 - Supabase config can block app startup
- `SEVERITY:` MEDIUM
- `EVIDENCE:` `lib/main.dart` calls `SupabaseConfig.init()` before `runApp`; `lib/core/services_root/supabase/supabase_config.dart` throws when config keys are absent.
- `IMPACT:` Missing Supabase config can prevent even non-chat screens from rendering.
- `RECOMMENDATION:` Decide whether chat should be optional at startup; if yes, handle missing config with a disabled chat state.
- `STATUS:` OPEN

## ARCH-ISSUE-04 - Broad debug logging of API data and errors
- `SEVERITY:` MEDIUM
- `EVIDENCE:` `lib/core/services_root/api_daotao/*` and `lib/features/*/services/*` contain many `print` or `debugPrint` calls, including response bodies and errors.
- `IMPACT:` Runtime logs may expose student data, session state symptoms, or API payloads and make production diagnostics noisy.
- `RECOMMENDATION:` Introduce a safe logging policy that redacts sensitive fields and removes response-body logging outside debug builds.
- `STATUS:` OPEN

## ARCH-ISSUE-05 - Visible placeholder role and study actions
- `SEVERITY:` LOW
- `EVIDENCE:` `lib/features/auth/student/screens/role_view.dart` routes only `Sinh vien` to login and logs other roles; `lib/features/home/study_view/screens/study_view.dart` includes multiple `onTap: () {}` actions.
- `IMPACT:` Users may see options that do not perform completed behavior.
- `RECOMMENDATION:` Either wire the flows, hide the entries, or route them to an explicit coming-soon view with product approval.
- `STATUS:` OPEN

## ARCH-ISSUE-06 - Notification service uses copied filename and encoded-space import
- `SEVERITY:` LOW
- `EVIDENCE:` `lib/features/notification/services/service_sql_notification_student.dart` imports `service_api_notification_student%20copy.dart`.
- `IMPACT:` Encoded filenames make imports brittle and obscure source ownership.
- `RECOMMENDATION:` Rename and update imports in a dedicated cleanup task after verifying behavior.
- `STATUS:` OPEN

## ARCH-ISSUE-07 - Session count check compares query result object to zero
- `SEVERITY:` MEDIUM
- `EVIDENCE:` `lib/core/services_root/sqlite/sessions/core_service_session.dart` compares `rawQuery` result object with `0` in `checkLogin`.
- `IMPACT:` The check can report a session exists based on the result object rather than the returned count value.
- `RECOMMENDATION:` Parse the SQL count value with `Sqflite.firstIntValue` or equivalent and add a regression test.
- `STATUS:` OPEN
