# List Features - Đăng ký tạm trú / tạm vắng

## Inventory

| Feature | Tên | Priority | Rules | Function | View | Case |
|---|---|---|---|---|---|---|
| RESIDENCE-F01 | Đăng ký tạm trú / tạm vắng và QR | P2 | RESIDENCE-BR01, RESIDENCE-BR02, RESIDENCE-BR03 | RESIDENCE-FN01 | RESIDENCE-V01 | RESIDENCE-CASE-25 |

## Dependencies

- RESIDENCE-API01: public verification
- RESIDENCE-API02: PDF export
- RESIDENCE-API03: QR generation
- Không có feature tương ứng được tìm thấy trong lib/features tại thời điểm DD

## RESIDENCE-F01 - Đăng ký tạm trú / tạm vắng và QR

- `Case:` RESIDENCE-CASE-25
- `Priority:` P2
- `Source:` BD 9.1-9.3
- `Roles:` Sinh viên, Công an, Chủ nhà
- `Function:` RESIDENCE-FN01
- `View:` RESIDENCE-V01

### Happy flow

- Điền form
- Sinh mã/QR
- Xuất PDF
- Quét QR xác minh

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Mỗi đơn có mã duy nhất
- PDF đủ thông tin/QR
- API không lộ dữ liệu quá phạm vi

### Tests

- Tạo đơn
- thiếu trường
- QR hết hạn
- token invalid

### Risks / open questions

- RESIDENCE-RISK01
- RESIDENCE-RISK02
- RESIDENCE-RISK03
