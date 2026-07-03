# TASK-CASE-22 - Nộp bài / giao bài / tạo báo cáo

- `STATUS:` Draft DD v0.1
- `MODULE:` TASK - Todo và đầu việc
- `PRIORITY:` P1
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 7.2
- `FEATURE:` TASK-F02
- `FUNCTION:` TASK-FN02
- `VIEW:` TASK-V02
- `ROLES:` Sinh viên, Giảng viên

## Mục tiêu

Nộp bài / giao bài / tạo báo cáo được thiết kế như một case riêng trong module `TASK` và trace trực tiếp tới bảng ưu tiên BD dòng 22.

## Entry point

Deadline hoặc module đầu việc

## Luồng chính

- GV giao bài
- SV upload
- SV tạo báo cáo PDF/Word

## Dữ liệu / API / state

- Assignment
- Deadline
- Attachment
- Submission
- Report form

Tích hợp liên quan:

- TASK-API01: task sync
- TASK-API02: file upload/submission
- TASK-API03: PDF/Word export

## UI / component

- View chính: TASK-V02.
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

- SV xem trạng thái nộp
- GV giao bài có deadline
- Báo cáo theo mẫu phê duyệt

## Test scenarios

- Upload ok/lỗi
- quá hạn
- export PDF/Word

## Open questions / risks

- TASK-RISK01
- TASK-RISK02
- TASK-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 22 |
| Case | TASK-CASE-22 |
| Feature | TASK-F02 |
| Function | TASK-FN02 |
| View | TASK-V02 |
| Source | BD 7.2 |
