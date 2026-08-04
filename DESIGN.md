# DESIGN.md — Cổng thông tin đào tạo

> **Phiên bản:** 1.0  
> **Nền tảng chính:** Flutter Mobile — Android/iOS  
> **Loại sản phẩm:** Cổng thông tin đào tạo dạng Super App  
> **Đối tượng ưu tiên:** Sinh viên; mở rộng cho giảng viên, ban đào tạo và quản trị viên  
> **Định hướng:** Tối giản, tinh tế, thân thiện; lấy cảm hứng từ sự rõ ràng của iOS nhưng không sao chép nguyên mẫu giao diện Apple.

---

## 1. Mục tiêu thiết kế

Thiết kế phải giúp người dùng:

1. Tìm được thông tin học tập quan trọng trong tối đa **3 thao tác**.
2. Nhìn nhanh được trạng thái hôm nay: lịch học, thông báo, hạn đăng ký, học phí và tiến độ.
3. Sử dụng tốt bằng một tay trên điện thoại.
4. Hiểu được mọi trạng thái của hệ thống: đang tải, thành công, lỗi, không có dữ liệu hoặc mất mạng.
5. Cảm thấy giao diện nhẹ, tin cậy và không bị quá tải thông tin.

### Tiêu chí thành công

- Giao diện sử dụng một màu nhấn chính.
- Không dùng quá nhiều card, đường viền, bóng đổ hoặc hiệu ứng.
- Nội dung quan trọng luôn nổi bật hơn nội dung trang trí.
- Thành phần giống nhau phải có hành vi và hình thức giống nhau.
- Mỗi màn hình chỉ nên có một hành động chính.
- Các tác vụ thường dùng phải tiếp cận được từ trang chủ hoặc thanh điều hướng chính.

---

## 2. Nguyên tắc thiết kế cốt lõi

### 2.1. Clear First

Ưu tiên khả năng đọc và hiểu trước yếu tố trang trí.

- Tiêu đề rõ ràng.
- Nhãn ngắn gọn.
- Không dùng thuật ngữ nội bộ nếu sinh viên không hiểu.
- Không đặt quá nhiều thông tin cùng cấp độ thị giác.

### 2.2. One Primary Action

Mỗi màn hình chỉ có một hành động chính rõ ràng.

Ví dụ:

- Màn hình đăng ký học phần: `Đăng ký`.
- Màn hình phản hồi: `Gửi phản hồi`.
- Màn hình học phí: `Thanh toán`.
- Màn hình hồ sơ: `Lưu thay đổi`.

### 2.3. Calm Interface

Giao diện phải tạo cảm giác bình tĩnh và đáng tin cậy.

- Nền sáng trung tính.
- Bóng đổ rất nhẹ.
- Hạn chế màu bão hòa.
- Không dùng gradient làm phong cách mặc định.
- Không dùng animation gây phân tâm.
- Không hiển thị quá nhiều badge màu đỏ.

### 2.4. Progressive Disclosure

Chỉ hiển thị thông tin cần thiết ở bước hiện tại.

- Thông tin tóm tắt hiển thị trước.
- Chi tiết mở bằng bottom sheet, accordion hoặc màn hình riêng.
- Bộ lọc nâng cao được đặt sau nút `Bộ lọc`.
- Không đưa toàn bộ dữ liệu học tập lên trang chủ.

### 2.5. Familiar Interaction

Ưu tiên cách tương tác quen thuộc trên thiết bị di động.

- Chạm để mở chi tiết.
- Vuốt xuống để làm mới.
- Bottom sheet cho lựa chọn ngắn.
- Dialog chỉ dùng cho hành động quan trọng hoặc không thể hoàn tác.
- Nút quay lại luôn có vị trí và hành vi nhất quán.

---

## 3. Kiến trúc trải nghiệm

### 3.1. Điều hướng chính

Thanh điều hướng dưới gồm tối đa 5 mục:

| Vị trí | Mục | Chức năng |
|---|---|---|
| 1 | Trang chủ | Tổng quan học tập hôm nay |
| 2 | Học tập | Lịch học, điểm, lịch thi, chương trình đào tạo |
| 3 | Dịch vụ | Tín chỉ, học phí, thủ tục, tiện ích campus |
| 4 | Thông báo | Thông báo đào tạo và nhắc việc |
| 5 | Cá nhân | Hồ sơ, cài đặt, hỗ trợ |

### 3.2. Hành động toàn cục

Các chức năng có thể được truy cập toàn cục:

