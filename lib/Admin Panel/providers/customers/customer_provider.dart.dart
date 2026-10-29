import 'package:flutter/material.dart';

class AdminCustomersProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;

  String searchQuery = '';
  List<Map<String, dynamic>> allCustomers = [];

  AdminCustomersProvider() {
    _fetchCustomers();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> _fetchCustomers() async {
    isLoading = true;
    _safeNotify();

    // TODO: BACKEND INTEGRATION - GET /api/admin/customers
    await Future.delayed(const Duration(milliseconds: 500));

    allCustomers = [
      {
        'id': 'C1',
        'name': 'Sara Khan',
        'phone': '+92 300 1234567',
        'bookings': 12,
        'tag': 'VIP',
        'avatar': 'assets/images/users/sara.png',
      },
      {
        'id': 'C2',
        'name': 'Ayesha Malik',
        'phone': '+92 301 2345678',
        'bookings': 8,
        'tag': 'VIP',
        'avatar': 'assets/images/users/ayesha.png',
      },
      {
        'id': 'C3',
        'name': 'Hina Fatima',
        'phone': '+92 302 3456789',
        'bookings': 5,
        'tag': 'Regular',
        'avatar': 'assets/images/users/hina.png',
      },
      {
        'id': 'C4',
        'name': 'Zainab Noor',
        'phone': '+92 303 4567890',
        'bookings': 3,
        'tag': 'Regular',
        'avatar': 'assets/images/users/zainab.png',
      },
      {
        'id': 'C5',
        'name': 'Maria Ahmed',
        'phone': '+92 304 5678901',
        'bookings': 2,
        'tag': 'New',
        'avatar': 'assets/images/users/maria.png',
      },
    ];

    isLoading = false;
    _safeNotify();
  }

  void updateSearch(String query) {
    searchQuery = query.toLowerCase();
    _safeNotify();
  }

  List<Map<String, dynamic>> get filteredCustomers {
    if (searchQuery.isEmpty) return allCustomers;
    return allCustomers.where((c) {
      return c['name'].toLowerCase().contains(searchQuery) ||
          c['phone'].toLowerCase().contains(searchQuery);
    }).toList();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
