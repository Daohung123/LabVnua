import 'package:flutter/material.dart';
import 'package:aqedu/features/home/home/views/home_view.dart';
import 'package:aqedu/features/home/chat/views/chat_view.dart';
import 'package:aqedu/features/home/study/views/study_view.dart';
import 'package:aqedu/features/home/other/views/other_features_view.dart';
import 'package:aqedu/features/home/settings/views/settings_view.dart';
import 'package:aqedu/core/widgets/fab/ai_fab_button.dart';
import 'package:aqedu/features/ai_assistant/screens/ai_chat_dialog.dart';
import 'package:aqedu/core/theme/app_theme.dart';

/// ========================================
/// HOME SCREEN - Main Navigation Hub
/// ========================================
///
/// The root container for the app's main navigation system.
/// Manages the bottom tab navigation and provides a central point
/// for accessing all major features.
///
/// Features:
/// - 5-tab bottom navigation (Home, Study, Chat, Other, Settings)
/// - State preservation using IndexedStack (maintains widget state)
/// - AI FAB button for quick AI assistant access
/// - Modern theme with updated colors

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Tracks currently active tab (0-4)
  /// 0: Home, 1: Study, 2: Chat, 3: Other, 4: Settings
  int currentIndex = 0;

  /// List of page widgets - using const for memory efficiency
  /// IndexedStack preserves state across tab switches
  final List<Widget> _pages = const [
    HomeStudent(),
    HocTapView(),
    Chat(),
    OtherFeaturesView(),
    SettingsView(),
  ];

  /// Helper method to create consistent navigation items
  /// Reduces code duplication and centralizes styling
  BottomNavigationBarItem _navItem(IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }

  /// Handle FAB press - opens AI chat dialog
  void _onFabPressed() {
    showDialog(
      context: context,
      builder: (context) => const AIChatDialog(),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// IndexedStack preserves the state of each tab when switching
      /// This means scroll positions, form data, and state are maintained
      body: IndexedStack(index: currentIndex, children: _pages),

      /// Modern bottom navigation bar with updated styling
      /// Uses AppColors theme system for consistency
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          /// Theme colors - now using centralized AppColors
          backgroundColor: AppColors.primary,
          fixedColor: Colors.white,
          unselectedItemColor: Colors.white70,

          /// Layout and behavior
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          showUnselectedLabels: true,

          /// Elevation for depth
          elevation: 8,

          /// Navigation items with Vietnamese labels
          items: [
            _navItem(Icons.home, 'Trang chủ'),
            _navItem(Icons.menu_book_outlined, 'Học tập'),
            _navItem(Icons.chat, 'Trò chuyện'),
            _navItem(Icons.apps_outlined, 'Khác'),
            _navItem(Icons.settings, 'Cài đặt'),
          ],
        ),
      ),

      /// AI Floating Action Button
      /// Provides quick access to AI assistant from any tab
      /// Icon and tooltip change based on current tab for context
      floatingActionButton: ContextAwareFabButton(
        currentTabIndex: currentIndex,
        onFabPressed: _onFabPressed,
        heroTag: 'ai-fab-button',
      ),

      /// Position FAB at bottom-right with some spacing
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
