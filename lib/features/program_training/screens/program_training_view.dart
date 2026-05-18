import 'package:aqedu/core/constants/UI/styles/colors.dart';
import 'package:flutter/material.dart';

import '../controllers/ctrl_program_training.dart';
import '../models/model_program_data.dart';

class ProgramTrainingView extends StatefulWidget {
  const ProgramTrainingView({super.key});

  @override
  State<ProgramTrainingView> createState() => _ProgramTrainingViewState();
}

class _ProgramTrainingViewState extends State<ProgramTrainingView> {
  static const Color kPrimary = Color(0xFF0047A8);
  static const Color kPrimaryLight = Color(0xFFEAF2FF);
  static const Color kBackground = Color(0xFFF6F8FC);
  static const Color kTextPrimary = Color(0xFF122033);
  static const Color kTextSecondary = Color(0xFF667085);
  static const Color kBorder = Color(0xFFD9E2F2);

  bool isLoading = true;
  String? errorMessage;
  List<ProgramTrainingSemester> semesters = [];

  @override
  void initState() {
    super.initState();
    loadProgramTraining();
  }

  Future<void> loadProgramTraining() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final ctrl = await CtrlProgramTraining.create();
      final result = await ctrl.getProgramTraining();

      if (!mounted) return;
      setState(() {
        semesters = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = "Không thể tải chương trình đào tạo.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = _buildYearSections(semesters);
    final totalSubjects = sections.fold<int>(
      0,
      (sum, section) => sum + section.entries.length,
    );

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: primaryColor,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        title: const Text(
          "Chương trình đào tạo",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: kPrimary))
            : errorMessage != null
                ? _ErrorState(
                    message: errorMessage!,
                    onRetry: loadProgramTraining,
                  )
                : semesters.isEmpty
                    ? const _EmptyState()
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final isDesktop = constraints.maxWidth >= 1100;
                          final isTablet = constraints.maxWidth >= 700;

                          final horizontalPadding = isDesktop
                              ? 32.0
                              : isTablet
                                  ? 20.0
                                  : 16.0;

                          return Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1400),
                              child: ListView(
                                padding: EdgeInsets.fromLTRB(
                                  horizontalPadding,
                                  16,
                                  horizontalPadding,
                                  24,
                                ),
                                children: [
                                  _HeaderCard(
                                    semesterCount: semesters.length,
                                    yearCount: sections.length,
                                    subjectCount: totalSubjects,
                                  ),
                                  const SizedBox(height: 16),
                                  ...sections.map((section) {
                                    return _YearSectionCard(
                                      section: section,
                                      primary: kPrimary,
                                      border: kBorder,
                                      textPrimary: kTextPrimary,
                                      textSecondary: kTextSecondary,
                                      primaryLight: kPrimaryLight,
                                    );
                                  }),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }

  List<_YearSection> _buildYearSections(List<ProgramTrainingSemester> data) {
    if (data.isEmpty) return [];

    final result = <_YearSection>[];

    for (int i = 0; i < data.length; i += 2) {
      final group = data.skip(i).take(2).toList();
      final yearIndex = (i ~/ 2) + 1;

      final entries = <_ProgramSubjectEntry>[];

      for (final semester in group) {
        final semesterLabel = _semesterLabel(semester, fallbackIndex: i + 1);

        final subjects = semester.dsCtdtMonHoc ?? [];
        for (final subject in subjects) {
          entries.add(
            _ProgramSubjectEntry(
              semesterLabel: semesterLabel,
              subject: subject,
            ),
          );
        }
      }

      result.add(
        _YearSection(
          yearTitle: "Năm học $yearIndex",
          yearSubtitle: group.isNotEmpty
              ? group.map((e) => _semesterLabel(e)).join(" • ")
              : "",
          entries: entries,
        ),
      );
    }

    return result;
  }

  String _semesterLabel(ProgramTrainingSemester semester, {int? fallbackIndex}) {
    final name = semester.tenHocKy?.trim();
    if (name != null && name.isNotEmpty) return name;

    final code = semester.hocKy?.trim();
    if (code != null && code.isNotEmpty) return "Học kỳ $code";

    if (fallbackIndex != null) return "Học kỳ $fallbackIndex";
    return "Học kỳ";
  }
}

class _YearSection {
  final String yearTitle;
  final String yearSubtitle;
  final List<_ProgramSubjectEntry> entries;

  const _YearSection({
    required this.yearTitle,
    required this.yearSubtitle,
    required this.entries,
  });
}

class _ProgramSubjectEntry {
  final String semesterLabel;
  final ProgramTrainingSubject subject;

  const _ProgramSubjectEntry({
    required this.semesterLabel,
    required this.subject,
  });
}

class _HeaderCard extends StatelessWidget {
  static const Color kPrimary = Color(0xFF0047A8);
  static const Color kPrimaryLight = Color(0xFFEAF2FF);
  static const Color kTextPrimary = Color(0xFF122033);
  static const Color kTextSecondary = Color(0xFF667085);

  final int semesterCount;
  final int yearCount;
  final int subjectCount;

