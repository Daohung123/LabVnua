# LabVnua Theme System

Centralized design system for the LabVnua Student App. This folder contains all reusable UI components, design tokens, and theming utilities.

## 📁 Folder Structure

```
lib/core/theme/
├── app_theme.dart              # Design tokens (colors, spacing, shadows, borders)
├── app_text_styles.dart        # Typography system (text styles for all use cases)
├── app_animations.dart         # Animation utilities and transitions
├── app_buttons.dart            # Button components (primary, secondary, etc.)
├── app_text_widgets.dart       # Text components (AppText, AppRichText, AppBadge)
├── app_containers.dart         # Container components (boxes, badges, dividers)
├── app_card.dart               # Card component with variants
├── app_section_header.dart     # Section header component
├── app_components.dart         # Barrel export (import everything here)
├── COMPONENTS_GUIDE.md         # Complete usage guide
└── README.md                   # This file
```

## 🎨 Design System Hierarchy

```
app_theme.dart (Design Tokens)
    ↓
    ├── AppColors          (Color palette)
    ├── AppSpacing         (Spacing scale)
    ├── AppRadius          (Border radius)
    ├── AppShadows         (Elevation)
    ├── AppBorders         (Border styles)
    ├── AppGradients       (Gradient presets)
    └── AppOpacity         (Transparency values)

app_text_styles.dart (Typography)
    ↓
    ├── Display styles     (Hero titles, large headings)
    ├── Heading styles     (Section titles)
    ├── Body text styles   (Content, descriptions)
    ├── Label styles       (Buttons, chips)
    └── Special styles     (Links, disabled, etc.)

[Components built on top]
    ↓
    ├── app_buttons.dart
    ├── app_text_widgets.dart
    ├── app_containers.dart
    ├── app_card.dart
    └── app_section_header.dart
```

## 🚀 Quick Start

### Import Everything

```dart
import 'package:aqedu/core/theme/app_components.dart';
```

### Use Components

```dart
// Buttons
AppButton.primary(label: 'Submit', onPressed: () {})
AppButton.secondary(label: 'Cancel', onPressed: () {})

// Text
AppText.sectionTitle('Title')
AppText.bodyMedium('Body text')

// Containers
AppCard(child: Text('Content'))
AppContainer.infoBox(child: Text('Info'))

// Design tokens
backgroundColor: AppColors.primary,
padding: EdgeInsets.all(AppSpacing.lg),
```

## 📖 Component Categories

### 1. **Design Tokens** (`app_theme.dart`)

Core visual constants used across the entire app.

- **Colors**: Primary, secondary, semantic (success, error, warning), text colors
- **Spacing**: 4px to 32px scale (xs, sm, md, lg, xl, xxl)
- **Border Radius**: 8px to 26px + full circle
- **Shadows**: Light, medium, hero, elevated (for depth)
- **Gradients**: Hero gradient, subtle gradient, success gradient
- **Opacity**: Interactive states (hover, pressed, disabled)

**Never hardcode colors or spacing!**

```dart
// ✅ Good
backgroundColor: AppColors.primary
padding: AppSpacing.lg

// ❌ Bad
backgroundColor: Color(0xff0047A8)
padding: EdgeInsets.all(16)
```

### 2. **Typography** (`app_text_styles.dart`)

Complete text hierarchy for consistent typography.

- **Display**: Hero titles, large headings (24px, bold)
- **Headings**: Section titles, card titles (16-18px)
- **Body**: Paragraphs, content text (13-15px)
- **Labels**: Buttons, chips, tags (11-16px, bold)
- **Utilities**: Link text, disabled text, custom modifiers

### 3. **Animations** (`app_animations.dart`)

Reusable animation utilities for smooth transitions.

- **Durations**: ExtraShort (100ms) to ExtraLong (800ms)
- **Curves**: Ease, linear, elastic, springy
- **Presets**: Quick enter, standard transition, slow entrance
- **Page Routes**: Fade, slide, scale+fade transitions
- **Utilities**: Staggered list animations, animated buttons

### 4. **Buttons** (`app_buttons.dart`)

Semantic button components for every use case.

**Variants:**

- `AppButton.primary()` - Main action (blue)
- `AppButton.secondary()` - Alternative action (light)
- `AppButton.outline()` - Low emphasis (bordered)
- `AppButton.text()` - Minimal (text only)
- `AppButton.success()` - Positive action (green)
- `AppButton.error()` - Destructive action (red)
- `AppButton.small()` - Compact (for tight spaces)
- `AppButton.block()` - Full width action

**Icon Button:**

```dart
AppIconButton.filled(icon: Icons.edit, onPressed: () {})
AppIconButton.outlined(icon: Icons.delete, onPressed: () {})
```

**Chip Button:**

```dart
AppChip.filter(label: 'Active', onPressed: () {})
AppChip.input(label: 'Tag', onRemoved: () {})
```

### 5. **Text Widgets** (`app_text_widgets.dart`)

Semantic text components following the design system.

**Factories:**

- `AppText.heroTitle()` - Large prominent heading
- `AppText.sectionTitle()` - Section header
- `AppText.bodyLarge()`, `.bodyMedium()`, `.bodySmall()`
- `AppText.labelLarge()`, `.labelMedium()`, `.labelSmall()`
- `AppText.link()` - Clickable link
- `AppText.disabled()` - Disabled state
- `AppText.hint()` - Placeholder/hint text
- `AppText.cardValue()` - Large numbers/values

