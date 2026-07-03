# Function List - Điểm danh

## Project dependency direction

- UI thuộc `lib/features/`; shared service thuộc `lib/core/`; database config thuộc `lib/config/`.
- DD này không thay đổi source code hoặc schema.
- External API contract chưa có source phải ghi `OPEN_QUESTION` trước khi implement.

## Function inventory

| Function | Tên | Input chính | Output chính | Case |
|---|---|---|---|---|
| ATTENDANCE-FN01 | Điểm danh QR cá nhân | Student ID; Mã buổi học; Timestamp; Trạng thái xác nhận | UI state / persisted state / navigation result | ATTENDANCE-CASE-14 |
| ATTENDANCE-FN02 | Xem danh sách vắng cho giảng viên | Danh sách lớp; Attendance record; Khoảng báo cáo | UI state / persisted state / navigation result | ATTENDANCE-CASE-15 |

## ATTENDANCE-FN01 - Điểm danh QR cá nhân

- `Case:` ATTENDANCE-CASE-14
- `Feature:` ATTENDANCE-F01
- `View:` ATTENDANCE-V01
- `Entry:` Sinh viên mở buổi học và chọn Sinh QR điểm danh

### Input

- Student ID
- Mã buổi học
- Timestamp
- Trạng thái xác nhận

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Sinh viên, Giảng viên, Cán bộ.
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

- lib/features/qr_code/screens/view_qr_code.dart
- android/app/src/main/AndroidManifest.xml
- lib/features/schedure/screens/components/detail_subject.dart

### Tests

- QR hợp lệ
- hết hạn
- sai buổi
- quét trùng

## ATTENDANCE-FN02 - Xem danh sách vắng cho giảng viên

- `Case:` ATTENDANCE-CASE-15
- `Feature:` ATTENDANCE-F02
- `View:` ATTENDANCE-V02
- `Entry:` Giảng viên mở màn điểm danh buổi học

### Input

- Danh sách lớp
- Attendance record
- Khoảng báo cáo

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Giảng viên.
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

- lib/features/qr_code/screens/view_qr_code.dart
- android/app/src/main/AndroidManifest.xml
- lib/features/schedure/screens/components/detail_subject.dart

### Tests

- Roster đủ
- chưa xử lý
- export buổi/tuần/tháng
