# Function List - Buổi học

## Project dependency direction

- UI thuộc `lib/features/`; shared service thuộc `lib/core/`; database config thuộc `lib/config/`.
- DD này không thay đổi source code hoặc schema.
- External API contract chưa có source phải ghi `OPEN_QUESTION` trước khi implement.

## Function inventory

| Function | Tên | Input chính | Output chính | Case |
|---|---|---|---|---|
| CLASS_SESSION-FN01 | Trang chi tiết buổi học | Tên môn; Mã học phần; Giảng viên; Thời gian; Phòng; Trạng thái | UI state / persisted state / navigation result | CLASS_SESSION-CASE-09 |
| CLASS_SESSION-FN02 | Ghi chú và ghi âm trong buổi học | Nội dung ghi chú; Audio metadata; Mã buổi học; Owner | UI state / persisted state / navigation result | CLASS_SESSION-CASE-10 |
| CLASS_SESSION-FN03 | Transcript buổi học | Transcript segment; Timestamp; Audio link; Từ khóa | UI state / persisted state / navigation result | CLASS_SESSION-CASE-11 |
| CLASS_SESSION-FN04 | Quiz / ra đề bằng text và giọng nói | Câu hỏi; Loại câu hỏi; Đáp án; Trạng thái publish; Mã buổi học | UI state / persisted state / navigation result | CLASS_SESSION-CASE-12 |
| CLASS_SESSION-FN05 | Thống kê người trả lời quiz | Submission; Điểm; Trạng thái nộp; Danh sách lớp | UI state / persisted state / navigation result | CLASS_SESSION-CASE-13 |
| CLASS_SESSION-FN06 | Trang Q&A theo buổi học | Question; Answer; Upvote; Transcript reference; Mã buổi học | UI state / persisted state / navigation result | CLASS_SESSION-CASE-16 |
| CLASS_SESSION-FN07 | Bộ FAQ | FAQ item; Nguồn câu hỏi; Tần suất; Trạng thái duyệt | UI state / persisted state / navigation result | CLASS_SESSION-CASE-17 |
| CLASS_SESSION-FN08 | Giao diện giảng viên đơn giản | Role giảng viên; Danh sách tác vụ | UI state / persisted state / navigation result | CLASS_SESSION-CASE-28 |
| CLASS_SESSION-FN09 | Điều phối trong buổi học | Nhóm; Phân công; Danh sách sinh viên; Mã buổi học | UI state / persisted state / navigation result | CLASS_SESSION-CASE-29 |
| CLASS_SESSION-FN10 | Đánh giá sinh viên theo quá trình đóng góp | Đóng góp; Điểm/nhận xét; Nguồn sự kiện | UI state / persisted state / navigation result | CLASS_SESSION-CASE-30 |

## CLASS_SESSION-FN01 - Trang chi tiết buổi học

- `Case:` CLASS_SESSION-CASE-09
- `Feature:` CLASS_SESSION-F01
- `View:` CLASS_SESSION-V01
- `Entry:` Click một tiết học từ lịch

### Input

- Tên môn
- Mã học phần
- Giảng viên
- Thời gian
- Phòng
- Trạng thái

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

- lib/features/schedure/screens/components/detail_subject.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/home/study_view/screens/study_view.dart

### Tests

- SV xem
- GV xem
- thiếu phòng

## CLASS_SESSION-FN02 - Ghi chú và ghi âm trong buổi học

- `Case:` CLASS_SESSION-CASE-10
- `Feature:` CLASS_SESSION-F02
- `View:` CLASS_SESSION-V02
- `Entry:` Trong trang chi tiết buổi học

### Input

- Nội dung ghi chú
- Audio metadata
- Mã buổi học
- Owner

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

- lib/features/schedure/screens/components/detail_subject.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/home/study_view/screens/study_view.dart

### Tests

- CRUD ghi chú
- start/stop recording
- lỗi microphone

## CLASS_SESSION-FN03 - Transcript buổi học

- `Case:` CLASS_SESSION-CASE-11
- `Feature:` CLASS_SESSION-F03
- `View:` CLASS_SESSION-V03
- `Entry:` Sau khi audio được xử lý

### Input

- Transcript segment
- Timestamp
- Audio link
- Từ khóa

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

- lib/features/schedure/screens/components/detail_subject.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/home/study_view/screens/study_view.dart

### Tests

- Audio ngắn/dài
- STT lỗi
- search empty

