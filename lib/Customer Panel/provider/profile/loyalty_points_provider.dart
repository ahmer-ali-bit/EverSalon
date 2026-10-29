import 'package:flutter/material.dart';

class LoyaltyPointsProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  int availablePoints = 0;
  int targetPoints = 3000;
  String tierName = 'Gold Tier';

  // List of ways to earn points
  List<Map<String, dynamic>> earnPointsMethods = [];

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// Fetch loyalty points data
  /// TODO: BACKEND INTEGRATION - GET /api/loyalty/points
  Future<void> fetchLoyaltyData() async {
    isLoading = true;
    _safeNotify();

    try {
      await Future.delayed(
        const Duration(milliseconds: 600),
      ); // Mock network delay

      // TODO: Replace with real API data
      availablePoints = 2450;
      targetPoints = 3000;
      tierName = 'Gold Tier';

      earnPointsMethods = [
        {
          'icon': Icons.calendar_today_outlined,
          'title': 'Booking a Service',
          'points': '+100 Pts',
        },
        {
          'icon': Icons.star_border_rounded,
          'title': 'Write a Review',
          'points': '+50 Pts',
        },
        {
          'icon': Icons.person_add_alt_1_outlined,
          'title': 'Refer a Friend',
          'points': '+150 Pts',
        },
        {
          'icon': Icons.local_offer_outlined,
          'title': 'Special Offers',
          'points': '+? Pts',
        },
      ];

      isLoading = false;
      _safeNotify();
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('fetchLoyaltyData error: $e');
    }
  }

  /// Calculate progress percentage for the bar (0.0 to 1.0)
  double get progressValue {
    if (targetPoints == 0) return 0.0;
    return availablePoints / targetPoints;
  }

  /// Calculate points needed to reach next tier
  int get pointsAway => targetPoints - availablePoints;
}
