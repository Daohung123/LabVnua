# HOME-CASE-04 - Trang chủ: lịch thay phần chào mừng

- `STATUS:` Draft DD v0.1
- `MODULE:` HOME - Trang chủ
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 3.1
- `FEATURE:` HOME-F01
- `FUNCTION:` HOME-FN01
- `VIEW:` HOME-V01
- `ROLES:` Sinh viên, Giảng viên

## Mục tiêu

Trang chủ: lịch thay phần chào mừng được thiết kế như một case riêng trong module `HOME` và trace trực tiếp tới bảng ưu tiên BD dòng 4.

## Entry point

Vào tab Home

## Luồng chính

- Tải ngày hiện tại
- Lấy lịch theo role
- Render khối lịch

## Dữ liệu / API / state

- Ngày hiện tại
- Danh sách tiết học/giảng dạy/họp
- Role

Tích hợp liên quan:

- HOME-API01: VNUA schedule
- HOME-API02: notification/cache
- HOME-API03: analytics event source

## UI / component

- View chính: HOME-V01.
- UI phải có loading, empty, error, permission denied và success state khi phù hợp.
- Copy hiển thị bằng tiếng Việt, bám terminology trong BD.

## Validation và permission

- Roles được phép: Sinh viên, Giảng viên.
- Kiểm tra dữ liệu bắt buộc trước khi submit.
- Kiểm tra quyền truy cập entity theo user/session hiện tại.
- Không gửi request hoặc ghi local state khi validation fail.

## Error handling

- Lỗi network/service hiển thị message an toàn.
- Thiếu contract phải được giữ ở `OPEN_QUESTION`, không hard-code behavior nghiệp vụ.
- Không log token, password, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.

## Acceptance criteria

- Home ưu tiên lịch trong ngày
- Không có lịch có empty state

## Test scenarios

- Có lịch hôm nay
- không có lịch
- lỗi tải lịch

## Open questions / risks

- HOME-RISK01
- HOME-RISK02
- HOME-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 4 |
| Case | HOME-CASE-04 |
| Feature | HOME-F01 |
| Function | HOME-FN01 |
| View | HOME-V01 |
| Source | BD 3.1 |
