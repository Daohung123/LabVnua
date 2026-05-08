import 'package:flutter/material.dart';
import '../../theme/app_text_widgets.dart';

/// Deprecated: Use AppText.sectionTitle() or AppText.bodyLarge() instead
/// This widget is kept for backward compatibility but should not be used in new code
@Deprecated('Use AppText.sectionTitle() instead')
class TextCommon extends StatelessWidget {
  final String txt;

  const TextCommon({super.key, required this.txt});

  @override
  Widget build(BuildContext context) => AppText.sectionTitle(txt);
}
