# Function List - AI trợ lý

## Project dependency direction

- UI thuộc `lib/features/`; shared service thuộc `lib/core/`; database config thuộc `lib/config/`.
- DD này không thay đổi source code hoặc schema.
- External API contract chưa có source phải ghi `OPEN_QUESTION` trước khi implement.

## Function inventory

| Function | Tên | Input chính | Output chính | Case |
|---|---|---|---|---|
| AI_ASSISTANT-FN01 | AI tích hợp dữ liệu nội bộ và deep link | User context; Entity mapping; AI response; Navigate action | UI state / persisted state / navigation result | AI_ASSISTANT-CASE-18 |
| AI_ASSISTANT-FN02 | Speech-to-Text tích hợp AI | Audio input; Transcript text; Locale; Error state | UI state / persisted state / navigation result | AI_ASSISTANT-CASE-19 |
| AI_ASSISTANT-FN03 | Thay Chat bằng AI trên navigation | Navigation item; AI screen/dialog state | UI state / persisted state / navigation result | AI_ASSISTANT-CASE-20 |

## AI_ASSISTANT-FN01 - AI tích hợp dữ liệu nội bộ và deep link

- `Case:` AI_ASSISTANT-CASE-18
- `Feature:` AI_ASSISTANT-F01
- `View:` AI_ASSISTANT-V01
- `Entry:` Mở AI từ navigation hoặc dialog

### Input

- User context
- Entity mapping
- AI response
- Navigate action

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

- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/ai_assistant/screens/ai_chat_dialog.dart
- lib/features/ai_assistant/services/service_ai.dart
- lib/features/chat/services/chat_service.dart
- lib/features/home/home_screen/screens/student_home_screen_view.dart

### Tests

- Hỏi deadline tuần này
- hỏi dữ liệu không có quyền
- action invalid

## AI_ASSISTANT-FN02 - Speech-to-Text tích hợp AI

- `Case:` AI_ASSISTANT-CASE-19
- `Feature:` AI_ASSISTANT-F02
- `View:` AI_ASSISTANT-V02
- `Entry:` Nút nhập giọng nói trong AI

### Input

- Audio input
- Transcript text
- Locale
- Error state

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

- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/ai_assistant/screens/ai_chat_dialog.dart
- lib/features/ai_assistant/services/service_ai.dart
- lib/features/chat/services/chat_service.dart
- lib/features/home/home_screen/screens/student_home_screen_view.dart

### Tests

- Cấp/từ chối mic
- STT thành công
- STT lỗi mạng

## AI_ASSISTANT-FN03 - Thay Chat bằng AI trên navigation

- `Case:` AI_ASSISTANT-CASE-20
- `Feature:` AI_ASSISTANT-F03
- `View:` AI_ASSISTANT-V03
- `Entry:` Bottom navigation/main shell

### Input

- Navigation item
- AI screen/dialog state

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

- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/ai_assistant/screens/ai_chat_dialog.dart
- lib/features/ai_assistant/services/service_ai.dart
- lib/features/chat/services/chat_service.dart
- lib/features/home/home_screen/screens/student_home_screen_view.dart

### Tests

- Tap AI nav
- back/close AI
- kiểm tra tab chat cũ
