import 'package:flutter/material.dart';

class AdminPackagesProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;
  String searchQuery = '';

  // 🌐 Global list shared with Walk-In Screen
  static final List<Map<String, dynamic>> _globalPackages = [
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
      ],
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

  // Static getter for Walk-In Screen
  static List<Map<String, dynamic>> get activePackagesGlobal =>
      _globalPackages.where((p) => p['isActive'] == true).toList();

  AdminPackagesProvider() {
    _fetchPackages();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  // =========================================================================
  // ⚡ BACKEND INTEGRATION - GET PACKAGES
  // API Endpoint: GET /api/admin/packages
  // =========================================================================
  Future<void> _fetchPackages() async {
    isLoading = true;
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 300));

    isLoading = false;
    _safeNotify();
  }

  List<Map<String, dynamic>> get allPackages => _globalPackages;

  List<Map<String, dynamic>> get filteredPackages {
    if (searchQuery.trim().isEmpty) return _globalPackages;
    return _globalPackages.where((pkg) {
      final name = (pkg['name'] ?? '').toString().toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();
  }

  void updateSearch(String query) {
    searchQuery = query;
    _safeNotify();
  }

  // =========================================================================
  // ⚡ BACKEND INTEGRATION - ADD / UPDATE PACKAGE
  // =========================================================================
  void addOrUpdatePackage(Map<String, dynamic> pkg) {
    final id = pkg['id']?.toString();

    if (pkg['services'] != null && pkg['includes'] == null) {
      pkg['includes'] = List<dynamic>.from(pkg['services']);
    } else if (pkg['includes'] != null && pkg['services'] == null) {
      pkg['services'] = List<dynamic>.from(pkg['includes']);
    }

    if (id == null || id.isEmpty) {
      pkg['id'] = 'PKG_${DateTime.now().millisecondsSinceEpoch}';
      pkg['isActive'] ??= true;
      _globalPackages.insert(0, pkg);
    } else {
      final index = _globalPackages.indexWhere(
        (p) => p['id']?.toString() == id,
      );
      if (index != -1) {
        _globalPackages[index] = pkg;
      } else {
        _globalPackages.insert(0, pkg);
      }
    }
    _safeNotify();
  }

  // =========================================================================
  // ⚡ BACKEND INTEGRATION - DELETE PACKAGE
  // =========================================================================
  void deletePackage(dynamic id) {
    _globalPackages.removeWhere((p) => p['id']?.toString() == id?.toString());
    _safeNotify();
  }

  // =========================================================================
  // ⚡ BACKEND INTEGRATION - TOGGLE ACTIVE STATUS
  // =========================================================================
  void toggleStatus(dynamic id, bool isActive) {
    final index = _globalPackages.indexWhere(
      (p) => p['id']?.toString() == id?.toString(),
    );
    if (index != -1) {
      _globalPackages[index]['isActive'] = isActive;
      _safeNotify();
    }
  }

  void togglePackageStatus(dynamic id, bool isActive) {
    toggleStatus(id, isActive);
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
