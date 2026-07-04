// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:aqedu/config/sync_data.dart';
import 'package:aqedu/features/ai_assistant/presentation/screens/ai_chat_screen.dart';
import 'package:aqedu/features/home/home_view/screens/student_home_view.dart';
import 'package:aqedu/features/home/other_view/screens/student_other_view.dart';
import 'package:aqedu/features/home/setting/screens/view_student_setting.dart';
import 'package:aqedu/features/home/study_view/screens/study_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
//  Design tokens
// ─────────────────────────────────────────────
const _kPrimary = Color(0xFF1A5FD4); // richer azure
const _kPrimaryLt = Color(0xFF3B7EF6); // highlight
const _kSurface = Color(0xFFFAFBFF); // warm-white base
const _kBorder = Color(0xFFE4E9F2);
const _kMuted = Color(0xFF8A97B0);

// ─────────────────────────────────────────────
//  HomeScreen — root scaffold
// ─────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await syncData();
  }

  static const _destinations = <_NavDest>[
    _NavDest('Trang chủ', Icons.home_outlined, Icons.home_rounded),
    _NavDest('Học tập', Icons.menu_book_outlined, Icons.menu_book_rounded),
    _NavDest('AI', Icons.auto_awesome_outlined, Icons.auto_awesome),
    _NavDest('Khác', Icons.grid_view_outlined, Icons.grid_view_rounded),
    _NavDest('Cài đặt', Icons.settings_outlined, Icons.settings_rounded),
  ];

  static const _pages = <Widget>[
    HomeStudent(),
    HocTapView(),
    AIChatScreen(),
    OtherFeaturesView(),
    SettingsView(),
  ];

  void _setTab(int i) {
    if (_currentIndex == i) return;
    HapticFeedback.selectionClick();
    setState(() => _currentIndex = i);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, c) {
        final wide = c.maxWidth >= 900;

        return Scaffold(
          backgroundColor: _kSurface,
          body: Stack(
            children: [
              // ── Subtle mesh background ──
              Positioned.fill(child: _MeshBackground()),

              // ── Main content ──
              wide
                  ? _DesktopShell(
                      destinations: _destinations,
                      selectedIndex: _currentIndex,
                      onSelected: _setTab,
                      child: IndexedStack(
                        index: _currentIndex,
                        children: _pages,
                      ),
                    )
                  : Stack(
                      children: [
                        IndexedStack(index: _currentIndex, children: _pages),
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 12,
                          child: SafeArea(
                            top: false,
                            child: _BottomNav(
                              destinations: _destinations,
                              selectedIndex: _currentIndex,
                              onSelected: _setTab,
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  Mesh background — very subtle colour blobs
// ─────────────────────────────────────────────
class _MeshBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _MeshPainter());
  }
}

class _MeshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    void blob(double x, double y, double r, Color c) {
      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        r,
        Paint()
          ..color = c
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 80),
      );
    }

    blob(0.85, 0.10, 160, _kPrimary.withOpacity(0.055));
    blob(0.05, 0.25, 130, _kPrimaryLt.withOpacity(0.040));
    blob(0.50, 0.90, 180, _kPrimary.withOpacity(0.035));
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────
//  Desktop shell — sidebar rail
// ─────────────────────────────────────────────
class _DesktopShell extends StatelessWidget {
  const _DesktopShell({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    required this.child,
  });
  final List<_NavDest> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // ── Sidebar ──
            _GlassCard(
              width: 100,
              borderRadius: 28,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Logo mark
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_kPrimary, _kPrimaryLt],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: _kPrimary.withOpacity(0.30),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AQEdu',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _kPrimary,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(indent: 16, endIndent: 16, height: 1),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: destinations.length,
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 10,
                      ),
                      itemBuilder: (_, i) {
                        final d = destinations[i];
                        final sel = i == selectedIndex;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Tooltip(
                            message: d.label,
                            preferBelow: false,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOutCubic,
                              decoration: BoxDecoration(
                                color: sel
                                    ? _kPrimary.withOpacity(0.08)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => onSelected(i),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AnimatedScale(
                                          scale: sel ? 1.12 : 1.0,
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          curve: Curves.easeOutBack,
                                          child: Icon(
                                            sel ? d.activeIcon : d.icon,
                                            size: 22,
                                            color: sel ? _kPrimary : _kMuted,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          d.label,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: sel
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: sel ? _kPrimary : _kMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // ── Page area ──
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: child,
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
//  Mobile bottom navigation — sliding pill
// ─────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });
  final List<_NavDest> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      borderRadius: 28,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: LayoutBuilder(
        builder: (ctx, c) {
          final total = destinations.length;
          final itemW = c.maxWidth / total;

          return SizedBox(
            height: 62,
            child: Stack(
              children: [
                // Sliding pill background
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  left: itemW * selectedIndex + 4,
                  top: 4,
                  width: itemW - 8,
                  height: 54,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _kPrimary.withOpacity(0.14),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                // Items
                Row(
                  children: List.generate(total, (i) {
                    final d = destinations[i];
                    final sel = i == selectedIndex;
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onSelected(i),
                        child: SizedBox(
                          height: 62,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedScale(
                                scale: sel ? 1.10 : 1.0,
                                duration: const Duration(milliseconds: 240),
                                curve: Curves.easeOutBack,
                                child: Icon(
                                  sel ? d.activeIcon : d.icon,
                                  size: 22,
                                  color: sel ? _kPrimary : _kMuted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: sel
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: sel ? _kPrimary : _kMuted,
                                ),
                                child: Text(
                                  d.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Glass card — reusable frosted surface
// ─────────────────────────────────────────────
class _GlassCard extends StatelessWidget {
  const _GlassCard({
    required this.child,
    this.width,
    this.borderRadius = 24,
    this.padding = EdgeInsets.zero,
  });
  final Widget child;
  final double? width;
  final double borderRadius;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.82),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: _kBorder.withOpacity(0.70), width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 32,
                offset: const Offset(0, 16),
              ),
              BoxShadow(
                color: _kPrimary.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Nav destination model
// ─────────────────────────────────────────────
class _NavDest {
  const _NavDest(this.label, this.icon, this.activeIcon);
  final String label;
  final IconData icon;
  final IconData activeIcon;
}
