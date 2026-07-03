# AUTH-CASE-01 - Làm lại giao diện đăng nhập và logo

- `STATUS:` Draft DD v0.1
- `MODULE:` AUTH - Xác thực và tài khoản
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 2.1
- `FEATURE:` AUTH-F01
- `FUNCTION:` AUTH-FN01
- `VIEW:` AUTH-V01
- `ROLES:` Sinh viên, Giảng viên

## Mục tiêu

Làm lại giao diện đăng nhập và logo được thiết kế như một case riêng trong module `AUTH` và trace trực tiếp tới bảng ưu tiên BD dòng 1.

## Entry point

Mở app khi chưa có session hợp lệ

## Luồng chính

- Hiển thị login đơn giản
- Hiển thị logo
- Submit phương thức login

## Dữ liệu / API / state

- Logo/asset
- Trạng thái form
- Session hiện có

Tích hợp liên quan:

- AUTH-API01: VNied/VNUA auth
- AUTH-API02: email/password fallback
- AUTH-API03: SQLite session restore

## UI / component

- View chính: AUTH-V01.
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

- Login UI không còn role thủ công
- Logo ổn định trên mobile
- Có loading/error state

## Test scenarios

- UI rỗng/loading/lỗi
- Layout mobile nhỏ/lớn

## Open questions / risks

- AUTH-RISK01
- AUTH-RISK02
- AUTH-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 1 |
| Case | AUTH-CASE-01 |
| Feature | AUTH-F01 |
| Function | AUTH-FN01 |
| View | AUTH-V01 |
| Source | BD 2.1 |
