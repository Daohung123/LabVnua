# CLASS_SESSION-CASE-29 - Điều phối trong buổi học

- `STATUS:` Draft DD v0.1
- `MODULE:` CLASS_SESSION - Buổi học
- `PRIORITY:` P2
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 4.1
- `FEATURE:` CLASS_SESSION-F09
- `FUNCTION:` CLASS_SESSION-FN09
- `VIEW:` CLASS_SESSION-V09
- `ROLES:` Giảng viên

## Mục tiêu

Điều phối trong buổi học được thiết kế như một case riêng trong module `CLASS_SESSION` và trace trực tiếp tới bảng ưu tiên BD dòng 29.

## Entry point

Trong chi tiết buổi học

## Luồng chính

- GV chia nhóm/phân công
- SV nhận phân công
- Lưu trạng thái

## Dữ liệu / API / state

- Nhóm
- Phân công
- Danh sách sinh viên
- Mã buổi học

Tích hợp liên quan:

- CLASS_SESSION-API01: schedule/detail source
- CLASS_SESSION-API02: STT provider
- CLASS_SESSION-API03: quiz backend
- CLASS_SESSION-API04: AI transcript Q&A

## UI / component

- View chính: CLASS_SESSION-V09.
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

- Phân công đúng buổi
- SV thấy nhiệm vụ

## Test scenarios

- Chia nhóm
- sửa phân công
- thiếu danh sách lớp

## Open questions / risks

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## Traceability

| Item | ID |
|---|---|
| BD row | 29 |
| Case | CLASS_SESSION-CASE-29 |
| Feature | CLASS_SESSION-F09 |
| Function | CLASS_SESSION-FN09 |
| View | CLASS_SESSION-V09 |
| Source | BD 4.1 |
