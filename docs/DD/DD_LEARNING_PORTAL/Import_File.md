# Import File - Cổng học tập

## Actual dependencies / evidence paths

- lib/features/home/study_view/screens/study_view.dart
- lib/features/program_training/screens/program_training_view.dart
- lib/features/score_data/screens/view_score_student.dart
- lib/features/schedure/screens/study_view_day_month.dart
- lib/features/course_register/screens/view_courses_register.dart

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

- LEARNING_PORTAL-API01: training program
- LEARNING_PORTAL-API02: score
- LEARNING_PORTAL-API03: schedule
- LEARNING_PORTAL-API04: document/deadline source

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
| LEARNING_PORTAL-CASE-24 | LEARNING_PORTAL-FN01 | Đủ dữ liệu; không có môn trượt; search empty; click môn |
