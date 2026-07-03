# Overall - Trang chủ

## Metadata

| Hạng mục | Nội dung |
|---|---|
| Dự án | Learning Management App |
| Module | Trang chủ |
| Module code | HOME |
| Technical name | home_dashboard |
| Phiên bản DD | v0.1 |
| Ngày tạo | 2026-07-03 |
| Nguồn | docs/BD/BasicDesign_LearningApp.md - BD section 3, rows 4-8 |
| Template | .agent/dd/module-dd-instruction.md |
| Phạm vi release | MVP + Sprint 2 |

## Goals

- Triển khai thiết kế chi tiết cho module `HOME` từ Basic Design.
- Giữ traceability từ feature/function/view/case tới BD.
- Đánh dấu rõ contract chưa có source bằng `OPEN_QUESTION`.

## Non-goals

- Không sửa app source, runtime config, migrations hoặc dependencies.
- Không tự định nghĩa API/schema/security contract chưa được phê duyệt.
- Không coi behavior trong DD là đã implement nếu code evidence chưa tồn tại.

## Boundary và ownership

- Module này thuộc package `DD_HOME` dưới `docs/DD/`.
- Implement sau nên theo feature-first Flutter: `lib/features/` cho feature UI/controller/service, `lib/core/` cho shared services, `lib/config/` cho database/config.
- Các public contract hoặc schema chưa có nguồn phải được giải quyết trước khi code.

## Actors và permissions

- Sinh viên
- Giảng viên

## Context

Tổng hợp lịch, deadline, thông báo/quảng cáo và lối tắt tự cấu hình trên màn hình đầu sau đăng nhập.

## Feature index

| Feature ID | Feature | Function | View | Case |
|---|---|---|---|---|
| HOME-F01 | Trang chủ: lịch thay phần chào mừng | HOME-FN01 | HOME-V01 | HOME-CASE-04 |
| HOME-F02 | Thời khóa biểu hiển thị ngang | HOME-FN02 | HOME-V02 | HOME-CASE-05 |
| HOME-F03 | Deadline phần 2 | HOME-FN03 | HOME-V03 | HOME-CASE-06 |
| HOME-F04 | Lối tắt tự cấu hình thay tổng quan nhanh | HOME-FN04 | HOME-V04 | HOME-CASE-07 |
| HOME-F05 | Thông báo và quảng cáo phần 3 | HOME-FN05 | HOME-V05 | HOME-CASE-08 |

## Flows

| Case | Flow |
|---|---|
| HOME-CASE-04 | Tải ngày hiện tại -> Lấy lịch theo role -> Render khối lịch |
| HOME-CASE-05 | Sắp xếp theo thời gian -> Render ngang -> Click tới chi tiết buổi học |
| HOME-CASE-06 | Lấy deadline -> Sắp xếp hạn gần nhất -> Click vào nộp bài/đầu việc |
| HOME-CASE-07 | Hiển thị grid 2 x N -> Vào chế độ chỉnh sửa -> Thêm/xóa/sắp xếp trong giới hạn |
| HOME-CASE-08 | Lấy thông báo -> Lấy quảng cáo nếu có nguồn -> Click chi tiết |

## States

- Đang tải
- Có dữ liệu
- Không có lịch
- Không có deadline
- Offline có cache
- Lỗi tải

## Business rules

- HOME-BR01: Lịch ngày hiện tại thay phần chào mừng
- HOME-BR02: Deadline dưới 24 giờ highlight
- HOME-BR03: Không có lịch họp thì không render
- HOME-BR04: Shortcut tối đa 8-10 ô

## Data

- HOME-E-schedule: lịch học/giảng dạy
- HOME-E-deadline: deadline
- HOME-E-notification: thông báo
- HOME-E-shortcut: cấu hình lối tắt

## Integrations

- HOME-API01: VNUA schedule
- HOME-API02: notification/cache
- HOME-API03: analytics event source

## Non-functional requirements

- Security: không log secret/token/password/PII sản xuất; kiểm tra role và scope dữ liệu.
- Resilience: UI có loading, empty, error, offline và success state khi phù hợp.
- Traceability: mọi feature/function/view/case link tới ID và source BD.
- Documentation: unknowns phải ghi `OPEN_QUESTION`, không dùng dữ liệu giả như thật.

## Risks và open questions

| ID | Nội dung |
|---|---|
| HOME-RISK01 | OPEN_QUESTION - Chưa có source deadline/nộp bài chính thức |
| HOME-RISK02 | OPEN_QUESTION - Analytics gợi ý shortcut chưa có contract |
| HOME-RISK03 | OPEN_QUESTION - Nguồn quảng cáo/sự kiện chưa xác định |

## ADR

- HOME-ADR01: Dùng Markdown module DD theo `.agent/dd/module-dd-instruction.md` và extension `cases/` đã được user phê duyệt.
- HOME-ADR02: Dùng source evidence trong BD/agent docs, không tự tạo contract API/schema.

## Traceability

| BD row | Case | Feature | Function | View |
|---|---|---|---|---|
| 4 | HOME-CASE-04 | HOME-F01 | HOME-FN01 | HOME-V01 |
| 5 | HOME-CASE-05 | HOME-F02 | HOME-FN02 | HOME-V02 |
| 6 | HOME-CASE-06 | HOME-F03 | HOME-FN03 | HOME-V03 |
| 7 | HOME-CASE-07 | HOME-F04 | HOME-FN04 | HOME-V04 |
| 8 | HOME-CASE-08 | HOME-F05 | HOME-FN05 | HOME-V05 |

## Approval

- Trạng thái: Draft DD v0.1.
- Điều kiện implement: review và xử lý các `OPEN_QUESTION` ảnh hưởng đến API, authorization, schema, bảo mật và business rule.
