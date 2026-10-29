import 'package:flutter/material.dart';

class PaymentProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND - POST /api/bookings (with paymentMethod)
  // Online / Card / UPI / Wallet → payment gateway
  // Cash → paymentStatus: pay_at_salon
  // ========================================================

  bool isProcessing = false;

  String selectedMethod = 'online';

  /// image path = assets/images/{id}.png
  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'online',
      'titleKey': 'Payment Online',
      'subtitleKey': 'Pay securely using card, UPI etc.',
      'image': 'assets/images/online.png',
      'icon': Icons.language_rounded,
    },
    {
      'id': 'card',
      'titleKey': 'Payment Card',
      'subtitleKey': 'Visa / Master / RuPay',
      'image': 'assets/images/card.png',
      'icon': Icons.credit_card_rounded,
    },
    {
      'id': 'upi',
      'titleKey': 'Payment UPI',
      'subtitleKey': 'Pay using any UPI app',
      'image': 'assets/images/upi.png',
      'icon': Icons.qr_code_rounded,
    },
    {
      'id': 'wallet',
      'titleKey': 'payment Wallet',
      'subtitleKey': 'PhonePo, PayTm, JazzCash etc.',
      'image': 'assets/images/wallet.png',
      'icon': Icons.account_balance_wallet_rounded,
    },
    {
      'id': 'cash',
      'titleKey': 'Payment Cash',
      'subtitleKey': 'Pay at the salon',
      'image': 'assets/images/cash.png',
      'icon': Icons.payments_outlined,
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
      // TODO: BACKEND API call here
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
