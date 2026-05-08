# LabVnua Component Library Guide

## Overview

The LabVnua app uses a centralized component system for consistent, reusable UI across all screens. All components follow the design system defined in `lib/core/theme/`.

## Quick Start

```dart
import 'package:aqedu/core/theme/app_components.dart';

// Use any component
AppButton.primary(label: 'Click me', onPressed: () {})
AppText.sectionTitle('My Section')
AppCard(child: Text('Content'))
```

---

## Component Categories

### 1. Design Tokens (Colors, Spacing, Typography)

**File:** `app_theme.dart`, `app_text_styles.dart`, `app_animations.dart`

Define all visual constants in one place. Never hardcode colors or spacing.

```dart
// ✅ Good - Use theme tokens
backgroundColor: AppColors.primary,
padding: EdgeInsets.all(AppSpacing.lg),

// ❌ Bad - Never hardcode
backgroundColor: Color(0xff0047A8),
padding: EdgeInsets.all(16),
```

#### Colors

```dart
AppColors.primary          // Main brand color
AppColors.success          // Success/positive
AppColors.error            // Error/negative
AppColors.warning          // Warning
AppColors.textPrimary      // Main text
AppColors.surface          // Card/container background
```

#### Spacing

```dart
AppSpacing.xs   // 4px
AppSpacing.sm   // 8px
AppSpacing.md   // 12px
AppSpacing.lg   // 16px
AppSpacing.xl   // 24px
AppSpacing.xxl  // 32px
```

#### Border Radius

```dart
AppRadius.sm    // 8px
AppRadius.md    // 14px
AppRadius.lg    // 18px
AppRadius.xl    // 22px
AppRadius.full  // 999px
```

---

### 2. Buttons (`app_buttons.dart`)

Semantic button components for different use cases.

#### Primary Button (Main action)

```dart
AppButton.primary(
  label: 'Submit',
  onPressed: () => _handleSubmit(),
  icon: Icons.check,
)
```

#### Secondary Button (Alternative action)

```dart
AppButton.secondary(
  label: 'Cancel',
  onPressed: () => Navigator.pop(context),
)
```

#### Outline Button (Low emphasis)

```dart
AppButton.outline(
  label: 'Learn More',
  onPressed: () => _navigateToLearn(),
)
```

#### Text Button (Minimal)

```dart
AppButton.text(
  label: 'Skip',
  onPressed: () {},
)
```

#### Success Button

```dart
AppButton.success(
  label: 'Confirm',
  onPressed: () => _confirm(),
)
```

#### Error Button (Destructive)

```dart
AppButton.error(
  label: 'Delete',
  onPressed: () => _delete(),
)
```

#### Block Button (Full width)

```dart
AppButton.block(
  label: 'Continue',
  onPressed: () {},
)
```

#### Small Button (Compact)

```dart
AppButton.small(
  label: 'Add',
  onPressed: () {},
)
```

#### Icon Button

```dart
AppIconButton.filled(
  icon: Icons.edit,
  onPressed: () => _edit(),
)

AppIconButton.outlined(
  icon: Icons.delete,
  onPressed: () => _delete(),
)
```

---

### 3. Text & Typography (`app_text_widgets.dart`)

Semantic text components following the design system.

#### Hero Title (Large, 24px, bold)

```dart
AppText.heroTitle('Welcome back!')
```

#### Section Title (18px, bold)

```dart
AppText.sectionTitle('Your Schedule')
```

#### Body Text

```dart
AppText.bodyLarge('Main paragraph text')
AppText.bodyMedium('Standard text')
AppText.bodySmall('Small descriptive text')
```

#### Labels

```dart
AppText.labelLarge('Primary Label')
AppText.labelMedium('Standard Label')
AppText.labelSmall('Small Label')
```

#### Special Styles

```dart
AppText.link('Tap here')
AppText.disabled('Not available')
AppText.hint('Enter your name')
AppText.cardValue('9.5')  // For large numbers
```

#### Rich Text

```dart
AppRichText(
  spans: [
    AppTextSpan(text: 'Hello ', style: AppTextStyles.bodyLarge),
    AppTextSpan(
      text: 'world',
      style: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
)
```

#### Badges

```dart
AppBadgeText.success('Completed')
AppBadgeText.error('Failed')
AppBadgeText.warning('Pending')
AppBadgeText.info('New')
```

---

### 4. Containers & Boxes (`app_containers.dart`)

Semantic container components for different content types.

#### Info Box (Informational)

```dart
AppContainer.infoBox(
  child: Text('Important information'),
)
```

#### Success Box

```dart
AppContainer.successBox(
  child: Text('Operation successful'),
)
```

#### Error Box

```dart
AppContainer.errorBox(
  child: Text('Something went wrong'),
)
```

#### Warning Box

```dart
AppContainer.warningBox(
  child: Text('Please be careful'),
)
```

#### Action Card (Clickable)

```dart
AppContainer.actionCard(
  child: Text('Tap me'),
  onTap: () => _handleTap(),
)
```

#### Gradient Container

```dart
AppContainer.gradient(
  child: Text('Gradient background'),
  gradient: AppGradients.heroGradient,
)
```

#### Elevated Container (Strong shadow)

```dart
AppContainer.elevated(
  child: Text('Prominent content'),
)
```

#### Outlined Container (Border only)

```dart
AppContainer.outlined(
  child: Text('Bordered'),
  borderColor: AppColors.primary,
)
```

#### Status Badge

```dart
AppStatusBadge.active('Online')
AppStatusBadge.inactive('Offline')
AppStatusBadge.pending('In Progress')
AppStatusBadge.error('Error')
```

#### Divider

```dart
AppDivider()
AppDivider.subtle()
AppDivider.spaced(spacing: 16)
```

