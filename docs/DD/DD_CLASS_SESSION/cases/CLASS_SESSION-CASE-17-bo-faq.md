# CLASS_SESSION-CASE-17 - Bộ FAQ

- `STATUS:` Draft DD v0.1
- `MODULE:` CLASS_SESSION - Buổi học
- `PRIORITY:` P1
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 4.4
- `FEATURE:` CLASS_SESSION-F07
- `FUNCTION:` CLASS_SESSION-FN07
- `VIEW:` CLASS_SESSION-V07
- `ROLES:` Giảng viên, AI

## Mục tiêu

Bộ FAQ được thiết kế như một case riêng trong module `CLASS_SESSION` và trace trực tiếp tới bảng ưu tiên BD dòng 17.

## Entry point

Quản lý Q&A/FAQ

## Luồng chính

- Xác định câu phổ biến
- Đưa vào FAQ
- Gợi ý khi câu tương tự

## Dữ liệu / API / state

- FAQ item
- Nguồn câu hỏi
- Tần suất
- Trạng thái duyệt

Tích hợp liên quan:

- CLASS_SESSION-API01: schedule/detail source
- CLASS_SESSION-API02: STT provider
- CLASS_SESSION-API03: quiz backend
- CLASS_SESSION-API04: AI transcript Q&A

## UI / component

- View chính: CLASS_SESSION-V07.
- UI phải có loading, empty, error, permission denied và success state khi phù hợp.
- Copy hiển thị bằng tiếng Việt, bám terminology trong BD.

## Validation và permission

- Roles được phép: Giảng viên, AI.
- Kiểm tra dữ liệu bắt buộc trước khi submit.
- Kiểm tra quyền truy cập entity theo user/session hiện tại.
- Không gửi request hoặc ghi local state khi validation fail.

## Error handling

- Lỗi network/service hiển thị message an toàn.
- Thiếu contract phải được giữ ở `OPEN_QUESTION`, không hard-code behavior nghiệp vụ.
- Không log token, password, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.

## Acceptance criteria

- FAQ không tự publish nếu chưa có rule
- Gợi ý không mất câu hỏi gốc

## Test scenarios

- Tạo FAQ
- gợi ý
- câu không liên quan

## Open questions / risks

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## Traceability

| Item | ID |
|---|---|
| BD row | 17 |
| Case | CLASS_SESSION-CASE-17 |
| Feature | CLASS_SESSION-F07 |
| Function | CLASS_SESSION-FN07 |
| View | CLASS_SESSION-V07 |
| Source | BD 4.4 |