- Tìm kiếm.
- Trợ lý AI.
- Thông báo chưa đọc.
- Quét QR.
- Hỗ trợ khẩn cấp hoặc báo lỗi.

Không đặt nhiều hơn 2 hành động toàn cục trên App Bar.

### 3.3. Phân nhóm chức năng

#### Học tập

- Lịch học.
- Lịch thi.
- Kết quả học tập và GPA.
- Chương trình đào tạo.
- Môn tiên quyết.
- Tiến độ tích lũy tín chỉ.
- Điểm danh.

#### Dịch vụ đào tạo

- Đăng ký tín chỉ.
- Học phí.
- Đăng ký nguyện vọng.
- Thủ tục và biểu mẫu.
- Tra cứu hồ sơ.
- Phản hồi và khiếu nại.

#### Tiện ích sinh viên

- Bản đồ trường.
- Sơ đồ và tìm phòng học.
- Tra cứu giảng viên.
- Danh bạ sinh viên.
- Xe bus trường.
- Ký túc xá.
- Căn tin và dịch vụ.
- Wi-Fi campus.

#### Hỗ trợ và tương tác

- Chat với phòng đào tạo.
- Chat với giảng viên.
- Trợ lý AI.
- FAQ.
- Gửi phản hồi.
- Báo lỗi hệ thống.

---

## 4. Ngôn ngữ thị giác

### 4.1. Đặc trưng

- Tối giản.
- Nhiều khoảng trắng.
- Phân cấp chữ rõ.
- Màu xanh dương làm màu nhấn chính.
- Card trắng trên nền xám rất nhạt.
- Góc bo mềm nhưng không quá tròn.
- Icon nét đơn giản, đồng nhất.
- Tránh hiệu ứng kính mờ quá mức.

### 4.2. Quy tắc sử dụng màu

Áp dụng quy tắc **Single Accent**:

- Màu xanh là màu tương tác chính.
- Màu xanh lá chỉ dùng cho thành công.
- Màu cam chỉ dùng cho cảnh báo.
- Màu đỏ chỉ dùng cho lỗi hoặc hành động nguy hiểm.
- Màu tím chỉ dùng cho AI nếu cần phân biệt trợ lý thông minh.
- Không dùng màu chỉ để trang trí.

---

## 5. Design Tokens

### 5.1. Color Tokens

#### Brand

| Token | Giá trị | Mục đích |
|---|---:|---|
| `color.primary` | `#0A84FF` | Nút chính, liên kết, trạng thái được chọn |
| `color.primaryPressed` | `#0066CC` | Trạng thái nhấn |
| `color.primarySoft` | `#EAF4FF` | Nền lựa chọn, chip, thông tin nhẹ |
| `color.ai` | `#7C5CFC` | Trợ lý AI, dùng có kiểm soát |
| `color.aiSoft` | `#F1EEFF` | Nền khu vực AI |

#### Neutral

| Token | Giá trị | Mục đích |
|---|---:|---|
| `color.background` | `#F5F7FA` | Nền ứng dụng |
| `color.surface` | `#FFFFFF` | Card, sheet, input |
| `color.surfaceAlt` | `#F9FAFB` | Nền phụ |
| `color.border` | `#E5E7EB` | Viền mặc định |
| `color.divider` | `#EEF0F3` | Đường phân cách |
| `color.textPrimary` | `#111827` | Nội dung chính |
| `color.textSecondary` | `#667085` | Nội dung phụ |
| `color.textTertiary` | `#98A2B3` | Placeholder, metadata |
| `color.disabled` | `#D0D5DD` | Thành phần bị vô hiệu hóa |

#### Semantic

| Token | Giá trị | Mục đích |
|---|---:|---|
| `color.success` | `#22A06B` | Thành công, đã hoàn tất |
| `color.successSoft` | `#EAF8F2` | Nền trạng thái thành công |
| `color.warning` | `#F79009` | Cảnh báo, sắp đến hạn |
| `color.warningSoft` | `#FFF4E5` | Nền cảnh báo |
| `color.error` | `#E5484D` | Lỗi, hành động nguy hiểm |
| `color.errorSoft` | `#FFF0F0` | Nền lỗi |
| `color.info` | `#0A84FF` | Thông tin |
| `color.infoSoft` | `#EAF4FF` | Nền thông tin |

### 5.2. Dark Mode

Dark Mode không bắt buộc trong phiên bản đầu, nhưng token phải hỗ trợ mở rộng.

| Token | Giá trị đề xuất |
|---|---:|
| `dark.background` | `#0F1115` |
| `dark.surface` | `#171A21` |
| `dark.surfaceAlt` | `#1D212A` |
| `dark.border` | `#2B303B` |
| `dark.textPrimary` | `#F5F7FA` |
| `dark.textSecondary` | `#A9B0BC` |

