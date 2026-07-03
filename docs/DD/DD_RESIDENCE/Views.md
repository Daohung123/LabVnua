# Views - Đăng ký tạm trú / tạm vắng

## Inventory và navigation

| View | Tên | Entry | Case |
|---|---|---|---|
| RESIDENCE-V01 | Đăng ký tạm trú / tạm vắng và QR | Sinh viên mở form đăng ký hành chính | RESIDENCE-CASE-25 |

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

## RESIDENCE-V01 - Đăng ký tạm trú / tạm vắng và QR

- `Case:` RESIDENCE-CASE-25
- `Function:` RESIDENCE-FN01
- `Entry:` Sinh viên mở form đăng ký hành chính

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Thông tin cá nhân
- Địa chỉ
- Thời gian
- Registration ID
- QR
- Verification token

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Điền form | RESIDENCE-FN01 | Cập nhật UI/state theo flow |
| Sinh mã/QR | RESIDENCE-FN01 | Cập nhật UI/state theo flow |
| Xuất PDF | RESIDENCE-FN01 | Cập nhật UI/state theo flow |
| Quét QR xác minh | RESIDENCE-FN01 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Sinh viên, Công an, Chủ nhà.
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
