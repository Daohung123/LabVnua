# Hướng dẫn nhập liệu chi tiết cho DD_Create_Template

## 1. Mục đích tài liệu

Tài liệu này hướng dẫn cách điền **template DD_Create** trong file Excel `DD_Create_Template(1).xlsx`.

Template dùng để mô tả chi tiết một **case tạo mới** trong module **Xác thực & Tài khoản**.  
Khi áp dụng cho case khác, chỉ cần thay nội dung ở các trường:

- `Id_case`
- `Tên case`
- `Mô tả case`
- `Điểm vào / kích hoạt`
- `Thành phần ảnh hưởng`
- `Dữ liệu & API`
- `Các bước thực hiện`
- `Kết quả mong đợi`

---

## 2. Cấu trúc file template

File gồm 4 sheet:

1. **Overview**  
   Mô tả tổng quan case: dự án, module, id case, tên case, loại thay đổi, mô tả nghiệp vụ, điểm kích hoạt, thành phần ảnh hưởng, dữ liệu & API.

2. **Lịch sử thay đổi**  
   Ghi lại phiên bản tài liệu, người phụ trách, nội dung sửa đổi và trạng thái.

3. **Các bước thực hiện**  
   Mô tả chi tiết từng bước dev cần làm để triển khai case.

4. **Kết quả**  
   Mô tả tiêu chí nghiệm thu, cách kiểm tra và dấu hiệu lỗi.

---

## 3. Nguyên tắc nhập liệu chung

### 3.1. Cách viết nội dung
- Viết **ngắn gọn nhưng đủ ý**, ưu tiên câu rõ ràng, cụ thể.
- Mỗi ô nên mô tả **một ý chính**.
- Dùng thuật ngữ nhất quán giữa các sheet.
- Nếu một case có API, phải nêu rõ:
  - endpoint
  - request
  - response
  - rule validate / business rule liên quan

### 3.2. Nguyên tắc đặt tên
- `Id_case`: dùng mã duy nhất, dễ tra cứu, ví dụ: `AUTH_CREATE_01`, `LOGIN_OTP_CREATE_02`.
- `Tên case`: mô tả đúng nghiệp vụ, ví dụ: `Tạo mới màn hình đổi mật khẩu`.
- `Loại thay đổi`: chọn một trong các giá trị phù hợp:
  - `Create mới`
  - `Update`
  - `Fix`
  - `Refactor`

### 3.3. Khi nào cần bổ sung file liên quan
Nếu case tác động đến nhiều tầng, nên ghi rõ:
- Screen / View
- Component
- Controller / Bloc / Provider
- Service
- Repository
- Route
- Storage / Cache

### 3.4. Cách viết dữ liệu kỹ thuật
Trong phần kỹ thuật, nên chỉ ra:
- file nào cần sửa
- hàm nào cần chỉnh
- dữ liệu nào cần map
- dữ liệu nào cần lưu
- luồng nào cần điều hướng

---

## 4. Hướng dẫn nhập sheet `Overview`

Sheet này là phần mô tả tổng quan case.  
Mục tiêu là để người đọc nhìn vào là hiểu ngay: **case gì, thuộc module nào, thay đổi gì, chạm vào đâu**.

### 4.1. Cấu trúc sheet
Sheet gồm 2 cột:

| Cột | Ý nghĩa |
|---|---|
| Hạng mục | Tên trường thông tin cần điền |
| Nội dung | Giá trị mô tả tương ứng |

### 4.2. Ý nghĩa từng trường

| Hạng mục | Cách điền | Gợi ý nội dung |
|---|---|---|
| Dự án | Tên hệ thống / sản phẩm | Ví dụ: `Learning App`, `Study2Work` |
| Module mẹ | Module lớn chứa case | Ví dụ: `Xác thực & Tài khoản` |
| Id_case | Mã định danh case | Ví dụ: `AUTH_CREATE_01` |
| Tên case | Tên chức năng / nghiệp vụ | Ví dụ: `Tạo mới chức năng đăng nhập bằng OTP` |
| Loại thay đổi | Loại xử lý | Chọn: `Create mới` / `Update` / `Fix` / `Refactor` |
| Mô tả case | Mô tả ngắn nghiệp vụ | Nêu case dùng để làm gì |
| Điểm vào / kích hoạt | Nơi bắt đầu thao tác | Màn hình, button, event, route |
| Thành phần ảnh hưởng | Các thành phần bị tác động | Screen, component, service, repository... |
| Dữ liệu & API | Dữ liệu và giao tiếp liên quan | field, endpoint, request, response, model |

