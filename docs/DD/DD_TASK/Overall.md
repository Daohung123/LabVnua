# Overall - Todo và đầu việc

## Metadata

| Hạng mục | Nội dung |
|---|---|
| Dự án | Learning Management App |
| Module | Todo và đầu việc |
| Module code | TASK |
| Technical name | task_todo |
| Phiên bản DD | v0.1 |
| Ngày tạo | 2026-07-03 |
| Nguồn | docs/BD/BasicDesign_LearningApp.md - BD section 7, rows 21-23 |
| Template | .agent/dd/module-dd-instruction.md |
| Phạm vi release | MVP + Sprint 2/3 |

## Goals

- Triển khai thiết kế chi tiết cho module `TASK` từ Basic Design.
- Giữ traceability từ feature/function/view/case tới BD.
- Đánh dấu rõ contract chưa có source bằng `OPEN_QUESTION`.

## Non-goals

- Không sửa app source, runtime config, migrations hoặc dependencies.
- Không tự định nghĩa API/schema/security contract chưa được phê duyệt.
- Không coi behavior trong DD là đã implement nếu code evidence chưa tồn tại.

## Boundary và ownership

- Module này thuộc package `DD_TASK` dưới `docs/DD/`.
- Implement sau nên theo feature-first Flutter: `lib/features/` cho feature UI/controller/service, `lib/core/` cho shared services, `lib/config/` cho database/config.
- Các public contract hoặc schema chưa có nguồn phải được giải quyết trước khi code.

## Actors và permissions

- Sinh viên
- Giảng viên

## Context

Quản lý todo online/offline, nộp bài/giao bài/tạo báo cáo và kế hoạch học tập.

## Feature index

| Feature ID | Feature | Function | View | Case |
|---|---|---|---|---|
| TASK-F01 | Todo online và offline | TASK-FN01 | TASK-V01 | TASK-CASE-21 |
| TASK-F02 | Nộp bài / giao bài / tạo báo cáo | TASK-FN02 | TASK-V02 | TASK-CASE-22 |
| TASK-F03 | Kế hoạch học tập | TASK-FN03 | TASK-V03 | TASK-CASE-23 |

## Flows

| Case | Flow |
|---|---|
| TASK-CASE-21 | Tạo/sửa/xóa -> Phân loại Online/Offline -> Lưu local và sync |
| TASK-CASE-22 | GV giao bài -> SV upload -> SV tạo báo cáo PDF/Word |
| TASK-CASE-23 | Tạo kế hoạch -> Liên kết lịch/deadline -> Theo dõi tiến độ |

## States

- Draft
- Đang mở
- Sắp hết hạn
- Đã nộp
- Chưa nộp
- Đã đồng bộ
- Chờ đồng bộ
- Xung đột

## Business rules

- TASK-BR01: Todo phân loại Online/Offline
- TASK-BR02: Todo gắn môn học hoặc buổi học
- TASK-BR03: Lưu local trước rồi đồng bộ khi có mạng

## Data

- TASK-E-task: đầu việc
- TASK-E-attachment: tài nguyên/link/file
- TASK-E-submission: bài nộp
- TASK-E-study-plan: kế hoạch học tập

## Integrations

- TASK-API01: task sync
- TASK-API02: file upload/submission
- TASK-API03: PDF/Word export

## Non-functional requirements

- Security: không log secret/token/password/PII sản xuất; kiểm tra role và scope dữ liệu.
- Resilience: UI có loading, empty, error, offline và success state khi phù hợp.
- Traceability: mọi feature/function/view/case link tới ID và source BD.
- Documentation: unknowns phải ghi `OPEN_QUESTION`, không dùng dữ liệu giả như thật.

## Risks và open questions

| ID | Nội dung |
|---|---|
| TASK-RISK01 | OPEN_QUESTION - Chưa có feature todo/deadline/submission rõ trong code |
| TASK-RISK02 | OPEN_QUESTION - Schema task/submission/file chưa có contract |
| TASK-RISK03 | OPEN_QUESTION - Mẫu báo cáo PDF/Word chưa cung cấp |

## ADR

- TASK-ADR01: Dùng Markdown module DD theo `.agent/dd/module-dd-instruction.md` và extension `cases/` đã được user phê duyệt.
- TASK-ADR02: Dùng source evidence trong BD/agent docs, không tự tạo contract API/schema.

## Traceability

| BD row | Case | Feature | Function | View |
|---|---|---|---|---|
| 21 | TASK-CASE-21 | TASK-F01 | TASK-FN01 | TASK-V01 |
| 22 | TASK-CASE-22 | TASK-F02 | TASK-FN02 | TASK-V02 |
| 23 | TASK-CASE-23 | TASK-F03 | TASK-FN03 | TASK-V03 |

## Approval

- Trạng thái: Draft DD v0.1.
- Điều kiện implement: review và xử lý các `OPEN_QUESTION` ảnh hưởng đến API, authorization, schema, bảo mật và business rule.
