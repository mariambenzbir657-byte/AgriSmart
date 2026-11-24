
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  String? qrResult;
  bool isScanned = false;
  bool showGenerator = false;

  final MobileScannerController controller =
  MobileScannerController();

  // Lien public de AgriSmart
  static const String appUrl =
      'https://architecture-pipe-applying-budget.trycloudflare.com';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _showScanner() async {
    setState(() {
      showGenerator = false;
    });

    await controller.start();
  }

  Future<void> _showGenerator() async {
    await controller.stop();

    if (!mounted) return;

    setState(() {
      showGenerator = true;
    });
  }

  void _scanAgain() {
    setState(() {
      qrResult = null;
      isScanned = false;
    });

    controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriSmart QR Code'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          // Choix Scanner / Générer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showScanner,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scanner'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !showGenerator
                          ? Colors.green
                          : Colors.grey.shade300,
                      foregroundColor: !showGenerator
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showGenerator,
                    icon: const Icon(Icons.qr_code),
                    label: const Text('Générer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showGenerator
                          ? Colors.green
                          : Colors.grey.shade300,
                      foregroundColor: showGenerator
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Partie Scanner
          if (!showGenerator) ...[
            Expanded(
              child: MobileScanner(
                controller: controller,
                onDetect: (capture) {
                  if (isScanned || capture.barcodes.isEmpty) {
                    return;
                  }

                  final barcode = capture.barcodes.first;
                  final value = barcode.rawValue;

                  if (value != null) {
                    setState(() {
                      qrResult = value;
                      isScanned = true;
                    });

                    controller.stop();
                  }
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Résultat du scan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    qrResult ?? 'Scannez un QR Code',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton.icon(
                    onPressed: _scanAgain,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Scanner à nouveau'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],

          // Partie Génération QR Code
          if (showGenerator)
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.agriculture,
                        color: Colors.green,
                        size: 65,
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'AgriSmart',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'QR Code de notre application',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 30),

                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: appUrl,
                          version: QrVersions.auto,
                          size: 230,
                          backgroundColor: Colors.white,
                          errorCorrectionLevel:
                          QrErrorCorrectLevel.H,
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        'Scannez ce QR Code pour accéder à AgriSmart',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Le lien n'est plus affiché
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
