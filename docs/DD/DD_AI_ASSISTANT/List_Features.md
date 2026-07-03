# List Features - AI trợ lý

## Inventory

| Feature | Tên | Priority | Rules | Function | View | Case |
|---|---|---|---|---|---|---|
| AI_ASSISTANT-F01 | AI tích hợp dữ liệu nội bộ và deep link | P0 - MVP | AI_ASSISTANT-BR01, AI_ASSISTANT-BR02, AI_ASSISTANT-BR03 | AI_ASSISTANT-FN01 | AI_ASSISTANT-V01 | AI_ASSISTANT-CASE-18 |
| AI_ASSISTANT-F02 | Speech-to-Text tích hợp AI | P0 - MVP | AI_ASSISTANT-BR01, AI_ASSISTANT-BR02, AI_ASSISTANT-BR03 | AI_ASSISTANT-FN02 | AI_ASSISTANT-V02 | AI_ASSISTANT-CASE-19 |
| AI_ASSISTANT-F03 | Thay Chat bằng AI trên navigation | P0 - MVP | AI_ASSISTANT-BR01, AI_ASSISTANT-BR02, AI_ASSISTANT-BR03 | AI_ASSISTANT-FN03 | AI_ASSISTANT-V03 | AI_ASSISTANT-CASE-20 |

## Dependencies

- AI_ASSISTANT-API01: Gemini
- AI_ASSISTANT-API02: internal context resolver
- AI_ASSISTANT-API03: STT
- AI_ASSISTANT-API04: deep link/action router
- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/ai_assistant/screens/ai_chat_dialog.dart
- lib/features/ai_assistant/services/service_ai.dart
- lib/features/chat/services/chat_service.dart
- lib/features/home/home_screen/screens/student_home_screen_view.dart

## AI_ASSISTANT-F01 - AI tích hợp dữ liệu nội bộ và deep link

- `Case:` AI_ASSISTANT-CASE-18
- `Priority:` P0 - MVP
- `Source:` BD 6.2, 6.3, 10.4
- `Roles:` Sinh viên, Giảng viên
- `Function:` AI_ASSISTANT-FN01
- `View:` AI_ASSISTANT-V01

### Happy flow

- Người dùng hỏi
- Resolver lấy context được phép
- AI trả lời kèm action

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Không cần nhập ID thủ công
- Action chỉ chạy khi hợp lệ

### Tests

- Hỏi deadline tuần này
- hỏi dữ liệu không có quyền
- action invalid

### Risks / open questions

- AI_ASSISTANT-RISK01
- AI_ASSISTANT-RISK02
- AI_ASSISTANT-RISK03
- AI_ASSISTANT-RISK04

## AI_ASSISTANT-F02 - Speech-to-Text tích hợp AI

- `Case:` AI_ASSISTANT-CASE-19
- `Priority:` P0 - MVP
- `Source:` BD 6.2, 10.3
- `Roles:` Sinh viên, Giảng viên
- `Function:` AI_ASSISTANT-FN02
- `View:` AI_ASSISTANT-V02

### Happy flow

- Ghi âm câu hỏi
- STT thành text tiếng Việt
- Gửi text vào AI

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Có trạng thái quyền mic/ghi âm/xử lý/lỗi
- Transcript kiểm soát được

### Tests

- Cấp/từ chối mic
- STT thành công
- STT lỗi mạng

### Risks / open questions

- AI_ASSISTANT-RISK01
- AI_ASSISTANT-RISK02
- AI_ASSISTANT-RISK03
- AI_ASSISTANT-RISK04

## AI_ASSISTANT-F03 - Thay Chat bằng AI trên navigation

- `Case:` AI_ASSISTANT-CASE-20
- `Priority:` P0 - MVP
- `Source:` BD 6.1
- `Roles:` Người dùng đã đăng nhập
- `Function:` AI_ASSISTANT-FN03
- `View:` AI_ASSISTANT-V03

### Happy flow

- Đổi Chat thành AI
- Mở AI từ tab
- Chuyển nhắn tin đối tác nếu còn dùng

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Navigation hiển thị AI
- Không mất lối vào chat đối tác nếu business còn cần

### Tests

- Tap AI nav
- back/close AI
- kiểm tra tab chat cũ

### Risks / open questions

- AI_ASSISTANT-RISK01
- AI_ASSISTANT-RISK02
- AI_ASSISTANT-RISK03
- AI_ASSISTANT-RISK04
