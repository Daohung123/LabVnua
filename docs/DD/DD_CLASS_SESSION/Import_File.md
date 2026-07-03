# Import File - Buổi học

## Actual dependencies / evidence paths

- lib/features/schedure/screens/components/detail_subject.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/home/study_view/screens/study_view.dart

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

- CLASS_SESSION-API01: schedule/detail source
- CLASS_SESSION-API02: STT provider
- CLASS_SESSION-API03: quiz backend
- CLASS_SESSION-API04: AI transcript Q&A

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
| CLASS_SESSION-CASE-09 | CLASS_SESSION-FN01 | SV xem; GV xem; thiếu phòng |
| CLASS_SESSION-CASE-10 | CLASS_SESSION-FN02 | CRUD ghi chú; start/stop recording; lỗi microphone |
| CLASS_SESSION-CASE-11 | CLASS_SESSION-FN03 | Audio ngắn/dài; STT lỗi; search empty |
| CLASS_SESSION-CASE-12 | CLASS_SESSION-FN04 | Tạo quiz text; quiz voice; publish/unpublish |
| CLASS_SESSION-CASE-13 | CLASS_SESSION-FN05 | Không ai nộp; một phần lớp nộp; submission trễ |
| CLASS_SESSION-CASE-16 | CLASS_SESSION-FN06 | Tạo câu hỏi; trả lời; upvote; câu hỏi từ audio |
| CLASS_SESSION-CASE-17 | CLASS_SESSION-FN07 | Tạo FAQ; gợi ý; câu không liên quan |
| CLASS_SESSION-CASE-28 | CLASS_SESSION-FN08 | Role GV; role SV; role invalid |
| CLASS_SESSION-CASE-29 | CLASS_SESSION-FN09 | Chia nhóm; sửa phân công; thiếu danh sách lớp |
| CLASS_SESSION-CASE-30 | CLASS_SESSION-FN10 | Nhiều nguồn; không có dữ liệu; GV chỉnh nhận xét |
