import 'package:flutter/material.dart';

/// Deprecated: Use AppIconButton instead
/// Image-based button component kept for backward compatibility
@Deprecated('Use AppIconButton or AppButton.small() with icon instead')
class ButtonImage extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;
  final String text;
  final double size;

  const ButtonImage({
    super.key,
    required this.imagePath,
    required this.onPressed,
    required this.text,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Image.asset(
            imagePath,
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
