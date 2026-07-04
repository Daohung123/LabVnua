# List Features - Kỹ thuật và hạ tầng

## Inventory

| Feature | Tên | Priority | Rules | Function | View | Case |
|---|---|---|---|---|---|---|
| PLATFORM-F01 | Lưu SQLite offline | P0 - MVP | PLATFORM-BR01, PLATFORM-BR02, PLATFORM-BR03 | PLATFORM-FN01 | PLATFORM-V01 | PLATFORM-CASE-26 |
| PLATFORM-F02 | Analytics hành vi người dùng | P1 | PLATFORM-BR01, PLATFORM-BR02, PLATFORM-BR03 | PLATFORM-FN02 | PLATFORM-V02 | PLATFORM-CASE-27 |

## Dependencies

- PLATFORM-API01: SQLite
- PLATFORM-API02: Workmanager
- PLATFORM-API03: Connectivity
- PLATFORM-API04: analytics backend
- lib/config/config_db.dart
- lib/config/sync_data.dart
- lib/features/notification/services/background_sync_service.dart
- lib/features/notification/services/data_change_detector_service.dart
- lib/core/services_root/sqlite/notification/data_change_sqlite.dart
- lib/app.dart

## PLATFORM-F01 - Lưu SQLite offline

- `Case:` PLATFORM-CASE-26
- `Priority:` P0 - MVP
- `Source:` BD 10.1
- `Roles:` Người dùng app
- `Function:` PLATFORM-FN01
- `View:` PLATFORM-V01

### Happy flow

- Sync dữ liệu về SQLite
- Xem offline
- Local-first note/todo rồi sync

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Xem được cache offline
- Conflict theo server wins/client wins

### Tests

- Login rồi mất mạng
- tạo offline
- sync lại
- conflict

### Risks / open questions

- PLATFORM-RISK01
- PLATFORM-RISK02
- PLATFORM-RISK03

## PLATFORM-F02 - Analytics hành vi người dùng

- `Case:` PLATFORM-CASE-27
- `Priority:` P1
- `Source:` BD 10.2
- `Roles:` Hệ thống, Nhà trường / Quản trị
- `Function:` PLATFORM-FN02
- `View:` PLATFORM-V02

### Happy flow

- Ghi event ẩn danh
- Tổng hợp theo role/thời gian
- Dùng cho shortcut/roadmap

### Alternate / error flows

- Thiếu dữ liệu nguồn thì hiển thị empty/error state, không render dữ liệu giả.
- Thiếu quyền thì action bị ẩn hoặc chặn trước khi gọi service.
- Contract chưa phê duyệt phải giữ ở `OPEN_QUESTION` hoặc disabled state.

### Acceptance criteria

- Không lưu PII
- Có policy PDPA trước khi bật

### Tests

- Event không PII
- opt-out/disabled
- aggregate dashboard

### Risks / open questions

- PLATFORM-RISK01
- PLATFORM-RISK02
- PLATFORM-RISK03
