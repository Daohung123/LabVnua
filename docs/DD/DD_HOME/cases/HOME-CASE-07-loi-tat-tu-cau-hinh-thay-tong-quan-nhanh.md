# HOME-CASE-07 - Lối tắt tự cấu hình thay tổng quan nhanh

- `STATUS:` Draft DD v0.1
- `MODULE:` HOME - Trang chủ
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 3.4
- `FEATURE:` HOME-F04
- `FUNCTION:` HOME-FN04
- `VIEW:` HOME-V04
- `ROLES:` Người dùng đã đăng nhập

## Mục tiêu

Lối tắt tự cấu hình thay tổng quan nhanh được thiết kế như một case riêng trong module `HOME` và trace trực tiếp tới bảng ưu tiên BD dòng 7.

## Entry point

Khối lối tắt trên Home

## Luồng chính

- Hiển thị grid 2 x N
- Vào chế độ chỉnh sửa
- Thêm/xóa/sắp xếp trong giới hạn

## Dữ liệu / API / state

- Danh sách shortcut
- Thứ tự
- Cấu hình theo user

Tích hợp liên quan:

- HOME-API01: VNUA schedule
- HOME-API02: notification/cache
- HOME-API03: analytics event source

## UI / component

- View chính: HOME-V04.
- UI phải có loading, empty, error, permission denied và success state khi phù hợp.
- Copy hiển thị bằng tiếng Việt, bám terminology trong BD.

## Validation và permission

- Roles được phép: Người dùng đã đăng nhập.
- Kiểm tra dữ liệu bắt buộc trước khi submit.
- Kiểm tra quyền truy cập entity theo user/session hiện tại.
- Không gửi request hoặc ghi local state khi validation fail.

## Error handling

- Lỗi network/service hiển thị message an toàn.
- Thiếu contract phải được giữ ở `OPEN_QUESTION`, không hard-code behavior nghiệp vụ.
- Không log token, password, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.

## Acceptance criteria

- Grid không vượt giới hạn
- Cấu hình được lưu hoặc ghi open question

## Test scenarios

- Thêm
- xóa
- reorder
- vượt giới hạn

## Open questions / risks

- HOME-RISK01
- HOME-RISK02
- HOME-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 7 |
| Case | HOME-CASE-07 |
| Feature | HOME-F04 |
| Function | HOME-FN04 |
| View | HOME-V04 |
| Source | BD 3.4 |
