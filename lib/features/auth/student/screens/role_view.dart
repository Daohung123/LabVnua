import 'package:aqedu/features/auth/student/screens/student_login_view.dart';
import 'package:flutter/material.dart';

// ─── Brand Colors ────────────────────────────────────────────────────────────
const kPrimary = Color(0xFF0047A8);
const kPrimaryLight = Color(0xFFE8F0FB);
const kPrimaryMid = Color(0xFFB8CCF0);
const kTextDark = Color(0xFF1A1A2E);
const kTextMuted = Color(0xFF8A94A6);
const kBg = Color(0xFFF5F7FC);

class RoleView extends StatefulWidget {
  const RoleView({super.key});

  @override
  State<RoleView> createState() => _RoleViewState();
}

class _RoleViewState extends State<RoleView>
    with SingleTickerProviderStateMixin {
  String selectedRole = "";
  late AnimationController _btnController;
  late Animation<double> _btnScale;

  final List<Map<String, String>> roles = [
    {
      "title": "Sinh viên",
      "image": "assets/student.png",
      "desc": "Học tập & theo dõi tiến độ",
    },
    {
      "title": "Giảng viên",
      "image": "assets/teacher.png",
      "desc": "Quản lý lớp & bài giảng",
    },
  ];

  @override
  void initState() {
    super.initState();
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..value = 1.0;
    _btnScale = _btnController;
  }

  @override
  void dispose() {
    _btnController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (selectedRole == "Sinh viên") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      debugPrint("Role: $selectedRole");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Hero Section ──────────────────────────────────────────────
            _HeroSection(height: size.height * 0.40),

            // ── Bottom Sheet ──────────────────────────────────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x120047A8),
                      blurRadius: 24,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bạn là ai?",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: kTextDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Chọn vai trò phù hợp để tiếp tục trải nghiệm",
                        style: TextStyle(
                          fontSize: 14,
                          color: kTextMuted,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 28),

                      Expanded(
                        child: Column(
                          children: roles.map((role) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: _RoleCard(
                                title: role["title"]!,
                                desc: role["desc"]!,
                                image: role["image"]!,
                                isSelected: selectedRole == role["title"],
                                onTap: () => setState(
                                  () => selectedRole = role["title"]!,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      _ContinueButton(
                        enabled: selectedRole.isNotEmpty,
                        onPressed: _onContinue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Hero Section (redesigned — no image needed) ──────────────────────────────
class _HeroSection extends StatelessWidget {
  final double height;
  const _HeroSection({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        children: [
          // ── Full gradient background ─────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF002F7A),
                    Color(0xFF0047A8),
                    Color(0xFF1565C0),
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),

          // ── Decorative circles (top-right) ───────────────────────────
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 30,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // ── Decorative circles (bottom-left) ─────────────────────────
          Positioned(
            bottom: 40,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // ── Dot grid decoration (top-left) ────────────────────────────
          Positioned(top: 14, left: 70, child: _DotGrid(rows: 3, cols: 5)),

          // ── White curved bottom ───────────────────────────────────────
          Positioned(
            bottom: -1,
            left: 0,
            right: 0,
            child: Container(
              height: 34,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
            ),
          ),

          // ── App bar ───────────────────────────────────────────────────
          Positioned(
            top: 12,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "EduAI",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),

          // ── Central illustration ──────────────────────────────────────
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(top: 56, bottom: 34),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Subtitle
                  Text(
                    "Nền tảng học tập thông minh",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ── Two floating role cards + connector ───────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Student card
                      _GlassRoleCard(
                        icon: Icons.menu_book_rounded,
                        label: "Sinh viên",
                        accentColor: const Color(0xFF64B5F6),
                      ),

                      // Connector
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.link_rounded,
                            color: kPrimary,
                            size: 22,
                          ),
                        ),
                      ),

                      // Teacher card
                      _GlassRoleCard(
                        icon: Icons.cast_for_education_rounded,
                        label: "Giảng viên",
                        accentColor: const Color(0xFFFFD54F),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ── Stat pills ────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatPill(icon: Icons.group_rounded, label: "Trợ lý AI"),
                      const SizedBox(width: 10),
                      _StatPill(
                        icon: Icons.library_books_rounded,
                        label: "Tối ưu trải nghiệm",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Glass Role Card ───────────────────────────────────────────────────────────
class _GlassRoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accentColor;

  const _GlassRoleCard({
    required this.icon,
    required this.label,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.22), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: accentColor.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Icon(icon, color: accentColor, size: 26),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Stat Pill ────────────────────────────────────────────────────────────────
class _StatPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.8), size: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Dot Grid Decoration ──────────────────────────────────────────────────────
class _DotGrid extends StatelessWidget {
  final int rows;
  final int cols;

  const _DotGrid({required this.rows, required this.cols});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(rows, (r) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(cols, (c) {
              return Padding(
                padding: const EdgeInsets.only(right: 7),
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

// ─── Role Card ────────────────────────────────────────────────────────────────
class _RoleCard extends StatelessWidget {
  final String title;
  final String desc;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.desc,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryLight : const Color(0xFFF8F9FC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? kPrimary : const Color(0xFFE4E8F0),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: kPrimary.withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFFEFF1F7),
                borderRadius: BorderRadius.circular(14),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: kPrimary.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              padding: const EdgeInsets.all(12),
              child: Image.asset(image, fit: BoxFit.contain),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? kPrimary : kTextDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: kTextMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? kPrimary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? kPrimary : const Color(0xFFCBD2E0),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 13)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Continue Button ───────────────────────────────────────────────────────────
class _ContinueButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _ContinueButton({required this.enabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: kPrimary.withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          disabledBackgroundColor: const Color(0xFFD0D8E8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Tiếp tục",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: enabled ? Colors.white : const Color(0xFF9BADC8),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_rounded,
              size: 20,
              color: enabled ? Colors.white : const Color(0xFF9BADC8),
            ),
          ],
        ),
      ),
    );
  }
}
