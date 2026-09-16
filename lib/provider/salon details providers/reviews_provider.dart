import 'package:flutter/material.dart';

class ReviewsProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND INTEGRATION - GET REVIEWS API
  // Endpoint: GET /api/salons/{salonId}/reviews
  // Returns: Overall rating, breakdown stats, and list of reviews
  // ========================================================

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Breakdown Data matching the UI design exactly
  final double overallRating = 4.8;
  final int totalReviews = 256;
  final Map<int, int> ratingBreakdown = {5: 198, 4: 42, 3: 10, 2: 3, 1: 3};

  List<Map<String, dynamic>> _reviews = [];
  List<Map<String, dynamic>> get reviews => _reviews;

  void fetchReviews(String salonId) async {
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    // Mock API Delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock Review Data exactly matching the UI image
    _reviews = [
      {
        'id': '1',
        'userName': 'Zainab Fatima',
        'userImage': 'assets/images/beautician.png', // Using available avatar
        'rating': 5.0,
        'date': '2 days ago',
        'comment':
            'Amazing service and very professional staff. Highly recommended!',
        'images': [
          'assets/images/spa.png', // Reusing available salon images for review
          'assets/images/skin care.png',
          'assets/images/bridal.png',
        ],
      },
      // You can add more mock reviews here if needed...
    ];

    _isLoading = false;
    notifyListeners();
  }
}
