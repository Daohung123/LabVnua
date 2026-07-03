# Overall - Cổng học tập

## Metadata

| Hạng mục | Nội dung |
|---|---|
| Dự án | Learning Management App |
| Module | Cổng học tập |
| Module code | LEARNING_PORTAL |
| Technical name | learning_portal |
| Phiên bản DD | v0.1 |
| Ngày tạo | 2026-07-03 |
| Nguồn | docs/BD/BasicDesign_LearningApp.md - BD section 8, row 24 |
| Template | .agent/dd/module-dd-instruction.md |
| Phạm vi release | Sprint 2/3 |

## Goals

- Triển khai thiết kế chi tiết cho module `LEARNING_PORTAL` từ Basic Design.
- Giữ traceability từ feature/function/view/case tới BD.
- Đánh dấu rõ contract chưa có source bằng `OPEN_QUESTION`.

## Non-goals

- Không sửa app source, runtime config, migrations hoặc dependencies.
- Không tự định nghĩa API/schema/security contract chưa được phê duyệt.
- Không coi behavior trong DD là đã implement nếu code evidence chưa tồn tại.

## Boundary và ownership

- Module này thuộc package `DD_LEARNING_PORTAL` dưới `docs/DD/`.
- Implement sau nên theo feature-first Flutter: `lib/features/` cho feature UI/controller/service, `lib/core/` cho shared services, `lib/config/` cho database/config.
- Các public contract hoặc schema chưa có nguồn phải được giải quyết trước khi code.

## Actors và permissions

- Sinh viên
- Giảng viên nếu có quyền

## Context

Cổng tra cứu môn học với thống kê hoàn thành/đang học/trượt, search và filter.

## Feature index

| Feature ID | Feature | Function | View | Case |
|---|---|---|---|---|
| LEARNING_PORTAL-F01 | Cổng học tập: bỏ tiêu đề, thêm thống kê và search | LEARNING_PORTAL-FN01 | LEARNING_PORTAL-V01 | LEARNING_PORTAL-CASE-24 |

## Flows

| Case | Flow |
|---|---|
| LEARNING_PORTAL-CASE-24 | Tải môn/thống kê -> Render thống kê -> Search/filter/click môn |

## States

- Đang tải
- Có môn học
- Không có môn
- Không có kết quả search
- Lỗi tải

## Business rules

- LEARNING_PORTAL-BR01: Header thay bằng thống kê môn học
- LEARNING_PORTAL-BR02: Filter theo học kỳ và trạng thái
- LEARNING_PORTAL-BR03: Click môn mở chi tiết lịch/tài liệu/deadline/điểm

## Data

- LEARNING_PORTAL-E-course: môn học
- LEARNING_PORTAL-E-term: học kỳ
- LEARNING_PORTAL-E-score: điểm
- LEARNING_PORTAL-E-document: tài liệu
- LEARNING_PORTAL-E-deadline: deadline

## Integrations

- LEARNING_PORTAL-API01: training program
- LEARNING_PORTAL-API02: score
- LEARNING_PORTAL-API03: schedule
- LEARNING_PORTAL-API04: document/deadline source

## Non-functional requirements

- Security: không log secret/token/password/PII sản xuất; kiểm tra role và scope dữ liệu.
- Resilience: UI có loading, empty, error, offline và success state khi phù hợp.
- Traceability: mọi feature/function/view/case link tới ID và source BD.
- Documentation: unknowns phải ghi `OPEN_QUESTION`, không dùng dữ liệu giả như thật.

## Risks và open questions

| ID | Nội dung |
|---|---|
| LEARNING_PORTAL-RISK01 | OPEN_QUESTION - Nguồn tài liệu/deadline theo môn chưa có contract |
| LEARNING_PORTAL-RISK02 | OPEN_QUESTION - Quy tắc môn trượt/hoàn thành từ điểm chưa chuẩn hóa |

## ADR

- LEARNING_PORTAL-ADR01: Dùng Markdown module DD theo `.agent/dd/module-dd-instruction.md` và extension `cases/` đã được user phê duyệt.
- LEARNING_PORTAL-ADR02: Dùng source evidence trong BD/agent docs, không tự tạo contract API/schema.

## Traceability

| BD row | Case | Feature | Function | View |
|---|---|---|---|---|
| 24 | LEARNING_PORTAL-CASE-24 | LEARNING_PORTAL-F01 | LEARNING_PORTAL-FN01 | LEARNING_PORTAL-V01 |

## Approval

- Trạng thái: Draft DD v0.1.
- Điều kiện implement: review và xử lý các `OPEN_QUESTION` ảnh hưởng đến API, authorization, schema, bảo mật và business rule.
