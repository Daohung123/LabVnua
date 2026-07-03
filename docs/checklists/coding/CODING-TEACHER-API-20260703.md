# CODING-TEACHER-API-20260703

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` TEACHER_API
- `PATTERN:` source-backed-teacher-api-foundation
- `DATE:` 2026-07-03

## Sources

- `AGENTS.md`
- `.agent/api/api_vnua.md`
- `.agent/worklogs/CODING/WL-20260703-03-dd-progress-checklist.md`
- `docs/checklists/checklist_features.md`
- `lib/core/services_root/api_daotao/root_daotao/daotao_post_get.dart`

## Acceptance

- [x] Add teacher API endpoint constants for profile, functions, and notifications.
- [x] Add teacher API response models with safe defaults for missing optional fields.
- [x] Add a thin teacher API service using `ApiHelper.withSession`.
- [x] Do not change login routing, teacher UI, attendance, database schema, or migrations.
- [x] Add focused parser tests.
- [x] Run focused tests.
- [x] Run scoped analyzer if feasible.

## Verification

- [x] `flutter test test\teacher_api_models_test.dart`
- [x] `flutter analyze lib\core\constants\api\api_daotao_teacher.dart lib\features\teacher\models\teacher_api_models.dart lib\features\teacher\services\teacher_api_service.dart test\teacher_api_models_test.dart`

## OPEN_QUESTION

- `OPEN_QUESTION-TEACHER-API-01:` Teacher login role source and post-login routing remain unresolved.
- `OPEN_QUESTION-TEACHER-API-02:` Teacher attendance roster/export backend contract remains unresolved.

## Notes

- Endpoint 4 in `.agent/api/api_vnua.md` is intentionally not implemented because its response sample duplicates notification shape.
