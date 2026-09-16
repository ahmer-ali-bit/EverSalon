import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddNewCardProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  // Live Card Details (raw values without spaces)
  String cardNumber = '';
  String cardHolderName = '';
  String expiryDate = '';
  String cvv = '';
  bool saveCardForFuture = true;

  // Controllers so formatters work smoothly with live preview
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardHolderController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  void updateCardNumber(String value) {
    // Store only digits
    cardNumber = value.replaceAll(RegExp(r'\D'), '');
    _safeNotify();
  }

  void updateCardHolderName(String value) {
    cardHolderName = value;
    _safeNotify();
  }

  void updateExpiryDate(String value) {
    // Store as typed (formatter already adds /)
    expiryDate = value;
    _safeNotify();
  }

  void updateCvv(String value) {
    cvv = value.replaceAll(RegExp(r'\D'), '');
    _safeNotify();
  }

  void toggleSaveCard(bool value) {
    saveCardForFuture = value;
    _safeNotify();
  }

  // TODO: BACKEND INTEGRATION - Save Card API
  Future<void> saveCard(BuildContext context) async {
    if (cardNumber.length < 15 ||
        cardHolderName.trim().isEmpty ||
        expiryDate.length < 5 ||
        cvv.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all card details correctly')),
      );
      return;
    }

    isLoading = true;
    _safeNotify();

    // Mock API Delay
    await Future.delayed(const Duration(seconds: 2));

    isLoading = false;
    _safeNotify();

    if (context.mounted) {
      Navigator.pop(context, true); // return success
    }
  }

  // ===== LIVE PREVIEW GETTERS =====
  String get formattedCardNumber {
    if (cardNumber.isEmpty) return '4242  4242  4242  4242';
    final buffer = StringBuffer();
    for (int i = 0; i < cardNumber.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write('  ');
      buffer.write(cardNumber[i]);
    }
    // Pad remaining with dots feel (optional)
    return buffer.toString();
  }

  String get displayExpiry {
    if (expiryDate.isEmpty) return 'MM/YY';
    return expiryDate;
  }

  String get displayName {
    if (cardHolderName.trim().isEmpty) return 'Zainab Fatima';
    return cardHolderName.trim();
  }

  @override
  void dispose() {
    _isDisposed = true;
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }
}

// ============================================================
// CUSTOM INPUT FORMATTERS
// ============================================================

/// Card Number: 4242 4242 4242 4242 (space after every 4 digits)
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Keep only digits
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 16) digits = digits.substring(0, 16);

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Expiry Date: MM/YY (auto slash after 2 digits)
class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Keep only digits
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 4) digits = digits.substring(0, 4);

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
