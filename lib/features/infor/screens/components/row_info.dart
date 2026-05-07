import 'package:flutter/material.dart';
import '../../../../core/constants/UI/styles/colors.dart';

class RowInfo extends StatelessWidget {
  final String left;
  final String right;

  const RowInfo({
    super.key,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              left,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              right,
              style: TextStyle(
                fontSize: 16,
                color: textBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}