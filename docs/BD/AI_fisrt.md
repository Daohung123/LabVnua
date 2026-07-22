# AI hóa ứng dụng:
## A. Tạo chức năng chuyển đổi giọng nói thành văn bản
## B. Chức năng AI hóa cho ứng dụng:
- UI: Thêm nút biểu tượng cho mic ở thanh menu nổi.
- Luồng hoạt động: 
1. Người dùng chọn nút mic AI => Hiển thị UI AI
2. Hiển thị UI cho phép người dùng có thể nói và trờ chuyện cùng AI
3. AI nhận data từ người dùng.
4. Gửi yêu cầu cho AI để phân loại task:
 - Task NoSQLite: Là loại task hỏi không liên quan tới cơ sở dữ liệu của người dùng
 - Task SQLite: là task hỏi có sự liên quan tới người dùng (Đọc file lib\config\config_db.dart để xác định cấu trúc dữ liệu SQLite)
 - Task di chuyển màn hình: Task này dùng khi người dùng muốn di chuyển màn hình để xem chức năng nào đó.
5. Sau khi phân loại task thì sẽ có rẽ nhánh như sau:
- Task NoSQLite thì sẽ trả lời bằng kiến thức của AI Gemini
- Task SQLite thì sẽ xác định các bảng cần truy vấn, các module cần lấy data và sẽ lấy sau đó gửi bảng data từ bảng SQLite đó cho AI xử lý và trả về
- Task di chuyển màn hình thì ứng dụng sẽ chuyển các màn hình hiện có cho AI và đợi AI phản hồi và chuyển view.

6. Lưu ý:
- Luồng hoạt động chung cho mọi task:
User nói => chuyển giọng nói sang văn bản => gửi văn bản tới AI => AI phản hồi lại lệnh thao tác(nếu có) kèm giọng nói => Nhận thao tác và giọng nói => Phản hồi bằng giọng nói trước khi thao tác logic.

- Ngôn ngữ chính và được ưu tiên là tiếng việt và chỉ tiếng việt.

## C. Cấu hình Gemini

- Ứng dụng nhận `GEMINI_API_KEY` và `GEMINI_MODEL` bằng compile-time define
  qua `flutter run --dart-define-from-file=.env`.
- File `.env` chỉ tồn tại ở máy phát triển, bị Git ignore; dùng
  `.env.example` làm mẫu và không ghi key thật vào tài liệu, mã nguồn hoặc log.
- `GEMINI_MODEL` mặc định là `gemini-3.5-flash` và có thể thay đổi theo môi
  trường sau khi kiểm thử tương thích.
- Key trong ứng dụng mobile không phải bí mật tuyệt đối vì được đóng gói cùng
  client. Production cần giới hạn key phù hợp và dùng backend proxy khi cần
  bảo vệ secret phía máy chủ.
