import 'package:aqedu/features/schedure/controllers/ctrl_schedure.dart';
import 'package:aqedu/features/schedure/models/Schedure_Student.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// ─────────────────────────────────────────────
//  Palette & helpers
// ─────────────────────────────────────────────
const _navy = Color(0xff0A1F5C);
const _navyLight = Color(0xff1740A6);
const _accent = Color(0xff4F8EF7);
const _accentGlow = Color(0xff7BB3FF);
const _surface = Color(0xffF0F4FF);
const _cardBg = Colors.white;
const _gold = Color(0xffFFB020);
const _green = Color(0xff22C97A);
const _rose = Color(0xffFF6B8A);

// Màu card theo tiết (sáng/chiều/tối)
Color _sessionColor(int tietBatDau) {
  if (tietBatDau <= 5) return _accent;
  if (tietBatDau <= 9) return _green;
  return _rose;
}

String _sessionLabel(int tietBatDau) {
  if (tietBatDau <= 5) return 'Sáng';
  if (tietBatDau <= 9) return 'Chiều';
  return 'Tối';
}

// Thời gian bắt đầu theo tiết
String _startTime(int tiet) {
  const times = {
    1: '07:00',
    2: '07:55',
    3: '08:50',
    4: '09:55',
    5: '10:50',
    6: '12:45',
    7: '13:40',
    8: '14:35',
    9: '15:30',
    10: '17:25',
    11: '18:15',
    12: '19:05',
  };
  return times[tiet] ?? '--:--';
}

// Thời gian kết thúc theo tiết
String _endTime(int tiet, int soTiet) {
  final end = tiet + soTiet - 1;
  const endTimes = {
    1: '07:50',
    2: '08:45',
    3: '09:40',
    4: '10:45',
    5: '11:40',
    6: '13:35',
    7: '14:30',
    8: '15:25',
    9: '17:20',
    10: '18:10',
    11: '19:00',
    12: '19:50',
  };
  return endTimes[end] ?? '--:--';
}

// Kiểm tra tiết đang diễn ra
bool _isNow(int tiet, int soTiet) {
  final now = TimeOfDay.now();
  final start = _startTime(tiet).split(':');
  final end = _endTime(tiet, soTiet).split(':');

  if (start.length != 2 || end.length != 2) return false;

  final nowMin = now.hour * 60 + now.minute;
  final startMin = int.parse(start[0]) * 60 + int.parse(start[1]);
  final endMin = int.parse(end[0]) * 60 + int.parse(end[1]);

  return nowMin >= startMin && nowMin <= endMin;
}

bool _isPast(int tiet, int soTiet) {
  final now = TimeOfDay.now();
  final end = _endTime(tiet, soTiet).split(':');

  if (end.length != 2) return false;

  final nowMin = now.hour * 60 + now.minute;
  final endMin = int.parse(end[0]) * 60 + int.parse(end[1]);

  return nowMin > endMin;
}

// ─────────────────────────────────────────────
//  Main View
// ─────────────────────────────────────────────
class TodayScheduleView extends StatefulWidget {
  const TodayScheduleView({super.key});

  @override
  State<TodayScheduleView> createState() => _TodayScheduleViewState();
}

