import 'package:flutter/material.dart';

class AdminReviewsProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;

  // Global Review Analytics
  double averageRating = 4.7;
  int totalReviewsCount = 312;
  Map<int, int> ratingBreakdown = {5: 220, 4: 65, 3: 15, 2: 8, 1: 4};

  // State Management
  int selectedFilterStars = 0; // 0 means 'All'
  List<Map<String, dynamic>> allReviews = [];

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // =========================================================================
  // ⚡ BACKEND INTEGRATION - GET REVIEWS
  // API Endpoint: GET /api/admin/reviews
  // Query Parameters (Optional): rating={1-5}, page=1, limit=10
  // Description: Fetches all customer reviews with pagination and ratings metrics.
  // =========================================================================
  Future<void> fetchAllReviews() async {
    isLoading = true;
    _safeNotify();

    // Simulating API loading latency
    await Future.delayed(const Duration(milliseconds: 600));

    allReviews = [
      {
        'id': 'REV_101',
        'customerName': 'Sara Khan',
        'customerAvatar': 'assets/images/users/sara.png',
        'rating': 5.0,
        'date': '2 hours ago',
        'comment':
            'Absolutely beautiful interior and extremely professional hair massage! Kiran Fatima is the absolute best. Will visit weekly.',
        'serviceUsed': 'Hair Spa & Blow Dry',
        'isFlagged': false,
        'isHidden': false,
        'adminReply':
            'Thank you so much Sara! We look forward to treating you again next week.',
      },
      {
        'id': 'REV_102',
        'customerName': 'Ayesha Malik',
        'customerAvatar': 'assets/images/users/ayesha.png',
        'rating': 4.0,
        'date': 'Yesterday',
        'comment':
            'Good services overall. Gel nails look pristine. However, had to wait 15 minutes past my slot start time.',
        'serviceUsed': 'Gel Manicure',
        'isFlagged': false,
        'isHidden': false,
        'adminReply': '',
      },
      {
        'id': 'REV_103',
        'customerName': 'Hina Fatima',
        'customerAvatar': 'assets/images/users/hina.png',
        'rating': 2.0,
        'date': '3 days ago',
        'comment':
            'Staff seemed super rushed. The classic pedicure scrub was way too harsh on my heels. Mildly disappointed.',
        'serviceUsed': 'Classic Pedicure',
        'isFlagged': true,
        'isHidden': false,
        'adminReply': '',
      },
      {
        'id': 'REV_104',
        'customerName': 'Zainab Noor',
        'customerAvatar': 'assets/images/users/zainab.png',
        'rating': 5.0,
        'date': '1 week ago',
        'comment':
            'Highly precise bridal services! Exceptional execution by the staff.',
        'serviceUsed': 'Bridal Makeup',
        'isFlagged': false,
        'isHidden': false,
        'adminReply':
            'Congratulations again Zainab! Honored to be part of your big day.',
      },
      {
        'id': 'REV_105',
        'customerName': 'Spam Account',
        'customerAvatar': '',
        'rating': 1.0,
        'date': '2 weeks ago',
        'comment': 'TERRIBLE! SCAM SERVICES! DO NOT GO!',
        'serviceUsed': 'Threading',
        'isFlagged': true,
        'isHidden': true, // Hidden from customer app views
        'adminReply': '',
      },
    ];

    isLoading = false;
    _safeNotify();
  }

  /// Sets active rating filter (0 = All, 1-5 for specific stars)
  void setRatingFilter(int stars) {
    selectedFilterStars = stars;
    _safeNotify();
  }

  /// Returns reviews dynamic list filtered by current filter state
  List<Map<String, dynamic>> get filteredReviews {
    if (selectedFilterStars == 0) {
      return allReviews;
    }
    return allReviews
        .where(
          (rev) => (rev['rating'] as double).toInt() == selectedFilterStars,
        )
        .toList();
  }

  // =========================================================================
  // ⚡ BACKEND INTEGRATION - SUBMIT / UPDATE REPLY
  // API Endpoint: POST /api/admin/reviews/{reviewId}/reply
  // Request Body: { "reply": "Your message text here" }
  // =========================================================================
  Future<bool> replyToReview(String reviewId, String replyText) async {
    final index = allReviews.indexWhere((element) => element['id'] == reviewId);
    if (index != -1) {
      allReviews[index]['adminReply'] = replyText;
      _safeNotify();

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 300));
      return true;
    }
    return false;
  }

  // =========================================================================
  // ⚡ BACKEND INTEGRATION - TOGGLE VISIBILITY (HIDE/SHOW)
  // API Endpoint: PUT /api/admin/reviews/{reviewId}/toggle-visibility
  // Request Body: { "isHidden": true/false }
  // =========================================================================
  Future<void> toggleReviewVisibility(String reviewId) async {
    final index = allReviews.indexWhere((element) => element['id'] == reviewId);
    if (index != -1) {
      final currentStatus = allReviews[index]['isHidden'] as bool;
      allReviews[index]['isHidden'] = !currentStatus;
      _safeNotify();

      await Future.delayed(const Duration(milliseconds: 250));
    }
  }

  // =========================================================================
  // ⚡ BACKEND INTEGRATION - DELETE REVIEW
  // API Endpoint: DELETE /api/admin/reviews/{reviewId}
  // =========================================================================
  Future<void> deleteReview(String reviewId) async {
    allReviews.removeWhere((element) => element['id'] == reviewId);
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 200));
  }
}
