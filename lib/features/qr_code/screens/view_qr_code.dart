import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerView extends StatefulWidget {
  const QRScannerView({super.key});

  @override
  State<QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
  final MobileScannerController controller = MobileScannerController();

  bool isScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onDetect(BarcodeCapture capture) {
    if (isScanned) return;

    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      final String? code = barcode.rawValue;

      if (code != null) {
        isScanned = true;

        debugPrint('QR: $code');

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Kết quả QR'),
            content: Text(code),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  isScanned = false;
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );

        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Quét QR'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: onDetect,
          ),

          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}