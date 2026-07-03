# PLATFORM-CASE-27 - Analytics hành vi người dùng

- `STATUS:` Draft DD v0.1
- `MODULE:` PLATFORM - Kỹ thuật và hạ tầng
- `PRIORITY:` P1
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 10.2
- `FEATURE:` PLATFORM-F02
- `FUNCTION:` PLATFORM-FN02
- `VIEW:` PLATFORM-V02
- `ROLES:` Hệ thống, Nhà trường / Quản trị

## Mục tiêu

Analytics hành vi người dùng được thiết kế như một case riêng trong module `PLATFORM` và trace trực tiếp tới bảng ưu tiên BD dòng 27.

## Entry point

Người dùng thao tác chức năng

## Luồng chính

- Ghi event ẩn danh
- Tổng hợp theo role/thời gian
- Dùng cho shortcut/roadmap

## Dữ liệu / API / state

- Anonymous event
- Role
- Feature name
- Timestamp
- Aggregation

Tích hợp liên quan:

- PLATFORM-API01: SQLite
- PLATFORM-API02: Workmanager
- PLATFORM-API03: Connectivity
- PLATFORM-API04: analytics backend

## UI / component

- View chính: PLATFORM-V02.
- UI phải có loading, empty, error, permission denied và success state khi phù hợp.
- Copy hiển thị bằng tiếng Việt, bám terminology trong BD.

## Validation và permission

- Roles được phép: Hệ thống, Nhà trường / Quản trị.
- Kiểm tra dữ liệu bắt buộc trước khi submit.
- Kiểm tra quyền truy cập entity theo user/session hiện tại.
- Không gửi request hoặc ghi local state khi validation fail.

## Error handling

- Lỗi network/service hiển thị message an toàn.
- Thiếu contract phải được giữ ở `OPEN_QUESTION`, không hard-code behavior nghiệp vụ.
- Không log token, password, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.

## Acceptance criteria

- Không lưu PII
- Có policy PDPA trước khi bật

## Test scenarios

- Event không PII
- opt-out/disabled
- aggregate dashboard

## Open questions / risks

- PLATFORM-RISK01
- PLATFORM-RISK02
- PLATFORM-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 27 |
| Case | PLATFORM-CASE-27 |
| Feature | PLATFORM-F02 |
| Function | PLATFORM-FN02 |
| View | PLATFORM-V02 |
| Source | BD 10.2 |
