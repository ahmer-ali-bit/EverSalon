import 'package:flutter/foundation.dart';

/// Global singleton repository for Packages
/// Ensures both Admin Packages Screen & Walk-In Booking Screen share same data
class PackagesRepository extends ChangeNotifier {
  static final PackagesRepository _instance = PackagesRepository._internal();
  factory PackagesRepository() => _instance;
  PackagesRepository._internal() {
    _initializeDefaultData();
  }

  List<Map<String, dynamic>> _packages = [];
  List<Map<String, dynamic>> get packages => List.unmodifiable(_packages);

  List<Map<String, dynamic>> get activePackages =>
      _packages.where((p) => p['isActive'] == true).toList();

  void _initializeDefaultData() {
    _packages = [
      {
        'id': 'PKG1',
        'name': 'Bridal Complete Package',
        'price': 15000.0,
        'originalPrice': 18000.0,
        'duration': '4 hours',
        'includes': [
          'Bridal Makeup',
          'Hair Styling',
          'Mehndi Design',
          'Manicure',
        ],
        'services': [
          'Bridal Makeup',
          'Hair Styling',
          'Mehndi Design',
          'Manicure',
        ], // Compatible with Catalog Screen
        'isActive': true,
        'image': '',
      },
      {
        'id': 'PKG2',
        'name': 'Party Ready Package',
        'price': 6500.0,
        'originalPrice': 7500.0,
        'duration': '2 hours',
        'includes': ['Party Makeup', 'Hair Blow Dry', 'Basic Manicure'],
        'services': ['Party Makeup', 'Hair Blow Dry', 'Basic Manicure'],
        'isActive': true,
        'image': '',
      },
      {
        'id': 'PKG3',
        'name': 'Full Beauty Treatment',
        'price': 8000.0,
        'originalPrice': 9500.0,
        'duration': '3 hours',
        'includes': ['Facial', 'Hair Spa', 'Manicure', 'Pedicure'],
        'services': ['Facial', 'Hair Spa', 'Manicure', 'Pedicure'],
        'isActive': true,
        'image': '',
      },
      {
        'id': 'PKG4',
        'name': 'Quick Refresh Combo',
        'price': 3500.0,
        'originalPrice': 3500.0,
        'duration': '90 mins',
        'includes': ['Threading', 'Basic Facial', 'Blow Dry'],
        'services': ['Threading', 'Basic Facial', 'Blow Dry'],
        'isActive': true,
        'image': '',
      },
    ];
  }

  // =========================================================================
  // ⚡ BACKEND: POST /api/admin/packages
  // =========================================================================
  void addOrUpdatePackage(Map<String, dynamic> pkg) {
    final id = pkg['id']?.toString();

    // Ensure both keys are mapped for cross-screen support
    if (pkg['services'] != null && pkg['includes'] == null) {
      pkg['includes'] = List<String>.from(pkg['services']);
    } else if (pkg['includes'] != null && pkg['services'] == null) {
      pkg['services'] = List<String>.from(pkg['includes']);
    }

    if (id == null || id.isEmpty) {
      pkg['id'] = 'PKG_${DateTime.now().millisecondsSinceEpoch}';
      pkg['isActive'] ??= true;
      _packages.insert(0, pkg);
    } else {
      final index = _packages.indexWhere((p) => p['id'] == id);
      if (index != -1) {
        _packages[index] = pkg;
      } else {
        _packages.insert(0, pkg);
      }
    }
    notifyListeners();
  }

  // =========================================================================
  // ⚡ BACKEND: DELETE /api/admin/packages/{id}
  // =========================================================================
  void deletePackage(String id) {
    _packages.removeWhere((p) => p['id'] == id);
    notifyListeners();
  }

  // =========================================================================
  // ⚡ BACKEND: PATCH /api/admin/packages/{id}/toggle
  // =========================================================================
  void togglePackageActive(String id, bool isActive) {
    final index = _packages.indexWhere((p) => p['id'] == id);
    if (index != -1) {
      _packages[index]['isActive'] = isActive;
      notifyListeners();
    }
  }
}
