import 'package:flutter/material.dart';

class CompletedBookingProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSubmitting = false;
  bool _isDisposed = false;

  Map<String, dynamic> bookingData = {};

  // Review States
  int currentRating = 0;
  final TextEditingController reviewController = TextEditingController();

  void initData(Map<String, dynamic> data) {
    bookingData = Map<String, dynamic>.from(data);
    notifyListeners();
  }

  void setRating(int rating) {
    currentRating = rating;
    notifyListeners();
  }

  // ========================================================
  // TODO: BACKEND INTEGRATION - POST /api/reviews
  // Body: { "bookingId": id, "rating": currentRating, "review": reviewController.text }
  // ========================================================
  Future<bool> submitReview() async {
    if (currentRating == 0) return false; // Rating is mandatory

    isSubmitting = true;
    notifyListeners();

    try {
      // API call simulation
      await Future.delayed(const Duration(milliseconds: 800));
      return true;
    } catch (e) {
      debugPrint('Submit Review Error: $e');
      return false;
    } finally {
      if (!_isDisposed) {
        isSubmitting = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    reviewController.dispose();
    super.dispose();
  }
}
