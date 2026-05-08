import 'package:aqedu/features/home/screens/student_home_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:aqedu/features/auth/student/ctrls/ctrl_login_Student.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }

    bool kt = await ctrl_login(email, password);

    if (kt != false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Đăng nhập thành công",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Đăng nhập thất bại",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Ảnh nền
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Lớp làm mờ nền
          Container(color: Colors.black.withOpacity(0.25)),

          /// Nội dung login
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  /// Logo bo tròn
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Image.asset("assets/logovnua.png", height: 80),
                  ),

                  const SizedBox(height: 20),

                  /// Tên trường
                  const Text(
                    "Học Viện Nông Nghiệp Việt Nam",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  /// Ô tài khoản
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Mã sinh viên / Giảng viên",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Ô mật khẩu
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Mật khẩu",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Nút đăng nhập
                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(
                      onPressed: handleLogin,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: const Text(
                        "Đăng nhập",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
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
