import 'package:flutter/material.dart';

class ResetPasswordProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ========================================================
  // BACKEND INTEGRATION: RESET PASSWORD API
  // ========================================================
  Future<bool> resetPassword({
    required String newPassword,
    required String confirmPassword,
    // Optional: pass token/otp/email from previous screen
    String? resetToken,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: CALL ACTUAL REST API HERE
      // Example:
      // final response = await http.post(
      //   Uri.parse('https://api.eversalon.com/auth/reset-password'),
      //   body: {
      //     'token': resetToken,
      //     'password': newPassword,
      //     'password_confirmation': confirmPassword,
      //   },
      // );
      //
      // if (response.statusCode == 200) {
      //   return true;
      // } else {
      //   _errorMessage = jsonDecode(response.body)['message'] ?? 'Reset failed';
      //   return false;
      // }

      // Simulate API network delay
      await Future.delayed(const Duration(seconds: 2));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to reset password. Please try again.';
      notifyListeners();
      return false;
    }
  }
}
