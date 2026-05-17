import 'package:flutter/material.dart';
import '../controllers/ctrl_exam_schedule.dart';
import '../models/model_main_object.dart';
import '../models/model_semester.dart';
import '../widgets/exam_card.dart';

class ExamScheduleView extends StatefulWidget {
  const ExamScheduleView({super.key});

  @override
  State<ExamScheduleView> createState() => _ExamScheduleViewState();
}

class _ExamScheduleViewState extends State<ExamScheduleView> {
  List<SemesterModel> _semesters = [];
  SemesterModel? _selectedSemester;
  List<LichThi> _exams = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final semesters = await CtrlExamSchedule.getSemesters();
      if (semesters.isNotEmpty) {
        setState(() {
          _semesters = semesters;
          _selectedSemester = semesters.first;
        });
        await _loadExams();
      } else {
        setState(() => _errorMessage = "Không thể tải danh sách học kỳ.");
      }
    } catch (e) {
      setState(() => _errorMessage = "Lỗi khởi tạo: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadExams({bool forceRefresh = false}) async {
    if (_selectedSemester == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final exams = await CtrlExamSchedule.getExams(
        _selectedSemester!.hocKy, 
        forceRefresh: forceRefresh
      );
      
      setState(() {
        _exams = exams;
        if (exams.isEmpty) {
          _errorMessage = "Không có lịch thi hoặc lỗi đồng bộ.";
        }
      });
    } catch (e) {
      setState(() => _errorMessage = "Lỗi tải lịch thi: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F8FC),
      appBar: AppBar(
        title: const Text("Lịch thi trực tuyến", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xff0047A8),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _loadExams(forceRefresh: true),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_semesters.isNotEmpty) _buildSemesterSelector(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xff0047A8)))
                : _errorMessage != null && _exams.isEmpty
                    ? _buildErrorView()
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 20),
                        itemCount: _exams.length,
                        itemBuilder: (context, index) => ExamCard(exam: _exams[index]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline_rounded, size: 64, color: Colors.orangeAccent),
            const SizedBox(height: 20),
            Text(_errorMessage ?? "Lỗi không xác định", textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _initData, child: const Text("Thử lại")),
          ],
        ),
      ),
    );
  }

  Widget _buildSemesterSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Row(
        children: [
          const Text("Học kỳ:", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<SemesterModel>(
                isExpanded: true,
                value: _selectedSemester,
                items: _semesters.map((s) => DropdownMenuItem(value: s, child: Text(s.tenHocKy))).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedSemester = val);
                    _loadExams();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