Không đảo màu trực tiếp. Mỗi semantic token phải được ánh xạ riêng cho Dark Mode.

### 5.3. Typography

Ưu tiên font hệ thống để giao diện nhẹ và tự nhiên:

```text
iOS: SF Pro Display / SF Pro Text
Android: Roboto
Fallback: Inter, Arial, sans-serif
```

Không bắt buộc nhúng SF Pro vào ứng dụng.

| Token | Size | Weight | Line height | Mục đích |
|---|---:|---:|---:|---|
| `display` | 32 | 700 | 40 | Số liệu nổi bật |
| `titleLarge` | 24 | 700 | 32 | Tiêu đề màn hình |
| `titleMedium` | 20 | 600 | 28 | Tiêu đề khu vực |
| `titleSmall` | 17 | 600 | 24 | Tiêu đề card |
| `bodyLarge` | 16 | 400 | 24 | Nội dung chính |
| `bodyMedium` | 14 | 400 | 20 | Nội dung mặc định |
| `bodySmall` | 13 | 400 | 18 | Metadata |
| `labelLarge` | 15 | 600 | 20 | Nút |
| `labelMedium` | 13 | 600 | 18 | Chip, tab |
| `caption` | 12 | 400 | 16 | Ghi chú |

Quy tắc:

- Không dùng chữ nhỏ hơn 12 px.
- Nội dung dài dùng weight 400.
- Không dùng quá 3 mức chữ trong cùng một card.
- Không viết hoa toàn bộ câu.
- Số liệu và trạng thái cần dùng tabular figures nếu font hỗ trợ.

### 5.4. Spacing

Hệ thống khoảng cách theo lưới 4 px, ưu tiên nhịp 8 px.

| Token | Giá trị |
|---|---:|
| `space.1` | 4 |
| `space.2` | 8 |
| `space.3` | 12 |
| `space.4` | 16 |
| `space.5` | 20 |
| `space.6` | 24 |
| `space.8` | 32 |
| `space.10` | 40 |
| `space.12` | 48 |

Quy ước:

- Padding ngang màn hình: 16 px.
- Khoảng cách giữa section: 24–32 px.
- Padding card: 16 px.
- Khoảng cách icon và label: 8–12 px.
- Không sử dụng giá trị lẻ không thuộc token nếu không có lý do rõ ràng.

### 5.5. Radius

| Token | Giá trị | Mục đích |
|---|---:|---|
| `radius.small` | 8 | Chip, badge |
| `radius.medium` | 12 | Input, button |
| `radius.large` | 16 | Card |
| `radius.xlarge` | 24 | Bottom sheet |
| `radius.full` | 999 | Avatar, pill |

Không bo tròn mọi thành phần. List item đơn giản có thể không cần card hoặc radius.

### 5.6. Elevation

| Token | Giá trị |
|---|---|
| `shadow.none` | Không có |
| `shadow.low` | `0 1px 3px rgba(16, 24, 40, 0.06)` |
| `shadow.medium` | `0 6px 18px rgba(16, 24, 40, 0.08)` |
| `shadow.overlay` | `0 16px 40px rgba(16, 24, 40, 0.14)` |

Quy tắc:

- Card thông thường ưu tiên border hoặc `shadow.low`.
- Không dùng shadow đậm cho button.
- Bottom sheet và dialog dùng `shadow.overlay`.
- Không dùng nhiều mức elevation trong cùng một màn hình.

### 5.7. Motion

| Token | Thời lượng | Mục đích |
|---|---:|---|
| `motion.fast` | 120 ms | Press, hover |
| `motion.normal` | 200 ms | Chuyển trạng thái |
| `motion.slow` | 320 ms | Sheet, page transition |

Easing đề xuất:

```text
standard: cubic-bezier(0.2, 0, 0, 1)
decelerate: cubic-bezier(0, 0, 0, 1)
accelerate: cubic-bezier(0.3, 0, 1, 1)
```

Animation chỉ được dùng để:

- Làm rõ quan hệ giữa hai trạng thái.
- Phản hồi thao tác.
- Giảm cảm giác thay đổi đột ngột.

---

## 6. Layout

### 6.1. Safe Area

- Tất cả màn hình phải tôn trọng `SafeArea`.
- Nội dung không bị che bởi camera, tai thỏ hoặc thanh điều hướng.
- Bottom sheet phải có khoảng cách đáy phù hợp thiết bị.

