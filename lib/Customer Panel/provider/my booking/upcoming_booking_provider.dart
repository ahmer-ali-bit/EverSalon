import 'package:flutter/material.dart';

class UpcomingBookingProvider extends ChangeNotifier {
  bool isLoading = false;
  Map<String, dynamic> bookingData = {};

  void initData(Map<String, dynamic> data) {
    bookingData = data;
    notifyListeners();
  }

  // ========================================================
  // TODO: BACKEND INTEGRATION - GET /api/bookings/{id}
  // Refresh booking details from server (optional, currently using passed data)
  // ========================================================
  Future<void> refreshBookingDetails() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    // Mock updating logic
    isLoading = false;
    notifyListeners();
  }

  // Cancel action prepare (real cancellation will happen in S45)
  Future<bool> cancelBooking() async {
    // Navigate to S45
    return true;
  }

  // Reschedule action prepare (real reschedule in S44)
  Future<bool> rescheduleBooking() async {
    // Navigate to S44
    return true;
  }
}
