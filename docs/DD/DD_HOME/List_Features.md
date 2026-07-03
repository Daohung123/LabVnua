# List Features - Trang chủ

## Inventory

| Feature | Tên | Priority | Rules | Function | View | Case |
|---|---|---|---|---|---|---|
| HOME-F01 | Trang chủ: lịch thay phần chào mừng | P0 - MVP | HOME-BR01, HOME-BR02, HOME-BR03, HOME-BR04 | HOME-FN01 | HOME-V01 | HOME-CASE-04 |
| HOME-F02 | Thời khóa biểu hiển thị ngang | P0 - MVP | HOME-BR01, HOME-BR02, HOME-BR03, HOME-BR04 | HOME-FN02 | HOME-V02 | HOME-CASE-05 |
| HOME-F03 | Deadline phần 2 | P0 - MVP | HOME-BR01, HOME-BR02, HOME-BR03, HOME-BR04 | HOME-FN03 | HOME-V03 | HOME-CASE-06 |
| HOME-F04 | Lối tắt tự cấu hình thay tổng quan nhanh | P0 - MVP | HOME-BR01, HOME-BR02, HOME-BR03, HOME-BR04 | HOME-FN04 | HOME-V04 | HOME-CASE-07 |
| HOME-F05 | Thông báo và quảng cáo phần 3 | P1 | HOME-BR01, HOME-BR02, HOME-BR03, HOME-BR04 | HOME-FN05 | HOME-V05 | HOME-CASE-08 |

## Dependencies

- HOME-API01: VNUA schedule
- HOME-API02: notification/cache
- HOME-API03: analytics event source
- lib/features/home/home_screen/screens/student_home_screen_view.dart
- lib/features/home/home_view/screens/student_home_view.dart
- lib/features/home/home_view/components/home_app_bar.dart
- lib/features/home/home_view/components/home_quick_actions.dart
- lib/features/home/home_view/components/home_quick_summary.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/notification/screens/view_noti_student.dart

## HOME-F01 - Trang chủ: lịch thay phần chào mừng

- `Case:` HOME-CASE-04
- `Priority:` P0 - MVP
- `Source:` BD 3.1
- `Roles:` Sinh viên, Giảng viên
- `Function:` HOME-FN01
- `View:` HOME-V01

### Happy flow

- Tải ngày hiện tại
- Lấy lịch theo role
- Render khối lịch

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Home ưu tiên lịch trong ngày
- Không có lịch có empty state

### Tests

- Có lịch hôm nay
- không có lịch
- lỗi tải lịch

### Risks / open questions

- HOME-RISK01
- HOME-RISK02
- HOME-RISK03

## HOME-F02 - Thời khóa biểu hiển thị ngang

- `Case:` HOME-CASE-05
- `Priority:` P0 - MVP
- `Source:` BD 3.1
- `Roles:` Sinh viên, Giảng viên
- `Function:` HOME-FN02
- `View:` HOME-V02

### Happy flow

- Sắp xếp theo thời gian
- Render ngang
- Click tới chi tiết buổi học

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Item đủ thời gian/địa điểm/môn
- Click có target hoặc open question

### Tests

- Nhiều tiết
- thiếu phòng
- click điều hướng

### Risks / open questions

- HOME-RISK01
- HOME-RISK02
- HOME-RISK03

## HOME-F03 - Deadline phần 2

- `Case:` HOME-CASE-06
- `Priority:` P0 - MVP
- `Source:` BD 3.2
- `Roles:` Sinh viên
- `Function:` HOME-FN03
- `View:` HOME-V03

### Happy flow

- Lấy deadline
- Sắp xếp hạn gần nhất
- Click vào nộp bài/đầu việc

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Deadline gần nhất đứng trước
- Dưới 24 giờ highlight
- Click có target rõ

### Tests

- Quá hạn
- dưới 24 giờ
- đã nộp
- chưa nộp

### Risks / open questions

- HOME-RISK01
- HOME-RISK02
- HOME-RISK03

## HOME-F04 - Lối tắt tự cấu hình thay tổng quan nhanh

- `Case:` HOME-CASE-07
- `Priority:` P0 - MVP
- `Source:` BD 3.4
- `Roles:` Người dùng đã đăng nhập
- `Function:` HOME-FN04
- `View:` HOME-V04

### Happy flow

- Hiển thị grid 2 x N
- Vào chế độ chỉnh sửa
- Thêm/xóa/sắp xếp trong giới hạn

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Grid không vượt giới hạn
- Cấu hình được lưu hoặc ghi open question

### Tests

- Thêm
- xóa
- reorder
- vượt giới hạn

### Risks / open questions

- HOME-RISK01
- HOME-RISK02
- HOME-RISK03

## HOME-F05 - Thông báo và quảng cáo phần 3

- `Case:` HOME-CASE-08
- `Priority:` P1
- `Source:` BD 3.3
- `Roles:` Người dùng đã đăng nhập
- `Function:` HOME-FN05
- `View:` HOME-V05

### Happy flow

- Lấy thông báo
- Lấy quảng cáo nếu có nguồn
- Click chi tiết

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Thông báo hiển thị được
- Không render quảng cáo giả khi thiếu nguồn

### Tests

- Thông báo mới/cũ
- không có quảng cáo
- click chi tiết

### Risks / open questions

- HOME-RISK01
- HOME-RISK02
- HOME-RISK03
