# AUTH-CASE-03 - Avatar dropdown gồm logout và cài đặt

- `STATUS:` Draft DD v0.1
- `MODULE:` AUTH - Xác thực và tài khoản
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 2.2, 3.5
- `FEATURE:` AUTH-F03
- `FUNCTION:` AUTH-FN03
- `VIEW:` AUTH-V03
- `ROLES:` Người dùng đã đăng nhập

## Mục tiêu

Avatar dropdown gồm logout và cài đặt được thiết kế như một case riêng trong module `AUTH` và trace trực tiếp tới bảng ưu tiên BD dòng 3.

## Entry point

Ấn avatar ở header

## Luồng chính

- Mở dropdown
- Hiển thị thông tin/cài đặt/đổi mật khẩu/logout
- Logout về login

## Dữ liệu / API / state

- Tên hiển thị
- Ảnh đại diện
- Session active

Tích hợp liên quan:

- AUTH-API01: VNied/VNUA auth
- AUTH-API02: email/password fallback
- AUTH-API03: SQLite session restore

## UI / component

- View chính: AUTH-V03.
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

- Menu đúng vị trí
- Logout kết thúc session
- Mục chưa có màn hình phải disabled hoặc ghi rõ

## Test scenarios

- Menu mở/đóng
- logout/relogin
- profile thiếu ảnh

## Open questions / risks

- AUTH-RISK01
- AUTH-RISK02
- AUTH-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 3 |
| Case | AUTH-CASE-03 |
| Feature | AUTH-F03 |
| Function | AUTH-FN03 |
| View | AUTH-V03 |
| Source | BD 2.2, 3.5 |
