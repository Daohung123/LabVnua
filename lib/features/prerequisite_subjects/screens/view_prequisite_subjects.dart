import 'package:aqedu/core/logging/app_log.dart';
import 'package:flutter/material.dart';

import '../controllers/ctrls_prequisite_subjects.dart';
import '../models/model_prequisite_subjects.dart';

import 'package:aqedu/core/theme/app_components.dart';
// ─── Filter Config ─────────────────────────────────────────────────────────────
class _FilterOption {
  final int value;
  final String label;
  final String shortLabel;
  final IconData icon;
  final Color color;
  final Color surface;

  const _FilterOption({
    required this.value,
    required this.label,
    required this.shortLabel,
    required this.icon,
    required this.color,
    required this.surface,
  });
}

const _filters = [
  _FilterOption(
    value: 1,
    label: 'Môn tiên quyết',
    shortLabel: 'Tiên quyết',
    icon: Icons.lock_outline_rounded,
    color: AppColors.primary,
    surface: AppColors.primarySoft,
  ),
  _FilterOption(
    value: 2,
    label: 'Môn học trước',
    shortLabel: 'Học trước',
    icon: Icons.arrow_back_rounded,
    color: AppColors.success,
    surface: AppColors.successLight,
  ),
  _FilterOption(
    value: 3,
    label: 'Môn song hành',
    shortLabel: 'Song hành',
    icon: Icons.compare_arrows_rounded,
    color: AppColors.warning,
    surface: AppColors.warningLight,
  ),
];

_FilterOption _filterFor(int value) =>
    _filters.firstWhere((f) => f.value == value, orElse: () => _filters.first);

// ─── View ──────────────────────────────────────────────────────────────────────
class PrerequisiteView extends StatefulWidget {
  const PrerequisiteView({super.key});

  @override
  State<PrerequisiteView> createState() => _PrerequisiteViewState();
}

