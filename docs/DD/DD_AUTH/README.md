# DD AUTH - Xác thực và tài khoản

- `STATUS:` DONE
- `MODULE_CODE:` AUTH
- `MODULE_NAME:` Xác thực và tài khoản
- `TECHNICAL_NAME:` auth_account
- `RELEASE_SCOPE:` MVP
- `SOURCE_BD:` `docs/BD/BasicDesign_LearningApp.md` - BD sections 2, 3.5, rows 1-3
- `TEMPLATE:` `.agent/dd/module-dd-instruction.md` approved with `cases/` extension
- `LANGUAGE:` Tiếng Việt

## Mục đích

Đăng nhập tập trung, tự động phân role, quản lý tài khoản qua avatar/header.

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
| AUTH-CASE-01 | Làm lại giao diện đăng nhập và logo | P0 - MVP | cases/AUTH-CASE-01-lam-lai-giao-dien-dang-nhap-va-logo.md |
| AUTH-CASE-02 | Bỏ chọn role, thêm đăng nhập VNied | P0 - MVP | cases/AUTH-CASE-02-bo-chon-role-them-dang-nhap-vnied.md |
| AUTH-CASE-03 | Avatar dropdown gồm logout và cài đặt | P0 - MVP | cases/AUTH-CASE-03-avatar-dropdown-gom-logout-va-cai-dat.md |

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
