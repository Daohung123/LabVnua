# Basic Design - Learning Management App

- `Nguồn:` `docs/base/BasicDesign_LearningApp.docx`
- `Loại tài liệu nguồn:` Basic Design (Thiết kế cơ bản)
- `Phiên bản nguồn:` 1.0 - Tháng 06/2026
- `Ngày tạo nguồn:` 06/06/2026
- `Ngày markdown hóa:` 2026-07-02
- `Phạm vi:` Ứng dụng mobile hỗ trợ quản lý học tập cho sinh viên, giảng viên và nhà trường
- `Ghi chú:` Tài liệu này markdown hóa và mô tả chi tiết nội dung trong file Word nguồn. Các yêu cầu dưới đây là yêu cầu thiết kế trong BD nguồn, không mặc định là đã được đối chiếu với mã nguồn hiện tại.

## 0. Thông tin tài liệu

Header của file Word nguồn ghi: `Learning Management App | Basic Design Document v1.0`.

| Trường | Giá trị |
|---|---|
| Dự án | Learning Management App |
| Loại tài liệu | Basic Design (Thiết kế cơ bản) |
| Đối tượng | Giảng viên, Sinh viên, Nhà trường |
| Ngày tạo | 06/06/2026 |
| Creator | Un-named |
| Last modified by | Un-named |
| Revision | 1 |
| Created metadata | 2026-06-06T07:22:52.075Z |
| Modified metadata | 2026-06-06T07:22:52.076Z |

## 1. Tổng quan dự án

### 1.1 Mục tiêu

Hệ thống cần xây dựng ứng dụng di động hỗ trợ quản lý học tập toàn diện cho sinh viên và giảng viên. Ứng dụng gom các nhóm chức năng chính: AI trợ lý, lịch học, quản lý buổi học, điểm danh, nộp bài, deadline và tiện ích hành chính. Tất cả được tập trung trong một nền tảng duy nhất để người dùng truy cập theo vai trò.

### 1.2 Đối tượng sử dụng

| Vai trò | Quyền hạn chính | Giao diện |
|---|---|---|
| Sinh viên | Xem lịch, nộp bài, điểm danh QR, hỏi đáp, AI hỗ trợ | Mobile App |
| Giảng viên | Tạo đề, ghi âm, điều phối buổi học, chấm điểm, thống kê | Mobile App, giao diện đơn giản |
| Nhà trường / Quản trị | Quản lý người dùng, xem báo cáo toàn trường, cấu hình hệ thống | Web Admin, thực hiện ở pha sau |

### 1.3 Phạm vi phiên bản 1 (MVP)

MVP tập trung vào các module cần có để ứng dụng vận hành như một nền tảng học tập mobile:

- Xác thực và đăng nhập bằng VNied hoặc email.
- Trang chủ cá nhân hóa gồm lịch, deadline và lối tắt.
- Quản lý buổi học gồm ghi âm, transcript, quiz và điểm danh QR.
- Cổng học tập gồm thống kê môn học và tìm kiếm.
- AI trợ lý tích hợp dữ liệu nội bộ và Speech-to-Text.
- Todo / đầu việc hoạt động online và offline.
- Đăng ký tạm trú / tạm vắng có mã QR.
- Lưu trữ offline bằng SQLite.

## 2. Module xác thực và tài khoản

### 2.1 Màn hình đăng nhập

#### Yêu cầu chức năng

- Giao diện đăng nhập đơn giản và hiển thị logo nhóm hoặc trường.
- Bỏ lựa chọn role giảng viên / sinh viên tại màn hình đăng nhập.
- Hệ thống tự động phân quyền sau khi xác thực.
- Hỗ trợ đăng nhập bằng VNied như SSO của trường đại học.
- Hỗ trợ đăng nhập bằng email và mật khẩu như phương án fallback.

#### Yêu cầu kỹ thuật

