import 'package:flutter/material.dart';

class BookingConfirmationProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND - POST /api/bookings (final confirm)
  // Response se bookingId aayega
  // ========================================================

  bool isLoading = false;
  String? bookingId;
  bool isConfirmed = false;

  /// Generate / fetch booking ID after successful payment
  Future<void> confirmBooking(Map<String, dynamic> bookingData) async {
    isLoading = true;
    notifyListeners();

    try {
      // TODO: POST /api/bookings
      // Body: bookingData (salon, services, beautician, date, time, notes, coupon, payment, total)
      await Future.delayed(const Duration(milliseconds: 400));

      // Mock booking ID (backend se aayega)
      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      bookingId = '#ES${ts.substring(ts.length - 8)}';
      isConfirmed = true;
    } catch (e) {
      debugPrint('Booking confirmation error: $e');
      isConfirmed = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
