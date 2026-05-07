import 'package:flutter/material.dart';
import '../ctrls/ctrls_inforStudent.dart';
import '../screens/components/profile_card.dart';
import '../screens/components/student_info_card.dart';
import '../../../core/constants/UI/styles/colors.dart';

class InforStudentView extends StatefulWidget {
  const InforStudentView({super.key});

  @override
  State<InforStudentView> createState() => _InforStudentViewState();
}

class _InforStudentViewState extends State<InforStudentView> {
  final StudentController controller = StudentController();

  dynamic student;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final result = await controller.getProfile();

    setState(() {
      student = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: bg_color,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          "Thông tin cá nhân",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              ProfileCard(student: student),
              const SizedBox(height: 16),
              StudentInfoCard(student: student),
            ],
          ),
        ),
      ),
    );
  }
}