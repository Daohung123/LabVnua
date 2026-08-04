// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:aqedu/core/theme/app_components.dart';
import 'package:aqedu/features/score_data/controllers/ctrl_score_student.dart';
import 'package:aqedu/features/score_data/models/model_score_student.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// GPA ENGINE — single source of truth for all score calculations (Scale 4)
// ═══════════════════════════════════════════════════════════════════════════════

class GpaEngine {
  GpaEngine._();

  // ── Safe parse helpers ──────────────────────────────────────────────────────

  static double parseDouble(String? v) {
    if (v == null || v.trim().isEmpty) return 0.0;
    return double.tryParse(v.trim().replaceAll(',', '.')) ?? 0.0;
  }

  static int parseInt(String? v) {
    if (v == null || v.trim().isEmpty) return 0;
    return int.tryParse(v.trim()) ?? 0;
  }

  static String safeText(String? v, {String fallback = '--'}) =>
      (v == null || v.trim().isEmpty) ? fallback : v.trim();

  // ── GPA-4 classification ────────────────────────────────────────────────────

  static String rankFromGpa4(double gpa4) {
    if (gpa4 >= 3.60) return 'Xuất sắc';
    if (gpa4 >= 3.20) return 'Giỏi';
    if (gpa4 >= 2.50) return 'Khá';
    if (gpa4 >= 2.00) return 'Trung bình';
    if (gpa4 >= 1.00) return 'Yếu';
    return 'Kém';
  }

  static Color colorFromGpa4(double gpa4) {
    if (gpa4 >= 3.60) return AppColors.success;
    if (gpa4 >= 3.20) return AppColors.primary;
    if (gpa4 >= 2.50) return AppColors.warning;
    if (gpa4 >= 2.00) return AppColors.warning;
    return AppColors.error;
  }

  static Color colorFromGpa4ForText(double gpa4) => colorFromGpa4(gpa4);

  // ── Subject pass check (dùng GPA-4: >= 1.0 là đạt theo quy định) ───────────
  // Thực tế hầu hết trường dùng diemTkSo hệ 10, nhưng trường hợp này
  // field dtbHkHe4 / dtbTichLuyHe4 đã là hệ 4. Môn được coi là ĐẠT khi
  // diemTkSo (hệ 10) >= 4.0 HOẶC diemTkChu != F/I

  static bool isSubjectPassed(SubjectScore s) {
    final letterGrade = safeText(s.diemTkChu).toUpperCase();
    if (letterGrade == 'F' || letterGrade == 'I') return false;
    final score10 = parseDouble(s.diemTkSo);
    return score10 >= 4.0;
  }

  // ── Convert score10 → GPA4 (standard Vietnamese university scale) ───────────
  static double score10ToGpa4(double score10) {
    if (score10 >= 9.0) return 4.0;
    if (score10 >= 8.5) return 3.7;
    if (score10 >= 8.0) return 3.5;
    if (score10 >= 7.5) return 3.2;
    if (score10 >= 7.0) return 3.0;
    if (score10 >= 6.5) return 2.8;
    if (score10 >= 6.0) return 2.5;
    if (score10 >= 5.5) return 2.3;
    if (score10 >= 5.0) return 2.0;
    if (score10 >= 4.0) return 1.0;
    return 0.0;
  }

  // ── Color from score10 ──────────────────────────────────────────────────────
  static Color colorFromScore10(double score10) {
    if (score10 >= 8.5) return AppColors.success;
    if (score10 >= 7.0) return AppColors.primary;
    if (score10 >= 5.5) return AppColors.warning;
    if (score10 >= 4.0) return AppColors.warning;
    return AppColors.error;
  }

  // ── Scholarship probability based on GPA-4 ──────────────────────────────────
  static String scholarshipChance(double gpa4) {
    if (gpa4 >= 3.60) return 'Rất cao';
    if (gpa4 >= 3.20) return 'Cao';
    if (gpa4 >= 2.80) return 'Trung bình';
    return 'Thấp';
  }

  static Color scholarshipColor(double gpa4) {
    if (gpa4 >= 3.60) return AppColors.success;
    if (gpa4 >= 3.20) return AppColors.primary;
    if (gpa4 >= 2.80) return AppColors.warning;
    return AppColors.error;
  }

  // ── Predicted GPA-4 improvement heuristic ──────────────────────────────────
  static double predictedGpa4(double currentGpa4, int failedCount) {
    double boost = 0.05;
    if (failedCount == 0) boost = 0.08;
    if (failedCount > 2) boost = -0.03;
    return (currentGpa4 + boost).clamp(0.0, 4.0);
  }

  // ── Target credits needed ───────────────────────────────────────────────────
  static int creditsToGraduate(int totalAccumulated, {int required = 140}) {
    return (required - totalAccumulated).clamp(0, required);
  }

  // ── GPA trend tag ───────────────────────────────────────────────────────────
  static String gpaTrendLabel(double current, double previous) {
    final delta = current - previous;
    if (delta > 0.15) return '↑ Tăng mạnh';
    if (delta > 0.0) return '↑ Tăng nhẹ';
    if (delta == 0.0) return '→ Ổn định';
    if (delta > -0.15) return '↓ Giảm nhẹ';
    return '↓ Giảm mạnh';
  }

