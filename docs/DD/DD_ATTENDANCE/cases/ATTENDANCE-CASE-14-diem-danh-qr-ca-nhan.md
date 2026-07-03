# ATTENDANCE-CASE-14 - Điểm danh QR cá nhân

- `STATUS:` Draft DD v0.1
- `MODULE:` ATTENDANCE - Điểm danh
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 5.1
- `FEATURE:` ATTENDANCE-F01
- `FUNCTION:` ATTENDANCE-FN01
- `VIEW:` ATTENDANCE-V01
- `ROLES:` Sinh viên, Giảng viên, Cán bộ

## Mục tiêu

Điểm danh QR cá nhân được thiết kế như một case riêng trong module `ATTENDANCE` và trace trực tiếp tới bảng ưu tiên BD dòng 14.

## Entry point

Sinh viên mở buổi học và chọn Sinh QR điểm danh

## Luồng chính

- Sinh QR
- Người điểm danh quét QR
- Xác nhận trong thời hạn

## Dữ liệu / API / state

- Student ID
- Mã buổi học
- Timestamp
- Trạng thái xác nhận

Tích hợp liên quan:

- ATTENDANCE-API01: QR generation/verification
- ATTENDANCE-API02: attendance report export

## UI / component

- View chính: ATTENDANCE-V01.
- UI phải có loading, empty, error, permission denied và success state khi phù hợp.
- Copy hiển thị bằng tiếng Việt, bám terminology trong BD.

## Validation và permission

- Roles được phép: Sinh viên, Giảng viên, Cán bộ.
- Kiểm tra dữ liệu bắt buộc trước khi submit.
- Kiểm tra quyền truy cập entity theo user/session hiện tại.
- Không gửi request hoặc ghi local state khi validation fail.

## Error handling

- Lỗi network/service hiển thị message an toàn.
- Thiếu contract phải được giữ ở `OPEN_QUESTION`, không hard-code behavior nghiệp vụ.
- Không log token, password, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.

## Acceptance criteria

- QR hết hạn không hợp lệ
- QR hợp lệ ghi đúng người/buổi

## Test scenarios

- QR hợp lệ
- hết hạn
- sai buổi
- quét trùng

## Open questions / risks

- ATTENDANCE-RISK01
- ATTENDANCE-RISK02
- ATTENDANCE-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 14 |
| Case | ATTENDANCE-CASE-14 |
| Feature | ATTENDANCE-F01 |
| Function | ATTENDANCE-FN01 |
| View | ATTENDANCE-V01 |
| Source | BD 5.1 |
