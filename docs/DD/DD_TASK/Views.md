# Views - Todo và đầu việc

## Inventory và navigation

| View | Tên | Entry | Case |
|---|---|---|---|
| TASK-V01 | Todo online và offline | Mở module Todo/Đầu việc | TASK-CASE-21 |
| TASK-V02 | Nộp bài / giao bài / tạo báo cáo | Deadline hoặc module đầu việc | TASK-CASE-22 |
| TASK-V03 | Kế hoạch học tập | Module học tập hoặc Todo | TASK-CASE-23 |

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

## TASK-V01 - Todo online và offline

- `Case:` TASK-CASE-21
- `Function:` TASK-FN01
- `Entry:` Mở module Todo/Đầu việc

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Title
- Description
- Type
- Course/session link
- Sync status

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Tạo/sửa/xóa | TASK-FN01 | Cập nhật UI/state theo flow |
| Phân loại Online/Offline | TASK-FN01 | Cập nhật UI/state theo flow |
| Lưu local và sync | TASK-FN01 | Cập nhật UI/state theo flow |

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

## TASK-V02 - Nộp bài / giao bài / tạo báo cáo

- `Case:` TASK-CASE-22
- `Function:` TASK-FN02
- `Entry:` Deadline hoặc module đầu việc

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Assignment
- Deadline
- Attachment
- Submission
- Report form

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| GV giao bài | TASK-FN02 | Cập nhật UI/state theo flow |
| SV upload | TASK-FN02 | Cập nhật UI/state theo flow |
| SV tạo báo cáo PDF/Word | TASK-FN02 | Cập nhật UI/state theo flow |

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

## TASK-V03 - Kế hoạch học tập

- `Case:` TASK-CASE-23
- `Function:` TASK-FN03
- `Entry:` Module học tập hoặc Todo

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Study plan
- Term/year
- Linked schedule
- Linked deadline
- Progress

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Tạo kế hoạch | TASK-FN03 | Cập nhật UI/state theo flow |
| Liên kết lịch/deadline | TASK-FN03 | Cập nhật UI/state theo flow |
| Theo dõi tiến độ | TASK-FN03 | Cập nhật UI/state theo flow |

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
