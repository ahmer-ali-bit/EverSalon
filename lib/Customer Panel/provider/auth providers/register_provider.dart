import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ========================================================
  // BACKEND INTEGRATION: REGISTER API
  // ========================================================
  Future<bool> register({
    required String fullName,
    required String emailOrPhone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: CALL ACTUAL REST API HERE
      // Example:
      // final response = await http.post(
      //   Uri.parse('https://api.eversalon.com/auth/register'),
      //   body: {'name': fullName, 'email': emailOrPhone, 'password': password},
      // );

      await Future.delayed(const Duration(seconds: 2));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Registration failed. Try again later.';
      notifyListeners();
      return false;
    }
  }
}
