import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AdminQrScannerProvider extends ChangeNotifier {
  bool _isDisposed = false;

  bool hasScanned = false;
  bool isScanningMock = false;
  String? scannedCode;
  Map<String, dynamic>? scannedBooking;

  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    autoStart: true,
  );

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  // Real Camera Detect
  void onDetect(BarcodeCapture capture) {
    if (hasScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
        hasScanned = true;
        scannedCode = barcode.rawValue;
        _safeNotify();

        _processScanData(scannedCode!);
        break;
      }
    }
  }

  // Fallback for Simulator testing
  Future<void> simulateScan() async {
    isScanningMock = true;
    _safeNotify();

    await Future.delayed(const Duration(seconds: 1));

    isScanningMock = false;
    hasScanned = true;
    _processScanData('#ES124051689');
  }

  Future<void> _processScanData(String qrData) async {
    // TODO: BACKEND INTEGRATION - GET /api/admin/bookings/qr?code=$qrData
    await Future.delayed(const Duration(milliseconds: 500));

    scannedBooking = {
      'bookingId': qrData.isNotEmpty ? qrData : '#ES124051689',
      'customerName': 'Ayesha Khan',
      'customerAvatar': 'assets/images/users/ayesha.png',
      'service': 'Hair Spa Treatment',
      'dateTime': '15 May 2024 • 11:00 AM',
      'paymentStatus': 'Paid',
    };

    _safeNotify();
  }

  void toggleTorch() {
    try {
      cameraController.toggleTorch();
    } catch (_) {}
    _safeNotify();
  }

  void resetScanner() {
    hasScanned = false;
    scannedCode = null;
    scannedBooking = null;
    isScanningMock = false;
    try {
      cameraController.start();
    } catch (_) {}
    _safeNotify();
  }

  @override
  void dispose() {
    try {
      cameraController.dispose();
    } catch (_) {}
    _isDisposed = true;
    super.dispose();
  }
}
