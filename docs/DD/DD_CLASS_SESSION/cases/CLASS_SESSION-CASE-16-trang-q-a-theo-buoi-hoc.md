# CLASS_SESSION-CASE-16 - Trang Q&A theo buổi học

- `STATUS:` Draft DD v0.1
- `MODULE:` CLASS_SESSION - Buổi học
- `PRIORITY:` P1
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 4.4
- `FEATURE:` CLASS_SESSION-F06
- `FUNCTION:` CLASS_SESSION-FN06
- `VIEW:` CLASS_SESSION-V06
- `ROLES:` Sinh viên, Giảng viên, AI

## Mục tiêu

Trang Q&A theo buổi học được thiết kế như một case riêng trong module `CLASS_SESSION` và trace trực tiếp tới bảng ưu tiên BD dòng 16.

## Entry point

Tab Q&A trong chi tiết buổi học

## Luồng chính

- Sinh viên hỏi text/voice
- GV/AI trả lời
- Upvote câu hỏi

## Dữ liệu / API / state

- Question
- Answer
- Upvote
- Transcript reference
- Mã buổi học

Tích hợp liên quan:

- CLASS_SESSION-API01: schedule/detail source
- CLASS_SESSION-API02: STT provider
- CLASS_SESSION-API03: quiz backend
- CLASS_SESSION-API04: AI transcript Q&A

## UI / component

- View chính: CLASS_SESSION-V06.
- UI phải có loading, empty, error, permission denied và success state khi phù hợp.
- Copy hiển thị bằng tiếng Việt, bám terminology trong BD.

## Validation và permission

- Roles được phép: Sinh viên, Giảng viên, AI.
- Kiểm tra dữ liệu bắt buộc trước khi submit.
- Kiểm tra quyền truy cập entity theo user/session hiện tại.
- Không gửi request hoặc ghi local state khi validation fail.

## Error handling

- Lỗi network/service hiển thị message an toàn.
- Thiếu contract phải được giữ ở `OPEN_QUESTION`, không hard-code behavior nghiệp vụ.
- Không log token, password, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.

## Acceptance criteria

- Mỗi buổi có thread riêng
- Câu hỏi gắn đúng context

## Test scenarios

- Tạo câu hỏi
- trả lời
- upvote
- câu hỏi từ audio

## Open questions / risks

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## Traceability

| Item | ID |
|---|---|
| BD row | 16 |
| Case | CLASS_SESSION-CASE-16 |
| Feature | CLASS_SESSION-F06 |
| Function | CLASS_SESSION-FN06 |
| View | CLASS_SESSION-V06 |
| Source | BD 4.4 |
