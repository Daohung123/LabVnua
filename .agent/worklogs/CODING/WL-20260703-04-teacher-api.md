# WL-20260703-04 - Teacher API Foundation

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` TEACHER_API
- `PATTERN:` source-backed-teacher-api-foundation
- `TAGS:` teacher, api, model-parser, service, tests
- `REF:` `docs/checklists/coding/CODING-TEACHER-API-20260703.md`

## CURRENT

- Added source-backed teacher API foundation from `.agent/api/api_vnua.md`.
- Implemented only constants, response models, service calls, and parser tests.

## CHANGED

- Added teacher endpoint constants for profile, functions, and notifications.
- Added teacher profile, function list, nested mobile title, and notification response models with safe defaults.
- Added a thin teacher API service using `ApiHelper.withSession` and returning `null` for invalid, failed, null-data, or HTML responses.
- Added focused parser tests for teacher profile, functions, notifications, and missing/null defaults.

## NOTE

- Did not change login routing, teacher UI, attendance roster/export, database schema, migrations, dependencies, runtime config, or DD source files.
- Endpoint 4 in `.agent/api/api_vnua.md` was intentionally not implemented because its response sample is not reliable.
- Teacher role source, post-login route, and attendance roster/export contracts remain unresolved.

## VERIFICATION

- `flutter test test\teacher_api_models_test.dart` passed.
- Scoped `flutter analyze` over teacher API files and test passed.

## TASK SPLIT

- `[x]` Read `AGENTS.md` and classify task as `CODING`.
- `[x]` Load teacher API source, coding workflow/rules, checklist, and relevant API patterns.
- `[x]` Implement teacher API constants, models, service, and parser tests.
- `[x]` Run focused verification.
- `[x]` Update checklist, progress checklist, worklog, and skill counter.

## NEXT

1. Resolve teacher role source and post-login routing before building teacher UI.
2. Resolve attendance roster/export backend before implementing teacher absence list.
3. Add service-level tests if `ApiHelper` becomes injectable through an interface.