  static Color gpaTrendColor(double current, double previous) {
    final delta = current - previous;
    if (delta > 0) return AppColors.success;
    if (delta == 0) return AppColors.warning;
    return AppColors.error;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCORE STATISTICS MODEL — cached per semester
// ═══════════════════════════════════════════════════════════════════════════════

class ScoreStatistics {
  final int totalSubjects;
  final int passedSubjects;
  final int failedSubjects;
  final int totalCredits;
  final int passedCredits;
  final int failedCredits;
  final int highScoreSubjects; // score10 >= 8.5
  final int goodScoreSubjects; // score10 >= 7.0
  final int avgScoreSubjects; // score10 >= 5.5
  final int lowScoreSubjects; // score10 < 5.5
  final double semGpa4; // GPA hệ 4 học kỳ (from dtbHkHe4)
  final double semGpa10; // GPA hệ 10 học kỳ (from dtbHkHe10)
  final double cumulativeGpa4; // GPA tích lũy hệ 4
  final double cumulativeGpa10; // GPA tích lũy hệ 10
  final String semGpa4Str;
  final String semGpa10Str;
  final String cumulativeGpa4Str;
  final String cumulativeGpa10Str;
  final String ranking;
  final String academicWarning;
  final double passRate;
  final double creditPassRate;
  final double highScoreRate;
  final SubjectScore? bestSubject;
  final SubjectScore? worstSubject;
  final List<SubjectScore> top3Subjects;
  final List<SubjectScore> bottom3Subjects;
  final Map<String, int> gradeDistribution; // A+, A, B+, B, C+, C, D+, D, F

  const ScoreStatistics({
    required this.totalSubjects,
    required this.passedSubjects,
    required this.failedSubjects,
    required this.totalCredits,
    required this.passedCredits,
    required this.failedCredits,
    required this.highScoreSubjects,
    required this.goodScoreSubjects,
    required this.avgScoreSubjects,
    required this.lowScoreSubjects,
    required this.semGpa4,
    required this.semGpa10,
    required this.cumulativeGpa4,
    required this.cumulativeGpa10,
    required this.semGpa4Str,
    required this.semGpa10Str,
    required this.cumulativeGpa4Str,
    required this.cumulativeGpa10Str,
    required this.ranking,
    required this.academicWarning,
    required this.passRate,
    required this.creditPassRate,
    required this.highScoreRate,
    required this.bestSubject,
    required this.worstSubject,
    required this.top3Subjects,
    required this.bottom3Subjects,
    required this.gradeDistribution,
  });

  static ScoreStatistics from(SemesterScore semester) {
    final subjects = semester.dsDiemMonHoc ?? <SubjectScore>[];

    final passed = subjects.where(GpaEngine.isSubjectPassed).toList();
    final failed = subjects
        .where((s) => !GpaEngine.isSubjectPassed(s))
        .toList();

    final totalCredits = subjects.fold<int>(
      0,
      (s, e) => s + GpaEngine.parseInt(e.soTinChi),
    );
    final passedCredits = passed.fold<int>(
      0,
      (s, e) => s + GpaEngine.parseInt(e.soTinChi),
    );
    final failedCredits = failed.fold<int>(
      0,
      (s, e) => s + GpaEngine.parseInt(e.soTinChi),
    );

    final highScore = subjects
        .where((s) => GpaEngine.parseDouble(s.diemTkSo) >= 8.5)
        .length;
    final goodScore = subjects.where((s) {
      final sc = GpaEngine.parseDouble(s.diemTkSo);
      return sc >= 7.0 && sc < 8.5;
    }).length;
    final avgScore = subjects.where((s) {
      final sc = GpaEngine.parseDouble(s.diemTkSo);
      return sc >= 5.5 && sc < 7.0;
    }).length;
    final lowScore = subjects
        .where((s) => GpaEngine.parseDouble(s.diemTkSo) < 5.5)
        .length;

    // GPA-4 & GPA-10 — đọc trực tiếp từ field (đã là hệ 4 / hệ 10)
    final semGpa4 = GpaEngine.parseDouble(semester.dtbHkHe4);
    final semGpa10 = GpaEngine.parseDouble(semester.dtbHkHe10);
    final cumGpa4 = GpaEngine.parseDouble(semester.dtbTichLuyHe4);
    final cumGpa10 = GpaEngine.parseDouble(semester.dtbTichLuyHe10);

    // Grade distribution
    final Map<String, int> dist = {
      'A+': 0,
      'A': 0,
      'B+': 0,
      'B': 0,
      'C+': 0,
      'C': 0,
      'D+': 0,
      'D': 0,
      'F': 0,
    };
    for (final s in subjects) {
      final letter = GpaEngine.safeText(s.diemTkChu).toUpperCase();
      if (dist.containsKey(letter)) {
        dist[letter] = (dist[letter] ?? 0) + 1;
      }
    }

    // Best / Worst
    SubjectScore? best;
    SubjectScore? worst;
    if (subjects.isNotEmpty) {
      final sorted = [...subjects]
        ..sort(
          (a, b) => GpaEngine.parseDouble(
            b.diemTkSo,
          ).compareTo(GpaEngine.parseDouble(a.diemTkSo)),
        );
      best = sorted.first;
      worst = sorted.last;
    }

    final sortedForTop = [...subjects]
      ..sort(
        (a, b) => GpaEngine.parseDouble(
          b.diemTkSo,
        ).compareTo(GpaEngine.parseDouble(a.diemTkSo)),
      );
    final top3 = sortedForTop.take(3).toList();
    final bottom3 = sortedForTop.reversed.take(3).toList().reversed.toList();

    final total = subjects.length;
    final passRate = total == 0 ? 0.0 : passed.length / total;
    final creditPassRate = totalCredits == 0
        ? 0.0
        : passedCredits / totalCredits;
    final highScoreRate = total == 0 ? 0.0 : highScore / total;

    final warning = semester.canhCaoHocTap?.trim();

    return ScoreStatistics(
      totalSubjects: total,
      passedSubjects: passed.length,
      failedSubjects: failed.length,
      totalCredits: totalCredits,
      passedCredits: passedCredits,
      failedCredits: failedCredits,
      highScoreSubjects: highScore,
      goodScoreSubjects: goodScore,
      avgScoreSubjects: avgScore,
      lowScoreSubjects: lowScore,
      semGpa4: semGpa4,
      semGpa10: semGpa10,
      cumulativeGpa4: cumGpa4,
      cumulativeGpa10: cumGpa10,
      semGpa4Str: GpaEngine.safeText(semester.dtbHkHe4),
      semGpa10Str: GpaEngine.safeText(semester.dtbHkHe10),
      cumulativeGpa4Str: GpaEngine.safeText(semester.dtbTichLuyHe4),
      cumulativeGpa10Str: GpaEngine.safeText(semester.dtbTichLuyHe10),
      ranking: GpaEngine.safeText(
        semester.xepLoaiTkbHk,
        fallback: GpaEngine.rankFromGpa4(semGpa4),
      ),
      academicWarning: (warning != null && warning.isNotEmpty)
          ? warning
          : 'Không có',
      passRate: passRate,
      creditPassRate: creditPassRate,
      highScoreRate: highScoreRate,
      bestSubject: best,
      worstSubject: worst,
      top3Subjects: top3,
      bottom3Subjects: bottom3,
      gradeDistribution: dist,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SEMESTER COMPARISON MODEL
// ═══════════════════════════════════════════════════════════════════════════════

class SemesterTrend {
  final String semesterName;
  final double gpa4;
  final double gpa10;
  final int passed;
  final int total;

  const SemesterTrend({
    required this.semesterName,
    required this.gpa4,
    required this.gpa10,
    required this.passed,
    required this.total,
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// MOCK / ENRICHED DATA MODELS
// ═══════════════════════════════════════════════════════════════════════════════

class _AiInsight {
  final String message;
  final String detail;
  final IconData icon;
  final Color color;
  final String tag;

  const _AiInsight({
    required this.message,
    required this.detail,
    required this.icon,
    required this.color,
    required this.tag,
  });
}

class _Achievement {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool unlocked;
  final int xp;
  final String condition;

  const _Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.unlocked,
    required this.xp,
    required this.condition,
  });
}

class _SmartNotif {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String time;
  final NotifPriority priority;

  const _SmartNotif({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.time,
    required this.priority,
  });
}

enum NotifPriority { high, medium, low }

class _RadarData {
  final String label;
  final double value; // 0.0 – 1.0
  final Color color;

  const _RadarData({
    required this.label,
    required this.value,
    required this.color,
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// STATIC MOCK DATA
// ═══════════════════════════════════════════════════════════════════════════════

List<_AiInsight> _buildAiInsights(ScoreStatistics stats) => [
  _AiInsight(
    message:
        'GPA hệ 4 hiện tại của bạn: ${stats.semGpa4.toStringAsFixed(2)} — ${GpaEngine.rankFromGpa4(stats.semGpa4)}',
    detail:
        'Dựa trên điểm trung bình học kỳ (GPA-4) so với thang xếp loại chuẩn.',
    icon: Icons.auto_graph_rounded,
    color: GpaEngine.colorFromGpa4(stats.semGpa4),
    tag: 'GPA',
  ),
  _AiInsight(
    message: stats.failedSubjects == 0
        ? 'Tuyệt vời! Bạn không có môn nào dưới chuẩn. 🎉'
        : 'Bạn có ${stats.failedSubjects} môn chưa đạt — cần ôn tập ngay.',
    detail: stats.failedSubjects == 0
        ? 'Tiếp tục duy trì phong độ học tập xuất sắc.'
        : 'Ưu tiên ôn tập các môn có điểm thấp nhất để nâng GPA.',
    icon: stats.failedSubjects == 0
        ? Icons.check_circle_rounded
        : Icons.warning_rounded,
    color: stats.failedSubjects == 0
        ? AppColors.success
        : AppColors.error,
    tag: 'Cảnh báo',
  ),
  _AiInsight(
    message:
        'Tỷ lệ tín chỉ đạt: ${(stats.creditPassRate * 100).toStringAsFixed(0)}% (${stats.passedCredits}/${stats.totalCredits} TC)',
    detail: 'Tín chỉ tích lũy ảnh hưởng trực tiếp đến tiến độ tốt nghiệp.',
    icon: Icons.menu_book_rounded,
    color: AppColors.primary,
    tag: 'Tín chỉ',
  ),
  _AiInsight(
    message:
        'Khả năng đạt học bổng: ${GpaEngine.scholarshipChance(stats.semGpa4)}',
    detail: 'Dựa trên GPA-4 học kỳ so với ngưỡng xét học bổng (≥ 3.20).',
    icon: Icons.workspace_premium_rounded,
    color: GpaEngine.scholarshipColor(stats.semGpa4),
    tag: 'Học bổng',
  ),
];

const _kAchievements = <_Achievement>[
  _Achievement(
    title: 'Học sinh xuất sắc',
    description: 'GPA-4 ≥ 3.60 trong một kỳ',
    icon: Icons.emoji_events_rounded,
    color: AppColors.warning,
    unlocked: true,
    xp: 500,
    condition: 'GPA-4 ≥ 3.60',
  ),
  _Achievement(
    title: 'Chuyên cần',
    description: 'Không vắng mặt 30 ngày',
    icon: Icons.local_fire_department_rounded,
    color: AppColors.error,
    unlocked: true,
    xp: 300,
    condition: '30 ngày liên tục',
  ),
  _Achievement(
    title: 'Streak Master',
    description: 'Học liên tục 14 ngày',
    icon: Icons.bolt_rounded,
    color: AppColors.ai,
    unlocked: true,
    xp: 200,
    condition: '14 ngày streak',
  ),
  _Achievement(
    title: 'Top Performer',
    description: 'Top 10% lớp',
    icon: Icons.military_tech_rounded,
    color: AppColors.primary,
    unlocked: false,
    xp: 1000,
    condition: 'GPA-4 ≥ 3.80',
  ),
  _Achievement(
    title: 'Perfect Score',
    description: 'Đạt 10/10 ít nhất 1 môn',
    icon: Icons.star_rounded,
    color: AppColors.success,
    unlocked: false,
    xp: 400,
    condition: 'Điểm tuyệt đối',
  ),
  _Achievement(
    title: 'No Fail Zone',
    description: 'Kỳ không có môn trượt',
    icon: Icons.shield_rounded,
    color: AppColors.primary,
    unlocked: true,
    xp: 350,
    condition: '0 môn trượt',
  ),
];

const _kNotifications = <_SmartNotif>[
  _SmartNotif(
    title: 'Thi cuối kỳ: Toán cao cấp',
    subtitle: 'Còn 5 ngày nữa — hãy ôn tập!',
    icon: Icons.assignment_rounded,
    color: AppColors.error,
    time: '5 ngày',
    priority: NotifPriority.high,
  ),
  _SmartNotif(
    title: 'Nộp bài tập lớn KTLT',
    subtitle: 'Deadline: 23/01/2025',
    icon: Icons.upload_file_rounded,
    color: AppColors.warning,
    time: '2 ngày',
    priority: NotifPriority.medium,
  ),
  _SmartNotif(
    title: 'Điểm CSDL đã cập nhật',
    subtitle: 'Kiểm tra kết quả mới nhất',
    icon: Icons.grade_rounded,
    color: AppColors.success,
    time: '1 giờ',
    priority: NotifPriority.low,
  ),
  _SmartNotif(
    title: 'Đăng ký học kỳ mới sắp đóng',
    subtitle: 'Hạn chót: 28/01/2025',
    icon: Icons.calendar_month_rounded,
    color: AppColors.ai,
    time: '3 ngày',
    priority: NotifPriority.medium,
  ),
];

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN VIEW
// ═══════════════════════════════════════════════════════════════════════════════

class ScoreAnalysisView extends StatefulWidget {
  const ScoreAnalysisView({super.key});

  @override
  State<ScoreAnalysisView> createState() => _ScoreAnalysisViewState();
}

class _ScoreAnalysisViewState extends State<ScoreAnalysisView>
    with TickerProviderStateMixin {
  // ── State ──────────────────────────────────────────────────────────────────
  bool _loading = true;
  String? _error;
  List<SemesterScore> _semesters = [];
  int _selectedSemIdx = 0;

  // Cache statistics per semester index
  final Map<int, ScoreStatistics> _statsCache = {};

  // Search / sort state for subject list
  String _searchQuery = '';
  SubjectSortMode _sortMode = SubjectSortMode.byScore;
  bool _showOnlyFailed = false;

  // Target GPA calculator
  double _targetGpa4 = 3.60;

  // ── Animation controllers ──────────────────────────────────────────────────
  late final AnimationController _heroCtrl;
  late final AnimationController _statsCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _tabCtrl;

  late final Animation<double> _heroFade;
  late final Animation<Offset> _heroSlide;
  late final Animation<double> _statsScale;
  late final Animation<double> _pulse;

  // ── Heatmap mock data ──────────────────────────────────────────────────────
  late final List<List<int>> _heatmapData;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _heatmapData = _generateHeatmap();
    _loadScores();
  }

  void _initAnimations() {
    _heroCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _statsCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _tabCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _heroFade = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut));
    _statsScale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _statsCtrl, curve: Curves.elasticOut));
    _pulse = Tween<double>(
      begin: 0.92,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  List<List<int>> _generateHeatmap() {
    final rng = math.Random(42);
    return List.generate(16, (_) => List.generate(7, (_) => rng.nextInt(5)));
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _statsCtrl.dispose();
    _pulseCtrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  // ── Data loading ───────────────────────────────────────────────────────────

  Future<void> _loadScores() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final ctrl = await CtrlScoreStudent.create();
      final data = await ctrl.getScores();
      if (!mounted) return;
      setState(() {
        _semesters = data;
        _selectedSemIdx = 0;
        _statsCache.clear();
        _loading = false;
      });
      _runEntranceAnimations();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Không thể tải dữ liệu điểm.';
        _loading = false;
      });
    }
  }

  void _runEntranceAnimations() {
    _heroCtrl
      ..reset()
      ..forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted)
        _statsCtrl
          ..reset()
          ..forward();
    });
  }

