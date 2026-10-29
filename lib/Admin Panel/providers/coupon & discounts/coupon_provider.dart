import 'package:flutter/material.dart';

class AdminCouponsProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;

  int selectedTabIndex = 0; // 0 for Coupons, 1 for Discounts
  List<Map<String, dynamic>> allCoupons = [];

  AdminCouponsProvider() {
    _fetchCoupons();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> _fetchCoupons() async {
    isLoading = true;
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 500)); // Mock API delay

    allCoupons = [
      {
        'id': 'CP1',
        'code': 'WELCOME10',
        'desc': 'Flat 10% OFF on all services',
        'validity': '31 May 2024',
        'isActive': true,
        'type': 'coupon',
      },
      {
        'id': 'CP2',
        'code': 'HAIR20',
        'desc': '20% OFF on Hair Services',
        'validity': '25 May 2024',
        'isActive': true,
        'type': 'coupon',
      },
      {
        'id': 'CP3',
        'code': 'NEWUSER',
        'desc': 'Flat Rs. 200 OFF on first booking',
        'validity': '30 May 2024',
        'isActive': false,
        'type': 'coupon',
      },
      {
        'id': 'DS1',
        'code': 'FESTIVE50',
        'desc': 'Flat 50% OFF for Eid',
        'validity': '10 Apr 2024',
        'isActive': false,
        'type': 'discount',
      },
    ];

    isLoading = false;
    _safeNotify();
  }

  void setTab(int index) {
    selectedTabIndex = index;
    _safeNotify();
  }

  void toggleStatus(String id, bool val) {
    final index = allCoupons.indexWhere((c) => c['id'] == id);
    if (index != -1) {
      allCoupons[index]['isActive'] = val;
      _safeNotify();
    }
  }

  void addOrUpdateCoupon(Map<String, dynamic> data) {
    final index = allCoupons.indexWhere((c) => c['id'] == data['id']);
    if (index != -1) {
      allCoupons[index] = data; // Update
    } else {
      allCoupons.insert(0, data); // Add new
    }
    _safeNotify();
  }

  List<Map<String, dynamic>> get currentList {
    String typeFilter = selectedTabIndex == 0 ? 'coupon' : 'discount';
    return allCoupons.where((c) => c['type'] == typeFilter).toList();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
