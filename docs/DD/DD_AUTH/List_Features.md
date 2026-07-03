# List Features - Xác thực và tài khoản

## Inventory

| Feature | Tên | Priority | Rules | Function | View | Case |
|---|---|---|---|---|---|---|
| AUTH-F01 | Làm lại giao diện đăng nhập và logo | P0 - MVP | AUTH-BR01, AUTH-BR02, AUTH-BR03 | AUTH-FN01 | AUTH-V01 | AUTH-CASE-01 |
| AUTH-F02 | Bỏ chọn role, thêm đăng nhập VNied | P0 - MVP | AUTH-BR01, AUTH-BR02, AUTH-BR03 | AUTH-FN02 | AUTH-V02 | AUTH-CASE-02 |
| AUTH-F03 | Avatar dropdown gồm logout và cài đặt | P0 - MVP | AUTH-BR01, AUTH-BR02, AUTH-BR03 | AUTH-FN03 | AUTH-V03 | AUTH-CASE-03 |

## Dependencies

- AUTH-API01: VNied/VNUA auth
- AUTH-API02: email/password fallback
- AUTH-API03: SQLite session restore
- lib/features/auth/student/screens/student_login_view.dart
- lib/features/auth/student/screens/role_view.dart
- lib/features/auth/student/controllers/ctrl_login_Student.dart
- lib/core/services_root/api_daotao/auth/checkLogin.dart
- lib/core/services_root/api_daotao/auth/reLogin.dart
- lib/core/services_root/sqlite/sessions/core_service_session.dart
- lib/config/config_DB.dart
- lib/features/home/home_view/components/home_app_bar.dart

## AUTH-F01 - Làm lại giao diện đăng nhập và logo

- `Case:` AUTH-CASE-01
- `Priority:` P0 - MVP
- `Source:` BD 2.1
- `Roles:` Sinh viên, Giảng viên
- `Function:` AUTH-FN01
- `View:` AUTH-V01

### Happy flow

- Hiển thị login đơn giản
- Hiển thị logo
- Submit phương thức login

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Login UI không còn role thủ công
- Logo ổn định trên mobile
- Có loading/error state

### Tests

- UI rỗng/loading/lỗi
- Layout mobile nhỏ/lớn

### Risks / open questions

- AUTH-RISK01
- AUTH-RISK02
- AUTH-RISK03

## AUTH-F02 - Bỏ chọn role, thêm đăng nhập VNied

- `Case:` AUTH-CASE-02
- `Priority:` P0 - MVP
- `Source:` BD 2.1
- `Roles:` Sinh viên, Giảng viên
- `Function:` AUTH-FN02
- `View:` AUTH-V02

### Happy flow

- Ẩn control chọn role
- Xác thực VNied
- Lưu session và route theo role

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Login không cần chọn role
- SV/GV đi đúng route
- Thiếu role không crash

### Tests

- VNied happy path
- fallback email/password
- role thiếu/lạ

### Risks / open questions

- AUTH-RISK01
- AUTH-RISK02
- AUTH-RISK03

## AUTH-F03 - Avatar dropdown gồm logout và cài đặt

- `Case:` AUTH-CASE-03
- `Priority:` P0 - MVP
- `Source:` BD 2.2, 3.5
- `Roles:` Người dùng đã đăng nhập
- `Function:` AUTH-FN03
- `View:` AUTH-V03

### Happy flow

- Mở dropdown
- Hiển thị thông tin/cài đặt/đổi mật khẩu/logout
- Logout về login

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Menu đúng vị trí
- Logout kết thúc session
- Mục chưa có màn hình phải disabled hoặc ghi rõ

### Tests

- Menu mở/đóng
- logout/relogin
- profile thiếu ảnh

### Risks / open questions

- AUTH-RISK01
- AUTH-RISK02
- AUTH-RISK03
