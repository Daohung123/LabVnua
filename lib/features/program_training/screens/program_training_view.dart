
import 'package:aqedu/core/theme/app_animations.dart';
import 'package:aqedu/core/theme/app_buttons.dart';
import 'package:aqedu/core/theme/app_containers.dart';
import 'package:aqedu/core/theme/app_text_widgets.dart';
import 'package:aqedu/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../controllers/ctrl_program_training.dart';
import '../models/model_program_data.dart';

class ProgramTrainingView extends StatefulWidget {
  const ProgramTrainingView({super.key});

  @override
  State<ProgramTrainingView> createState() => _ProgramTrainingViewState();
}

class _ProgramTrainingViewState extends State<ProgramTrainingView> {
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
    } catch (_) {
      if (!mounted) return;

      setState(() {
        errorMessage = "Không thể tải chương trình đào tạo";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = _buildYearSections();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: AppText.labelLarge(
          "Chương trình đào tạo",
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              )
            : errorMessage != null
                ? _ErrorView(
                    message: errorMessage!,
                    onRetry: loadProgramTraining,
                  )
                : ListView(
                    padding: AppSpacing.screenPadding,
                    children: [
                      _HeaderCard(
                        totalYear: sections.length,
                        totalSemester: semesters.length,
                        totalSubject: sections.fold(
                          0,
                          (p, e) => p + e.entries.length,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...sections.map(
                        (e) => _YearCard(section: e),
                      ),
                    ],
                  ),
      ),
    );
  }

  List<_YearSection> _buildYearSections() {
    final result = <_YearSection>[];

    for (int i = 0; i < semesters.length; i += 2) {
      final group = semesters.skip(i).take(2).toList();

      final entries = <_ProgramSubjectEntry>[];

      for (final semester in group) {
        final subjects = semester.dsCtdtMonHoc ?? [];

        for (final subject in subjects) {
          entries.add(
            _ProgramSubjectEntry(
              semesterLabel: semester.tenHocKy ?? "Học kỳ",
              subject: subject,
            ),
          );
        }
      }

      result.add(
        _YearSection(
          yearTitle: "Năm học ${(i ~/ 2) + 1}",
          entries: entries,
        ),
      );
    }

    return result;
  }
}

class _HeaderCard extends StatelessWidget {
  final int totalYear;
  final int totalSemester;
  final int totalSubject;

  const _HeaderCard({
    required this.totalYear,
    required this.totalSemester,
    required this.totalSubject,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer.gradient(
      gradient: AppGradients.heroGradient,
      borderRadius: AppRadius.xl,
      boxShadow: AppShadows.heroShadow,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.heroTitle("Lộ trình đào tạo"),

          const SizedBox(height: 8),

          AppText.heroSubtitle(
            "Thông tin được thu gọn để dễ theo dõi hơn.",
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              _StatBox(
                value: totalYear.toString(),
                label: "Năm học",
              ),
              const SizedBox(width: 12),
              _StatBox(
                value: totalSemester.toString(),
                label: "Học kỳ",
              ),
              const SizedBox(width: 12),
              _StatBox(
                value: totalSubject.toString(),
                label: "Môn học",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;

  const _StatBox({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.12),
          borderRadius: AppRadius.circular_lg,
        ),
        child: Column(
          children: [
            AppText.cardValue(
              value,
              color: Colors.white,
            ),
            const SizedBox(height: 4),
            AppText.labelSmall(
              label,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

class _YearCard extends StatefulWidget {
  final _YearSection section;

  const _YearCard({
    required this.section,
  });

  @override
  State<_YearCard> createState() => _YearCardState();
}

class _YearCardState extends State<_YearCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppAnimations.durationMedium,
      curve: AppAnimations.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.circular_xl,
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: AppShadows.lightShadow,
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: AppRadius.circular_xl,
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(.1),
                      borderRadius: AppRadius.circular_md,
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        AppText.sectionTitle(
                          widget.section.yearTitle,
                        ),
                        const SizedBox(height: 4),
                        AppText.bodySmall(
                          "${widget.section.entries.length} môn học",
                        ),
                      ],
                    ),
                  ),

                  AnimatedRotation(
                    duration:
                        AppAnimations.durationMedium,
                    turns: expanded ? .5 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedSize(
            duration: AppAnimations.durationMedium,
            curve: AppAnimations.easeInOut,
            child: expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      0,
                      18,
                      18,
                    ),
                    child: Column(
                      children: widget.section.entries
                          .map(
                            (e) => Padding(
                              padding:
                                  const EdgeInsets.only(
                                top: 12,
                              ),
                              child: SubjectCompactCard(
                                entry: e,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class SubjectCompactCard extends StatefulWidget {
  final _ProgramSubjectEntry entry;

  const SubjectCompactCard({
    super.key,
    required this.entry,
  });

  @override
  State<SubjectCompactCard> createState() =>
      _SubjectCompactCardState();
}

class _SubjectCompactCardState
    extends State<SubjectCompactCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final subject = widget.entry.subject;

    return AnimatedContainer(
      duration: AppAnimations.durationMedium,
      curve: AppAnimations.easeInOut,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppRadius.circular_lg,
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: AppRadius.circular_lg,
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight
                          .withOpacity(.12),
                      borderRadius:
                          AppRadius.circular_full,
                    ),
                    child: AppText.labelSmall(
                      subject.maMon ?? "--",
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        AppText.cardHeading(
                          subject.tenMon ??
                              "Không rõ tên môn",
                        ),

                        const SizedBox(height: 4),

                        AppText.bodySmall(
                          "${subject.soTinChi ?? "0"} tín chỉ • ${widget.entry.semesterLabel}",
                        ),
                      ],
                    ),
                  ),

                  AnimatedRotation(
                    duration:
                        AppAnimations.durationMedium,
                    turns: expanded ? .5 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedSize(
            duration: AppAnimations.durationMedium,
            curve: AppAnimations.easeInOut,
            child: expanded
                ? Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.fromLTRB(
                      16,
                      0,
                      16,
                      16,
                    ),
                    child: Column(
                      children: [
                        const Divider(),

                        const SizedBox(height: 12),

                        _InfoRow(
                          label: "Lý thuyết",
                          value:
                              subject.lyThuyet ?? "--",
                        ),

                        _InfoRow(
                          label: "Thực hành",
                          value:
                              subject.thucHanh ?? "--",
                        ),

                        _InfoRow(
                          label: "Tổng tiết",
                          value:
                              subject.tongTiet ?? "--",
                        ),

                        _InfoRow(
                          label: "Bắt buộc",
                          value:
                              subject.monBatBuoc ==
                                      "x"
                                  ? "Có"
                                  : "Không",
                        ),

                        if ((subject.tenMonEg ?? "")
                            .trim()
                            .isNotEmpty)
                          _InfoRow(
                            label: "English",
                            value: subject.tenMonEg!,
                          ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: AppText.bodySmall(label),
          ),
          Expanded(
            child: AppText.bodyMedium(value),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppContainer.errorBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 52,
              color: AppColors.error,
            ),
            const SizedBox(height: 12),
            AppText.sectionTitle(message),
            const SizedBox(height: 16),
            AppButton.primary(
              label: "Tải lại",
              onPressed: onRetry,
              icon: Icons.refresh_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _YearSection {
  final String yearTitle;
  final List<_ProgramSubjectEntry> entries;

  _YearSection({
    required this.yearTitle,
    required this.entries,
  });
}

class _ProgramSubjectEntry {
  final String semesterLabel;
  final ProgramTrainingSubject subject;

  _ProgramSubjectEntry({
    required this.semesterLabel,
    required this.subject,
  });
}