#### Spacer

```dart
AppSpacer.xs()   // 4px
AppSpacer.md()   // 12px
AppSpacer.lg()   // 16px
```

---

### 5. Cards (`app_card.dart`)

Flexible card component with built-in styling.

#### Basic Card

```dart
AppCard(
  child: Column(
    children: [
      Text('Card Title'),
      Text('Card content'),
    ],
  ),
)
```

#### Hero Card (Prominent)

```dart
AppCard.hero(
  child: Text('Featured content'),
  onTap: () => _navigate(),
)
```

#### Elevated Card (Strong shadow)

```dart
AppCard.elevated(
  child: Text('Important content'),
)
```

#### Subtle Card (Minimal)

```dart
AppCard.subtle(
  child: Text('Subtle card'),
)
```

#### Success Card

```dart
AppCard.success(
  child: Text('Success message'),
)
```

#### Error Card

```dart
AppCard.error(
  child: Text('Error message'),
)
```

---

### 6. Section Headers (`app_section_header.dart`)

Consistent headers for content sections.

#### Basic Header

```dart
AppSectionHeader(
  title: 'Today\'s Schedule',
  subtitle: 'Check your classes',
)
```

#### Header with Action

```dart
AppSectionHeader.withAction(
  title: 'Recent',
  subtitle: 'Your recent activities',
  actionText: 'View All',
  onAction: () => _viewAll(),
)
```

#### Compact Header

```dart
AppSectionHeader.compact(
  title: 'Settings',
  subtitle: 'Preferences',
)
```

#### Colored Header

```dart
AppSectionHeader.colored(
  title: 'Completed',
  titleColor: AppColors.success,
  subtitle: 'Well done!',
)
```

---

## Best Practices

### ✅ DO

1. **Use theme components** - Always prefer AppButton, AppText, etc.
2. **Use design tokens** - Never hardcode colors or spacing
3. **Import from app_components** - Single import for everything
4. **Use semantic variants** - AppButton.error for destructive, AppButton.success for positive
5. **Keep components composable** - Combine small components into larger ones

```dart
// ✅ Good composition
AppCard(
  child: Column(
    children: [
      AppSectionHeader(title: 'Profile'),
      AppText.bodyMedium('User info'),
      Row(
        children: [
          AppButton.primary(label: 'Edit', onPressed: () {}),
          AppButton.secondary(label: 'Cancel', onPressed: () {}),
        ],
      ),
    ],
  ),
)
```

### ❌ DON'T

1. **Don't hardcode colors** - Use AppColors
2. **Don't hardcode spacing** - Use AppSpacing
3. **Don't use raw Text()** - Use AppText variants
4. **Don't import individual files** - Use app_components.dart
5. **Don't create duplicate components** - Reuse existing ones

```dart
// ❌ Bad - Hardcoded styling
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Color(0xff0047A8),
    borderRadius: BorderRadius.circular(14),
  ),
  child: Text('Submit', style: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  )),
)

// ✅ Good - Use components
AppButton.primary(
  label: 'Submit',
  onPressed: () {},
)
```

---

## Migration from Old Components

### Old → New

| Old Component   | New Component                 | Notes               |
| --------------- | ----------------------------- | ------------------- |
| `TextCommon`    | `AppText.sectionTitle()`      | Deprecated          |
| `btnCommon()`   | `AppButton.primary()`         | Deprecated          |
| `ButtonImage`   | `AppButton.small()` with icon | Deprecated          |
| `ContainerMod1` | `AppContainer.elevated()`     | Deprecated          |
| `Avatar`        | `UserAvatar`                  | Renamed for clarity |
| `Scan`          | `QRScanButton`                | Renamed for clarity |
| `Noti`          | `NotificationButton`          | Renamed for clarity |

---

## Customization

All components support customization while maintaining consistency:

```dart
AppButton.primary(
  label: 'Custom Button',
  onPressed: () {},
  backgroundColor: AppColors.tuitionColor,  // Feature-specific color
  width: double.infinity,                   // Custom width
  padding: EdgeInsets.symmetric(
    horizontal: AppSpacing.xl,
    vertical: AppSpacing.lg,
  ),
)

AppText.sectionTitle(
  'Custom Title',
  color: AppColors.scheduleColor,          // Feature-specific color
  maxLines: 1,
)

AppCard(
  padding: AppSpacing.xl,
  borderRadius: AppRadius.lg,
  backgroundColor: AppColors.background,
)
```

---

## Adding New Components

When adding new components:

1. **Create in theme folder** - Not widgets folder
2. **Follow naming** - `App{ComponentName}`
3. **Use design tokens** - Colors, spacing, radius from app_theme.dart
4. **Add factory constructors** - For common variants
5. **Export in app_components.dart**
6. **Add documentation** - Clear usage examples

Example:

```dart
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int maxLines;
  final bool obscureText;
  final String? errorText;

  const AppTextField({
    Key? key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.obscureText = false,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implementation using AppColors, AppSpacing, etc.
  }

  /// Email input field
  factory AppTextField.email({
    required TextEditingController controller,
  }) => AppTextField(
    label: 'Email',
    hint: 'your@email.com',
    controller: controller,
    keyboardType: TextInputType.emailAddress,
  );
}
```

---

## Resources

- **Colors**: `lib/core/theme/app_theme.dart` - AppColors class
- **Typography**: `lib/core/theme/app_text_styles.dart` - AppTextStyles class
- **Spacing**: `lib/core/theme/app_theme.dart` - AppSpacing class
- **Animations**: `lib/core/theme/app_animations.dart` - Animation utilities
- **Components**: `lib/core/theme/` - All component files

---

## Questions?

Refer to existing components and screens for usage examples.