  const _HeaderCard({
    required this.semesterCount,
    required this.yearCount,
    required this.subjectCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0047A8), Color(0xFF0B63E6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 800;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.18),
                      ),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Chương trình đào tạo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Hiển thị đầy đủ nội dung theo từng năm học, tối ưu cho mobile, tablet và desktop.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13.5,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatChip(
                    label: "Học kỳ",
                    value: semesterCount.toString(),
                  ),
                  _StatChip(
                    label: "Năm học",
                    value: yearCount.toString(),
                  ),
                  _StatChip(
                    label: "Môn học",
                    value: subjectCount.toString(),
                  ),
                ],
              ),
              if (isWide) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  child: const Text(
                    "Mỗi năm học được trình bày thành một section rõ ràng. Môn học hiển thị dưới dạng thẻ trực quan, dễ đọc, không ẩn bớt thông tin.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _YearSectionCard extends StatelessWidget {
  const _YearSectionCard({
    required this.section,
    required this.primary,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.primaryLight,
  });

  final _YearSection section;
  final Color primary;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color primaryLight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A1A).withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth;
          final subjectCardWidth = cardWidth >= 1200
              ? (cardWidth - 32) / 3
              : cardWidth >= 700
                  ? (cardWidth - 12) / 2
                  : cardWidth;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: primaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      color: primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.yearTitle,
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          section.yearSubtitle.isNotEmpty
                              ? section.yearSubtitle
                              : "Danh sách môn học được hiển thị đầy đủ bên dưới.",
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 13.5,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (section.entries.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFD),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE9EEF7)),
                  ),
                  child: Text(
                    "Chưa có dữ liệu môn học cho ${section.yearTitle.toLowerCase()}.",
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 13.5,
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: section.entries.map((entry) {
                    return SizedBox(
                      width: subjectCardWidth,
                      child: _SubjectCard(
                        entry: entry,
                        primary: primary,
                        border: border,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        primaryLight: primaryLight,
                      ),
                    );
                  }).toList(),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({
    required this.entry,
    required this.primary,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.primaryLight,
  });

  final _ProgramSubjectEntry entry;
  final Color primary;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color primaryLight;

  @override
  Widget build(BuildContext context) {
    final subject = entry.subject;
    final isCompulsory = subject.monBatBuoc == "x";
    final isLearned = subject.monDaHoc == "x";
    final isPassed = subject.monDaDat == "x";
    final componentLessons = subject.dsTietThanhPhan ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFCFE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.tenMon ?? "Không rõ tên môn",
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if ((subject.tenMonEg ?? "").trim().isNotEmpty)
                      Text(
                        subject.tenMonEg!,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 12.5,
                          height: 1.35,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _SmallTag(
                text: entry.semesterLabel,
                background: primaryLight,
                textColor: primary,
              ),
            ],
          ),
          const SizedBox(height: 14),
          _InfoGrid(
            items: [
              _InfoItem("Mã môn", subject.maMon),
              _InfoItem("Số tín chỉ", subject.soTinChi),
              _InfoItem("Lý thuyết", subject.lyThuyet),
              _InfoItem("Thực hành", subject.thucHanh),
              _InfoItem("Tổng tiết", subject.tongTiet),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusChip(
                label: "Bắt buộc",
                active: isCompulsory,
              ),
              _StatusChip(
                label: "Đã học",
                active: isLearned,
              ),
              _StatusChip(
                label: "Đã đạt",
                active: isPassed,
              ),
            ],
          ),
          if (componentLessons.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8EEF7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tiết thành phần",
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...componentLessons.map((e) {
                    final name = (e.tenThanhPhan ?? "").trim();
                    final lessonCount = (e.soTiet ?? "").trim();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "• ",
                            style: TextStyle(fontSize: 13.5),
                          ),
                          Expanded(
                            child: Text(
                              name.isEmpty
                                  ? "Không rõ"
                                  : "$name: ${lessonCount.isEmpty ? "—" : "$lessonCount tiết"}",
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 13.2,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.items});

  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 520;
        final width = isWide ? (constraints.maxWidth - 12) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: 12,
          runSpacing: 8,
          children: items.where((e) => e.hasValue).map((item) {
            return SizedBox(
              width: width,
              child: _InfoRow(item: item),
            );
          }).toList(),
        );
      },
    );
  }
}

class _InfoItem {
  final String label;
  final String? value;

  const _InfoItem(this.label, this.value);

  bool get hasValue => value != null && value!.trim().isNotEmpty;
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.item});

  final _InfoItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            item.label,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF667085),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            item.value ?? "",
            style: const TextStyle(
              fontSize: 12.8,
              color: Color(0xFF122033),
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.active,
  });

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFEAF2FF) : const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active ? const Color(0xFFB7D2FF) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: active ? const Color(0xFF0047A8) : const Color(0xFF667085),
        ),
      ),
    );
  }
}

class _SmallTag extends StatelessWidget {
  const _SmallTag({
    required this.text,
    required this.background,
    required this.textColor,
  });

  final String text;
  final Color background;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.menu_book_rounded, size: 54, color: Color(0xFF98A2B3)),
            SizedBox(height: 12),
            Text(
              "Không có dữ liệu chương trình đào tạo",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF122033),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6),
            Text(
              "Vui lòng kiểm tra lại nguồn dữ liệu hoặc kết nối mạng.",
              style: TextStyle(
                fontSize: 13.5,
                color: Color(0xFF667085),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 54, color: Color(0xFFD92D20)),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF122033),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Hãy thử tải lại để tiếp tục xem chương trình đào tạo.",
              style: TextStyle(
                fontSize: 13.5,
                color: Color(0xFF667085),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0047A8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Tải lại"),
            ),
          ],
        ),
      ),
    );
  }
}