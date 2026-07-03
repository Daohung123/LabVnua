# Diagrams - Đăng ký tạm trú / tạm vắng

- `STATUS:` Evidence-only notes for future diagrams.
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD section 9, row 25

## Diagram candidates

- Flow diagram cho các case trong `RESIDENCE`.
- State diagram cho trạng thái: Draft; Đã tạo mã; Đã xuất PDF; Đã xác minh; Hết hạn token; Bị từ chối nếu có workflow duyệt.
- Integration diagram cho: RESIDENCE-API01, RESIDENCE-API02, RESIDENCE-API03.

## Rule

Chỉ thêm diagram khi có source evidence hoặc task sau yêu cầu cụ thể. Không vẽ contract API/schema chưa xác minh như sự thật đã phê duyệt.