### 4.3. Cách viết từng ô

#### Dự án
Điền tên dự án thực tế đang triển khai.  
Không dùng mô tả chung chung như “app” hoặc “system” nếu dự án đã có tên chính thức.

#### Module mẹ
Điền tên module cấp cao nhất.  
Ví dụ:
- `Xác thực & Tài khoản`
- `Quản lý người dùng`
- `Đơn hàng`
- `Thanh toán`

#### Id_case
Là mã case duy nhất, nên có quy ước đồng nhất để dễ tìm kiếm.  
Ví dụ:
- `AUTH_CREATE_01`
- `AUTH_UPDATE_02`
- `PROFILE_CREATE_01`

#### Tên case
Nên là tên chức năng/nghiệp vụ người đọc hiểu ngay.  
Ví dụ:
- `Tạo mới màn hình đăng ký tài khoản`
- `Thêm chức năng quên mật khẩu`
- `Cập nhật luồng xác thực OTP`

#### Loại thay đổi
Chỉ chọn một giá trị phù hợp nhất:
- `Create mới`: tạo chức năng hoàn toàn mới
- `Update`: chỉnh sửa chức năng hiện có
- `Fix`: sửa lỗi
- `Refactor`: tái cấu trúc nhưng không thay đổi nghiệp vụ chính

#### Mô tả case
Mô tả ngắn gọn:
- người dùng làm gì
- hệ thống phản hồi gì
- mục tiêu nghiệp vụ là gì

Ví dụ:
> Cho phép người dùng nhập số điện thoại để nhận mã OTP và xác thực tài khoản.

#### Điểm vào / kích hoạt
Ghi rõ điểm bắt đầu luồng.  
Ví dụ:
- Màn hình `Login`
- Button `Đăng ký`
- Event `onSubmit`
- Route `/register`

#### Thành phần ảnh hưởng
Liệt kê các thành phần sẽ phải chỉnh sửa.  
Ví dụ:
- `RegisterScreen`
- `RegisterBloc`
- `AuthService`
- `AuthRepository`
- `AppRoute`

#### Dữ liệu & API
Ghi rõ các dữ liệu liên quan:
- field input
- request body
- response
- endpoint
- model
- rule validate

Ví dụ:
- `phoneNumber`
- `otpCode`
- `POST /auth/send-otp`
- `POST /auth/verify-otp`

---

## 5. Hướng dẫn nhập sheet `Lịch sử thay đổi`

Sheet này dùng để ghi log thay đổi của tài liệu.  
Mỗi lần cập nhật template hoặc cập nhật nội dung case, nên thêm 1 dòng mới.

### 5.1. Cấu trúc cột

| Cột | Ý nghĩa |
|---|---|
| Phiên bản | Số phiên bản tài liệu |
| Ngày | Ngày cập nhật |
| Người phụ trách | Người thực hiện thay đổi |
| Loại thay đổi | Nội dung thay đổi thuộc loại gì |
| Sheet bị ảnh hưởng | Sheet nào bị sửa |
| Tóm tắt thay đổi | Mô tả ngắn nội dung thay đổi |
| Lý do | Vì sao phải thay đổi |
| Trạng thái | Draft / Hoàn thành / Đang cập nhật |

### 5.2. Cách điền
- **Phiên bản**: dùng định dạng tăng dần, ví dụ `1.0`, `1.1`, `2.0`
- **Ngày**: dùng định dạng chuẩn `yyyy-mm-dd`
- **Người phụ trách**: tên người sửa
- **Loại thay đổi**: ví dụ `Khởi tạo template`, `Cập nhật nội dung case`, `Bổ sung validation`
- **Sheet bị ảnh hưởng**: ghi rõ sheet liên quan
- **Tóm tắt thay đổi**: ghi 1 câu ngắn, đúng trọng tâm
- **Lý do**: vì sao cần thay đổi
- **Trạng thái**: ví dụ `Draft`, `Review`, `Hoàn thành`

