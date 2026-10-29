import 'package:flutter/material.dart';

class AdminCustomerDetailProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;

  String id = '';
  String name = '';
  String phone = '';
  String email = '';
  String avatar = '';
  String tag = 'Regular';
  String notes = '';
  bool isBlocked = false;

  double totalSpending = 0.0;
  int loyaltyPoints = 0;
  String membershipTier = 'None';
  List<String> favoriteServices = [];
  List<Map<String, dynamic>> bookingHistory = [];

  // ✅ AUTO LOYALTY CONFIG (Admin can change from Loyalty Settings)
  static int pointsRate = 100; // Rs. 100 spend = 1 point
  static Map<String, int> tierThresholds = {
    'Bronze': 0,
    'Silver': 5000,
    'Gold': 15000,
    'Platinum': 30000,
  };

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // ✅ AUTO TIER CALCULATOR
  String _calculateTier(int points) {
    if (points >= tierThresholds['Platinum']!) return 'Platinum';
    if (points >= tierThresholds['Gold']!) return 'Gold';
    if (points >= tierThresholds['Silver']!) return 'Silver';
    return 'Bronze';
  }

  // ✅ AUTO POINTS CALCULATOR
  int _calculatePoints(double spending) {
    return (spending / pointsRate).floor();
  }

  // ✅ NEXT TIER PROGRESS (0.0 to 1.0)
  double get nextTierProgress {
    final currentTier = membershipTier;
    int currentThreshold = tierThresholds[currentTier] ?? 0;
    int nextThreshold;

    if (currentTier == 'Bronze') {
      nextThreshold = tierThresholds['Silver']!;
    } else if (currentTier == 'Silver')
      nextThreshold = tierThresholds['Gold']!;
    else if (currentTier == 'Gold')
      nextThreshold = tierThresholds['Platinum']!;
    else
      return 1.0; // Platinum = max

    final range = nextThreshold - currentThreshold;
    if (range <= 0) return 1.0;
    final progress = (loyaltyPoints - currentThreshold) / range;
    return progress.clamp(0.0, 1.0);
  }

  String get nextTierName {
    if (membershipTier == 'Bronze') return 'Silver';
    if (membershipTier == 'Silver') return 'Gold';
    if (membershipTier == 'Gold') return 'Platinum';
    return 'Max';
  }

  int get nextTierPointsNeeded {
    if (membershipTier == 'Bronze') {
      return tierThresholds['Silver']! - loyaltyPoints;
    }
    if (membershipTier == 'Silver') {
      return tierThresholds['Gold']! - loyaltyPoints;
    }
    if (membershipTier == 'Gold') {
      return tierThresholds['Platinum']! - loyaltyPoints;
    }
    return 0;
  }

  // =========================================================================
  // ⚡ BACKEND: GET /api/admin/customers/{id}
  // =========================================================================
  Future<void> fetchCustomerDetails(String customerId) async {
    isLoading = true;
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 600));

    id = customerId;

    if (customerId == 'C1') {
      name = 'Sara Khan';
      phone = '+92 300 1234567';
      email = 'sara.khan@gmail.com';
      avatar = 'assets/images/users/sara.png';
      tag = 'VIP';
      notes = 'Prefers premium products. Always requests senior stylist Kiran.';
      isBlocked = false;
      totalSpending = 24500.0;
      favoriteServices = [
        'Bridal Makeup',
        'Hair Spa treatment',
        'Gel Manicure',
      ];
      bookingHistory = [
        {
          'bookingId': 'B9901',
          'service': 'Bridal Makeup',
          'dateTime': '24 Oct 2023, 10:00 AM',
          'amount': 15000.0,
          'status': 'Completed',
          'staff': 'Kiran Fatima',
        },
        {
          'bookingId': 'B9582',
          'service': 'Hair Spa & Blow dry',
          'dateTime': '12 Sep 2023, 04:30 PM',
          'amount': 4500.0,
          'status': 'Completed',
          'staff': 'Ayesha',
        },
        {
          'bookingId': 'B9120',
          'service': 'Gel Manicure',
          'dateTime': '05 Aug 2023, 01:00 PM',
          'amount': 5000.0,
          'status': 'Completed',
          'staff': 'Hina',
        },
      ];
    } else if (customerId == 'C2') {
      name = 'Ayesha Malik';
      phone = '+92 301 2345678';
      email = 'ayesha.malik@outlook.com';
      avatar = 'assets/images/users/ayesha.png';
      tag = 'VIP';
      notes = 'Allergic to specific brand dyes.';
      isBlocked = false;
      totalSpending = 18200.0;
      favoriteServices = ['Keratin Treatment', 'Classic Pedicure'];
      bookingHistory = [
        {
          'bookingId': 'B8842',
          'service': 'Keratin Treatment',
          'dateTime': '15 Oct 2023, 12:00 PM',
          'amount': 14000.0,
          'status': 'Completed',
          'staff': 'Kiran Fatima',
        },
        {
          'bookingId': 'B8110',
          'service': 'Classic Pedicure',
          'dateTime': '28 Aug 2023, 02:00 PM',
          'amount': 4200.0,
          'status': 'Completed',
          'staff': 'Zainab',
        },
      ];
    } else {
      name = 'Client $customerId';
      phone = '+92 300 0000000';
      email = 'client@eversalon.com';
      avatar = '';
      tag = 'Regular';
      notes = '';
      isBlocked = false;
      totalSpending = 3500.0;
      favoriteServices = ['Haircut & Wash'];
      bookingHistory = [
        {
          'bookingId': 'B5001',
          'service': 'Haircut & Wash',
          'dateTime': '10 Nov 2023, 11:30 AM',
          'amount': 3500.0,
          'status': 'Completed',
          'staff': 'Unknown',
        },
      ];
    }

    // ✅ AUTO CALCULATE LOYALTY
    loyaltyPoints = _calculatePoints(totalSpending);
    membershipTier = _calculateTier(loyaltyPoints);

    isLoading = false;
    _safeNotify();
  }

  void toggleBlockStatus() {
    isBlocked = !isBlocked;
    _safeNotify();
  }

  void updateTag(String newTag) {
    tag = newTag;
    _safeNotify();
  }

  void updateNotes(String newNotes) {
    notes = newNotes;
    _safeNotify();
  }

  // ✅ MANUAL POINTS ADJUSTMENT (Admin can add/deduct)
  // =========================================================================
  // ⚡ BACKEND: POST /api/admin/customers/{id}/adjust-points
  // Body: { "points": 500, "reason": "Birthday bonus" }
  // =========================================================================
  void adjustPoints(int points, String reason) {
    loyaltyPoints += points;
    if (loyaltyPoints < 0) loyaltyPoints = 0;
    membershipTier = _calculateTier(loyaltyPoints);
    _safeNotify();
  }

  Future<bool> sendCustomOffer(String title, String message) async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('Push to $name: [$title] - $message');
    return true;
  }
}
