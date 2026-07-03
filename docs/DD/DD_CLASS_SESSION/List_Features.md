# List Features - Buổi học

## Inventory

| Feature | Tên | Priority | Rules | Function | View | Case |
|---|---|---|---|---|---|---|
| CLASS_SESSION-F01 | Trang chi tiết buổi học | P0 - MVP | CLASS_SESSION-BR01, CLASS_SESSION-BR02, CLASS_SESSION-BR03, CLASS_SESSION-BR04 | CLASS_SESSION-FN01 | CLASS_SESSION-V01 | CLASS_SESSION-CASE-09 |
| CLASS_SESSION-F02 | Ghi chú và ghi âm trong buổi học | P0 - MVP | CLASS_SESSION-BR01, CLASS_SESSION-BR02, CLASS_SESSION-BR03, CLASS_SESSION-BR04 | CLASS_SESSION-FN02 | CLASS_SESSION-V02 | CLASS_SESSION-CASE-10 |
| CLASS_SESSION-F03 | Transcript buổi học | P0 - MVP | CLASS_SESSION-BR01, CLASS_SESSION-BR02, CLASS_SESSION-BR03, CLASS_SESSION-BR04 | CLASS_SESSION-FN03 | CLASS_SESSION-V03 | CLASS_SESSION-CASE-11 |
| CLASS_SESSION-F04 | Quiz / ra đề bằng text và giọng nói | P0 - MVP | CLASS_SESSION-BR01, CLASS_SESSION-BR02, CLASS_SESSION-BR03, CLASS_SESSION-BR04 | CLASS_SESSION-FN04 | CLASS_SESSION-V04 | CLASS_SESSION-CASE-12 |
| CLASS_SESSION-F05 | Thống kê người trả lời quiz | P0 - MVP | CLASS_SESSION-BR01, CLASS_SESSION-BR02, CLASS_SESSION-BR03, CLASS_SESSION-BR04 | CLASS_SESSION-FN05 | CLASS_SESSION-V05 | CLASS_SESSION-CASE-13 |
| CLASS_SESSION-F06 | Trang Q&A theo buổi học | P1 | CLASS_SESSION-BR01, CLASS_SESSION-BR02, CLASS_SESSION-BR03, CLASS_SESSION-BR04 | CLASS_SESSION-FN06 | CLASS_SESSION-V06 | CLASS_SESSION-CASE-16 |
| CLASS_SESSION-F07 | Bộ FAQ | P1 | CLASS_SESSION-BR01, CLASS_SESSION-BR02, CLASS_SESSION-BR03, CLASS_SESSION-BR04 | CLASS_SESSION-FN07 | CLASS_SESSION-V07 | CLASS_SESSION-CASE-17 |
| CLASS_SESSION-F08 | Giao diện giảng viên đơn giản | P1 | CLASS_SESSION-BR01, CLASS_SESSION-BR02, CLASS_SESSION-BR03, CLASS_SESSION-BR04 | CLASS_SESSION-FN08 | CLASS_SESSION-V08 | CLASS_SESSION-CASE-28 |
| CLASS_SESSION-F09 | Điều phối trong buổi học | P2 | CLASS_SESSION-BR01, CLASS_SESSION-BR02, CLASS_SESSION-BR03, CLASS_SESSION-BR04 | CLASS_SESSION-FN09 | CLASS_SESSION-V09 | CLASS_SESSION-CASE-29 |
| CLASS_SESSION-F10 | Đánh giá sinh viên theo quá trình đóng góp | P2 | CLASS_SESSION-BR01, CLASS_SESSION-BR02, CLASS_SESSION-BR03, CLASS_SESSION-BR04 | CLASS_SESSION-FN10 | CLASS_SESSION-V10 | CLASS_SESSION-CASE-30 |

## Dependencies

- CLASS_SESSION-API01: schedule/detail source
- CLASS_SESSION-API02: STT provider
- CLASS_SESSION-API03: quiz backend
- CLASS_SESSION-API04: AI transcript Q&A
- lib/features/schedure/screens/components/detail_subject.dart
- lib/features/schedure/screens/today_schedule_view.dart
- lib/features/ai_assistant/controllers/controller_ai.dart
- lib/features/home/study_view/screens/study_view.dart

## CLASS_SESSION-F01 - Trang chi tiết buổi học

- `Case:` CLASS_SESSION-CASE-09
- `Priority:` P0 - MVP
- `Source:` BD 4.1
- `Roles:` Sinh viên, Giảng viên
- `Function:` CLASS_SESSION-FN01
- `View:` CLASS_SESSION-V01

### Happy flow

- Nhận mã buổi học
- Tải thông tin
- Render chức năng theo role

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Thông tin đủ
- Chức năng không phù hợp role không xuất hiện

### Tests

- SV xem
- GV xem
- thiếu phòng

### Risks / open questions

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## CLASS_SESSION-F02 - Ghi chú và ghi âm trong buổi học

- `Case:` CLASS_SESSION-CASE-10
- `Priority:` P0 - MVP
- `Source:` BD 4.1, 4.2
- `Roles:` Sinh viên, Giảng viên
- `Function:` CLASS_SESSION-FN02
- `View:` CLASS_SESSION-V02

### Happy flow

- Tạo ghi chú
- Bắt đầu/dừng ghi âm
- Lưu vào storage phê duyệt

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Ghi chú đúng buổi/owner
- Ghi âm có trạng thái và không mất dữ liệu khi lỗi

### Tests

- CRUD ghi chú
- start/stop recording
- lỗi microphone

