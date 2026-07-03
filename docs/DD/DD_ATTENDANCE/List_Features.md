# List Features - Điểm danh

## Inventory

| Feature | Tên | Priority | Rules | Function | View | Case |
|---|---|---|---|---|---|---|
| ATTENDANCE-F01 | Điểm danh QR cá nhân | P0 - MVP | ATTENDANCE-BR01, ATTENDANCE-BR02, ATTENDANCE-BR03 | ATTENDANCE-FN01 | ATTENDANCE-V01 | ATTENDANCE-CASE-14 |
| ATTENDANCE-F02 | Xem danh sách vắng cho giảng viên | P0 - MVP | ATTENDANCE-BR01, ATTENDANCE-BR02, ATTENDANCE-BR03 | ATTENDANCE-FN02 | ATTENDANCE-V02 | ATTENDANCE-CASE-15 |

## Dependencies

- ATTENDANCE-API01: QR generation/verification
- ATTENDANCE-API02: attendance report export
- lib/features/qr_code/screens/view_qr_code.dart
- android/app/src/main/AndroidManifest.xml
- lib/features/schedure/screens/components/detail_subject.dart

## ATTENDANCE-F01 - Điểm danh QR cá nhân

- `Case:` ATTENDANCE-CASE-14
- `Priority:` P0 - MVP
- `Source:` BD 5.1
- `Roles:` Sinh viên, Giảng viên, Cán bộ
- `Function:` ATTENDANCE-FN01
- `View:` ATTENDANCE-V01

### Happy flow

- Sinh QR
- Người điểm danh quét QR
- Xác nhận trong thời hạn

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- QR hết hạn không hợp lệ
- QR hợp lệ ghi đúng người/buổi

### Tests

- QR hợp lệ
- hết hạn
- sai buổi
- quét trùng

### Risks / open questions

- ATTENDANCE-RISK01
- ATTENDANCE-RISK02
- ATTENDANCE-RISK03

## ATTENDANCE-F02 - Xem danh sách vắng cho giảng viên

- `Case:` ATTENDANCE-CASE-15
- `Priority:` P0 - MVP
- `Source:` BD 5.1
- `Roles:` Giảng viên
- `Function:` ATTENDANCE-FN02
- `View:` ATTENDANCE-V02

### Happy flow

- Tải roster
- Gộp trạng thái
- Điểm danh thủ công/xuất báo cáo

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Danh sách trạng thái rõ
- Điểm danh thủ công có audit tối thiểu

### Tests

- Roster đủ
- chưa xử lý
- export buổi/tuần/tháng

### Risks / open questions

- ATTENDANCE-RISK01
- ATTENDANCE-RISK02
- ATTENDANCE-RISK03
