import 'package:flutter/material.dart';

class AdminDashboardProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;

  String selectedDate = "May 15, 2024";

  // Pre-initialized map to avoid null runtime errors during build
  Map<String, Map<String, String>> stats = {
    'bookings': {'value': '128', 'trend': '+15%'},
    'revenue': {'value': 'Rs. 45,600', 'trend': '+12%'},
    'customers': {'value': '86', 'trend': '+10%'},
    'services': {'value': '56', 'trend': '+8%'},
  };

  List<Map<String, String>> recentBookings = [];

  AdminDashboardProvider() {
    _fetchDashboardData();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> _fetchDashboardData() async {
    isLoading = true;
    _safeNotify();

    // TODO: BACKEND INTEGRATION - GET /api/admin/dashboard
    await Future.delayed(const Duration(milliseconds: 500));

    recentBookings = [
      {
        'customerName': 'Sara Khan',
        'service': 'Hair Spa Treatment',
        'time': '10:00 AM',
        'status': 'Confirmed',
        'image': 'assets/images/users/sara.png',
      },
      {
        'customerName': 'Ayesha Malik',
        'service': 'Bridal Makeup',
        'time': '11:30 AM',
        'status': 'Confirmed',
        'image': 'assets/images/users/ayesha.png',
      },
      {
        'customerName': 'Hina Fatima',
        'service': 'Hair Cut & Styling',
        'time': '01:00 PM',
        'status': 'Pending',
        'image': 'assets/images/users/hina.png',
      },
    ];

    isLoading = false;
    _safeNotify();
  }

  void updateDate(String newDate) {
    selectedDate = newDate;
    _safeNotify();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
