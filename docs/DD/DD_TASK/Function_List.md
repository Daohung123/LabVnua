# Function List - Todo và đầu việc

## Project dependency direction

- UI thuộc `lib/features/`; shared service thuộc `lib/core/`; database config thuộc `lib/config/`.
- DD này không thay đổi source code hoặc schema.
- External API contract chưa có source phải ghi `OPEN_QUESTION` trước khi implement.

## Function inventory

| Function | Tên | Input chính | Output chính | Case |
|---|---|---|---|---|
| TASK-FN01 | Todo online và offline | Title; Description; Type; Course/session link; Sync status | UI state / persisted state / navigation result | TASK-CASE-21 |
| TASK-FN02 | Nộp bài / giao bài / tạo báo cáo | Assignment; Deadline; Attachment; Submission; Report form | UI state / persisted state / navigation result | TASK-CASE-22 |
| TASK-FN03 | Kế hoạch học tập | Study plan; Term/year; Linked schedule; Linked deadline; Progress | UI state / persisted state / navigation result | TASK-CASE-23 |

## TASK-FN01 - Todo online và offline

- `Case:` TASK-CASE-21
- `Feature:` TASK-F01
- `View:` TASK-V01
- `Entry:` Mở module Todo/Đầu việc

### Input

- Title
- Description
- Type
- Course/session link
- Sync status

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Sinh viên, Giảng viên.
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
- lib/features/home/study_view/screens/study_view.dart
- lib/features/schedure
- lib/features/score_data

### Tests

- CRUD online
- CRUD offline
- conflict

## TASK-FN02 - Nộp bài / giao bài / tạo báo cáo

- `Case:` TASK-CASE-22
- `Feature:` TASK-F02
- `View:` TASK-V02
- `Entry:` Deadline hoặc module đầu việc

### Input

- Assignment
- Deadline
- Attachment
- Submission
- Report form

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Sinh viên, Giảng viên.
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
- lib/features/home/study_view/screens/study_view.dart
- lib/features/schedure
- lib/features/score_data

### Tests

- Upload ok/lỗi
- quá hạn
- export PDF/Word

## TASK-FN03 - Kế hoạch học tập

- `Case:` TASK-CASE-23
- `Feature:` TASK-F03
- `View:` TASK-V03
- `Entry:` Module học tập hoặc Todo

### Input

- Study plan
- Term/year
- Linked schedule
- Linked deadline
- Progress

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Sinh viên.
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
- lib/features/home/study_view/screens/study_view.dart
- lib/features/schedure
- lib/features/score_data

### Tests

- Tạo kế hoạch
- liên kết deadline
- không có deadline
