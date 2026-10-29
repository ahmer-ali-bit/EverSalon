import 'package:flutter/material.dart';

class MyMembershipProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  // Membership Card Data
  String tierName = 'GOLD MEMBER';
  String memberSince = '12 Jan 2024';
  String memberId = 'GM24568';
  String status = 'Active'; // For next screen, though managed here

  // Benefits List
  List<String> benefits = [];

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// Fetch membership details
  /// TODO: BACKEND INTEGRATION - GET /api/membership
  Future<void> fetchMembership() async {
    isLoading = true;
    _safeNotify();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      // Mock Data
      tierName = 'GOLD MEMBER';
      memberSince = '12 Jan 2024';
      memberId = 'GM24568';
      status = 'Active';

      benefits = [
        '10% OFF on All Services',
        'Priority Booking',
        'Exclusive Offers',
        'Birthday Special Gift',
        'Free Hair Consultation',
      ];

      isLoading = false;
      _safeNotify();
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('fetchMembership error: $e');
    }
  }
}
