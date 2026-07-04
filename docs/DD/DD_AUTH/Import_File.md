# Import File - Xác thực và tài khoản

## Actual dependencies / evidence paths

- lib/features/auth/student/screens/student_login_view.dart
- lib/features/auth/student/screens/role_view.dart
- lib/features/auth/student/controllers/ctrl_login_student.dart
- lib/core/services_root/api_daotao/auth/check_login.dart
- lib/core/services_root/api_daotao/auth/re_login.dart
- lib/core/services_root/sqlite/sessions/core_service_session.dart
- lib/config/config_db.dart
- lib/features/home/home_view/components/home_app_bar.dart

## Significant file/layer mapping

| Layer | Allowed mapping |
|---|---|
| Feature UI | Dùng thư mục screens/widgets/components trong feature tương ứng dưới `lib/features/`. |
| Controller/service | Dùng controller/service trong feature hoặc shared service dưới `lib/core/services_root/`. |
| Persistence | SQLite đi qua `lib/config/config_db.dart` hoặc service dưới `lib/core/services_root/sqlite/`. |
| External API | Endpoint/service phải có source hoặc contract; nếu chưa có thì ghi `OPEN_QUESTION`. |
| Theme/shared UI | Ưu tiên `lib/core/theme` theo architecture note. |

## Allowed imports

- Feature-local screens/controllers/services/models của module.
- Shared core services đã có evidence trong `.agent/api/*` và `.agent/database/*`.
- Theme/shared components trong `lib/core/theme` khi implement UI mới.

## Forbidden imports / constraints

- Không import trực tiếp secret values hoặc hard-code token/API key.
- Không tạo dependency vòng giữa feature modules.
- Không suy diễn Supabase schema/RLS hoặc external API envelope khi chưa có source.
- Không thay đổi app source trong task DD.

## Exports / contracts

- AUTH-API01: VNied/VNUA auth
- AUTH-API02: email/password fallback
- AUTH-API03: SQLite session restore

## Config key names

- Không có config key name riêng được xác nhận cho module này.

## Flags

- Feature flag hoặc disabled state cần dùng cho behavior có `OPEN_QUESTION` chưa được chốt.
- P2 case có thể tách khỏi MVP implementation nếu release scope không bao gồm.

## Timeout / retry / fallback

- Network call phải có timeout và error state ở UI.
- Retry chỉ áp dụng cho thao tác idempotent hoặc có idempotency key.
- Offline fallback chỉ dùng khi có cache hợp lệ và timestamp/source rõ ràng.

## Test mapping

| Case | Function | Test notes |
|---|---|---|
| AUTH-CASE-01 | AUTH-FN01 | UI rỗng/loading/lỗi; Layout mobile nhỏ/lớn |
| AUTH-CASE-02 | AUTH-FN02 | VNied happy path; fallback email/password; role thiếu/lạ |
| AUTH-CASE-03 | AUTH-FN03 | Menu mở/đóng; logout/relogin; profile thiếu ảnh |
