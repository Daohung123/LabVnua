import 'package:flutter/material.dart';
import '../controllers/ctrl_score_student.dart';
import '../models/model_score_student.dart';
import 'components/score_dropdown.dart';
import 'components/score_subject_card.dart';
import 'components/score_total.dart';
import '../../../core/constants/UI/styles/colors.dart';

class ScoreView extends StatefulWidget {
  const ScoreView({super.key});

  @override
  State<ScoreView> createState() => _ScoreViewState();
}

class _ScoreViewState extends State<ScoreView> {
  final ScoreController controller = ScoreController();

  ScoreData? scoreData;
  SemesterScore? selectedSemester;

  bool isLoading = true;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final result = await controller.getScore();

    setState(() {
      scoreData = result;
      selectedSemester = result.dsDiemHocky?.first;
      isLoading = false;
    });
  }

  void changeSemester(SemesterScore semester) {
    setState(() {
      selectedSemester = semester;
      isOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || scoreData == null || selectedSemester == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: bg_color,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
        ),
        title: const Text(
          "Xem điểm",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScoreDropdown(
                semesters: scoreData!.dsDiemHocky ?? [],
                selectedSemester: selectedSemester!,
                isOpen: isOpen,
                onTap: () {
                  setState(() {
                    isOpen = !isOpen;
                  });
                },
                onSelect: changeSemester,
              ),

              const SizedBox(height: 22),

              Text(
                "Điểm tổng kết",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              ScoreTotalCard(
                semester: selectedSemester!,
              ),

              const SizedBox(height: 22),

              Text(
                "Chi tiết môn",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              ScoreSubjectCard(
                subjects: selectedSemester!.dsDiemMonHoc ?? [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}