### 6.2. Kích thước chạm

- Touch target tối thiểu: **44 × 44 px**.
- Nút chính cao: **48–52 px**.
- Icon button hiển thị 24 px nhưng vùng chạm tối thiểu 44 px.
- Khoảng cách giữa hai hành động nguy hiểm tối thiểu 12 px.

### 6.3. Responsive

#### Mobile nhỏ: `< 360 px`

- Giảm khoảng cách, không giảm cỡ chữ dưới chuẩn.
- Card thống kê chuyển từ 2 cột thành 1 cột nếu bị chật.
- Nhãn dài được xuống dòng tối đa 2 dòng.

#### Mobile tiêu chuẩn: `360–599 px`

- Layout mặc định.
- Grid chức năng 3 cột.
- Card thống kê 2 cột.

#### Tablet: `600–1023 px`

- Giới hạn chiều rộng nội dung.
- Grid chức năng 4–5 cột.
- Có thể dùng navigation rail.
- Chi tiết và danh sách có thể hiển thị dạng master–detail.

#### Desktop/Web: `>= 1024 px`

- Nội dung chính tối đa 1200 px.
- Sidebar cố định hoặc navigation rail mở rộng.
- Không kéo giãn card toàn màn hình.
- Ưu tiên bảng dữ liệu cho nghiệp vụ quản trị.

---

## 7. Thành phần giao diện

## 7.1. App Bar

### Mặc định

- Chiều cao 56 px.
- Tiêu đề căn trái.
- Tối đa 2 icon action.
- Không dùng logo trên mọi màn hình.
- Có thể trong suốt khi nằm trên nền chính và chuyển sang nền trắng khi cuộn.

### Large Title

Chỉ dùng cho màn hình cấp cao:

- Trang chủ.
- Học tập.
- Dịch vụ.
- Thông báo.
- Cá nhân.

Large title thu gọn khi cuộn.

## 7.2. Bottom Navigation

- Tối đa 5 mục.
- Icon 24 px.
- Label 11–12 px.
- Mục đang chọn dùng `color.primary`.
- Mục không chọn dùng `color.textTertiary`.
- Không dùng nền màu khác nhau cho từng mục.
- Badge thông báo chỉ hiển thị số khi thật sự cần.

## 7.3. Button

### Primary Button

- Nền `color.primary`.
- Chữ trắng.
- Cao 50 px.
- Radius 12 px.
- Không dùng shadow.
- Chỉ một primary button nổi bật trong vùng nhìn.

### Secondary Button

- Nền `color.primarySoft`.
- Chữ `color.primary`.
- Không dùng border nếu nền đã đủ rõ.

### Outline Button

- Nền trắng.
- Border `color.border`.
- Chữ `color.textPrimary`.

### Text Button

- Không nền.
- Dùng cho hành động phụ hoặc liên kết.

### Destructive Button

- Chỉ dùng `color.error` cho hành động xóa, hủy đăng ký hoặc đăng xuất khỏi toàn bộ thiết bị.
- Phải có bước xác nhận nếu hành động không thể hoàn tác.

### Trạng thái

Mọi button phải hỗ trợ:

- Default.
- Pressed.
- Disabled.
- Loading.
- Success tạm thời nếu cần.

Khi loading, giữ nguyên chiều rộng nút để tránh layout bị giật.

## 7.4. Input

- Cao tối thiểu 48 px.
- Label hiển thị bên trên hoặc floating label.
- Placeholder không thay thế label.
- Border mặc định `color.border`.
- Focus dùng border `color.primary`.
- Error dùng border và helper text `color.error`.
- Có nút xóa nhanh cho search input.
- Password có nút hiện/ẩn.
- Không validate khi người dùng chưa tương tác, trừ lỗi hệ thống bắt buộc.

## 7.5. Card

### Standard Card

- Nền trắng.
- Radius 16 px.
- Padding 16 px.
- Border 1 px hoặc `shadow.low`.
- Không đồng thời dùng border đậm và shadow.

### Action Card

Dùng cho lối tắt chức năng:

- Icon nằm trên hoặc bên trái.
- Label tối đa 2 dòng.
- Có trạng thái pressed.
- Không chứa đoạn mô tả dài.

### Information Card

Dùng cho:

- Lịch học tiếp theo.
- Học phí.
- Hạn đăng ký.
- GPA.
- Thông báo quan trọng.

Mỗi card chỉ có một mục đích thông tin chính.

## 7.6. List Item

Cấu trúc chuẩn:

```text
[Leading] [Title                         ] [Trailing]
          [Subtitle / metadata           ]
```