- Tích hợp OAuth2 với hệ thống VNied.
- Lưu token xác thực an toàn bằng Keychain trên iOS hoặc Keystore trên Android.
- Tự động đăng nhập lại khi token còn hạn.

### 2.2 Quản lý tài khoản trên header avatar

- Khi người dùng ấn vào avatar trên header, hệ thống hiện dropdown menu.
- Dropdown gồm các mục: Thông tin cá nhân, Cài đặt, Đổi mật khẩu, Đăng xuất.
- Ảnh đại diện và tên hiển thị được lấy từ dữ liệu VNied.

## 3. Module trang chủ

Trang chủ được chia thành ba phần chính. Mỗi phần có thể click để điều hướng sang trang chi tiết tương ứng.

### 3.1 Phần 1 - Lịch và thời khóa biểu

#### Yêu cầu chức năng

- Thay thế phần "Chào mừng" bằng lịch động theo ngày hiện tại.
- Hiển thị lịch học cho sinh viên, lịch giảng dạy cho giảng viên và lịch họp nếu có.
- Thời khóa biểu ưu tiên hiển thị theo chiều ngang với đầy đủ thời gian, địa điểm, môn học và hoạt động.
- Khi click vào từng tiết học, ứng dụng chuyển sang trang chi tiết buổi học.
- Nếu không có lịch họp thì không hiển thị mục lịch họp.

### 3.2 Phần 2 - Deadline

- Danh sách deadline được sắp xếp theo thứ tự ưu tiên gần nhất.
- Mỗi deadline hiển thị tên nhiệm vụ, môn học, ngày hết hạn và trạng thái chưa nộp / đã nộp.
- Khi click vào deadline, ứng dụng chuyển sang trang nộp bài hoặc chi tiết đầu việc.
- Deadline còn dưới 24 giờ được highlight màu đỏ.

### 3.3 Phần 3 - Thông báo và quảng cáo

- Hiển thị thông báo hệ thống như nghỉ học, thay đổi lịch và các thông báo liên quan.
- Hiển thị quảng cáo sự kiện trường và hoạt động ngoại khóa.
- Khi click vào một mục, ứng dụng chuyển sang chi tiết thông báo hoặc sự kiện.

### 3.4 Lối tắt tự cấu hình

#### Mô tả

Phần "Tổng quan nhanh" trong trang chủ được thay bằng grid lối tắt cho phép người dùng tự chọn các chức năng hiển thị.

#### Yêu cầu chức năng

- Grid có dạng 2 x N, gồm các icon chức năng hay dùng.
- Số ô lối tắt tối đa khoảng 8 đến 10 ô.
- Người dùng có chế độ chỉnh sửa để thêm, xóa và sắp xếp chức năng.
- Hệ thống gợi ý lối tắt dựa trên hành vi sử dụng. Yêu cầu này phụ thuộc vào analytics nội bộ.

### 3.5 Header

- Logo nhóm hoặc trường nằm ở góc trái.
- Avatar người dùng nằm ở góc phải và mở dropdown tài khoản.
- Nếu có tích hợp trạng thái "Hoạt động / Đã đồng bộ" thì đặt trên header; nếu không dùng thì bỏ hẳn.
- Không hiển thị nút Chat riêng trên header; chức năng này được thay bằng AI.

## 4. Module buổi học

Module buổi học là module trung tâm của ứng dụng. Khi người dùng click vào một tiết học trên lịch, ứng dụng hiển thị toàn bộ chức năng liên quan đến buổi học đó.

### 4.1 Trang chi tiết buổi học

#### Thông tin hiển thị

- Tên môn học, mã học phần và tên giảng viên.
- Thời gian, địa điểm và phòng học.
- Trạng thái buổi học: Sắp diễn ra, Đang học, Đã kết thúc.
- Danh sách chức năng liên quan theo role người dùng.

#### Chức năng dành cho sinh viên

