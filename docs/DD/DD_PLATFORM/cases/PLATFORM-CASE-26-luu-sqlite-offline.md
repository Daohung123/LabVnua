# PLATFORM-CASE-26 - Lưu SQLite offline

- `STATUS:` Draft DD v0.1
- `MODULE:` PLATFORM - Kỹ thuật và hạ tầng
- `PRIORITY:` P0 - MVP
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 10.1
- `FEATURE:` PLATFORM-F01
- `FUNCTION:` PLATFORM-FN01
- `VIEW:` PLATFORM-V01
- `ROLES:` Người dùng app

## Mục tiêu

Lưu SQLite offline được thiết kế như một case riêng trong module `PLATFORM` và trace trực tiếp tới bảng ưu tiên BD dòng 26.

## Entry point

Sau login và khi dùng app offline

## Luồng chính

- Sync dữ liệu về SQLite
- Xem offline
- Local-first note/todo rồi sync

## Dữ liệu / API / state

- Session
- Schedule
- Deadline
- Document metadata
- Note
- Todo
- Sync status

Tích hợp liên quan:

- PLATFORM-API01: SQLite
- PLATFORM-API02: Workmanager
- PLATFORM-API03: Connectivity
- PLATFORM-API04: analytics backend

## UI / component

- View chính: PLATFORM-V01.
- UI phải có loading, empty, error, permission denied và success state khi phù hợp.
- Copy hiển thị bằng tiếng Việt, bám terminology trong BD.

## Validation và permission

- Roles được phép: Người dùng app.
- Kiểm tra dữ liệu bắt buộc trước khi submit.
- Kiểm tra quyền truy cập entity theo user/session hiện tại.
- Không gửi request hoặc ghi local state khi validation fail.

## Error handling

- Lỗi network/service hiển thị message an toàn.
- Thiếu contract phải được giữ ở `OPEN_QUESTION`, không hard-code behavior nghiệp vụ.
- Không log token, password, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.

## Acceptance criteria

- Xem được cache offline
- Conflict theo server wins/client wins

## Test scenarios

- Login rồi mất mạng
- tạo offline
- sync lại
- conflict

## Open questions / risks

- PLATFORM-RISK01
- PLATFORM-RISK02
- PLATFORM-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 26 |
| Case | PLATFORM-CASE-26 |
| Feature | PLATFORM-F01 |
| Function | PLATFORM-FN01 |
| View | PLATFORM-V01 |
| Source | BD 10.1 |
