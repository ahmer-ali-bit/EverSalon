import 'package:flutter/material.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ========================================================
  // BACKEND INTEGRATION: FORGOT PASSWORD API
  // ========================================================
  Future<bool> sendResetLink(String emailOrPhone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // UI updates to show loading spinner

    try {
      // TODO: CALL ACTUAL REST API HERE
      // Example:
      // final response = await http.post(
      //   Uri.parse('https://api.eversalon.com/auth/forgot-password'),
      //   body: {'email': emailOrPhone},
      // );
      //
      // if(response.statusCode == 200) {
      //    return true; // Link sent successfully
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
      _errorMessage = 'Failed to send reset link. Please try again.';
      notifyListeners();
      return false; // Return false on error
    }
  }
}
