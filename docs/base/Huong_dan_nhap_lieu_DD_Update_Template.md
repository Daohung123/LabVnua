# Hướng dẫn nhập liệu – DD_Update_Template

Tài liệu này hướng dẫn cách điền file **DD_Update_Template.xlsx** khi tạo tài liệu Detail Design cho từng case update trong sheet **Update**.

---

## 1. Mục đích của file DD_Update

File DD_Update dùng để mô tả **chi tiết cách dev chỉnh sửa hệ thống theo từng case thay đổi**.  
Mỗi file DD_Update chỉ nên tập trung vào **1 case** hoặc **1 nhóm thay đổi rất nhỏ, cùng luồng xử lý**.

### Khi nào dùng
- Khi có một case update cần mô tả rõ các bước triển khai.
- Khi cần bàn giao cho dev, QA, BA, PM.
- Khi cần trace từ yêu cầu nghiệp vụ sang thay đổi code thực tế.

### Nguyên tắc chung
- Nội dung phải **rõ ràng, cụ thể, có thể implement được**.
- Không viết chung chung kiểu “cập nhật logic” nếu chưa mô tả dev phải sửa gì.
- Mỗi thay đổi nên nêu rõ:
  - sửa ở đâu
  - sửa cái gì
  - ảnh hưởng gì
  - kiểm tra như thế nào
- Giữ thuật ngữ thống nhất giữa các sheet.

---

## 2. Cấu trúc file

File gồm 4 sheet:

1. **Overview**  
   Tóm tắt toàn bộ case: module, màn hình, mô tả thay đổi, tác động chính.

2. **Lịch sử thay đổi**  
   Ghi nhận version của tài liệu.

3. **Các bước thực hiện**  
   Mô tả chi tiết từng bước dev cần làm.

4. **Kết quả**  
   Mô tả kết quả mong đợi sau khi hoàn thành case và tiêu chí nghiệm thu.

---

## 3. Hướng dẫn nhập sheet `Overview`

Sheet này là phần nhìn nhanh của tài liệu.  
Chỉ ghi thông tin **quan trọng nhất**, ngắn gọn nhưng đủ ý.

### 3.1. Tiêu đề tài liệu
**Dòng 1**  
`DD_UPDATE | MODULE [TÊN MODULE]`

Cách điền:
- Thay `[TÊN MODULE]` bằng tên module thật.
- Ví dụ: `DD_UPDATE | MODULE Xác thực và Tài khoản`

**Dòng 2**  
`Case trích xuất từ sheet Update: [Id_case] | Nội dung thay đổi: [Tóm tắt thay đổi]`

Cách điền:
- `[Id_case]`: mã case lấy từ sheet Update.
- `[Tóm tắt thay đổi]`: mô tả ngắn gọn nội dung thay đổi.

### 3.2. Các trường thông tin
| Trường | Cách điền |
|---|---|
| Mã tài liệu | Luôn là `DD_Update` |
| Id_case | Mã case duy nhất lấy từ sheet Update |
| Module mẹ | Tên module cấp cha, ví dụ: `Xác thực`, `Tài khoản`, `Đơn hàng` |
| Màn hình / Thành phần | Tên màn hình, widget, component hoặc luồng liên quan |
| Tên case / Nội dung thay đổi | Tóm tắt case bằng 1 câu ngắn |
| Hiện trạng (As-Is) | Mô tả hệ thống đang hoạt động thế nào trước khi sửa |
| Vấn đề / Lý do | Vì sao cần thay đổi, lỗi gì, yêu cầu mới gì |
| Mục tiêu mới (To-Be) | Sau khi sửa thì hệ thống phải đạt trạng thái nào |
| Mô tả chi tiết thay đổi | Mô tả ngắn phần logic hoặc UI sẽ thay đổi ra sao |
| Tác động chính | Nêu các nhóm ảnh hưởng: UI, API, DB, Router, Test, Validation... |
| Nguồn dữ liệu | Ghi rõ case lấy từ sheet Update, ví dụ: `Update - dòng 12` |

### 3.3. Lưu ý khi viết Overview
- Không viết quá dài.
- Không lặp lại toàn bộ nội dung chi tiết của sheet “Các bước thực hiện”.
- Chỉ tóm tắt, không mô tả triển khai quá sâu.

---

## 4. Hướng dẫn nhập sheet `Lịch sử thay đổi`

Sheet này dùng để theo dõi version của tài liệu.

