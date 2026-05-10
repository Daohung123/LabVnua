import 'package:aqedu/features/home/settings/controllers/controller_settings.dart';
import 'package:flutter/material.dart';
import 'package:aqedu/features/auth/student/screens/role_view.dart';


class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () {
          ControllerSettings.logOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RoleView()),
          );
        },
        icon: const Icon(Icons.logout_rounded),
        label: const Text(
          'Đăng xuất',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xffDC2626),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xffFECACA)),
          ),
        ),
      ),
    );
  }
}
