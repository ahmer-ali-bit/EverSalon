import 'package:flutter/material.dart';

class PackagesProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND INTEGRATION - GET SALON PACKAGES API
  // Endpoint: GET /api/salons/{salonId}/packages
  // ========================================================

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _packages = [];
  List<Map<String, dynamic>> get packages => _packages;

  // Selected package (Booking mode - single select)
  Map<String, dynamic>? _selectedPackage;
  Map<String, dynamic>? get selectedPackage => _selectedPackage;

  bool isSelected(String id) {
    return _selectedPackage != null && _selectedPackage!['id'] == id;
  }

  void selectPackage(Map<String, dynamic> pkg) {
    // Toggle: if already selected, deselect
    if (_selectedPackage != null && _selectedPackage!['id'] == pkg['id']) {
      _selectedPackage = null;
    } else {
      _selectedPackage = pkg;
    }
    notifyListeners();
  }

  void fetchPackages(String salonId) async {
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    // ========================================================
    // TODO: Replace this mock delay with actual API Call
    // ========================================================
    await Future.delayed(const Duration(milliseconds: 600));

    _packages = [
      {
        'id': '1',
        'name': 'Bridal Package',
        'price': 25000,
        'image': 'assets/images/bridal copy.png',
        'includes': [
          'HD Bridal Makeup',
          'Hair Styling',
          'Facial',
          'Nail Care',
          'Hair Spa',
        ],
      },
      {
        'id': '2',
        'name': 'Party Package',
        'price': 8500,
        'image': 'assets/images/makeup copy.png',
        'includes': ['Party Makeup', 'Hair Styling', 'Nail Paint', 'Lashes'],
      },
      {
        'id': '3',
        'name': 'Skin Glow Package',
        'price': 5500,
        'image': 'assets/images/skin glow.png',
        'includes': [
          'Deep Cleansing',
          'Whitening Facial',
          'Bleach',
          'Face Mask',
        ],
      },
      {
        'id': '4',
        'name': 'Relaxation Spa',
        'price': 12000,
        'image': 'assets/images/spa copy.png',
        'includes': [
          'Full Body Massage',
          'Aromatherapy',
          'Body Scrub',
          'Steam',
        ],
      },
    ];

    _isLoading = false;
    notifyListeners();
  }
}
