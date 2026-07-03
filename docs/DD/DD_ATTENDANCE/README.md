# DD ATTENDANCE - Điểm danh

- `STATUS:` DONE
- `MODULE_CODE:` ATTENDANCE
- `MODULE_NAME:` Điểm danh
- `TECHNICAL_NAME:` attendance
- `RELEASE_SCOPE:` MVP
- `SOURCE_BD:` `docs/BD/BasicDesign_LearningApp.md` - BD section 5, rows 14-15
- `TEMPLATE:` `.agent/dd/module-dd-instruction.md` approved with `cases/` extension
- `LANGUAGE:` Tiếng Việt

## Mục đích

Điểm danh bằng QR cá nhân, danh sách vắng và báo cáo theo buổi/tuần/tháng.

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
| ATTENDANCE-CASE-14 | Điểm danh QR cá nhân | P0 - MVP | cases/ATTENDANCE-CASE-14-diem-danh-qr-ca-nhan.md |
| ATTENDANCE-CASE-15 | Xem danh sách vắng cho giảng viên | P0 - MVP | cases/ATTENDANCE-CASE-15-xem-danh-sach-vang-cho-giang-vien.md |

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
