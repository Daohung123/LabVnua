# WL-20260724-01 - Full UI Design System Refactor

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` ALL_UI
- `PATTERN:` design-system-full-refactor
- `TAGS:` flutter, ui, design-system, material3, ios-inspired
- `REF:` `docs/checklists/coding/CODING-UI-DESIGN-SYSTEM-20260724.md`

## CURRENT
- Refactored the complete Flutter presentation layer against the project-level `DESIGN.md`, with one global palette and consistent components while preserving existing business behavior.

## CHANGED
- `lib/core/theme/` — rebuilt color, typography, spacing, radius, shadow, motion, ThemeData and shared state/component definitions.
- `lib/main.dart` — applied the global application theme and fixed Light Mode for consistent rendering.
- `lib/features/auth/student/screens/student_login_view.dart` — replaced the decorative login implementation with a focused responsive form while preserving the DD_AUTH test contract.
- `lib/core/screens/` — standardized loading, offline and developing states.
- `lib/features/**/screens`, `lib/features/**/widgets`, `lib/core/widgets/` — migrated feature UI to shared tokens and reduced local gradients, palette aliases and excessive elevation.
- Native/in-app notification accents now map to the same application color tokens.
- `docs/reports/UI_REFACTOR_REPORT_20260724.md` — recorded scope, decisions, verification and release checks.

## NOTE
- Primary color is fixed at `#0A84FF`; background is `#F5F7FA`; surface is white; primary text is `#111827`.
- Automatic Dark Mode is disabled until all feature screens are fully dark-compatible.
- No intentional business logic, API, routing, state-management or persistence contract change was made.
- Static verification passed across 249 Dart files.
- `flutter analyze` and `flutter test` were not run because Flutter/Dart executables are unavailable in the execution environment.

## TASK SPLIT
- `[x]` Read `AGENTS.md`, coding workflow, design rules and relevant worklogs.
- `[x]` Audit the full presentation layer and identify duplicate/local palettes.
- `[x]` Build one global design system from `DESIGN.md`.
- `[x]` Apply ThemeData at the application root.
- `[x]` Refactor feature UI and shared widgets to common tokens.
- `[x]` Simplify major decorative screens and preserve business behavior.
- `[x]` Run source-level static verification and record the Flutter SDK limitation.
- `[x]` Update checklist, report, worklog and skill counter.
- `[x]` Package the refactored source for handoff.

## NEXT
1. Run `flutter pub get`, `flutter analyze` and `flutter test` on a machine with the matching Flutter SDK.
2. Perform device smoke testing for authentication, Home, Schedule, Score, Tuition, Notifications, Chat and QR.
3. Enable system Dark Mode only after a dedicated dark-theme pass across all feature screens.
