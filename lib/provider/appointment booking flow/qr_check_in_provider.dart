import 'package:flutter/material.dart';

class QrCheckInProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND - GET /api/bookings/{bookingId}/qr
  // QR payload usually contains bookingId + verification token
  // ========================================================

  bool isLoading = false;
  bool isDownloading = false;

  String bookingId = '';
  String qrData = '';

  void initFromBookingData(Map<String, dynamic> bookingData) {
    isLoading = true;
    notifyListeners();

    // Booking ID from confirmation or generate fallback
    bookingId =
        bookingData['bookingId']?.toString() ??
        '#ES${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

    // QR payload — backend se secure token aana chahiye
    // For now: bookingId + salon + date + time
    final salonId =
        bookingData['salonData']?['id']?.toString() ??
        bookingData['salon']?['id']?.toString() ??
        'salon';
    final date = bookingData['selectedDate']?.toString() ?? '';
    final time = bookingData['selectedTime']?.toString() ?? '';

    qrData = 'EVERSALON|$bookingId|$salonId|$date|$time';

    isLoading = false;
    notifyListeners();
  }

  /// Download / save QR — wire with gallery_saver / path_provider later
  Future<bool> downloadQr() async {
    isDownloading = true;
    notifyListeners();

    try {
      // TODO: Capture QR widget as image + save to gallery
      // Packages: screenshot / gal / image_gallery_saver
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
