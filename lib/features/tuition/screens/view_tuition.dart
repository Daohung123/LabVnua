import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:aqedu/core/theme/app_theme.dart';
import 'package:aqedu/core/theme/app_text_styles.dart';

import '../controllers/controller_tuition_student.dart';
import '../models/model_data.dart';
import '../models/model_item.dart';

// ═══════════════════════════════════════════════════════════════════════════
// MAIN VIEW
// ═══════════════════════════════════════════════════════════════════════════

class HocPhiView extends StatefulWidget {
  const HocPhiView({super.key});

  @override
  State<HocPhiView> createState() => _HocPhiViewState();
}

class _HocPhiViewState extends State<HocPhiView> {
  late Future<Data?> _futureData;
  String? _selectedHocKy;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _futureData = _fetchData();
    });
  }

  Future<Data?> _fetchData() async {
    final controller = await CtrlHocPhi.create();
    return controller.getHocPhiData();
  }

  List<HocPhiHocKy> _getFilteredList(List<HocPhiHocKy> list) {
    if (_selectedHocKy == null || _selectedHocKy!.isEmpty) return list;
    return list.where((e) => e.tenHocKy == _selectedHocKy).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: FutureBuilder<Data?>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _HpLoadingState();
            }

            if (snapshot.hasError) {
              return _HpErrorState(
                message: snapshot.error.toString(),
                onRetry: _loadData,
              );
            }

            final data = snapshot.data;
            if (data == null) {
              return _HpErrorState(
                message: 'Không có dữ liệu học phí.',
                icon: Icons.inbox_outlined,
                onRetry: _loadData,
              );
            }

            final allHocKyNames = data.dsHocPhiHocKy
                .map((e) => e.tenHocKy)
                .toSet()
                .toList();
            final filteredList = _getFilteredList(data.dsHocPhiHocKy);

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => _loadData(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  _HpAppBar(onRefresh: _loadData),
                  SliverToBoxAdapter(child: _HpSummarySection(data: data)),
                  SliverToBoxAdapter(
                    child: _HpFilterBar(
                      hocKyOptions: allHocKyNames,
                      selectedHocKy: _selectedHocKy,
                      onHocKyChanged: (val) =>
                          setState(() => _selectedHocKy = val),
                      onReset: () => setState(() => _selectedHocKy = null),
                    ),
                  ),
                  if (filteredList.isEmpty)
                    const SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 52,
                              color: AppColors.textMuted,
                            ),
                            SizedBox(height: AppSpacing.md),
                            Text(
                              'Không tìm thấy học kỳ phù hợp',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        0,
                        AppSpacing.lg,
                        AppSpacing.xxl40,
                      ),
                      sliver: SliverList.separated(
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) =>
                            _HpSemesterCard(item: filteredList[index]),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// APP BAR
// ═══════════════════════════════════════════════════════════════════════════

