# Import File - AI trợ lý

## Actual dependencies / evidence paths

- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/ai_assistant/screens/ai_chat_dialog.dart
- lib/features/ai_assistant/services/service_ai.dart
- lib/features/chat/services/chat_service.dart
- lib/features/home/home_screen/screens/student_home_screen_view.dart

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

- AI_ASSISTANT-API01: Gemini
- AI_ASSISTANT-API02: internal context resolver
- AI_ASSISTANT-API03: STT
- AI_ASSISTANT-API04: deep link/action router

## Config key names

- GEMINI_API_KEY
- GEMINI_MODEL (mặc định: `gemini-3.5-flash`)
- SUPABASE_URL
- SUPABASE_ANON_KEY

## Runtime configuration safety

- Runtime config được truyền bằng `--dart-define-from-file=.env` và đọc qua
  `String.fromEnvironment`; `.env` là file local bị Git ignore.
- Chỉ `.env.example` được commit và không chứa giá trị credential thật.
- Gemini key đóng gói trong mobile client không phải server secret; production
  cần key restriction phù hợp hoặc backend proxy khi cần bảo vệ secret.

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
| AI_ASSISTANT-CASE-18 | AI_ASSISTANT-FN01 | Hỏi deadline tuần này; hỏi dữ liệu không có quyền; action invalid |
| AI_ASSISTANT-CASE-19 | AI_ASSISTANT-FN02 | Cấp/từ chối mic; STT thành công; STT lỗi mạng |
| AI_ASSISTANT-CASE-20 | AI_ASSISTANT-FN03 | Tap AI nav; back/close AI; kiểm tra tab chat cũ |
