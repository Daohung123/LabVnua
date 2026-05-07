import 'package:flutter/material.dart';
import '../../../../core/constants/UI/styles/colors.dart';

class ScoreSubjectItem extends StatelessWidget {
  final dynamic subject;

  const ScoreSubjectItem({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPass = subject.ketQua == 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPass ? Icons.check_circle : Icons.cancel_outlined,
            color: isPass ? Colors.green : Colors.redAccent,
            size: 22,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.tenMon ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Môn học: ${subject.maMon ?? ""}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              const Text(
                "TK(10)",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              Text(
                subject.diemTkSo == "" ? "-" : subject.diemTkSo ?? "-",
                style: TextStyle(
                  fontSize: 17,
                  color: textBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(width: 14),

          Column(
            children: [
              const Text(
                "TK(C)",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              Text(
                subject.diemTkChu == "" ? "-" : subject.diemTkChu ?? "-",
                style: TextStyle(
                  fontSize: 17,
                  color: isPass ? Colors.redAccent : Colors.black45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}