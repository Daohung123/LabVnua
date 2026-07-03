# DD TASK - Todo và đầu việc

- `STATUS:` DONE
- `MODULE_CODE:` TASK
- `MODULE_NAME:` Todo và đầu việc
- `TECHNICAL_NAME:` task_todo
- `RELEASE_SCOPE:` MVP + Sprint 2/3
- `SOURCE_BD:` `docs/BD/BasicDesign_LearningApp.md` - BD section 7, rows 21-23
- `TEMPLATE:` `.agent/dd/module-dd-instruction.md` approved with `cases/` extension
- `LANGUAGE:` Tiếng Việt

## Mục đích

Quản lý todo online/offline, nộp bài/giao bài/tạo báo cáo và kế hoạch học tập.

## Cấu trúc package

| File / thư mục | Vai trò |
|---|---|
| README.md | Tổng quan package và danh sách case |
| Overall.md | Goals, boundary, rules, data, integrations, risks, traceability |
| List_Features.md | Feature inventory và mô tả từng feature |
| Function_List.md | Function/use case, I/O, permission, validation, side effects |
| Views.md | View inventory, UI states và action mapping |
| Import_File.md | Mapping source path, imports, contracts, config keys, test mapping |
| cases/ | Case-level DD cho từng dòng ưu tiên BD |
| diagrams/ | Evidence-only diagram notes |
| assets/ | Evidence-only asset notes |
| history/ | Lịch sử tài liệu |

## Case inventory

| Case ID | Tên case | Ưu tiên | File |
|---|---|---|---|
| TASK-CASE-21 | Todo online và offline | P0 - MVP | cases/TASK-CASE-21-todo-online-va-offline.md |
| TASK-CASE-22 | Nộp bài / giao bài / tạo báo cáo | P1 | cases/TASK-CASE-22-nop-bai-giao-bai-tao-bao-cao.md |
| TASK-CASE-23 | Kế hoạch học tập | P1 | cases/TASK-CASE-23-ke-hoach-hoc-tap.md |

## Evidence

- `docs/BD/BasicDesign_LearningApp.md`
- `.agent/dd/module-dd-instruction.md`
- `.agent/architecture/overview.md`
- `.agent/architecture/flutter-app.md`
- `.agent/api/index.md`
- `.agent/database/overview.md`

## Safety

- Tài liệu này không xác nhận toàn bộ chức năng đã implement.
- Không ghi secret values, token, password, connection string hoặc PII sản xuất.
