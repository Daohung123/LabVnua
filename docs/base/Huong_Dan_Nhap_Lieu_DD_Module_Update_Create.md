# HƯỚNG DẪN NHẬP LIỆU CHI TIẾT CHO 3 LOẠI DD

Tài liệu này dùng để nhập liệu thống nhất cho 3 loại tài liệu Detail Design (DD):

1. **DD_Module**: tài liệu tổng hợp cho toàn module.
2. **DD_Update**: tài liệu mô tả chi tiết từng case thay đổi (Update).
3. **DD_Create**: tài liệu mô tả chi tiết từng case/tính năng mới (Create).

---

## 1. Nguyên tắc chung khi nhập liệu

### 1.1 Mục tiêu của DD
- DD phải giúp dev hiểu được **cần làm gì**, **làm như thế nào**, **dữ liệu nào bị tác động**, và **kiểm tra ra sao**.
- Nội dung phải đủ rõ để:
  - Dev có thể code không cần hỏi lại quá nhiều.
  - QA có thể dựa vào đó để test.
  - PM/BA có thể review phạm vi thay đổi.

### 1.2 Cách viết nội dung
- Viết **ngắn gọn nhưng đủ ý**.
- Ưu tiên các cụm từ mô tả thực thi:
  - “hiển thị”
  - “validate”
  - “lưu”
  - “điều hướng”
  - “gọi API”
  - “xử lý lỗi”
- Tránh ghi chung chung như:
  - “làm đẹp hơn”
  - “cải thiện trải nghiệm”
  - “xử lý thêm”
  - “nâng cấp logic”
  nếu không có mô tả cụ thể.

### 1.3 Quy tắc đặt tên
- Tên module/tính năng phải thống nhất giữa các sheet.
- Một case nên có **1 tên chính**, dùng xuyên suốt từ Update/Create đến Result.
- Nếu có nhiều màn hình/component liên quan, ghi theo thứ tự:
  - màn hình chính
  - component con
  - action cụ thể

### 1.4 Quy tắc mô tả luồng
- Mỗi luồng nên đi theo thứ tự:
  1. Trigger / điểm vào
  2. Điều kiện kiểm tra
  3. Xử lý
  4. Output / trạng thái sau xử lý
  5. Tác động UI / API / DB / state
- Với lỗi/ngoại lệ:
  - nêu rõ nguyên nhân
  - nêu cách xử lý
  - nêu message hiển thị
  - nêu có retry hay không

---

# 2. DD_Module – Cách nhập liệu cho tài liệu module tổng hợp

DD_Module thường gồm 5 sheet:
- `Overview`
- `History`
- `Update`
- `Create`
- `Result`

Mục tiêu của file này là mô tả **toàn bộ module** ở mức tổng quan, sau đó chia ra các case thay đổi, case tạo mới và kết quả nghiệm thu.

---

## 2.1 Sheet `Overview`

### Mục đích
Ghi thông tin định danh của tài liệu.

### Cần nhập
- **Dự án**: tên dự án/sản phẩm.
- **Module**: tên module đang thiết kế.
- **Phiên bản DD**: version của tài liệu.
- **Nền tảng**: Flutter Mobile / Web / Backend / API / Admin...
- **Người phụ trách**: người tạo hoặc quản lý tài liệu.
- **Phạm vi**: mô tả ngắn module này bao gồm gì.

### Quy tắc nhập
- Tên module phải thống nhất với tên ở `History`, `Update`, `Create`, `Result`.
- Phiên bản nên theo dạng:
  - `v1.0`
  - `v1.1`
  - `v2.0`
- Nếu là tài liệu module đầu tiên, ghi rõ là:
  - `DD ban đầu`
  - `Tạo mới`

---

## 2.2 Sheet `History`

### Mục đích
Theo dõi lịch sử thay đổi tài liệu.

### Cần nhập
- **Phiên bản**
- **Ngày**
- **Người phụ trách**
- **Loại thay đổi**
- **Sheet bị ảnh hưởng**
- **Tóm tắt thay đổi**
- **Lý do**
- **Trạng thái**

### Quy tắc nhập
- Mỗi lần cập nhật tài liệu nên thêm 1 dòng history.
- Nội dung “Tóm tắt thay đổi” phải ngắn nhưng đủ để nhận biết thay đổi gì.
- Trạng thái nên dùng thống nhất:
  - `Hoàn thành`
  - `Chưa hoàn thành`
  - `Đang review`
  - `Cần chỉnh sửa`

---

## 2.3 Sheet `Update`

### Mục đích
Danh sách các **thay đổi hiện có** của module.