### Risks / open questions

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## CLASS_SESSION-F03 - Transcript buổi học

- `Case:` CLASS_SESSION-CASE-11
- `Priority:` P0 - MVP
- `Source:` BD 4.2
- `Roles:` Sinh viên, Giảng viên
- `Function:` CLASS_SESSION-FN03
- `View:` CLASS_SESSION-V03

### Happy flow

- Gửi audio sang STT
- Nhận transcript timestamp
- Xem/search/nghe lại đồng bộ

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Transcript theo timestamp
- Search trả đoạn liên quan
- Có processing/error state

### Tests

- Audio ngắn/dài
- STT lỗi
- search empty

### Risks / open questions

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## CLASS_SESSION-F04 - Quiz / ra đề bằng text và giọng nói

- `Case:` CLASS_SESSION-CASE-12
- `Priority:` P0 - MVP
- `Source:` BD 4.3
- `Roles:` Giảng viên tạo, Sinh viên làm
- `Function:` CLASS_SESSION-FN04
- `View:` CLASS_SESSION-V04

### Happy flow

- Tạo câu hỏi text/voice
- Cấu trúc hóa đề
- Publish cho sinh viên

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Hỗ trợ loại câu hỏi trong BD
- Sinh viên chỉ thấy quiz đã publish

### Tests

- Tạo quiz text
- quiz voice
- publish/unpublish

### Risks / open questions

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## CLASS_SESSION-F05 - Thống kê người trả lời quiz

- `Case:` CLASS_SESSION-CASE-13
- `Priority:` P0 - MVP
- `Source:` BD 4.3
- `Roles:` Giảng viên
- `Function:` CLASS_SESSION-FN05
- `View:` CLASS_SESSION-V05

### Happy flow

- Thu submission
- Tổng hợp đã/chưa nộp/điểm TB
- Hiển thị realtime hoặc refresh

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- GV biết ai đã/chưa nộp
- Điểm TB từ submission hợp lệ

### Tests

- Không ai nộp
- một phần lớp nộp
- submission trễ

### Risks / open questions

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## CLASS_SESSION-F06 - Trang Q&A theo buổi học

- `Case:` CLASS_SESSION-CASE-16
- `Priority:` P1
- `Source:` BD 4.4
- `Roles:` Sinh viên, Giảng viên, AI
- `Function:` CLASS_SESSION-FN06
- `View:` CLASS_SESSION-V06

### Happy flow

- Sinh viên hỏi text/voice
- GV/AI trả lời
- Upvote câu hỏi

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Mỗi buổi có thread riêng
- Câu hỏi gắn đúng context

### Tests

- Tạo câu hỏi
- trả lời
- upvote
- câu hỏi từ audio

### Risks / open questions

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## CLASS_SESSION-F07 - Bộ FAQ

- `Case:` CLASS_SESSION-CASE-17
- `Priority:` P1
- `Source:` BD 4.4
- `Roles:` Giảng viên, AI
- `Function:` CLASS_SESSION-FN07
- `View:` CLASS_SESSION-V07

### Happy flow

- Xác định câu phổ biến
- Đưa vào FAQ
- Gợi ý khi câu tương tự

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- FAQ không tự publish nếu chưa có rule
- Gợi ý không mất câu hỏi gốc

### Tests

- Tạo FAQ
- gợi ý
- câu không liên quan

### Risks / open questions

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## CLASS_SESSION-F08 - Giao diện giảng viên đơn giản

- `Case:` CLASS_SESSION-CASE-28
- `Priority:` P1
- `Source:` BD 1.2, 4.1
- `Roles:` Giảng viên
- `Function:` CLASS_SESSION-FN08
- `View:` CLASS_SESSION-V08

### Happy flow

- Hiển thị tác vụ GV chính
- Giảm nhiễu chức năng SV
- Ưu tiên tạo đề/ghi âm/thống kê/điểm danh

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- GV thấy UI đơn giản
- Không thấy tác vụ chỉ SV

### Tests

- Role GV
- role SV
- role invalid

### Risks / open questions

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## CLASS_SESSION-F09 - Điều phối trong buổi học

- `Case:` CLASS_SESSION-CASE-29
- `Priority:` P2
- `Source:` BD 4.1
- `Roles:` Giảng viên
- `Function:` CLASS_SESSION-FN09
- `View:` CLASS_SESSION-V09

### Happy flow

- GV chia nhóm/phân công
- SV nhận phân công
- Lưu trạng thái

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Phân công đúng buổi
- SV thấy nhiệm vụ

### Tests

- Chia nhóm
- sửa phân công
- thiếu danh sách lớp

### Risks / open questions

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05

## CLASS_SESSION-F10 - Đánh giá sinh viên theo quá trình đóng góp

- `Case:` CLASS_SESSION-CASE-30
- `Priority:` P2
- `Source:` BD 4.1
- `Roles:` Giảng viên
- `Function:` CLASS_SESSION-FN10
- `View:` CLASS_SESSION-V10

### Happy flow

- Tổng hợp đóng góp
- GV xem/chỉnh
- Lưu đánh giá

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Đánh giá trace được nguồn
- Không tự quyết điểm khi chưa có rule

### Tests

- Nhiều nguồn
- không có dữ liệu
- GV chỉnh nhận xét

### Risks / open questions

- CLASS_SESSION-RISK01
- CLASS_SESSION-RISK02
- CLASS_SESSION-RISK03
- CLASS_SESSION-RISK04
- CLASS_SESSION-RISK05