### 4.1. Các cột
| Cột | Ý nghĩa | Cách điền |
|---|---|---|
| Phiên bản | Số version tài liệu | Ví dụ: `v1.0`, `v1.1`, `v2.0` |
| Ngày cập nhật | Ngày chỉnh sửa tài liệu | Định dạng `yyyy-mm-dd` |
| Người cập nhật | Tên người chỉnh sửa | Ví dụ: `Nguyễn Văn A` |
| Nội dung thay đổi | Mô tả thay đổi của version đó | Viết ngắn gọn, rõ nội dung |
| Ghi chú | Ghi chú thêm nếu có | Ví dụ: lý do cập nhật, link liên quan |

### 4.2. Quy tắc version
- `v1.0`: bản đầu tiên.
- Tăng `v1.1`, `v1.2` khi sửa nhỏ.
- Tăng `v2.0` khi thay đổi lớn về cấu trúc hoặc logic.

### 4.3. Lưu ý
- Mỗi lần cập nhật đáng kể nên thêm 1 dòng mới.
- Không xóa lịch sử cũ nếu không có yêu cầu đặc biệt.

---

## 5. Hướng dẫn nhập sheet `Các bước thực hiện`

Đây là sheet quan trọng nhất.  
Mục tiêu là mô tả **rõ từng bước dev cần làm** theo trình tự triển khai.

### 5.1. Khối thông tin case
Phần trên của sheet gồm:
- `Id_case`
- `Module mẹ`
- `Màn hình / Thành phần`
- `Mục tiêu thay đổi`

Cách điền:
- Điền đúng thông tin của case đang mô tả.
- `Mục tiêu thay đổi` nên viết theo góc nhìn kết quả mong muốn, không viết lan man.

### 5.2. Bảng chi tiết step-by-step
| Cột | Ý nghĩa | Cách viết |
|---|---|---|
| STT | Số thứ tự bước | Từ 1, 2, 3... |
| Bước thực hiện | Tên bước ngắn gọn | Ví dụ: `Cập nhật UI`, `Sửa validation`, `Map API response` |
| Dev cần làm gì | Mô tả hành động chính | Nói rõ dev phải sửa gì |
| Chi tiết triển khai | Mô tả sâu hơn | Nêu file, logic, điều kiện, cách xử lý |
| File/Component liên quan | Tên file, class, widget, component | Ví dụ: `login_screen.dart`, `AuthBloc`, `UserModel` |
| Output mong đợi | Kết quả sau bước đó | Nêu trạng thái cần đạt |
| Kiểm tra / Lưu ý | Lưu ý test, edge case, rủi ro | Nêu điều cần verify |

### 5.3. Cách viết từng bước cho đúng
Mỗi bước nên theo logic:
1. **Phân tích thay đổi**
2. **Sửa giao diện hoặc luồng xử lý**
3. **Cập nhật model / state / API / DB nếu có**
4. **Kiểm tra và test lại**

### 5.4. Ví dụ cách viết tốt
- **Bước thực hiện**: `Cập nhật nút đăng nhập`
- **Dev cần làm gì**: `Ẩn/hiện nút theo điều kiện mới`
- **Chi tiết triển khai**: `Kiểm tra trạng thái form hợp lệ trước khi enable button`
- **File/Component liên quan**: `login_screen.dart`
- **Output mong đợi**: `Nút chỉ sáng khi form hợp lệ`
- **Kiểm tra / Lưu ý**: `Test với input rỗng, sai định dạng, đủ dữ liệu`

### 5.5. Lưu ý quan trọng
- Không viết một bước quá lớn nếu có thể tách nhỏ hơn.
- Nếu thay đổi liên quan nhiều tầng, nên tách riêng theo từng layer:
  - UI
  - State management
  - API
  - DB / cache
  - Validation
  - Navigation
  - Test
- Với case phức tạp, có thể viết 5–9 bước tùy độ lớn.

---

## 6. Hướng dẫn nhập sheet `Kết quả`

Sheet này mô tả kết quả mong đợi sau khi hoàn thành case.

### 6.1. Các cột
| Cột | Ý nghĩa | Cách điền |
|---|---|---|
| Hạng mục | Phần hệ thống bị ảnh hưởng | Ví dụ: UI, Session, Điều hướng, Lỗi |
| Kết quả mong muốn | Kết quả cần đạt | Viết ngắn, cụ thể |
| Tiêu chí nghiệm thu | Điều kiện để xác nhận đúng | Có thể kiểm thử bằng tay hoặc test case |