  // ── Computed getters ───────────────────────────────────────────────────────

  SemesterScore? get _selectedSemester {
    if (_semesters.isEmpty) return null;
    return _semesters[_selectedSemIdx.clamp(0, _semesters.length - 1)];
  }

  ScoreStatistics get _currentStats {
    if (_statsCache.containsKey(_selectedSemIdx))
      return _statsCache[_selectedSemIdx]!;
    final sem = _selectedSemester;
    if (sem == null) {
      return ScoreStatistics.from(SemesterScore());
    }
    final stats = ScoreStatistics.from(sem);
    _statsCache[_selectedSemIdx] = stats;
    return stats;
  }

  List<SemesterTrend> get _semesterTrends {
    return _semesters.map((sem) {
      final stats = ScoreStatistics.from(sem);
      return SemesterTrend(
        semesterName: GpaEngine.safeText(
          sem.tenHocKy,
          fallback: 'HK ${sem.hocKy ?? ''}',
        ),
        gpa4: stats.semGpa4,
        gpa10: stats.semGpa10,
        passed: stats.passedSubjects,
        total: stats.totalSubjects,
      );
    }).toList();
  }

  List<SubjectScore> get _filteredSubjects {
    final sem = _selectedSemester;
    if (sem == null) return [];
    var subjects = sem.dsDiemMonHoc ?? <SubjectScore>[];

    if (_showOnlyFailed) {
      subjects = subjects.where((s) => !GpaEngine.isSubjectPassed(s)).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      subjects = subjects.where((s) {
        return GpaEngine.safeText(s.tenMon).toLowerCase().contains(q) ||
            GpaEngine.safeText(s.maMon).toLowerCase().contains(q);
      }).toList();
    }

    switch (_sortMode) {
      case SubjectSortMode.byScore:
        subjects.sort(
          (a, b) => GpaEngine.parseDouble(
            b.diemTkSo,
          ).compareTo(GpaEngine.parseDouble(a.diemTkSo)),
        );
        break;
      case SubjectSortMode.byName:
        subjects.sort(
          (a, b) => GpaEngine.safeText(
            a.tenMon,
          ).compareTo(GpaEngine.safeText(b.tenMon)),
        );
        break;
      case SubjectSortMode.byCredits:
        subjects.sort(
          (a, b) => GpaEngine.parseInt(
            b.soTinChi,
          ).compareTo(GpaEngine.parseInt(a.soTinChi)),
        );
        break;
      case SubjectSortMode.byStatus:
        subjects.sort((a, b) {
          final ap = GpaEngine.isSubjectPassed(a) ? 0 : 1;
          final bp = GpaEngine.isSubjectPassed(b) ? 0 : 1;
          return ap.compareTo(bp);
        });
        break;
    }

    return subjects;
  }

