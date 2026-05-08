import 'package:flutter/material.dart';

class OtherQuickSummary extends StatelessWidget {
  final Color cardColor;
  final Color borderColor;
  final Color mutedTextColor;

  const OtherQuickSummary({
    super.key,
    required this.cardColor,
    required this.borderColor,
    required this.mutedTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SummaryCardOther(
            icon: Icons.apps_rounded,
            title: 'Tiện ích',
            value: '9',
            accentColor: const Color(0xff0EA5E9),
            cardColor: cardColor,
            borderColor: borderColor,
            mutedTextColor: mutedTextColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCardOther(
            icon: Icons.support_agent_rounded,
            title: 'Hỗ trợ',
            value: '6',
            accentColor: const Color(0xff10B981),
            cardColor: cardColor,
            borderColor: borderColor,
            mutedTextColor: mutedTextColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCardOther(
            icon: Icons.menu,
            title: 'Tổng',
            value: '15',
            accentColor: const Color(0xff8B5CF6),
            cardColor: cardColor,
            borderColor: borderColor,
            mutedTextColor: mutedTextColor,
          ),
        ),
      ],
    );
  }
}

class SummaryCardOther extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color accentColor;
  final Color cardColor;
  final Color borderColor;
  final Color mutedTextColor;

  const SummaryCardOther({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.accentColor,
    required this.cardColor,
    required this.borderColor,
    required this.mutedTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xff111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.5,
              color: mutedTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