class _HpAppBar extends StatelessWidget {
  final VoidCallback onRefresh;
  const _HpAppBar({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 110,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
      shadowColor: AppColors.transparent,
      actions: [],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          56,
          AppSpacing.md14,
        ),
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Học Phí',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 21,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              'Thông tin học phí sinh viên',
              style: TextStyle(
                color: AppColors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        background: Container(
          decoration: const BoxDecoration(color: AppColors.primary),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withOpacity(AppOpacity.bg10),
                  ),
                ),
              ),
              Positioned(
                right: 50,
                bottom: 10,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white.withOpacity(AppOpacity.bg10 - 0.01),
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

// ═══════════════════════════════════════════════════════════════════════════
// SUMMARY SECTION
// ═══════════════════════════════════════════════════════════════════════════

class _HpSummarySection extends StatelessWidget {
  final Data data;
  const _HpSummarySection({required this.data});

  double _parseNum(dynamic val) {
    if (val == null) return 0;
    if (val is num) return val.toDouble();
    final str = val.toString().replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(str) ?? 0;
  }

  String _formatCurrency(double value) {
    if (value == 0) return '0 đ';
    final formatted = value
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');
    return '$formatted đ';
  }

  /// Xác định học kỳ gần nhất:
  /// 1. Ưu tiên sắp xếp theo trường `nhhk` (Năm Học Học Kỳ) giảm dần –
  ///    giá trị lớn hơn = kỳ gần hơn (ví dụ: "20242" > "20241" > "20232").
  /// 2. Nếu `nhhk` không parse được (null hoặc không phải số), fallback về
  ///    phần tử cuối cùng trong danh sách (API thường trả về thứ tự thời gian).
  HocPhiHocKy? _findLatestHocKy(List<HocPhiHocKy> list) {
    if (list.isEmpty) return null;

    final sorted = [...list];
    sorted.sort((a, b) {
      final aVal = int.tryParse(a.nhhk?.toString() ?? '') ?? 0;
      final bVal = int.tryParse(b.nhhk?.toString() ?? '') ?? 0;
      return bVal.compareTo(aVal); // giảm dần
    });

    final hasValidNhhk = sorted.any(
      (e) => (int.tryParse(e.nhhk?.toString() ?? '') ?? 0) > 0,
    );

    return hasValidNhhk ? sorted.first : list.last;
  }

  @override
  Widget build(BuildContext context) {
    final list = data.dsHocPhiHocKy;
    final latest = _findLatestHocKy(list);

    // Chỉ lấy số nợ của kỳ gần nhất
    final latestConNo = _parseNum(latest?.conNo);
    final isDebt = latestConNo > 0;

    // Tổng phải thu và đã thu (toàn bộ các kỳ, để làm thông tin phụ)
    double totalPhaiThu = 0, totalDaThu = 0;
    for (final item in list) {
      totalPhaiThu += _parseNum(item.phaiThu);
      totalDaThu += _parseNum(item.daThu);
    }

    return Container(
      color: AppColors.primary,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xl),
            topRight: Radius.circular(AppRadius.xl),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          20,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero: Công nợ kỳ gần nhất ───────────────────────
            if (latest != null)
              _DebtHeroCard(
                tenHocKy: latest.tenHocKy ?? '—',
                conNo: latestConNo,
                isDebt: isDebt,
                formatCurrency: _formatCurrency,
              ),

            // Fallback nếu không có dữ liệu học kỳ nào
            if (latest == null) _NoDataCard(),

            const SizedBox(height: AppSpacing.md),

            // ── Thống kê tổng (thông tin phụ) ───────────────────
            Row(
              children: [
                Expanded(
                  child: _MiniStatCard(
                    label: 'Tổng phải thu',
                    value: _formatCurrency(totalPhaiThu),
                    icon: Icons.account_balance_wallet_outlined,
                    color: AppColors.primary,
                    bg: AppColors.primaryLight,
                    footer: '${list.length} học kỳ',
                  ),
                ),
                const SizedBox(width: AppSpacing.sm10),
                Expanded(
                  child: _MiniStatCard(
                    label: 'Tổng đã thu',
                    value: _formatCurrency(totalDaThu),
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.success,
                    bg: AppColors.successLight,
                    footer: 'Đã thanh toán',
                  ),
                ),
              ],
            ),

            // ── Thông báo gia hạn (nếu có) ───────────────────────
            if (data.noiDungGiaHan != null &&
                data.noiDungGiaHan.toString().isNotEmpty)
              _ExtensionNotice(
                content: data.noiDungGiaHan.toString(),
                deadline: data.ngayGiaHan?.toString() ?? '',
              ),

            const SizedBox(height: AppSpacing.xs),
          ],
        ),
      ),
    );
  }
}

// ─── Hero card: nổi bật số nợ kỳ gần nhất ───────────────────────────────────

class _DebtHeroCard extends StatelessWidget {
  final String tenHocKy;
  final double conNo;
  final bool isDebt;
  final String Function(double) formatCurrency;

