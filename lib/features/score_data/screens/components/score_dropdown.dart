import 'package:flutter/material.dart';
import '../../models/model_score_student.dart';
import '../../../../core/constants/UI/styles/colors.dart';

class ScoreDropdown extends StatelessWidget {
  final List<SemesterScore> semesters;
  final SemesterScore selectedSemester;
  final bool isOpen;
  final VoidCallback onTap;
  final Function(SemesterScore) onSelect;

  const ScoreDropdown({
    super.key,
    required this.semesters,
    required this.selectedSemester,
    required this.isOpen,
    required this.onTap,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.calendar_month, color: primaryColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedSemester.tenHocKy ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Column(
              children: semesters.map((semester) {
                return InkWell(
                  onTap: () => onSelect(semester),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month, color: primaryColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            semester.tenHocKy ?? "",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}