class _PrerequisiteViewState extends State<PrerequisiteView>
    with SingleTickerProviderStateMixin {
  List<PrerequisiteSubject> subjects = [];
  bool isLoading = true;
  int selectedLoaiTienQuyet = 1;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    AppLog.vongDoi(
      'Màn hình môn học điều kiện được mở',
      khuVuc: 'Môn học điều kiện',
    );
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    loadPrerequisite();
  }

  @override
  void dispose() {
    AppLog.vongDoi(
      'Màn hình môn học điều kiện được đóng',
      khuVuc: 'Môn học điều kiện',
    );
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> loadPrerequisite() async {
    AppLog.api(
      'Bắt đầu tải danh sách môn học điều kiện',
      khuVuc: 'Môn học điều kiện',
      duLieu: {'loai_tien_quyet': selectedLoaiTienQuyet},
    );
    setState(() => isLoading = true);
    _fadeCtrl.reset();
    try {
      final controller = await CtrlPrerequisite.create();
      final result = await controller.getPrerequisiteSubjects(
        loaiTienQuyet: selectedLoaiTienQuyet,
      );
      setState(() {
        subjects = result;
        isLoading = false;
      });
      AppLog.api(
        'Tải danh sách môn học điều kiện hoàn tất',
        khuVuc: 'Môn học điều kiện',
        duLieu: {
          'loai_tien_quyet': selectedLoaiTienQuyet,
          'so_luong': result.length,
        },
      );
      _fadeCtrl.forward();
    } catch (e, stackTrace) {
      AppLog.loi(
        'Tải danh sách môn học điều kiện gặp lỗi',
        khuVuc: 'Môn học điều kiện',
        duLieu: {'loai_tien_quyet': selectedLoaiTienQuyet},
        loi: e,
        stackTrace: stackTrace,
      );
      setState(() {
        subjects = [];
        isLoading = false;
      });
      _fadeCtrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filter = _filterFor(selectedLoaiTienQuyet);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _AppHeader(filter: filter, onRefresh: loadPrerequisite),
          SliverToBoxAdapter(
            child: _FilterChips(
              selected: selectedLoaiTienQuyet,
              onChanged: (v) {
                AppLog.thaoTacNguoiDung(
                  'Người dùng đổi bộ lọc môn học điều kiện',
                  khuVuc: 'Môn học điều kiện',
                  duLieu: {'loai_tien_quyet_moi': v},
                );
                setState(() => selectedLoaiTienQuyet = v);
                loadPrerequisite();
              },
            ),
          ),
          if (isLoading)
            const SliverFillRemaining(child: _LoadingState())
          else if (subjects.isEmpty)
            SliverFillRemaining(child: _EmptyState(filter: filter))
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
              sliver: SliverList.separated(
                itemCount: subjects.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (ctx, i) => FadeTransition(
                  opacity: _fadeAnim,
                  child: _PrerequisiteCard(
                    item: subjects[i],
                    filter: filter,
                    index: i,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── App Header (SliverAppBar) ─────────────────────────────────────────────────
class _AppHeader extends StatelessWidget {
  final _FilterOption filter;
  final VoidCallback onRefresh;

  const _AppHeader({required this.filter, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(16, 0, 56, 16),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Môn học điều kiện',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              filter.label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Subtle gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryPressed, AppColors.primaryPressed],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Decorative circles
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withOpacity(0.06),
                ),
              ),
            ),
            Positioned(
              right: 40,
              bottom: -10,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withOpacity(0.08),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
          tooltip: 'Tải lại',
        ),
      ],
    );
  }
}

// ─── Filter Chips ──────────────────────────────────────────────────────────────
class _FilterChips extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _FilterChips({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: _filters
            .map(
              (f) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: f.value < _filters.length ? 8 : 0,
                  ),
                  child: _ChipItem(
                    filter: f,
                    isSelected: selected == f.value,
                    onTap: () => onChanged(f.value),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ChipItem extends StatelessWidget {
  final _FilterOption filter;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChipItem({
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? filter.color : filter.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? filter.color : filter.color.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              filter.icon,
              size: 18,
              color: isSelected ? AppColors.white : filter.color,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              filter.shortLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.white : filter.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Card ──────────────────────────────────────────────────────────────────────
class _PrerequisiteCard extends StatelessWidget {
  final PrerequisiteSubject item;
  final _FilterOption filter;
  final int index;

  const _PrerequisiteCard({
    required this.item,
    required this.filter,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header strip ──
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.lg),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.maMonDangKy != null)
                        Text(
                          item.maMonDangKy!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            letterSpacing: 0.4,
                          ),
                        ),
                      Text(
                        item.tenMonDangKy ?? '—',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                // Index badge
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Body ──
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Connector label
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: filter.surface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: filter.color.withOpacity(0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(filter.icon, size: 13, color: filter.color),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            filter.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: filter.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Divider(
                        color: AppColors.border,
                        thickness: 1,
                        height: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Required subject box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: filter.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: filter.color.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 38,
                        decoration: BoxDecoration(
                          color: filter.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.maMonYeuCau != null)
                              Text(
                                item.maMonYeuCau!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: filter.color,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            Text(
                              item.tenMonYeuCau ?? '—',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Tags row (if any)
                if ((item.khoi != null && item.khoi!.isNotEmpty) ||
                    (item.heDaoTao != null && item.heDaoTao!.isNotEmpty)) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (item.khoi != null && item.khoi!.isNotEmpty)
                        _Tag(
                          icon: Icons.school_outlined,
                          text: item.khoi!,
                          label: 'Khối',
                        ),
                      if (item.heDaoTao != null && item.heDaoTao!.isNotEmpty)
                        _Tag(
                          icon: Icons.layers_outlined,
                          text: item.heDaoTao!,
                          label: 'Hệ đào tạo',
                        ),
                    ],
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

// ─── Tag ───────────────────────────────────────────────────────────────────────
class _Tag extends StatelessWidget {
  final String label;
  final String text;
  final IconData icon;

  const _Tag({required this.label, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.primary.withOpacity(0.15), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── States ────────────────────────────────────────────────────────────────────
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2.5),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Đang tải dữ liệu...',
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

class _EmptyState extends StatelessWidget {
  final _FilterOption filter;

  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: filter.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(filter.icon, size: 36, color: filter.color),
            ),
            const SizedBox(height: AppSpacing.lg20),
            Text(
              'Không có dữ liệu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Chưa có môn "${filter.label.toLowerCase()}" nào được ghi nhận.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
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
