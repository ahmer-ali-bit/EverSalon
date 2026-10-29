import 'package:flutter/material.dart';

class ManageBookingProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;
  String selectedFilter = 'All';

  final List<String> filters = [
    'All',
    'Confirmed',
    'Pending',
    'Cancelled',
    'Rescheduling',
  ];

  // ✅ SESSION PERSISTENCE: Static list preserves bookings across screen navigations
  static List<Map<String, String>> _sessionBookings = [];

  List<Map<String, String>> allBookings = [];

  ManageBookingProvider() {
    _fetchBookings();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> _fetchBookings() async {
    isLoading = true;
    _safeNotify();

    // Simulating mock database loading latency
    await Future.delayed(const Duration(milliseconds: 300));

    // Initialize static list ONLY ONCE per app launch
    if (_sessionBookings.isEmpty) {
      _sessionBookings = [
        {
          'id': 'ESR1240520',
          'customerName': 'Hina Fatima',
          'customerAvatar': 'assets/images/users/hina.png',
          'service': 'Gel Manicure & Polish',
          'dateTime': '18 May 2024, 02:30 PM',
          'price': 'Rs. 1,500',
          'status': 'Reschedule Pending',
        },
        {
          'id': 'ESR1240516',
          'customerName': 'Sara Khan',
          'customerAvatar': 'assets/images/users/sara.png',
          'service': 'Hair Spa Treatment',
          'dateTime': '15 May 2024, 10:00 AM',
          'price': 'Rs. 2,000',
          'status': 'Confirmed',
        },
        {
          'id': 'ESR1240517',
          'customerName': 'Ayesha Malik',
          'customerAvatar': 'assets/images/users/ayesha.png',
          'service': 'Bridal Makeup',
          'dateTime': '15 May 2024, 11:30 AM',
          'price': 'Rs. 5,500',
          'status': 'Confirmed',
        },
        {
          'id': 'ESR1240518',
          'customerName': 'Hina Fatima',
          'customerAvatar': 'assets/images/users/hina.png',
          'service': 'Hair Cut & Styling',
          'dateTime': '15 May 2024, 01:00 PM',
          'price': 'Rs. 1,200',
          'status': 'Pending',
        },
        {
          'id': 'ESR1240519',
          'customerName': 'Zainab Noor',
          'customerAvatar': 'assets/images/users/zainab.png',
          'service': 'Facial',
          'dateTime': '15 May 2024, 02:30 PM',
          'price': 'Rs. 1,500',
          'status': 'Cancelled',
        },
      ];
    }

    // Sync instance state with our persistent session data
    allBookings = List.from(_sessionBookings);
    isLoading = false;
    _safeNotify();
  }

  void setFilter(String filter) {
    selectedFilter = filter;
    _safeNotify();
  }

  // ✅ ADDED: Add new walk-in booking safely to static session
  // =========================================================================
  // ⚡ BACKEND: POST /api/admin/bookings/manual
  // =========================================================================
  void addNewWalkInBooking(Map<String, String> newBooking) {
    _sessionBookings.insert(0, newBooking); // Insert to static session cache
    allBookings = List.from(_sessionBookings); // Sync local list
    selectedFilter = 'All'; // Reset filter to show the new card
    _safeNotify();
  }

  // ✅ UPDATED: Update status safely inside static session
  // =========================================================================
  // ⚡ BACKEND: PATCH /api/admin/bookings/{id}/status
  // =========================================================================
  void updateBookingStatus(String id, String newStatus) {
    // Update inside session storage
    final sessionIndex = _sessionBookings.indexWhere((b) => b['id'] == id);
    if (sessionIndex != -1) {
      _sessionBookings[sessionIndex]['status'] = newStatus;
    }

    // Update inside local view state
    final index = allBookings.indexWhere((b) => b['id'] == id);
    if (index != -1) {
      allBookings[index]['status'] = newStatus;
      _safeNotify();
    }
  }

  List<Map<String, String>> get filteredBookings {
    if (selectedFilter == 'All') {
      return allBookings;
    }
    if (selectedFilter == 'Rescheduling') {
      return allBookings
          .where((b) => b['status'] == 'Reschedule Pending')
          .toList();
    }
    return allBookings.where((b) => b['status'] == selectedFilter).toList();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
