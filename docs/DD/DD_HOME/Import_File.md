# Import File - Trang chủ

## Actual dependencies / evidence paths

- lib/features/home/home_screen/screens/student_home_screen_view.dart
- lib/features/home/home_view/screens/student_home_view.dart
- lib/features/home/home_view/components/home_app_bar.dart
- lib/features/home/home_view/components/home_quick_actions.dart
- lib/features/home/home_view/components/home_quick_summary.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/notification/screens/view_noti_student.dart

## Significant file/layer mapping

| Layer | Allowed mapping |
|---|---|
| Feature UI | Dùng thư mục screens/widgets/components trong feature tương ứng dưới `lib/features/`. |
| Controller/service | Dùng controller/service trong feature hoặc shared service dưới `lib/core/services_root/`. |
| Persistence | SQLite đi qua `lib/config/config_DB.dart` hoặc service dưới `lib/core/services_root/sqlite/`. |
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

- HOME-API01: VNUA schedule
- HOME-API02: notification/cache
- HOME-API03: analytics event source

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
| HOME-CASE-04 | HOME-FN01 | Có lịch hôm nay; không có lịch; lỗi tải lịch |
| HOME-CASE-05 | HOME-FN02 | Nhiều tiết; thiếu phòng; click điều hướng |
| HOME-CASE-06 | HOME-FN03 | Quá hạn; dưới 24 giờ; đã nộp; chưa nộp |
| HOME-CASE-07 | HOME-FN04 | Thêm; xóa; reorder; vượt giới hạn |
| HOME-CASE-08 | HOME-FN05 | Thông báo mới/cũ; không có quảng cáo; click chi tiết |
