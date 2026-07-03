# Views - Buổi học

## Inventory và navigation

| View | Tên | Entry | Case |
|---|---|---|---|
| CLASS_SESSION-V01 | Trang chi tiết buổi học | Click một tiết học từ lịch | CLASS_SESSION-CASE-09 |
| CLASS_SESSION-V02 | Ghi chú và ghi âm trong buổi học | Trong trang chi tiết buổi học | CLASS_SESSION-CASE-10 |
| CLASS_SESSION-V03 | Transcript buổi học | Sau khi audio được xử lý | CLASS_SESSION-CASE-11 |
| CLASS_SESSION-V04 | Quiz / ra đề bằng text và giọng nói | Chức năng quiz trong buổi học | CLASS_SESSION-CASE-12 |
| CLASS_SESSION-V05 | Thống kê người trả lời quiz | Màn thống kê quiz | CLASS_SESSION-CASE-13 |
| CLASS_SESSION-V06 | Trang Q&A theo buổi học | Tab Q&A trong chi tiết buổi học | CLASS_SESSION-CASE-16 |
| CLASS_SESSION-V07 | Bộ FAQ | Quản lý Q&A/FAQ | CLASS_SESSION-CASE-17 |
| CLASS_SESSION-V08 | Giao diện giảng viên đơn giản | Giảng viên vào app hoặc buổi học | CLASS_SESSION-CASE-28 |
| CLASS_SESSION-V09 | Điều phối trong buổi học | Trong chi tiết buổi học | CLASS_SESSION-CASE-29 |
| CLASS_SESSION-V10 | Đánh giá sinh viên theo quá trình đóng góp | Màn đánh giá trong buổi học | CLASS_SESSION-CASE-30 |

## Global UI states

- Initial
- Loading
- Loaded
- Empty
- Validation error
- Permission denied
- Offline
- Service error
- Success

## CLASS_SESSION-V01 - Trang chi tiết buổi học

- `Case:` CLASS_SESSION-CASE-09
- `Function:` CLASS_SESSION-FN01
- `Entry:` Click một tiết học từ lịch

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Tên môn
- Mã học phần
- Giảng viên
- Thời gian
- Phòng
- Trạng thái

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Nhận mã buổi học | CLASS_SESSION-FN01 | Cập nhật UI/state theo flow |
| Tải thông tin | CLASS_SESSION-FN01 | Cập nhật UI/state theo flow |
| Render chức năng theo role | CLASS_SESSION-FN01 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Sinh viên, Giảng viên.
- Action không phù hợp role phải ẩn hoặc disabled.

### Required UI states

- Loading
- Loaded
- Empty
- Error
- Offline
- Permission denied
- Submitting
- Success

## CLASS_SESSION-V02 - Ghi chú và ghi âm trong buổi học

- `Case:` CLASS_SESSION-CASE-10
- `Function:` CLASS_SESSION-FN02
- `Entry:` Trong trang chi tiết buổi học

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Nội dung ghi chú
- Audio metadata
- Mã buổi học
- Owner

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Tạo ghi chú | CLASS_SESSION-FN02 | Cập nhật UI/state theo flow |
| Bắt đầu/dừng ghi âm | CLASS_SESSION-FN02 | Cập nhật UI/state theo flow |
| Lưu vào storage phê duyệt | CLASS_SESSION-FN02 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Sinh viên, Giảng viên.
- Action không phù hợp role phải ẩn hoặc disabled.

### Required UI states

- Loading
- Loaded
- Empty
- Error
- Offline
- Permission denied
- Submitting
- Success

## CLASS_SESSION-V03 - Transcript buổi học

- `Case:` CLASS_SESSION-CASE-11
- `Function:` CLASS_SESSION-FN03
- `Entry:` Sau khi audio được xử lý

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Transcript segment
- Timestamp
- Audio link
- Từ khóa

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Gửi audio sang STT | CLASS_SESSION-FN03 | Cập nhật UI/state theo flow |
| Nhận transcript timestamp | CLASS_SESSION-FN03 | Cập nhật UI/state theo flow |
| Xem/search/nghe lại đồng bộ | CLASS_SESSION-FN03 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Sinh viên, Giảng viên.
- Action không phù hợp role phải ẩn hoặc disabled.

### Required UI states

- Loading
- Loaded
- Empty
- Error
- Offline
- Permission denied
- Submitting
- Success

## CLASS_SESSION-V04 - Quiz / ra đề bằng text và giọng nói

- `Case:` CLASS_SESSION-CASE-12
- `Function:` CLASS_SESSION-FN04
- `Entry:` Chức năng quiz trong buổi học

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Câu hỏi
- Loại câu hỏi
- Đáp án
- Trạng thái publish
- Mã buổi học

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Tạo câu hỏi text/voice | CLASS_SESSION-FN04 | Cập nhật UI/state theo flow |
| Cấu trúc hóa đề | CLASS_SESSION-FN04 | Cập nhật UI/state theo flow |
| Publish cho sinh viên | CLASS_SESSION-FN04 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Giảng viên tạo, Sinh viên làm.
- Action không phù hợp role phải ẩn hoặc disabled.

### Required UI states

- Loading
- Loaded
- Empty
- Error
- Offline
- Permission denied
- Submitting
- Success

## CLASS_SESSION-V05 - Thống kê người trả lời quiz

