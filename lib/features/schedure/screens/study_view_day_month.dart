// ============================================================
//  THỜI KHÓA BIỂU – View (MVC) – v2 + Conflict Detection
//  Model:      schedure_student.dart  (TkbResponse, TuanTkb, ThoiKhoaBieu, TietTrongNgay)
//  Controller: ctrl_schedure.dart     (CtrlSchedure)
//  Màu chủ đạo: #0047A8 + trắng
// ============================================================
//
//  LUỒNG DỮ LIỆU:
//  CtrlSchedure.create() [async factory, lấy cookie+token từ SQLite]
//    → getFullTkbResponse()
//        → TkbResponse { dsTietTrongNgay, dsTuanTkb }
//
//  View xây 2 cấu trúc từ TkbResponse:
//    1. periodMap : Map<int, TietTrongNgay>  — tra cứu giờ theo số tiết (từ API)
//    2. allItems  : List<ThoiKhoaBieu>       — toàn bộ buổi học (flat)
//
//  Tab Ngày  → lọc allItems theo ngày đang chọn
//  Tab Tuần  → chọn TuanTkb → hiển thị grid 7 cột
//
// ============================================================
//  CONFLICT DETECTION (xử lý hoàn toàn trong VIEW, không đổi model/controller):
//
//  Nguyên tắc phát hiện trùng:
//    Hai tiết A, B trùng nhau khi chúng cùng ngày VÀ:
//      A.tietBatDau <= (B.tietBatDau + B.soTiet - 1)
//      AND B.tietBatDau <= (A.tietBatDau + A.soTiet - 1)
//    Tức là các khoảng [tietBatDau, tietBatDau+soTiet-1] có phần giao nhau.
//
//  Tab Ngày:
//    - _findConflictIndices(list) → Set<int> index của các tiết trùng trong ngày
//    - Hiển thị _ConflictBanner ở đầu danh sách nếu có trùng
//    - _LessonCard nhận isConflict=true → viền đỏ + badge "Trùng lịch"
//    - _WeekStrip: ngày có trùng → chấm đỏ thay vì chấm xanh
//
//  Tab Tuần:
//    - _WeekGrid._findWeekConflicts() → Set<ThoiKhoaBieu> các tiết bị trùng
//    - Group by thu → detect overlap trong từng cột ngày
//    - Header column có trùng → highlight đỏ nhẹ
//    - _GridBlock nhận isConflict=true → viền đỏ + icon ⚠
//
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// ── Import từ dự án thực ─────────────────────────────────────
import '../models/schedure_student.dart';
import '../controllers/ctrl_schedure.dart';

// ─────────────────────────────────────────────────────────────
// CONSTANTS
// ─────────────────────────────────────────────────────────────

const Color kPrimary = Color(0xFF0047A8);
const Color kPrimaryLight = Color(0xFFE8F0FE);
const Color kPrimaryDark = Color(0xFF003580);
const Color kBg = Color(0xFFF4F7FD);
const Color kCardBg = Colors.white;
const Color kMorning = Color(0xFFEDF4FF); // sáng
const Color kAfternoon = Color(0xFFE6F9F0); // chiều/tối
const Color kBorderLight = Color(0xFFDDE6F5);

// ── Màu cảnh báo trùng tiết ──────────────────────────────────
const Color kConflict = Color(0xFFD32F2F);
const Color kConflictBg = Color(0xFFFFF5F5);
const Color kConflictBorder = Color(0xFFFFCDD2);
const Color kConflictAccent = Color(0xFFFFEBEE);

const double kRadius = 14.0;
const double kRadiusSm = 10.0;
const double kRowH = 54.0; // chiều cao 1 tiết trong grid tuần
const double kTimeColW = 56.0;

// ─────────────────────────────────────────────────────────────
// DATE HELPER (view-level)
// ─────────────────────────────────────────────────────────────

final DateFormat _ddMMyyyyFmt = DateFormat('dd/MM/yyyy');

/// Parse linh hoạt: thử ISO trước, fallback dd/MM/yyyy
DateTime? _parseDate(String? raw) {
  if (raw == null || raw.trim().isEmpty) return null;
  final s = raw.trim();
  try {
    return DateTime.parse(s);
  } catch (_) {}
  try {
    return _ddMMyyyyFmt.parse(s);
  } catch (_) {}
  return null;
}

/// So sánh chỉ phần ngày (năm/tháng/ngày), bỏ qua giờ
bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

// ─────────────────────────────────────────────────────────────
// CONFLICT DETECTION HELPERS
// ─────────────────────────────────────────────────────────────

/// Kiểm tra 2 tiết học có chồng thời gian không (so sánh khoảng số tiết)
bool _tietsOverlap(ThoiKhoaBieu a, ThoiKhoaBieu b) {
  final aEnd = a.tietBatDau + a.soTiet - 1;
  final bEnd = b.tietBatDau + b.soTiet - 1;
  return a.tietBatDau <= bEnd && b.tietBatDau <= aEnd;
}