- Xem tài liệu buổi học và đề cương.
- Điểm danh bằng QR cá nhân.
- Tham gia quiz hoặc bài kiểm tra nhanh.
- Ghi chú bằng text và ghi âm cá nhân.
- Hỏi đáp theo buổi học trên trang comment.
- Xem transcript buổi học do giảng viên tạo.
- Hỏi đáp thông qua transcript với AI hỗ trợ.

#### Chức năng dành cho giảng viên

- Tạo đề hoặc quiz dạng text, câu hỏi trắc nghiệm và tự luận.
- Hỗ trợ tạo đề bằng giọng nói.
- Xem thống kê ai đã trả lời và chưa trả lời quiz.
- Điểm danh, xem danh sách vắng và xác nhận điểm danh.
- Ghi âm buổi học và tự động chuyển thành transcript.
- Ghi chú tiến độ giảng dạy.
- Thông báo nghỉ học.
- Điều phối trong buổi học như chia nhóm hoặc phân công.
- Quản lý trang Q&A của buổi học và trả lời câu hỏi sinh viên.
- Quản lý FAQ để tránh trả lời lặp lại.
- Đánh giá sinh viên dựa trên quá trình đóng góp.

### 4.2 Tính năng ghi âm thành transcript

#### Luồng xử lý

- Giảng viên nhấn Ghi âm trong buổi học, hệ thống bắt đầu ghi âm audio.
- Sau buổi học, audio được chuyển sang transcript bằng Speech-to-Text.
- Transcript hiển thị theo timestamp và có thể tìm kiếm theo từ khóa.
- Sinh viên có thể nghe lại audio đồng thời với xem transcript.
- Sinh viên có thể đặt câu hỏi gắn với đoạn transcript cụ thể.
- Mục tiêu của tính năng là hỗ trợ kiểm soát chất lượng giảng dạy.

### 4.3 Tính năng quiz / ra đề

#### Yêu cầu

- Giảng viên tạo đề dạng trắc nghiệm, đúng/sai, điền vào chỗ trống.
- Hỗ trợ tạo đề bằng giọng nói, trong đó giảng viên nói câu hỏi và hệ thống nhận diện, cấu trúc hóa nội dung.
- Sinh viên nhận đề ngay trong app khi giảng viên publish.
- Thống kê real-time gồm ai đã nộp, ai chưa nộp và điểm trung bình.
- Lưu lịch sử các đề đã ra theo từng buổi học.

### 4.4 Trang Q&A buổi học

- Mỗi buổi học có một thread Q&A riêng.
- Sinh viên đặt câu hỏi bằng text hoặc ghi âm.
- Giảng viên hoặc AI trả lời câu hỏi.
- Câu hỏi phổ biến được đưa vào FAQ và được gợi ý tự động.
- Câu hỏi có thể được upvote để giảng viên ưu tiên trả lời.

### 4.5 Xác nhận tiến độ lịch học

- Giảng viên xác nhận tiến độ giảng dạy so với giáo trình đã đăng ký.
- Sinh viên xem tiến độ thực tế so với kế hoạch.
- Sinh viên gửi phản ánh nếu có sai lệch.

## 5. Module điểm danh

### 5.1 Điểm danh bằng QR cá nhân

#### Luồng sinh viên

- Sinh viên mở app, vào trang lịch học của buổi học và nhấn "Sinh QR điểm danh".
- QR được sinh dựa trên ID sinh viên, mã buổi học và timestamp để hạn chế việc chia sẻ QR.
- Người điểm danh, gồm giảng viên hoặc cán bộ, quét QR để hệ thống xác nhận.
- QR có thời hạn, ví dụ 5 phút, để tránh gian lận.

#### Luồng giảng viên

- Xem danh sách lớp với trạng thái đã điểm danh, vắng và chưa xử lý.
- Điểm danh thủ công từng sinh viên khi cần.
- Xuất báo cáo điểm danh theo buổi, theo tuần hoặc theo tháng.

## 6. Module AI trợ lý