### 6.2. Các hạng mục nên có
Có thể dùng các dòng mẫu như:
- `[Màn hình / UI]`
- `[Xác thực / Session]`
- `[Điều hướng]`
- `[Lỗi / ngoại lệ]`
- `[Đăng xuất / Reset state]`

Tùy case thực tế, bạn có thể:
- giữ nguyên các dòng mẫu
- hoặc thay bằng hạng mục phù hợp hơn

### 6.3. Cách viết tiêu chí nghiệm thu
Nên viết theo dạng kiểm tra được:
- Người dùng làm gì
- Hệ thống phản hồi thế nào
- Khi nào được xem là đạt

Ví dụ:
- `Người dùng nhập đúng thông tin thì vào được màn hình tiếp theo`
- `Khi token hết hạn thì hiển thị thông báo và chuyển về màn hình đăng nhập`
- `Khi dữ liệu lỗi thì không crash app và hiển thị message phù hợp`

---

## 7. Quy ước nhập liệu chung

### 7.1. Quy ước nội dung
- Dùng tiếng Việt rõ ràng, thống nhất.
- Tránh viết tắt khó hiểu.
- Tránh câu quá dài.
- Ưu tiên mô tả theo động từ hành động:
  - `Thêm`
  - `Sửa`
  - `Xóa`
  - `Ẩn`
  - `Hiển thị`
  - `Validate`
  - `Map`
  - `Chuyển hướng`
  - `Gọi API`

### 7.2. Quy ước tên file / component
- Ghi đúng tên file đang sử dụng trong codebase.
- Nếu chưa chốt file cụ thể, ghi theo nhóm component để tiện trace.
- Nếu một bước liên quan nhiều file, có thể liệt kê bằng dấu phẩy.

### 7.3. Quy ước viết mô tả thay đổi
Nên theo format:
- **Trước**: hệ thống đang như thế nào
- **Sau**: hệ thống cần thành gì
- **Cách xử lý**: dev phải làm gì để đạt được thay đổi đó

---

## 8. Checklist trước khi bàn giao file DD_Update

Trước khi xuất file, hãy kiểm tra:
- [ ] Đã điền đúng `Id_case`
- [ ] Đã ghi đúng `Module mẹ`
- [ ] Đã mô tả rõ `As-Is` và `To-Be`
- [ ] Đã tách bước triển khai đủ chi tiết
- [ ] Đã ghi đúng file/component liên quan
- [ ] Đã mô tả tiêu chí nghiệm thu rõ ràng
- [ ] Không còn placeholder như `[Tên module]`, `[Id_case]`
- [ ] Nội dung thống nhất giữa các sheet

---

## 9. Mẫu điền nhanh

### Overview
- Mã tài liệu: `DD_Update`
- Id_case: `CASE_01`
- Module mẹ: `Xác thực`
- Màn hình / Thành phần: `Login Screen`
- Tên case / Nội dung thay đổi: `Ẩn role khi đăng nhập`
- Hiện trạng (As-Is): `Người dùng phải chọn role thủ công`
- Vấn đề / Lý do: `Yêu cầu tự động phân quyền`
- Mục tiêu mới (To-Be): `Hệ thống tự xác định role sau đăng nhập`
- Mô tả chi tiết thay đổi: `Bỏ chọn role ở UI, xử lý role từ dữ liệu xác thực`
- Tác động chính: `UI, Auth flow, Test`
- Nguồn dữ liệu: `Update - dòng 5`

### Các bước thực hiện
1. Cập nhật giao diện
2. Sửa luồng xử lý xác thực
3. Map role từ response
4. Kiểm tra điều hướng
5. Test edge case

### Kết quả
- UI: Không còn nút chọn role
- Xác thực / Session: Role được set tự động
- Điều hướng: Chuyển đúng màn hình theo role
- Lỗi / ngoại lệ: Không crash khi thiếu role
- Đăng xuất / Reset state: Reset đúng trạng thái

---

## 10. Kết luận

File DD_Update phải giúp dev **đọc là làm được**.  
Vì vậy, nội dung nên:
- rõ ràng,
- có trình tự,
- có đầu vào / đầu ra,
- có tiêu chí kiểm tra.

Nếu case mới phức tạp, hãy ưu tiên chia nhỏ thành nhiều bước thay vì viết dồn một đoạn dài.
