# Function List - Cổng học tập

## Project dependency direction

- UI thuộc `lib/features/`; shared service thuộc `lib/core/`; database config thuộc `lib/config/`.
- DD này không thay đổi source code hoặc schema.
- External API contract chưa có source phải ghi `OPEN_QUESTION` trước khi implement.

## Function inventory

| Function | Tên | Input chính | Output chính | Case |
|---|---|---|---|---|
| LEARNING_PORTAL-FN01 | Cổng học tập: bỏ tiêu đề, thêm thống kê và search | Môn học; Học kỳ; Trạng thái môn; Điểm; Lịch; Tài liệu; Deadline | UI state / persisted state / navigation result | LEARNING_PORTAL-CASE-24 |

## LEARNING_PORTAL-FN01 - Cổng học tập: bỏ tiêu đề, thêm thống kê và search

- `Case:` LEARNING_PORTAL-CASE-24
- `Feature:` LEARNING_PORTAL-F01
- `View:` LEARNING_PORTAL-V01
- `Entry:` Tab học tập/cổng học tập

### Input

- Môn học
- Học kỳ
- Trạng thái môn
- Điểm
- Lịch
- Tài liệu
- Deadline

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

- lib/features/home/study_view/screens/study_view.dart
- lib/features/program_training/screens/program_training_view.dart
- lib/features/score_data/screens/view_score_student.dart
- lib/features/schedure/screens/study_view_day_month.dart
- lib/features/course_register/screens/view_courses_register.dart

### Tests

- Đủ dữ liệu
- không có môn trượt
- search empty
- click môn
