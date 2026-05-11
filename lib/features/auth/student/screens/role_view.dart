import 'package:aqedu/features/auth/student/screens/student_login_view.dart';
import 'package:flutter/material.dart';

// ─── Brand Colors ──────────────────────────────────────────────────────────────
const kPrimary = Color(0xFF0047A8);
const kPrimaryDark = Color(0xFF00337A);
const kPrimaryLight = Color(0xFFEAF2FF);
const kPrimarySoft = Color(0xFFBFD5FF);
const kTextDark = Color(0xFF101828);
const kTextMuted = Color(0xFF667085);
const kBorder = Color(0xFFE4E7EC);
const kBg = Color(0xFFF5F7FC);

class RoleView extends StatefulWidget {
  const RoleView({super.key});

  @override
  State<RoleView> createState() => _RoleViewState();
}

class _RoleViewState extends State<RoleView> {
  String selectedRole = "";

  final List<_RoleItem> roles = const [
    _RoleItem(
      title: "Sinh viên",
      image: "assets/student.png",
      desc: "Học tập, xem thời khóa biểu và theo dõi tiến độ cá nhân.",
      icon: Icons.menu_book_rounded,
      accent: Color(0xFF2F80ED),
    ),
    _RoleItem(
      title: "Giảng viên",
      image: "assets/teacher.png",
      desc: "Quản lý lớp học, bài giảng và theo dõi hoạt động học tập.",
      icon: Icons.cast_for_education_rounded,
      accent: Color(0xFFF2994A),
    ),
  ];

  void _onContinue() {
    if (selectedRole == "Sinh viên") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    debugPrint("Role: $selectedRole");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isDesktop = width >= 980;
            final isTablet = width >= 600;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isDesktop ? 1180 : 760),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop
                            ? 32
                            : isTablet
                                ? 24
                                : 16,
                        vertical: isDesktop ? 24 : 16,
                      ),
                      child: isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: _HeroPanel(
                                    compact: false,
                                    selectedRole: selectedRole,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 9,
                                  child: _SelectionPanel(
                                    selectedRole: selectedRole,
                                    roles: roles,
                                    onSelect: (role) {
                                      setState(() => selectedRole = role);
                                    },
                                    onContinue: _onContinue,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _HeroPanel(
                                  compact: true,
                                  selectedRole: selectedRole,
                                ),
                                const SizedBox(height: 18),
                                _SelectionPanel(
                                  selectedRole: selectedRole,
                                  roles: roles,
                                  onSelect: (role) {
                                    setState(() => selectedRole = role);
                                  },
                                  onContinue: _onContinue,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  final bool compact;
  final String selectedRole;

  const _HeroPanel({
    required this.compact,
    required this.selectedRole,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            kPrimaryDark,
            kPrimary,
            Color(0xFF1565C0),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: _CircleDecoration(size: compact ? 180 : 240, opacity: 0.09),
          ),
          Positioned(
            bottom: -50,
            left: -30,
            child: _CircleDecoration(size: compact ? 150 : 220, opacity: 0.06),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.18)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.school_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "EduAI",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(compact ? 20 : 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: compact ? 52 : 64),
                Text(
                  "Nền tảng học tập thông minh",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontSize: compact ? 12 : 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Chọn vai trò để bắt đầu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 28 : 36,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.0,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  "Giao diện được tối ưu cho mọi kích thước màn hình, từ điện thoại đến desktop, giúp trải nghiệm rõ ràng và chuyên nghiệp hơn.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.84),
                    fontSize: compact ? 14 : 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 22),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _HeroStat(
                      icon: Icons.person_rounded,
                      label: selectedRole.isEmpty ? "Chưa chọn vai trò" : selectedRole,
                    ),
                    const _HeroStat(
                      icon: Icons.verified_rounded,
                      label: "Giao diện responsive",
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final showRow = constraints.maxWidth >= 420;
                    final roleCards = [
                      _MiniRoleChip(
                        icon: Icons.menu_book_rounded,
                        label: "Sinh viên",
                        accent: const Color(0xFF64B5F6),
                      ),
                      _MiniRoleChip(
                        icon: Icons.cast_for_education_rounded,
                        label: "Giảng viên",
                        accent: const Color(0xFFFFB74D),
                      ),
                    ];

                    if (showRow) {
                      return Row(
                        children: [
                          Expanded(child: roleCards[0]),
                          const SizedBox(width: 12),
                          Expanded(child: roleCards[1]),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        roleCards[0],
                        const SizedBox(height: 12),
                        roleCards[1],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionPanel extends StatelessWidget {
  final String selectedRole;
  final List<_RoleItem> roles;
  final ValueChanged<String> onSelect;
  final VoidCallback onContinue;

  const _SelectionPanel({
    required this.selectedRole,
    required this.roles,
    required this.onSelect,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width >= 600 ? 24 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: kBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bạn là ai?",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: kTextDark,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Chọn một vai trò để tiếp tục đăng nhập và sử dụng hệ thống.",
            style: TextStyle(
              fontSize: 14,
              color: kTextMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),
          ...roles.map(
            (role) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _RoleCard(
                title: role.title,
                desc: role.desc,
                image: role.image,
                icon: role.icon,
                accent: role.accent,
                isSelected: selectedRole == role.title,
                onTap: () => onSelect(role.title),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _ContinueButton(
            enabled: selectedRole.isNotEmpty,
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String desc;
  final String image;
  final IconData icon;
  final Color accent;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.desc,
    required this.image,
    required this.icon,
    required this.accent,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 380;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(compact ? 14 : 16),
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryLight : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? kPrimary : kBorder,
              width: isSelected ? 2 : 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: kPrimary.withOpacity(0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: compact ? 56 : 64,
                height: compact ? 56 : 64,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xFFF0F4FA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? kPrimarySoft : Colors.transparent,
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Image.asset(
                        image,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) {
                          return Icon(icon, color: accent, size: 28);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: compact ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: compact ? 15 : 16,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? kPrimary : kTextDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.8,
                        color: kTextMuted,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? kPrimary : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? kPrimary : const Color(0xFFCBD5E1),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _ContinueButton({
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: kPrimary.withOpacity(0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: kPrimary,
            disabledBackgroundColor: const Color(0xFFD6DEEA),
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
                  color: enabled ? Colors.white : const Color(0xFF98A2B3),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                size: 20,
                color: enabled ? Colors.white : const Color(0xFF98A2B3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniRoleChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;

  const _MiniRoleChip({
    required this.icon,
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroStat({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.85), size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleDecoration extends StatelessWidget {
  final double size;
  final double opacity;

  const _CircleDecoration({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}

class _RoleItem {
  final String title;
  final String image;
  final String desc;
  final IconData icon;
  final Color accent;

  const _RoleItem({
    required this.title,
    required this.image,
    required this.desc,
    required this.icon,
    required this.accent,
  });
}