/// Trả về set INDEX của các tiết bị trùng trong danh sách (cùng ngày).
/// O(n²) với n nhỏ (thường < 10 tiết/ngày) → chấp nhận được.
Set<int> _findConflictIndices(List<ThoiKhoaBieu> list) {
  final conflicts = <int>{};
  for (int i = 0; i < list.length; i++) {
    for (int j = i + 1; j < list.length; j++) {
      if (_tietsOverlap(list[i], list[j])) {
        conflicts.add(i);
        conflicts.add(j);
      }
    }
  }
  return conflicts;
}

/// Trả về true nếu danh sách có ít nhất 1 cặp tiết trùng
bool _hasConflictInList(List<ThoiKhoaBieu> list) {
  for (int i = 0; i < list.length; i++) {
    for (int j = i + 1; j < list.length; j++) {
      if (_tietsOverlap(list[i], list[j])) return true;
    }
  }
  return false;
}

// ─────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────

/// Nhãn thứ trong tuần: 2→"T2", 7→"T7", 8→"CN"
String _thuLabel(int thu) {
  if (thu == 8 || thu == 1) return "CN";
  return "T$thu";
}

/// Tra giờ từ periodMap (dsTietTrongNgay của API)
String _gioStart(Map<int, TietTrongNgay> map, int tiet) =>
    map[tiet]?.gioBatDau ?? "—";

String _gioEnd(Map<int, TietTrongNgay> map, int tietBatDau, int soTiet) {
  final lastTiet = tietBatDau + soTiet - 1;
  return map[lastTiet]?.gioKetThuc ?? "—";
}

bool _isBuoiSang(Map<int, TietTrongNgay> map, int tietBatDau) {
  final gio = map[tietBatDau]?.gioBatDau ?? "";
  if (gio.isEmpty) return tietBatDau <= 5;
  final hour = int.tryParse(gio.split(":").first) ?? 0;
  return hour < 12;
}

/// So sánh ngày với hôm nay → "today" | "past" | "upcoming"
String _dayStatus(String ngayhoc) {
  if (ngayhoc.isEmpty) return "upcoming";
  final d = _parseDate(ngayhoc);
  if (d == null) return "upcoming";
  final today = DateTime.now();
  final todayMidnight = DateTime(today.year, today.month, today.day);
  final dMidnight = DateTime(d.year, d.month, d.day);
  if (dMidnight == todayMidnight) return "today";
  if (dMidnight.isBefore(todayMidnight)) return "past";
  return "upcoming";
}

