# AUTH-CASE-02 - Bỏ chọn role, thêm đăng nhập VNied

- `STATUS:` Draft DD v0.1
- `MODULE:` AUTH - Xác thực và tài khoản
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 2.1
- `FEATURE:` AUTH-F02
- `FUNCTION:` AUTH-FN02
- `VIEW:` AUTH-V02
- `ROLES:` Sinh viên, Giảng viên

## Mục tiêu

Bỏ chọn role, thêm đăng nhập VNied được thiết kế như một case riêng trong module `AUTH` và trace trực tiếp tới bảng ưu tiên BD dòng 2.

## Entry point

Từ LoginScreen chọn VNied hoặc email/password

## Luồng chính

- Ẩn control chọn role
- Xác thực VNied
- Lưu session và route theo role

## Dữ liệu / API / state

- Access token/cookie
- Role
- Profile
- Thời hạn token

Tích hợp liên quan:

- AUTH-API01: VNied/VNUA auth
- AUTH-API02: email/password fallback
- AUTH-API03: SQLite session restore

## UI / component

- View chính: AUTH-V02.
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

- Login không cần chọn role
- SV/GV đi đúng route
- Thiếu role không crash

## Test scenarios

- VNied happy path
- fallback email/password
- role thiếu/lạ

## Open questions / risks

- AUTH-RISK01
- AUTH-RISK02
- AUTH-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 2 |
| Case | AUTH-CASE-02 |
| Feature | AUTH-F02 |
| Function | AUTH-FN02 |
| View | AUTH-V02 |
| Source | BD 2.1 |
