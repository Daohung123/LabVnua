import 'package:flutter/material.dart';

/// Data model cho shortcut tiles
/// Tránh passing nhiều positional arguments và dễ đọc
class ShortcutData {
  const ShortcutData(this.icon, this.label, this.color, this.page);
  final IconData icon;
  final String label;
  final Color color;
  final Object page;
}
