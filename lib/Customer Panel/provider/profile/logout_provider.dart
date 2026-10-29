import 'package:flutter/material.dart';

class LogoutProvider extends ChangeNotifier {
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

  /// Perform User Logout
  Future<bool> performLogout() async {
    isLoading = true;
    _safeNotify();

    try {
      // TODO: BACKEND INTEGRATION - Clear auth token, session data, user preferences
      // e.g. await SharedPreferences.getInstance()..clear();
      // e.g. POST /api/auth/logout
      await Future.delayed(const Duration(milliseconds: 800)); // Mock delay

      isLoading = false;
      _safeNotify();
      return true; // Success
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('Logout error: $e');
      return false;
    }
  }
}
