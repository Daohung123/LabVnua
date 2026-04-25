import 'package:aqedu/features/auth/screens/student_login_view.dart';
import 'package:flutter/material.dart';

class RoleView extends StatefulWidget {
  const RoleView({super.key});

  @override
  State<RoleView> createState() => _RoleViewState();
}

class _RoleViewState extends State<RoleView> {
  String selectedRole = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /// ====== ẢNH PHÍA TRÊN ======
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Image.asset(
              "assets/role.png",
              fit: BoxFit.contain, // Không bị phóng to méo hình
            ),
          ),

          /// ====== CONTAINER PHÍA DƯỚI ======
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// PHẦN TIÊU ĐỀ + ROLE
                  Column(
                    children: [
                      const Text(
                        "Vai trò người dùng",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Vui lòng chọn vai trò bên dưới để tiếp tục",
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildRoleItem(
                            title: "Sinh viên",
                            image: "assets/student.png",
                          ),
                          buildRoleItem(
                            title: "Giảng viên",
                            image: "assets/teacher.png",
                          ),
                        ],
                      ),
                    ],
                  ),

                  /// NÚT TIẾP TỤC
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      //Xu li navigation cho cac role
                      onPressed: selectedRole.isEmpty
                          ? null
                          : () {
                              if (selectedRole == "Sinh viên") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              } else {
                                print(selectedRole);
                              }
                            },
                      child: const Text(
                        "Tiếp tục",
                        style: TextStyle(fontSize: 18),
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

  Widget buildRoleItem({required String title, required String image}) {
    final bool isSelected = selectedRole == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = title;
        });
      },
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(image),
            ),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
