# List Features - Cổng học tập

## Inventory

| Feature | Tên | Priority | Rules | Function | View | Case |
|---|---|---|---|---|---|---|
| LEARNING_PORTAL-F01 | Cổng học tập: bỏ tiêu đề, thêm thống kê và search | P1 | LEARNING_PORTAL-BR01, LEARNING_PORTAL-BR02, LEARNING_PORTAL-BR03 | LEARNING_PORTAL-FN01 | LEARNING_PORTAL-V01 | LEARNING_PORTAL-CASE-24 |

## Dependencies

- LEARNING_PORTAL-API01: training program
- LEARNING_PORTAL-API02: score
- LEARNING_PORTAL-API03: schedule
- LEARNING_PORTAL-API04: document/deadline source
- lib/features/home/study_view/screens/study_view.dart
- lib/features/program_training/screens/program_training_view.dart
- lib/features/score_data/screens/view_score_student.dart
- lib/features/schedure/screens/study_view_day_month.dart
- lib/features/course_register/screens/view_courses_register.dart

## LEARNING_PORTAL-F01 - Cổng học tập: bỏ tiêu đề, thêm thống kê và search

- `Case:` LEARNING_PORTAL-CASE-24
- `Priority:` P1
- `Source:` BD 8.1, 8.2
- `Roles:` Sinh viên
- `Function:` LEARNING_PORTAL-FN01
- `View:` LEARNING_PORTAL-V01

### Happy flow

- Tải môn/thống kê
- Render thống kê
- Search/filter/click môn

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Có số môn hoàn thành/đang học/trượt
- Search trong phạm vi có nguồn

### Tests

- Đủ dữ liệu
- không có môn trượt
- search empty
- click môn

### Risks / open questions

- LEARNING_PORTAL-RISK01
- LEARNING_PORTAL-RISK02
