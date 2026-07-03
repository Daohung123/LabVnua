# Import File - Todo và đầu việc

## Actual dependencies / evidence paths

- lib/config/config_DB.dart
- lib/features/home/study_view/screens/study_view.dart
- lib/features/schedure
- lib/features/score_data

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

- TASK-API01: task sync
- TASK-API02: file upload/submission
- TASK-API03: PDF/Word export

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
| TASK-CASE-21 | TASK-FN01 | CRUD online; CRUD offline; conflict |
| TASK-CASE-22 | TASK-FN02 | Upload ok/lỗi; quá hạn; export PDF/Word |
| TASK-CASE-23 | TASK-FN03 | Tạo kế hoạch; liên kết deadline; không có deadline |