- Cao tối thiểu 56 px.
- Dùng divider thay vì bọc mỗi item bằng card.
- Trailing có thể là chevron, trạng thái hoặc giá trị.
- Không đặt quá 2 hành động trực tiếp trong một item.

## 7.7. Chip và Badge

### Chip

Dùng cho:

- Bộ lọc.
- Trạng thái lựa chọn.
- Nhóm học phần.
- Loại thông báo.

### Badge

Dùng cho:

- Chưa đọc.
- Sắp đến hạn.
- Có lỗi.
- Trạng thái hồ sơ.

Badge chỉ dùng text ngắn, tối đa 12 ký tự.

## 7.8. Tabs

- Dùng khi có 2–4 nhóm nội dung cùng cấp.
- Tab đang chọn dùng underline 2 px hoặc pill nhẹ.
- Không dùng tab cho quy trình tuần tự.
- Cho phép cuộn ngang khi có nhiều tab nhưng ưu tiên rút gọn số lượng.

## 7.9. Bottom Sheet

Dùng cho:

- Chọn học kỳ.
- Chọn bộ lọc.
- Chọn hành động.
- Xem chi tiết ngắn.
- Xác nhận có nhiều lựa chọn.

Quy tắc:

- Radius trên 24 px.
- Có drag handle.
- Padding ngang 20 px.
- Không dùng bottom sheet cho nội dung biểu mẫu quá dài.

## 7.10. Dialog

Chỉ dùng cho:

- Xác nhận hành động quan trọng.
- Thông báo lỗi nghiêm trọng.
- Yêu cầu quyền hệ thống.
- Session hết hạn.

Dialog phải có tiêu đề rõ và tối đa 2 hành động.

## 7.11. Snackbar và Toast

- Thành công: hiển thị 2–3 giây.
- Lỗi cần xử lý: snackbar có hành động `Thử lại`.
- Không hiển thị nhiều snackbar liên tiếp.
- Không dùng toast cho thông tin quan trọng cần đọc.

---

## 8. Mẫu màn hình chính

## 8.1. Trang chủ

### Thứ tự nội dung

1. Lời chào ngắn và avatar.
2. Lịch học hoặc sự kiện gần nhất.
3. Cảnh báo quan trọng.
4. Lối tắt chức năng thường dùng.
5. Tóm tắt học tập.
6. Thông báo mới.
7. Trợ lý AI.

### Quy tắc

- Không hiển thị quá 6 lối tắt đầu tiên.
- Có nút `Xem tất cả`.
- Lịch học tiếp theo phải là thành phần nổi bật nhất.
- Trạng thái hôm nay quan trọng hơn số liệu tổng hợp dài hạn.
- Không sử dụng carousel tự động.

## 8.2. Lịch học

- Chế độ mặc định: tuần.
- Có nút chuyển ngày/tuần/tháng.
- Môn học sử dụng màu rất nhẹ, không dùng màu bão hòa.
- Hiển thị rõ: tên môn, thời gian, phòng, giảng viên.
- Môn đang diễn ra có nhãn `Đang học`.
- Môn sắp diễn ra có nhãn thời gian còn lại.
- Khi không có lịch, hiển thị empty state tích cực.

## 8.3. Kết quả học tập

Ưu tiên:

1. GPA hiện tại.
2. Tín chỉ tích lũy.
3. Tiến độ chương trình.
4. Danh sách học phần theo học kỳ.

Không dùng biểu đồ nếu bảng hoặc progress bar truyền đạt rõ hơn.

## 8.4. Đăng ký tín chỉ

Quy trình:

```text
Chọn học kỳ → Tìm học phần → Xem lớp mở → Kiểm tra điều kiện → Xác nhận
```

Phải hiển thị rõ:

- Số tín chỉ.
- Lịch học.
- Sĩ số.
- Điều kiện tiên quyết.
- Xung đột lịch.
- Trạng thái đăng ký.

Màu đỏ chỉ dùng cho lỗi hoặc xung đột thực sự.

## 8.5. Học phí

- Hiển thị tổng phải đóng.
- Hiển thị số đã đóng và còn thiếu.
- Phân tách rõ từng khoản.
- Deadline phải nổi bật nhưng không gây hoảng loạn.
- Nút thanh toán chỉ hiển thị khi có khoản phải thanh toán.
- Biên lai và lịch sử thanh toán nằm ở màn hình chi tiết.

## 8.6. Thông báo

