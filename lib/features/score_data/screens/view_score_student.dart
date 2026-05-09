import 'package:aqedu/features/score_data/controllers/ctrl_score_student.dart';
import 'package:flutter/material.dart';
import '../models/model_score_student.dart';

const Color kPrimary = Color(0xFF0047A8);
const Color kPrimaryLight = Color(0xFFE8EFFA);
const Color kPrimaryDark = Color(0xFF00358A);
const Color kBackground = Color(0xFFF5F7FC);
const Color kSurface = Color(0xFFFFFFFF);
const Color kTextPrimary = Color(0xFF0D1B3E);
const Color kTextSecondary = Color(0xFF6B7A99);
const Color kDivider = Color(0xFFE4EAF4);
const Color kSuccess = Color(0xFF1A9E5C);
const Color kWarning = Color(0xFFF59E0B);
const Color kDanger = Color(0xFFE53E3E);

class ScoreStudentView extends StatefulWidget {
  const ScoreStudentView({super.key});

  @override
  State<ScoreStudentView> createState() => _ScoreStudentViewState();
}

class _ScoreStudentViewState extends State<ScoreStudentView>
    with SingleTickerProviderStateMixin {
  late Future<List<SemesterScore>> futureScores;
  SemesterScore? _selectedSemester;

  // Nullable để tránh LateInitializationError khi build được gọi sớm
  AnimationController? _animCtrl;
  Animation<double>? _fadeAnim;
  Animation<Offset>? _slideAnim;

  // Fallback an toàn khi animation chưa sẵn sàng
  Animation<double> get _safeFade =>
      _fadeAnim ?? const AlwaysStoppedAnimation(1.0);
  Animation<Offset> get _safeSlide =>
      _slideAnim ?? const AlwaysStoppedAnimation(Offset.zero);

  @override
  void initState() {
    super.initState();
    final ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _animCtrl = ctrl;
    _fadeAnim = CurvedAnimation(parent: ctrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOut));

    futureScores = _loadData();
  }

  Future<List<SemesterScore>> _loadData() async {
    final ctrl = await CtrlScoreStudent.create();
    return await ctrl.getScores();
  }

  void _onSemesterChanged(SemesterScore? value) {
    setState(() => _selectedSemester = value);
    _animCtrl?.forward(from: 0);
  }

  @override
  void dispose() {
    _animCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: FutureBuilder<List<SemesterScore>>(
        future: futureScores,
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: [
              _buildSliverAppBar(snapshot),
              if (snapshot.connectionState == ConnectionState.waiting)
                const SliverFillRemaining(child: _LoadingState())
              else if (snapshot.hasError)
                SliverFillRemaining(
                  child: _ErrorState(error: snapshot.error.toString()),
                )
              else if (!snapshot.hasData || snapshot.data!.isEmpty)
                const SliverFillRemaining(child: _EmptyState())
              else ...[
                SliverToBoxAdapter(
                  child: _SemesterDropdown(
                    semesters: snapshot.data!,
                    selected: _selectedSemester,
                    onChanged: _onSemesterChanged,
                  ),
                ),
                if (_selectedSemester == null)
                  const SliverFillRemaining(child: _DefaultPromptState())
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    sliver: SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _safeFade,
                        child: SlideTransition(
                          position: _safeSlide,
                          child: _ScoreContent(semester: _selectedSemester!),
                        ),
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

  Widget _buildSliverAppBar(AsyncSnapshot snapshot) {
    return SliverAppBar(
      expandedHeight: 130,
      collapsedHeight: 64,
      pinned: true,
      elevation: 0,
      backgroundColor: kPrimary,
      surfaceTintColor: kPrimary,
      leading: IconButton(
        onPressed: () => Navigator.of(context).maybePop(),
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kPrimary, kPrimaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -20,
                right: -30,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              Positioned(
                bottom: -10,
                left: 60,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.04),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kết quả học tập',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                'Xem điểm theo từng học kỳ',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Semester Dropdown ────────────────────────────────────────────────────────

class _SemesterDropdown extends StatelessWidget {
  final List<SemesterScore> semesters;
  final SemesterScore? selected;
  final ValueChanged<SemesterScore?> onChanged;

  const _SemesterDropdown({
    required this.semesters,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kSurface,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chọn học kỳ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kTextSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: kBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected != null ? kPrimary : kDivider,
                width: selected != null ? 1.5 : 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<SemesterScore>(
                value: selected,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: kPrimary,
                ),
                hint: const Text(
                  'Chọn học kỳ để xem điểm...',
                  style: TextStyle(color: kTextSecondary, fontSize: 14),
                ),
                dropdownColor: kSurface,
                borderRadius: BorderRadius.circular(12),
                items: semesters.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(
                      s.tenHocKy ?? 'Học kỳ không xác định',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kTextPrimary,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
                selectedItemBuilder: (_) => semesters
                    .map(
                      (s) => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          s.tenHocKy ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kPrimary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Score Content ────────────────────────────────────────────────────────────

class _ScoreContent extends StatelessWidget {
  final SemesterScore semester;

  const _ScoreContent({required this.semester});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        _SemesterSummaryCard(semester: semester),
        const SizedBox(height: 16),
        if (semester.dsDiemMonHoc != null &&
            semester.dsDiemMonHoc!.isNotEmpty) ...[
          _SectionHeader(
            title: 'Điểm các môn học',
            count: semester.dsDiemMonHoc!.length,
          ),
          const SizedBox(height: 10),
          ...semester.dsDiemMonHoc!.asMap().entries.map(
            (e) => _SubjectCard(subject: e.value, index: e.key),
          ),
        ],
      ],
    );
  }
}

// ─── Summary Card ─────────────────────────────────────────────────────────────

class _SemesterSummaryCard extends StatelessWidget {
  final SemesterScore semester;

  const _SemesterSummaryCard({required this.semester});

  @override
  Widget build(BuildContext context) {
    final dtb10 = semester.dtbHkHe10;
    final gpaColor = _gpaColor(dtb10);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimary, kPrimaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tổng kết học kỳ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        semester.tenHocKy ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (dtb10 != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: gpaColor.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: gpaColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      dtb10.toString(),
                      style: TextStyle(
                        color: gpaColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Container(height: 1, color: Colors.white.withOpacity(0.15)),
            const SizedBox(height: 16),
            Row(
              children: [
                _StatChip(
                  icon: Icons.star_rounded,
                  label: 'Hệ 4',
                  value: semester.dtbHkHe4?.toString() ?? '--',
                ),
                const SizedBox(width: 10),
                _StatChip(
                  icon: Icons.bookmark_rounded,
                  label: 'Tín chỉ tích lũy',
                  value: semester.soTinChiDatTichLuy?.toString() ?? '--',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _gpaColor(dynamic gpa) {
    if (gpa == null) return Colors.white;
    final val = double.tryParse(gpa.toString()) ?? 0;
    if (val >= 8.5) return const Color(0xFF4ADE80);
    if (val >= 7.0) return const Color(0xFFFBBF24);
    if (val >= 5.0) return const Color(0xFFFB923C);
    return const Color(0xFFF87171);
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 15),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: kPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: kTextPrimary,
            letterSpacing: -0.2,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: kPrimaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count môn',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: kPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Subject Card ─────────────────────────────────────────────────────────────

class _SubjectCard extends StatelessWidget {
  final dynamic subject;
  final int index;

  const _SubjectCard({required this.subject, required this.index});

  Color _gradeColor(dynamic grade) {
    if (grade == null) return kTextSecondary;
    final val = double.tryParse(grade.toString()) ?? 0;
    if (val >= 8.5) return kSuccess;
    if (val >= 7.0) return kWarning;
    if (val >= 5.0) return const Color(0xFFF97316);
    return kDanger;
  }

  String _gradeLetter(dynamic letter) {
    if (letter == null || letter.toString().isEmpty) return '--';
    return letter.toString().toUpperCase();
  }

  Color _letterBg(dynamic letter) {
    final l = letter?.toString().toUpperCase() ?? '';
    switch (l) {
      case 'A+':
      case 'A':
        return const Color(0xFFDCFCE7);
      case 'B+':
      case 'B':
        return const Color(0xFFFEF9C3);
      case 'C+':
      case 'C':
        return const Color(0xFFFFEDD5);
      default:
        return const Color(0xFFFFE4E4);
    }
  }

  Color _letterColor(dynamic letter) {
    final l = letter?.toString().toUpperCase() ?? '';
    switch (l) {
      case 'A+':
      case 'A':
        return kSuccess;
      case 'B+':
      case 'B':
        return const Color(0xFFB45309);
      case 'C+':
      case 'C':
        return const Color(0xFFC2410C);
      default:
        return kDanger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final letterGrade = subject.diemTkChu;
    final numGrade = subject.diemTk;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kDivider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Index badge
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: kPrimaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: kPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Subject name & numeric grade
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.tenMon ?? 'Môn học không xác định',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: kTextPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.bar_chart_rounded,
                        size: 13,
                        color: kTextSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Điểm TK: ',
                        style: const TextStyle(
                          fontSize: 12,
                          color: kTextSecondary,
                        ),
                      ),
                      Text(
                        numGrade?.toString() ?? '--',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: _gradeColor(numGrade),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Letter grade badge
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _letterBg(letterGrade),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _gradeLetter(letterGrade),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: _letterColor(letterGrade),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── States ───────────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: kPrimary, strokeWidth: 2.5),
          SizedBox(height: 16),
          Text(
            'Đang tải dữ liệu...',
            style: TextStyle(color: kTextSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;

  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4E4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: kDanger,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Không thể tải dữ liệu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: kTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: kTextSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: kPrimaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.inbox_rounded, color: kPrimary, size: 36),
            ),
            const SizedBox(height: 16),
            const Text(
              'Chưa có dữ liệu điểm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: kTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Dữ liệu điểm của bạn sẽ xuất hiện ở đây\nkhi có kết quả từ nhà trường.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: kTextSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DefaultPromptState extends StatelessWidget {
  const _DefaultPromptState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kPrimaryLight, kPrimaryLight.withOpacity(0.5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.touch_app_rounded,
                color: kPrimary,
                size: 36,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Chọn học kỳ để xem điểm',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: kTextPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sử dụng menu phía trên để chọn\nhọc kỳ bạn muốn xem kết quả.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: kTextSecondary,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