### 5.3. Quy tắc quản lý lịch sử
- Không ghi đè lịch sử cũ.
- Mỗi thay đổi quan trọng phải có 1 dòng riêng.
- Tóm tắt thay đổi nên ngắn và dễ đọc.
- Nếu thay đổi ảnh hưởng đến logic test hoặc nghiệm thu, cần cập nhật thêm sheet `Kết quả`.

---

## 6. Hướng dẫn nhập sheet `Các bước thực hiện`

Sheet này là phần quan trọng nhất.  
Mục tiêu là mô tả **từng bước dev cần làm** để hoàn thành case.

### 6.1. Mục tiêu của sheet
Sheet này phải trả lời được 5 câu hỏi:
1. Dev cần làm gì trước?
2. Dev cần sửa file nào?
3. UI/form thay đổi ra sao?
4. API/logic/state xử lý thế nào?
5. Lỗi được xử lý ra sao?

### 6.2. Ý nghĩa các cột

| Cột | Ý nghĩa |
|---|---|
| STT | Thứ tự bước thực hiện |
| Id_case | Mã case tương ứng |
| Hạng mục | Tên nhóm công việc |
| Mục tiêu bước | Mục tiêu cụ thể của bước đó |
| Dev cần làm gì? | Mô tả hành động dev phải thực hiện |
| File / Component | File, màn hình, component, service cần chỉnh |
| UI / Form | Thay đổi giao diện, field, layout, trạng thái |
| API / Logic | Endpoint, request, response, rule xử lý |
| State / Storage | Trạng thái, cache, local storage, redux/bloc/provider |
| Xử lý lỗi | Cách xử lý lỗi ở bước đó |
| Kết quả mong đợi | Kết quả sau khi hoàn thành bước |
| Kiểm tra | Cách kiểm tra bước thực hiện |
| Điều kiện pass | Điều kiện để bước được xem là đạt |
| Lưu ý | Những điểm cần tránh / cần chú ý |
| Tài liệu / Link | Link tài liệu liên quan |

### 6.3. Cách viết nội dung từng bước

#### Bước 1: Khảo sát luồng hiện tại
Ghi các việc như:
- đọc lại luồng cũ
- xác định màn hình / component / service liên quan
- kiểm tra file nào đang render UI
- kiểm tra nơi gọi API
- kiểm tra trạng thái đang được lưu ở đâu

**Mục tiêu:** dev biết rõ phạm vi trước khi code.

#### Bước 2: Cập nhật UI / Form
Ghi các việc như:
- chỉnh form
- thêm/xóa field
- đổi label, placeholder
- thêm validation message
- thêm loading state
- disable button khi chưa hợp lệ

**Mục tiêu:** giao diện đúng theo nghiệp vụ và dễ sử dụng.

#### Bước 3: Kết nối submit với API / Logic
Ghi rõ:
- trim dữ liệu trước khi gửi
- validate lại trước submit
- gọi service/repository/api
- xử lý loading
- map response về model/state
- xử lý lỗi 4xx/5xx/network

**Mục tiêu:** thao tác chính chạy đúng luồng.

#### Bước 4: Lưu dữ liệu / State / Điều hướng
Ghi rõ:
- lưu dữ liệu nào
- cập nhật state nào
- điều hướng sang đâu
- reset form hay refresh dữ liệu
- sync storage nếu cần

**Mục tiêu:** sau khi thành công, app ở trạng thái đúng.

#### Bước 5: Xử lý lỗi + nghiệm thu
Ghi rõ:
- map message lỗi
- giữ dữ liệu hợp lệ
- cho phép retry
- chuẩn bị checklist test
- xác định case lỗi nghiệp vụ và lỗi hệ thống

**Mục tiêu:** dev và QA có tiêu chí rõ để kiểm tra.

### 6.4. Gợi ý cách viết theo cột

