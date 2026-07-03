# DD LEARNING_PORTAL - Cổng học tập

- `STATUS:` DONE
- `MODULE_CODE:` LEARNING_PORTAL
- `MODULE_NAME:` Cổng học tập
- `TECHNICAL_NAME:` learning_portal
- `RELEASE_SCOPE:` Sprint 2/3
- `SOURCE_BD:` `docs/BD/BasicDesign_LearningApp.md` - BD section 8, row 24
- `TEMPLATE:` `.agent/dd/module-dd-instruction.md` approved with `cases/` extension
- `LANGUAGE:` Tiếng Việt

## Mục đích

Cổng tra cứu môn học với thống kê hoàn thành/đang học/trượt, search và filter.

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
| LEARNING_PORTAL-CASE-24 | Cổng học tập: bỏ tiêu đề, thêm thống kê và search | P1 | cases/LEARNING_PORTAL-CASE-24-cong-hoc-tap-bo-tieu-de-them-thong-ke-va-search.md |

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
