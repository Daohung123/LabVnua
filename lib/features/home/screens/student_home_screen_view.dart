import 'package:flutter/material.dart';
import 'package:aqedu/features/home/screens/student_chat_view.dart';
import 'package:aqedu/features/home/screens/student_home_view.dart';
import 'package:aqedu/features/home/screens/student_other_view.dart';
import 'package:aqedu/features/home/screens/student_setting_view.dart';
import 'package:aqedu/features/home/screens/study_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // index hiện tại của BottomNavigationBar
  int currentIndex = 0;

  // danh sách màn hình (không thay đổi) — dùng const khi có thể
  final List<Widget> _pages = const [
    Home(),
    Study(),
    Chat(),
    Other(),
    Setting(),
  ];

  // helper nhỏ để tạo item, giúp code gọn và dễ sửa
  BottomNavigationBarItem _navItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack giữ state của từng trang khi chuyển tab
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),

      // SafeArea để tránh chạm vùng notch / gesture bar
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          backgroundColor: Color(0xff104492),
          fixedColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed, 
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          showUnselectedLabels: true,
          items: [
            _navItem(Icons.home, 'Trang chủ'),
            _navItem(Icons.menu_book_outlined, 'Học tập'),
            _navItem(Icons.chat, 'Trò chuyện'),
            _navItem(Icons.add_box, 'Khác'),
            _navItem(Icons.settings, 'Cài đặt'),
          ],
        ),
      ),
    );
  }
}
