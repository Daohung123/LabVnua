# Coding Design Guidance

## Verified Product/UI Conventions
| Convention | Source |
|---|---|
| Main brand colors use blue variants such as `AppColors.primary`. | `lib/core/theme/app_theme.dart` |
| Shared spacing, radius, shadow, border, and gradient tokens live in `AppSpacing`, `AppRadius`, `AppShadows`, `AppBorders`, and `AppGradients`. | `lib/core/theme/app_theme.dart` |
| Theme components include buttons, text widgets, containers, cards, section headers, animations, and app components barrel export. | `lib/core/theme/README.md` |
| Legacy widgets should be migrated gradually to the theme component system. | `lib/core/widgets/README.md` |
| User-facing copy is largely Vietnamese in current screens. | `lib/features/auth/student/screens/role_view.dart`, `lib/features/home/study_view/screens/study_view.dart` |
| Home shell supports mobile bottom navigation and a wide-layout desktop side rail. | `lib/features/home/home_screen/screens/student_home_screen_view.dart` |

## Recommendations
- Preserve existing Vietnamese user-facing text unless the task explicitly changes copy or localization.
- Prefer existing `AppColors`, `AppSpacing`, and component factories over hard-coded UI values in new code.
- If touching an older screen that hard-codes styles, keep refactors scoped to the requested behavior unless the checklist explicitly includes design cleanup.
- For placeholder actions, use an approved product decision before wiring or hiding visible menu entries.

## OPEN_QUESTION
- `OPEN_QUESTION-DESIGN-01:` No accessibility standard, localization policy, or formal design system approval source exists beyond in-repo theme documentation.
