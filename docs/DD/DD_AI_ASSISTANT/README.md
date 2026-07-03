# DD AI_ASSISTANT - AI trợ lý

- `STATUS:` DONE
- `MODULE_CODE:` AI_ASSISTANT
- `MODULE_NAME:` AI trợ lý
- `TECHNICAL_NAME:` ai_assistant
- `RELEASE_SCOPE:` MVP
- `SOURCE_BD:` `docs/BD/BasicDesign_LearningApp.md` - BD sections 6, 10.3, 10.4, rows 18-20
- `TEMPLATE:` `.agent/dd/module-dd-instruction.md` approved with `cases/` extension
- `LANGUAGE:` Tiếng Việt

## Mục đích

AI thay Chat trên navigation, truy vấn dữ liệu nội bộ, hỗ trợ Speech-to-Text và deep link điều hướng.

## Cấu trúc package

| File / thư mục | Vai trò |
|---|---|
| README.md | Tổng quan package và danh sách case |
| Overall.md | Goals, boundary, rules, data, integrations, risks, traceability |
| List_Features.md | Feature inventory và mô tả từng feature |
| Function_List.md | Function/use case, I/O, permission, validation, side effects |
| Views.md | View inventory, UI states và action mapping |
| Import_File.md | Mapping source path, imports, contracts, config keys, test mapping |
| cases/ | Case-level DD cho từng dòng ưu tiên BD |
| diagrams/ | Evidence-only diagram notes |
| assets/ | Evidence-only asset notes |
| history/ | Lịch sử tài liệu |

## Case inventory

| Case ID | Tên case | Ưu tiên | File |
|---|---|---|---|
| AI_ASSISTANT-CASE-18 | AI tích hợp dữ liệu nội bộ và deep link | P0 - MVP | cases/AI_ASSISTANT-CASE-18-ai-tich-hop-du-lieu-noi-bo-va-deep-link.md |
| AI_ASSISTANT-CASE-19 | Speech-to-Text tích hợp AI | P0 - MVP | cases/AI_ASSISTANT-CASE-19-speech-to-text-tich-hop-ai.md |
| AI_ASSISTANT-CASE-20 | Thay Chat bằng AI trên navigation | P0 - MVP | cases/AI_ASSISTANT-CASE-20-thay-chat-bang-ai-tren-navigation.md |

## Evidence

- `docs/BD/BasicDesign_LearningApp.md`
- `.agent/dd/module-dd-instruction.md`
- `.agent/architecture/overview.md`
- `.agent/architecture/flutter-app.md`
- `.agent/api/index.md`
- `.agent/database/overview.md`

## Safety

- Tài liệu này không xác nhận toàn bộ chức năng đã implement.
- Không ghi secret values, token, password, connection string hoặc PII sản xuất.
