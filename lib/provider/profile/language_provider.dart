import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  // Selected Language Name
  String _selectedLanguage = 'English';
  String get selectedLanguage => _selectedLanguage;

  // Selected Language Code (for future localization)
  String _selectedCode = 'en';
  String get selectedCode => _selectedCode;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// Change Language Method - Instant update
  Future<void> changeLanguage(String languageName, String code) async {
    if (_selectedLanguage == languageName) return;

    // 1. Instant UI update
    _selectedLanguage = languageName;
    _selectedCode = code;
    _safeNotify();

    // 2. Mock API delay in background
    isLoading = true;
    _safeNotify();

    try {
      // TODO: BACKEND INTEGRATION - Save language preference in SharedPreferences / API
      await Future.delayed(const Duration(milliseconds: 400));
      isLoading = false;
      _safeNotify();
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('Language update error: $e');
    }
  }
}
