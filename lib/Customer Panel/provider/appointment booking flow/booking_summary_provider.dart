import 'package:flutter/material.dart';

class BookingSummaryProvider extends ChangeNotifier {
  bool isLoading = true;

  // Pricing details
  int _subtotal = 0;
  int _serviceTax = 0;
  int _totalAmount = 0;

  int get subtotal => _subtotal;
  int get serviceTax => _serviceTax;
  int get totalAmount => _totalAmount;

  void init(Map<String, dynamic> bookingData) {
    _calculatePrices(bookingData);
  }

  void _calculatePrices(Map<String, dynamic> bookingData) {
    final String flowType = bookingData['flowType'] ?? 'service';

    if (flowType == 'package') {
      _subtotal = bookingData['packagePrice'] as int? ?? 0;
    } else {
      _subtotal = bookingData['servicesTotal'] as int? ?? 0;
    }

    // Calculate 5% tax
    _serviceTax = (_subtotal * 0.05).round();
    _totalAmount = _subtotal + _serviceTax;

    isLoading = false;
    notifyListeners();
  }
}
