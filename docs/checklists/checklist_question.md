# DD Open Questions And Coding Blockers

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` DD_OPEN_QUESTIONS
- `PATTERN:` source-backed-blocker-inventory
- `DATE:` 2026-07-03
- `SOURCE_OF_TRUTH:` `docs/checklists/checklist_features.md`

## Purpose

Tài liệu này gom toàn bộ vướng mắc hiện tại của các DD để chọn task coding tiếp theo mà không đoán business rule, API contract, quyền truy cập, schema, privacy, hoặc sync policy.

Nguyên tắc áp dụng:

- Chỉ code phần có source/evidence rõ ràng.
- Các case còn `OPEN_QUESTION` không được nâng lên `DONE` nếu chưa có contract mới.
- Không thêm backend/API/role/STT/audio/analytics network/residence legal flow bằng suy đoán.
- Không ghi secret, token, cookie, password, connection string, production PII.

## Sources Read

- `AGENTS.md`
- `.agent/tasks/coding/workflow.md`
- `.agent/tasks/coding/rules.md`
- `.agent/skills/index.md`
- `docs/checklists/checklist_features.md`
- `.agent/worklogs/CODING/WL-20260703-06-learning-portal.md`
- `.agent/worklogs/CODING/WL-20260703-07-task-platform-local.md`
- `.agent/worklogs/CODING/WL-20260703-08-class-session-local.md`

## Current Progress Snapshot

| Metric | Value |
|---|---:|
| DD cases reviewed | 30 |
| Completed cases at 100% | 7 |
| Partial/stub cases above 0% | 10 |
| Not started or blocked cases | 13 |
| Overall coding progress | 43.3% |

| Priority | Cases | Coding % | Main blocker |
|---|---:|---:|---|
| P0 - MVP | 19 | 59.2% | Backend/API contracts, role policy, STT/audio/privacy, attendance contract, official deadline/task sync. |
| P1 | 8 | 21.9% | Ads/events source, Q&A/FAQ policy, teacher routing, submission/report APIs, learning metrics, analytics policy. |
| P2 | 3 | 0.0% | Residence legal/PDF/verification, class coordination, contribution scoring. |

## Module-Level Blockers

| Module | Coding % | Vướng mắc còn lại |
|---|---:|---|
| `DD_AUTH` | 91.7% | VNied OAuth2, secure storage policy, post-login role routing. |
| `DD_HOME` | 80.0% | Official deadline/submission source, advertising/event source, analytics-based suggestions. |
| `DD_CLASS_SESSION` | 12.5% | Teacher/session route, richer backend session data, audio, transcript, quiz, Q&A, FAQ, attendance roster/export, contribution scoring. |
| `DD_ATTENDANCE` | 12.5% | Signed QR generation/verification, attendance backend, scan authority, teacher roster/export authorization. |
| `DD_AI_ASSISTANT` | 58.3% | AI data-access allowlist, OS deep link scheme, STT provider/quota/offline/privacy. |
| `DD_TASK` | 25.0% | Online task source, sync conflict handling, submission API, file storage, report template, learning-plan schema. |
| `DD_LEARNING_PORTAL` | 75.0% | Official course material/deadline source, completion/failure metric rules. |
| `DD_RESIDENCE` | 0.0% | Legal form, PDF template, public verification API, token policy, PII retention. |
| `DD_PLATFORM` | 75.0% | Offline mutation conflict policy, analytics provider/taxonomy/consent/retention. |

## Cross-Cutting Questions Blocking Coding

### Backend/API Contracts

- Official deadline/submission source for Home and Learning Portal is missing.
- Online task API and task sync contract are missing.
- Assignment/submission/report APIs are missing.
- Quiz authoring, quiz submission, and quiz statistics APIs are missing.
- Attendance signed QR, verification, roster, absence, and export APIs are missing.
- Residence registration, PDF export, and public verification APIs are missing.
- Analytics network provider and event taxonomy are missing.

### Role And Authorization

- Post-login role routing contract is not approved.
- Teacher route source is missing.
- Teacher UI permissions are not defined.
- Attendance scan authority and teacher roster/export authorization are missing.
- Quiz, Q&A, FAQ, coordination, and contribution-scoring permissions are missing.

### Privacy, Security, And Retention

- Secure storage policy is not approved.
- Audio recording storage, retention, and permissions are missing.
- STT provider, quota, offline behavior, retry/cache, and privacy policy are missing.
- AI data-access allowlist is not approved.
- Analytics consent, retention, and server policy are missing.
- Residence token policy and PII retention are missing.
- Production logging policy is not documented.

### Offline And Sync

- Read-only daotao response caching and offline app access are implemented.
- Conflict-resolution policy for offline mutations is not defined.
- Local Todo currently has `sync_status=pending`, but no backend sync contract.
- Local class-session notes currently have local sync status, but no sync target.

### Source Gaps

- Advertising/event source for Home is not defined.
- Course material source is not defined.
- Learning completion/failure metric rules are not defined.
- Learning-plan schema and linkage to schedule/deadline are missing.
- Teacher role source is missing.
- Residence legal template/source is missing.

### Engineering Hygiene

- Full `flutter analyze` is still blocked by existing repo-wide lint debt: 599 issues recorded in `checklist_features.md`.
- Coding rule `OPEN_QUESTION-CODING-01`: no formal naming convention for Dart files/classes beyond mixed existing style.
- Coding rule `OPEN_QUESTION-CODING-02`: no approved production logging policy is documented.

## Per-Case Questions And Next Coding Stance

| Case | Priority | Current % | Status | Vướng mắc / câu hỏi cần trả lời | Có thể code tiếp an toàn? |
|---|---|---:|---|---|---|
| `AUTH-CASE-01` - Làm lại giao diện đăng nhập và logo | P0 | 100% | DONE | Không có blocker DD hiện tại. Còn nên manual smoke test trên device/emulator. | Không cần coding thêm trừ test/smoke hoặc polish có yêu cầu rõ. |
| `AUTH-CASE-02` - Bỏ chọn role, thêm đăng nhập VNied | P0 | 75% | PARTIAL | VNied OAuth2 endpoint/client/redirect/scope chưa có. Secure storage policy chưa duyệt. Role routing sau login chưa có contract. | Chỉ giữ VNied disabled stub. Không enable login thật hoặc role routing khi chưa có contract. |
| `AUTH-CASE-03` - Avatar dropdown gồm logout và cài đặt | P0 | 100% | DONE | Không có blocker DD hiện tại. Còn nên manual smoke test avatar/settings/logout. | Không cần coding thêm trừ test/smoke. |
| `HOME-CASE-04` - Trang chủ: lịch thay phần chào mừng | P0 | 100% | DONE | Không có blocker DD hiện tại. Cần validate với authenticated schedule data thật. | Có thể thêm test dữ liệu lịch dày nếu cần, không đổi business rule. |
| `HOME-CASE-05` - Thời khóa biểu hiển thị ngang | P0 | 100% | DONE | Không có blocker DD hiện tại. Cần validate rendering với schedule thật/dày. | Có thể thêm widget tests edge cases. |
| `HOME-CASE-06` - Deadline phần 2 | P0 | 50% | PARTIAL | Official deadline/submission source chưa có. Hiện chỉ có local Todo due dates và empty state khi không có nguồn chính thức. | Có thể cải thiện local Todo preview/UI. Không implement deadline chính thức hoặc navigation submit khi chưa có source. |
| `HOME-CASE-07` - Lối tắt tự cấu hình thay tổng quan nhanh | P0 | 100% | DONE | Không có blocker DD hiện tại. Cần validate persistence sau restart app thật. | Có thể thêm persistence tests nếu cần. |
| `HOME-CASE-08` - Thông báo và quảng cáo phần 3 | P1 | 50% | PARTIAL | Advertising/event source chưa có. Analytics-based suggestions chưa định nghĩa. | Chỉ giữ notification preview. Không thêm ads/events hoặc recommendation logic khi chưa có source/taxonomy. |
| `CLASS_SESSION-CASE-09` - Trang chi tiết buổi học | P0 | 75% | PARTIAL | Teacher/session route contract chưa rõ. Backend session data đầy đủ hơn schedule item chưa có. | Có thể polish local schedule-backed detail. Không thêm backend-only fields hoặc teacher routing. |
| `CLASS_SESSION-CASE-10` - Ghi chú và ghi âm trong buổi học | P0 | 50% | PARTIAL | Audio storage, retention, permission policy chưa có. Text notes local đã có. | Có thể cải thiện local text notes. Không thêm audio recording/transcript khi chưa có policy. |
| `CLASS_SESSION-CASE-11` - Transcript buổi học | P0 | 0% | NOT_STARTED | STT provider, quota, retry, cache policy, transcript storage contract chưa có. | Không code transcript/STT. Chỉ có thể chuẩn bị UI disabled/source-gap nếu được yêu cầu. |
| `CLASS_SESSION-CASE-12` - Quiz / ra đề bằng text và giọng nói | P0 | 0% | NOT_STARTED | Quiz schema/API, realtime behavior, voice quiz/STT, role permissions chưa có. | Không code quiz flow. Chỉ có thể tạo placeholder disabled nếu có yêu cầu rõ. |
| `CLASS_SESSION-CASE-13` - Thống kê người trả lời quiz | P0 | 0% | NOT_STARTED | Quiz submission/statistics backend contract chưa có. Phụ thuộc `CLASS_SESSION-CASE-12`. | Không code statistics khi quiz data model chưa có. |
| `CLASS_SESSION-CASE-16` - Trang Q&A theo buổi học | P1 | 0% | NOT_STARTED | Q&A data model, policy, moderation behavior chưa có. | Không code Q&A thật. Cần contract ownership/moderation trước. |
| `CLASS_SESSION-CASE-17` - Bộ FAQ | P1 | 0% | NOT_STARTED | FAQ ownership, source policy, edit rights chưa có. | Không code FAQ thật. Cần source và quyền chỉnh sửa trước. |
| `CLASS_SESSION-CASE-28` - Giao diện giảng viên đơn giản | P1 | 0% | NOT_STARTED | Teacher route và role source còn thiếu. Teacher API foundation đã có nhưng shell vẫn student-focused. | Không build teacher UI/routing khi chưa có role source. Có thể mở rộng parser/service teacher nếu có API source-backed mới. |
| `CLASS_SESSION-CASE-29` - Điều phối trong buổi học | P2 | 0% | NOT_STARTED | Coordination state machine và permissions chưa có. | Không code coordination flow khi chưa có trạng thái/quyền. |
| `CLASS_SESSION-CASE-30` - Đánh giá sinh viên theo quá trình đóng góp | P2 | 0% | NOT_STARTED | Scoring rubric, data sources, visibility, export policy chưa có. | Không code scoring. Cần rubric và nguồn dữ liệu trước. |
| `ATTENDANCE-CASE-14` - Điểm danh QR cá nhân | P0 | 25% | STUB | Signed QR generation/verification, attendance backend, scan authority chưa có. Hiện chỉ có generic QR scanner. | Không nối scanner vào attendance state. Có thể chỉ refactor scanner UI nếu không đổi business flow. |
| `ATTENDANCE-CASE-15` - Xem danh sách vắng cho giảng viên | P0 | 0% | NOT_STARTED | Attendance roster/export backend và teacher authorization chưa có. | Không code roster/export. Phụ thuộc teacher role và attendance backend. |
| `AI_ASSISTANT-CASE-18` - AI tích hợp dữ liệu nội bộ và deep link | P0 | 75% | PARTIAL | AI data-access policy và OS deep link scheme chưa duyệt. Hiện chỉ đọc notification/schedule cache có chọn lọc. | Có thể mở rộng allowlist local nếu có source rõ. Không thêm OS deep links hoặc dữ liệu nhạy cảm. |
| `AI_ASSISTANT-CASE-19` - Speech-to-Text tích hợp AI | P0 | 0% | NOT_STARTED | STT provider, quota, offline behavior, permission, privacy policy chưa có. | Không thêm STT dependency/provider. |
| `AI_ASSISTANT-CASE-20` - Thay Chat bằng AI trên navigation | P0 | 100% | DONE | Không có blocker DD hiện tại. Cần manual smoke test AI tab trên device/emulator. | Không cần coding thêm trừ smoke/test/polish. |
| `TASK-CASE-21` - Todo online và offline | P0 | 75% | PARTIAL | Online task source, backend task API, sync conflict handling chưa có. Local offline Todo đã có. | Có thể cải thiện local Todo/offline UX. Không implement sync online. |
| `TASK-CASE-22` - Nộp bài / giao bài / tạo báo cáo | P1 | 0% | NOT_STARTED | Submission API, assignment API, file storage, report template chưa có. | Không code submission/upload/report. Cần API/file/template contract trước. |
| `TASK-CASE-23` - Kế hoạch học tập | P1 | 0% | NOT_STARTED | Learning-plan schema và linkage tới schedule/deadline chưa có. | Không code plan thật. Có thể đợi task/deadline contract. |
| `LEARNING_PORTAL-CASE-24` - Cổng học tập: bỏ tiêu đề, thêm thống kê và search | P1 | 75% | PARTIAL | Course material/deadline source và completion/failure metric rules chưa có. Local catalog/search/stats đã có. | Có thể polish catalog/search. Không thêm official metrics khi chưa có source. |
| `RESIDENCE-CASE-25` - Đăng ký tạm trú / tạm vắng và QR | P2 | 0% | NOT_STARTED | Legal form/PDF template, public verification API, token policy, PII retention chưa có. | Không code residence flow/PDF/QR. Đây là privacy/legal-sensitive. |
| `PLATFORM-CASE-26` - Lưu SQLite offline | P0 | 100% | DONE | Daotao response cache, manual sync button, offline startup access, and SQLite/cache display path đã có. Mutation conflict policy vẫn ngoài scope. | Không cần coding thêm trừ smoke test offline thật hoặc khi có conflict policy cho mutation. |
| `PLATFORM-CASE-27` - Analytics hành vi người dùng | P1 | 50% | PARTIAL | Analytics provider, taxonomy, consent, retention chưa có. Local anonymous validator/service đã có. | Có thể ghi local anonymous events tối thiểu. Không gửi backend/network. |

## Coding Slices That Are Still Safe Without New Contracts

Các slice dưới đây có thể tiếp tục nếu muốn coding ngay, vì không cần đoán backend hoặc policy:

1. `TEST_ANALYZER_DEBT`: xử lý hoặc gom scoped lint debt trong các file đã chạm, hoặc tạo task riêng xử lý full analyzer debt. Không đổi business behavior.
2. `LOCAL_TASK_UX`: cải thiện Todo local-only: sort/filter, validation UI, more widget tests, no sync online.
3. `CLASS_SESSION_TEXT_NOTES`: cải thiện text notes local-only: edit note, timestamps, empty/error states, no audio/transcript.
4. `LEARNING_PORTAL_LOCAL_CATALOG`: polish search/group UI and tests using existing destinations only, no official course metrics.
5. `AI_LOCAL_CONTEXT_ALLOWLIST`: mở rộng AI context chỉ với local cached data đã có source rõ và không chứa secret/PII; không thêm OS deep link/STT.
6. `HOME_EDGE_TESTS`: thêm widget tests cho schedule dense data, shortcut persistence, local due task states.
7. `TEACHER_API_FOUNDATION_EXT`: chỉ mở rộng model/service teacher nếu có endpoint contract source-backed mới trong `.agent/api/api_vnua.md`.

## Coding Slices That Must Stay Blocked

Không nên code các slice này cho đến khi có answer/contract:

- VNied login thật.
- Secure storage migration.
- Student/teacher role routing.
- Teacher home UI.
- Official deadline/submission cards.
- Ads/events/recommendation source.
- Audio recording.
- STT/transcript.
- Quiz creation/submission/statistics.
- Q&A/FAQ/moderation.
- Attendance signed QR, roster, absence export.
- Task online sync.
- Assignment submission/upload/report generation.
- Learning plan.
- Residence registration/PDF/QR/public verification.
- Analytics backend/network dashboard.
- Offline mutation queue/conflict resolver.

## Questions To Ask Before Unblocking Major DD Areas

### Auth And Role

1. VNied OAuth2 endpoint/client/redirect/scope là gì?
2. Token/session nào được phép lưu ở đâu, bằng secure storage policy nào?
3. Sau login, nguồn xác định role student/teacher/admin là gì?
4. Nếu một tài khoản có nhiều role thì route mặc định và switch role thế nào?

### Home, Deadline, Learning Portal, Task

1. Deadline chính thức lấy từ API/table nào?
2. Submission/deadline có liên kết môn học/buổi học/task như thế nào?
3. Online Todo/task schema là gì?
4. Khi offline Todo sync lên backend bị conflict thì ưu tiên local hay server?
5. Course material source nằm ở đâu?
6. Completion/failure metrics của Learning Portal tính theo rule nào?

### Class Session

1. Session detail route nhận key/id nào?
2. Backend trả những field nào ngoài schedule item hiện có?
3. Ai được tạo/sửa/xóa note, Q&A, FAQ, quiz?
4. Audio có được ghi không, lưu ở đâu, giữ bao lâu?
5. Transcript dùng provider nào, quota/retry/cache ra sao?
6. Quiz realtime hay async, schema câu hỏi/câu trả lời/thống kê là gì?
7. Contribution scoring lấy dữ liệu từ đâu, ai xem được, export format nào?

### Attendance

1. QR điểm danh là QR ký số hay raw payload?
2. Ai tạo QR, ai scan QR, TTL bao lâu?
3. Backend verify attendance như thế nào?
4. Teacher roster/absence API và export format là gì?
5. Quyền giảng viên xem lớp/ca học được xác thực từ đâu?

### AI

1. AI được phép đọc những bảng local nào?
2. Có cần consent riêng khi AI đọc dữ liệu học tập không?
3. OS deep link scheme/path nào được duyệt?
4. STT provider nào, quota/offline behavior/privacy ra sao?
5. Có cần audit log cho AI action không, nếu có log field nào được phép?

### Residence

1. Mẫu pháp lý tạm trú/tạm vắng là mẫu nào?
2. PDF template chính thức ở đâu?
3. Public verification QR/API hoạt động thế nào?
4. Token policy, expiry, revocation là gì?
5. PII retention và xóa dữ liệu theo rule nào?

### Platform

1. Entity nào cần offline mutation queue ngoài read-only daotao cache?
2. Conflict policy cho từng entity mutation là gì?
3. Màn nào cần chặn mutation khi offline?
4. Analytics provider là gì?
5. Event taxonomy, consent, retention, opt-out là gì?
6. Production logging policy và naming convention Dart thống nhất thế nào?

## Next Recommended Coding Order

Thứ tự này ưu tiên phần có thể code an toàn trước, sau đó mới đụng phần cần contract:

1. `TEST_ANALYZER_DEBT` hoặc scoped lint cleanup để giảm nợ kỹ thuật đang chặn full `flutter analyze`.
2. `LOCAL_TASK_UX` vì đã có local SQLite/model/controller/UI/test.
3. `CLASS_SESSION_TEXT_NOTES` vì đã có local notes và không cần audio policy.
4. `LEARNING_PORTAL_LOCAL_CATALOG` vì chỉ dùng catalog/destination hiện có.
5. Chỉ sau khi có contract: `AUTH_ROLE_ROUTING`, `ATTENDANCE`, `TASK_SYNC`, `CLASS_SESSION_AUDIO_STT_QUIZ`, `RESIDENCE`, `ANALYTICS_BACKEND`.

## Verification

- [x] `docs/checklists/checklist_features.md` đã được đọc và mọi non-100% case đều được đưa vào tài liệu này.
- [x] Các case 100% vẫn được ghi nhận với smoke-test residual nếu có.
- [x] Các blocker từ module summary, priority summary, case rows, coding rules, và ba worklog gần nhất đã được tổng hợp.
- [x] Không copy terminal logs, secrets, token, cookie, password, connection string, hoặc production PII.
