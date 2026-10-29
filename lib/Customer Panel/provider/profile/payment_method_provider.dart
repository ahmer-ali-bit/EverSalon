import 'package:flutter/material.dart';

class SavedCardModel {
  final String id;
  final String brand;
  final String maskedNumber;
  final String expiry;
  final bool isDefault;
  final String imageAsset;

  SavedCardModel({
    required this.id,
    required this.brand,
    required this.maskedNumber,
    required this.expiry,
    this.isDefault = false,
    required this.imageAsset,
  });
}

class PaymentMethodsProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  List<SavedCardModel> savedCards = [];

  PaymentMethodsProvider() {
    _fetchPaymentMethods();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  // TODO: BACKEND INTEGRATION - Fetch saved cards
  Future<void> _fetchPaymentMethods() async {
    isLoading = true;
    _safeNotify();

    // Mock API delay
    await Future.delayed(const Duration(seconds: 1));

    savedCards = [
      SavedCardModel(
        id: '1',
        brand: 'Visa',
        maskedNumber: '•••• 4242', // Updated to bullet dots like design
        expiry: '12/26',
        isDefault: true,
        imageAsset: 'assets/images/visa card.png',
      ),
      SavedCardModel(
        id: '2',
        brand: 'Mastercard',
        maskedNumber: '•••• 8888',
        expiry: '09/27',
        isDefault: false,
        imageAsset: 'assets/images/master card.png',
      ),
      SavedCardModel(
        id: '3',
        brand: 'Meezan Bank',
        maskedNumber: '•••• 1234',
        expiry: '08/25',
        isDefault: false,
        imageAsset: 'assets/images/meezan.png',
      ),
    ];

    isLoading = false;
    _safeNotify();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
