# TASK-CASE-21 - Todo online và offline

- `STATUS:` Draft DD v0.1
- `MODULE:` TASK - Todo và đầu việc
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 7.1, 10.1
- `FEATURE:` TASK-F01
- `FUNCTION:` TASK-FN01
- `VIEW:` TASK-V01
- `ROLES:` Sinh viên, Giảng viên

## Mục tiêu

Todo online và offline được thiết kế như một case riêng trong module `TASK` và trace trực tiếp tới bảng ưu tiên BD dòng 21.

## Entry point

Mở module Todo/Đầu việc

## Luồng chính

- Tạo/sửa/xóa
- Phân loại Online/Offline
- Lưu local và sync

## Dữ liệu / API / state

- Title
- Description
- Type
- Course/session link
- Sync status

Tích hợp liên quan:

- TASK-API01: task sync
- TASK-API02: file upload/submission
- TASK-API03: PDF/Word export

## UI / component

- View chính: TASK-V01.
- UI phải có loading, empty, error, permission denied và success state khi phù hợp.
- Copy hiển thị bằng tiếng Việt, bám terminology trong BD.

## Validation và permission

- Roles được phép: Sinh viên, Giảng viên.
- Kiểm tra dữ liệu bắt buộc trước khi submit.
- Kiểm tra quyền truy cập entity theo user/session hiện tại.
- Không gửi request hoặc ghi local state khi validation fail.

## Error handling

- Lỗi network/service hiển thị message an toàn.
- Thiếu contract phải được giữ ở `OPEN_QUESTION`, không hard-code behavior nghiệp vụ.
- Không log token, password, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.

## Acceptance criteria

- Todo hoạt động offline
- Sync state rõ khi có mạng

## Test scenarios

- CRUD online
- CRUD offline
- conflict

## Open questions / risks

- TASK-RISK01
- TASK-RISK02
- TASK-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 21 |
| Case | TASK-CASE-21 |
| Feature | TASK-F01 |
| Function | TASK-FN01 |
| View | TASK-V01 |
| Source | BD 7.1, 10.1 |
