import 'package:flutter/material.dart';
import '../../theme/app_buttons.dart';

/// Deprecated: Use AppButton.primary() or AppButton variants instead
/// This function is kept for backward compatibility.
@Deprecated('Use AppButton.primary() or other AppButton factories instead')
Widget btnCommon({
  required String text,
  required double width_text,
  required VoidCallback onPressed,
  required Color colors_background,
  required Color colors_text,
}) {
  return AppButton(
    label: text,
    onPressed: onPressed,
    backgroundColor: colors_background,
    foregroundColor: colors_text,
    textStyle: TextStyle(color: colors_text, fontSize: width_text),
  );
}
