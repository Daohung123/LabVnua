# Overall - AI trợ lý

## Metadata

| Hạng mục | Nội dung |
|---|---|
| Dự án | Learning Management App |
| Module | AI trợ lý |
| Module code | AI_ASSISTANT |
| Technical name | ai_assistant |
| Phiên bản DD | v0.1 |
| Ngày tạo | 2026-07-03 |
| Nguồn | docs/BD/BasicDesign_LearningApp.md - BD sections 6, 10.3, 10.4, rows 18-20 |
| Template | .agent/dd/module-dd-instruction.md |
| Phạm vi release | MVP |

## Goals

- Triển khai thiết kế chi tiết cho module `AI_ASSISTANT` từ Basic Design.
- Giữ traceability từ feature/function/view/case tới BD.
- Đánh dấu rõ contract chưa có source bằng `OPEN_QUESTION`.

## Non-goals

- Không sửa app source, runtime config, migrations hoặc dependencies.
- Không tự định nghĩa API/schema/security contract chưa được phê duyệt.
- Không coi behavior trong DD là đã implement nếu code evidence chưa tồn tại.

## Boundary và ownership

- Module này thuộc package `DD_AI_ASSISTANT` dưới `docs/DD/`.
- Implement sau nên theo feature-first Flutter: `lib/features/` cho feature UI/controller/service, `lib/core/` cho shared services, `lib/config/` cho database/config.
- Các public contract hoặc schema chưa có nguồn phải được giải quyết trước khi code.

## Actors và permissions

- Sinh viên
- Giảng viên

## Context

AI thay Chat trên navigation, truy vấn dữ liệu nội bộ, hỗ trợ Speech-to-Text và deep link điều hướng.

## Feature index

| Feature ID | Feature | Function | View | Case |
|---|---|---|---|---|
| AI_ASSISTANT-F01 | AI tích hợp dữ liệu nội bộ và deep link | AI_ASSISTANT-FN01 | AI_ASSISTANT-V01 | AI_ASSISTANT-CASE-18 |
| AI_ASSISTANT-F02 | Speech-to-Text tích hợp AI | AI_ASSISTANT-FN02 | AI_ASSISTANT-V02 | AI_ASSISTANT-CASE-19 |
| AI_ASSISTANT-F03 | Thay Chat bằng AI trên navigation | AI_ASSISTANT-FN03 | AI_ASSISTANT-V03 | AI_ASSISTANT-CASE-20 |

## Flows

| Case | Flow |
|---|---|
| AI_ASSISTANT-CASE-18 | Người dùng hỏi -> Resolver lấy context được phép -> AI trả lời kèm action |
| AI_ASSISTANT-CASE-19 | Ghi âm câu hỏi -> STT thành text tiếng Việt -> Gửi text vào AI |
| AI_ASSISTANT-CASE-20 | Đổi Chat thành AI -> Mở AI từ tab -> Chuyển nhắn tin đối tác nếu còn dùng |

## States

- Idle
- Đang nhận input
- Đang gọi AI
- Có câu trả lời
- Có action điều hướng
- Lỗi AI/STT
- Không đủ quyền dữ liệu

## Business rules

- AI_ASSISTANT-BR01: AI chỉ dùng dữ liệu người dùng được phép truy cập
- AI_ASSISTANT-BR02: Action điều hướng phải được validate
- AI_ASSISTANT-BR03: Chat navigation chuyển thành AI

## Data

- AI_ASSISTANT-E-context: context nội bộ
- AI_ASSISTANT-E-entity-map: ánh xạ thực thể
- AI_ASSISTANT-E-action: action điều hướng
- AI_ASSISTANT-E-voice-input: input giọng nói

## Integrations

- AI_ASSISTANT-API01: Gemini
- AI_ASSISTANT-API02: internal context resolver
- AI_ASSISTANT-API03: STT
- AI_ASSISTANT-API04: deep link/action router

## Non-functional requirements

- Security: không log secret/token/password/PII sản xuất; kiểm tra role và scope dữ liệu.
- Resilience: UI có loading, empty, error, offline và success state khi phù hợp.
- Traceability: mọi feature/function/view/case link tới ID và source BD.
- Documentation: unknowns phải ghi `OPEN_QUESTION`, không dùng dữ liệu giả như thật.

## Risks và open questions

| ID | Nội dung |
|---|---|
| AI_ASSISTANT-RISK01 | OPEN_QUESTION - Data access policy cho AI chưa rõ |
| AI_ASSISTANT-RISK02 | OPEN_QUESTION - Deep link scheme chưa định nghĩa |
| AI_ASSISTANT-RISK03 | OPEN_QUESTION - STT provider/quota/offline chưa chốt |
| AI_ASSISTANT-RISK04 | OPEN_QUESTION - Luồng nhắn tin đối tác sau khi thay Chat chưa thiết kế |

## ADR

- AI_ASSISTANT-ADR01: Dùng Markdown module DD theo `.agent/dd/module-dd-instruction.md` và extension `cases/` đã được user phê duyệt.
- AI_ASSISTANT-ADR02: Dùng source evidence trong BD/agent docs, không tự tạo contract API/schema.

## Traceability

| BD row | Case | Feature | Function | View |
|---|---|---|---|---|
| 18 | AI_ASSISTANT-CASE-18 | AI_ASSISTANT-F01 | AI_ASSISTANT-FN01 | AI_ASSISTANT-V01 |
| 19 | AI_ASSISTANT-CASE-19 | AI_ASSISTANT-F02 | AI_ASSISTANT-FN02 | AI_ASSISTANT-V02 |
| 20 | AI_ASSISTANT-CASE-20 | AI_ASSISTANT-F03 | AI_ASSISTANT-FN03 | AI_ASSISTANT-V03 |

## Implemented architecture update (2026-07-22)

- Gemini classification is restricted to `noSqlite`, `sqlite`, and `navigate`; it cannot produce SQL, routes, URLs, table names, or widgets.
- Context uses a local academic allowlist. Credentials, raw payloads, chat, contact/financial data, and analytics are excluded.
- Vietnamese STT/TTS supports short commands. Voice navigation runs only after TTS completes; a safe manual navigation action remains available on TTS failure.
- Navigation is a typed local allowlist for existing screens. Entity-detail navigation remains disabled until a resolver exists.

## Runtime configuration (2026-07-22)

- Gemini receives `GEMINI_API_KEY` and `GEMINI_MODEL` through
  `--dart-define-from-file=.env` and `String.fromEnvironment`.
- `.env` is local and Git-ignored; `.env.example` has no credential values.
- The default model is `gemini-3.5-flash`. A mobile client key is not a
  server-side secret, so production requires appropriate key restriction or a
  backend proxy.

## Remaining verification

- Android/iOS real-device and release-build validation is still required for STT/TTS and SQLCipher.
- Supabase realtime-to-local-cache wiring remains subject to the repository's missing Supabase schema/RLS contract.

## Approval

- Trạng thái: Draft DD v0.1.
- Điều kiện implement: review và xử lý các `OPEN_QUESTION` ảnh hưởng đến API, authorization, schema, bảo mật và business rule.
