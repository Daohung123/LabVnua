# Views - Kỹ thuật và hạ tầng

## Inventory và navigation

| View | Tên | Entry | Case |
|---|---|---|---|
| PLATFORM-V01 | Lưu SQLite offline | Sau login và khi dùng app offline | PLATFORM-CASE-26 |
| PLATFORM-V02 | Analytics hành vi người dùng | Người dùng thao tác chức năng | PLATFORM-CASE-27 |

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

## PLATFORM-V01 - Lưu SQLite offline

- `Case:` PLATFORM-CASE-26
- `Function:` PLATFORM-FN01
- `Entry:` Sau login và khi dùng app offline

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Session
- Schedule
- Deadline
- Document metadata
- Note
- Todo
- Sync status

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Sync dữ liệu về SQLite | PLATFORM-FN01 | Cập nhật UI/state theo flow |
| Xem offline | PLATFORM-FN01 | Cập nhật UI/state theo flow |
| Local-first note/todo rồi sync | PLATFORM-FN01 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Người dùng app.
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

## PLATFORM-V02 - Analytics hành vi người dùng

- `Case:` PLATFORM-CASE-27
- `Function:` PLATFORM-FN02
- `Entry:` Người dùng thao tác chức năng

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Anonymous event
- Role
- Feature name
- Timestamp
- Aggregation

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Ghi event ẩn danh | PLATFORM-FN02 | Cập nhật UI/state theo flow |
| Tổng hợp theo role/thời gian | PLATFORM-FN02 | Cập nhật UI/state theo flow |
| Dùng cho shortcut/roadmap | PLATFORM-FN02 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Hệ thống, Nhà trường / Quản trị.
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
