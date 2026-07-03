# Function List - Đăng ký tạm trú / tạm vắng

## Project dependency direction

- UI thuộc `lib/features/`; shared service thuộc `lib/core/`; database config thuộc `lib/config/`.
- DD này không thay đổi source code hoặc schema.
- External API contract chưa có source phải ghi `OPEN_QUESTION` trước khi implement.

## Function inventory

| Function | Tên | Input chính | Output chính | Case |
|---|---|---|---|---|
| RESIDENCE-FN01 | Đăng ký tạm trú / tạm vắng và QR | Thông tin cá nhân; Địa chỉ; Thời gian; Registration ID; QR; Verification token | UI state / persisted state / navigation result | RESIDENCE-CASE-25 |

## RESIDENCE-FN01 - Đăng ký tạm trú / tạm vắng và QR

- `Case:` RESIDENCE-CASE-25
- `Feature:` RESIDENCE-F01
- `View:` RESIDENCE-V01
- `Entry:` Sinh viên mở form đăng ký hành chính

### Input

- Thông tin cá nhân
- Địa chỉ
- Thời gian
- Registration ID
- QR
- Verification token

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Sinh viên, Công an, Chủ nhà.
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

- Không có feature tương ứng được tìm thấy trong lib/features tại thời điểm DD

### Tests

- Tạo đơn
- thiếu trường
- QR hết hạn
- token invalid