### Ý nghĩa từng cột
- **STT**: số thứ tự case update.
- **Module**: tên module con hoặc module chính.
- **Màn hình / Thành phần**: nơi có thay đổi.
- **Hiện trạng (As-Is)**: trạng thái hiện tại trước khi sửa.
- **Vấn đề / Lý do**: vì sao cần thay đổi.
- **Mục tiêu mới (To-Be)**: kết quả mong muốn sau thay đổi.
- **Mô tả thay đổi**: mô tả ngắn cách thay đổi sẽ được thực hiện.
- **Tác động UI**: thay đổi hiển thị.
- **Tác động logic / luồng**: thay đổi logic điều hướng/xử lý.
- **Tác động API / DB / State**: dữ liệu nào bị ảnh hưởng.
- **Tiêu chí nghiệm thu**: điều kiện để xem case là đạt.
- **Điểm cần test**: các điểm QA cần kiểm tra.
- **Ghi chú**: thông tin bổ sung.
- **Link tài liệu mô tả xử lý**: link sang DD chi tiết nếu có.

### Cách viết đúng
#### As-Is
Chỉ mô tả đúng hiện trạng đang có, không lẫn giải pháp.

#### Vấn đề / Lý do
Nêu nguyên nhân thực tế:
- khó dùng
- sai luồng
- thiếu chức năng
- không an toàn
- không đồng nhất

#### To-Be
Mô tả đầu ra mong muốn, không đi quá sâu vào kỹ thuật.

#### Mô tả thay đổi
Viết một câu hoặc vài câu ngắn:
- thay đổi UI nào
- thay đổi luồng nào
- thay đổi dữ liệu nào
- thay đổi cách xử lý nào

### Lỗi thường gặp
- Ghi To-Be quá chung chung.
- Ghi cả giải pháp kỹ thuật vào cột “Vấn đề / Lý do”.
- Quên nêu tác động API/DB/State.
- Một case quá lớn nhưng không tách thành nhiều dòng.

---

## 2.4 Sheet `Create`

### Mục đích
Liệt kê các **tính năng/thành phần mới** cần xây từ đầu.

### Ý nghĩa từng cột
- **STT**: số thứ tự.
- **Module / tính năng mới**: tên chức năng hoặc component.
- **Vai trò sử dụng**: ai dùng tính năng này.
- **Mục đích**: chức năng này để làm gì.
- **Điểm kích hoạt / vào màn hình**: người dùng vào từ đâu.
- **Luồng người dùng**: các bước chính người dùng đi qua.
- **Màn hình / Component**: nơi hiển thị hoặc component được tạo.
- **Dữ liệu cần có**: input, field, object, metadata.
- **Backend / API**: endpoint, service, integration liên quan.
- **State / Storage**: trạng thái cần lưu ở app/local/remote.
- **Tiêu chí nghiệm thu**: điều kiện hoàn thành.
- **Điểm cần test**: các tình huống kiểm tra.
- **Ghi chú**: ràng buộc, giả định, lưu ý.
- **Link tài liệu mô tả xử lý**: link sang DD chi tiết nếu cần.

### Cách viết đúng
#### Module / tính năng mới
Nên đặt theo kiểu:
- `Auth state manager`
- `Form đăng ký`
- `Màn hình chọn lớp`
- `Service lưu token`

#### Vai trò sử dụng
Nếu nhiều vai trò, ghi rõ:
- `Sinh viên`
- `Giảng viên`
- `Quản trị`
- `Hệ thống`

#### Dữ liệu cần có
Phải liệt kê rõ input cần thiết:
- text field
- enum
- file
- token
- id
- list dữ liệu

#### Backend / API
Nếu chưa có API cụ thể, vẫn nên ghi:
- cần API gì
- mục đích của API
- dữ liệu vào/ra mong muốn

#### State / Storage
Ghi rõ dữ liệu lưu ở đâu:
- memory state
- secure storage
- local database
- shared preferences
- remote backend

### Lỗi thường gặp
- Chỉ mô tả UI mà quên backend/state.
- Ghi tên component nhưng không mô tả mục đích.
- Không mô tả trigger để vào tính năng.
- Thiếu tiêu chí nghiệm thu.

---

## 2.5 Sheet `Result`

### Mục đích
Mô tả kết quả cuối cùng cần đạt và cách nghiệm thu.

### Ý nghĩa từng cột
- **STT**
- **Module / tính năng**
- **Kết quả cuối mong đợi**
- **Đầu ra nhìn thấy bởi người dùng**
- **Kết quả kỹ thuật**
- **Cách kiểm tra**
- **Tiêu chí đạt**
- **Dấu hiệu lỗi**

