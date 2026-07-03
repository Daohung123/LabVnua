# Views - Cổng học tập

## Inventory và navigation

| View | Tên | Entry | Case |
|---|---|---|---|
| LEARNING_PORTAL-V01 | Cổng học tập: bỏ tiêu đề, thêm thống kê và search | Tab học tập/cổng học tập | LEARNING_PORTAL-CASE-24 |

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

## LEARNING_PORTAL-V01 - Cổng học tập: bỏ tiêu đề, thêm thống kê và search

- `Case:` LEARNING_PORTAL-CASE-24
- `Function:` LEARNING_PORTAL-FN01
- `Entry:` Tab học tập/cổng học tập

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Môn học
- Học kỳ
- Trạng thái môn
- Điểm
- Lịch
- Tài liệu
- Deadline

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Tải môn/thống kê | LEARNING_PORTAL-FN01 | Cập nhật UI/state theo flow |
| Render thống kê | LEARNING_PORTAL-FN01 | Cập nhật UI/state theo flow |
| Search/filter/click môn | LEARNING_PORTAL-FN01 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Sinh viên.
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
