Thư mục chứa các giá trị cố định (immutable) được sử dụng xuyên suốt toàn bộ ứng dụng.

Mục đích:
Tránh hard-code
Đảm bảo tính nhất quán
Dễ bảo trì và thay đổi

Bao gồm:
colors → màu sắc UI
strings → text hiển thị
sizes → kích thước, spacing
assets → đường dẫn ảnh/icon
api → endpoint backend
storage_keys → key lưu local
config → cấu hình chung (app name, version)

Lưu ý:
Sử dụng static const
Không chứa logic
Không lưu dữ liệu nhạy cảm (API key, secret)