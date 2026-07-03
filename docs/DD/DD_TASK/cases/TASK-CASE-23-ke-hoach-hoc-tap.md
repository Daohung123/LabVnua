# TASK-CASE-23 - Kế hoạch học tập

- `STATUS:` Draft DD v0.1
- `MODULE:` TASK - Todo và đầu việc
- `PRIORITY:` P1
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 7.3
- `FEATURE:` TASK-F03
- `FUNCTION:` TASK-FN03
- `VIEW:` TASK-V03
- `ROLES:` Sinh viên

## Mục tiêu

Kế hoạch học tập được thiết kế như một case riêng trong module `TASK` và trace trực tiếp tới bảng ưu tiên BD dòng 23.

## Entry point

Module học tập hoặc Todo

## Luồng chính

- Tạo kế hoạch
- Liên kết lịch/deadline
- Theo dõi tiến độ

## Dữ liệu / API / state

- Study plan
- Term/year
- Linked schedule
- Linked deadline
- Progress

Tích hợp liên quan:

- TASK-API01: task sync
- TASK-API02: file upload/submission
- TASK-API03: PDF/Word export

## UI / component

- View chính: TASK-V03.
- UI phải có loading, empty, error, permission denied và success state khi phù hợp.
- Copy hiển thị bằng tiếng Việt, bám terminology trong BD.

## Validation và permission

- Roles được phép: Sinh viên.
- Kiểm tra dữ liệu bắt buộc trước khi submit.
- Kiểm tra quyền truy cập entity theo user/session hiện tại.
- Không gửi request hoặc ghi local state khi validation fail.

## Error handling

- Lỗi network/service hiển thị message an toàn.
- Thiếu contract phải được giữ ở `OPEN_QUESTION`, không hard-code behavior nghiệp vụ.
- Không log token, password, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.

## Acceptance criteria

- Kế hoạch có mốc thời gian
- Tiến độ từ task/deadline liên quan

## Test scenarios

- Tạo kế hoạch
- liên kết deadline
- không có deadline

## Open questions / risks

- TASK-RISK01
- TASK-RISK02
- TASK-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 23 |
| Case | TASK-CASE-23 |
| Feature | TASK-F03 |
| Function | TASK-FN03 |
| View | TASK-V03 |
| Source | BD 7.3 |
