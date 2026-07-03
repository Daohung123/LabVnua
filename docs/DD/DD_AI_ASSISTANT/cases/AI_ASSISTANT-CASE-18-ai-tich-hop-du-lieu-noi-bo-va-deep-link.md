# AI_ASSISTANT-CASE-18 - AI tích hợp dữ liệu nội bộ và deep link

- `STATUS:` Draft DD v0.1
- `MODULE:` AI_ASSISTANT - AI trợ lý
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 6.2, 6.3, 10.4
- `FEATURE:` AI_ASSISTANT-F01
- `FUNCTION:` AI_ASSISTANT-FN01
- `VIEW:` AI_ASSISTANT-V01
- `ROLES:` Sinh viên, Giảng viên

## Mục tiêu

AI tích hợp dữ liệu nội bộ và deep link được thiết kế như một case riêng trong module `AI_ASSISTANT` và trace trực tiếp tới bảng ưu tiên BD dòng 18.

## Entry point

Mở AI từ navigation hoặc dialog

## Luồng chính

- Người dùng hỏi
- Resolver lấy context được phép
- AI trả lời kèm action

## Dữ liệu / API / state

- User context
- Entity mapping
- AI response
- Navigate action

Tích hợp liên quan:

- AI_ASSISTANT-API01: Gemini
- AI_ASSISTANT-API02: internal context resolver
- AI_ASSISTANT-API03: STT
- AI_ASSISTANT-API04: deep link/action router

## UI / component

- View chính: AI_ASSISTANT-V01.
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

- Không cần nhập ID thủ công
- Action chỉ chạy khi hợp lệ

## Test scenarios

- Hỏi deadline tuần này
- hỏi dữ liệu không có quyền
- action invalid

## Open questions / risks

- AI_ASSISTANT-RISK01
- AI_ASSISTANT-RISK02
- AI_ASSISTANT-RISK03
- AI_ASSISTANT-RISK04

## Traceability

| Item | ID |
|---|---|
| BD row | 18 |
| Case | AI_ASSISTANT-CASE-18 |
| Feature | AI_ASSISTANT-F01 |
| Function | AI_ASSISTANT-FN01 |
| View | AI_ASSISTANT-V01 |
| Source | BD 6.2, 6.3, 10.4 |