## CLASS_SESSION-FN04 - Quiz / ra đề bằng text và giọng nói

- `Case:` CLASS_SESSION-CASE-12
- `Feature:` CLASS_SESSION-F04
- `View:` CLASS_SESSION-V04
- `Entry:` Chức năng quiz trong buổi học

### Input

- Câu hỏi
- Loại câu hỏi
- Đáp án
- Trạng thái publish
- Mã buổi học

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Giảng viên tạo, Sinh viên làm.
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

- lib/features/schedure/screens/components/detail_subject.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/home/study_view/screens/study_view.dart

### Tests

- Tạo quiz text
- quiz voice
- publish/unpublish

## CLASS_SESSION-FN05 - Thống kê người trả lời quiz

- `Case:` CLASS_SESSION-CASE-13
- `Feature:` CLASS_SESSION-F05
- `View:` CLASS_SESSION-V05
- `Entry:` Màn thống kê quiz

### Input

- Submission
- Điểm
- Trạng thái nộp
- Danh sách lớp

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Giảng viên.
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

- lib/features/schedure/screens/components/detail_subject.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/home/study_view/screens/study_view.dart

### Tests

- Không ai nộp
- một phần lớp nộp
- submission trễ

## CLASS_SESSION-FN06 - Trang Q&A theo buổi học

- `Case:` CLASS_SESSION-CASE-16
- `Feature:` CLASS_SESSION-F06
- `View:` CLASS_SESSION-V06
- `Entry:` Tab Q&A trong chi tiết buổi học

### Input

- Question
- Answer
- Upvote
- Transcript reference
- Mã buổi học

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Sinh viên, Giảng viên, AI.
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

- lib/features/schedure/screens/components/detail_subject.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/home/study_view/screens/study_view.dart

### Tests

- Tạo câu hỏi
- trả lời
- upvote
- câu hỏi từ audio

## CLASS_SESSION-FN07 - Bộ FAQ

- `Case:` CLASS_SESSION-CASE-17
- `Feature:` CLASS_SESSION-F07
- `View:` CLASS_SESSION-V07
- `Entry:` Quản lý Q&A/FAQ

### Input

- FAQ item
- Nguồn câu hỏi
- Tần suất
- Trạng thái duyệt

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Giảng viên, AI.
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

- lib/features/schedure/screens/components/detail_subject.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/home/study_view/screens/study_view.dart

### Tests

- Tạo FAQ
- gợi ý
- câu không liên quan

## CLASS_SESSION-FN08 - Giao diện giảng viên đơn giản

- `Case:` CLASS_SESSION-CASE-28
- `Feature:` CLASS_SESSION-F08
- `View:` CLASS_SESSION-V08
- `Entry:` Giảng viên vào app hoặc buổi học

### Input

- Role giảng viên
- Danh sách tác vụ

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Giảng viên.
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

- lib/features/schedure/screens/components/detail_subject.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/home/study_view/screens/study_view.dart

### Tests

- Role GV
- role SV
- role invalid

## CLASS_SESSION-FN09 - Điều phối trong buổi học

- `Case:` CLASS_SESSION-CASE-29
- `Feature:` CLASS_SESSION-F09
- `View:` CLASS_SESSION-V09
- `Entry:` Trong chi tiết buổi học

### Input

- Nhóm
- Phân công
- Danh sách sinh viên
- Mã buổi học

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Giảng viên.
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

- lib/features/schedure/screens/components/detail_subject.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/home/study_view/screens/study_view.dart

### Tests

- Chia nhóm
- sửa phân công
- thiếu danh sách lớp

## CLASS_SESSION-FN10 - Đánh giá sinh viên theo quá trình đóng góp

- `Case:` CLASS_SESSION-CASE-30
- `Feature:` CLASS_SESSION-F10
- `View:` CLASS_SESSION-V10
- `Entry:` Màn đánh giá trong buổi học

### Input

- Đóng góp
- Điểm/nhận xét
- Nguồn sự kiện

### Output

- UI cập nhật theo trạng thái xử lý.
- Navigation hoặc persisted state chỉ cập nhật khi validation và permission pass.
- Error message an toàn, không lộ secret/token/password/PII sản xuất.

### Permission

- Roles được phép: Giảng viên.
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

- lib/features/schedure/screens/components/detail_subject.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/home/study_view/screens/study_view.dart

### Tests

- Nhiều nguồn
- không có dữ liệu
- GV chỉnh nhận xét