### 6.1 Tổng quan

AI thay thế hoàn toàn chức năng Chat. Vị trí Chat cũ trên thanh điều hướng được chuyển thành AI. Tính năng nhắn tin với đối tác, nếu có, được chuyển sang tab Đối tác.

### 6.2 Yêu cầu chức năng

- AI có quyền truy cập dữ liệu nội bộ của người dùng trong app, gồm lịch học, deadline, điểm, môn học và transcript.
- Kết quả AI trả về có thể kèm deep link để tự động chuyển trang trong app.
- Hỗ trợ nhập liệu bằng giọng nói với Speech-to-Text tích hợp.
- AI hỗ trợ sinh viên hỏi đáp qua transcript buổi học.
- AI tư vấn kế hoạch học tập và cảnh báo nguy cơ trượt môn.

### 6.3 Kiến trúc kết nối dữ liệu AI

- Xây dựng bảng ánh xạ ID thực thể, gồm môn học, buổi học, sinh viên và deadline, để AI lấy context.
- API handler nhận kết quả AI, parse deep link và điều hướng tự động.
- Người dùng không cần nhập ID thủ công; AI tự resolve từ ngôn ngữ tự nhiên.

#### Ví dụ nguồn

Người dùng hỏi "Tuần này tôi có bao nhiêu deadline?". AI truy vấn bảng deadline theo `user_id` và tuần hiện tại, sau đó trả về kết quả kèm link "xem tất cả" dẫn đến trang Deadline.

## 7. Module todo và đầu việc

### 7.1 Danh sách todo

- Tạo, sửa và xóa đầu việc trên app.
- Phân loại đầu việc thành Online, có link hoặc tài nguyên kèm theo, và Offline, là ghi nhớ thực tế.
- Có thể gắn đầu việc với môn học hoặc buổi học cụ thể.
- Hỗ trợ offline bằng cách lưu SQLite và đồng bộ khi có mạng.

### 7.2 Tạo báo cáo / nộp bài / giao bài

- Sinh viên tải lên file nộp bài và xem trạng thái nộp.
- Giảng viên giao bài kèm deadline và đính kèm tài liệu hướng dẫn.
- Chức năng tạo báo cáo cho phép sinh viên điền form và xuất file PDF hoặc Word.

### 7.3 Kế hoạch học tập

- Sinh viên xây dựng kế hoạch học tập theo học kỳ hoặc năm học.
- Kế hoạch liên kết với thời khóa biểu và deadline.
- Ứng dụng theo dõi tiến độ thực hiện kế hoạch.

## 8. Module cổng học tập

### 8.1 Giao diện

- Bỏ tiêu đề "Cổng học tập" và thay bằng bảng thống kê môn học.
- Thống kê gồm số môn đã hoàn thành, số môn đang học và số môn trượt nếu có.
- Thêm thanh tìm kiếm chức năng, môn học hoặc tài liệu.

### 8.2 Danh sách môn học

- Hiển thị tất cả môn theo học kỳ.
- Khi click vào môn, ứng dụng hiển thị chi tiết gồm lịch học, tài liệu, deadline và điểm.
- Bộ lọc gồm học kỳ và trạng thái đang học / đã hoàn thành / trượt.

## 9. Module đăng ký tạm trú / tạm vắng

### 9.1 Mô tả

Sinh viên đăng ký tạm trú hoặc tạm vắng trực tuyến. Hệ thống in đơn có mã QR để xác minh với công an và chủ nhà.

### 9.2 Luồng xử lý

1. Sinh viên điền form đăng ký gồm thông tin cá nhân, địa chỉ và thời gian.
2. Hệ thống sinh mã đăng ký duy nhất và mã QR xác minh.
3. Hệ thống xuất đơn PDF có đầy đủ thông tin và mã QR.
4. Sinh viên in đơn và mang đến cơ quan công an.
5. Công an quét mã QR để xác minh thông tin trực tiếp với hệ thống.
6. Chủ nhà xác nhận nếu luồng nghiệp vụ yêu cầu.

