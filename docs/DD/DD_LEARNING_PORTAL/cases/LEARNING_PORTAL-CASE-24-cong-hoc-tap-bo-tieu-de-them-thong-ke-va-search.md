# LEARNING_PORTAL-CASE-24 - Cổng học tập: bỏ tiêu đề, thêm thống kê và search

- `STATUS:` Draft DD v0.1
- `MODULE:` LEARNING_PORTAL - Cổng học tập
- `PRIORITY:` P1
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 8.1, 8.2
- `FEATURE:` LEARNING_PORTAL-F01
- `FUNCTION:` LEARNING_PORTAL-FN01
- `VIEW:` LEARNING_PORTAL-V01
- `ROLES:` Sinh viên

## Mục tiêu

Cổng học tập: bỏ tiêu đề, thêm thống kê và search được thiết kế như một case riêng trong module `LEARNING_PORTAL` và trace trực tiếp tới bảng ưu tiên BD dòng 24.

## Entry point

Tab học tập/cổng học tập

## Luồng chính

- Tải môn/thống kê
- Render thống kê
- Search/filter/click môn

## Dữ liệu / API / state

- Môn học
- Học kỳ
- Trạng thái môn
- Điểm
- Lịch
- Tài liệu
- Deadline

Tích hợp liên quan:

- LEARNING_PORTAL-API01: training program
- LEARNING_PORTAL-API02: score
- LEARNING_PORTAL-API03: schedule
- LEARNING_PORTAL-API04: document/deadline source

## UI / component

- View chính: LEARNING_PORTAL-V01.
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

- Có số môn hoàn thành/đang học/trượt
- Search trong phạm vi có nguồn

## Test scenarios

- Đủ dữ liệu
- không có môn trượt
- search empty
- click môn

## Open questions / risks

- LEARNING_PORTAL-RISK01
- LEARNING_PORTAL-RISK02

## Traceability

| Item | ID |
|---|---|
| BD row | 24 |
| Case | LEARNING_PORTAL-CASE-24 |
| Feature | LEARNING_PORTAL-F01 |
| Function | LEARNING_PORTAL-FN01 |
| View | LEARNING_PORTAL-V01 |
| Source | BD 8.1, 8.2 |
