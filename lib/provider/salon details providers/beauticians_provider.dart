import 'package:flutter/material.dart';

class BeauticiansProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND INTEGRATION - GET BEAUTICIANS API
  // Endpoint: GET /api/salons/{salonId}/beauticians
  // ========================================================

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _beauticians = [];
  List<Map<String, dynamic>> get beauticians => _beauticians;

  // Selected beautician (Booking mode - single select)
  Map<String, dynamic>? _selectedBeautician;
  Map<String, dynamic>? get selectedBeautician => _selectedBeautician;

  bool isSelected(String id) {
    return _selectedBeautician != null && _selectedBeautician!['id'] == id;
  }

  void selectBeautician(Map<String, dynamic> b) {
    if (_selectedBeautician != null && _selectedBeautician!['id'] == b['id']) {
      _selectedBeautician = null;
    } else {
      _selectedBeautician = b;
    }
    notifyListeners();
  }

  void fetchBeauticians(String salonId) async {
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    // ========================================================
    // TODO: Replace this mock delay with actual API Call
    // ========================================================
    await Future.delayed(const Duration(milliseconds: 600));

    _beauticians = [
      {
        'id': '1',
        'name': 'Ayesha Khan',
        'role': 'Senior Stylist',
        'rating': 4.9,
        'reviews': 128,
        'isFavorite': false,
        'image': 'assets/images/beautician.png',
      },
      {
        'id': '2',
        'name': 'Sara Malik',
        'role': 'Makeup Artist',
        'rating': 4.8,
        'reviews': 96,
        'isFavorite': true,
        'image': 'assets/images/beautician.png',
      },
      {
        'id': '3',
        'name': 'Hina Butt',
        'role': 'Hair Color Expert',
        'rating': 4.7,
        'reviews': 84,
        'isFavorite': false,
        'image': 'assets/images/beautician.png',
      },
      {
        'id': '4',
        'name': 'Mehwish Ali',
        'role': 'Nail Artist',
        'rating': 4.6,
        'reviews': 72,
        'isFavorite': false,
        'image': 'assets/images/beautician.png',
      },
    ];

    _isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final index = _beauticians.indexWhere((b) => b['id'] == id);
    if (index != -1) {
      _beauticians[index]['isFavorite'] = !_beauticians[index]['isFavorite'];
      notifyListeners();
      // TODO: BACKEND - POST /api/beauticians/favorite/toggle
    }
  }
}
