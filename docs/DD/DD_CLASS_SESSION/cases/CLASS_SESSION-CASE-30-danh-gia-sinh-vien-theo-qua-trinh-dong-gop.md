# CLASS_SESSION-CASE-30 - Đánh giá sinh viên theo quá trình đóng góp

- `STATUS:` Draft DD v0.1
- `MODULE:` CLASS_SESSION - Buổi học
- `PRIORITY:` P2
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 4.1
- `FEATURE:` CLASS_SESSION-F10
- `FUNCTION:` CLASS_SESSION-FN10
- `VIEW:` CLASS_SESSION-V10
- `ROLES:` Giảng viên

## Mục tiêu

Đánh giá sinh viên theo quá trình đóng góp được thiết kế như một case riêng trong module `CLASS_SESSION` và trace trực tiếp tới bảng ưu tiên BD dòng 30.

## Entry point

Màn đánh giá trong buổi học

## Luồng chính

- Tổng hợp đóng góp
- GV xem/chỉnh
- Lưu đánh giá

## Dữ liệu / API / state

- Đóng góp
- Điểm/nhận xét
- Nguồn sự kiện

Tích hợp liên quan:

- CLASS_SESSION-API01: schedule/detail source
- CLASS_SESSION-API02: STT provider
- CLASS_SESSION-API03: quiz backend
- CLASS_SESSION-API04: AI transcript Q&A

## UI / component

- View chính: CLASS_SESSION-V10.
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

- Đánh giá trace được nguồn
- Không tự quyết điểm khi chưa có rule

## Test scenarios

- Nhiều nguồn
- không có dữ liệu
- GV chỉnh nhận xét

## Open questions / risks

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## Traceability

| Item | ID |
|---|---|
| BD row | 30 |
| Case | CLASS_SESSION-CASE-30 |
| Feature | CLASS_SESSION-F10 |
| Function | CLASS_SESSION-FN10 |
| View | CLASS_SESSION-V10 |
| Source | BD 4.1 |
