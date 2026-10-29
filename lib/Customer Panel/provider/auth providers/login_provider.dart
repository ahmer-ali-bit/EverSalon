import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ========================================================
  // BACKEND INTEGRATION: LOGIN API
  // ========================================================
  Future<bool> login({
    required String emailOrPhone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // UI updates to show loading spinner

    try {
      // TODO: CALL ACTUAL REST API HERE
      // Example:
      // final response = await http.post(
      //   Uri.parse('https://api.eversalon.com/auth/login'),
      //   body: {'email': emailOrPhone, 'password': password},
      // );
      //
      // if(response.statusCode == 200) {
      //    // Save user token to global state or SharedPreferences
      //    return true;
      // } else {
      //    _errorMessage = jsonDecode(response.body)['message'];
      //    return false;
      // }

      // Simulating API network delay
      await Future.delayed(const Duration(seconds: 2));

      _isLoading = false;
      notifyListeners();
      return true; // Return true on success
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Login failed. Please check your network and try again.';
      notifyListeners();
      return false; // Return false on error
    }
  }
}
