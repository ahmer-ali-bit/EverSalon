import 'package:flutter/material.dart';

class AdminAddonsProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;
  String searchQuery = '';

  List<Map<String, dynamic>> allAddons = [];

  AdminAddonsProvider() {
    _fetchAddons();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> _fetchAddons() async {
    isLoading = true;
    _safeNotify();

    // TODO: BACKEND INTEGRATION - GET /api/admin/addons
    await Future.delayed(const Duration(milliseconds: 500));

    allAddons = [
      {
        'id': 'AD1',
        'name': 'False Mink Lashes',
        'price': '1500',
        'duration': '15 mins',
        'category': 'Makeup',
        'isActive': true,
      },
      {
        'id': 'AD2',
        'name': 'Moroccan Hair Serum Treatment',
        'price': '600',
        'duration': '10 mins',
        'category': 'Hair Care',
        'isActive': true,
      },
      {
        'id': 'AD3',
        'name': '24K Gold Sheet Mask',
        'price': '1200',
        'duration': '20 mins',
        'category': 'Skin Care',
        'isActive': true,
      },
      {
        'id': 'AD4',
        'name': 'French Tip Nail Art (Per Nail)',
        'price': '200',
        'duration': '10 mins',
        'category': 'Nails',
        'isActive': false,
      },
      {
        'id': 'AD5',
        'name': 'Scalp Acupressure Massage',
        'price': '800',
        'duration': '15 mins',
        'category': 'Spa & Massage',
        'isActive': true,
      },
    ];

    isLoading = false;
    _safeNotify();
  }

  void updateSearch(String query) {
    searchQuery = query.toLowerCase();
    _safeNotify();
  }

  void toggleStatus(String id, bool val) {
    final index = allAddons.indexWhere((a) => a['id'] == id);
    if (index != -1) {
      allAddons[index]['isActive'] = val;
      _safeNotify();
    }
  }

  void addOrUpdateAddon(Map<String, dynamic> data) {
    final index = allAddons.indexWhere((a) => a['id'] == data['id']);
    if (index != -1) {
      allAddons[index] = data;
    } else {
      allAddons.insert(0, data);
    }
    _safeNotify();
  }

  void deleteAddon(String id) {
    allAddons.removeWhere((a) => a['id'] == id);
    _safeNotify();
  }

  List<Map<String, dynamic>> get filteredAddons {
    if (searchQuery.isEmpty) return allAddons;
    return allAddons.where((a) {
      return (a['name'] as String).toLowerCase().contains(searchQuery) ||
          (a['category'] as String).toLowerCase().contains(searchQuery);
    }).toList();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
