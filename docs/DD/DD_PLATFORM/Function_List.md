# Function List - Kỹ thuật và hạ tầng

## Project dependency direction

- UI thuộc `lib/features/`; shared service thuộc `lib/core/`; database config thuộc `lib/config/`.
- DD này không thay đổi source code hoặc schema.
- External API contract chưa có source phải ghi `OPEN_QUESTION` trước khi implement.

## Function inventory

| Function | Tên | Input chính | Output chính | Case |
|---|---|---|---|---|
| PLATFORM-FN01 | Lưu SQLite offline | Session; Schedule; Deadline; Document metadata; Note; Todo; Sync status | UI state / persisted state / navigation result | PLATFORM-CASE-26 |
| PLATFORM-FN02 | Analytics hành vi người dùng | Anonymous event; Role; Feature name; Timestamp; Aggregation | UI state / persisted state / navigation result | PLATFORM-CASE-27 |

## PLATFORM-FN01 - Lưu SQLite offline

- `Case:` PLATFORM-CASE-26
- `Feature:` PLATFORM-F01
- `View:` PLATFORM-V01
- `Entry:` Sau login và khi dùng app offline

### Input

- Session
- Schedule
- Deadline
- Document metadata
- Note
- Todo
- Sync status

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Người dùng app.
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

- lib/config/config_DB.dart
- lib/config/syncData.dart
- lib/features/notification/services/background_sync_service.dart
- lib/features/notification/services/data_change_detector_service.dart
- lib/core/services_root/sqlite/notification/data_change_sqlite.dart
- lib/app.dart

### Tests

- Login rồi mất mạng
- tạo offline
- sync lại
- conflict

## PLATFORM-FN02 - Analytics hành vi người dùng

- `Case:` PLATFORM-CASE-27
- `Feature:` PLATFORM-F02
- `View:` PLATFORM-V02
- `Entry:` Người dùng thao tác chức năng

### Input

- Anonymous event
- Role
- Feature name
- Timestamp
- Aggregation

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Hệ thống, Nhà trường / Quản trị.
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

- lib/config/config_DB.dart
- lib/config/syncData.dart
- lib/features/notification/services/background_sync_service.dart
- lib/features/notification/services/data_change_detector_service.dart
- lib/core/services_root/sqlite/notification/data_change_sqlite.dart
- lib/app.dart

### Tests

- Event không PII
- opt-out/disabled
- aggregate dashboard
