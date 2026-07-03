# CLASS_SESSION-CASE-12 - Quiz / ra đề bằng text và giọng nói

- `STATUS:` Draft DD v0.1
- `MODULE:` CLASS_SESSION - Buổi học
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 4.3
- `FEATURE:` CLASS_SESSION-F04
- `FUNCTION:` CLASS_SESSION-FN04
- `VIEW:` CLASS_SESSION-V04
- `ROLES:` Giảng viên tạo, Sinh viên làm

## Mục tiêu

Quiz / ra đề bằng text và giọng nói được thiết kế như một case riêng trong module `CLASS_SESSION` và trace trực tiếp tới bảng ưu tiên BD dòng 12.

## Entry point

Chức năng quiz trong buổi học

## Luồng chính

- Tạo câu hỏi text/voice
- Cấu trúc hóa đề
- Publish cho sinh viên

## Dữ liệu / API / state

- Câu hỏi
- Loại câu hỏi
- Đáp án
- Trạng thái publish
- Mã buổi học

Tích hợp liên quan:

- CLASS_SESSION-API01: schedule/detail source
- CLASS_SESSION-API02: STT provider
- CLASS_SESSION-API03: quiz backend
- CLASS_SESSION-API04: AI transcript Q&A

## UI / component

- View chính: CLASS_SESSION-V04.
- UI phải có loading, empty, error, permission denied và success state khi phù hợp.
- Copy hiển thị bằng tiếng Việt, bám terminology trong BD.

## Validation và permission

- Roles được phép: Giảng viên tạo, Sinh viên làm.
- Kiểm tra dữ liệu bắt buộc trước khi submit.
- Kiểm tra quyền truy cập entity theo user/session hiện tại.
- Không gửi request hoặc ghi local state khi validation fail.

## Error handling

- Lỗi network/service hiển thị message an toàn.
- Thiếu contract phải được giữ ở `OPEN_QUESTION`, không hard-code behavior nghiệp vụ.
- Không log token, password, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.

## Acceptance criteria

- Hỗ trợ loại câu hỏi trong BD
- Sinh viên chỉ thấy quiz đã publish

## Test scenarios

- Tạo quiz text
- quiz voice
- publish/unpublish

## Open questions / risks

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## Traceability

| Item | ID |
|---|---|
| BD row | 12 |
| Case | CLASS_SESSION-CASE-12 |
| Feature | CLASS_SESSION-F04 |
| Function | CLASS_SESSION-FN04 |
| View | CLASS_SESSION-V04 |
| Source | BD 4.3 |
