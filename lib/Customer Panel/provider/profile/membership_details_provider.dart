import 'package:flutter/material.dart';

class MembershipDetailsProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  String tierName = 'GOLD MEMBER';
  String validTill = '12 Jan 2025';
  String status = 'Active';
  int starCount = 5;

  List<Map<String, dynamic>> benefits = [];

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// TODO: BACKEND INTEGRATION - GET /api/membership/details
  Future<void> fetchMembershipDetails() async {
    isLoading = true;
    _safeNotify();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      // TODO: BACKEND INTEGRATION - GET /api/membership/details
      tierName = 'GOLD MEMBER';
      validTill = '12 Jan 2025';
      status = 'Active';
      starCount = 5;

      benefits = [
        {
          'icon': Icons.local_offer_outlined,
          'title': '10% OFF on All Services',
          'subtitle': 'Applicable on all salon services',
        },
        {
          'icon': Icons.priority_high_rounded,
          'title': 'Priority Booking',
          'subtitle': 'Get early access to bookings',
        },
        {
          'icon': Icons.card_giftcard_outlined,
          'title': 'Exclusive Offers',
          'subtitle': 'Special member-only offers',
        },
        {
          'icon': Icons.cake_outlined,
          'title': 'Birthday Special Gift',
          'subtitle': 'Enjoy a surprise gift on your birthday',
        },
        {
          'icon': Icons.content_cut_rounded,
          'title': 'Free Hair Consultation',
          'subtitle': 'One free consultation every month',
        },
      ];

      isLoading = false;
      _safeNotify();
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('fetchMembershipDetails error: $e');
    }
  }
}
