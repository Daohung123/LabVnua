# CODING-AI-VOICE-LOCAL-FIRST-20260722 — AI thoại và dữ liệu local-first

- `STATUS:` DONE
- `SCOPE:` AI_ASSISTANT, LOCAL_FIRST_SECURITY, CHAT_CACHE
- `REF:` `docs/BD/AI_fisrt.md`
- `PATTERN:` sqlite-local-first-slice
- `TAGS:` ai, voice, sqlite, security, offline

## GOAL

- [x] Dữ liệu đọc của AI được lấy qua SQLite mã hóa theo phiên người dùng.
- [x] AI hỗ trợ nhập giọng nói và đọc phản hồi tiếng Việt trước điều hướng hợp lệ.
- [x] Không lưu credential trong SQLite hoặc gửi dữ liệu nhạy cảm vào Gemini.

## CONTEXT

- `auth.db` legacy không có owner scope và không được dùng làm nguồn mới.
- UI AI hiện chỉ hỗ trợ text và Gemini trả về chuỗi không có action có kiểu.

## PLAN

- [x] Thêm secure storage, SQLCipher, STT/TTS và permission nền tảng.
- [x] Chuyển session sang secure storage, tạo SQLite mã hóa theo owner hash, và xóa cache phiên khi logout.
- [x] Thêm owner-scoped snapshot/AI-turn local data source và read-only context registry.
- [x] Thêm intent/action có kiểu, gateway voice, navigation allowlist và UI mic.
- [x] Bảo toàn cache-only cho API đọc; mutation không fallback từ cache cũ.
- [x] Cập nhật context/docs, test, worklog và skill index.

## CHECK

- [x] Unit/widget test cho AI intent, allowlist, STT/TTS orchestration và thứ tự action.
- [x] `flutter test` và scoped `flutter analyze`.
- [x] Android release APK build pass; iOS/thiết bị thật được ghi rõ là ngoài workspace.

## FOLLOW-UP: STT → AI và cấu hình Gemini `.env`

- [x] Transcript partial hiển thị trong ô nhập; transcript final tạo bubble người dùng và tự gửi AI đúng một lần.
- [x] Stop gửi transcript hiện có; transcript rỗng, quyền STT, locale hoặc lỗi bất đồng bộ đều trả trạng thái tiếng Việt và cho phép thử lại.
- [x] Gemini nhận `GEMINI_API_KEY`/`GEMINI_MODEL` bằng `--dart-define-from-file=.env`; `.env` bị Git ignore, `.env.example` không có secret, model mặc định là `gemini-3.5-flash`.
- [x] Classify/generate đều timeout 20 giây; lỗi config, model, mạng và timeout hiển thị bubble tiếng Việt, fallback classifier cục bộ vẫn thử tạo câu trả lời.
- [x] Log chỉ chứa phase, model, độ dài prompt, loại task/lỗi; không ghi prompt, transcript, context, API key hoặc raw response.
- [x] Voice chỉ tự điều hướng sau TTS hoàn tất; TTS lỗi mới bật điều hướng thủ công an toàn.
- [x] `flutter analyze` phạm vi thay đổi, `flutter test --dart-define-from-file=.env`, và Android release build cùng `.env` đều pass.

## RESULT

- `DONE:` SQLCipher/session secure storage, read-only cache registry/snapshots, typed AI, Vietnamese voice UI/FAB, navigation allowlist, Chat realtime-to-local-cache, Gemini `.env` compile-time config, docs và kiểm tra tự động.
- `BLOCKED:` -
- `RISK:` Migration không tự xóa `auth.db` legacy; người dùng phải xác nhận riêng nếu muốn dọn dữ liệu cũ. SQLCipher/STT/TTS vẫn cần real-device release smoke testing với Gemini key hợp lệ.

## HANDOFF

- `NEXT:` Chạy smoke test SQLCipher/STT/TTS trên Android/iOS thật với microphone, voice `vi-VN` và Gemini key hợp lệ; xác nhận Supabase RLS/schema với môi trường production.
- `READ:` `lib/config/config_db.dart`
- `SKILL:` YES — mở rộng pattern SQLite local-first với owner-scoped encrypted store.