- `Case:` CLASS_SESSION-CASE-13
- `Function:` CLASS_SESSION-FN05
- `Entry:` Màn thống kê quiz

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Submission
- Điểm
- Trạng thái nộp
- Danh sách lớp

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Thu submission | CLASS_SESSION-FN05 | Cập nhật UI/state theo flow |
| Tổng hợp đã/chưa nộp/điểm TB | CLASS_SESSION-FN05 | Cập nhật UI/state theo flow |
| Hiển thị realtime hoặc refresh | CLASS_SESSION-FN05 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Giảng viên.
- Action không phù hợp role phải ẩn hoặc disabled.

### Required UI states

- Loading
- Loaded
- Empty
- Error
- Offline
- Permission denied
- Submitting
- Success

## CLASS_SESSION-V06 - Trang Q&A theo buổi học

- `Case:` CLASS_SESSION-CASE-16
- `Function:` CLASS_SESSION-FN06
- `Entry:` Tab Q&A trong chi tiết buổi học

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Question
- Answer
- Upvote
- Transcript reference
- Mã buổi học

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Sinh viên hỏi text/voice | CLASS_SESSION-FN06 | Cập nhật UI/state theo flow |
| GV/AI trả lời | CLASS_SESSION-FN06 | Cập nhật UI/state theo flow |
| Upvote câu hỏi | CLASS_SESSION-FN06 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Sinh viên, Giảng viên, AI.
- Action không phù hợp role phải ẩn hoặc disabled.

### Required UI states

- Loading
- Loaded
- Empty
- Error
- Offline
- Permission denied
- Submitting
- Success

## CLASS_SESSION-V07 - Bộ FAQ

- `Case:` CLASS_SESSION-CASE-17
- `Function:` CLASS_SESSION-FN07
- `Entry:` Quản lý Q&A/FAQ

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- FAQ item
- Nguồn câu hỏi
- Tần suất
- Trạng thái duyệt

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Xác định câu phổ biến | CLASS_SESSION-FN07 | Cập nhật UI/state theo flow |
| Đưa vào FAQ | CLASS_SESSION-FN07 | Cập nhật UI/state theo flow |
| Gợi ý khi câu tương tự | CLASS_SESSION-FN07 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Giảng viên, AI.
- Action không phù hợp role phải ẩn hoặc disabled.

### Required UI states

- Loading
- Loaded
- Empty
- Error
- Offline
- Permission denied
- Submitting
- Success

## CLASS_SESSION-V08 - Giao diện giảng viên đơn giản

- `Case:` CLASS_SESSION-CASE-28
- `Function:` CLASS_SESSION-FN08
- `Entry:` Giảng viên vào app hoặc buổi học

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Role giảng viên
- Danh sách tác vụ

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Hiển thị tác vụ GV chính | CLASS_SESSION-FN08 | Cập nhật UI/state theo flow |
| Giảm nhiễu chức năng SV | CLASS_SESSION-FN08 | Cập nhật UI/state theo flow |
| Ưu tiên tạo đề/ghi âm/thống kê/điểm danh | CLASS_SESSION-FN08 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Giảng viên.
- Action không phù hợp role phải ẩn hoặc disabled.

### Required UI states

- Loading
- Loaded
- Empty
- Error
- Offline
- Permission denied
- Submitting
- Success

## CLASS_SESSION-V09 - Điều phối trong buổi học

- `Case:` CLASS_SESSION-CASE-29
- `Function:` CLASS_SESSION-FN09
- `Entry:` Trong chi tiết buổi học

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Nhóm
- Phân công
- Danh sách sinh viên
- Mã buổi học

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| GV chia nhóm/phân công | CLASS_SESSION-FN09 | Cập nhật UI/state theo flow |
| SV nhận phân công | CLASS_SESSION-FN09 | Cập nhật UI/state theo flow |
| Lưu trạng thái | CLASS_SESSION-FN09 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Giảng viên.
- Action không phù hợp role phải ẩn hoặc disabled.

### Required UI states

- Loading
- Loaded
- Empty
- Error
- Offline
- Permission denied
- Submitting
- Success

## CLASS_SESSION-V10 - Đánh giá sinh viên theo quá trình đóng góp

- `Case:` CLASS_SESSION-CASE-30
- `Function:` CLASS_SESSION-FN10
- `Entry:` Màn đánh giá trong buổi học

### Layout

- Header/context rõ theo module và role.
- Nội dung chính ưu tiên thông tin/action trong BD.
- Action ghi dữ liệu có disabled/loading/error state.

### Data source

- Đóng góp
- Điểm/nhận xét
- Nguồn sự kiện

### Validation

- Kiểm tra required fields, role, ownership và network state trước action.
- Empty/error state mô tả đúng tình trạng, không giả lập dữ liệu thật.

### Action mapping

| Action | Function | Result |
|---|---|---|
| Tổng hợp đóng góp | CLASS_SESSION-FN10 | Cập nhật UI/state theo flow |
| GV xem/chỉnh | CLASS_SESSION-FN10 | Cập nhật UI/state theo flow |
| Lưu đánh giá | CLASS_SESSION-FN10 | Cập nhật UI/state theo flow |

### Cache/fetch

- Ưu tiên cache khi offline nếu module có SQLite source hợp lệ.
- Khi online, fetch mới phải có loading và xử lý parse/network error.

### Copy và UX/accessibility

- Giữ tiếng Việt nhất quán với BD.
- Tap target đủ lớn trên mobile; text quan trọng không bị cắt.
- Màu cảnh báo không là tín hiệu duy nhất khi cần phân biệt trạng thái.

### Permissions

- Roles: Giảng viên.
- Action không phù hợp role phải ẩn hoặc disabled.

### Required UI states

- Loading
- Loaded
- Empty
- Error
- Offline
- Permission denied
- Submitting
- Success
