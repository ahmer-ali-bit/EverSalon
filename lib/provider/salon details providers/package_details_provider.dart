import 'package:flutter/material.dart';

class PackageDetailsProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND INTEGRATION - GET SPECIFIC PACKAGE DETAILS
  // Endpoint: GET /api/packages/{packageId}
  // Returns: coverImage, price, includes list
  // ========================================================

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic> _packageData = {};
  Map<String, dynamic> get packageData => _packageData;

  void initPackageData(Map<String, dynamic> initialData) async {
    _packageData = Map.from(initialData);
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    await Future.delayed(const Duration(milliseconds: 300)); // Mock API delay

    final name = (_packageData['name'] ?? '').toString().toLowerCase();

    // --------------------------------------------------------
    // COVER IMAGE MAPPING (har package ki specific real image)
    // Path: assets/images/
    // --------------------------------------------------------
    if (name.contains('bridal')) {
      _packageData['coverImage'] = 'assets/images/bridal copy.png';
    } else if (name.contains('party')) {
      _packageData['coverImage'] = 'assets/images/party.png';
    } else if (name.contains('skin') || name.contains('glow')) {
      _packageData['coverImage'] = 'assets/images/skin glow.png';
    } else if (name.contains('spa') || name.contains('relax')) {
      _packageData['coverImage'] = 'assets/images/spa.png';
    } else {
      _packageData['coverImage'] = 'assets/images/bridal copy.png'; // Fallback
    }

    // Ensure includes is not null
    if (_packageData['includes'] == null ||
        (_packageData['includes'] as List).isEmpty) {
      _packageData['includes'] = [
        'HD Makeup',
        'Hair Styling',
        'Nail Care',
        'Premium Service',
      ];
    }

    _isLoading = false;
    notifyListeners();
  }

  void sharePackage() {
    // ========================================================
    // TODO: BACKEND INTEGRATION - Share package link
    // ========================================================
    debugPrint('Sharing Package: ${_packageData['name']}');
  }
}
