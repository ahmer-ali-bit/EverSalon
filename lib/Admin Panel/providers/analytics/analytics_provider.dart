import 'package:flutter/material.dart';

class AdminAnalyticsProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;

  String selectedDateRange = "May 1 - May 15, 2024";
  final List<String> dateRanges = [
    "May 1 - May 15, 2024",
    "Apr 15 - Apr 30, 2024",
  ];

  String totalRevenue = "Rs. 245,600";
  String revenueTrend = "+18% vs last 15 days";

  // Data for line chart (Mock values representing daily revenue)
  List<double> revenueData = [];

  // Data for popular services bar chart
  List<Map<String, dynamic>> popularServices = [];

  AdminAnalyticsProvider() {
    _fetchAnalytics();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> _fetchAnalytics() async {
    isLoading = true;
    _safeNotify();

    // Mock API Delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Chart points
    revenueData = [10, 25, 18, 35, 30, 50, 45, 70, 65, 80, 90, 85, 100];

    popularServices = [
      {
        'name': 'Hair Spa Treatment',
        'count': 120,
        'percentage': 1.0,
      }, // Highest gets 1.0
      {'name': 'Bridal Makeup', 'count': 85, 'percentage': 0.7},
      {'name': 'Hair Cut & Styling', 'count': 75, 'percentage': 0.6},
      {'name': 'Facial', 'count': 60, 'percentage': 0.5},
      {'name': 'Manicure', 'count': 45, 'percentage': 0.35},
    ];

    isLoading = false;
    _safeNotify();
  }

  void updateDateRange(String? newRange) {
    if (newRange != null) {
      selectedDateRange = newRange;
      // You can add logic here to fetch new data based on date
      _safeNotify();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
