# CLASS_SESSION-CASE-28 - Giao diện giảng viên đơn giản

- `STATUS:` Draft DD v0.1
- `MODULE:` CLASS_SESSION - Buổi học
- `PRIORITY:` P1
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 1.2, 4.1
- `FEATURE:` CLASS_SESSION-F08
- `FUNCTION:` CLASS_SESSION-FN08
- `VIEW:` CLASS_SESSION-V08
- `ROLES:` Giảng viên

## Mục tiêu

Giao diện giảng viên đơn giản được thiết kế như một case riêng trong module `CLASS_SESSION` và trace trực tiếp tới bảng ưu tiên BD dòng 28.

## Entry point

Giảng viên vào app hoặc buổi học

## Luồng chính

- Hiển thị tác vụ GV chính
- Giảm nhiễu chức năng SV
- Ưu tiên tạo đề/ghi âm/thống kê/điểm danh

## Dữ liệu / API / state

- Role giảng viên
- Danh sách tác vụ

Tích hợp liên quan:

- CLASS_SESSION-API01: schedule/detail source
- CLASS_SESSION-API02: STT provider
- CLASS_SESSION-API03: quiz backend
- CLASS_SESSION-API04: AI transcript Q&A

## UI / component

- View chính: CLASS_SESSION-V08.
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

- GV thấy UI đơn giản
- Không thấy tác vụ chỉ SV

## Test scenarios

- Role GV
- role SV
- role invalid

## Open questions / risks

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## Traceability

| Item | ID |
|---|---|
| BD row | 28 |
| Case | CLASS_SESSION-CASE-28 |
| Feature | CLASS_SESSION-F08 |
| Function | CLASS_SESSION-FN08 |
| View | CLASS_SESSION-V08 |
| Source | BD 1.2, 4.1 |
