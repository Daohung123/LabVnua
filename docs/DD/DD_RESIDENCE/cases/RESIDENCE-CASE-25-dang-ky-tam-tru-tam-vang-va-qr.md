# RESIDENCE-CASE-25 - Đăng ký tạm trú / tạm vắng và QR

- `STATUS:` Draft DD v0.1
- `MODULE:` RESIDENCE - Đăng ký tạm trú / tạm vắng
- `PRIORITY:` P2
- `SOURCE:` `docs/BD/BasicDesign_LearningApp.md` - BD 9.1-9.3
- `FEATURE:` RESIDENCE-F01
- `FUNCTION:` RESIDENCE-FN01
- `VIEW:` RESIDENCE-V01
- `ROLES:` Sinh viên, Công an, Chủ nhà

## Mục tiêu

Đăng ký tạm trú / tạm vắng và QR được thiết kế như một case riêng trong module `RESIDENCE` và trace trực tiếp tới bảng ưu tiên BD dòng 25.

## Entry point

Sinh viên mở form đăng ký hành chính

## Luồng chính

- Điền form
- Sinh mã/QR
- Xuất PDF
- Quét QR xác minh

## Dữ liệu / API / state

- Thông tin cá nhân
- Địa chỉ
- Thời gian
- Registration ID
- QR
- Verification token

Tích hợp liên quan:

- RESIDENCE-API01: public verification
- RESIDENCE-API02: PDF export
- RESIDENCE-API03: QR generation

## UI / component

- View chính: RESIDENCE-V01.
- UI phải có loading, empty, error, permission denied và success state khi phù hợp.
- Copy hiển thị bằng tiếng Việt, bám terminology trong BD.

## Validation và permission

- Roles được phép: Sinh viên, Công an, Chủ nhà.
- Kiểm tra dữ liệu bắt buộc trước khi submit.
- Kiểm tra quyền truy cập entity theo user/session hiện tại.
- Không gửi request hoặc ghi local state khi validation fail.

## Error handling

- Lỗi network/service hiển thị message an toàn.
- Thiếu contract phải được giữ ở `OPEN_QUESTION`, không hard-code behavior nghiệp vụ.
- Không log token, password, prompt chứa dữ liệu riêng tư hoặc PII sản xuất.

## Acceptance criteria

- Mỗi đơn có mã duy nhất
- PDF đủ thông tin/QR
- API không lộ dữ liệu quá phạm vi

## Test scenarios

- Tạo đơn
- thiếu trường
- QR hết hạn
- token invalid

## Open questions / risks

- RESIDENCE-RISK01
- RESIDENCE-RISK02
- RESIDENCE-RISK03

## Traceability

| Item | ID |
|---|---|
| BD row | 25 |
| Case | RESIDENCE-CASE-25 |
| Feature | RESIDENCE-F01 |
| Function | RESIDENCE-FN01 |
| View | RESIDENCE-V01 |
| Source | BD 9.1-9.3 |
