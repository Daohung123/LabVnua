# List Features - Todo và đầu việc

## Inventory

| Feature | Tên | Priority | Rules | Function | View | Case |
|---|---|---|---|---|---|---|
| TASK-F01 | Todo online và offline | P0 - MVP | TASK-BR01, TASK-BR02, TASK-BR03 | TASK-FN01 | TASK-V01 | TASK-CASE-21 |
| TASK-F02 | Nộp bài / giao bài / tạo báo cáo | P1 | TASK-BR01, TASK-BR02, TASK-BR03 | TASK-FN02 | TASK-V02 | TASK-CASE-22 |
| TASK-F03 | Kế hoạch học tập | P1 | TASK-BR01, TASK-BR02, TASK-BR03 | TASK-FN03 | TASK-V03 | TASK-CASE-23 |

## Dependencies

- TASK-API01: task sync
- TASK-API02: file upload/submission
- TASK-API03: PDF/Word export
- lib/config/config_DB.dart
- lib/features/home/study_view/screens/study_view.dart
- lib/features/schedure
- lib/features/score_data

## TASK-F01 - Todo online và offline

- `Case:` TASK-CASE-21
- `Priority:` P0 - MVP
- `Source:` BD 7.1, 10.1
- `Roles:` Sinh viên, Giảng viên
- `Function:` TASK-FN01
- `View:` TASK-V01

### Happy flow

- Tạo/sửa/xóa
- Phân loại Online/Offline
- Lưu local và sync

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Todo hoạt động offline
- Sync state rõ khi có mạng

### Tests

- CRUD online
- CRUD offline
- conflict

### Risks / open questions

- TASK-RISK01
- TASK-RISK02
- TASK-RISK03

## TASK-F02 - Nộp bài / giao bài / tạo báo cáo

- `Case:` TASK-CASE-22
- `Priority:` P1
- `Source:` BD 7.2
- `Roles:` Sinh viên, Giảng viên
- `Function:` TASK-FN02
- `View:` TASK-V02

### Happy flow

- GV giao bài
- SV upload
- SV tạo báo cáo PDF/Word

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- SV xem trạng thái nộp
- GV giao bài có deadline
- Báo cáo theo mẫu phê duyệt

### Tests

- Upload ok/lỗi
- quá hạn
- export PDF/Word

### Risks / open questions

- TASK-RISK01
- TASK-RISK02
- TASK-RISK03

## TASK-F03 - Kế hoạch học tập

- `Case:` TASK-CASE-23
- `Priority:` P1
- `Source:` BD 7.3
- `Roles:` Sinh viên
- `Function:` TASK-FN03
- `View:` TASK-V03

### Happy flow

- Tạo kế hoạch
- Liên kết lịch/deadline
- Theo dõi tiến độ

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Kế hoạch có mốc thời gian
- Tiến độ từ task/deadline liên quan

### Tests

- Tạo kế hoạch
- liên kết deadline
- không có deadline

### Risks / open questions

- TASK-RISK01
- TASK-RISK02
- TASK-RISK03
