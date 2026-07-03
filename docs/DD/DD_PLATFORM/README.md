# DD PLATFORM - Kỹ thuật và hạ tầng

- `STATUS:` DONE
- `MODULE_CODE:` PLATFORM
- `MODULE_NAME:` Kỹ thuật và hạ tầng
- `TECHNICAL_NAME:` platform_infrastructure
- `RELEASE_SCOPE:` MVP + Sprint 2/3
- `SOURCE_BD:` `docs/BD/BasicDesign_LearningApp.md` - BD sections 10.1, 10.2, rows 26-27
- `TEMPLATE:` `.agent/dd/module-dd-instruction.md` approved with `cases/` extension
- `LANGUAGE:` Tiếng Việt

## Mục đích

Nền tảng offline SQLite, đồng bộ khi có mạng và analytics hành vi người dùng.

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
| PLATFORM-CASE-26 | Lưu SQLite offline | P0 - MVP | cases/PLATFORM-CASE-26-luu-sqlite-offline.md |
| PLATFORM-CASE-27 | Analytics hành vi người dùng | P1 | cases/PLATFORM-CASE-27-analytics-hanh-vi-nguoi-dung.md |

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
