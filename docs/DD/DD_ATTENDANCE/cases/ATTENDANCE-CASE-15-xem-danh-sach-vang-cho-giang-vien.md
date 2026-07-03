# ATTENDANCE-CASE-15 - Xem danh sách vắng cho giảng viên

- `STATUS:` Draft DD v0.1
- `MODULE:` ATTENDANCE - Điểm danh
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 5.1
- `FEATURE:` ATTENDANCE-F02
- `FUNCTION:` ATTENDANCE-FN02
- `VIEW:` ATTENDANCE-V02
- `ROLES:` Giảng viên

## Mục tiêu

Xem danh sách vắng cho giảng viên được thiết kế như một case riêng trong module `ATTENDANCE` và trace trực tiếp tới bảng ưu tiên BD dòng 15.

## Entry point

Giảng viên mở màn điểm danh buổi học

## Luồng chính

- Tải roster
- Gộp trạng thái
- Điểm danh thủ công/xuất báo cáo

## Dữ liệu / API / state

- Danh sách lớp
- Attendance record
- Khoảng báo cáo

Tích hợp liên quan:

- ATTENDANCE-API01: QR generation/verification
- ATTENDANCE-API02: attendance report export

## UI / component

- View chính: ATTENDANCE-V02.
- UI phải có loading, empty, error, permission denied và success state khi phù hợp.
- Copy hiển thị bằng tiếng Việt, bám terminology trong BD.

## Validation và permission

- Roles được phép: Giảng viên.
- Kiểm tra dữ liệu bắt buộc trước khi submit.
- Kiểm tra quyền truy cập entity theo user/session hiện tại.
- Không gửi request hoặc ghi local state khi validation fail.

## Error handling

- Lỗi network/service hiển thị message an toàn.
- Thiếu contract phải được giữ ở `OPEN_QUESTION`, không hard-code behavior nghiệp vụ.
- Không log token, password, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.

## Acceptance criteria

- Danh sách trạng thái rõ
- Điểm danh thủ công có audit tối thiểu

## Test scenarios

- Roster đủ
- chưa xử lý
- export buổi/tuần/tháng

## Open questions / risks

- ATTENDANCE-RISK01
- ATTENDANCE-RISK02
- ATTENDANCE-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 15 |
| Case | ATTENDANCE-CASE-15 |
| Feature | ATTENDANCE-F02 |
| Function | ATTENDANCE-FN02 |
| View | ATTENDANCE-V02 |
| Source | BD 5.1 |
