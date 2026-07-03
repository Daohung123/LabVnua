# CLASS_SESSION-CASE-09 - Trang chi tiết buổi học

- `STATUS:` Draft DD v0.1
- `MODULE:` CLASS_SESSION - Buổi học
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 4.1
- `FEATURE:` CLASS_SESSION-F01
- `FUNCTION:` CLASS_SESSION-FN01
- `VIEW:` CLASS_SESSION-V01
- `ROLES:` Sinh viên, Giảng viên

## Mục tiêu

Trang chi tiết buổi học được thiết kế như một case riêng trong module `CLASS_SESSION` và trace trực tiếp tới bảng ưu tiên BD dòng 9.

## Entry point

Click một tiết học từ lịch

## Luồng chính

- Nhận mã buổi học
- Tải thông tin
- Render chức năng theo role

## Dữ liệu / API / state

- Tên môn
- Mã học phần
- Giảng viên
- Thời gian
- Phòng
- Trạng thái

Tích hợp liên quan:

- CLASS_SESSION-API01: schedule/detail source
- CLASS_SESSION-API02: STT provider
- CLASS_SESSION-API03: quiz backend
- CLASS_SESSION-API04: AI transcript Q&A

## UI / component

- View chính: CLASS_SESSION-V01.
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

- Thông tin đủ
- Chức năng không phù hợp role không xuất hiện

## Test scenarios

- SV xem
- GV xem
- thiếu phòng

## Open questions / risks

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## Traceability

| Item | ID |
|---|---|
| BD row | 9 |
| Case | CLASS_SESSION-CASE-09 |
| Feature | CLASS_SESSION-F01 |
| Function | CLASS_SESSION-FN01 |
| View | CLASS_SESSION-V01 |
| Source | BD 4.1 |
