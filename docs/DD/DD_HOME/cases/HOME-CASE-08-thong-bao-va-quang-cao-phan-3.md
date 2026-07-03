# HOME-CASE-08 - Thông báo và quảng cáo phần 3

- `STATUS:` Draft DD v0.1
- `MODULE:` HOME - Trang chủ
- `PRIORITY:` P1
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 3.3
- `FEATURE:` HOME-F05
- `FUNCTION:` HOME-FN05
- `VIEW:` HOME-V05
- `ROLES:` Người dùng đã đăng nhập

## Mục tiêu

Thông báo và quảng cáo phần 3 được thiết kế như một case riêng trong module `HOME` và trace trực tiếp tới bảng ưu tiên BD dòng 8.

## Entry point

Khối thông báo/sự kiện trên Home

## Luồng chính

- Lấy thông báo
- Lấy quảng cáo nếu có nguồn
- Click chi tiết

## Dữ liệu / API / state

- Tiêu đề
- Nội dung tóm tắt
- Ngày gửi
- Loại mục

Tích hợp liên quan:

- HOME-API01: VNUA schedule
- HOME-API02: notification/cache
- HOME-API03: analytics event source

## UI / component

- View chính: HOME-V05.
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

- Thông báo hiển thị được
- Không render quảng cáo giả khi thiếu nguồn

## Test scenarios

- Thông báo mới/cũ
- không có quảng cáo
- click chi tiết

## Open questions / risks

- HOME-RISK01
- HOME-RISK02
- HOME-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 8 |
| Case | HOME-CASE-08 |
| Feature | HOME-F05 |
| Function | HOME-FN05 |
| View | HOME-V05 |
| Source | BD 3.3 |
