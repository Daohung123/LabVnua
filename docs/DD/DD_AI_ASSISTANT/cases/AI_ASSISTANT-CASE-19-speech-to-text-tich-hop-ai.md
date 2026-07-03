# AI_ASSISTANT-CASE-19 - Speech-to-Text tích hợp AI

- `STATUS:` Draft DD v0.1
- `MODULE:` AI_ASSISTANT - AI trợ lý
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 6.2, 10.3
- `FEATURE:` AI_ASSISTANT-F02
- `FUNCTION:` AI_ASSISTANT-FN02
- `VIEW:` AI_ASSISTANT-V02
- `ROLES:` Sinh viên, Giảng viên

## Mục tiêu

Speech-to-Text tích hợp AI được thiết kế như một case riêng trong module `AI_ASSISTANT` và trace trực tiếp tới bảng ưu tiên BD dòng 19.

## Entry point

Nút nhập giọng nói trong AI

## Luồng chính

- Ghi âm câu hỏi
- STT thành text tiếng Việt
- Gửi text vào AI

## Dữ liệu / API / state

- Audio input
- Transcript text
- Locale
- Error state

Tích hợp liên quan:

- AI_ASSISTANT-API01: Gemini
- AI_ASSISTANT-API02: internal context resolver
- AI_ASSISTANT-API03: STT
- AI_ASSISTANT-API04: deep link/action router

## UI / component

- View chính: AI_ASSISTANT-V02.
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

- Có trạng thái quyền mic/ghi âm/xử lý/lỗi
- Transcript kiểm soát được

## Test scenarios

- Cấp/từ chối mic
- STT thành công
- STT lỗi mạng

## Open questions / risks

- AI_ASSISTANT-RISK01
- AI_ASSISTANT-RISK02
- AI_ASSISTANT-RISK03
- AI_ASSISTANT-RISK04

## Traceability

| Item | ID |
|---|---|
| BD row | 19 |
| Case | AI_ASSISTANT-CASE-19 |
| Feature | AI_ASSISTANT-F02 |
| Function | AI_ASSISTANT-FN02 |
| View | AI_ASSISTANT-V02 |
| Source | BD 6.2, 10.3 |
