import 'package:flutter/material.dart';

class AdminProfileProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  // Admin Data
  String name = "Kiran Fatima";
  String email = "kiran@eversalon.com";
  String role = "Admin";
  String avatar = "assets/images/users/kiran.png";

  // Preferences
  bool isTwoFactorOn = true;
  String currentLanguage = "English";

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  void toggleTwoFactor(bool val) {
    isTwoFactorOn = val;
    _safeNotify();
  }

  void setLanguage(String lang) {
    currentLanguage = lang;
    _safeNotify();
  }

  Future<void> logout(BuildContext context) async {
    isLoading = true;
    _safeNotify();

    // Mock Logout API / Clear SharedPreferences
    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    _safeNotify();

    if (context.mounted) {
      // NAVIGATION: To Login Screen (Clear Stack)
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
