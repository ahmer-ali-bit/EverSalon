import 'package:flutter/material.dart';

class AddAddressProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  // Form states
  String selectedType = 'Home'; // Default selection
  bool isDefault = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  void setType(String type) {
    selectedType = type;
    _safeNotify();
  }

  void toggleDefault(bool value) {
    isDefault = value;
    _safeNotify();
  }

  /// Submit Form
  Future<bool> saveAddress({
    required String name,
    required String phone,
    required String address,
  }) async {
    if (name.isEmpty || phone.isEmpty || address.isEmpty) {
      return false; // Validation failed
    }

    isLoading = true;
    _safeNotify();

    try {
      // TODO: BACKEND INTEGRATION - POST /api/addresses
      await Future.delayed(const Duration(seconds: 1)); // Mock API call

      isLoading = false;
      _safeNotify();
      return true; // Success
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('saveAddress error: $e');
      return false;
    }
  }
}