**Rich Text:**

```dart
AppRichText(spans: [
  AppTextSpan(text: 'Bold ', style: AppTextStyles.bodyLarge.copyWith(
    fontWeight: FontWeight.bold,
  )),
  AppTextSpan(text: 'normal', style: AppTextStyles.bodyLarge),
])
```

**Badges:**

```dart
AppBadgeText.success('Completed')
AppBadgeText.error('Failed')
AppBadgeText.warning('Pending')
AppBadgeText.info('New')
```

### 6. **Containers** (`app_containers.dart`)

Semantic container components for different content types.

**Variants:**

- `AppContainer.infoBox()` - Informational content
- `AppContainer.successBox()` - Success messages
- `AppContainer.errorBox()` - Error messages
- `AppContainer.warningBox()` - Warning messages
- `AppContainer.actionCard()` - Clickable cards
- `AppContainer.elevated()` - Prominent content
- `AppContainer.gradient()` - Gradient background
- `AppContainer.outlined()` - Border only
- `AppContainer.subtle()` - Minimal styling
- `AppContainer.transparent()` - No decoration

**Status Badge:**

```dart
AppStatusBadge.active('Online')
AppStatusBadge.inactive('Offline')
AppStatusBadge.pending('In Progress')
AppStatusBadge.error('Error')
```

**Divider:**

```dart
AppDivider()
AppDivider.subtle()
AppDivider.spaced(spacing: 16)
```

**Spacer:**

```dart
AppSpacer.xs()   // 4px
AppSpacer.md()   // 12px
AppSpacer.lg()   // 16px
```

### 7. **Cards** (`app_card.dart`)

Flexible card component with built-in styling and shadows.

**Variants:**

- `AppCard()` - Standard card
- `AppCard.hero()` - Featured/prominent card
- `AppCard.elevated()` - Strong shadow
- `AppCard.subtle()` - Minimal shadow
- `AppCard.success()` - Success state card
- `AppCard.error()` - Error state card

### 8. **Section Headers** (`app_section_header.dart`)

Consistent headers for content sections.

**Variants:**

- `AppSectionHeader()` - Basic header with optional subtitle
- `AppSectionHeader.compact()` - Compact spacing
- `AppSectionHeader.withAction()` - Header with action button
- `AppSectionHeader.colored()` - Custom title color

## 🎯 Best Practices

### ✅ DO

1. **Always use app_components** - Import everything from one place
2. **Use design tokens** - Never hardcode colors or spacing
3. **Use semantic components** - AppButton.error for destructive, AppButton.success for positive
4. **Compose components** - Combine small components into larger UI
5. **Keep consistent** - Use the same components across all screens

### ❌ DON'T

1. **Don't hardcode colors** - Use AppColors
2. **Don't hardcode spacing** - Use AppSpacing
3. **Don't use raw Text()** - Use AppText variants
4. **Don't create duplicate components** - Reuse existing ones
5. **Don't import individual files** - Use app_components.dart barrel export

## 🔄 Migration Guide

### From Old Widget System

| Old                  | New                           | Location                    |
| -------------------- | ----------------------------- | --------------------------- |
| `TextCommon`         | `AppText.sectionTitle()`      | theme/app_text_widgets.dart |
| `btnCommon()`        | `AppButton.primary()`         | theme/app_buttons.dart      |
| `ButtonImage`        | `AppButton.small()` with icon | theme/app_buttons.dart      |
| `ContainerMod1`      | `AppContainer.elevated()`     | theme/app_containers.dart   |
| Raw `Container`      | `AppCard` or `AppContainer`   | theme/app_containers.dart   |
| Raw `Text()`         | `AppText.*()`                 | theme/app_text_widgets.dart |
| Raw `ElevatedButton` | `AppButton.*()`               | theme/app_buttons.dart      |

## 📚 Documentation

- **Complete Guide**: See `COMPONENTS_GUIDE.md` for detailed usage examples
- **Theme Tokens**: See `app_theme.dart` for all available colors, spacing, etc.
- **Typography**: See `app_text_styles.dart` for text hierarchy
- **Real Examples**: Check feature screens in `lib/features/` for practical usage

## 🛠️ Adding New Components

When adding new UI components:

1. **Create in theme folder** (not widgets)
2. **Follow naming**: `App{ComponentName}`
3. **Use design tokens**: Colors, spacing from app_theme.dart
4. **Add factory constructors**: For common variants
5. **Export in app_components.dart**
6. **Document with examples**
7. **Update COMPONENTS_GUIDE.md**

## 📊 Design Token Summary

| Category       | Scale                   | Usage                           |
| -------------- | ----------------------- | ------------------------------- |
| **Colors**     | 20+ semantic colors     | Text, backgrounds, states       |
| **Spacing**    | 6 steps (4-32px)        | Padding, margins, gaps          |
| **Radius**     | 5 sizes (8-26px) + full | Cards, buttons, inputs          |
| **Shadows**    | 4 levels                | Elevation hierarchy             |
| **Typography** | 8+ text styles          | Text hierarchy                  |
| **Animations** | 5 durations + curves    | Transitions, micro-interactions |

---

**Last Updated**: 2025-05-08
