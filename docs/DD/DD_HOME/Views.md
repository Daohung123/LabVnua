# Views - Trang chủ

## Inventory và navigation

| View | Tên | Entry | Case |
|---|---|---|---|
| HOME-V01 | Trang chủ: lịch thay phần chào mừng | Vào tab Home | HOME-CASE-04 |
| HOME-V02 | Thời khóa biểu hiển thị ngang | Khối lịch trên Home hoặc trang lịch | HOME-CASE-05 |
| HOME-V03 | Deadline phần 2 | Khối Deadline trên Home | HOME-CASE-06 |
| HOME-V04 | Lối tắt tự cấu hình thay tổng quan nhanh | Khối lối tắt trên Home | HOME-CASE-07 |
| HOME-V05 | Thông báo và quảng cáo phần 3 | Khối thông báo/sự kiện trên Home | HOME-CASE-08 |

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

## HOME-V01 - Trang chủ: lịch thay phần chào mừng

- `Case:` HOME-CASE-04
- `Function:` HOME-FN01
- `Entry:` Vào tab Home

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Ngày hiện tại
- Danh sách tiết học/giảng dạy/họp
- Role

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Tải ngày hiện tại | HOME-FN01 | Cập nhật UI/state theo flow |
| Lấy lịch theo role | HOME-FN01 | Cập nhật UI/state theo flow |
| Render khối lịch | HOME-FN01 | Cập nhật UI/state theo flow |

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

## HOME-V02 - Thời khóa biểu hiển thị ngang

- `Case:` HOME-CASE-05
- `Function:` HOME-FN02
- `Entry:` Khối lịch trên Home hoặc trang lịch

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Thời gian
- Địa điểm
- Môn học
- Hoạt động
- Mã buổi học

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Sắp xếp theo thời gian | HOME-FN02 | Cập nhật UI/state theo flow |
| Render ngang | HOME-FN02 | Cập nhật UI/state theo flow |
| Click tới chi tiết buổi học | HOME-FN02 | Cập nhật UI/state theo flow |

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

## HOME-V03 - Deadline phần 2

- `Case:` HOME-CASE-06
- `Function:` HOME-FN03
- `Entry:` Khối Deadline trên Home

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Tên nhiệm vụ
- Môn học
- Ngày hết hạn
- Trạng thái nộp

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Lấy deadline | HOME-FN03 | Cập nhật UI/state theo flow |
| Sắp xếp hạn gần nhất | HOME-FN03 | Cập nhật UI/state theo flow |
| Click vào nộp bài/đầu việc | HOME-FN03 | Cập nhật UI/state theo flow |

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

## HOME-V04 - Lối tắt tự cấu hình thay tổng quan nhanh

- `Case:` HOME-CASE-07
- `Function:` HOME-FN04
- `Entry:` Khối lối tắt trên Home

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Danh sách shortcut
- Thứ tự
- Cấu hình theo user

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Hiển thị grid 2 x N | HOME-FN04 | Cập nhật UI/state theo flow |
| Vào chế độ chỉnh sửa | HOME-FN04 | Cập nhật UI/state theo flow |
| Thêm/xóa/sắp xếp trong giới hạn | HOME-FN04 | Cập nhật UI/state theo flow |

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

## HOME-V05 - Thông báo và quảng cáo phần 3

- `Case:` HOME-CASE-08
- `Function:` HOME-FN05
- `Entry:` Khối thông báo/sự kiện trên Home

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Tiêu đề
- Nội dung tóm tắt
- Ngày gửi
- Loại mục

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Lấy thông báo | HOME-FN05 | Cập nhật UI/state theo flow |
| Lấy quảng cáo nếu có nguồn | HOME-FN05 | Cập nhật UI/state theo flow |
| Click chi tiết | HOME-FN05 | Cập nhật UI/state theo flow |

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
