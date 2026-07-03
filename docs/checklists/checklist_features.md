# DD Coding Progress Checklist

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` DD_PROGRESS
- `PATTERN:` dd-backed-progress-checklist
- `DATE:` 2026-07-03
- `TOTAL_CASES:` 30
- `PROGRESS_FORMULA:` Average of case-level coding percentages.

## Sources Used

- `AGENTS.md` - repository workflow, safety, and handoff rules.
- `docs/DD/*/README.md` and `docs/DD/*/List_Features.md` - DD case inventory and priority.
- `docs/checklists/coding/CODING-AUTH-20260703-dd-auth.md` - completed AUTH coding evidence.
- `docs/checklists/coding/CODING-HOME-20260703-dd-home.md` - completed HOME coding evidence.
- `docs/checklists/coding/CODING-TEACHER-API-20260703.md` - teacher API foundation evidence.
- `docs/checklists/coding/CODING-AI-20260703-source-backed.md` - source-backed AI shell evidence.
- `docs/checklists/coding/CODING-LEARNING-PORTAL-20260703-source-backed.md` - learning portal catalog evidence.
- `docs/checklists/coding/CODING-TASK-PLATFORM-LOCAL-20260703.md` - local Todo and analytics foundation evidence.
- `docs/checklists/coding/CODING-CLASS-SESSION-LOCAL-20260703.md` - schedule-backed class session detail and local notes evidence.
- `docs/checklists/coding/CODING-OFFLINE-SQLITE-SYNC-20260703.md` - daotao SQLite cache, offline startup, and manual sync evidence.
- `.agent/worklogs/CODING/WL-20260703-01-dd-auth.md` - AUTH coding handoff.
- `.agent/worklogs/CODING/WL-20260703-02-dd-home.md` - HOME coding handoff.
- `.agent/worklogs/CODING/WL-20260703-04-teacher-api.md` - teacher API coding handoff.
- `.agent/worklogs/CODING/WL-20260703-05-ai-source-backed.md` - AI source-backed coding handoff.
- `.agent/worklogs/CODING/WL-20260703-06-learning-portal.md` - learning portal coding handoff.
- `.agent/worklogs/CODING/WL-20260703-07-task-platform-local.md` - task/platform local coding handoff.
- `.agent/worklogs/CODING/WL-20260703-08-class-session-local.md` - class session local coding handoff.
- `.agent/worklogs/CODING/WL-20260703-10-offline-sqlite-sync.md` - offline SQLite sync coding handoff.
- Direct source evidence under `lib/features/`, `lib/core/`, `lib/config/`, and `test/` for AI, platform, QR, Home, Auth, and placeholder checks.

## Scoring Rubric

| Coding % | Meaning |
|---:|---|
| 100% | Implemented and tested against DD intent. |
| 75% | Main user flow implemented; minor DD items unresolved. |
| 50% | Partial source-backed implementation exists. |
| 25% | UI/stub/disabled state only, or infrastructure exists but business flow is missing. |
| 0% | No direct implementation evidence, or implementation is blocked by unresolved contract. |

## Overall Progress

| Metric | Value |
|---|---:|
| DD cases reviewed | 30 |
| Completed cases at 100% | 7 |
| Partial/stub cases above 0% | 10 |
| Not started or blocked cases | 13 |
| Overall coding progress | 43.3% |

## Module Progress

| Module | Cases | Coding % | Status |
|---|---:|---:|---|
| DD_AUTH | 3 | 91.7% | Mostly implemented; VNied OAuth2, secure storage, and role routing remain open. |
| DD_HOME | 5 | 80.0% | Source-backed MVP implemented; local Todo due dates now feed deadline preview; official deadlines, ads/events, and analytics suggestions remain open. |
| DD_CLASS_SESSION | 10 | 12.5% | Schedule-backed detail and local text notes exist; audio, transcript, quiz, Q&A, attendance, and scoring contracts remain open. |
| DD_ATTENDANCE | 2 | 12.5% | Generic QR scanner exists; attendance business flow is missing. |
| DD_AI_ASSISTANT | 3 | 58.3% | AI tab/page and limited local context exist; STT, OS deep link, and data policy remain open. |
| DD_TASK | 3 | 25.0% | Local offline Todo exists; submission/report and learning-plan contracts remain open. |
| DD_LEARNING_PORTAL | 1 | 75.0% | Catalog search/statistics UI exists; official course material/deadline metrics remain open. |
| DD_RESIDENCE | 1 | 0.0% | Not started. |
| DD_PLATFORM | 2 | 75.0% | SQLite/offline infrastructure now includes daotao response cache, offline startup access, manual sync, local tasks, notes, and anonymous local analytics; mutation conflict policy and backend analytics remain open. |

## Priority Progress

| Priority | Cases | Coding % | Notes |
|---|---:|---:|---|
| P0 - MVP | 19 | 59.2% | AUTH, HOME, AI tab, local Todo, class-session detail/notes, daotao SQLite cache, and offline app access carry MVP progress; attendance, AI STT, and official backend contracts remain incomplete. |
| P1 | 8 | 21.9% | Notification preview, learning portal search/catalog, and local analytics provide partial progress. |
| P2 | 3 | 0.0% | No source-backed implementation found for P2 cases. |

## Case Progress

| Module | Case | Priority | Coding % | Status | Evidence | Blocked/Open question | Next step |
|---|---|---|---:|---|---|---|---|
| DD_AUTH | AUTH-CASE-01 - Làm lại giao diện đăng nhập và logo | P0 - MVP | 100% | DONE | `CODING-AUTH-20260703-dd-auth.md`, `test/auth_dd_auth_test.dart`, `lib/features/auth/student/screens/student_login_view.dart` | - | Manual smoke test on device/emulator remains useful. |
| DD_AUTH | AUTH-CASE-02 - Bỏ chọn role, thêm đăng nhập VNied | P0 - MVP | 75% | PARTIAL | `CODING-AUTH-20260703-dd-auth.md`, unauthenticated route now enters `LoginScreen`, VNied button is disabled stub. | OPEN_QUESTION: VNied OAuth2 endpoint/client/redirect/scope, secure storage policy, and role routing contract are not approved. | Resolve VNied and role contracts, then enable real VNied login and post-login role routing. |
| DD_AUTH | AUTH-CASE-03 - Avatar dropdown gồm logout và cài đặt | P0 - MVP | 100% | DONE | `CODING-AUTH-20260703-dd-auth.md`, avatar dropdown/logout cleanup covered by AUTH tests. | - | Manual smoke test avatar settings/logout path. |
| DD_HOME | HOME-CASE-04 - Trang chủ: lịch thay phần chào mừng | P0 - MVP | 100% | DONE | `CODING-HOME-20260703-dd-home.md`, `lib/features/home/home_view/screens/student_home_view.dart`, `test/home_dd_home_test.dart` | - | Validate with authenticated schedule data on device/emulator. |
| DD_HOME | HOME-CASE-05 - Thời khóa biểu hiển thị ngang | P0 - MVP | 100% | DONE | `CODING-HOME-20260703-dd-home.md`, `lib/features/home/home_view/components/home_schedule_section.dart`, `test/home_dd_home_test.dart` | - | Validate rendering with real dense schedule data. |
| DD_HOME | HOME-CASE-06 - Deadline phần 2 | P0 - MVP | 50% | PARTIAL | `CODING-HOME-20260703-dd-home.md`, `CODING-TASK-PLATFORM-LOCAL-20260703.md`, `HomeDeadlineSection` shows upcoming local Todo due dates and keeps source-gap empty state when none exist. | OPEN_QUESTION: official deadline/submission source is not available. | Define deadline/submission source contract before implementing official cards and navigation. |
| DD_HOME | HOME-CASE-07 - Lối tắt tự cấu hình thay tổng quan nhanh | P0 - MVP | 100% | DONE | `CODING-HOME-20260703-dd-home.md`, `home_shortcuts` SQLite table, `test/home_dd_home_test.dart` | - | Validate persistence after app restart on device/emulator. |
| DD_HOME | HOME-CASE-08 - Thông báo và quảng cáo phần 3 | P1 | 50% | PARTIAL | `CODING-HOME-20260703-dd-home.md`, `HomeNotificationSection` uses notification data. | OPEN_QUESTION: advertising/event source and analytics-based suggestions are not defined. | Keep notification preview; add event/ads source only after contract approval. |
| DD_CLASS_SESSION | CLASS_SESSION-CASE-09 - Trang chi tiết buổi học | P0 - MVP | 75% | PARTIAL | `CODING-CLASS-SESSION-LOCAL-20260703.md`, `ClassSessionDetailScreen` renders details from existing schedule items and Home schedule cards open it. | OPEN_QUESTION: teacher/session route contract and richer backend session data are not confirmed. | Define official class-session route/data contract before adding backend-only fields. |
| DD_CLASS_SESSION | CLASS_SESSION-CASE-10 - Ghi chú và ghi âm trong buổi học | P0 - MVP | 50% | PARTIAL | `CODING-CLASS-SESSION-LOCAL-20260703.md`, local `class_session_notes` SQLite table and note CRUD UI exist. | OPEN_QUESTION: audio storage, retention, and permission policy missing. | Keep text notes local; define audio policy before recording/transcript work. |
| DD_CLASS_SESSION | CLASS_SESSION-CASE-11 - Transcript buổi học | P0 - MVP | 0% | NOT_STARTED | No transcript pipeline found. | OPEN_QUESTION: STT provider, quota, retry, and cache policy missing. | Choose STT provider and transcript storage contract. |
| DD_CLASS_SESSION | CLASS_SESSION-CASE-12 - Quiz / ra đề bằng text và giọng nói | P0 - MVP | 0% | NOT_STARTED | No quiz authoring or voice quiz flow found. | OPEN_QUESTION: quiz schema and realtime behavior missing. | Define quiz schema/API and role permissions. |
| DD_CLASS_SESSION | CLASS_SESSION-CASE-13 - Thống kê người trả lời quiz | P0 - MVP | 0% | NOT_STARTED | No quiz statistics implementation found. | OPEN_QUESTION: quiz submission/statistics backend contract missing. | Implement after quiz data model and submission flow exist. |
| DD_CLASS_SESSION | CLASS_SESSION-CASE-16 - Trang Q&A theo buổi học | P1 | 0% | NOT_STARTED | No class-session Q&A flow found. | OPEN_QUESTION: Q&A policy and moderation behavior missing. | Define Q&A data model and moderation rules. |
| DD_CLASS_SESSION | CLASS_SESSION-CASE-17 - Bộ FAQ | P1 | 0% | NOT_STARTED | No FAQ feature found for class sessions. | OPEN_QUESTION: FAQ ownership and source policy missing. | Define FAQ source, edit rights, and presentation rules. |
| DD_CLASS_SESSION | CLASS_SESSION-CASE-28 - Giao diện giảng viên đơn giản | P1 | 0% | NOT_STARTED | Current authenticated shell remains student-focused; teacher API foundation exists in `lib/features/teacher/` and `lib/core/constants/api/api_daotao_teacher.dart`. | OPEN_QUESTION: teacher route and role source missing. | Resolve teacher role/routing before building teacher UI. |
| DD_CLASS_SESSION | CLASS_SESSION-CASE-29 - Điều phối trong buổi học | P2 | 0% | NOT_STARTED | No class-session moderation/coordination flow found. | OPEN_QUESTION: coordination state machine and permissions missing. | Define facilitator actions and state transitions. |
| DD_CLASS_SESSION | CLASS_SESSION-CASE-30 - Đánh giá sinh viên theo quá trình đóng góp | P2 | 0% | NOT_STARTED | No contribution scoring flow found. | OPEN_QUESTION: scoring rubric and data sources missing. | Define scoring inputs, visibility, and export policy. |
| DD_ATTENDANCE | ATTENDANCE-CASE-14 - Điểm danh QR cá nhân | P0 - MVP | 25% | STUB | `lib/features/qr_code/screens/view_qr_code.dart` provides a generic QR scanner only. | OPEN_QUESTION: signed QR generation/verification, attendance backend, and scan authority missing. | Define attendance QR contract, then connect scanner/generator to attendance state. |
| DD_ATTENDANCE | ATTENDANCE-CASE-15 - Xem danh sách vắng cho giảng viên | P0 - MVP | 0% | NOT_STARTED | No teacher roster/absence screen found. | OPEN_QUESTION: attendance roster/export backend and teacher authorization missing. | Resolve roster source and export format before coding. |
| DD_AI_ASSISTANT | AI_ASSISTANT-CASE-18 - AI tích hợp dữ liệu nội bộ và deep link | P0 - MVP | 75% | PARTIAL | `CODING-AI-20260703-source-backed.md`, `AiContextService` selectively includes notification and schedule cache context when prompts are relevant. | OPEN_QUESTION: AI data access policy and OS deep link scheme missing. | Define data-access allowlist and approved navigation/deep-link routes before expanding actions. |
| DD_AI_ASSISTANT | AI_ASSISTANT-CASE-19 - Speech-to-Text tích hợp AI | P0 - MVP | 0% | NOT_STARTED | No STT capture/provider integration found. | OPEN_QUESTION: STT provider, quota, offline behavior, and privacy policy missing. | Choose STT provider and permission/privacy behavior. |
| DD_AI_ASSISTANT | AI_ASSISTANT-CASE-20 - Thay Chat bằng AI trên navigation | P0 - MVP | 100% | DONE | `CODING-AI-20260703-source-backed.md`, Home shell navigation now uses an `AI` tab with `AIChatScreen`; duplicate AI FAB/dialog path removed. | - | Manual smoke test the AI tab on device/emulator. |
| DD_TASK | TASK-CASE-21 - Todo online và offline | P0 - MVP | 75% | PARTIAL | `CODING-TASK-PLATFORM-LOCAL-20260703.md`, local `tasks` SQLite table, model/service/controller, Todo UI, and Home upcoming due-date preview exist. | OPEN_QUESTION: online task source, sync conflict handling, and backend task API missing. | Define online sync contract before marking this fully done. |
| DD_TASK | TASK-CASE-22 - Nộp bài / giao bài / tạo báo cáo | P1 | 0% | NOT_STARTED | No submission, assignment, file upload, or report generation flow found. | OPEN_QUESTION: submission API, file storage, and report template missing. | Define assignment/submission contracts and report template. |
| DD_TASK | TASK-CASE-23 - Kế hoạch học tập | P1 | 0% | NOT_STARTED | No learning-plan feature found. | OPEN_QUESTION: plan schema and linkage to schedule/deadline missing. | Define learning-plan data model and integration points. |
| DD_LEARNING_PORTAL | LEARNING_PORTAL-CASE-24 - Cổng học tập: bỏ tiêu đề, thêm thống kê và search | P1 | 75% | PARTIAL | `CODING-LEARNING-PORTAL-20260703-source-backed.md`, `HocTapView` is catalog-driven with search, grouped functions, item count/stat summary, and empty state. | OPEN_QUESTION: course material/deadline source and completion/failure rules missing. | Add official metrics after source and metric rules are defined. |
| DD_RESIDENCE | RESIDENCE-CASE-25 - Đăng ký tạm trú / tạm vắng và QR | P2 | 0% | NOT_STARTED | No residence registration form, PDF export, or verification flow found. | OPEN_QUESTION: legal form/PDF template, public verification API, token policy, and PII retention missing. | Define legal template and privacy/security contract before coding. |
| DD_PLATFORM | PLATFORM-CASE-26 - Lưu SQLite offline | P0 - MVP | 100% | DONE | `CODING-OFFLINE-SQLITE-SYNC-20260703.md`, SQLite v6 adds `api_response_cache`; `ApiHelper` stores daotao JSON responses immediately and falls back to cache; Home has sync button; offline startup allows local-session users into app; schedule display reads SQLite/cache. | - | Manual smoke test on device with airplane mode after one successful sync. |
| DD_PLATFORM | PLATFORM-CASE-27 - Analytics hành vi người dùng | P1 | 50% | PARTIAL | `CODING-TASK-PLATFORM-LOCAL-20260703.md`, local anonymous `analytics_events` model/service/validator exists and rejects token/cookie/password/PII-like metadata. | OPEN_QUESTION: analytics provider/taxonomy/consent/retention missing. | Approve analytics policy and event taxonomy before network instrumentation. |

## Verification

- [x] `docs/checklists/checklist_features.md` includes 30 case rows.
- [x] Every DD module has a module percentage.
- [x] Every non-100% row includes a blocker/open question or next step.
- [x] No secret values, API keys, tokens, passwords, connection strings, production PII, or terminal logs copied.
- [x] Latest TEACHER_API slice changed app source only for teacher API foundation; runtime configuration, migrations, dependencies, and DD source content unchanged.
- [x] Focused TEACHER_API parser tests and scoped analyzer passed.
- [x] Source-backed AI, learning portal, task/platform local, and class-session local slices implemented with focused widget/unit tests.
- [x] `flutter test test\source_backed_remaining_test.dart test\home_dd_home_test.dart` passed.
- [x] Full `flutter test` passed.
- [x] Scoped `flutter analyze` on touched source/test files passed.
- [x] Full `flutter analyze` still fails with 599 existing repo-wide issues outside this slice.
- [x] Offline SQLite sync slice implemented with daotao response cache, manual Home sync button, offline startup access, and focused tests.
- [x] `flutter test test\home_dd_home_test.dart test\source_backed_remaining_test.dart` passed after offline sync changes.

## Handoff

- `NEXT:` Resolve the remaining P0 `OPEN_QUESTION` contracts before implementing blocked backend/STT/audio/attendance flows.
- `READ:` Target DD package README, then its case file and source-backed checklist/worklog if present.
- `WORKLOG:` `.agent/worklogs/CODING/WL-20260703-03-dd-progress-checklist.md`, `.agent/worklogs/CODING/WL-20260703-04-teacher-api.md`, `.agent/worklogs/CODING/WL-20260703-05-ai-source-backed.md`, `.agent/worklogs/CODING/WL-20260703-06-learning-portal.md`, `.agent/worklogs/CODING/WL-20260703-07-task-platform-local.md`, `.agent/worklogs/CODING/WL-20260703-08-class-session-local.md`, `.agent/worklogs/CODING/WL-20260703-10-offline-sqlite-sync.md`
