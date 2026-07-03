# Overall - Xác thực và tài khoản

## Metadata

| Hạng mục | Nội dung |
|---|---|
| Dự án | Learning Management App |
| Module | Xác thực và tài khoản |
| Module code | AUTH |
| Technical name | auth_account |
| Phiên bản DD | v0.1 |
| Ngày tạo | 2026-07-03 |
| Nguồn | docs/BD/BasicDesign_LearningApp.md - BD sections 2, 3.5, rows 1-3 |
| Template | .agent/dd/module-dd-instruction.md |
| Phạm vi release | MVP |

## Goals

- Triển khai thiết kế chi tiết cho module `AUTH` từ Basic Design.
- Giữ traceability từ feature/function/view/case tới BD.
- Đánh dấu rõ contract chưa có source bằng `OPEN_QUESTION`.

## Non-goals

- Không sửa app source, runtime config, migrations hoặc dependencies.
- Không tự định nghĩa API/schema/security contract chưa được phê duyệt.
- Không coi behavior trong DD là đã implement nếu code evidence chưa tồn tại.

## Boundary và ownership

- Module này thuộc package `DD_AUTH` dưới `docs/DD/`.
- Implement sau nên theo feature-first Flutter: `lib/features/` cho feature UI/controller/service, `lib/core/` cho shared services, `lib/config/` cho database/config.
- Các public contract hoặc schema chưa có nguồn phải được giải quyết trước khi code.

## Actors và permissions

- Sinh viên
- Giảng viên
- Nhà trường pha sau

## Context

Đăng nhập tập trung, tự động phân role, quản lý tài khoản qua avatar/header.

## Feature index

| Feature ID | Feature | Function | View | Case |
|---|---|---|---|---|
| AUTH-F01 | Làm lại giao diện đăng nhập và logo | AUTH-FN01 | AUTH-V01 | AUTH-CASE-01 |
| AUTH-F02 | Bỏ chọn role, thêm đăng nhập VNied | AUTH-FN02 | AUTH-V02 | AUTH-CASE-02 |
| AUTH-F03 | Avatar dropdown gồm logout và cài đặt | AUTH-FN03 | AUTH-V03 | AUTH-CASE-03 |

## Flows

| Case | Flow |
|---|---|
| AUTH-CASE-01 | Hiển thị login đơn giản -> Hiển thị logo -> Submit phương thức login |
| AUTH-CASE-02 | Ẩn control chọn role -> Xác thực VNied -> Lưu session và route theo role |
| AUTH-CASE-03 | Mở dropdown -> Hiển thị thông tin/cài đặt/đổi mật khẩu/logout -> Logout về login |

## States

- Chưa xác thực
- Đang xác thực
- Đã xác thực
- Token hết hạn
- Lỗi xác thực
- Đã đăng xuất

## Business rules

- AUTH-BR01: Không chọn role thủ công
- AUTH-BR02: Token/session chỉ dùng khi còn hiệu lực
- AUTH-BR03: Avatar menu chỉ cho user đã đăng nhập

## Data

- AUTH-E-session: SQLite session
- AUTH-E-profile: hồ sơ người dùng
- AUTH-E-role: role sau xác thực

## Integrations

- AUTH-API01: VNied/VNUA auth
- AUTH-API02: email/password fallback
- AUTH-API03: SQLite session restore

## Non-functional requirements

- Security: không log secret/token/password/PII sản xuất; kiểm tra role và scope dữ liệu.
- Resilience: UI có loading, empty, error, offline và success state khi phù hợp.
- Traceability: mọi feature/function/view/case link tới ID và source BD.
- Documentation: unknowns phải ghi `OPEN_QUESTION`, không dùng dữ liệu giả như thật.

## Risks và open questions

| ID | Nội dung |
|---|---|
| AUTH-RISK01 | OPEN_QUESTION - Chưa có hợp đồng OAuth2 VNied |
| AUTH-RISK02 | OPEN_QUESTION - Secure storage token/cookie/session.pass chưa được phê duyệt |
| AUTH-RISK03 | OPEN_QUESTION - Quy tắc role thiếu/lạ/nhiều role chưa rõ |

## ADR

- AUTH-ADR01: Dùng Markdown module DD theo `.agent/dd/module-dd-instruction.md` và extension `cases/` đã được user phê duyệt.
- AUTH-ADR02: Dùng source evidence trong BD/agent docs, không tự tạo contract API/schema.

## Traceability

| BD row | Case | Feature | Function | View |
|---|---|---|---|---|
| 1 | AUTH-CASE-01 | AUTH-F01 | AUTH-FN01 | AUTH-V01 |
| 2 | AUTH-CASE-02 | AUTH-F02 | AUTH-FN02 | AUTH-V02 |
| 3 | AUTH-CASE-03 | AUTH-F03 | AUTH-FN03 | AUTH-V03 |

## Approval

- Trạng thái: Draft DD v0.1.
- Điều kiện implement: review và xử lý các `OPEN_QUESTION` ảnh hưởng đến API, authorization, schema, bảo mật và business rule.
