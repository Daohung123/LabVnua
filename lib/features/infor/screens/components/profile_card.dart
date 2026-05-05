import 'package:flutter/material.dart';
import '../../../../core/constants/UI/styles/colors.dart';

class ProfileCard extends StatelessWidget {
  final Map<String, String> student;

  const ProfileCard({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: darkCard,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Row(
        children: [
          const CircleAvatar(
            radius: 34,
            backgroundImage: NetworkImage(
              "https://i.pravatar.cc/150?img=3",
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student["name"] ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  student["maSv"] ?? "",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              print("QR Code");
            },
            icon: const Icon(
              Icons.qr_code_2,
              color: Colors.white,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}