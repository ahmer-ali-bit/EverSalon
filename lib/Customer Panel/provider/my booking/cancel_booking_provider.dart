import 'package:flutter/material.dart';

class CancelBookingProvider extends ChangeNotifier {
  bool isLoading = false;
  bool _isDisposed = false;

  Map<String, dynamic> bookingData = {};

  void initData(Map<String, dynamic> data) {
    bookingData = Map<String, dynamic>.from(data);
    // Ensure cancelled status on success screen
    bookingData['status'] = bookingData['status'] ?? 'cancelled';
    notifyListeners();
  }

  // ========================================================
  // TODO: BACKEND INTEGRATION - GET /api/bookings/{id}
  // Optional refresh after cancel confirm
  // ========================================================
  Future<void> loadCancelledBooking() async {
    isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      debugPrint('CancelBookingProvider load error: $e');
    } finally {
      if (!_isDisposed) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
