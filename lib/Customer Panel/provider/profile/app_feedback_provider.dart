import 'package:flutter/material.dart';

class AppFeedbackProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  int rating = 0; // 0 to 5

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  void setRating(int value) {
    rating = value;
    _safeNotify();
  }

  Future<bool> submitFeedback(String feedbackText) async {
    if (rating == 0) {
      return false; // Rating is mandatory
    }

    isLoading = true;
    _safeNotify();

    try {
      // TODO: BACKEND INTEGRATION - POST /api/feedback
      await Future.delayed(const Duration(seconds: 1)); // Mock API delay

      isLoading = false;
      _safeNotify();
      return true; // Success
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('Submit feedback error: $e');
      return false;
    }
  }
}
