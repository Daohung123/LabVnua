# CODING — Full UI Design System Refactor

- `TYPE:` CODING
- `SCOPE:` ALL_UI
- `PATTERN:` design-system-full-refactor
- `STATUS:` IMPLEMENTED_STATIC_VERIFIED_RUNTIME_NOT_RUN
- `SOURCE:` `DESIGN.md`

## Acceptance Criteria

- [x] Chốt một màu chính và phong cách thống nhất toàn dự án.
- [x] Hợp nhất color, spacing, radius, shadow, typography và motion tokens.
- [x] Cấu hình `ThemeData` toàn cục cho MaterialApp.
- [x] Refactor và audit toàn bộ phạm vi file UI sang token dùng chung.
- [x] Loại bỏ palette cục bộ và màu hard-code khỏi lớp UI.
- [x] Chuẩn hóa component dùng chung và trạng thái loading/empty/error.
- [x] Kiểm tra cú pháp và tính nhất quán tĩnh bằng công cụ khả dụng.
- [ ] Chạy `flutter analyze` — `NOT RUN`, môi trường không có Flutter SDK.
- [ ] Chạy `flutter test` — `NOT RUN`, môi trường không có Flutter SDK.
- [x] Đóng gói mã nguồn đã chỉnh sửa.

## Decisions

- Primary: `#0A84FF`.
- Primary pressed: `#0066CC`.
- Background: `#F5F7FA`.
- Surface: `#FFFFFF`.
- Primary text: `#111827`.
- Visual style: simple, calm, iOS-inspired, Material 3 compatible.
- Business logic, API, routing, repositories and persistence contracts remain unchanged.

## Verification Constraint

`flutter` and `dart` executables are not installed in the execution environment. Runtime analyzer and test status must therefore remain `NOT RUN` unless a local SDK becomes available.
