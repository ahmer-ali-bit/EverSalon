import 'package:flutter/material.dart';

class AdminSettingsProvider extends ChangeNotifier {
  bool _isDisposed = false;

  // You can load initial settings preferences here if needed from APIs
  AdminSettingsProvider();

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
