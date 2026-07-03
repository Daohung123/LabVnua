# Views - Xác thực và tài khoản

## Inventory và navigation

| View | Tên | Entry | Case |
|---|---|---|---|
| AUTH-V01 | Làm lại giao diện đăng nhập và logo | Mở app khi chưa có session hợp lệ | AUTH-CASE-01 |
| AUTH-V02 | Bỏ chọn role, thêm đăng nhập VNied | Từ LoginScreen chọn VNied hoặc email/password | AUTH-CASE-02 |
| AUTH-V03 | Avatar dropdown gồm logout và cài đặt | Ấn avatar ở header | AUTH-CASE-03 |

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

## AUTH-V01 - Làm lại giao diện đăng nhập và logo

- `Case:` AUTH-CASE-01
- `Function:` AUTH-FN01
- `Entry:` Mở app khi chưa có session hợp lệ

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Logo/asset
- Trạng thái form
- Session hiện có

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Hiển thị login đơn giản | AUTH-FN01 | Cập nhật UI/state theo flow |
| Hiển thị logo | AUTH-FN01 | Cập nhật UI/state theo flow |
| Submit phương thức login | AUTH-FN01 | Cập nhật UI/state theo flow |

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

## AUTH-V02 - Bỏ chọn role, thêm đăng nhập VNied

- `Case:` AUTH-CASE-02
- `Function:` AUTH-FN02
- `Entry:` Từ LoginScreen chọn VNied hoặc email/password

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Access token/cookie
- Role
- Profile
- Thời hạn token

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Ẩn control chọn role | AUTH-FN02 | Cập nhật UI/state theo flow |
| Xác thực VNied | AUTH-FN02 | Cập nhật UI/state theo flow |
| Lưu session và route theo role | AUTH-FN02 | Cập nhật UI/state theo flow |

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

## AUTH-V03 - Avatar dropdown gồm logout và cài đặt

- `Case:` AUTH-CASE-03
- `Function:` AUTH-FN03
- `Entry:` Ấn avatar ở header

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Tên hiển thị
- Ảnh đại diện
- Session active

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Mở dropdown | AUTH-FN03 | Cập nhật UI/state theo flow |
| Hiển thị thông tin/cài đặt/đổi mật khẩu/logout | AUTH-FN03 | Cập nhật UI/state theo flow |
| Logout về login | AUTH-FN03 | Cập nhật UI/state theo flow |

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