class _TodayScheduleViewState extends State<TodayScheduleView>
    with TickerProviderStateMixin {
  late Future<ThoiKhoaBieu> _future;
  final DateTime today = DateTime.now();
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi');
    _future = _loadData();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<ThoiKhoaBieu> _loadData() async {
    final ctrl = await CtrlSchedure.create();
    ThoiKhoaBieu data = await ctrl.getTkbTodayItem();
    
    return data;
  }

  bool _isEmptyItem(ThoiKhoaBieu item) {
    return item.soTiet == 0 ||
        item.tenMon.trim().isEmpty ||
        item.tenMon == "Không có lịch học hôm nay";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: CustomScrollView(
        slivers: [
          _SliverHeader(today: today),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
            sliver: FutureBuilder<ThoiKhoaBieu>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(child: _LoadingView());
                }

                if (snapshot.hasError) {
                  return const SliverFillRemaining(child: _ErrorView());
                }

                final item = snapshot.data;
                if (item == null || _isEmptyItem(item)) {
                  return const SliverFillRemaining(child: _EmptyView());
                }

                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _ScheduleCard(
                      item: item,
                      index: 0,
                      isLast: true,
                      pulseCtrl: _pulseCtrl,
                    ),
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

// ─────────────────────────────────────────────
//  Sliver AppBar / Header
// ─────────────────────────────────────────────
class _SliverHeader extends StatelessWidget {
  final DateTime today;
  const _SliverHeader({required this.today});

  String _thuViet(int weekday) {
    const names = [
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
      'Chủ Nhật',
    ];
    return names[(weekday - 1) % 7];
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      stretch: true,
      backgroundColor: _navy,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "Lịch học hôm nay",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      centerTitle: false,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_navy, _navyLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              right: -40,
              top: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _accentGlow.withOpacity(0.12),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _gold.withOpacity(0.10),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _gold.withOpacity(0.20),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _gold.withOpacity(0.4)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.today_rounded, size: 13, color: _gold),
                            SizedBox(width: 5),
                            Text(
                              'HÔM NAY',
                              style: TextStyle(
                                color: _gold,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _thuViet(today.weekday),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMMM, yyyy', 'vi').format(today),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Schedule Card
// ─────────────────────────────────────────────
class _ScheduleCard extends StatefulWidget {
  final ThoiKhoaBieu item;
  final int index;
  final bool isLast;
  final AnimationController pulseCtrl;

  const _ScheduleCard({
    required this.item,
    required this.index,
    required this.isLast,
    required this.pulseCtrl,
  });

  @override
  State<_ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<_ScheduleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + widget.index * 80),
    );
    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final color = _sessionColor(item.tietBatDau);
    final isNow = _isNow(item.tietBatDau, item.soTiet);
    final isPast = _isPast(item.tietBatDau, item.soTiet);
    final startT = _startTime(item.tietBatDau);
    final endT = _endTime(item.tietBatDau, item.soTiet);
    final session = _sessionLabel(item.tietBatDau);

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TimelineColumn(
              color: color,
              isNow: isNow,
              isPast: isPast,
              isLast: widget.isLast,
              pulseCtrl: widget.pulseCtrl,
              startTime: startT,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 4, bottom: 18),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: isNow ? Border.all(color: color, width: 1.5) : null,
                  boxShadow: [
                    BoxShadow(
                      color: isNow
                          ? color.withOpacity(0.18)
                          : Colors.black.withOpacity(0.06),
                      blurRadius: isNow ? 20 : 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 5,
                        decoration: BoxDecoration(
                          color: isPast ? Colors.grey.shade300 : color,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item.tenMon,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: isPast
                                        ? Colors.grey.shade400
                                        : _navy,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _SessionBadge(
                                label: session,
                                color: isPast ? Colors.grey : color,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              _InfoChip(
                                icon: Icons.schedule_rounded,
                                label: '$startT – $endT',
                                color: isPast ? Colors.grey : color,
                              ),
                              _InfoChip(
                                icon: Icons.meeting_room_rounded,
                                label: item.phong,
                                color: isPast ? Colors.grey : _navyLight,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Tiết ',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              Wrap(
                                spacing: 4,
                                children: List.generate(
                                  item.soTiet,
                                  (i) => _TietBadge(
                                    label: '${item.tietBatDau + i}',
                                    color: isPast
                                        ? Colors.grey.shade300
                                        : color,
                                    textColor: isPast
                                        ? Colors.grey.shade400
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Divider(height: 1, color: Colors.grey.shade100),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor: isPast
                                    ? Colors.grey.shade200
                                    : color.withOpacity(0.12),
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 14,
                                  color: isPast ? Colors.grey : color,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Giảng viên',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      item.giangVien,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: isPast
                                            ? Colors.grey.shade400
                                            : _navy,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isNow)
                                AnimatedBuilder(
                                  animation: widget.pulseCtrl,
                                  builder: (_, __) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _green.withOpacity(
                                        0.1 + 0.1 * widget.pulseCtrl.value,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: _green,
                                        width: 1,
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: 6,
                                          color: _green,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'ĐANG HỌC',
                                          style: TextStyle(
                                            color: _green,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (isPast && !isNow)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Đã xong',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
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
    );
  }
}

// ─────────────────────────────────────────────
//  Timeline Column
// ─────────────────────────────────────────────
class _TimelineColumn extends StatelessWidget {
  final Color color;
  final bool isNow, isPast, isLast;
  final AnimationController pulseCtrl;
  final String startTime;

  const _TimelineColumn({
    required this.color,
    required this.isNow,
    required this.isPast,
    required this.isLast,
    required this.pulseCtrl,
    required this.startTime,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      child: Column(
        children: [
          const SizedBox(height: 4),
          Text(
            startTime,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isPast ? Colors.grey.shade400 : _navy,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedBuilder(
            animation: pulseCtrl,
            builder: (_, __) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  if (isNow)
                    Container(
                      width: 28 + 6 * pulseCtrl.value,
                      height: 28 + 6 * pulseCtrl.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withOpacity(
                          0.15 * (1 - pulseCtrl.value * 0.5),
                        ),
                      ),
                    ),
                  Container(
                    width: isPast ? 12 : 18,
                    height: isPast ? 12 : 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPast ? Colors.grey.shade300 : color,
                      boxShadow: isNow
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.5),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: isNow
                        ? const Icon(
                            Icons.play_arrow_rounded,
                            size: 12,
                            color: Colors.white,
                          )
                        : isPast
                        ? null
                        : Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.white.withOpacity(0.8),
                          ),
                  ),
                ],
              );
            },
          ),
          if (!isLast)
            Container(
              width: 2,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    isPast ? Colors.grey.shade200 : color.withOpacity(0.4),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Micro-components
// ─────────────────────────────────────────────
class _SessionBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _SessionBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.3)),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    ),
  );
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 12, color: color),
      const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

class _TietBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _TietBadge({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    child: Text(
      label,
      style: TextStyle(
        color: textColor,
        fontSize: 9,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

// ─────────────────────────────────────────────
//  State Views
// ─────────────────────────────────────────────
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: _accent,
            backgroundColor: _accent.withOpacity(0.15),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Đang tải lịch học...',
          style: TextStyle(color: _navyLight, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

class _ErrorView extends StatelessWidget {
  const _ErrorView();

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _rose.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.cloud_off_rounded, size: 40, color: _rose),
        ),
        const SizedBox(height: 14),
        const Text(
          'Không thể tải dữ liệu',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: _navy,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Kiểm tra kết nối và thử lại',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
      ],
    ),
  );
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [_accent.withOpacity(0.1), Colors.transparent],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.weekend_rounded,
            size: 56,
            color: _accent.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Hôm nay không có lịch học',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 17,
            color: _navy,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Hãy tận hưởng ngày nghỉ nhé! 🎉',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
        ),
      ],
    ),
  );
}