### Cách viết đúng
- `Kết quả cuối mong đợi`: mô tả outcome cuối cùng.
- `Đầu ra nhìn thấy bởi người dùng`: user thấy gì.
- `Kết quả kỹ thuật`: state/API/DB/route/logic đạt trạng thái gì.
- `Cách kiểm tra`: test theo hành động cụ thể.
- `Tiêu chí đạt`: chỉ rõ khi nào được tính là pass.
- `Dấu hiệu lỗi`: mô tả tình trạng fail dễ nhận biết.

### Lỗi thường gặp
- Chỉ ghi lại việc user nhìn thấy, không ghi kỹ thuật.
- Tiêu chí đạt quá mơ hồ.
- Dấu hiệu lỗi không đủ để QA nhận biết.

---

# 3. DD_Update – Cách nhập liệu cho tài liệu mô tả chi tiết 1 case Update

File DD_Update dùng để phân tích **1 case thay đổi** từ sheet `Update` thành tài liệu xử lý chi tiết.

## 3.1 Mục tiêu của DD_Update
Tài liệu phải trả lời được:
- Case này là gì?
- Phạm vi đến đâu?
- Luồng main flow diễn ra như thế nào?
- Có ngoại lệ nào?
- Validate ở đâu?
- Tác động API/DB/State ra sao?
- Test case nào cần cover?

---

## 3.2 Phần 1 – Thông tin case nguồn từ sheet Update

### Cần điền
- **STT**
- **Module**
- **Màn hình / Thành phần**
- **Hiện trạng (As-Is)**
- **Vấn đề / Lý do**
- **Mục tiêu mới (To-Be)**
- **Mô tả thay đổi**
- **Tác động UI**
- **Tác động logic / luồng**
- **Tác động API / DB / State**
- **Tiêu chí nghiệm thu**
- **Điểm cần test**
- **Ghi chú**
- **Link tài liệu mô tả xử lý**

### Cách nhập
- Đây là phần “tóm tắt case”.
- Chỉ nên lấy **1 case đúng nghĩa** từ sheet Update.
- Nếu case update quá lớn, tách ra nhiều DD_Update riêng.

### Quy tắc
- Nội dung ở phần này phải khớp với dòng gốc trong sheet Update.
- Không thêm chi tiết vượt quá case gốc.
- Link tài liệu nên trỏ tới:
  - DD chi tiết hiện tại
  - hoặc tài liệu liên quan nếu có

---

## 3.3 Phần 2.1 – Bối cảnh & phạm vi

### `Mục tiêu chi tiết`
Ghi mục tiêu cụ thể của case.

Ví dụ:
- Bỏ chọn vai trò thủ công khi đăng nhập.
- Bổ sung luồng validate lỗi từ server.
- Điều hướng theo role sau khi login thành công.

### `Phạm vi bao gồm`
Ghi rõ những phần được làm:
- UI
- logic
- API
- state
- validate
- error handling
- persistence

### `Phạm vi không bao gồm`
Ghi rõ những phần **không làm** để tránh mở rộng phạm vi ngoài ý muốn.

### `Giả định / phụ thuộc`
Ghi các điều kiện phụ thuộc:
- API đã có
- backend trả đúng schema
- token format ổn định
- role đã có trong claims/profile
- UI có component nền tảng sẵn

### Lỗi thường gặp
- Không ghi phạm vi loại trừ.
- Không nêu phụ thuộc vào API/backend.
- Mục tiêu chi tiết viết trùng với mô tả tổng quan.

---

## 3.4 Phần 2.2 – Luồng xử lý chi tiết (Main Flow)

### Ý nghĩa cột
- **Bước**: số thứ tự xử lý.
- **Trigger / Input**: điều gì kích hoạt bước này.
- **Điều kiện / Rule**: rule áp dụng trước khi xử lý.
- **Xử lý chi tiết**: dev cần làm gì ở bước đó.
- **Output / State**: trạng thái đầu ra sau bước.
- **UI thay đổi**: thay đổi hiển thị.
- **API / DB**: call API, lưu DB, cập nhật state.
- **Ghi chú**: thông tin bổ sung.

### Cách viết
Main flow nên mô tả theo dạng:
1. Người dùng thực hiện hành động.
2. Hệ thống kiểm tra điều kiện.
3. Hệ thống xử lý.
4. Trạng thái cập nhật.
5. Kết quả hiển thị/điều hướng.