  List<_RadarData> _buildRadarData(ScoreStatistics stats) {
    final gpa4Ratio = (stats.semGpa4 / 4.0).clamp(0.0, 1.0);
    return [
      _RadarData(
        label: 'GPA',
        value: gpa4Ratio,
        color: AppColors.primary,
      ),
      _RadarData(
        label: 'Đạt môn',
        value: stats.passRate.clamp(0.0, 1.0),
        color: AppColors.success,
      ),
      _RadarData(
        label: 'Điểm cao',
        value: stats.highScoreRate.clamp(0.0, 1.0),
        color: AppColors.warning,
      ),
      _RadarData(
        label: 'Tín chỉ',
        value: stats.creditPassRate.clamp(0.0, 1.0),
        color: AppColors.ai,
      ),
      _RadarData(
        label: 'Ổn định',
        value: stats.totalSubjects == 0
            ? 0
            : (1.0 - stats.failedSubjects / stats.totalSubjects).clamp(
                0.0,
                1.0,
              ),
        color: AppColors.error,
      ),
    ];
  }

  // ── Root build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loading) return _buildShimmerScaffold();
    if (_error != null) return _buildErrorScaffold();
    if (_semesters.isEmpty) return _buildEmptyScaffold();

    final stats = _currentStats;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: RefreshIndicator(
          onRefresh: _loadScores,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              _buildSliverAppBar(stats),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.lg20),
                      _buildQuickStatsRow(stats),
                      const SizedBox(height: 22),
                      _buildSemesterSelector(),
                      const SizedBox(height: 22),
                      _buildGpaOverviewCard(stats),
                      const SizedBox(height: 22),
                      _buildAiInsightsSection(stats),
                      const SizedBox(height: 22),
                      _buildProgressRingsSection(stats),
                      const SizedBox(height: 22),
                      _buildGradeDistributionSection(stats),
                      const SizedBox(height: 22),
                      _buildRadarChartSection(stats),
                      const SizedBox(height: 22),
                      _buildSemesterTrendSection(),
                      const SizedBox(height: 22),
                      _buildStreakSection(),
                      const SizedBox(height: 22),
                      _buildHeatmapSection(),
                      const SizedBox(height: 22),
                      _buildTopBottomSubjectsSection(stats),
                      const SizedBox(height: 22),
                      _buildPredictiveSection(stats),
                      const SizedBox(height: 22),
                      _buildTargetGpaCalculator(stats),
                      const SizedBox(height: 22),
                      _buildSubjectSection(),
                      const SizedBox(height: 22),
                      _buildAchievementsSection(),
                      const SizedBox(height: 22),
                      _buildNotificationsSection(),
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

  // ── Sliver App Bar ─────────────────────────────────────────────────────────