### 9.3 Yêu cầu kỹ thuật

- QR chứa ID đăng ký. Khi quét, hệ thống trả về thông tin đầy đủ của đăng ký.
- Có API endpoint công khai cho công an truy vấn, bảo mật bằng token ngắn hạn.
- Lưu lịch sử đăng ký theo từng sinh viên.

## 10. Yêu cầu kỹ thuật và hạ tầng

### 10.1 Hỗ trợ offline bằng SQLite

- Sau khi đăng nhập thành công, toàn bộ dữ liệu cá nhân được đồng bộ về SQLite local.
- App hoạt động đầy đủ các tính năng xem lịch, deadline và tài liệu khi không có mạng.
- Ghi chú và todo được lưu local trước, sau đó đồng bộ khi có mạng trở lại.
- Chiến lược giải quyết xung đột: server wins cho dữ liệu học tập, client wins cho ghi chú cá nhân.

### 10.2 Analytics hành vi người dùng

- Thu thập dữ liệu ẩn danh về chức năng nào được dùng nhiều nhất.
- Dashboard nội bộ xem thống kê sử dụng theo role và theo thời gian.
- Dữ liệu analytics được dùng để gợi ý lối tắt và ưu tiên phát triển tính năng tiếp theo.
- Tuân thủ quy định PDPA và bảo mật dữ liệu.

### 10.3 Speech-to-Text

- Tích hợp Speech-to-Text vào AI trợ lý, ra đề bằng giọng nói và ghi âm buổi học thành transcript.
- Ưu tiên hỗ trợ tiếng Việt.
- Xử lý online khi có mạng và cache kết quả về local.

### 10.4 Deep link và điều hướng từ AI

- Mỗi trang trong app có một deep link scheme duy nhất.
- AI trả về kết quả kèm action có cấu trúc, ví dụ: `{ type: 'navigate', screen: 'ClassDetail', params: { classId: 'xxx' } }`.
- App handler parse action và tự động điều hướng, không cần người dùng thao tác thêm.

## 11. Tổng hợp đầu việc và ưu tiên

| # | Đầu việc | Module | Ưu tiên | Ghi chú |
|---:|---|---|---|---|
| 1 | Làm lại giao diện đăng nhập và logo | Xác thực | P0 - MVP |  |
| 2 | Bỏ chọn role, thêm đăng nhập VNied | Xác thực | P0 - MVP |  |
| 3 | Avatar dropdown gồm logout và cài đặt | Header | P0 - MVP |  |
| 4 | Trang chủ: lịch thay phần chào mừng | Trang chủ | P0 - MVP |  |
| 5 | Thời khóa biểu hiển thị ngang | Trang chủ | P0 - MVP |  |
| 6 | Deadline phần 2 | Trang chủ | P0 - MVP |  |
| 7 | Lối tắt tự cấu hình thay tổng quan nhanh | Trang chủ | P0 - MVP |  |
| 8 | Thông báo và quảng cáo phần 3 | Trang chủ | P1 |  |
| 9 | Trang chi tiết buổi học | Buổi học | P0 - MVP |  |
| 10 | Ghi chú và ghi âm trong buổi học | Buổi học | P0 - MVP | STT |
| 11 | Transcript buổi học | Buổi học | P0 - MVP | STT |
| 12 | Quiz / ra đề bằng text và giọng nói | Buổi học | P0 - MVP |  |
| 13 | Thống kê người trả lời quiz | Buổi học | P0 - MVP |  |
| 14 | Điểm danh QR cá nhân | Điểm danh | P0 - MVP |  |
| 15 | Xem danh sách vắng cho giảng viên | Điểm danh | P0 - MVP |  |
| 16 | Trang Q&A theo buổi học | Buổi học | P1 |  |
| 17 | Bộ FAQ | Buổi học | P1 |  |
| 18 | AI tích hợp dữ liệu nội bộ và deep link | AI | P0 - MVP |  |
| 19 | Speech-to-Text tích hợp AI | AI | P0 - MVP |  |
| 20 | Thay Chat bằng AI trên navigation | AI | P0 - MVP |  |
| 21 | Todo online và offline | Todo | P0 - MVP | SQLite |
| 22 | Nộp bài / giao bài / tạo báo cáo | Todo | P1 |  |
| 23 | Kế hoạch học tập | Học tập | P1 |  |
| 24 | Cổng học tập: bỏ tiêu đề, thêm thống kê và search | Cổng học tập | P1 |  |
| 25 | Đăng ký tạm trú / tạm vắng và QR | Hành chính | P2 |  |
| 26 | Lưu SQLite offline | Kỹ thuật | P0 - MVP |  |
| 27 | Analytics hành vi người dùng | Kỹ thuật | P1 |  |
| 28 | Giao diện giảng viên đơn giản | UX | P1 |  |
| 29 | Điều phối trong buổi học | Buổi học | P2 |  |
| 30 | Đánh giá sinh viên theo quá trình đóng góp | Buổi học | P2 |  |

