# CLASS_SESSION-CASE-10 - Ghi chú và ghi âm trong buổi học

- `STATUS:` Draft DD v0.1
- `MODULE:` CLASS_SESSION - Buổi học
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 4.1, 4.2
- `FEATURE:` CLASS_SESSION-F02
- `FUNCTION:` CLASS_SESSION-FN02
- `VIEW:` CLASS_SESSION-V02
- `ROLES:` Sinh viên, Giảng viên

## Mục tiêu

Ghi chú và ghi âm trong buổi học được thiết kế như một case riêng trong module `CLASS_SESSION` và trace trực tiếp tới bảng ưu tiên BD dòng 10.

## Entry point

Trong trang chi tiết buổi học

## Luồng chính

- Tạo ghi chú
- Bắt đầu/dừng ghi âm
- Lưu vào storage phê duyệt

## Dữ liệu / API / state

- Nội dung ghi chú
- Audio metadata
- Mã buổi học
- Owner

Tích hợp liên quan:

- CLASS_SESSION-API01: schedule/detail source
- CLASS_SESSION-API02: STT provider
- CLASS_SESSION-API03: quiz backend
- CLASS_SESSION-API04: AI transcript Q&A

## UI / component

- View chính: CLASS_SESSION-V02.
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

- Ghi chú đúng buổi/owner
- Ghi âm có trạng thái và không mất dữ liệu khi lỗi

## Test scenarios

- CRUD ghi chú
- start/stop recording
- lỗi microphone

## Open questions / risks

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## Traceability

| Item | ID |
|---|---|
| BD row | 10 |
| Case | CLASS_SESSION-CASE-10 |
| Feature | CLASS_SESSION-F02 |
| Function | CLASS_SESSION-FN02 |
| View | CLASS_SESSION-V02 |
| Source | BD 4.1, 4.2 |
