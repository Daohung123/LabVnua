# Overall - Điểm danh

## Metadata

| Hạng mục | Nội dung |
|---|---|
| Dự án | Learning Management App |
| Module | Điểm danh |
| Module code | ATTENDANCE |
| Technical name | attendance |
| Phiên bản DD | v0.1 |
| Ngày tạo | 2026-07-03 |
| Nguồn | docs/BD/BasicDesign_LearningApp.md - BD section 5, rows 14-15 |
| Template | .agent/dd/module-dd-instruction.md |
| Phạm vi release | MVP |

## Goals

- Triển khai thiết kế chi tiết cho module `ATTENDANCE` từ Basic Design.
- Giữ traceability từ feature/function/view/case tới BD.
- Đánh dấu rõ contract chưa có source bằng `OPEN_QUESTION`.

## Non-goals

- Không sửa app source, runtime config, migrations hoặc dependencies.
- Không tự định nghĩa API/schema/security contract chưa được phê duyệt.
- Không coi behavior trong DD là đã implement nếu code evidence chưa tồn tại.

## Boundary và ownership

- Module này thuộc package `DD_ATTENDANCE` dưới `docs/DD/`.
- Implement sau nên theo feature-first Flutter: `lib/features/` cho feature UI/controller/service, `lib/core/` cho shared services, `lib/config/` cho database/config.
- Các public contract hoặc schema chưa có nguồn phải được giải quyết trước khi code.

## Actors và permissions

- Sinh viên
- Giảng viên
- Cán bộ điểm danh

## Context

Điểm danh bằng QR cá nhân, danh sách vắng và báo cáo theo buổi/tuần/tháng.

## Feature index

| Feature ID | Feature | Function | View | Case |
|---|---|---|---|---|
| ATTENDANCE-F01 | Điểm danh QR cá nhân | ATTENDANCE-FN01 | ATTENDANCE-V01 | ATTENDANCE-CASE-14 |
| ATTENDANCE-F02 | Xem danh sách vắng cho giảng viên | ATTENDANCE-FN02 | ATTENDANCE-V02 | ATTENDANCE-CASE-15 |

## Flows

| Case | Flow |
|---|---|
| ATTENDANCE-CASE-14 | Sinh QR -> Người điểm danh quét QR -> Xác nhận trong thời hạn |
| ATTENDANCE-CASE-15 | Tải roster -> Gộp trạng thái -> Điểm danh thủ công/xuất báo cáo |

## States

- Chưa điểm danh
- QR còn hạn
- QR hết hạn
- Đã điểm danh
- Vắng
- Chưa xử lý

## Business rules

- ATTENDANCE-BR01: QR chứa student ID, mã buổi học, timestamp
- ATTENDANCE-BR02: QR có thời hạn ví dụ 5 phút
- ATTENDANCE-BR03: Giảng viên có thể điểm danh thủ công

## Data

- ATTENDANCE-E-qr: QR payload
- ATTENDANCE-E-record: bản ghi điểm danh
- ATTENDANCE-E-roster: danh sách lớp

## Integrations

- ATTENDANCE-API01: QR generation/verification
- ATTENDANCE-API02: attendance report export

## Non-functional requirements

- Security: không log secret/token/password/PII sản xuất; kiểm tra role và scope dữ liệu.
- Resilience: UI có loading, empty, error, offline và success state khi phù hợp.
- Traceability: mọi feature/function/view/case link tới ID và source BD.
- Documentation: unknowns phải ghi `OPEN_QUESTION`, không dùng dữ liệu giả như thật.

## Risks và open questions

| ID | Nội dung |
|---|---|
| ATTENDANCE-RISK01 | OPEN_QUESTION - Chưa có spec ký/verify QR |
| ATTENDANCE-RISK02 | OPEN_QUESTION - Backend attendance/roster/export chưa có contract |
| ATTENDANCE-RISK03 | OPEN_QUESTION - Quyền cán bộ quét QR chưa rõ |

## ADR

- ATTENDANCE-ADR01: Dùng Markdown module DD theo `.agent/dd/module-dd-instruction.md` và extension `cases/` đã được user phê duyệt.
- ATTENDANCE-ADR02: Dùng source evidence trong BD/agent docs, không tự tạo contract API/schema.

## Traceability

| BD row | Case | Feature | Function | View |
|---|---|---|---|---|
| 14 | ATTENDANCE-CASE-14 | ATTENDANCE-F01 | ATTENDANCE-FN01 | ATTENDANCE-V01 |
| 15 | ATTENDANCE-CASE-15 | ATTENDANCE-F02 | ATTENDANCE-FN02 | ATTENDANCE-V02 |

## Approval

- Trạng thái: Draft DD v0.1.
- Điều kiện implement: review và xử lý các `OPEN_QUESTION` ảnh hưởng đến API, authorization, schema, bảo mật và business rule.
