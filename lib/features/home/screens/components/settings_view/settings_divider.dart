import 'package:flutter/material.dart';

class SettingsCustomDivider extends StatelessWidget {
  final Color borderColor;

  const SettingsCustomDivider({super.key, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Divider(height: 1, thickness: 1, color: borderColor),
    );
  }
}
