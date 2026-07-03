# Views - Điểm danh

## Inventory và navigation

| View | Tên | Entry | Case |
|---|---|---|---|
| ATTENDANCE-V01 | Điểm danh QR cá nhân | Sinh viên mở buổi học và chọn Sinh QR điểm danh | ATTENDANCE-CASE-14 |
| ATTENDANCE-V02 | Xem danh sách vắng cho giảng viên | Giảng viên mở màn điểm danh buổi học | ATTENDANCE-CASE-15 |

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

## ATTENDANCE-V01 - Điểm danh QR cá nhân

- `Case:` ATTENDANCE-CASE-14
- `Function:` ATTENDANCE-FN01
- `Entry:` Sinh viên mở buổi học và chọn Sinh QR điểm danh

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Student ID
- Mã buổi học
- Timestamp
- Trạng thái xác nhận

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Sinh QR | ATTENDANCE-FN01 | Cập nhật UI/state theo flow |
| Người điểm danh quét QR | ATTENDANCE-FN01 | Cập nhật UI/state theo flow |
| Xác nhận trong thời hạn | ATTENDANCE-FN01 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Sinh viên, Giảng viên, Cán bộ.
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

## ATTENDANCE-V02 - Xem danh sách vắng cho giảng viên

- `Case:` ATTENDANCE-CASE-15
- `Function:` ATTENDANCE-FN02
- `Entry:` Giảng viên mở màn điểm danh buổi học

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Danh sách lớp
- Attendance record
- Khoảng báo cáo

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Tải roster | ATTENDANCE-FN02 | Cập nhật UI/state theo flow |
| Gộp trạng thái | ATTENDANCE-FN02 | Cập nhật UI/state theo flow |
| Điểm danh thủ công/xuất báo cáo | ATTENDANCE-FN02 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Giảng viên.
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