Quy ước ưu tiên trong file nguồn:

- `P0:` Bắt buộc cho bản MVP đầu tiên.
- `P1:` Quan trọng, ưu tiên sprint 2 đến 3.
- `P2:` Tính năng nâng cao, dành cho sprint sau.

## 12. Tóm tắt thiết kế theo module

| Module | Mục đích | Kết quả mong đợi |
|---|---|---|
| Xác thực và tài khoản | Đăng nhập tập trung, tự động phân role, quản lý thông tin cá nhân | Người dùng vào app bằng VNied/email và quản lý tài khoản qua avatar |
| Trang chủ | Tổng hợp lịch, deadline, thông báo và lối tắt | Người dùng thấy việc cần làm ngay khi mở app |
| Buổi học | Gom các tác vụ trong một buổi học | Sinh viên và giảng viên thao tác theo role trên cùng một context buổi học |
| Điểm danh | Điểm danh bằng QR cá nhân và báo cáo vắng mặt | Hạn chế gian lận và giúp giảng viên theo dõi lớp |
| AI trợ lý | Thay chat, truy vấn dữ liệu nội bộ, hỗ trợ deep link | Người dùng hỏi đáp bằng ngôn ngữ tự nhiên và có thể điều hướng trực tiếp |
| Todo và đầu việc | Quản lý việc học, nộp bài, giao bài và kế hoạch | Đầu việc được lưu offline và đồng bộ khi có mạng |
| Cổng học tập | Xem thống kê và danh sách môn học | Người dùng tra cứu môn học, tài liệu, deadline và điểm |
| Tạm trú / tạm vắng | Tạo đơn hành chính có QR xác minh | Sinh viên đăng ký trực tuyến và bên ngoài có thể xác minh bằng QR |
| Kỹ thuật và hạ tầng | Offline, analytics, STT, deep link | Nền tảng hỗ trợ app hoạt động cả khi mất mạng và kết nối với AI |

## 13. Lưu ý truy xuất và giới hạn

- File Word nguồn không chứa hình ảnh media riêng trong gói `.docx`; nội dung trích xuất gồm paragraph, heading và table.
- File nguồn có header và footer đơn giản; footer chỉ hiển thị nhãn "Trang".
- Tài liệu nguồn không chứa comments có nội dung.
- Repo hiện chưa có template Markdown BD riêng trong `docs/base/`; cấu trúc Markdown này giữ trung thành với thứ tự và nội dung của file Word nguồn.
- Các yêu cầu liên quan OAuth2, VNied, endpoint công khai, analytics, STT, deep link và quyền truy cập dữ liệu AI cần được đối chiếu lại với yêu cầu bảo mật và hợp đồng API trước khi thiết kế chi tiết hoặc implement.