// ─────────────────────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────────────────────

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with TickerProviderStateMixin {
  // ── State ────────────────────────────────────────────────
  late TabController _tabCtrl;
  DateTime _selectedDate = DateTime.now();
  final DateTime _today = DateTime.now();

  // Dữ liệu từ Controller
  TkbResponse? _tkbResponse;
  Map<int, TietTrongNgay> _periodMap = {};
  List<ThoiKhoaBieu> _allItems = [];

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _fetchData();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  // ── Data Fetching ─────────────────────────────────────────
  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final ctrl = await CtrlSchedure.create();
      final response = await ctrl.getFullTkbResponse();

      if (!mounted) return;

      if (response == null) {
        setState(() {
          _error = "Không thể tải dữ liệu";
          _loading = false;
        });
        return;
      }

      // Xây period map: tiet → TietTrongNgay (dùng tra giờ động)
      final map = <int, TietTrongNgay>{};
      for (final t in response.dsTietTrongNgay) {
        map[t.tiet] = t;
      }

      // Flat list toàn bộ buổi học
      final all = response.dsTuanTkb
          .expand((tuan) => tuan.dsThoiKhoaBieu)
          .toList();

      setState(() {
        _tkbResponse = response;
        _periodMap = map;
        _allItems = all;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  // ── Helpers ───────────────────────────────────────────────
  bool _hasLesson(DateTime date) {
    return _allItems.any((s) {
      final d = _parseDate(s.ngayhoc);
      return d != null && _isSameDay(d, date);
    });
  }

  List<ThoiKhoaBieu> _scheduleForDay(DateTime date) {
    return _allItems.where((s) {
      final d = _parseDate(s.ngayhoc);
      return d != null && _isSameDay(d, date);
    }).toList()..sort((a, b) => a.tietBatDau.compareTo(b.tietBatDau));
  }

  /// Kiểm tra ngày đó có tiết bị trùng không (dùng cho _WeekStrip + _DayTab)
  bool _hasConflict(DateTime date) {
    final list = _scheduleForDay(date);
    return _hasConflictInList(list);
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: kBg,
        body: Column(
          children: [
            _Header(
              tabCtrl: _tabCtrl,
              onTodayTap: () => setState(() => _selectedDate = _today),
            ),
            Expanded(
              child: _loading
                  ? const _LoadingState()
                  : _error != null
                  ? _ErrorState(message: _error!, onRetry: _fetchData)
                  : TabBarView(
                      controller: _tabCtrl,
                      children: [
                        // ── Tab Ngày ────────────────────
                        _DayTab(
                          selectedDate: _selectedDate,
                          today: _today,
                          periodMap: _periodMap,
                          hasLesson: _hasLesson,
                          hasConflict: _hasConflict,
                          scheduleForDay: _scheduleForDay,
                          onDateChanged: (d) =>
                              setState(() => _selectedDate = d),
                        ),
                        // ── Tab Tuần ────────────────────
                        _WeekTab(
                          tkbResponse: _tkbResponse,
                          periodMap: _periodMap,
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

// ─────────────────────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final TabController tabCtrl;
  final VoidCallback onTodayTap;

  const _Header({required this.tabCtrl, required this.onTodayTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimary, kPrimaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const Expanded(
                    child: Text(
                      "Thời Khóa Biểu",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onTodayTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.today, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            "Hôm nay",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 10),
              child: Container(
                width: 156,
                height: 36,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TabBar(
                  controller: tabCtrl,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelColor: kPrimary,
                  unselectedLabelColor: Colors.white,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: "Ngày"),
                    Tab(text: "Tuần"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TAB NGÀY
// ─────────────────────────────────────────────────────────────

class _DayTab extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime today;
  final Map<int, TietTrongNgay> periodMap;
  final bool Function(DateTime) hasLesson;
  final bool Function(DateTime)
  hasConflict; // [NEW] kiểm tra ngày có trùng tiết
  final List<ThoiKhoaBieu> Function(DateTime) scheduleForDay;
  final ValueChanged<DateTime> onDateChanged;

  const _DayTab({
    required this.selectedDate,
    required this.today,
    required this.periodMap,
    required this.hasLesson,
    required this.hasConflict,
    required this.scheduleForDay,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _WeekStrip(
          selectedDate: selectedDate,
          today: today,
          hasLesson: hasLesson,
          hasConflict: hasConflict, // [NEW] truyền xuống _WeekStrip
          onDateSelected: onDateChanged,
          onPrevWeek: () =>
              onDateChanged(selectedDate.subtract(const Duration(days: 7))),
          onNextWeek: () =>
              onDateChanged(selectedDate.add(const Duration(days: 7))),
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    final list = scheduleForDay(selectedDate);
    final isToday = _isSameDay(selectedDate, today);

    if (list.isEmpty) {
      return _EmptyState(
        message: isToday
            ? "Hôm nay không có lịch học"
            : "Không có lịch học ngày này",
        subMessage: isToday ? "Hãy tận hưởng ngày nghỉ của bạn 🎉" : null,
      );
    }

    // [NEW] Phát hiện tiết trùng trong ngày đang xem
    final conflictIndices = _findConflictIndices(list);
    final hasConflicts = conflictIndices.isNotEmpty;

    return Column(
      children: [
        // [NEW] Banner cảnh báo nếu có tiết trùng
        if (hasConflicts)
          _ConflictBanner(
            conflictCount: conflictIndices.length,
            names: conflictIndices.map((i) => list[i].tenMon).toList(),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            itemCount: list.length,
            itemBuilder: (ctx, i) => _LessonCard(
              item: list[i],
              isToday: isToday,
              periodMap: periodMap,
              isConflict: conflictIndices.contains(i), // [NEW]
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// [NEW] CONFLICT BANNER – hiển thị ở đầu danh sách ngày khi có trùng
// ─────────────────────────────────────────────────────────────

class _ConflictBanner extends StatelessWidget {
  final int conflictCount;
  final List<String> names;

  const _ConflictBanner({required this.conflictCount, required this.names});

  @override
  Widget build(BuildContext context) {
    // Deduplicate tên môn
    final uniqueNames = names.toSet().toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: kConflictAccent,
        borderRadius: BorderRadius.circular(kRadiusSm),
        border: Border.all(color: kConflict.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 1),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: kConflict.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: kConflict,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$conflictCount tiết bị trùng lịch trong ngày này",
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: kConflict,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  uniqueNames.join("  •  "),
                  style: TextStyle(
                    fontSize: 11,
                    color: kConflict.withOpacity(0.75),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WEEK STRIP (thanh 7 ngày) – [UPDATED] hiển thị chấm đỏ nếu ngày có trùng
// ─────────────────────────────────────────────────────────────

class _WeekStrip extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime today;
  final bool Function(DateTime) hasLesson;
  final bool Function(DateTime) hasConflict; // [NEW]
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPrevWeek;
  final VoidCallback onNextWeek;

  const _WeekStrip({
    required this.selectedDate,
    required this.today,
    required this.hasLesson,
    required this.hasConflict,
    required this.onDateSelected,
    required this.onPrevWeek,
    required this.onNextWeek,
  });

  @override
  Widget build(BuildContext context) {
    final mon = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));

    return Container(
      color: kCardBg,
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          // Month + Nav
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Row(
              children: [
                _NavBtn(icon: Icons.chevron_left, onTap: onPrevWeek),
                Expanded(
                  child: Center(
                    child: Text(
                      "Tháng ${selectedDate.month} / ${selectedDate.year}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: kPrimary,
                      ),
                    ),
                  ),
                ),
                _NavBtn(icon: Icons.chevron_right, onTap: onNextWeek),
              ],
            ),
          ),
          // 7 ngày
          Row(
            children: List.generate(7, (i) {
              final d = mon.add(Duration(days: i));
              final isSel = _isSameDay(d, selectedDate);
              final isTod = _isSameDay(d, today);
              final hasLes = hasLesson(d);
              final hasConf = hasConflict(d); // [NEW]

              return Expanded(
                child: GestureDetector(
                  onTap: () => onDateSelected(d),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      // [NEW] ngày có trùng + đang chọn → nền đỏ nhạt
                      color: isSel
                          ? (hasConf ? kConflict : kPrimary)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      // [NEW] ngày có trùng nhưng chưa chọn → viền đỏ nhẹ
                      border: (!isSel && hasConf)
                          ? Border.all(
                              color: kConflict.withOpacity(0.4),
                              width: 1,
                            )
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(
                          _thuLabel(d.weekday == 7 ? 8 : d.weekday + 1),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isSel
                                ? Colors.white.withOpacity(0.85)
                                : Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "${d.day}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isSel
                                ? Colors.white
                                : isTod
                                ? kPrimary
                                : hasConf
                                ? kConflict // [NEW] số ngày đỏ nếu có trùng
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // [NEW] Dot indicator: đỏ nếu có trùng, xanh nếu có lịch bình thường
                        AnimatedOpacity(
                          opacity: (hasLes || hasConf) ? 1 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isSel
                                  ? Colors.white
                                  : hasConf
                                  ? kConflict
                                  : kPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 2),
          const Divider(height: 1, color: kBorderLight),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: kPrimaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: kPrimary, size: 18),
    ),
  );
}

// ─────────────────────────────────────────────────────────────
// LESSON CARD (tab ngày) – [UPDATED] hiển thị trạng thái trùng tiết
// ─────────────────────────────────────────────────────────────

class _LessonCard extends StatelessWidget {
  final ThoiKhoaBieu item;
  final bool isToday;
  final Map<int, TietTrongNgay> periodMap;
  final bool isConflict; // [NEW]

  const _LessonCard({
    required this.item,
    required this.isToday,
    required this.periodMap,
    this.isConflict = false,
  });

  @override
  Widget build(BuildContext context) {
    final status = _dayStatus(item.ngayhoc);
    final isMorn = _isBuoiSang(periodMap, item.tietBatDau);
    final opacity = status == "past" ? 0.55 : 1.0;

    final gioStart = _gioStart(periodMap, item.tietBatDau);
    final gioEnd = _gioEnd(periodMap, item.tietBatDau, item.soTiet);

    // [NEW] màu nền và viền thay đổi theo isConflict
    final bgColor = isConflict
        ? kConflictBg
        : isMorn
        ? kMorning
        : kAfternoon;

    final borderDecoration = isConflict
        ? Border.all(color: kConflict.withOpacity(0.55), width: 1.5)
        : isToday
        ? Border.all(color: kPrimary.withOpacity(0.3), width: 1.5)
        : Border.all(color: kBorderLight, width: 1);

    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(kRadius),
          boxShadow: [
            BoxShadow(
              color: isConflict
                  ? kConflict.withOpacity(0.08)
                  : kPrimary.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          border: borderDecoration,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kRadius),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Cột thời gian ──────────────────────────
                Container(
                  width: 70,
                  color: bgColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // [NEW] icon ⚠ thay label sáng/chiều nếu bị trùng
                      if (isConflict)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: kConflict.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            color: kConflict,
                            size: 13,
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isMorn
                                ? kPrimary.withOpacity(0.1)
                                : Colors.teal.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isMorn ? "Sáng" : "Chiều",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: isMorn ? kPrimary : Colors.teal[700],
                            ),
                          ),
                        ),
                      const SizedBox(height: 6),
                      Text(
                        gioStart,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: isConflict ? kConflict : Colors.black87,
                        ),
                      ),
                      Container(
                        width: 16,
                        height: 1.5,
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        color: isConflict
                            ? kConflict.withOpacity(0.3)
                            : Colors.grey[300],
                      ),
                      Text(
                        gioEnd,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isConflict
                              ? kConflict.withOpacity(0.7)
                              : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                // Separator
                Container(
                  width: 1,
                  color: isConflict ? kConflict.withOpacity(0.2) : kBorderLight,
                ),

                // ── Nội dung chính ─────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên môn
                        Text(
                          item.tenMon,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isConflict ? kConflict : kPrimary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 9),

                        // Tiết học
                        _InfoRow(
                          icon: Icons.schedule_outlined,
                          text:
                              "Tiết ${item.tietBatDau}–${item.tietBatDau + item.soTiet - 1}"
                              "  (${item.soTiet} tiết)",
                          color: isConflict ? kConflict.withOpacity(0.8) : null,
                        ),
                        const SizedBox(height: 5),

                        // Phòng học
                        _InfoRow(
                          icon: Icons.meeting_room_outlined,
                          text: "Phòng ${item.phong}",
                        ),
                        const SizedBox(height: 5),

                        // Giảng viên
                        _InfoRow(
                          icon: Icons.person_outline,
                          text: item.giangVien,
                          color: Colors.green[700]!,
                        ),

                        const SizedBox(height: 8),
                        // [NEW] Badge "Trùng lịch" khi bị conflict
                        if (isConflict)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: kConflict.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: kConflict.withOpacity(0.25),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  size: 10,
                                  color: kConflict,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Trùng lịch",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: kConflict,
                                  ),
                                ),
                              ],
                            ),
                          )
                        // Badge "Hôm nay" bình thường
                        else if (isToday)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle, size: 6, color: kPrimary),
                                SizedBox(width: 4),
                                Text(
                                  "Hôm nay",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: kPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  const _InfoRow({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Colors.black54;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(icon, size: 13, color: c),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: c,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TAB TUẦN
// ─────────────────────────────────────────────────────────────

class _WeekTab extends StatefulWidget {
  final TkbResponse? tkbResponse;
  final Map<int, TietTrongNgay> periodMap;

  const _WeekTab({required this.tkbResponse, required this.periodMap});

  @override
  State<_WeekTab> createState() => _WeekTabState();
}

class _WeekTabState extends State<_WeekTab> {
  TuanTkb? _selectedWeek;

  @override
  void initState() {
    super.initState();
    _autoSelectCurrentWeek();
  }

  @override
  void didUpdateWidget(_WeekTab old) {
    super.didUpdateWidget(old);
    if (old.tkbResponse != widget.tkbResponse) _autoSelectCurrentWeek();
  }

  void _autoSelectCurrentWeek() {
    final tuanList = widget.tkbResponse?.dsTuanTkb;
    if (tuanList == null || tuanList.isEmpty) return;

    final now = DateTime.now();
    final nowMidnight = DateTime(now.year, now.month, now.day);

    TuanTkb? found;
    for (final t in tuanList) {
      final start = _parseDate(t.ngayBatDau);
      final end = _parseDate(t.ngayKetThuc);
      if (start == null || end == null) continue;
      final startM = DateTime(start.year, start.month, start.day);
      final endM = DateTime(end.year, end.month, end.day);
      if (!nowMidnight.isBefore(startM) && !nowMidnight.isAfter(endM)) {
        found = t;
        break;
      }
    }

    setState(() => _selectedWeek = found ?? tuanList.first);
  }

  void _pickWeek() {
    final tuanList = widget.tkbResponse?.dsTuanTkb;
    if (tuanList == null || tuanList.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _WeekPicker(
        tuanList: tuanList,
        selected: _selectedWeek,
        onPick: (t) => setState(() => _selectedWeek = t),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tkb = widget.tkbResponse;

    return Column(
      children: [
        // ── Selector bar ─────────────────────────────────
        Container(
          color: kCardBg,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (tkb != null) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: kPrimaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.school_outlined,
                            size: 13,
                            color: kPrimary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Tổng ${tkb.totalItems} buổi  •  ${tkb.totalPages} trang",
                            style: const TextStyle(
                              fontSize: 11,
                              color: kPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              // Chọn tuần
              GestureDetector(
                onTap: tkb != null ? _pickWeek : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: kBg,
                    borderRadius: BorderRadius.circular(kRadiusSm),
                    border: Border.all(color: kBorderLight),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: kPrimary,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedWeek != null
                              ? "Tuần ${_selectedWeek!.tuanHocKy}  •  ${_selectedWeek!.thongTinTuan}"
                              : "Chọn tuần học",
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: tkb != null
                            ? Colors.grey[600]
                            : Colors.grey[300],
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: kBorderLight),

        // ── Week Grid ─────────────────────────────────────
        Expanded(
          child: _selectedWeek == null
              ? const _EmptyState(message: "Chọn tuần để xem lịch học")
              : _WeekGrid(week: _selectedWeek!, periodMap: widget.periodMap),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WEEK PICKER (bottom sheet)
// ─────────────────────────────────────────────────────────────

class _WeekPicker extends StatelessWidget {
  final List<TuanTkb> tuanList;
  final TuanTkb? selected;
  final ValueChanged<TuanTkb> onPick;

  const _WeekPicker({
    required this.tuanList,
    required this.selected,
    required this.onPick,
  });

  bool _isCurrent(TuanTkb t) {
    final start = _parseDate(t.ngayBatDau);
    final end = _parseDate(t.ngayKetThuc);
    if (start == null || end == null) return false;
    final now = DateTime.now();
    final nowM = DateTime(now.year, now.month, now.day);
    final startM = DateTime(start.year, start.month, start.day);
    final endM = DateTime(end.year, end.month, end.day);
    return !nowM.isBefore(startM) && !nowM.isAfter(endM);
  }

  /// [NEW] Kiểm tra tuần có tiết trùng không (hiển thị warning trong picker)
  bool _weekHasConflict(TuanTkb t) {
    final byThu = <int, List<ThoiKhoaBieu>>{};
    for (final s in t.dsThoiKhoaBieu) {
      byThu.putIfAbsent(s.thu, () => []).add(s);
    }
    for (final list in byThu.values) {
      if (_hasConflictInList(list)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      maxChildSize: 0.88,
      minChildSize: 0.35,
      expand: false,
      builder: (ctx, ctrl) => Container(
        decoration: const BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Chọn tuần học",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const Divider(height: 20),
            Expanded(
              child: ListView.builder(
                controller: ctrl,
                itemCount: tuanList.length,
                itemBuilder: (_, i) {
                  final t = tuanList[i];
                  final isSel = t == selected;
                  final isCur = _isCurrent(t);
                  final hasConf = _weekHasConflict(t); // [NEW]

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      backgroundColor: hasConf
                          ? kConflict.withOpacity(0.1)
                          : isCur
                          ? Colors.orange.withOpacity(0.15)
                          : isSel
                          ? kPrimaryLight
                          : kBg,
                      child: Text(
                        "${t.tuanHocKy}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: hasConf
                              ? kConflict
                              : isCur
                              ? Colors.orange[700]
                              : isSel
                              ? kPrimary
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                    title: Text(
                      t.thongTinTuan,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        color: isSel ? kPrimary : Colors.black87,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          "${t.dsThoiKhoaBieu.length} buổi học",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                        // [NEW] badge trùng tiết trong picker
                        if (hasConf) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: kConflict.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  size: 9,
                                  color: kConflict,
                                ),
                                SizedBox(width: 2),
                                Text(
                                  "Có trùng tiết",
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: kConflict,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    trailing: isSel
                        ? const Icon(
                            Icons.check_circle,
                            color: kPrimary,
                            size: 20,
                          )
                        : isCur
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "Tuần hiện tại",
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.orange,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : null,
                    onTap: () {
                      onPick(t);
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WEEK GRID – [UPDATED] phát hiện và highlight trùng tiết theo cột ngày
// ─────────────────────────────────────────────────────────────

class _WeekGrid extends StatelessWidget {
  final TuanTkb week;
  final Map<int, TietTrongNgay> periodMap;

  const _WeekGrid({required this.week, required this.periodMap});

  // ── [NEW] Phát hiện tiết trùng trong tuần, group theo thu ──
  /// Trả về Set các ThoiKhoaBieu bị trùng (so sánh theo object reference)
  Set<ThoiKhoaBieu> _findWeekConflicts() {
    // Group by thu (ngày trong tuần)
    final byThu = <int, List<ThoiKhoaBieu>>{};
    for (final s in week.dsThoiKhoaBieu) {
      byThu.putIfAbsent(s.thu, () => []).add(s);
    }

    // Trong từng thu-group: tìm các cặp overlap
    final conflicts = <ThoiKhoaBieu>{};
    for (final list in byThu.values) {
      for (int i = 0; i < list.length; i++) {
        for (int j = i + 1; j < list.length; j++) {
          if (_tietsOverlap(list[i], list[j])) {
            conflicts.add(list[i]);
            conflicts.add(list[j]);
          }
        }
      }
    }
    return conflicts;
  }

  /// Tập hợp chỉ số cột (0–6) có tiết trùng
  Set<int> _conflictCols(Set<ThoiKhoaBieu> conflicts) {
    return conflicts.map((s) {
      int col = s.thu - 2;
      if (col < 0 || col > 6) col = 6;
      return col;
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final maxTiet = _calcMaxTiet();

    DateTime? firstDay;
    if (week.ngayBatDau.isNotEmpty) {
      firstDay = _parseDate(week.ngayBatDau);
    }

    // [NEW] Tính conflicts một lần, dùng cho header và blocks
    final weekConflicts = _findWeekConflicts();
    final conflictCols = _conflictCols(weekConflicts);

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildDayHeader(firstDay, conflictCols), // [NEW] pass conflictCols
          SizedBox(
            height: kRowH * maxTiet,
            child: Stack(
              children: [
                _buildGridLines(maxTiet),
                ..._buildBlocks(
                  context,
                  maxTiet,
                  weekConflicts,
                ), // [NEW] pass conflicts
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calcMaxTiet() {
    if (week.dsThoiKhoaBieu.isEmpty) return 10;
    int max = 10;
    for (final s in week.dsThoiKhoaBieu) {
      final last = s.tietBatDau + s.soTiet - 1;
      if (last > max) max = last;
    }
    return max + 1;
  }

  // [UPDATED] _buildDayHeader nhận conflictCols để highlight cột có trùng
  Widget _buildDayHeader(DateTime? firstDay, Set<int> conflictCols) {
    final today = DateTime.now();
    return Container(
      height: 44,
      color: kPrimary,
      child: Row(
        children: [
          SizedBox(width: kTimeColW),
          ...List.generate(7, (i) {
            final hasConf = conflictCols.contains(i); // [NEW]
            String label = _dayLabels[i];

            if (firstDay != null) {
              final d = firstDay.add(Duration(days: i));
              final isToday = _isSameDay(d, today);
              label = "${_dayLabels[i]}\n${d.day}/${d.month}";

              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    // [NEW] cột có trùng tiết → nền đỏ nhạt trên header
                    color: hasConf
                        ? kConflict.withOpacity(0.25)
                        : isToday
                        ? Colors.white.withOpacity(0.15)
                        : Colors.transparent,
                    border: Border(
                      right: BorderSide(color: Colors.white.withOpacity(0.12)),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: isToday
                                ? Colors.white
                                : Colors.white.withOpacity(0.85),
                            height: 1.5,
                          ),
                        ),
                        // [NEW] icon ⚠ nhỏ dưới ngày nếu cột có trùng
                        if (hasConf)
                          const Padding(
                            padding: EdgeInsets.only(top: 1),
                            child: Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.white,
                              size: 9,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: hasConf
                      ? kConflict.withOpacity(0.25)
                      : Colors.transparent,
                  border: Border(
                    right: BorderSide(color: Colors.white.withOpacity(0.12)),
                  ),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  static const _dayLabels = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];

  Widget _buildGridLines(int maxTiet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cột tiết
        SizedBox(
          width: kTimeColW,
          child: Column(
            children: List.generate(maxTiet, (i) {
              final tiet = i + 1;
              final gio = periodMap[tiet]?.gioBatDau ?? "";
              return Container(
                height: kRowH,
                decoration: BoxDecoration(
                  color: kCardBg,
                  border: Border(
                    right: BorderSide(color: Colors.blue.shade100),
                    bottom: BorderSide(color: Colors.blue.shade50, width: 0.5),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$tiet",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: kPrimary,
                      ),
                    ),
                    if (gio.isNotEmpty)
                      Text(
                        gio,
                        style: TextStyle(fontSize: 8, color: Colors.grey[400]),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
        // 7 cột ngày
        ...List.generate(
          7,
          (di) => Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.blue.shade50)),
              ),
              child: Column(
                children: List.generate(
                  maxTiet,
                  (pi) => Container(
                    height: kRowH,
                    color: pi % 2 == 0
                        ? kCardBg
                        : Colors.blue.shade50.withOpacity(0.25),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // [UPDATED] _buildBlocks nhận weekConflicts để truyền isConflict vào _GridBlock
  List<Widget> _buildBlocks(
    BuildContext context,
    int maxTiet,
    Set<ThoiKhoaBieu> weekConflicts,
  ) {
    final sw = MediaQuery.of(context).size.width;
    final dayW = (sw - kTimeColW) / 7;

    return week.dsThoiKhoaBieu.map((s) {
      int col = s.thu - 2;
      if (col < 0 || col > 6) col = 6;

      final isMorn = _isBuoiSang(periodMap, s.tietBatDau);
      final isConflict = weekConflicts.contains(s); // [NEW]

      return Positioned(
        left: kTimeColW + col * dayW,
        top: (s.tietBatDau - 1) * kRowH,
        width: dayW,
        height: s.soTiet * kRowH,
        child: _GridBlock(
          subject: s,
          isMorning: isMorn,
          isConflict: isConflict, // [NEW]
        ),
      );
    }).toList();
  }
}

// ─────────────────────────────────────────────────────────────
// GRID BLOCK – [UPDATED] hiển thị trạng thái trùng tiết trong lưới tuần
// ─────────────────────────────────────────────────────────────

class _GridBlock extends StatelessWidget {
  final ThoiKhoaBieu subject;
  final bool isMorning;
  final bool isConflict; // [NEW]

  const _GridBlock({
    required this.subject,
    required this.isMorning,
    this.isConflict = false,
  });

  @override
  Widget build(BuildContext context) {
    // [NEW] Màu riêng cho block bị trùng
    final bg = isConflict
        ? const Color(0xFFFFEBEE)
        : isMorning
        ? const Color(0xFFCCDFFF)
        : const Color(0xFFC5EDD9);

    final border = isConflict
        ? kConflict.withOpacity(0.55)
        : isMorning
        ? kPrimary.withOpacity(0.35)
        : Colors.teal.withOpacity(0.4);

    final textColor = isConflict
        ? kConflict
        : isMorning
        ? kPrimary
        : Colors.teal[800]!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border, width: isConflict ? 1.5 : 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // [NEW] Icon cảnh báo nhỏ ở góc phải nếu bị trùng
            if (isConflict)
              Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 9,
                  color: kConflict.withOpacity(0.85),
                ),
              ),
            Expanded(
              child: Text(
                subject.tenMon,
                style: TextStyle(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  height: 1.3,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: isConflict ? 4 : 5,
              ),
            ),
            if (subject.soTiet >= 3)
              Text(
                subject.phong,
                style: TextStyle(
                  fontSize: 7.5,
                  color: textColor.withOpacity(0.75),
                ),
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STATE WIDGETS
// ─────────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(color: kPrimary, strokeWidth: 2.5),
          ),
          const SizedBox(height: 16),
          Text(
            "Đang tải lịch học...",
            style: TextStyle(color: Colors.grey[500], fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final String? subMessage;

  const _EmptyState({required this.message, this.subMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: kPrimaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                size: 36,
                color: kPrimary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            if (subMessage != null) ...[
              const SizedBox(height: 6),
              Text(
                subMessage!,
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorState({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_outlined,
                size: 36,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Không thể tải dữ liệu",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text("Thử lại"),
                style: TextButton.styleFrom(
                  foregroundColor: kPrimary,
                  backgroundColor: kPrimaryLight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// HOME WIDGET – card nhỏ trên trang chủ
// Dùng CtrlSchedure.getTkbToday() → List<ThoiKhoaBieu>
// ─────────────────────────────────────────────────────────────

class ScheduleHomeCard extends StatefulWidget {
  const ScheduleHomeCard({super.key});

  @override
  State<ScheduleHomeCard> createState() => _ScheduleHomeCardState();
}

class _ScheduleHomeCardState extends State<ScheduleHomeCard> {
  late Future<List<ThoiKhoaBieu>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadToday();
  }

  Future<List<ThoiKhoaBieu>> _loadToday() async {
    final ctrl = await CtrlSchedure.create();
    return ctrl.getTkbToday();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(kRadius),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.calendar_today, color: kPrimary, size: 16),
                  SizedBox(width: 8),
                  Text(
                    "Thời Khóa Biểu",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScheduleScreen()),
                ),
                child: const Row(
                  children: [
                    Text(
                      "Xem thêm",
                      style: TextStyle(
                        fontSize: 12,
                        color: kPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.arrow_forward_ios, size: 11, color: kPrimary),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(
            DateFormat('EEEE, dd/MM/yyyy', 'vi').format(DateTime.now()),
            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
          ),
          const SizedBox(height: 12),

          // Content
          SizedBox(
            height: 140,
            child: FutureBuilder<List<ThoiKhoaBieu>>(
              future: _future,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: kPrimary,
                      strokeWidth: 2,
                    ),
                  );
                }
                if (snap.hasError) {
                  return Center(
                    child: Text(
                      "Không tải được lịch",
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                  );
                }
                final list = snap.data ?? [];
                if (list.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.weekend_outlined,
                        size: 36,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Hôm nay không có lịch học",
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  );
                }

                // [NEW] Phát hiện trùng tiết trong danh sách hôm nay
                final conflictIndices = _findConflictIndices(list);

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (_, i) => _HomeCard(
                    item: list[i],
                    isConflict: conflictIndices.contains(i), // [NEW]
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final ThoiKhoaBieu item;
  final bool isConflict; // [NEW]
  const _HomeCard({required this.item, this.isConflict = false});

  @override
  Widget build(BuildContext context) {
    final isMorn = item.tietBatDau <= 5;

    // [NEW] Màu khác nhau theo trạng thái conflict
    final bg = isConflict
        ? kConflictAccent
        : isMorn
        ? kMorning
        : kAfternoon;

    final borderColor = isConflict
        ? kConflict.withOpacity(0.4)
        : isMorn
        ? kPrimary.withOpacity(0.2)
        : Colors.teal.withOpacity(0.2);

    return Container(
      width: 165,
      margin: const EdgeInsets.only(right: 10, top: 2, bottom: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(kRadiusSm),
        border: Border.all(color: borderColor, width: isConflict ? 1.5 : 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // [NEW] Badge trùng lịch trên HomeCard
          if (isConflict)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: kConflict.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 9,
                      color: kConflict,
                    ),
                    SizedBox(width: 3),
                    Text(
                      "Trùng lịch",
                      style: TextStyle(
                        fontSize: 9,
                        color: kConflict,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: Text(
              item.tenMon,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: isConflict ? kConflict : kPrimary,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.schedule_outlined, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                "Tiết ${item.tietBatDau}  (${item.soTiet} tiết)",
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.meeting_room_outlined,
                size: 12,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  "Phòng ${item.phong}",
                  style: const TextStyle(fontSize: 11, color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.giangVien,
                  style: const TextStyle(fontSize: 10, color: Colors.blueGrey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
