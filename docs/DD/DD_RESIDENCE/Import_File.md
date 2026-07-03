# Import File - Đăng ký tạm trú / tạm vắng

## Actual dependencies / evidence paths

- Không có feature tương ứng được tìm thấy trong lib/features tại thời điểm DD

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

- RESIDENCE-API01: public verification
- RESIDENCE-API02: PDF export
- RESIDENCE-API03: QR generation

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
| RESIDENCE-CASE-25 | RESIDENCE-FN01 | Tạo đơn; thiếu trường; QR hết hạn; token invalid |
