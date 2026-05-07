import 'package:flutter/material.dart';
import 'score_subject_item.dart';

class ScoreSubjectCard extends StatelessWidget {
  final List<dynamic> subjects;

  const ScoreSubjectCard({
    super.key,
    required this.subjects,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: subjects.map((subject) {
          return ScoreSubjectItem(subject: subject);
        }).toList(),
      ),
    );
  }
}