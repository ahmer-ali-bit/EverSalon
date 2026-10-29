import 'package:flutter/material.dart';

class AllSalonsProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND INTEGRATION - GET ALL SALONS API
  // Endpoint: GET /api/salons?tab={tabName}
  // ========================================================

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Selected tab index: 0 = All, 1 = Popular, 2 = Nearby, 3 = Top Rated
  int _selectedTab = 0;
  int get selectedTab => _selectedTab;

  List<Map<String, dynamic>> _salons = [];
  List<Map<String, dynamic>> get salons => _salons;

  void selectTab(int index) {
    _selectedTab = index;
    notifyListeners();

    // Filter or re-fetch salons based on selected tab
    fetchSalons();
  }

  void fetchSalons() async {
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    // ========================================================
    // TODO: Replace mock delay with actual API Call
    // ========================================================
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock Salons Data
    _salons = [
      {
        'id': '1',
        'name': 'Glow Beauty Lounge',
        'image': 'assets/images/glow beauty lounge.png',
        'rating': 4.8,
        'reviews': 256,
        'reviewCount': 256,
        'distance': '2.4 km',
        'address': 'Yasrab Town, Bahawalpur',
        'fullAddress': 'Yasrab Town, Near Shell Pump, Bahawalpur, Pakistan',
        'type': 'Unisex Salon',
        'isOpen': true,
        'openTime': '10:00 AM',
        'closeTime': '9:00 PM',
        'openDays': 'Mon - Sun',
        'phone': '+92 300 1234567',
      },
      {
        'id': '2',
        'name': 'The Glam Studio',
        'image': 'assets/images/the glam studio.png',
        'rating': 4.7,
        'reviews': 180,
        'reviewCount': 180,
        'distance': '3.1 km',
        'address': 'Model Town A, Bahawalpur',
        'fullAddress': 'Model Town A, Main Boulevard, Bahawalpur, Pakistan',
        'type': 'Ladies Salon',
        'isOpen': true,
        'openTime': '11:00 AM',
        'closeTime': '10:00 PM',
        'openDays': 'Mon - Sat',
        'phone': '+92 301 9876543',
      },
      {
        'id': '3',
        'name': 'Elegance Salon',
        'image': 'assets/images/elegance salon.png',
        'rating': 4.6,
        'reviews': 142,
        'reviewCount': 142,
        'distance': '1.8 km',
        'address': 'Farid Gate, Bahawalpur',
        'fullAddress': 'Farid Gate Market, Bahawalpur, Pakistan',
        'type': 'Unisex Salon',
        'isOpen': false,
        'openTime': '10:00 AM',
        'closeTime': '8:00 PM',
        'openDays': 'Tue - Sun',
        'phone': '+92 302 5551234',
      },
      {
        'id': '4',
        'name': 'Beauty Bliss',
        'image': 'assets/images/beauty bliss.png',
        'rating': 4.9,
        'reviews': 310,
        'reviewCount': 310,
        'distance': '4.2 km',
        'address': 'Commercial Area, Bahawalpur',
        'fullAddress': 'Commercial Area Phase 1, Bahawalpur, Pakistan',
        'type': 'Ladies Salon',
        'isOpen': true,
        'openTime': '10:00 AM',
        'closeTime': '9:00 PM',
        'openDays': 'Mon - Sun',
        'phone': '+92 303 4448888',
      },
    ];

    _isLoading = false;
    notifyListeners();
  }
}
