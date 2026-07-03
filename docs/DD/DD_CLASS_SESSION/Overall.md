# Overall - Buổi học

## Metadata

| Hạng mục | Nội dung |
|---|---|
| Dự án | Learning Management App |
| Module | Buổi học |
| Module code | CLASS_SESSION |
| Technical name | class_session |
| Phiên bản DD | v0.1 |
| Ngày tạo | 2026-07-03 |
| Nguồn | docs/BD/BasicDesign_LearningApp.md - BD section 4, rows 9-13,16-17,28-30 |
| Template | .agent/dd/module-dd-instruction.md |
| Phạm vi release | MVP + Sprint 2/3 + Later |

## Goals

- Triển khai thiết kế chi tiết cho module `CLASS_SESSION` từ Basic Design.
- Giữ traceability từ feature/function/view/case tới BD.
- Đánh dấu rõ contract chưa có source bằng `OPEN_QUESTION`.

## Non-goals

- Không sửa app source, runtime config, migrations hoặc dependencies.
- Không tự định nghĩa API/schema/security contract chưa được phê duyệt.
- Không coi behavior trong DD là đã implement nếu code evidence chưa tồn tại.

## Boundary và ownership

- Module này thuộc package `DD_CLASS_SESSION` dưới `docs/DD/`.
- Implement sau nên theo feature-first Flutter: `lib/features/` cho feature UI/controller/service, `lib/core/` cho shared services, `lib/config/` cho database/config.
- Các public contract hoặc schema chưa có nguồn phải được giải quyết trước khi code.

## Actors và permissions

- Sinh viên
- Giảng viên
- AI khi được phép

## Context

Gom chi tiết buổi học, ghi chú/ghi âm, transcript, quiz, Q&A, FAQ, tiến độ và tác vụ giảng viên.

## Feature index

| Feature ID | Feature | Function | View | Case |
|---|---|---|---|---|
| CLASS_SESSION-F01 | Trang chi tiết buổi học | CLASS_SESSION-FN01 | CLASS_SESSION-V01 | CLASS_SESSION-CASE-09 |
| CLASS_SESSION-F02 | Ghi chú và ghi âm trong buổi học | CLASS_SESSION-FN02 | CLASS_SESSION-V02 | CLASS_SESSION-CASE-10 |
| CLASS_SESSION-F03 | Transcript buổi học | CLASS_SESSION-FN03 | CLASS_SESSION-V03 | CLASS_SESSION-CASE-11 |
| CLASS_SESSION-F04 | Quiz / ra đề bằng text và giọng nói | CLASS_SESSION-FN04 | CLASS_SESSION-V04 | CLASS_SESSION-CASE-12 |
| CLASS_SESSION-F05 | Thống kê người trả lời quiz | CLASS_SESSION-FN05 | CLASS_SESSION-V05 | CLASS_SESSION-CASE-13 |
| CLASS_SESSION-F06 | Trang Q&A theo buổi học | CLASS_SESSION-FN06 | CLASS_SESSION-V06 | CLASS_SESSION-CASE-16 |
| CLASS_SESSION-F07 | Bộ FAQ | CLASS_SESSION-FN07 | CLASS_SESSION-V07 | CLASS_SESSION-CASE-17 |
| CLASS_SESSION-F08 | Giao diện giảng viên đơn giản | CLASS_SESSION-FN08 | CLASS_SESSION-V08 | CLASS_SESSION-CASE-28 |
| CLASS_SESSION-F09 | Điều phối trong buổi học | CLASS_SESSION-FN09 | CLASS_SESSION-V09 | CLASS_SESSION-CASE-29 |
| CLASS_SESSION-F10 | Đánh giá sinh viên theo quá trình đóng góp | CLASS_SESSION-FN10 | CLASS_SESSION-V10 | CLASS_SESSION-CASE-30 |

## Flows

| Case | Flow |
|---|---|
| CLASS_SESSION-CASE-09 | Nhận mã buổi học -> Tải thông tin -> Render chức năng theo role |
| CLASS_SESSION-CASE-10 | Tạo ghi chú -> Bắt đầu/dừng ghi âm -> Lưu vào storage phê duyệt |
| CLASS_SESSION-CASE-11 | Gửi audio sang STT -> Nhận transcript timestamp -> Xem/search/nghe lại đồng bộ |
| CLASS_SESSION-CASE-12 | Tạo câu hỏi text/voice -> Cấu trúc hóa đề -> Publish cho sinh viên |
| CLASS_SESSION-CASE-13 | Thu submission -> Tổng hợp đã/chưa nộp/điểm TB -> Hiển thị realtime hoặc refresh |
| CLASS_SESSION-CASE-16 | Sinh viên hỏi text/voice -> GV/AI trả lời -> Upvote câu hỏi |
| CLASS_SESSION-CASE-17 | Xác định câu phổ biến -> Đưa vào FAQ -> Gợi ý khi câu tương tự |
| CLASS_SESSION-CASE-28 | Hiển thị tác vụ GV chính -> Giảm nhiễu chức năng SV -> Ưu tiên tạo đề/ghi âm/thống kê/điểm danh |
| CLASS_SESSION-CASE-29 | GV chia nhóm/phân công -> SV nhận phân công -> Lưu trạng thái |
| CLASS_SESSION-CASE-30 | Tổng hợp đóng góp -> GV xem/chỉnh -> Lưu đánh giá |

