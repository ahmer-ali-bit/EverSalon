import 'package:flutter/material.dart';

class BookingConfirmationProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND - POST /api/bookings
  // Response: { bookingId, status, qrToken, ... }
  // ========================================================

  // FIX: Default value set to true directly to avoid calling notifyListeners() during build phase
  bool isLoading = true;
  bool isConfirmed = false;
  String? bookingId;

  Future<void> confirmBooking(Map<String, dynamic> bookingData) async {
    // isLoading is already true, no need to call notifyListeners() immediately!
    try {
      // TODO: POST /api/bookings OR GET /api/bookings/{id}
      await Future.delayed(const Duration(milliseconds: 400));

      final existing = bookingData['bookingId']?.toString();
      if (existing != null && existing.isNotEmpty) {
        bookingId = existing.startsWith('#') ? existing : '#$existing';
      } else {
        final ts = DateTime.now().millisecondsSinceEpoch.toString();
        bookingId = '#ES${ts.substring(ts.length - 8)}';
      }

      isConfirmed = true;
    } catch (e) {
      debugPrint('Booking confirmation error: $e');
      isConfirmed = false;
    } finally {
      isLoading = false;
      notifyListeners(); // Safely notified after async delay
    }
  }
}
