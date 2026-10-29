import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  // Default theme is System
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// Change theme and save preference
  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;
    _safeNotify();

    isLoading = true;
    _safeNotify();

    try {
      // TODO: BACKEND INTEGRATION - Save user theme preference to SharedPrefs or Backend API
      await Future.delayed(const Duration(milliseconds: 500));

      isLoading = false;
      _safeNotify();
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('Theme update error: $e');
    }
  }
}
