# HOME-CASE-05 - Thời khóa biểu hiển thị ngang

- `STATUS:` Draft DD v0.1
- `MODULE:` HOME - Trang chủ
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 3.1
- `FEATURE:` HOME-F02
- `FUNCTION:` HOME-FN02
- `VIEW:` HOME-V02
- `ROLES:` Sinh viên, Giảng viên

## Mục tiêu

Thời khóa biểu hiển thị ngang được thiết kế như một case riêng trong module `HOME` và trace trực tiếp tới bảng ưu tiên BD dòng 5.

## Entry point

Khối lịch trên Home hoặc trang lịch

## Luồng chính

- Sắp xếp theo thời gian
- Render ngang
- Click tới chi tiết buổi học

## Dữ liệu / API / state

- Thời gian
- Địa điểm
- Môn học
- Hoạt động
- Mã buổi học

Tích hợp liên quan:

- HOME-API01: VNUA schedule
- HOME-API02: notification/cache
- HOME-API03: analytics event source

## UI / component

- View chính: HOME-V02.
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

- Item đủ thời gian/địa điểm/môn
- Click có target hoặc open question

## Test scenarios

- Nhiều tiết
- thiếu phòng
- click điều hướng

## Open questions / risks

- HOME-RISK01
- HOME-RISK02
- HOME-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 5 |
| Case | HOME-CASE-05 |
| Feature | HOME-F02 |
| Function | HOME-FN02 |
| View | HOME-V02 |
| Source | BD 3.1 |