### Ví dụ cấu trúc logic
- Bước 1: người dùng bấm nút.
- Bước 2: kiểm tra dữ liệu đầu vào.
- Bước 3: gọi API.
- Bước 4: nhận response.
- Bước 5: lưu state.
- Bước 6: điều hướng sang màn hình tiếp theo.

### Lưu ý
- Một bước chỉ nên mô tả **một hành động chính**.
- Nếu có nhiều nhánh điều kiện, tách thành nhiều bước hoặc đưa sang phần ngoại lệ.
- Không viết gộp tất cả vào 1 dòng dài khó đọc.

---

## 3.5 Phần 2.3 – Ngoại lệ / nhánh thay thế

### Ý nghĩa cột
- **Tình huống**: case lỗi hoặc nhánh khác.
- **Nguyên nhân**: lý do phát sinh.
- **Cách xử lý**: hệ thống xử lý thế nào.
- **Thông báo người dùng**: message hiển thị.
- **Có retry?**: có cho thử lại hay không.
- **Rollback / Recovery**: có quay lui trạng thái không.
- **Trường / dữ liệu**: field hoặc dữ liệu liên quan.
- **Rule kiểm tra**: rule validate.
- **Vị trí validate**: client / server / UI / backend.
- **Message lỗi**: nội dung lỗi.
- **Mức độ**: high / medium / low.

### Cách viết
Mỗi hàng tương ứng một ngoại lệ:
- input sai
- API fail
- timeout
- token hết hạn
- permission denied
- mất mạng
- dữ liệu rỗng
- trạng thái không hợp lệ

### Nên ghi rõ
- lỗi xảy ra ở đâu
- ai xử lý
- hiển thị gì
- người dùng có được phép thử lại không
- có xóa/reset state không

### Lỗi thường gặp
- Chỉ ghi “thông báo lỗi” mà không ghi nguyên nhân.
- Không nêu retry.
- Không chỉ ra validate ở client hay server.

---

## 3.6 Phần 2.5 – Tiêu chí nghiệm thu & Test case

### `Tiêu chí nghiệm thu`
Đây là điều kiện để xác định case đã hoàn thành.

Nên viết theo dạng:
- Sau khi xử lý xong, người dùng nhìn thấy gì.
- Hệ thống lưu/điều hướng/validate ra sao.
- Không còn lỗi nào thuộc phạm vi case.

### `Test case`
Mỗi test case nên có:
- **Test ID**
- **Scenario**
- **Precondition**
- **Steps**
- **Expected Result**
- **Priority**

### Cách viết test case tốt
- Mỗi case nên có test cả:
  - happy path
  - lỗi input
  - lỗi API
  - trạng thái loading
  - trạng thái retry
  - trạng thái permission/auth nếu liên quan

### Lỗi thường gặp
- Test case chỉ có happy path.
- Expected Result quá ngắn.
- Không ghi precondition.

---

## 3.7 Phần 2.6 – Ghi chú & phê duyệt

### Cần điền
- Người soạn
- Người review
- Ngày tạo
- Phiên bản
- Trạng thái
- Link DD

### Quy tắc
- Luôn cập nhật khi sửa tài liệu.
- Link DD nên dùng để truy vết sang file gốc hoặc bản phân rã chi tiết hơn.

---

# 4. DD_Create – Cách nhập liệu cho tài liệu mô tả chi tiết 1 case Create

File DD_Create dùng để mô tả **1 tính năng mới** hoặc **1 component mới** cần xây từ đầu.

## 4.1 Mục tiêu của DD_Create
Tài liệu phải trả lời được:
- Tính năng mới này dùng cho ai?
- Nó dùng để làm gì?
- Điểm kích hoạt ở đâu?
- Luồng người dùng ra sao?
- Cần dữ liệu gì?
- Cần API / state / storage nào?
- Điều kiện nghiệm thu là gì?
- Test ra sao?

---

## 4.2 Phần thông tin case nguồn

Khi copy từ sheet `Create`, cần lấy đúng:
- Tên module/tính năng mới
- Vai trò sử dụng
- Mục đích
- Điểm kích hoạt
- Luồng người dùng
- Màn hình / Component
- Dữ liệu cần có
- Backend / API
- State / Storage
- Tiêu chí nghiệm thu
- Điểm cần test
- Ghi chú
- Link tài liệu mô tả xử lý

### Cách viết tốt
- **Vai trò sử dụng**: ghi rõ ai dùng, không ghi chung chung.
- **Mục đích**: viết theo outcome.
- **Điểm kích hoạt**: cho biết user đi từ đâu vào.
- **Luồng người dùng**: mô tả theo bước.
- **Dữ liệu cần có**: liệt kê đầy đủ field/input.