## States

- Sắp diễn ra
- Đang học
- Đã kết thúc
- Đang ghi âm
- Đang xử lý transcript
- Quiz đang mở
- Quiz đã đóng

## Business rules

- CLASS_SESSION-BR01: Chức năng lọc theo role
- CLASS_SESSION-BR02: Transcript có timestamp và search
- CLASS_SESSION-BR03: Quiz chỉ hiển thị sau publish
- CLASS_SESSION-BR04: Q&A thuộc từng buổi học

## Data

- CLASS_SESSION-E-session: buổi học
- CLASS_SESSION-E-note: ghi chú
- CLASS_SESSION-E-audio: audio
- CLASS_SESSION-E-transcript: transcript
- CLASS_SESSION-E-quiz: quiz
- CLASS_SESSION-E-qna: Q&A

## Integrations

- CLASS_SESSION-API01: schedule/detail source
- CLASS_SESSION-API02: STT provider
- CLASS_SESSION-API03: quiz backend
- CLASS_SESSION-API04: AI transcript Q&A

## Non-functional requirements

- Security: không log secret/token/password/PII sản xuất; kiểm tra role và scope dữ liệu.
- Resilience: UI có loading, empty, error, offline và success state khi phù hợp.
- Traceability: mọi feature/function/view/case link tới ID và source BD.
- Documentation: unknowns phải ghi `OPEN_QUESTION`, không dùng dữ liệu giả như thật.

## Risks và open questions

| ID | Nội dung |
|---|---|
| CLASS_SESSION-RISK01 | OPEN_QUESTION - Route/screen chi tiết buổi học chưa xác nhận hoàn chỉnh |
| CLASS_SESSION-RISK02 | OPEN_QUESTION - Audio storage/retention chưa có contract |
| CLASS_SESSION-RISK03 | OPEN_QUESTION - STT provider/quota/retry/cache chưa chốt |
| CLASS_SESSION-RISK04 | OPEN_QUESTION - Quiz schema/realtime stats chưa có backend spec |
| CLASS_SESSION-RISK05 | OPEN_QUESTION - Q&A/FAQ policy chưa rõ |

## ADR

- CLASS_SESSION-ADR01: Dùng Markdown module DD theo `.agent/dd/module-dd-instruction.md` và extension `cases/` đã được user phê duyệt.
- CLASS_SESSION-ADR02: Dùng source evidence trong BD/agent docs, không tự tạo contract API/schema.

## Traceability

| BD row | Case | Feature | Function | View |
|---|---|---|---|---|
| 9 | CLASS_SESSION-CASE-09 | CLASS_SESSION-F01 | CLASS_SESSION-FN01 | CLASS_SESSION-V01 |
| 10 | CLASS_SESSION-CASE-10 | CLASS_SESSION-F02 | CLASS_SESSION-FN02 | CLASS_SESSION-V02 |
| 11 | CLASS_SESSION-CASE-11 | CLASS_SESSION-F03 | CLASS_SESSION-FN03 | CLASS_SESSION-V03 |
| 12 | CLASS_SESSION-CASE-12 | CLASS_SESSION-F04 | CLASS_SESSION-FN04 | CLASS_SESSION-V04 |
| 13 | CLASS_SESSION-CASE-13 | CLASS_SESSION-F05 | CLASS_SESSION-FN05 | CLASS_SESSION-V05 |
| 16 | CLASS_SESSION-CASE-16 | CLASS_SESSION-F06 | CLASS_SESSION-FN06 | CLASS_SESSION-V06 |
| 17 | CLASS_SESSION-CASE-17 | CLASS_SESSION-F07 | CLASS_SESSION-FN07 | CLASS_SESSION-V07 |
| 28 | CLASS_SESSION-CASE-28 | CLASS_SESSION-F08 | CLASS_SESSION-FN08 | CLASS_SESSION-V08 |
| 29 | CLASS_SESSION-CASE-29 | CLASS_SESSION-F09 | CLASS_SESSION-FN09 | CLASS_SESSION-V09 |
| 30 | CLASS_SESSION-CASE-30 | CLASS_SESSION-F10 | CLASS_SESSION-FN10 | CLASS_SESSION-V10 |

## Approval

- Trạng thái: Draft DD v0.1.
- Điều kiện implement: review và xử lý các `OPEN_QUESTION` ảnh hưởng đến API, authorization, schema, bảo mật và business rule.
