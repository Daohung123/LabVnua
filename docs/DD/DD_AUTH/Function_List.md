# Function List - Xác thực và tài khoản

## Project dependency direction

- UI thuộc `lib/features/`; shared service thuộc `lib/core/`; database config thuộc `lib/config/`.
- DD này không thay đổi source code hoặc schema.
- External API contract chưa có source phải ghi `OPEN_QUESTION` trước khi implement.

## Function inventory

| Function | Tên | Input chính | Output chính | Case |
|---|---|---|---|---|
| AUTH-FN01 | Làm lại giao diện đăng nhập và logo | Logo/asset; Trạng thái form; Session hiện có | UI state / persisted state / navigation result | AUTH-CASE-01 |
| AUTH-FN02 | Bỏ chọn role, thêm đăng nhập VNied | Access token/cookie; Role; Profile; Thời hạn token | UI state / persisted state / navigation result | AUTH-CASE-02 |
| AUTH-FN03 | Avatar dropdown gồm logout và cài đặt | Tên hiển thị; Ảnh đại diện; Session active | UI state / persisted state / navigation result | AUTH-CASE-03 |

## AUTH-FN01 - Làm lại giao diện đăng nhập và logo

- `Case:` AUTH-CASE-01
- `Feature:` AUTH-F01
- `View:` AUTH-V01
- `Entry:` Mở app khi chưa có session hợp lệ

### Input

- Logo/asset
- Trạng thái form
- Session hiện có

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Sinh viên, Giảng viên.
- Function phải kiểm tra role trước action, không chỉ dựa vào ẩn UI.

### Validation

- Kiểm tra dữ liệu bắt buộc trước khi gọi service.
- Kiểm tra entity thuộc phạm vi user/session hiện tại.
- Contract chưa rõ phải ghi `OPEN_QUESTION`.

### Transaction / side effects

- Ghi local hoặc gọi API phải có loading và xử lý failure.
- Không thực hiện destructive action khi thiếu xác nhận nghiệp vụ.
- Offline sync cần ghi nhận pending/conflict state.

### Security

- Không log credential, token, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.
- Chỉ ghi config key names, không ghi secret values.

### Imports / dependencies

- lib/features/auth/student/screens/student_login_view.dart
- lib/features/auth/student/screens/role_view.dart
- lib/features/auth/student/controllers/ctrl_login_student.dart
- lib/core/services_root/api_daotao/auth/check_login.dart
- lib/core/services_root/api_daotao/auth/re_login.dart
- lib/core/services_root/sqlite/sessions/core_service_session.dart
- lib/config/config_db.dart
- lib/features/home/home_view/components/home_app_bar.dart

### Tests

- UI rỗng/loading/lỗi
- Layout mobile nhỏ/lớn

## AUTH-FN02 - Bỏ chọn role, thêm đăng nhập VNied

- `Case:` AUTH-CASE-02
- `Feature:` AUTH-F02
- `View:` AUTH-V02
- `Entry:` Từ LoginScreen chọn VNied hoặc email/password

### Input

- Access token/cookie
- Role
- Profile
- Thời hạn token

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Sinh viên, Giảng viên.
- Function phải kiểm tra role trước action, không chỉ dựa vào ẩn UI.

### Validation

- Kiểm tra dữ liệu bắt buộc trước khi gọi service.
- Kiểm tra entity thuộc phạm vi user/session hiện tại.
- Contract chưa rõ phải ghi `OPEN_QUESTION`.

### Transaction / side effects

- Ghi local hoặc gọi API phải có loading và xử lý failure.
- Không thực hiện destructive action khi thiếu xác nhận nghiệp vụ.
- Offline sync cần ghi nhận pending/conflict state.

### Security

- Không log credential, token, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.
- Chỉ ghi config key names, không ghi secret values.

### Imports / dependencies

- lib/features/auth/student/screens/student_login_view.dart
- lib/features/auth/student/screens/role_view.dart
- lib/features/auth/student/controllers/ctrl_login_student.dart
- lib/core/services_root/api_daotao/auth/check_login.dart
- lib/core/services_root/api_daotao/auth/re_login.dart
- lib/core/services_root/sqlite/sessions/core_service_session.dart
- lib/config/config_db.dart
- lib/features/home/home_view/components/home_app_bar.dart

### Tests

- VNied happy path
- fallback email/password
- role thiếu/lạ

## AUTH-FN03 - Avatar dropdown gồm logout và cài đặt

- `Case:` AUTH-CASE-03
- `Feature:` AUTH-F03
- `View:` AUTH-V03
- `Entry:` Ấn avatar ở header

### Input

- Tên hiển thị
- Ảnh đại diện
- Session active

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Người dùng đã đăng nhập.
- Function phải kiểm tra role trước action, không chỉ dựa vào ẩn UI.

### Validation

- Kiểm tra dữ liệu bắt buộc trước khi gọi service.
- Kiểm tra entity thuộc phạm vi user/session hiện tại.
- Contract chưa rõ phải ghi `OPEN_QUESTION`.

### Transaction / side effects

- Ghi local hoặc gọi API phải có loading và xử lý failure.
- Không thực hiện destructive action khi thiếu xác nhận nghiệp vụ.
- Offline sync cần ghi nhận pending/conflict state.

### Security

- Không log credential, token, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.
- Chỉ ghi config key names, không ghi secret values.

### Imports / dependencies

- lib/features/auth/student/screens/student_login_view.dart
- lib/features/auth/student/screens/role_view.dart
- lib/features/auth/student/controllers/ctrl_login_student.dart
- lib/core/services_root/api_daotao/auth/check_login.dart
- lib/core/services_root/api_daotao/auth/re_login.dart
- lib/core/services_root/sqlite/sessions/core_service_session.dart
- lib/config/config_db.dart
- lib/features/home/home_view/components/home_app_bar.dart

### Tests

- Menu mở/đóng
- logout/relogin
- profile thiếu ảnh
