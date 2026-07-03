# Overall - Đăng ký tạm trú / tạm vắng

## Metadata

| Hạng mục | Nội dung |
|---|---|
| Dự án | Learning Management App |
| Module | Đăng ký tạm trú / tạm vắng |
| Module code | RESIDENCE |
| Technical name | residence_registration |
| Phiên bản DD | v0.1 |
| Ngày tạo | 2026-07-03 |
| Nguồn | docs/BD/BasicDesign_LearningApp.md - BD section 9, row 25 |
| Template | .agent/dd/module-dd-instruction.md |
| Phạm vi release | Later / P2 |

## Goals

- Triển khai thiết kế chi tiết cho module `RESIDENCE` từ Basic Design.
- Giữ traceability từ feature/function/view/case tới BD.
- Đánh dấu rõ contract chưa có source bằng `OPEN_QUESTION`.

## Non-goals

- Không sửa app source, runtime config, migrations hoặc dependencies.
- Không tự định nghĩa API/schema/security contract chưa được phê duyệt.
- Không coi behavior trong DD là đã implement nếu code evidence chưa tồn tại.

## Boundary và ownership

- Module này thuộc package `DD_RESIDENCE` dưới `docs/DD/`.
- Implement sau nên theo feature-first Flutter: `lib/features/` cho feature UI/controller/service, `lib/core/` cho shared services, `lib/config/` cho database/config.
- Các public contract hoặc schema chưa có nguồn phải được giải quyết trước khi code.

## Actors và permissions

- Sinh viên
- Công an
- Chủ nhà
- Nhà trường / Quản trị

## Context

Sinh viên đăng ký tạm trú/tạm vắng, xuất đơn có QR để công an/chủ nhà xác minh.

## Feature index

| Feature ID | Feature | Function | View | Case |
|---|---|---|---|---|
| RESIDENCE-F01 | Đăng ký tạm trú / tạm vắng và QR | RESIDENCE-FN01 | RESIDENCE-V01 | RESIDENCE-CASE-25 |

## Flows

| Case | Flow |
|---|---|
| RESIDENCE-CASE-25 | Điền form -> Sinh mã/QR -> Xuất PDF -> Quét QR xác minh |

## States

- Draft
- Đã tạo mã
- Đã xuất PDF
- Đã xác minh
- Hết hạn token
- Bị từ chối nếu có workflow duyệt

## Business rules

- RESIDENCE-BR01: Mỗi đăng ký có mã duy nhất
- RESIDENCE-BR02: QR chứa ID đăng ký
- RESIDENCE-BR03: Public verification bảo mật bằng token ngắn hạn

## Data

- RESIDENCE-E-registration: đơn đăng ký
- RESIDENCE-E-qr: QR xác minh
- RESIDENCE-E-verification-token: token ngắn hạn
- RESIDENCE-E-history: lịch sử đăng ký

## Integrations

- RESIDENCE-API01: public verification
- RESIDENCE-API02: PDF export
- RESIDENCE-API03: QR generation

## Non-functional requirements

- Security: không log secret/token/password/PII sản xuất; kiểm tra role và scope dữ liệu.
- Resilience: UI có loading, empty, error, offline và success state khi phù hợp.
- Traceability: mọi feature/function/view/case link tới ID và source BD.
- Documentation: unknowns phải ghi `OPEN_QUESTION`, không dùng dữ liệu giả như thật.

## Risks và open questions

| ID | Nội dung |
|---|---|
| RESIDENCE-RISK01 | OPEN_QUESTION - Chưa có form/mẫu PDF pháp lý |
| RESIDENCE-RISK02 | OPEN_QUESTION - Public API/token/rate limit chưa có contract |
| RESIDENCE-RISK03 | OPEN_QUESTION - PII consent/retention chưa tài liệu hóa |

## ADR

- RESIDENCE-ADR01: Dùng Markdown module DD theo `.agent/dd/module-dd-instruction.md` và extension `cases/` đã được user phê duyệt.
- RESIDENCE-ADR02: Dùng source evidence trong BD/agent docs, không tự tạo contract API/schema.

## Traceability

| BD row | Case | Feature | Function | View |
|---|---|---|---|---|
| 25 | RESIDENCE-CASE-25 | RESIDENCE-F01 | RESIDENCE-FN01 | RESIDENCE-V01 |

## Approval

- Trạng thái: Draft DD v0.1.
- Điều kiện implement: review và xử lý các `OPEN_QUESTION` ảnh hưởng đến API, authorization, schema, bảo mật và business rule.