  Widget _buildSliverAppBar(ScoreStatistics stats) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      elevation: 0,
      backgroundColor: AppColors.primaryPressed,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white),
        onPressed: () => Navigator.maybePop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, color: AppColors.white),
          onPressed: _loadScores,
          tooltip: 'Làm mới',
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
        background: _AppBarBackground(
          heroFade: _heroFade,
          heroSlide: _heroSlide,
          stats: stats,
        ),
        title: const Text(
          'Phân tích học tập',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
      ),
    );
  }

  // ── Quick Stats Row ────────────────────────────────────────────────────────

  Widget _buildQuickStatsRow(ScoreStatistics stats) {
    return ScaleTransition(
      scale: _statsScale,
      child: Row(
        children: [
          _QuickStatPill(
            value: '${stats.passedSubjects}/${stats.totalSubjects}',
            label: 'Môn đạt',
            icon: Icons.check_circle_rounded,
            color: AppColors.success,
          ),
          const SizedBox(width: AppSpacing.sm),
          _QuickStatPill(
            value: stats.failedSubjects.toString(),
            label: 'Chưa đạt',
            icon: Icons.cancel_rounded,
            color: AppColors.error,
          ),
          const SizedBox(width: AppSpacing.sm),
          _QuickStatPill(
            value: stats.highScoreSubjects.toString(),
            label: 'Điểm cao',
            icon: Icons.star_rounded,
            color: AppColors.warning,
          ),
          const SizedBox(width: AppSpacing.sm),
          _QuickStatPill(
            value: '${stats.passedCredits}TC',
            label: 'TC đạt',
            icon: Icons.menu_book_rounded,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  // ── Semester Selector ──────────────────────────────────────────────────────

  Widget _buildSemesterSelector() {
    return _SectionCard(
      title: 'Chọn học kỳ',
      icon: Icons.calendar_today_rounded,
      child: SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _semesters.length,
          separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (context, index) {
            final item = _semesters[index];
            final selected = index == _selectedSemIdx;
            final label = GpaEngine.safeText(
              item.tenHocKy,
              fallback: 'HK ${item.hocKy ?? ''}',
            );
            return GestureDetector(
              onTap: () {
                setState(() => _selectedSemIdx = index);
                _runEntranceAnimations();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.background,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  boxShadow: selected ? AppShadows.lightShadow : null,
                  border: selected ? null : Border.all(color: AppColors.border),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? AppColors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── GPA Overview Card ──────────────────────────────────────────────────────

  Widget _buildGpaOverviewCard(ScoreStatistics stats) {
    final rank = GpaEngine.rankFromGpa4(stats.semGpa4);
    final rankColor = GpaEngine.colorFromGpa4(stats.semGpa4);
    final cumRank = GpaEngine.rankFromGpa4(stats.cumulativeGpa4);
    final cumColor = GpaEngine.colorFromGpa4(stats.cumulativeGpa4);
    final hasWarning = stats.academicWarning != 'Không có';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryPressed, rankColor.withOpacity(0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: rankColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border: Border.all(color: AppColors.white.withOpacity(0.25)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.white,
                        size: 11,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'GPA Dashboard',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (hasWarning)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.error.withOpacity(0.5)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          color: AppColors.white,
                          size: 11,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          'Cảnh báo',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stats.semGpa4 == 0
                          ? '--'
                          : stats.semGpa4.toStringAsFixed(2),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'GPA Hệ 4 • Học kỳ này',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _GlassChip(label: rank, color: rankColor),
                    const SizedBox(height: AppSpacing.sm),
                    _GlassChip(
                      label:
                          'Tích lũy: ${stats.cumulativeGpa4 == 0 ? '--' : stats.cumulativeGpa4.toStringAsFixed(2)}',
                      color: cumColor,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _GlassChip(label: cumRank, color: cumColor),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(height: 1, color: AppColors.white.withOpacity(0.15)),
            const SizedBox(height: 14),
            Row(
              children: [
                _GpaMetricSmall(label: 'GPA-10 HK', value: stats.semGpa10Str),
                _GpaMetricSmall(
                  label: 'GPA-10 TL',
                  value: stats.cumulativeGpa10Str,
                ),
                _GpaMetricSmall(label: 'Xếp loại', value: stats.ranking),
                _GpaMetricSmall(
                  label: 'Cảnh báo',
                  value: stats.academicWarning,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── AI Insights ────────────────────────────────────────────────────────────

  Widget _buildAiInsightsSection(ScoreStatistics stats) {
    final insights = _buildAiInsights(stats);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          title: 'AI Study Insights',
          icon: Icons.auto_awesome_rounded,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.md),
        ...List.generate(insights.length, (i) {
          final insight = insights[i];
          return _AnimatedEntrance(
            delay: Duration(milliseconds: 80 * i),
            child: _AiInsightCard(insight: insight),
          );
        }),
      ],
    );
  }

  // ── Progress Rings ─────────────────────────────────────────────────────────

  Widget _buildProgressRingsSection(ScoreStatistics stats) {
    return _SectionCard(
      title: 'Tổng quan tiến độ',
      icon: Icons.analytics_rounded,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AnimatedRing(
                value: (stats.semGpa4 / 4.0).clamp(0.0, 1.0),
                center: stats.semGpa4 == 0
                    ? '--'
                    : stats.semGpa4.toStringAsFixed(2),
                label: 'GPA-4 HK',
                color: GpaEngine.colorFromGpa4(stats.semGpa4),
              ),
              _AnimatedRing(
                value: (stats.cumulativeGpa4 / 4.0).clamp(0.0, 1.0),
                center: stats.cumulativeGpa4 == 0
                    ? '--'
                    : stats.cumulativeGpa4.toStringAsFixed(2),
                label: 'GPA-4 TL',
                color: GpaEngine.colorFromGpa4(stats.cumulativeGpa4),
              ),
              _AnimatedRing(
                value: stats.passRate.clamp(0.0, 1.0),
                center: '${(stats.passRate * 100).toStringAsFixed(0)}%',
                label: 'Môn đạt',
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 18),
          _ProgressRow(
            label: 'Tỷ lệ tín chỉ đạt',
            value: stats.creditPassRate,
            text: '${stats.passedCredits}/${stats.totalCredits} TC',
            color: AppColors.primary,
          ),
          const SizedBox(height: 10),
          _ProgressRow(
            label: 'Môn điểm cao (≥ 8.5)',
            value: stats.highScoreRate,
            text: '${stats.highScoreSubjects} môn',
            color: AppColors.warning,
          ),
          const SizedBox(height: 14),
          _WarningBanner(warning: stats.academicWarning),
        ],
      ),
    );
  }

  // ── Grade Distribution ─────────────────────────────────────────────────────

  Widget _buildGradeDistributionSection(ScoreStatistics stats) {
    final dist = stats.gradeDistribution;
    final total = stats.totalSubjects;
    if (total == 0) return const SizedBox.shrink();

    final grades = ['A+', 'A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F'];
    final colors = [
      AppColors.success,
      AppColors.success,
      AppColors.primary,
      AppColors.primary,
      AppColors.warning,
      AppColors.error,
      AppColors.warning,
      AppColors.warning,
      AppColors.error,
    ];

    return _SectionCard(
      title: 'Phân phối điểm chữ',
      icon: Icons.bar_chart_rounded,
      iconColor: AppColors.ai,
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(grades.length, (i) {
                final grade = grades[i];
                final count = dist[grade] ?? 0;
                final ratio = total == 0 ? 0.0 : count / total;
                return _GradeBar(
                  grade: grade,
                  count: count,
                  ratio: ratio,
                  color: colors[i],
                );
              }),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: List.generate(grades.length, (i) {
              final count = dist[grades[i]] ?? 0;
              if (count == 0) return const SizedBox.shrink();
              return _LegendChip(
                label: '${grades[i]}: $count',
                color: colors[i],
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Radar Chart ────────────────────────────────────────────────────────────

  Widget _buildRadarChartSection(ScoreStatistics stats) {
    final radarData = _buildRadarData(stats);
    return _SectionCard(
      title: 'Radar kỹ năng học tập',
      icon: Icons.radar_rounded,
      iconColor: AppColors.primary,
      child: Row(
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: CustomPaint(painter: _RadarChartPainter(data: radarData)),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: radarData
                  .map(
                    (d) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                d.label,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                '${(d.value * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: d.color,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            child: LinearProgressIndicator(
                              value: d.value,
                              minHeight: 5,
                              backgroundColor: AppColors.border,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                d.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Semester Trend ─────────────────────────────────────────────────────────

  Widget _buildSemesterTrendSection() {
    final trends = _semesterTrends;
    if (trends.length < 2) return const SizedBox.shrink();

    return _SectionCard(
      title: 'Xu hướng GPA-4 theo học kỳ',
      icon: Icons.show_chart_rounded,
      iconColor: AppColors.success,
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: CustomPaint(
              painter: _TrendLinePainter(trends: trends),
              size: const Size(double.infinity, 120),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: trends
                  .map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: GpaEngine.colorFromGpa4(t.gpa4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            t.gpa4.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: GpaEngine.colorFromGpa4(t.gpa4),
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: Text(
                              t.semesterName,
                              style: const TextStyle(
                                fontSize: 9,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          if (trends.length >= 2) ...[
            const SizedBox(height: 10),
            _TrendDeltaBadge(
              current: trends.last.gpa4,
              previous: trends[trends.length - 2].gpa4,
            ),
          ],
        ],
      ),
    );
  }

  // ── Study Streak ───────────────────────────────────────────────────────────

  Widget _buildStreakSection() {
    const totalXP = 2450;
    const nextLevelXP = 3000;
    const progress = totalXP / nextLevelXP;

    return _SectionCard(
      title: 'Study Streak & XP',
      icon: Icons.local_fire_department_rounded,
      iconColor: AppColors.error,
      child: Column(
        children: [
          Row(
            children: [
              _StreakCard(
                value: '12',
                label: 'Ngày liên tục',
                icon: Icons.local_fire_department_rounded,
                color: AppColors.error,
                pulse: _pulse,
              ),
              const SizedBox(width: 10),
              _StreakCard(
                value: '21',
                label: 'Streak tốt nhất',
                icon: Icons.emoji_events_rounded,
                color: AppColors.warning,
                pulse: _pulse,
              ),
              const SizedBox(width: 10),
              _StreakCard(
                value: '2450',
                label: 'XP tổng',
                icon: Icons.bolt_rounded,
                color: AppColors.ai,
                pulse: _pulse,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.ai, AppColors.ai],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: const Text(
                  '⚡ Level 8 • Scholar',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Text(
                '2450 / 3000 XP',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 1400),
              curve: Curves.easeOut,
              builder: (context, val, _) => LinearProgressIndicator(
                value: val,
                minHeight: 10,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.ai,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Heatmap ────────────────────────────────────────────────────────────────

  Widget _buildHeatmapSection() {
    return _SectionCard(
      title: 'Learning Heatmap',
      icon: Icons.grid_view_rounded,
      iconColor: AppColors.success,
      trailing: const Text(
        '4 tháng gần đây',
        style: TextStyle(
          fontSize: 11,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 96, child: _HeatmapGrid(data: _heatmapData)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Ít',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
              const SizedBox(width: AppSpacing.xs),
              ...[0, 1, 2, 3, 4].map(
                (level) => Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: _HeatmapGrid.cellColor(level),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Text(
                'Nhiều',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Top / Bottom Subjects ──────────────────────────────────────────────────

  Widget _buildTopBottomSubjectsSection(ScoreStatistics stats) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _SectionCard(
            title: 'Môn tốt nhất',
            icon: Icons.trending_up_rounded,
            iconColor: AppColors.success,
            child: Column(
              children: stats.top3Subjects.isEmpty
                  ? [
                      const Text(
                        'Chưa có dữ liệu',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ]
                  : stats.top3Subjects.asMap().entries.map((e) {
                      final idx = e.key;
                      final s = e.value;
                      return _TopSubjectRow(
                        rank: idx + 1,
                        subject: s,
                        isTop: true,
                      );
                    }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SectionCard(
            title: 'Cần cải thiện',
            icon: Icons.trending_down_rounded,
            iconColor: AppColors.error,
            child: Column(
              children: stats.bottom3Subjects.isEmpty
                  ? [
                      const Text(
                        'Chưa có dữ liệu',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ]
                  : stats.bottom3Subjects.asMap().entries.map((e) {
                      final idx = e.key;
                      final s = e.value;
                      return _TopSubjectRow(
                        rank: idx + 1,
                        subject: s,
                        isTop: false,
                      );
                    }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // ── Predictive Section ─────────────────────────────────────────────────────

  Widget _buildPredictiveSection(ScoreStatistics stats) {
    final predicted = GpaEngine.predictedGpa4(
      stats.semGpa4,
      stats.failedSubjects,
    );
    final delta = predicted - stats.semGpa4;
    final scholChance = GpaEngine.scholarshipChance(stats.semGpa4);
    final scholColor = GpaEngine.scholarshipColor(stats.semGpa4);
    final riskLabel = stats.failedSubjects > 0
        ? '${stats.failedSubjects} môn nguy hiểm'
        : 'An toàn';
    final riskColor = stats.failedSubjects > 0
        ? AppColors.error
        : AppColors.success;
    final trend = _semesterTrends.length >= 2
        ? GpaEngine.gpaTrendLabel(
            stats.semGpa4,
            _semesterTrends[_semesterTrends.length - 2].gpa4,
          )
        : '→ Ổn định';

    return _SectionCard(
      title: 'Dự đoán AI & Phân tích',
      icon: Icons.psychology_rounded,
      iconColor: AppColors.ai,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _PredictCard(
                  label: 'GPA-4 dự kiến',
                  value: predicted.toStringAsFixed(2),
                  icon: Icons.trending_up_rounded,
                  color: AppColors.success,
                  delta: delta >= 0
                      ? '+${delta.toStringAsFixed(2)}'
                      : delta.toStringAsFixed(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PredictCard(
                  label: 'Học bổng',
                  value: scholChance,
                  icon: Icons.workspace_premium_rounded,
                  color: scholColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PredictCard(
                  label: 'Nguy cơ trượt',
                  value: riskLabel,
                  icon: Icons.warning_rounded,
                  color: riskColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PredictCard(
                  label: 'Xu hướng GPA',
                  value: trend,
                  icon: Icons.show_chart_rounded,
                  color: _semesterTrends.length >= 2
                      ? GpaEngine.gpaTrendColor(
                          stats.semGpa4,
                          _semesterTrends[_semesterTrends.length - 2].gpa4,
                        )
                      : AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PredictCard(
                  label: 'Xếp loại dự đoán',
                  value: GpaEngine.rankFromGpa4(predicted),
                  icon: Icons.emoji_events_rounded,
                  color: GpaEngine.colorFromGpa4(predicted),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PredictCard(
                  label: 'Xếp loại tích lũy',
                  value: GpaEngine.rankFromGpa4(stats.cumulativeGpa4),
                  icon: Icons.school_rounded,
                  color: GpaEngine.colorFromGpa4(stats.cumulativeGpa4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Target GPA Calculator ──────────────────────────────────────────────────

  Widget _buildTargetGpaCalculator(ScoreStatistics stats) {
    final diff = _targetGpa4 - stats.semGpa4;
    final achievable = _targetGpa4 <= 4.0 && diff <= 1.2;
    final message = achievable
        ? diff <= 0
              ? 'Bạn đã đạt mục tiêu này rồi! 🎉'
              : 'Cần tăng ${diff.toStringAsFixed(2)} điểm GPA-4 — khả thi!'
        : 'Mục tiêu GPA-4 này khá thách thức.';
    final msgColor = diff <= 0
        ? AppColors.success
        : achievable
        ? AppColors.warning
        : AppColors.error;

    return _SectionCard(
      title: 'Tính toán mục tiêu GPA-4',
      icon: Icons.calculate_rounded,
      iconColor: AppColors.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mục tiêu GPA-4',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  _targetGpa4.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.border,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.12),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            ),
            child: Slider(
              value: _targetGpa4,
              min: 0.0,
              max: 4.0,
              divisions: 40,
              onChanged: (v) => setState(() => _targetGpa4 = v),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '0.00',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
              Text(
                GpaEngine.rankFromGpa4(_targetGpa4),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: GpaEngine.colorFromGpa4(_targetGpa4),
                ),
              ),
              const Text(
                '4.00',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: msgColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: msgColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  diff <= 0 ? Icons.check_circle_rounded : Icons.info_rounded,
                  color: msgColor,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: msgColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _TargetRow(
                  label: 'GPA-4 hiện tại',
                  value: stats.semGpa4.toStringAsFixed(2),
                  color: GpaEngine.colorFromGpa4(stats.semGpa4),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _TargetRow(
                  label: 'Cần đạt thêm',
                  value: diff > 0 ? '+${diff.toStringAsFixed(2)}' : '✓ Đã đạt',
                  color: diff > 0 ? AppColors.warning : AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Subject Section ────────────────────────────────────────────────────────

  Widget _buildSubjectSection() {
    final subjects = _filteredSubjects;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          title: 'Chi tiết môn học',
          icon: Icons.library_books_rounded,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.md),

        // Search bar
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.lightShadow,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm môn học...',
              hintStyle: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
                size: 18,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () => setState(() => _searchQuery = ''),
                    )
                  : null,
            ),
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
        ),
        const SizedBox(height: 10),

        // Sort & filter row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: 'Theo điểm',
                selected: _sortMode == SubjectSortMode.byScore,
                onTap: () =>
                    setState(() => _sortMode = SubjectSortMode.byScore),
              ),
              const SizedBox(width: AppSpacing.sm),
              _FilterChip(
                label: 'Theo tên',
                selected: _sortMode == SubjectSortMode.byName,
                onTap: () => setState(() => _sortMode = SubjectSortMode.byName),
              ),
              const SizedBox(width: AppSpacing.sm),
              _FilterChip(
                label: 'Theo TC',
                selected: _sortMode == SubjectSortMode.byCredits,
                onTap: () =>
                    setState(() => _sortMode = SubjectSortMode.byCredits),
              ),
              const SizedBox(width: AppSpacing.sm),
              _FilterChip(
                label: 'Trạng thái',
                selected: _sortMode == SubjectSortMode.byStatus,
                onTap: () =>
                    setState(() => _sortMode = SubjectSortMode.byStatus),
              ),
              const SizedBox(width: AppSpacing.sm),
              _FilterChip(
                label: 'Chỉ trượt',
                selected: _showOnlyFailed,
                onTap: () => setState(() => _showOnlyFailed = !_showOnlyFailed),
                color: AppColors.error,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        if (subjects.isEmpty)
          _EmptySubjectState(
            showOnlyFailed: _showOnlyFailed,
            query: _searchQuery,
          )
        else
          ...List.generate(
            subjects.length,
            (i) => _AnimatedEntrance(
              delay: Duration(milliseconds: 40 * i),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _SubjectCard(
                  subject: subjects[i],
                  isPassed: GpaEngine.isSubjectPassed(subjects[i]),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ── Achievements ───────────────────────────────────────────────────────────

  Widget _buildAchievementsSection() {
    final totalXP = _kAchievements
        .where((a) => a.unlocked)
        .fold<int>(0, (s, a) => s + a.xp);
    final unlocked = _kAchievements.where((a) => a.unlocked).length;

    return _SectionCard(
      title: 'Thành tích & Huy hiệu',
      icon: Icons.military_tech_rounded,
      iconColor: AppColors.warning,
      child: Column(
        children: [
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _kAchievements.length,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, i) =>
                  _AchievementBadge(achievement: _kAchievements[i]),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$unlocked/${_kAchievements.length}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Text(
                        'Huy hiệu mở khóa',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.ai, AppColors.ai],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.bolt_rounded,
                                color: AppColors.white,
                                size: 14,
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                'Scholar',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$totalXP XP',
                            style: const TextStyle(
                              color: AppColors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.white70,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Notifications ──────────────────────────────────────────────────────────

  Widget _buildNotificationsSection() {
    return _SectionCard(
      title: 'Thông báo thông minh',
      icon: Icons.notifications_active_rounded,
      iconColor: AppColors.error,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(
          '${_kNotifications.length}',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.error,
          ),
        ),
      ),
      child: Column(
        children: _kNotifications.map((n) => _NotifCard(notif: n)).toList(),
      ),
    );
  }

  // ── Loading / Error / Empty scaffolds ──────────────────────────────────────

  Widget _buildShimmerScaffold() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: 6,
          itemBuilder: (_, i) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: i == 0 ? 240 : 130,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: const _ShimmerOverlay(),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScaffold() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  size: 48,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: AppSpacing.lg20),
              const Text(
                'Không thể tải dữ liệu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _error ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              GestureDetector(
                onTap: _loadScores,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryPressed, AppColors.primary],
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    boxShadow: AppShadows.lightShadow,
                  ),
                  child: const Text(
                    'Thử lại',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyScaffold() {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Chưa có dữ liệu điểm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Dữ liệu học tập sẽ xuất hiện ở đây',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SubjectSortMode
// ═══════════════════════════════════════════════════════════════════════════════

enum SubjectSortMode { byScore, byName, byCredits, byStatus }

// ═══════════════════════════════════════════════════════════════════════════════
// APP BAR BACKGROUND
// ═══════════════════════════════════════════════════════════════════════════════

class _AppBarBackground extends StatelessWidget {
  final Animation<double> heroFade;
  final Animation<Offset> heroSlide;
  final ScoreStatistics stats;

  const _AppBarBackground({
    required this.heroFade,
    required this.heroSlide,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.primary),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: -30,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 40,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withOpacity(0.03),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
              child: FadeTransition(
                opacity: heroFade,
                child: SlideTransition(
                  position: heroSlide,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(
                                AppRadius.full,
                              ),
                              border: Border.all(
                                color: AppColors.white.withOpacity(0.25),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: AppColors.white,
                                  size: 11,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'AI Analytics • GPA-4 Engine',
                                  style: TextStyle(
                                    color: AppColors.white.withOpacity(0.9),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: rankColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: rankColor.withOpacity(0.5),
                              ),
                            ),
                            child: Text(
                              GpaEngine.rankFromGpa4(stats.semGpa4),
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Phân tích học tập',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Theo dõi GPA-4 & tiến độ học tập',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.7),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          _HeroMetric(
                            label: 'GPA Hệ 4',
                            value: stats.semGpa4 == 0
                                ? '--'
                                : stats.semGpa4.toStringAsFixed(2),
                            icon: Icons.auto_graph_rounded,
                          ),
                          const SizedBox(width: 10),
                          _HeroMetric(
                            label: 'GPA Tích lũy',
                            value: stats.cumulativeGpa4 == 0
                                ? '--'
                                : stats.cumulativeGpa4.toStringAsFixed(2),
                            icon: Icons.trending_up_rounded,
                          ),
                          const SizedBox(width: 10),
                          _HeroMetric(
                            label: 'Xếp loại',
                            value: GpaEngine.rankFromGpa4(stats.semGpa4),
                            icon: Icons.emoji_events_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// REUSABLE WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _HeroMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _HeroMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.11),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.white.withOpacity(0.18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.white.withOpacity(0.65), size: 15),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppColors.white.withOpacity(0.6),
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassChip extends StatelessWidget {
  final String label;
  final Color color;

  const _GlassChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.white.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _GpaMetricSmall extends StatelessWidget {
  final String label;
  final String value;

  const _GpaMetricSmall({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: TextStyle(color: AppColors.white.withOpacity(0.5), fontSize: 9),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.lightShadow,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: color, size: 15),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(icon, color: color, size: 17),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _QuickStatPill extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _QuickStatPill({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.lightShadow,
          border: Border.all(color: color.withOpacity(0.12)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: color, size: 14),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AiInsightCard extends StatelessWidget {
  final _AiInsight insight;

  const _AiInsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: insight.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: insight.color.withOpacity(0.2)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: AppColors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          leading: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: insight.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(insight.icon, color: insight.color, size: 16),
          ),
          title: Text(
            insight.message,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: insight.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              insight.tag,
              style: TextStyle(
                color: insight.color,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          children: [
            Text(
              insight.detail,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final Animation<double> pulse;

  const _StreakCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: color.withOpacity(0.18)),
        ),
        child: Column(
          children: [
            ScaleTransition(
              scale: pulse,
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 7),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedRing extends StatelessWidget {
  final double value;
  final String center;
  final String label;
  final Color color;

  const _AnimatedRing({
    required this.value,
    required this.center,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 82,
          height: 82,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value),
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeOut,
            builder: (context, val, _) => CustomPaint(
              painter: _RingPainter(progress: val, color: color),
              child: Center(
                child: Text(
                  center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final double value;
  final String text;
  final Color color;

  const _ProgressRow({
    required this.label,
    required this.value,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOut,
            builder: (context, val, _) => LinearProgressIndicator(
              value: val,
              minHeight: 7,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}

class _WarningBanner extends StatelessWidget {
  final String warning;

  const _WarningBanner({required this.warning});

  @override
  Widget build(BuildContext context) {
    final hasWarning = warning != 'Không có';
    final color = hasWarning ? AppColors.error : AppColors.success;
    final icon = hasWarning
        ? Icons.warning_amber_rounded
        : Icons.check_circle_rounded;
    final text = hasWarning
        ? 'Cảnh báo học tập: $warning'
        : 'Không có cảnh báo học tập';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PredictCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? delta;

  const _PredictCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.delta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 17),
              if (delta != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (delta!.startsWith('+')
                                ? AppColors.success
                                : AppColors.error)
                            .withOpacity(0.14),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    delta!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: delta!.startsWith('+')
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TargetRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GradeBar extends StatelessWidget {
  final String grade;
  final int count;
  final double ratio;
  final Color color;

  const _GradeBar({
    required this.grade,
    required this.count,
    required this.ratio,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (count > 0)
          Text(
            '$count',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        const SizedBox(height: 2),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: ratio),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOut,
          builder: (context, val, _) => Container(
            width: 22,
            height: (val * 80).clamp(4.0, 80.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          grade,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _LegendChip extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? c : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: selected ? c : AppColors.border),
          boxShadow: selected ? AppShadows.lightShadow : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _TrendDeltaBadge extends StatelessWidget {
  final double current;
  final double previous;

  const _TrendDeltaBadge({required this.current, required this.previous});

  @override
  Widget build(BuildContext context) {
    final delta = current - previous;
    final label = GpaEngine.gpaTrendLabel(current, previous);
    final color = GpaEngine.gpaTrendColor(current, previous);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            delta >= 0
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            '$label so với kỳ trước (${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(2)})',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopSubjectRow extends StatelessWidget {
  final int rank;
  final SubjectScore subject;
  final bool isTop;

  const _TopSubjectRow({
    required this.rank,
    required this.subject,
    required this.isTop,
  });

  @override
  Widget build(BuildContext context) {
    final score = GpaEngine.parseDouble(subject.diemTkSo);
    final color = GpaEngine.colorFromScore10(score);
    final name = GpaEngine.safeText(subject.tenMon);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: (isTop ? AppColors.success : AppColors.error).withOpacity(
                0.1,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: isTop ? AppColors.success : AppColors.error,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              score.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySubjectState extends StatelessWidget {
  final bool showOnlyFailed;
  final String query;

  const _EmptySubjectState({required this.showOnlyFailed, required this.query});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(
            showOnlyFailed
                ? Icons.check_circle_outline_rounded
                : Icons.search_off_rounded,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            showOnlyFailed
                ? 'Không có môn trượt — xuất sắc!'
                : 'Không tìm thấy môn học "$query"',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final _Achievement achievement;

  const _AchievementBadge({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: achievement.unlocked ? 1.0 : 0.38,
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: achievement.unlocked
                    ? LinearGradient(
                        colors: [
                          achievement.color.withOpacity(0.2),
                          achievement.color.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: achievement.unlocked ? null : AppColors.border,
                shape: BoxShape.circle,
                border: Border.all(
                  color: achievement.unlocked
                      ? achievement.color.withOpacity(0.45)
                      : AppColors.border,
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  achievement.icon,
                  color: achievement.color,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              achievement.title,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (achievement.unlocked)
              Text(
                '+${achievement.xp} XP',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: achievement.color,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final _SmartNotif notif;

  const _NotifCard({required this.notif});

  @override
  Widget build(BuildContext context) {
    final priorityColor = notif.priority == NotifPriority.high
        ? AppColors.error
        : notif.priority == NotifPriority.medium
        ? AppColors.warning
        : AppColors.success;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: notif.color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: notif.color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: notif.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(notif.icon, color: notif.color, size: 18),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notif.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: priorityColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  notif.subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: notif.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              notif.time,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: notif.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SUBJECT CARD (expandable, with all score details)
// ═══════════════════════════════════════════════════════════════════════════════

class _SubjectCard extends StatelessWidget {
  final SubjectScore subject;
  final bool isPassed;

  const _SubjectCard({required this.subject, required this.isPassed});

  @override
  Widget build(BuildContext context) {
    final score10 = GpaEngine.parseDouble(subject.diemTkSo);
    final gpa4Converted = GpaEngine.score10ToGpa4(score10);
    final scoreStr = GpaEngine.safeText(subject.diemTkSo);
    final letter = GpaEngine.safeText(subject.diemTkChu);
    final credits = GpaEngine.safeText(subject.soTinChi);
    final title = GpaEngine.safeText(subject.tenMon);
    final code = GpaEngine.safeText(subject.maMon);
    final statusColor = isPassed ? AppColors.success : AppColors.error;
    final scoreColor = GpaEngine.colorFromScore10(score10);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: statusColor.withOpacity(0.18)),
        boxShadow: AppShadows.lightShadow,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: AppColors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scoreColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Center(
              child: Text(
                scoreStr,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: scoreColor,
                ),
              ),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Row(
              children: [
                Text(
                  '$code • $credits TC',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: scoreColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isPassed ? 'Đạt' : 'Trượt',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ),
          children: [
            Divider(color: AppColors.border, height: 1),
            const SizedBox(height: AppSpacing.md),
            _DetailRow(
              label: 'Điểm giữa kỳ',
              value: GpaEngine.safeText(subject.diemGiuaKy),
            ),
            _DetailRow(
              label: 'Điểm thi',
              value: GpaEngine.safeText(subject.diemThi),
            ),
            _DetailRow(
              label: 'Điểm tổng kết (Hệ 10)',
              value: scoreStr,
              highlight: true,
              highlightColor: scoreColor,
            ),
            _DetailRow(
              label: 'Quy đổi GPA-4',
              value: gpa4Converted.toStringAsFixed(1),
              highlight: true,
              highlightColor: GpaEngine.colorFromGpa4(gpa4Converted),
            ),
            _DetailRow(
              label: 'Kết quả',
              value: isPassed ? '✅ Đạt' : '❌ Chưa đạt',
              highlight: true,
              highlightColor: statusColor,
            ),
            if (subject.lyDoKhongTinhDiemTbtl?.trim().isNotEmpty == true)
              _DetailRow(
                label: 'Lý do không tính TBTL',
                value: GpaEngine.safeText(subject.lyDoKhongTinhDiemTbtl),
              ),
            if (subject.dsDiemThanhPhan?.isNotEmpty == true) ...[
              const SizedBox(height: 10),
              const Text(
                'Điểm thành phần',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...subject.dsDiemThanhPhan!.map(
                (c) => _ComponentChip(component: c),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  final Color? highlightColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.highlight = false,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
              color: highlightColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComponentChip extends StatelessWidget {
  final ComponentScore component;

  const _ComponentChip({required this.component});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${component.kyHieu ?? '--'} • ${component.tenThanhPhan ?? '--'}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Trọng số: ${component.trongSo ?? '--'}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              component.diemThanhPhan ?? '--',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// HEATMAP GRID
// ═══════════════════════════════════════════════════════════════════════════════

class _HeatmapGrid extends StatelessWidget {
  final List<List<int>> data;

  const _HeatmapGrid({required this.data});

  static Color cellColor(int level) {
    switch (level) {
      case 0:
        return AppColors.border;
      case 1:
        return AppColors.successLight;
      case 2:
        return AppColors.success;
      case 3:
        return AppColors.success;
      default:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize =
            (constraints.maxWidth / data.length).floor().toDouble() - 3;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data
              .map(
                (week) => Column(
                  children: week
                      .map(
                        (level) => Container(
                          width: cellSize,
                          height: cellSize,
                          margin: const EdgeInsets.only(bottom: 3),
                          decoration: BoxDecoration(
                            color: cellColor(level),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ANIMATION UTILITIES
// ═══════════════════════════════════════════════════════════════════════════════

class _AnimatedEntrance extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const _AnimatedEntrance({required this.child, required this.delay});

  @override
  State<_AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<_AnimatedEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.14),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CUSTOM PAINTERS
// ═══════════════════════════════════════════════════════════════════════════════

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;

  const _RingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 7;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppColors.border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.color != color;
}

class _RadarChartPainter extends CustomPainter {
  final List<_RadarData> data;

  const _RadarChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 12;
    final n = data.length;
    final angleStep = 2 * math.pi / n;

    // Grid rings
    for (int ring = 1; ring <= 4; ring++) {
      final r = radius * ring / 4;
      final path = Path();
      for (int i = 0; i < n; i++) {
        final angle = -math.pi / 2 + i * angleStep;
        final x = center.dx + r * math.cos(angle);
        final y = center.dy + r * math.sin(angle);
        if (i == 0)
          path.moveTo(x, y);
        else
          path.lineTo(x, y);
      }
      path.close();
      canvas.drawPath(
        path,
        Paint()
          ..color = AppColors.border
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    // Axis lines
    for (int i = 0; i < n; i++) {
      final angle = -math.pi / 2 + i * angleStep;
      canvas.drawLine(
        center,
        Offset(
          center.dx + radius * math.cos(angle),
          center.dy + radius * math.sin(angle),
        ),
        Paint()
          ..color = AppColors.border
          ..strokeWidth = 1,
      );
    }

    // Data polygon
    final dataPath = Path();
    for (int i = 0; i < n; i++) {
      final angle = -math.pi / 2 + i * angleStep;
      final r = radius * data[i].value;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0)
        dataPath.moveTo(x, y);
      else
        dataPath.lineTo(x, y);
    }
    dataPath.close();

    canvas.drawPath(
      dataPath,
      Paint()
        ..color = AppColors.primary.withOpacity(0.15)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      dataPath,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Dots
    for (int i = 0; i < n; i++) {
      final angle = -math.pi / 2 + i * angleStep;
      final r = radius * data[i].value;
      canvas.drawCircle(
        Offset(
          center.dx + r * math.cos(angle),
          center.dy + r * math.sin(angle),
        ),
        4,
        Paint()
          ..color = data[i].color
          ..style = PaintingStyle.fill,
      );
    }

    // Labels
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < n; i++) {
      final angle = -math.pi / 2 + i * angleStep;
      final labelRadius = radius + 14;
      final x = center.dx + labelRadius * math.cos(angle);
      final y = center.dy + labelRadius * math.sin(angle);
      tp.text = TextSpan(
        text: data[i].label,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      );
      tp.layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_RadarChartPainter old) => old.data != data;
}

class _TrendLinePainter extends CustomPainter {
  final List<SemesterTrend> trends;

  const _TrendLinePainter({required this.trends});

  @override
  void paint(Canvas canvas, Size size) {
    if (trends.length < 2) return;

    final maxGpa = trends.map((t) => t.gpa4).reduce(math.max).clamp(0.01, 4.0);
    final minGpa = trends.map((t) => t.gpa4).reduce(math.min).clamp(0.0, 3.99);
    final range = (maxGpa - minGpa).clamp(0.5, 4.0);

    final padding = const EdgeInsets.only(
      top: 16,
      bottom: 20,
      left: 8,
      right: 8,
    );
    final plotWidth = size.width - padding.left - padding.right;
    final plotHeight = size.height - padding.top - padding.bottom;
    final xStep = plotWidth / (trends.length - 1);

    Offset getPoint(int i) {
      final gpa = trends[i].gpa4;
      final x = padding.left + i * xStep;
      final y = padding.top + plotHeight * (1 - (gpa - minGpa) / range);
      return Offset(x, y);
    }

    // Gradient fill
    final fillPath = Path();
    fillPath.moveTo(padding.left, padding.top + plotHeight);
    for (int i = 0; i < trends.length; i++) {
      fillPath.lineTo(getPoint(i).dx, getPoint(i).dy);
    }
    fillPath.lineTo(padding.left + plotWidth, padding.top + plotHeight);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.2),
            AppColors.primary.withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Line
    final linePath = Path();
    for (int i = 0; i < trends.length; i++) {
      final p = getPoint(i);
      if (i == 0)
        linePath.moveTo(p.dx, p.dy);
      else
        linePath.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = AppColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Dots
    for (int i = 0; i < trends.length; i++) {
      final p = getPoint(i);
      final color = GpaEngine.colorFromGpa4(trends[i].gpa4);
      canvas.drawCircle(
        p,
        5,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        p,
        5,
        Paint()
          ..color = AppColors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(_TrendLinePainter old) => old.trends != trends;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SHIMMER OVERLAY
// ═══════════════════════════════════════════════════════════════════════════════

class _ShimmerOverlay extends StatefulWidget {
  const _ShimmerOverlay();

  @override
  State<_ShimmerOverlay> createState() => _ShimmerOverlayState();
}

class _ShimmerOverlayState extends State<_ShimmerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          gradient: LinearGradient(
            begin: Alignment(-2 + 4 * _anim.value, 0),
            end: Alignment(2 + 4 * _anim.value, 0),
            colors: const [
              AppColors.border,
              AppColors.surfaceAlt,
              AppColors.border,
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXTENSION: SemesterScore default constructor guard
// ═══════════════════════════════════════════════════════════════════════════════

extension SemesterScoreExt on SemesterScore {
  static SemesterScore empty() => SemesterScore();
}
