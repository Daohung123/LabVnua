# CREATE_DD-ALL-20260703 - LearningApp Markdown Module DD Packages

- `STATUS:` DONE
- `SCOPE:` LearningApp all BD modules
- `REF:` `docs/BD/BasicDesign_LearningApp.md`
- `TEMPLATE:` `.agent/dd/module-dd-instruction.md` + approved `cases/` extension from user plan
- `PATTERN:` bd-to-markdown-module-dd-packages
- `TAGS:` detail-design, markdown, learning-app, module-dd, traceability

## GOAL
- [x] Create Markdown DD packages under `docs/DD/` for all modules and all 30 cases from the Basic Design priority table.

## SOURCES
- [x] `AGENTS.md` - repository agent workflow and handoff rules.
- [x] `.agent/tasks/create-dd/workflow.md` - CREATE_DD workflow.
- [x] `.agent/tasks/create-dd/rules.md` - CREATE_DD rules and open questions.
- [x] `.agent/dd/module-dd-instruction.md` - approved module DD structure for this task.
- [x] `.agent/architecture/overview.md` - architecture evidence.
- [x] `.agent/architecture/flutter-app.md` - Flutter feature-first evidence.
- [x] `.agent/api/index.md` - integration boundaries and contract gaps.
- [x] `.agent/database/overview.md` - SQLite/local persistence evidence.
- [x] `.agent/api/internal.md` - internal service boundaries.
- [x] `.agent/api/external.md` - external integration notes.
- [x] `.agent/database/schema.md` - local schema evidence.
- [x] `.agent/database/migrations.md` - migration evidence.
- [x] `docs/BD/BasicDesign_LearningApp.md` - Basic Design source.

## PLAN
- [x] Identify module and scope.
- [x] Extract requirements and traceability from BD rows 1-30.
- [x] Fill the approved Markdown module DD structure.
- [x] Add case-level DD files under each module `cases/` directory.
- [x] Record OPEN_QUESTION items for unknown contracts and source gaps.
- [x] Run DD quality gate.

## OUTPUT
- [x] `docs/DD/DD_AUTH/` - Xác thực và tài khoản DD package; BD cases 1, 2, 3.
- [x] `docs/DD/DD_HOME/` - Trang chủ DD package; BD cases 4, 5, 6, 7, 8.
- [x] `docs/DD/DD_CLASS_SESSION/` - Buổi học DD package; BD cases 9, 10, 11, 12, 13, 16, 17, 28, 29, 30.
- [x] `docs/DD/DD_ATTENDANCE/` - Điểm danh DD package; BD cases 14, 15.
- [x] `docs/DD/DD_AI_ASSISTANT/` - AI trợ lý DD package; BD cases 18, 19, 20.
- [x] `docs/DD/DD_TASK/` - Todo và đầu việc DD package; BD cases 21, 22, 23.
- [x] `docs/DD/DD_LEARNING_PORTAL/` - Cổng học tập DD package; BD cases 24.
- [x] `docs/DD/DD_RESIDENCE/` - Đăng ký tạm trú / tạm vắng DD package; BD cases 25.
- [x] `docs/DD/DD_PLATFORM/` - Kỹ thuật và hạ tầng DD package; BD cases 26, 27.
- [x] `docs/checklists/create-dd/CREATE_DD-ALL-20260703-learningapp-module-dd.md` - this checklist.
- [x] `.agent/worklogs/CREATE_DD/WL-20260703-01-learningapp-module-dd.md` - compact worklog.
- [x] `.agent/skills/index.md` - CREATE_DD counter incremented after worklog.

## RESULT
- `DONE:` Created 9 Markdown module DD packages and 30 case-level DD files from the Basic Design.
- `BLOCKED:` -
- `OPEN_QUESTION:` Contract/source gaps are recorded in each module `Overall.md` and affected case files.

## QUALITY GATE
- [x] Required module files exist for all 9 packages.
- [x] `cases/` includes all BD case rows 1-30.
- [x] Feature/function/view/case IDs are defined and traceable.
- [x] Unknown API/schema/security/business contracts are marked `OPEN_QUESTION`.
- [x] No secret values, token values, passwords, connection strings or production PII copied.
- [x] App source, runtime configuration, migrations, dependencies and DD Excel files unchanged.
- [x] Markdown files are UTF-8 and use Vietnamese content consistent with BD.

## HANDOFF
- `NEXT:` Review module open questions before implementation, especially authorization, public API, STT, analytics, deep link and schema contracts.
- `READ:` `docs/DD/DD_AUTH/README.md`, then the target module package.
- `SKILL:` NO - this is the second CREATE_DD worklog; not enough evidence for a reusable skill.
