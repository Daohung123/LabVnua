# HOME-CASE-06 - Deadline phần 2

- `STATUS:` Draft DD v0.1
- `MODULE:` HOME - Trang chủ
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 3.2
- `FEATURE:` HOME-F03
- `FUNCTION:` HOME-FN03
- `VIEW:` HOME-V03
- `ROLES:` Sinh viên

## Mục tiêu

Deadline phần 2 được thiết kế như một case riêng trong module `HOME` và trace trực tiếp tới bảng ưu tiên BD dòng 6.

## Entry point

Khối Deadline trên Home

## Luồng chính

- Lấy deadline
- Sắp xếp hạn gần nhất
- Click vào nộp bài/đầu việc

## Dữ liệu / API / state

- Tên nhiệm vụ
- Môn học
- Ngày hết hạn
- Trạng thái nộp

Tích hợp liên quan:

- HOME-API01: VNUA schedule
- HOME-API02: notification/cache
- HOME-API03: analytics event source

## UI / component

- View chính: HOME-V03.
- UI phải có loading, empty, error, permission denied và success state khi phù hợp.
- Copy hiển thị bằng tiếng Việt, bám terminology trong BD.

## Validation và permission

- Roles được phép: Sinh viên.
- Kiểm tra dữ liệu bắt buộc trước khi submit.
- Kiểm tra quyền truy cập entity theo user/session hiện tại.
- Không gửi request hoặc ghi local state khi validation fail.

## Error handling

- Lỗi network/service hiển thị message an toàn.
- Thiếu contract phải được giữ ở `OPEN_QUESTION`, không hard-code behavior nghiệp vụ.
- Không log token, password, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.

## Acceptance criteria

- Deadline gần nhất đứng trước
- Dưới 24 giờ highlight
- Click có target rõ

## Test scenarios

- Quá hạn
- dưới 24 giờ
- đã nộp
- chưa nộp

## Open questions / risks

- HOME-RISK01
- HOME-RISK02
- HOME-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 6 |
| Case | HOME-CASE-06 |
| Feature | HOME-F03 |
| Function | HOME-FN03 |
| View | HOME-V03 |
| Source | BD 3.2 |
