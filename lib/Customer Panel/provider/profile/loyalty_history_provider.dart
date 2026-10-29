import 'package:flutter/material.dart';

class LoyaltyHistoryProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  // Filter Dropdown state
  String selectedFilter = 'All Transactions';
  final List<String> filterOptions = [
    'All Transactions',
    'Earned Points',
    'Redeemed Points',
  ];

  // Grouped history mock data
  List<Map<String, dynamic>> historyData = [];

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// Change filter
  void setFilter(String filter) {
    if (selectedFilter != filter) {
      selectedFilter = filter;
      fetchHistory(); // Re-fetch based on filter
    }
  }

  /// Fetch history data
  /// TODO: BACKEND INTEGRATION - GET /api/loyalty/history?filter={filter}
  Future<void> fetchHistory() async {
    isLoading = true;
    _safeNotify();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      // Mock Data (Already grouped or backend will group it)
      // Usually backend sends array of objects, we map it. Here it's pre-mapped.
      historyData = [
        {
          'month': 'May 2024',
          'transactions': [
            {
              'title': 'Hair Spa Treatment',
              'subtitle': 'Booking',
              'points': '+100',
              'date': '15 May 2024',
              'isPositive': true,
              'icon': Icons.spa_outlined,
            },
            {
              'title': 'Review for Glow Beauty Lounge',
              'subtitle': 'Review',
              'points': '+50',
              'date': '14 May 2024',
              'isPositive': true,
              'icon': Icons.star_border_rounded,
            },
            {
              'title': 'Refer a Friend',
              'subtitle': 'Referral Bonus',
              'points': '+150',
              'date': '10 May 2024',
              'isPositive': true,
              'icon': Icons.people_outline_rounded,
            },
            {
              'title': 'Discount Redeemed',
              'subtitle': 'At The Glam Studio',
              'points': '-200',
              'date': '8 May 2024',
              'isPositive': false,
              'icon': Icons.favorite_border_rounded,
            },
            {
              'title': 'Facial Treatment',
              'subtitle': 'Booking',
              'points': '+100',
              'date': '5 May 2024',
              'isPositive': true,
              'icon': Icons.face_retouching_natural_rounded,
            },
          ],
        },
      ];

      isLoading = false;
      _safeNotify();
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('fetchHistory error: $e');
    }
  }
}
