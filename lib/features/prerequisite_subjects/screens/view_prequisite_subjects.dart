import 'package:flutter/material.dart';

import '../controllers/ctrls_prequisite_subjects.dart';
import '../models/model_prequisite_subjects.dart';

// ─── Brand Tokens ──────────────────────────────────────────────────────────────
class _Colors {
  static const primary = Color(0xff0047A8);
  static const primaryLight = Color(0xff1A5DC4);
  static const primarySurface = Color(0xffEEF4FF);
  static const accent = Color(0xff3B82F6);
  static const amber = Color(0xffF59E0B);
  static const amberSurface = Color(0xffFFFBEB);
  static const teal = Color(0xff0D9488);
  static const tealSurface = Color(0xffF0FDFA);
  static const bg = Color(0xffF4F7FD);
  static const surface = Colors.white;
  static const textPrimary = Color(0xff0F172A);
  static const textSecondary = Color(0xff64748B);
  static const divider = Color(0xffE2E8F0);
}

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
    color: _Colors.primary,
    surface: _Colors.primarySurface,
  ),
  _FilterOption(
    value: 2,
    label: 'Môn học trước',
    shortLabel: 'Học trước',
    icon: Icons.arrow_back_rounded,
    color: _Colors.teal,
    surface: _Colors.tealSurface,
  ),
  _FilterOption(
    value: 3,
    label: 'Môn song hành',
    shortLabel: 'Song hành',
    icon: Icons.compare_arrows_rounded,
    color: _Colors.amber,
    surface: _Colors.amberSurface,
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
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 340));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    loadPrerequisite();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> loadPrerequisite() async {
    setState(() => isLoading = true);
    _fadeCtrl.reset();
    try {
      final controller = await CtrlPrerequisite.create();
      final result = await controller.getPrerequisiteSubjects(
          loaiTienQuyet: selectedLoaiTienQuyet);
      setState(() {
        subjects = result;
        isLoading = false;
      });
      _fadeCtrl.forward();
    } catch (e) {
      debugPrint('Lỗi loadPrerequisite: $e');
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
      backgroundColor: _Colors.bg,
      body: CustomScrollView(
        slivers: [
          _AppHeader(
            filter: filter,
            onRefresh: loadPrerequisite,
          ),
          SliverToBoxAdapter(
            child: _FilterChips(
              selected: selectedLoaiTienQuyet,
              onChanged: (v) {
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
                separatorBuilder: (_, __) => const SizedBox(height: 12),
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
      backgroundColor: _Colors.primary,
      foregroundColor: Colors.white,
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
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              filter.label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
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
                  colors: [Color(0xff003080), _Colors.primaryLight],
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
                  color: Colors.white.withOpacity(0.06),
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
                  color: Colors.white.withOpacity(0.08),
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
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: _filters
            .map((f) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: f.value < _filters.length ? 8 : 0),
                    child: _ChipItem(
                      filter: f,
                      isSelected: selected == f.value,
                      onTap: () => onChanged(f.value),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _ChipItem extends StatelessWidget {
  final _FilterOption filter;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChipItem(
      {required this.filter,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: isSelected ? filter.color : filter.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? filter.color
                : filter.color.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              filter.icon,
              size: 18,
              color: isSelected ? Colors.white : filter.color,
            ),
            const SizedBox(height: 4),
            Text(
              filter.shortLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : filter.color,
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

  const _PrerequisiteCard(
      {required this.item, required this.filter, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _Colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _Colors.primary.withOpacity(0.06),
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
              color: _Colors.primarySurface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _Colors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.menu_book_rounded,
                      color: Colors.white, size: 18),
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
                            color: _Colors.primary,
                            letterSpacing: 0.4,
                          ),
                        ),
                      Text(
                        item.tenMonDangKy ?? '—',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _Colors.textPrimary,
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
                    color: _Colors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _Colors.primary,
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
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: filter.surface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: filter.color.withOpacity(0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(filter.icon,
                              size: 13, color: filter.color),
                          const SizedBox(width: 4),
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: Divider(
                          color: _Colors.divider, thickness: 1, height: 1),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Required subject box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: filter.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: filter.color.withOpacity(0.2), width: 1),
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
                                color: _Colors.textPrimary,
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
                      if (item.heDaoTao != null &&
                          item.heDaoTao!.isNotEmpty)
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

  const _Tag(
      {required this.label, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: _Colors.primarySurface,
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: _Colors.primary.withOpacity(0.15), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: _Colors.primary),
          const SizedBox(width: 4),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: _Colors.textSecondary,
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _Colors.primary,
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
          CircularProgressIndicator(
            color: _Colors.primary,
            strokeWidth: 2.5,
          ),
          SizedBox(height: 16),
          Text(
            'Đang tải dữ liệu...',
            style: TextStyle(
              color: _Colors.textSecondary,
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
        padding: const EdgeInsets.all(32),
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
            const SizedBox(height: 20),
            Text(
              'Không có dữ liệu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _Colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Chưa có môn "${filter.label.toLowerCase()}" nào được ghi nhận.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: _Colors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}