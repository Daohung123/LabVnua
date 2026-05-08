import 'package:flutter/material.dart';
import '../../theme/app_text_widgets.dart';

/// User Greeting - Personalized greeting message with emoji
class UserGreeting extends StatelessWidget {
  final String firstName;
  final String middleName;
  final String lastName;
  final bool showEmoji;
  final TextStyle? textStyle;

  const UserGreeting({
    super.key,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    this.showEmoji = true,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final name = '$lastName $middleName $firstName'.trim();
    final greeting = showEmoji ? 'Hi, $name 👋' : 'Hi, $name';

    return AppText.heroSubtitle(greeting, color: Colors.white);
  }
}
