/// ========================================
/// APP COMPONENTS - Central Component Library
/// ========================================
///
/// Unified export for all reusable UI components following the app's design system.
///
/// Usage:
/// ```dart
/// import 'package:aqedu/core/theme/app_components.dart';
///
/// // Use components
/// AppButton.primary(label: 'Submit', onPressed: () {})
/// AppText.sectionTitle('Section Title')
/// AppCard(child: Text('Content'))
/// AppContainer.infoBox(child: Text('Info'))
/// ```
///
/// Component categories:
/// - Design Tokens: Colors, Spacing, Shadows, Borders, Gradients
/// - Text & Typography: TextStyle definitions
/// - Animations: Transitions, durations, curves
/// - Buttons: Primary, secondary, outline, text, success, error
/// - Text Widgets: Semantic text components
/// - Containers: Boxes, status badges, dividers
/// - Cards: AppCard with variants
/// - Headers: Section headers
library;

// ========================================
// DESIGN TOKENS
// ========================================
export 'app_theme.dart';
export 'app_text_styles.dart';
export 'app_animations.dart';

// ========================================
// INTERACTIVE COMPONENTS
// ========================================
export 'app_buttons.dart';

// ========================================
// TEXT & TYPOGRAPHY
// ========================================
export 'app_text_widgets.dart';

// ========================================
// CONTAINERS & SPACING
// ========================================
export 'app_containers.dart';

// ========================================
// CARDS & SECTIONS
// ========================================


