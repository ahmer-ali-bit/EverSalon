import 'package:flutter/material.dart';

class AccountSettingsProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// TODO: BACKEND INTEGRATION - DELETE /api/account
  Future<void> deleteAccount(BuildContext context) async {
    isLoading = true;
    _safeNotify();

    try {
      // Mock delay
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Call API to delete account, clear local storage

      isLoading = false;
      _safeNotify();

      // Navigate to splash/login screen (adjust route based on your auth setup)
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('deleteAccount error: $e');
    }
  }

  /// TODO: BACKEND INTEGRATION - POST /api/logout
  Future<void> logout(BuildContext context) async {
    isLoading = true;
    _safeNotify();

    try {
      // Mock delay
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Call API to logout, clear token

      isLoading = false;
      _safeNotify();

      // Navigate to login screen
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('logout error: $e');
    }
  }
}
