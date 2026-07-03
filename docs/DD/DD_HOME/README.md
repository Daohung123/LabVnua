# DD HOME - Trang chủ

- `STATUS:` DONE
- `MODULE_CODE:` HOME
- `MODULE_NAME:` Trang chủ
- `TECHNICAL_NAME:` home_dashboard
- `RELEASE_SCOPE:` MVP + Sprint 2
- `SOURCE_BD:` `docs/BD/BasicDesign_LearningApp.md` - BD section 3, rows 4-8
- `TEMPLATE:` `.agent/dd/module-dd-instruction.md` approved with `cases/` extension
- `LANGUAGE:` Tiếng Việt

## Mục đích

Tổng hợp lịch, deadline, thông báo/quảng cáo và lối tắt tự cấu hình trên màn hình đầu sau đăng nhập.

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
| HOME-CASE-04 | Trang chủ: lịch thay phần chào mừng | P0 - MVP | cases/HOME-CASE-04-trang-chu-lich-thay-phan-chao-mung.md |
| HOME-CASE-05 | Thời khóa biểu hiển thị ngang | P0 - MVP | cases/HOME-CASE-05-thoi-khoa-bieu-hien-thi-ngang.md |
| HOME-CASE-06 | Deadline phần 2 | P0 - MVP | cases/HOME-CASE-06-deadline-phan-2.md |
| HOME-CASE-07 | Lối tắt tự cấu hình thay tổng quan nhanh | P0 - MVP | cases/HOME-CASE-07-loi-tat-tu-cau-hinh-thay-tong-quan-nhanh.md |
| HOME-CASE-08 | Thông báo và quảng cáo phần 3 | P1 | cases/HOME-CASE-08-thong-bao-va-quang-cao-phan-3.md |

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
