import 'package:flutter/material.dart';

class OtherSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color mutedTextColor;

  const OtherSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.mutedTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xff111827),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: mutedTextColor,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