- Tab: `Tất cả`, `Đào tạo`, `Học tập`, `Hệ thống`.
- Thông báo chưa đọc dùng nền xanh rất nhạt.
- Không dùng chữ đậm toàn bộ nội dung.
- Metadata gồm nguồn gửi và thời gian.
- Hỗ trợ đánh dấu đã đọc.
- Thông báo quan trọng có pin hoặc badge, không dùng nền đỏ toàn card.

## 8.7. Trợ lý AI

AI phải có phong cách riêng nhưng vẫn thuộc hệ thống.

- Dùng `color.ai` có kiểm soát.
- Không biến toàn bộ màn hình thành màu tím.
- Câu trả lời dùng card hoặc bubble đơn giản.
- Hiển thị nguồn dữ liệu khi câu trả lời liên quan quy định đào tạo.
- Có trạng thái `AI có thể trả lời chưa chính xác`.
- Các hành động gợi ý ngắn, tối đa 3.
- Không tự động gửi dữ liệu cá nhân nhạy cảm vào hội thoại nếu chưa được phép.

## 8.8. Tính năng khác

Bố cục:

```text
Banner ngắn
Section: Tiện ích sinh viên
Grid 3 cột
Section: Hỗ trợ và tương tác
Grid 3 cột
```

- Mỗi item có icon, label và vùng chạm rõ.
- Không dùng card quá lớn.
- Không thêm mô tả dưới mọi icon.
- Nhóm chức năng được phân tách bằng khoảng trắng và tiêu đề.

---

## 9. Trạng thái hệ thống

Mọi màn hình lấy dữ liệu phải có đầy đủ các trạng thái sau.

### 9.1. Loading

- Dùng skeleton tương ứng với bố cục thật.
- Không dùng spinner toàn màn hình cho dữ liệu có thể tải theo vùng.
- Giữ ổn định layout.
- Sau 8 giây có thể hiển thị thông báo tải chậm.

### 9.2. Empty

Empty state gồm:

1. Icon đơn giản.
2. Tiêu đề ngắn.
3. Mô tả một câu.
4. Hành động nếu có.

Ví dụ:

```text
Chưa có lịch học hôm nay
Bạn có thể xem lịch của cả tuần để chủ động kế hoạch.
[Xem lịch tuần]
```

### 9.3. Error

- Nêu rõ lỗi bằng ngôn ngữ người dùng.
- Có nút `Thử lại`.
- Không hiển thị stack trace, mã kỹ thuật hoặc response thô.
- Nếu một vùng lỗi, không làm hỏng toàn bộ màn hình.

### 9.4. Offline

- Hiển thị banner nhỏ `Đang sử dụng dữ liệu đã lưu`.
- Dữ liệu cache phải có thời gian cập nhật cuối.
- Cho phép người dùng tiếp tục xem dữ liệu offline.
- Hành động cần mạng phải báo trước khi thực hiện.

### 9.5. Permission

Giải thích lý do trước khi gọi permission hệ thống.

Ví dụ:

- Camera: dùng để quét QR điểm danh.
- Notification: dùng để nhắc lịch học và hạn đăng ký.
- Storage: chỉ yêu cầu khi người dùng tải hoặc chọn tài liệu.

---

## 10. Accessibility

### Yêu cầu tối thiểu

- Contrast text thường đạt tối thiểu 4.5:1.
- Text lớn đạt tối thiểu 3:1.
- Không truyền đạt trạng thái chỉ bằng màu.
- Hỗ trợ tăng kích thước chữ.
- Screen reader đọc được label của icon button.
- Thứ tự focus hợp lý.
- Touch target tối thiểu 44 × 44 px.
- Animation tôn trọng `reduce motion`.
- Không khóa orientation nếu không bắt buộc.

### Nội dung thay thế

Icon không có label trực quan phải có semantic label.

Ví dụ:

```dart
Semantics(
  label: 'Mở thông báo',
  button: true,
  child: IconButton(...),
)
```

---

## 11. Content Design

### 11.1. Giọng điệu

- Lịch sự.
- Ngắn gọn.
- Chủ động.
- Không đổ lỗi cho người dùng.
- Không dùng ngôn ngữ máy móc.

### 11.2. Quy tắc viết

| Không nên | Nên dùng |
|---|---|
| `Dữ liệu rỗng` | `Chưa có dữ liệu` |
| `Request thất bại` | `Không thể tải thông tin` |
| `Sai input` | `Vui lòng kiểm tra thông tin đã nhập` |
| `Submit` | `Gửi` hoặc `Xác nhận` |
| `OK` | Tên hành động cụ thể |
| `Cancel` | `Hủy` |

### 11.3. Ngày và giờ

