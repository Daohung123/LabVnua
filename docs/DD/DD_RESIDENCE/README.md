# DD RESIDENCE - Đăng ký tạm trú / tạm vắng

- `STATUS:` DONE
- `MODULE_CODE:` RESIDENCE
- `MODULE_NAME:` Đăng ký tạm trú / tạm vắng
- `TECHNICAL_NAME:` residence_registration
- `RELEASE_SCOPE:` Later / P2
- `SOURCE_BD:` `docs/BD/BasicDesign_LearningApp.md` - BD section 9, row 25
- `TEMPLATE:` `.agent/dd/module-dd-instruction.md` approved with `cases/` extension
- `LANGUAGE:` Tiếng Việt

## Mục đích

Sinh viên đăng ký tạm trú/tạm vắng, xuất đơn có QR để công an/chủ nhà xác minh.

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
| RESIDENCE-CASE-25 | Đăng ký tạm trú / tạm vắng và QR | P2 | cases/RESIDENCE-CASE-25-dang-ky-tam-tru-tam-vang-va-qr.md |

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
