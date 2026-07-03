# Function List - Trang chủ

## Project dependency direction

- UI thuộc `lib/features/`; shared service thuộc `lib/core/`; database config thuộc `lib/config/`.
- DD này không thay đổi source code hoặc schema.
- External API contract chưa có source phải ghi `OPEN_QUESTION` trước khi implement.

## Function inventory

| Function | Tên | Input chính | Output chính | Case |
|---|---|---|---|---|
| HOME-FN01 | Trang chủ: lịch thay phần chào mừng | Ngày hiện tại; Danh sách tiết học/giảng dạy/họp; Role | UI state / persisted state / navigation result | HOME-CASE-04 |
| HOME-FN02 | Thời khóa biểu hiển thị ngang | Thời gian; Địa điểm; Môn học; Hoạt động; Mã buổi học | UI state / persisted state / navigation result | HOME-CASE-05 |
| HOME-FN03 | Deadline phần 2 | Tên nhiệm vụ; Môn học; Ngày hết hạn; Trạng thái nộp | UI state / persisted state / navigation result | HOME-CASE-06 |
| HOME-FN04 | Lối tắt tự cấu hình thay tổng quan nhanh | Danh sách shortcut; Thứ tự; Cấu hình theo user | UI state / persisted state / navigation result | HOME-CASE-07 |
| HOME-FN05 | Thông báo và quảng cáo phần 3 | Tiêu đề; Nội dung tóm tắt; Ngày gửi; Loại mục | UI state / persisted state / navigation result | HOME-CASE-08 |

## HOME-FN01 - Trang chủ: lịch thay phần chào mừng

- `Case:` HOME-CASE-04
- `Feature:` HOME-F01
- `View:` HOME-V01
- `Entry:` Vào tab Home

### Input

- Ngày hiện tại
- Danh sách tiết học/giảng dạy/họp
- Role

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Sinh viên, Giảng viên.
- Function phải kiểm tra role trước action, không chỉ dựa vào ẩn UI.

### Validation

- Kiểm tra dữ liệu bắt buộc trước khi gọi service.
- Kiểm tra entity thuộc phạm vi user/session hiện tại.
- Contract chưa rõ phải ghi `OPEN_QUESTION`.

### Transaction / side effects

- Ghi local hoặc gọi API phải có loading và xử lý failure.
- Không thực hiện destructive action khi thiếu xác nhận nghiệp vụ.
- Offline sync cần ghi nhận pending/conflict state.

### Security

- Không log credential, token, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.
- Chỉ ghi config key names, không ghi secret values.

### Imports / dependencies

- lib/features/home/home_screen/screens/student_home_screen_view.dart
- lib/features/home/home_view/screens/student_home_view.dart
- lib/features/home/home_view/components/home_app_bar.dart
- lib/features/home/home_view/components/home_quick_actions.dart
- lib/features/home/home_view/components/home_quick_summary.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/notification/screens/view_noti_student.dart

### Tests

- Có lịch hôm nay
- không có lịch
- lỗi tải lịch

## HOME-FN02 - Thời khóa biểu hiển thị ngang

- `Case:` HOME-CASE-05
- `Feature:` HOME-F02
- `View:` HOME-V02
- `Entry:` Khối lịch trên Home hoặc trang lịch

### Input

- Thời gian
- Địa điểm
- Môn học
- Hoạt động
- Mã buổi học

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Sinh viên, Giảng viên.
- Function phải kiểm tra role trước action, không chỉ dựa vào ẩn UI.

### Validation

- Kiểm tra dữ liệu bắt buộc trước khi gọi service.
- Kiểm tra entity thuộc phạm vi user/session hiện tại.
- Contract chưa rõ phải ghi `OPEN_QUESTION`.

### Transaction / side effects

- Ghi local hoặc gọi API phải có loading và xử lý failure.
- Không thực hiện destructive action khi thiếu xác nhận nghiệp vụ.
- Offline sync cần ghi nhận pending/conflict state.

### Security

- Không log credential, token, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.
- Chỉ ghi config key names, không ghi secret values.

### Imports / dependencies

- lib/features/home/home_screen/screens/student_home_screen_view.dart
- lib/features/home/home_view/screens/student_home_view.dart
- lib/features/home/home_view/components/home_app_bar.dart
- lib/features/home/home_view/components/home_quick_actions.dart
- lib/features/home/home_view/components/home_quick_summary.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/notification/screens/view_noti_student.dart

### Tests

- Nhiều tiết
- thiếu phòng
- click điều hướng