#### `Hạng mục`
Nên đặt tên nhóm công việc ngắn gọn và rõ ràng, ví dụ:
- Khảo sát luồng hiện tại
- Cập nhật UI / Form
- Kết nối submit với API / Logic
- Lưu dữ liệu / State / Điều hướng
- Xử lý lỗi + nghiệm thu

#### `Mục tiêu bước`
Phải trả lời “bước này để làm gì?”.  
Ví dụ:
- Xác định điểm chạm và file phải sửa trước khi code.
- Chuẩn hóa giao diện theo yêu cầu nghiệp vụ.

#### `Dev cần làm gì?`
Là phần mô tả chi tiết nhất của bước.  
Nên viết theo thứ tự hành động:
1. kiểm tra
2. chỉnh sửa
3. test
4. xác nhận

#### `File / Component`
Nên liệt kê tên file hoặc nhóm file có thể ảnh hưởng.  
Ví dụ:
- `LoginScreen`
- `RegisterForm`
- `AuthService`
- `AuthRepository`

#### `UI / Form`
Mô tả các thay đổi hiển thị:
- field nào
- button nào
- trạng thái nào
- layout ra sao
- responsive như thế nào

#### `API / Logic`
Mô tả:
- endpoint
- method
- payload
- response
- rule xử lý

#### `State / Storage`
Mô tả:
- state local/global nào thay đổi
- dữ liệu có cần lưu local không
- có sync cache hay không

#### `Xử lý lỗi`
Nêu rõ:
- lỗi mạng
- lỗi server
- lỗi validate
- lỗi dữ liệu không hợp lệ
- fallback / retry

#### `Kết quả mong đợi`
Mỗi bước nên có 1 câu mô tả rõ trạng thái mong muốn sau khi làm xong.

#### `Kiểm tra`
Nên ghi cách kiểm tra thực tế:
- chạy app
- thử nhập data
- test happy path
- test lỗi mạng
- test loading / retry

#### `Điều kiện pass`
Là tiêu chí để kết luận bước đó đạt.  
Ví dụ:
- form hiển thị đúng
- submit gọi đúng API
- response lỗi không làm crash
- state sau thành công đúng

#### `Lưu ý`
Ghi những điều cần tránh:
- không log dữ liệu nhạy cảm
- không lưu plain text cho dữ liệu nhạy cảm
- không làm vỡ layout
- không bỏ sót file phụ thuộc

#### `Tài liệu / Link`
Ghi link đến:
- Basic Design
- API spec
- ticket
- mockup
- backlog

---

## 7. Hướng dẫn nhập sheet `Kết quả`

Sheet này mô tả tiêu chí nghiệm thu sau khi dev hoàn thành case.  
Mục tiêu là để QA, dev và người review có cùng một chuẩn kiểm tra.

### 7.1. Ý nghĩa các cột

| Cột | Ý nghĩa |
|---|---|
| STT | Thứ tự tiêu chí |
| Hạng mục nghiệm thu | Nhóm nội dung cần kiểm tra |
| Kết quả mong đợi | Điều cần đạt |
| Hiển thị cho user | User nhìn thấy gì |
| Kết quả kỹ thuật | Trạng thái bên trong hệ thống |
| Cách kiểm tra | Cách test |
| Tiêu chí đạt | Điều kiện pass |
| Dấu hiệu lỗi | Dấu hiệu cho thấy lỗi |

### 7.2. Các nhóm nghiệm thu nên có

#### UI / Form
Kiểm tra:
- layout
- label
- placeholder
- button state
- validation hiển thị đúng

#### Luồng chính
Kiểm tra:
- submit thành công
- điều hướng đúng
- dữ liệu được ghi đúng
- trạng thái sau thao tác đúng

#### Dữ liệu / Validation
Kiểm tra:
- nhập sai định dạng
- thiếu dữ liệu
- dữ liệu vượt giới hạn
- message lỗi đúng

#### Lỗi hệ thống / mạng
Kiểm tra:
- mất mạng
- server trả lỗi
- timeout
- retry hoạt động đúng

