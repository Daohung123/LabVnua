# Views - AI trợ lý

## Inventory và navigation

| View | Tên | Entry | Case |
|---|---|---|---|
| AI_ASSISTANT-V01 | AI tích hợp dữ liệu nội bộ và deep link | Mở AI từ navigation hoặc dialog | AI_ASSISTANT-CASE-18 |
| AI_ASSISTANT-V02 | Speech-to-Text tích hợp AI | Nút nhập giọng nói trong AI | AI_ASSISTANT-CASE-19 |
| AI_ASSISTANT-V03 | Thay Chat bằng AI trên navigation | Bottom navigation/main shell | AI_ASSISTANT-CASE-20 |

## Global UI states

- Initial
- Loading
- Loaded
- Empty
- Validation error
- Permission denied
- Offline
- Service error
- Success

## AI_ASSISTANT-V01 - AI tích hợp dữ liệu nội bộ và deep link

- `Case:` AI_ASSISTANT-CASE-18
- `Function:` AI_ASSISTANT-FN01
- `Entry:` Mở AI từ navigation hoặc dialog

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- User context
- Entity mapping
- AI response
- Navigate action

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Người dùng hỏi | AI_ASSISTANT-FN01 | Cập nhật UI/state theo flow |
| Resolver lấy context được phép | AI_ASSISTANT-FN01 | Cập nhật UI/state theo flow |
| AI trả lời kèm action | AI_ASSISTANT-FN01 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Sinh viên, Giảng viên.
- Action không phù hợp role phải ẩn hoặc disabled.

### Required UI states

- Loading
- Loaded
- Empty
- Error
- Offline
- Permission denied
- Submitting
- Success

## AI_ASSISTANT-V02 - Speech-to-Text tích hợp AI

- `Case:` AI_ASSISTANT-CASE-19
- `Function:` AI_ASSISTANT-FN02
- `Entry:` Nút nhập giọng nói trong AI

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Audio input
- Transcript text
- Locale
- Error state

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Ghi âm câu hỏi | AI_ASSISTANT-FN02 | Cập nhật UI/state theo flow |
| STT thành text tiếng Việt | AI_ASSISTANT-FN02 | Cập nhật UI/state theo flow |
| Gửi text vào AI | AI_ASSISTANT-FN02 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Sinh viên, Giảng viên.
- Action không phù hợp role phải ẩn hoặc disabled.

### Required UI states

- Loading
- Loaded
- Empty
- Error
- Offline
- Permission denied
- Submitting
- Success

## AI_ASSISTANT-V03 - Thay Chat bằng AI trên navigation

- `Case:` AI_ASSISTANT-CASE-20
- `Function:` AI_ASSISTANT-FN03
- `Entry:` Bottom navigation/main shell

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Navigation item
- AI screen/dialog state

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Đổi Chat thành AI | AI_ASSISTANT-FN03 | Cập nhật UI/state theo flow |
| Mở AI từ tab | AI_ASSISTANT-FN03 | Cập nhật UI/state theo flow |
| Chuyển nhắn tin đối tác nếu còn dùng | AI_ASSISTANT-FN03 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Người dùng đã đăng nhập.
- Action không phù hợp role phải ẩn hoặc disabled.

### Required UI states

- Loading
- Loaded
- Empty
- Error
- Offline
- Permission denied
- Submitting
- Success
