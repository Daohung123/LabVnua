# CLASS_SESSION-CASE-13 - Thống kê người trả lời quiz

- `STATUS:` Draft DD v0.1
- `MODULE:` CLASS_SESSION - Buổi học
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 4.3
- `FEATURE:` CLASS_SESSION-F05
- `FUNCTION:` CLASS_SESSION-FN05
- `VIEW:` CLASS_SESSION-V05
- `ROLES:` Giảng viên

## Mục tiêu

Thống kê người trả lời quiz được thiết kế như một case riêng trong module `CLASS_SESSION` và trace trực tiếp tới bảng ưu tiên BD dòng 13.

## Entry point

Màn thống kê quiz

## Luồng chính

- Thu submission
- Tổng hợp đã/chưa nộp/điểm TB
- Hiển thị realtime hoặc refresh

## Dữ liệu / API / state

- Submission
- Điểm
- Trạng thái nộp
- Danh sách lớp

Tích hợp liên quan:

- CLASS_SESSION-API01: schedule/detail source
- CLASS_SESSION-API02: STT provider
- CLASS_SESSION-API03: quiz backend
- CLASS_SESSION-API04: AI transcript Q&A

## UI / component

- View chính: CLASS_SESSION-V05.
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

- GV biết ai đã/chưa nộp
- Điểm TB từ submission hợp lệ

## Test scenarios

- Không ai nộp
- một phần lớp nộp
- submission trễ

## Open questions / risks

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## Traceability

| Item | ID |
|---|---|
| BD row | 13 |
| Case | CLASS_SESSION-CASE-13 |
| Feature | CLASS_SESSION-F05 |
| Function | CLASS_SESSION-FN05 |
| View | CLASS_SESSION-V05 |
| Source | BD 4.3 |