#### State / Storage
Kiểm tra:
- sau khi quay lại app / màn hình, dữ liệu còn đúng
- cache / storage không bị sai
- state không bị reset bất thường

### 7.3. Cách viết tiêu chí đạt
Tiêu chí đạt phải đo được, tránh viết chung chung.  
Ví dụ:
- “Nút submit chỉ bật khi form hợp lệ”
- “Sau khi lưu thành công, màn hình chuyển sang trang chi tiết”
- “Lỗi mạng hiển thị toast và cho phép retry”

### 7.4. Cách viết dấu hiệu lỗi
Dấu hiệu lỗi nên mô tả rõ:
- màn hình trắng
- button bị treo
- message lỗi sai
- mất dữ liệu đã nhập
- app crash
- điều hướng sai route

---

## 8. Mẫu cách điền nhanh cho 1 case

### 8.1. Overview
- **Dự án:** Study2Work
- **Module mẹ:** Xác thực & Tài khoản
- **Id_case:** AUTH_CREATE_01
- **Tên case:** Tạo mới chức năng đăng ký tài khoản bằng số điện thoại
- **Loại thay đổi:** Create mới
- **Mô tả case:** Cho phép người dùng nhập số điện thoại để nhận OTP và tạo tài khoản mới.
- **Điểm vào / kích hoạt:** Màn hình Login, nút `Đăng ký`
- **Thành phần ảnh hưởng:** `RegisterScreen`, `RegisterBloc`, `AuthService`, `AuthRepository`
- **Dữ liệu & API:** `phoneNumber`, `POST /auth/send-otp`, `POST /auth/verify-otp`

### 8.2. Các bước thực hiện
1. Khảo sát luồng hiện tại  
2. Cập nhật UI / Form  
3. Kết nối submit với API / Logic  
4. Lưu dữ liệu / State / Điều hướng  
5. Xử lý lỗi + nghiệm thu  

### 8.3. Kết quả
- Form hiển thị đúng
- Gửi OTP thành công
- Nhập OTP sai hiển thị lỗi đúng
- Lỗi mạng có thông báo retry
- Trạng thái sau khi thành công được lưu đúng

---

## 9. Checklist trước khi bàn giao

Trước khi hoàn tất file DD, nên tự kiểm tra:

- [ ] `Id_case` đã duy nhất và đúng quy ước
- [ ] `Tên case` mô tả đúng nghiệp vụ
- [ ] `Mô tả case` ngắn gọn, dễ hiểu
- [ ] `Điểm vào / kích hoạt` rõ ràng
- [ ] `Thành phần ảnh hưởng` không bị thiếu file quan trọng
- [ ] `Dữ liệu & API` có đủ endpoint, request, response
- [ ] `Các bước thực hiện` mô tả đủ UI, logic, state, lỗi
- [ ] `Kết quả` có đủ happy path và case lỗi
- [ ] `Lịch sử thay đổi` có ghi phiên bản và trạng thái

---

## 10. Quy ước trình bày khuyến nghị

Để file dễ đọc và dễ dùng cho team dev, nên áp dụng các quy ước sau:

- Giữ ngôn ngữ đồng nhất trong toàn bộ file.
- Không ghi quá dài ở các ô cần ngắn gọn.
- Dùng từ khóa kỹ thuật nhất quán: `API`, `state`, `storage`, `validation`, `routing`, `fallback`.
- Nếu một case có nhiều nhánh xử lý, nên tách thành nhiều bước rõ ràng.
- Nếu có thay đổi không liên quan đến nghiệp vụ, ghi riêng ở `Lưu ý`.

---

## 11. Kết luận

Template này được thiết kế để mô tả case tạo mới theo hướng:
- rõ ràng về nghiệp vụ
- đủ chi tiết cho dev triển khai
- đủ tiêu chí cho QA kiểm thử
- dễ mở rộng cho các case khác

Khi nhập liệu, hãy ưu tiên trả lời 4 câu hỏi:
1. **Case này là gì?**
2. **Dev cần sửa ở đâu?**
3. **Xử lý dữ liệu và API thế nào?**
4. **Khi nào được xem là hoàn thành?**