- Ngày: `24/07/2026`.
- Giờ: `08:30`.
- Khoảng thời gian: `08:30–10:15`.
- Dùng `Hôm nay`, `Ngày mai` khi hữu ích nhưng vẫn có ngày cụ thể trong chi tiết.

### 11.4. Số liệu

- GPA: tối đa 2 chữ số thập phân.
- Học phí: định dạng `1.250.000 ₫`.
- Tín chỉ: dùng số nguyên.
- Không viết tắt gây mơ hồ.

---

## 12. Iconography và hình ảnh

### Icon

- Dùng một bộ icon duy nhất.
- Kích thước chuẩn: 20, 24 và 28 px.
- Stroke tương đương 1.75–2 px.
- Không trộn icon filled và outlined tùy tiện.
- Icon chỉ dùng màu khi có ý nghĩa trạng thái.

### Illustration

- Chỉ dùng cho onboarding, empty state và lỗi lớn.
- Illustration phải đơn giản, ít màu.
- Không dùng ảnh stock không liên quan môi trường giáo dục.
- Không dùng mascot ở mọi màn hình.

### Avatar

- Kích thước chuẩn: 32, 40, 48, 64 px.
- Có fallback bằng chữ cái đầu.
- Không để ảnh biến dạng.
- Chỉ hiển thị viền trạng thái khi thật sự cần.

---

## 13. Quy tắc dữ liệu và quyền riêng tư trong UI

- Không hiển thị mã sinh viên, email hoặc số điện thoại đầy đủ trên màn hình công khai.
- Dữ liệu nhạy cảm phải được che một phần khi cần.
- Không hiển thị điểm hoặc học phí trong notification preview nếu người dùng chưa cho phép.
- Hành động liên quan tài chính phải yêu cầu xác nhận rõ ràng.
- Người dùng phải biết dữ liệu được lấy từ nguồn nào và thời điểm cập nhật cuối.
- Không dùng dark pattern để ép bật thông báo, định vị hoặc camera.

---

## 14. Flutter Implementation Guide

### 14.1. Cấu trúc đề xuất

```text
lib/
├── app/
│   ├── app.dart
│   ├── router/
│   └── theme/
│       ├── app_colors.dart
│       ├── app_spacing.dart
│       ├── app_radius.dart
│       ├── app_typography.dart
│       ├── app_shadows.dart
│       └── app_theme.dart
├── core/
│   ├── widgets/
│   │   ├── app_button.dart
│   │   ├── app_card.dart
│   │   ├── app_text_field.dart
│   │   ├── app_empty_state.dart
│   │   ├── app_error_state.dart
│   │   ├── app_skeleton.dart
│   │   └── app_section_header.dart
│   └── extensions/
└── features/
```

### 14.2. Token mẫu

```dart
import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF0A84FF);
  static const primaryPressed = Color(0xFF0066CC);
  static const primarySoft = Color(0xFFEAF4FF);

  static const background = Color(0xFFF5F7FA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF9FAFB);
  static const border = Color(0xFFE5E7EB);
  static const divider = Color(0xFFEEF0F3);

  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF667085);
  static const textTertiary = Color(0xFF98A2B3);

  static const success = Color(0xFF22A06B);
  static const warning = Color(0xFFF79009);
  static const error = Color(0xFFE5484D);
  static const ai = Color(0xFF7C5CFC);
}

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

abstract final class AppRadius {
  static const small = 8.0;
  static const medium = 12.0;
  static const large = 16.0;
  static const xLarge = 24.0;
}
```

### 14.3. ThemeData mẫu

```dart
ThemeData buildLightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
    primary: AppColors.primary,
    surface: AppColors.surface,
    error: AppColors.error,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.background,
    splashFactory: InkSparkle.splashFactory,
    fontFamily: 'Inter',
    visualDensity: VisualDensity.standard,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
    ),
  );
}
```

### 14.4. Quy tắc code UI

- Không khai báo màu trực tiếp trong feature.
- Không khai báo spacing ngẫu nhiên trong widget.
- Không sao chép component giữa các module.
- Component dùng lại từ 2 nơi trở lên phải được đưa vào `core/widgets`.
- Widget màn hình không nên chứa logic nghiệp vụ.
- Không gọi API trực tiếp trong widget UI.
- Mọi màn hình async phải xử lý loading, empty, error và offline.
- Không dùng `Container` cho mọi thành phần khi `Padding`, `DecoratedBox`, `SizedBox` hoặc component semantic phù hợp hơn.
- Hạn chế widget tree lồng quá sâu.
- Thêm `const` khi có thể.
- Kiểm tra overflow với text scale lớn và màn hình nhỏ.

