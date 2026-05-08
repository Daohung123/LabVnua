import 'package:flutter/material.dart';

/// QR Scan Button - Icon button for QR code scanning
class QRScanButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color iconColor;
  final double iconSize;
  final String tooltip;

  const QRScanButton({
    super.key,
    required this.onPressed,
    this.iconColor = Colors.white,
    this.iconSize = 28,
    this.tooltip = 'Quét mã QR',
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(Icons.qr_code_scanner_outlined),
      iconSize: iconSize,
      color: iconColor,
      tooltip: tooltip,
    );
  }
}