  const _DebtHeroCard({
    required this.tenHocKy,
    required this.conNo,
    required this.isDebt,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final cardColors = isDebt
        ? [AppColors.warning, AppColors.error]
        : [AppColors.success, AppColors.success];

    final shadowColor = isDebt
        ? AppColors.error.withOpacity(0.30)
        : AppColors.success.withOpacity(0.28);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cardColors,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle background
          Positioned(
            right: -16,
            top: -16,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withOpacity(AppOpacity.bg10 - 0.03),
              ),
            ),
          ),
          Positioned(
            right: 28,
            bottom: -20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withOpacity(AppOpacity.bg10 - 0.05),
              ),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(AppOpacity.bg18),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(
                      isDebt
                          ? Icons.warning_amber_rounded
                          : Icons.verified_rounded,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Công nợ kỳ gần nhất',
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.88),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xs + 2),

              // Tên học kỳ
              Text(
                tenHocKy,
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.65),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 18),

              // Số tiền – element nổi bật nhất
              Text(
                isDebt ? formatCurrency(conNo) : 'Không có công nợ',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 14),

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(AppOpacity.bg18),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.25),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDebt
                          ? Icons.error_outline_rounded
                          : Icons.check_circle_outline_rounded,
                      color: AppColors.white,
                      size: 13,
                    ),
                    const SizedBox(width: AppSpacing.xs + 1),
                    Text(
                      isDebt ? 'Cần thanh toán' : 'Đã thanh toán đầy đủ',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Fallback card khi không có dữ liệu học kỳ ─────────────────────────────

class _NoDataCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg + 4,
        vertical: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Column(
        children: [
          Icon(Icons.inbox_outlined, size: 40, color: AppColors.textMuted),
          SizedBox(height: AppSpacing.sm10),
          Text(
            'Chưa có dữ liệu học phí',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Mini stat card (thông tin phụ) ──────────────────────────────────────────

class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bg;
  final String footer;

  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bg,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(AppOpacity.bg10 - 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const Spacer(),
              Text(
                footer,
                style: TextStyle(
                  fontSize: 10.5,
                  color: color.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Extension notice ─────────────────────────────────────────────────────────

class _ExtensionNotice extends StatelessWidget {
  final String content;
  final String deadline;
  const _ExtensionNotice({required this.content, required this.deadline});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md14),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.warningLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.warning, size: 18),
          const SizedBox(width: AppSpacing.sm10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: const TextStyle(
                    color: AppColors.warning,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                if (deadline.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Hạn: $deadline',
                    style: const TextStyle(
                      color: AppColors.warning,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FILTER BAR
// ═══════════════════════════════════════════════════════════════════════════

class _HpFilterBar extends StatelessWidget {
  final List<String> hocKyOptions;
  final String? selectedHocKy;
  final ValueChanged<String?> onHocKyChanged;
  final VoidCallback onReset;

  const _HpFilterBar({
    required this.hocKyOptions,
    required this.selectedHocKy,
    required this.onHocKyChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final hasFilter = selectedHocKy != null && selectedHocKy!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Text(
                'Chi tiết theo học kỳ',
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Dropdown + reset
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(AppOpacity.hovered - 0.01),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedHocKy,
                    hint: const Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          'Tất cả học kỳ',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                        ),
                      ],
                    ),
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md14,
                        vertical: 13,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                      fillColor: AppColors.surface,
                      filled: true,
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text(
                          'Tất cả học kỳ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      ...hocKyOptions.map(
                        (hk) => DropdownMenuItem<String>(
                          value: hk,
                          child: Text(
                            hk,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    onChanged: onHocKyChanged,
                  ),
                ),
              ),
              if (hasFilter) ...[
                const SizedBox(width: AppSpacing.sm10),
                GestureDetector(
                  onTap: onReset,
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.error,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ],
          ),

          if (hasFilter)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Row(
                children: [
                  const Icon(
                    Icons.filter_list_rounded,
                    size: 13,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Đang lọc: $selectedHocKy',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SEMESTER CARD
// ═══════════════════════════════════════════════════════════════════════════

class _HpSemesterCard extends StatefulWidget {
  final HocPhiHocKy item;
  const _HpSemesterCard({required this.item});

  @override
  State<_HpSemesterCard> createState() => _HpSemesterCardState();
}

class _HpSemesterCardState extends State<_HpSemesterCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  double _parseNum(dynamic val) {
    if (val == null) return 0;
    if (val is num) return val.toDouble();
    final str = val.toString().replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(str) ?? 0;
  }

  String _fmt(dynamic val) {
    if (val == null || val.toString().isEmpty) return '—';
    final num = double.tryParse(
      val.toString().replaceAll(RegExp(r'[^\d.]'), ''),
    );
    if (num == null) return val.toString();
    return num.toStringAsFixed(
      0,
    ).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final conNo = _parseNum(item.conNo);
    final isDebt = conNo > 0;

    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: _isExpanded ? AppColors.primary.withOpacity(0.25) : AppColors.divider,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _isExpanded
                  ? AppColors.primary.withOpacity(AppOpacity.bg10)
                  : AppColors.primary.withOpacity(AppOpacity.bg10 - 0.06),
              blurRadius: _isExpanded ? 18 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Card Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon badge
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.primaryDark, AppColors.primary],
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: AppColors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Title + meta
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.tenHocKy ?? '—',
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.2,
                              ),
                            ),
                            if (item.nhhk != null) ...[
                              const SizedBox(height: AppSpacing.xs + 1),
                              Text(
                                'NHHK: ${item.nhhk}',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            if (item.tenNhomCt != null &&
                                item.tenNhomCt.toString().isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.xs + 1),
                              Text(
                                item.tenNhomCt.toString(),
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Expand arrow + status chip
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RotationTransition(
                            turns: Tween(
                              begin: 0.0,
                              end: 0.5,
                            ).animate(_expandAnimation),
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs + 2),
                          _StatusChip(isDebt: isDebt),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.md14),

                  // Quick figures row
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md14,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: [
                        _QuickStat(
                          label: 'Phải thu',
                          value: _fmt(item.phaiThu),
                          color: AppColors.primary,
                        ),
                        _VertDivider(),
                        _QuickStat(
                          label: 'Đã thu',
                          value: _fmt(item.daThu),
                          color: AppColors.success,
                        ),
                        _VertDivider(),
                        _QuickStat(
                          label: 'Còn nợ',
                          value: _fmt(item.conNo),
                          color: isDebt ? AppColors.error : AppColors.success,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Expandable detail ────────────────────────────────
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Column(
                children: [
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    color: AppColors.divider,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md14,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: Column(
                      children: [
                        _DetailGroup(
                          title: 'Học phí',
                          icon: Icons.payments_outlined,
                          rows: [
                            _DetailEntry('Học phí gốc', item.hocPhi),
                            _DetailEntry('Đơn giá', item.donGia),
                            _DetailEntry('Học bổng', item.tongHocBong),
                            _DetailEntry('Miễn giảm', item.mienGiam),
                            _DetailEntry('Được hỗ trợ', item.duocHoTro),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm10),
                        _DetailGroup(
                          title: 'Thanh toán',
                          icon: Icons.receipt_long_outlined,
                          rows: [
                            _DetailEntry('Phải thu', item.phaiThu),
                            _DetailEntry('Đã thu', item.daThu),
                            _DetailEntry('Còn nợ', item.conNo),
                          ],
                        ),
                        if (item.ghiChu != null &&
                            item.ghiChu.toString().isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.sm10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.warningLight,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(
                                color: AppColors.warningLight,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.sticky_note_2_outlined,
                                  size: 15,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    item.ghiChu.toString(),
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: AppColors.warning,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
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

// ─── Status Chip ─────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final bool isDebt;
  const _StatusChip({required this.isDebt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: isDebt ? AppColors.errorLight : AppColors.successLight,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDebt
                ? Icons.error_outline_rounded
                : Icons.check_circle_outline_rounded,
            size: 11,
            color: isDebt ? AppColors.error : AppColors.success,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            isDebt ? 'Còn nợ' : 'Đã trả',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: isDebt ? AppColors.error : AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Stat ──────────────────────────────────────────────────────────────

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _QuickStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.xs + 1),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 26,
    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm10),
    color: AppColors.divider,
  );
}

// ─── Detail Group ─────────────────────────────────────────────────────────────

class _DetailEntry {
  final String label;
  final dynamic value;
  const _DetailEntry(this.label, this.value);
}

class _DetailGroup extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_DetailEntry> rows;

  const _DetailGroup({
    required this.title,
    required this.icon,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    final visible = rows
        .where(
          (r) =>
              r.value != null &&
              r.value.toString().isNotEmpty &&
              r.value.toString() != 'null' &&
              r.value.toString() != '0',
        )
        .toList();

    if (visible.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md14,
              AppSpacing.md,
              AppSpacing.md14,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(icon, size: 15, color: AppColors.primary),
                const SizedBox(width: AppSpacing.xs + 1),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
          ...visible.map((e) => _DetailRow(label: e.label, value: e.value)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final dynamic value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final display = value?.toString() ?? '—';
    final isEmpty = display.isEmpty || display == 'null';

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md14,
        vertical: 7,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              isEmpty ? '—' : display,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isEmpty ? AppColors.textMuted : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LOADING STATE
// ═══════════════════════════════════════════════════════════════════════════

class _HpLoadingState extends StatelessWidget {
  const _HpLoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).padding.top + 70,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primary],
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.primary,
                    backgroundColor: AppColors.primary.withOpacity(AppOpacity.pressed),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Đang tải học phí...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ERROR STATE
// ═══════════════════════════════════════════════════════════════════════════

class _HpErrorState extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback onRetry;

  const _HpErrorState({
    required this.message,
    this.icon = Icons.cloud_off_rounded,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 86,
                height: 86,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 42,
                  color: AppColors.primary.withOpacity(0.45),
                ),
              ),
              const SizedBox(height: AppSpacing.lg20),
              const Text(
                'Không thể tải dữ liệu',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.lg20),
              SizedBox(
                width: 150,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 17),
                  label: const Text('Thử lại'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
}
