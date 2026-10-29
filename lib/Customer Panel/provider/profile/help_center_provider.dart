import 'package:flutter/material.dart';

class HelpCenterProvider extends ChangeNotifier {
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

  /// Simulate an action like starting a live chat or submitting an issue
  Future<void> initiateSupportAction(String actionType) async {
    isLoading = true;
    _safeNotify();

    try {
      // TODO: BACKEND INTEGRATION - Create support ticket or init chat
      await Future.delayed(const Duration(milliseconds: 600));

      isLoading = false;
      _safeNotify();
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('Support action error: $e');
    }
  }
}
