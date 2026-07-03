# Diagrams - AI trợ lý

- `STATUS:` Evidence-only notes for future diagrams.
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD sections 6, 10.3, 10.4, rows 18-20

## Diagram candidates

- Flow diagram cho các case trong `AI_ASSISTANT`.
- State diagram cho trạng thái: Idle; Đang nhận input; Đang gọi AI; Có câu trả lời; Có action điều hướng; Lỗi AI/STT; Không đủ quyền dữ liệu.
- Integration diagram cho: AI_ASSISTANT-API01, AI_ASSISTANT-API02, AI_ASSISTANT-API03, AI_ASSISTANT-API04.

## Rule

Chỉ thêm diagram khi có source evidence hoặc task sau yêu cầu cụ thể. Không vẽ contract API/schema chưa xác minh như sự thật đã phê duyệt.
