# Legacy Widgets

This folder contains legacy widget components. **Most components here are deprecated** in favor of the new theme-based system.

## ⚠️ Deprecation Notice

**Please use components from `lib/core/theme/app_components.dart` instead.**

The components in this folder are kept for backward compatibility only. New code should always use the centralized component system from the theme folder.

## 📦 Legacy Components

### AppBar Components

- **`UserAvatar`** (avt.dart) - Circular profile image with border
- **`UserGreeting`** (name_user.dart) - User greeting message
- **`QRScanButton`** (scan.dart) - QR code scan button
- **`NotificationButton`** (notification.dart) - Notification bell icon
- **`TimeFormat`** (time_fomat.dart) - Real-time clock display

### Button Components

- **`btnCommon()`** (btn_common.dart) - ⚠️ Deprecated function, use `AppButton.primary()`
- **`ButtonImage`** (btn_icon.dart) - ⚠️ Deprecated, use `AppButton` with icon

### Text Components

- **`TextCommon`** (Text/text_common.dart) - ⚠️ Deprecated, use `AppText.sectionTitle()`

### Container Components

- **`ContainerMod1`** (Container_mod/container_mod1.dart) - ⚠️ Deprecated, use `AppContainer.elevated()`
- **`IconContainer`** (Container_mod/container_icon.dart) - Icon inside container

### Modern Components (Already Refactored)

- **`AppCard`** (components/app_card.dart) - ✅ Reusable card component
- **`AppSectionHeader`** (components/app_section_header.dart) - ✅ Section header
- **`AIFabButton`** (fab/ai_fab_button.dart) - ✅ AI assistant FAB

## 🔄 Migration Path

### Before (Legacy)

```dart
import 'package:aqedu/core/widgets/Text/text_common.dart';
import 'package:aqedu/core/widgets/Button/btn_common.dart';

TextCommon(txt: 'Title')
btnCommon(
  text: 'Submit',
  width_text: 16,
  onPressed: () {},
  colors_background: Colors.blue,
  colors_text: Colors.white,
)
```

### After (Modern)

```dart
import 'package:aqedu/core/theme/app_components.dart';

AppText.sectionTitle('Title')
AppButton.primary(
  label: 'Submit',
  onPressed: () {},
)
```

## 📋 Components to Migrate

| Component     | File                              | Replacement        | Status     |
| ------------- | --------------------------------- | ------------------ | ---------- |
| TextCommon    | Text/text_common.dart             | AppText.\*         | Deprecated |
| btnCommon()   | Button/btn_common.dart            | AppButton.\*       | Deprecated |
| ButtonImage   | Button/btn_icon.dart              | AppButton.small()  | Deprecated |
| ContainerMod1 | Container_mod/container_mod1.dart | AppContainer.\*    | Deprecated |
| Avatar        | appBar/avt.dart                   | UserAvatar         | Legacy     |
| NameUser      | appBar/name_user.dart             | UserGreeting       | Legacy     |
| Scan          | appBar/scan.dart                  | QRScanButton       | Legacy     |
| Noti          | appBar/notification.dart          | NotificationButton | Legacy     |

## ✅ Already Refactored

These components have been cleaned up and follow best practices:

- ✅ `AppCard` - Modern, reusable card component
- ✅ `AppSectionHeader` - Standardized section headers
- ✅ `AIFabButton` - Professional FAB with animations
- ✅ `TimeFormat` - Real-time clock display with streaming

## 🚀 Migration Strategy

1. **Phase 1** - Identify all usages of legacy components

   ```bash
   # Find imports of legacy widgets
   grep -r "import.*widgets" lib/features/
   ```

2. **Phase 2** - Replace with modern components
   - `TextCommon` → `AppText.*`
   - `btnCommon()` → `AppButton.*`
   - `ContainerMod1` → `AppContainer.*`
   - Raw `Text()` → `AppText.*`
   - Raw `ElevatedButton` → `AppButton.*`

3. **Phase 3** - Remove legacy files (after full migration)

## 📚 Resources

- **Modern Components Guide**: `lib/core/theme/README.md`
- **Component Usage Guide**: `lib/core/theme/COMPONENTS_GUIDE.md`
- **Design System**: `lib/core/theme/app_theme.dart`

## ⚡ Quick Example

### Before (Legacy)

```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(14),
  ),
  child: TextCommon(txt: 'Title'),
)
```

### After (Modern)

```dart
AppCard(
  child: AppText.sectionTitle('Title'),
)
```

## 🎯 Next Steps

1. Import from `lib/core/theme/app_components.dart` in new features
2. Gradually migrate existing screens to use modern components
3. Remove deprecated components after migration is complete
4. Enjoy consistent, maintainable UI! ✨

---

**Note**: The legacy widgets folder will be deprecated in the next major version. Please prioritize migration to the modern component system.
