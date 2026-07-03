# AI_ASSISTANT-CASE-20 - Thay Chat bằng AI trên navigation

- `STATUS:` Draft DD v0.1
- `MODULE:` AI_ASSISTANT - AI trợ lý
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 6.1
- `FEATURE:` AI_ASSISTANT-F03
- `FUNCTION:` AI_ASSISTANT-FN03
- `VIEW:` AI_ASSISTANT-V03
- `ROLES:` Người dùng đã đăng nhập

## Mục tiêu

Thay Chat bằng AI trên navigation được thiết kế như một case riêng trong module `AI_ASSISTANT` và trace trực tiếp tới bảng ưu tiên BD dòng 20.

## Entry point

Bottom navigation/main shell

## Luồng chính

- Đổi Chat thành AI
- Mở AI từ tab
- Chuyển nhắn tin đối tác nếu còn dùng

## Dữ liệu / API / state

- Navigation item
- AI screen/dialog state

Tích hợp liên quan:

- AI_ASSISTANT-API01: Gemini
- AI_ASSISTANT-API02: internal context resolver
- AI_ASSISTANT-API03: STT
- AI_ASSISTANT-API04: deep link/action router

## UI / component

- View chính: AI_ASSISTANT-V03.
- UI phải có loading, empty, error, permission denied và success state khi phù hợp.
- Copy hiển thị bằng tiếng Việt, bám terminology trong BD.

## Validation và permission

- Roles được phép: Người dùng đã đăng nhập.
- Kiểm tra dữ liệu bắt buộc trước khi submit.
- Kiểm tra quyền truy cập entity theo user/session hiện tại.
- Không gửi request hoặc ghi local state khi validation fail.

## Error handling

- Lỗi network/service hiển thị message an toàn.
- Thiếu contract phải được giữ ở `OPEN_QUESTION`, không hard-code behavior nghiệp vụ.
- Không log token, password, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.

## Acceptance criteria

- Navigation hiển thị AI
- Không mất lối vào chat đối tác nếu business còn cần

## Test scenarios

- Tap AI nav
- back/close AI
- kiểm tra tab chat cũ

## Open questions / risks

- AI_ASSISTANT-RISK01
- AI_ASSISTANT-RISK02
- AI_ASSISTANT-RISK03
- AI_ASSISTANT-RISK04

## Traceability

| Item | ID |
|---|---|
| BD row | 20 |
| Case | AI_ASSISTANT-CASE-20 |
| Feature | AI_ASSISTANT-F03 |
| Function | AI_ASSISTANT-FN03 |
| View | AI_ASSISTANT-V03 |
| Source | BD 6.1 |
