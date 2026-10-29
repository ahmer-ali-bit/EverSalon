import 'package:flutter/material.dart';

class AdminServicesProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;

  String searchQuery = '';
  List<Map<String, dynamic>> allServices = [];

  AdminServicesProvider() {
    _fetchServices();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> _fetchServices() async {
    isLoading = true;
    _safeNotify();

    // TODO: BACKEND INTEGRATION - GET /api/admin/services
    await Future.delayed(const Duration(milliseconds: 500));

    allServices = [
      {
        'id': 'S1',
        'name': 'Hair Spa Treatment',
        'duration': '60 mins',
        'price': '2000',
        'image': 'assets/images/services/hair_spa.png',
        'isActive': true,
      },
      {
        'id': 'S2',
        'name': 'Hair Cut & Styling',
        'duration': '45 mins',
        'price': '1200',
        'image': 'assets/images/services/hair_cut.png',
        'isActive': true,
      },
      {
        'id': 'S3',
        'name': 'Bridal Makeup',
        'duration': '120 mins',
        'price': '5500',
        'image': 'assets/images/services/bridal_makeup.png',
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

  // Toggle directly from list
  void toggleServiceStatus(String id, bool val) {
    final index = allServices.indexWhere((s) => s['id'] == id);
    if (index != -1) {
      allServices[index]['isActive'] = val;
      _safeNotify();
    }
  }

  // Add new or update existing from Form
  void addOrUpdateService(Map<String, dynamic> serviceData) {
    final index = allServices.indexWhere((s) => s['id'] == serviceData['id']);
    if (index != -1) {
      allServices[index] = serviceData; // Update
    } else {
      allServices.insert(0, serviceData); // Add at top
    }
    _safeNotify();
  }

  List<Map<String, dynamic>> get filteredServices {
    if (searchQuery.isEmpty) return allServices;
    return allServices.where((s) {
      final name = (s['name'] as String).toLowerCase();
      return name.contains(searchQuery);
    }).toList();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