## HOME-FN03 - Deadline phần 2

- `Case:` HOME-CASE-06
- `Feature:` HOME-F03
- `View:` HOME-V03
- `Entry:` Khối Deadline trên Home

### Input

- Tên nhiệm vụ
- Môn học
- Ngày hết hạn
- Trạng thái nộp

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Sinh viên.
- Function phải kiểm tra role trước action, không chỉ dựa vào ẩn UI.

### Validation

- Kiểm tra dữ liệu bắt buộc trước khi gọi service.
- Kiểm tra entity thuộc phạm vi user/session hiện tại.
- Contract chưa rõ phải ghi `OPEN_QUESTION`.

### Transaction / side effects

- Ghi local hoặc gọi API phải có loading và xử lý failure.
- Không thực hiện destructive action khi thiếu xác nhận nghiệp vụ.
- Offline sync cần ghi nhận pending/conflict state.

### Security

- Không log credential, token, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.
- Chỉ ghi config key names, không ghi secret values.

### Imports / dependencies

- lib/features/home/home_screen/screens/student_home_screen_view.dart
- lib/features/home/home_view/screens/student_home_view.dart
- lib/features/home/home_view/components/home_app_bar.dart
- lib/features/home/home_view/components/home_quick_actions.dart
- lib/features/home/home_view/components/home_quick_summary.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/notification/screens/view_noti_student.dart

### Tests

- Quá hạn
- dưới 24 giờ
- đã nộp
- chưa nộp

## HOME-FN04 - Lối tắt tự cấu hình thay tổng quan nhanh

- `Case:` HOME-CASE-07
- `Feature:` HOME-F04
- `View:` HOME-V04
- `Entry:` Khối lối tắt trên Home

### Input

- Danh sách shortcut
- Thứ tự
- Cấu hình theo user

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Người dùng đã đăng nhập.
- Function phải kiểm tra role trước action, không chỉ dựa vào ẩn UI.

### Validation

- Kiểm tra dữ liệu bắt buộc trước khi gọi service.
- Kiểm tra entity thuộc phạm vi user/session hiện tại.
- Contract chưa rõ phải ghi `OPEN_QUESTION`.

### Transaction / side effects

- Ghi local hoặc gọi API phải có loading và xử lý failure.
- Không thực hiện destructive action khi thiếu xác nhận nghiệp vụ.
- Offline sync cần ghi nhận pending/conflict state.

### Security

- Không log credential, token, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.
- Chỉ ghi config key names, không ghi secret values.

### Imports / dependencies

- lib/features/home/home_screen/screens/student_home_screen_view.dart
- lib/features/home/home_view/screens/student_home_view.dart
- lib/features/home/home_view/components/home_app_bar.dart
- lib/features/home/home_view/components/home_quick_actions.dart
- lib/features/home/home_view/components/home_quick_summary.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/notification/screens/view_noti_student.dart

### Tests

- Thêm
- xóa
- reorder
- vượt giới hạn

## HOME-FN05 - Thông báo và quảng cáo phần 3

- `Case:` HOME-CASE-08
- `Feature:` HOME-F05
- `View:` HOME-V05
- `Entry:` Khối thông báo/sự kiện trên Home

### Input

- Tiêu đề
- Nội dung tóm tắt
- Ngày gửi
- Loại mục

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Người dùng đã đăng nhập.
- Function phải kiểm tra role trước action, không chỉ dựa vào ẩn UI.

### Validation

- Kiểm tra dữ liệu bắt buộc trước khi gọi service.
- Kiểm tra entity thuộc phạm vi user/session hiện tại.
- Contract chưa rõ phải ghi `OPEN_QUESTION`.

### Transaction / side effects

- Ghi local hoặc gọi API phải có loading và xử lý failure.
- Không thực hiện destructive action khi thiếu xác nhận nghiệp vụ.
- Offline sync cần ghi nhận pending/conflict state.

### Security

- Không log credential, token, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.
- Chỉ ghi config key names, không ghi secret values.

### Imports / dependencies

- lib/features/home/home_screen/screens/student_home_screen_view.dart
- lib/features/home/home_view/screens/student_home_view.dart
- lib/features/home/home_view/components/home_app_bar.dart
- lib/features/home/home_view/components/home_quick_actions.dart
- lib/features/home/home_view/components/home_quick_summary.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/notification/screens/view_noti_student.dart

### Tests

- Thông báo mới/cũ
- không có quảng cáo
- click chi tiết
