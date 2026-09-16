import 'package:flutter/material.dart';

class BookingSummaryProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND - POST /api/bookings/preview
  // (Optional: verify subtotal, tax, total from server)
  // ========================================================

  bool isLoading = false;
  static const double taxRate = 0.05;

  int _subtotal = 0;
  int get subtotal => _subtotal;

  int get serviceTax => (_subtotal * taxRate).round();
  int get totalAmount => _subtotal + serviceTax;

  int _durationMinutes = 60;
  int get durationMinutes => _durationMinutes;
  String get durationLabel => '$_durationMinutes mins';

  void initFromBookingData(Map<String, dynamic> bookingData) {
    isLoading = true;
    notifyListeners();

    final services =
        bookingData['selectedServices'] as List<dynamic>? ??
        bookingData['services'] as List<dynamic>? ??
        [];

    int sum = 0;
    int duration = 0;

    for (final s in services) {
      if (s is Map) {
        sum += (s['price'] as int? ?? s['amount'] as int? ?? 0);
        duration += (s['duration'] as int? ?? 0);
      }
    }

    // Fallbacks if no valid services map found
    if (sum == 0) {
      sum =
          bookingData['totalServicePrice'] as int? ??
          bookingData['subtotal'] as int? ??
          1000;
    }

    _subtotal = sum;
    _durationMinutes = duration > 0 ? duration : 60;

    isLoading = false;
    notifyListeners();
  }
}
