# Overall - Kỹ thuật và hạ tầng

## Metadata

| Hạng mục | Nội dung |
|---|---|
| Dự án | Learning Management App |
| Module | Kỹ thuật và hạ tầng |
| Module code | PLATFORM |
| Technical name | platform_infrastructure |
| Phiên bản DD | v0.1 |
| Ngày tạo | 2026-07-03 |
| Nguồn | docs/BD/BasicDesign_LearningApp.md - BD sections 10.1, 10.2, rows 26-27 |
| Template | .agent/dd/module-dd-instruction.md |
| Phạm vi release | MVP + Sprint 2/3 |

## Goals

- Triển khai thiết kế chi tiết cho module `PLATFORM` từ Basic Design.
- Giữ traceability từ feature/function/view/case tới BD.
- Đánh dấu rõ contract chưa có source bằng `OPEN_QUESTION`.

## Non-goals

- Không sửa app source, runtime config, migrations hoặc dependencies.
- Không tự định nghĩa API/schema/security contract chưa được phê duyệt.
- Không coi behavior trong DD là đã implement nếu code evidence chưa tồn tại.

## Boundary và ownership

- Module này thuộc package `DD_PLATFORM` dưới `docs/DD/`.
- Implement sau nên theo feature-first Flutter: `lib/features/` cho feature UI/controller/service, `lib/core/` cho shared services, `lib/config/` cho database/config.
- Các public contract hoặc schema chưa có nguồn phải được giải quyết trước khi code.

## Actors và permissions

- Người dùng app
- Hệ thống nền
- Nhà trường / Quản trị pha sau

## Context

Nền tảng offline SQLite, đồng bộ khi có mạng và analytics hành vi người dùng.

## Feature index

| Feature ID | Feature | Function | View | Case |
|---|---|---|---|---|
| PLATFORM-F01 | Lưu SQLite offline | PLATFORM-FN01 | PLATFORM-V01 | PLATFORM-CASE-26 |
| PLATFORM-F02 | Analytics hành vi người dùng | PLATFORM-FN02 | PLATFORM-V02 | PLATFORM-CASE-27 |

## Flows

| Case | Flow |
|---|---|
| PLATFORM-CASE-26 | Sync dữ liệu về SQLite -> Xem offline -> Local-first note/todo rồi sync |
| PLATFORM-CASE-27 | Ghi event ẩn danh -> Tổng hợp theo role/thời gian -> Dùng cho shortcut/roadmap |

## States

- Online
- Offline
- Đang đồng bộ
- Đã đồng bộ
- Chờ đồng bộ
- Xung đột
- Analytics disabled

## Business rules

- PLATFORM-BR01: Server wins cho dữ liệu học tập
- PLATFORM-BR02: Client wins cho ghi chú cá nhân
- PLATFORM-BR03: Analytics ẩn danh và tuân thủ PDPA

## Data

- PLATFORM-E-local-cache: SQLite cache
- PLATFORM-E-sync-job: background sync job
- PLATFORM-E-change-history: notification_history
- PLATFORM-E-analytics-event: sự kiện ẩn danh

## Integrations

- PLATFORM-API01: SQLite
- PLATFORM-API02: Workmanager
- PLATFORM-API03: Connectivity
- PLATFORM-API04: analytics backend

## Non-functional requirements

- Security: không log secret/token/password/PII sản xuất; kiểm tra role và scope dữ liệu.
- Resilience: UI có loading, empty, error, offline và success state khi phù hợp.
- Traceability: mọi feature/function/view/case link tới ID và source BD.
- Documentation: unknowns phải ghi `OPEN_QUESTION`, không dùng dữ liệu giả như thật.

## Risks và open questions

| ID | Nội dung |
|---|---|
| PLATFORM-RISK01 | OPEN_QUESTION - Danh sách dữ liệu sync sau login chưa đầy đủ |
| PLATFORM-RISK02 | OPEN_QUESTION - Conflict resolution theo entity chưa chi tiết |
| PLATFORM-RISK03 | OPEN_QUESTION - Analytics provider/taxonomy/consent/retention chưa chốt |

## ADR

- PLATFORM-ADR01: Dùng Markdown module DD theo `.agent/dd/module-dd-instruction.md` và extension `cases/` đã được user phê duyệt.
- PLATFORM-ADR02: Dùng source evidence trong BD/agent docs, không tự tạo contract API/schema.

## Traceability

| BD row | Case | Feature | Function | View |
|---|---|---|---|---|
| 26 | PLATFORM-CASE-26 | PLATFORM-F01 | PLATFORM-FN01 | PLATFORM-V01 |
| 27 | PLATFORM-CASE-27 | PLATFORM-F02 | PLATFORM-FN02 | PLATFORM-V02 |

## Approval

- Trạng thái: Draft DD v0.1.
- Điều kiện implement: review và xử lý các `OPEN_QUESTION` ảnh hưởng đến API, authorization, schema, bảo mật và business rule.