---

## 15. Component Acceptance Checklist

Mỗi component chỉ được xem là hoàn tất khi đạt các điều kiện:

- [ ] Dùng đúng token màu, khoảng cách, radius và typography.
- [ ] Có trạng thái default, pressed, disabled và loading nếu phù hợp.
- [ ] Touch target đạt tối thiểu 44 × 44 px.
- [ ] Không overflow ở màn hình 320 px.
- [ ] Hoạt động với text scale 1.3.
- [ ] Có semantic label cho phần tử tương tác.
- [ ] Không hard-code dữ liệu nghiệp vụ.
- [ ] Không làm thay đổi layout đột ngột khi tải dữ liệu.
- [ ] Đã kiểm tra loading, empty, error và offline.
- [ ] Không sử dụng màu ngoài design token nếu chưa được phê duyệt.

---

## 16. Screen Review Checklist

Trước khi nghiệm thu một màn hình:

### Nội dung

- [ ] Tiêu đề màn hình rõ ràng.
- [ ] Hành động chính dễ nhận biết.
- [ ] Không có nội dung thừa hoặc trùng lặp.
- [ ] Thứ tự thông tin phản ánh đúng mức độ quan trọng.
- [ ] Nhãn sử dụng tiếng Việt tự nhiên.

### Hình thức

- [ ] Chỉ có một màu nhấn chính.
- [ ] Khoảng trắng đủ thoáng.
- [ ] Không lạm dụng card.
- [ ] Không dùng quá 3 mức chữ trong một vùng.
- [ ] Icon đồng bộ.
- [ ] Bóng đổ nhẹ hoặc không có.

### Hành vi

- [ ] Nút quay lại hoạt động đúng.
- [ ] Tác vụ có phản hồi tức thời.
- [ ] Form giữ dữ liệu khi xảy ra lỗi có thể phục hồi.
- [ ] Hành động nguy hiểm có xác nhận.
- [ ] Có xử lý mất mạng.
- [ ] Có thể sử dụng bằng một tay.

---

## 17. Những điều không được làm

- Không dùng quá 2 màu thương hiệu trên cùng một màn hình.
- Không dùng gradient làm nền chính.
- Không dùng shadow đậm cho toàn bộ card.
- Không bo tròn quá mức.
- Không đặt quá nhiều button cùng cấp.
- Không dùng icon thay chữ khi ý nghĩa không rõ.
- Không dùng carousel tự chạy.
- Không dùng animation dài hơn 400 ms cho tác vụ thường xuyên.
- Không hiển thị lỗi kỹ thuật trực tiếp cho người dùng.
- Không dùng modal cho mọi tác vụ.
- Không đặt banner quảng cáo hoặc nội dung không liên quan học tập trên trang chủ.
- Không làm giao diện giống iOS đến mức phá vỡ thói quen sử dụng Android.
- Không thay đổi quy tắc thiết kế riêng lẻ trong từng feature.

---

## 18. Definition of Done cho UI/UX

Một màn hình được xem là hoàn thành khi:

1. Tuân thủ toàn bộ design token.
2. Có đầy đủ trạng thái dữ liệu.
3. Responsive trên điện thoại nhỏ, điện thoại tiêu chuẩn và tablet.
4. Đạt yêu cầu accessibility tối thiểu.
5. Không có overflow hoặc layout shift rõ rệt.
6. Có phản hồi cho mọi thao tác.
7. Nội dung đã được kiểm tra về ngôn ngữ.
8. Được kiểm thử trên ít nhất một thiết bị Android thật.
9. Không chứa dữ liệu giả hoặc xử lý hard-code trong bản production.
10. Có ảnh hoặc video bằng chứng nghiệm thu.

---

## 19. Tóm tắt định hướng

Thiết kế của Cổng thông tin đào tạo phải thể hiện ba đặc tính:

### Đơn giản

Người dùng nhìn thấy đúng thông tin cần thiết, không phải học cách sử dụng hệ thống.

### Tinh tế

Màu sắc tiết chế, typography rõ ràng, khoảng trắng hợp lý và chuyển động nhẹ.

### Thân thiện

Ngôn ngữ gần gũi, phản hồi minh bạch, hỗ trợ đầy đủ trạng thái lỗi và khả năng sử dụng tốt trên thiết bị thật.

> **Nguyên tắc cuối cùng:** Khi phải lựa chọn giữa giao diện đẹp hơn và giao diện dễ hiểu hơn, luôn chọn giao diện dễ hiểu hơn.
