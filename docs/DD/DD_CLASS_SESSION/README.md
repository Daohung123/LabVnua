# DD CLASS_SESSION - Buổi học

- `STATUS:` DONE
- `MODULE_CODE:` CLASS_SESSION
- `MODULE_NAME:` Buổi học
- `TECHNICAL_NAME:` class_session
- `RELEASE_SCOPE:` MVP + Sprint 2/3 + Later
- `SOURCE_BD:` `docs/BD/BasicDesign_LearningApp.md` - BD section 4, rows 9-13,16-17,28-30
- `TEMPLATE:` `.agent/dd/module-dd-instruction.md` approved with `cases/` extension
- `LANGUAGE:` Tiếng Việt

## Mục đích

Gom chi tiết buổi học, ghi chú/ghi âm, transcript, quiz, Q&A, FAQ, tiến độ và tác vụ giảng viên.

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
| CLASS_SESSION-CASE-09 | Trang chi tiết buổi học | P0 - MVP | cases/CLASS_SESSION-CASE-09-trang-chi-tiet-buoi-hoc.md |
| CLASS_SESSION-CASE-10 | Ghi chú và ghi âm trong buổi học | P0 - MVP | cases/CLASS_SESSION-CASE-10-ghi-chu-va-ghi-am-trong-buoi-hoc.md |
| CLASS_SESSION-CASE-11 | Transcript buổi học | P0 - MVP | cases/CLASS_SESSION-CASE-11-transcript-buoi-hoc.md |
| CLASS_SESSION-CASE-12 | Quiz / ra đề bằng text và giọng nói | P0 - MVP | cases/CLASS_SESSION-CASE-12-quiz-ra-de-bang-text-va-giong-noi.md |
| CLASS_SESSION-CASE-13 | Thống kê người trả lời quiz | P0 - MVP | cases/CLASS_SESSION-CASE-13-thong-ke-nguoi-tra-loi-quiz.md |
| CLASS_SESSION-CASE-16 | Trang Q&A theo buổi học | P1 | cases/CLASS_SESSION-CASE-16-trang-q-a-theo-buoi-hoc.md |
| CLASS_SESSION-CASE-17 | Bộ FAQ | P1 | cases/CLASS_SESSION-CASE-17-bo-faq.md |
| CLASS_SESSION-CASE-28 | Giao diện giảng viên đơn giản | P1 | cases/CLASS_SESSION-CASE-28-giao-dien-giang-vien-don-gian.md |
| CLASS_SESSION-CASE-29 | Điều phối trong buổi học | P2 | cases/CLASS_SESSION-CASE-29-dieu-phoi-trong-buoi-hoc.md |
| CLASS_SESSION-CASE-30 | Đánh giá sinh viên theo quá trình đóng góp | P2 | cases/CLASS_SESSION-CASE-30-danh-gia-sinh-vien-theo-qua-trinh-dong-gop.md |

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
