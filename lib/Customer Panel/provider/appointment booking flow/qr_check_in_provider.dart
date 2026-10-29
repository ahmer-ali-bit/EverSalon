import 'package:flutter/material.dart';

class QrCheckInProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND - GET /api/bookings/{bookingId}/qr
  // Payload preferably: bookingId + signed token from server
  // ========================================================

  bool isLoading = false;
  bool isDownloading = false;

  String bookingId = '';
  String qrData = '';

  void initFromBookingData(Map<String, dynamic> bookingData) {
    isLoading = true;
    notifyListeners();

    final rawId = bookingData['bookingId']?.toString();
    if (rawId != null && rawId.isNotEmpty) {
      bookingId = rawId.startsWith('#') ? rawId : '#$rawId';
    } else {
      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      bookingId = '#ES${ts.substring(ts.length - 8)}';
    }

    final salonId = (bookingData['salon'] ?? bookingData['salonData']) is Map
        ? ((bookingData['salon'] ?? bookingData['salonData'])['id']
                  ?.toString() ??
              'salon')
        : 'salon';
    final date = bookingData['selectedDate']?.toString() ?? '';
    final time = bookingData['selectedTime']?.toString() ?? '';
    final flow = bookingData['flowType']?.toString() ?? 'service';

    // TODO: replace with server-signed token
    qrData = 'EVERSALON|$bookingId|$salonId|$date|$time|$flow';

    isLoading = false;
    notifyListeners();
  }

  Future<bool> downloadQr() async {
    isDownloading = true;
    notifyListeners();
    try {
      // TODO: capture QR widget → save gallery (gal / image_gallery_saver)
      await Future.delayed(const Duration(milliseconds: 600));
      return true;
    } catch (e) {
      debugPrint('QR download error: $e');
      return false;
    } finally {
      isDownloading = false;
      notifyListeners();
    }
  }
}
