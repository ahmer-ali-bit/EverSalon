import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND INTEGRATION - POST /api/payments
  // Send selected payment method & booking details
  // ========================================================

  bool isLoading = false;
  bool isProcessing = false;

  // Selected method key (default: 'online')
  String selectedMethod = 'online';

  // Payment Methods with Image Assets matching their name/id
  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'online',
      'title': 'Online Payment',
      'subtitle': 'Pay securely using card, UPI etc.',
      'image': 'assets/images/online payment.png',
    },
    {
      'id': 'card',
      'title': 'Credit / Debit Card',
      'subtitle': 'VISA  ·  Mastercard  ·  RuPay',
      'image': 'assets/images/card.png',
    },
    {
      'id': 'upi',
      'title': 'UPI',
      'subtitle': 'Pay using any UPI app',
      'image': 'assets/images/upi.png',
    },
    {
      'id': 'wallet',
      'title': 'Wallets',
      'subtitle': 'PhonePe, Paytm, JazzCash etc.',
      'image': 'assets/images/wallet.png',
    },
    {
      'id': 'cash',
      'title': 'Cash at Salon',
      'subtitle': 'Pay at the salon',
      'image': 'assets/images/cash.png',
    },
  ];

  void selectMethod(String id) {
    selectedMethod = id;
    notifyListeners();
  }

  bool isSelected(String id) => selectedMethod == id;

  Future<bool> processPayment(Map<String, dynamic> bookingData) async {
    isProcessing = true;
    notifyListeners();

    try {
      // TODO: Call Backend Payment API / Gateway SDK
      await Future.delayed(const Duration(milliseconds: 800));
      return true;
    } catch (e) {
      debugPrint('Payment error: $e');
      return false;
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }
}
