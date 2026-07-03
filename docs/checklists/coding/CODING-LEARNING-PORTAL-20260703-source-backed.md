# CODING Learning Portal Source-Backed Checklist

- `STATUS:` DONE
- `TYPE:` CODING
- `SCOPE:` LEARNING_PORTAL
- `PATTERN:` catalog-driven-local-ui
- `DATE:` 2026-07-03

## Source Inputs

- `.agent/tasks/coding/workflow.md`
- `.agent/tasks/coding/rules.md`
- `docs/checklists/checklist_features.md`
- Existing `HocTapView` navigation targets.

## Changes

- [x] Refactored `HocTapView` into a catalog-driven portal.
- [x] Added search/filter behavior, grouped function sections, item count/stat summary, loading-free empty state, and preserved Vietnamese copy.
- [x] Preserved existing navigation targets for training program, prerequisites, scores, student info, schedule, course registration, tuition, and score analysis.
- [x] Added local Todo as a learning portal entry without adding backend assumptions.
- [x] Kept official deadline, course material, and completion/failure metrics as source gaps.

## Verification

- [x] `flutter test test\source_backed_remaining_test.dart test\home_dd_home_test.dart`
- [x] `flutter test`
- [x] Scoped `flutter analyze` on touched source/test files passed.
- [x] Full `flutter analyze` still fails on existing repo-wide lint debt unrelated to this slice.

## Open Questions

- `OPEN_QUESTION:` Official course material/deadline source and metric rules are not available.