---

## 4.3 Phân rã tính năng mới

### `Màn hình / Component`
Ghi rõ:
- là screen mới
- component tái sử dụng
- dialog
- bottom sheet
- widget
- service
- controller/bloc/provider

### `Backend / API`
Nên nêu:
- cần endpoint nào
- request/response kỳ vọng
- xử lý khi API chưa có
- mapping dữ liệu từ backend sang UI

### `State / Storage`
Nên mô tả:
- state local
- state tạm trong màn hình
- cache
- persistence
- secure storage

### `Tiêu chí nghiệm thu`
Nên mô tả theo hành vi quan sát được:
- đúng UI
- đúng dữ liệu
- đúng điều hướng
- đúng validate
- đúng lưu trạng thái

---

## 4.4 Lỗi thường gặp khi nhập DD_Create
- Chỉ mô tả component, không mô tả user flow.
- Thiếu dữ liệu đầu vào.
- Không nói rõ API/state/storage.
- Đưa tiêu chí nghiệm thu quá mơ hồ.
- Tên tính năng mới không khớp giữa Create và Result.

---

# 5. Quy tắc liên kết giữa 3 loại DD

## 5.1 Luồng đúng nên là
1. **DD_Module**
   - mô tả toàn bộ module
   - liệt kê các case Update/Create
   - ghi kết quả mong đợi

2. **DD_Update**
   - phân rã sâu 1 case thay đổi từ sheet Update

3. **DD_Create**
   - phân rã sâu 1 case tính năng mới từ sheet Create

## 5.2 Quy tắc đồng bộ nội dung
- Một case đã có trong `Update` hoặc `Create` thì tên phải đồng nhất trong DD chi tiết.
- Nếu tách 1 case lớn thành nhiều DD chi tiết, cần đánh dấu rõ:
  - part 1
  - part 2
  - hoặc sub-case

## 5.3 Quy tắc link
- `Update/Create` nên có link sang file DD chi tiết.
- `DD chi tiết` nên có link ngược về dòng case nguồn.
- `Result` nên bám theo case trong `Update/Create`.

---

# 6. Checklist trước khi nộp file

## DD_Module
- [ ] Đã nhập đủ Overview
- [ ] History có phiên bản mới nhất
- [ ] Update mô tả đủ case thay đổi
- [ ] Create mô tả đủ tính năng mới
- [ ] Result khớp với Update/Create
- [ ] Tên module thống nhất toàn file

## DD_Update
- [ ] Có case nguồn rõ ràng
- [ ] Có bối cảnh & phạm vi
- [ ] Có main flow theo thứ tự
- [ ] Có ngoại lệ / nhánh thay thế
- [ ] Có tiêu chí nghiệm thu
- [ ] Có test case
- [ ] Có người review / version / status

## DD_Create
- [ ] Tên tính năng mới rõ ràng
- [ ] Mô tả vai trò sử dụng
- [ ] Có trigger / điểm vào
- [ ] Có user flow
- [ ] Có dữ liệu cần có
- [ ] Có backend / API / state / storage
- [ ] Có tiêu chí nghiệm thu
- [ ] Có điểm test

---

# 7. Mẫu câu gợi ý khi viết nội dung

## Mẫu mô tả Update
- `Người dùng hiện phải ...`
- `Cần thay đổi để ...`
- `Sau khi cập nhật, hệ thống sẽ ...`
- `App tự động ...`
- `Trường hợp lỗi, hiển thị ...`

## Mẫu mô tả Create
- `Tính năng này cho phép ...`
- `Người dùng truy cập từ ...`
- `Luồng xử lý gồm ...`
- `Dữ liệu cần có bao gồm ...`
- `Khi hoàn thành, hệ thống ...`

## Mẫu mô tả nghiệm thu
- `Khi thực hiện ..., hệ thống phải ...`
- `Người dùng nhìn thấy ...`
- `Dữ liệu được lưu vào ...`
- `Không phát sinh lỗi ...`
- `Điều hướng đúng sang ...`

---

# 8. Kết luận

- `DD_Module` dùng cho bức tranh tổng thể.
- `DD_Update` dùng để bóc chi tiết từng case thay đổi.
- `DD_Create` dùng để bóc chi tiết từng case/tính năng mới.
- Khi nhập liệu, ưu tiên **rõ phạm vi, rõ luồng, rõ tác động, rõ kiểm tra**.

Nếu cần, có thể tái sử dụng tài liệu này làm template chuẩn cho các module khác bằng cách thay tên module, tên tính năng và case nguồn.
