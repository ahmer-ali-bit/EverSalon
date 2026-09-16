import 'package:flutter/material.dart';

class ServicesProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND INTEGRATION - GET SALON SERVICES API
  // Endpoint: GET /api/salons/{salonId}/services
  // ========================================================

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> get services => _services;

  // Selected services (Booking mode - multi select)
  final List<Map<String, dynamic>> _selectedServices = [];
  List<Map<String, dynamic>> get selectedServices => _selectedServices;

  bool isSelected(String id) {
    return _selectedServices.any((s) => s['id'] == id);
  }

  void toggleSelection(Map<String, dynamic> service) {
    final id = service['id'];
    if (isSelected(id)) {
      _selectedServices.removeWhere((s) => s['id'] == id);
    } else {
      _selectedServices.add(service);
    }
    notifyListeners();
  }

  int get totalPrice {
    int total = 0;
    for (var s in _selectedServices) {
      total += (s['price'] as int? ?? 0);
    }
    return total;
  }

  void fetchServices(dynamic salonId) async {
    final id = salonId?.toString() ?? '1';
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    // ========================================================
    // TODO: Replace this mock delay with actual API Call
    // Endpoint: GET /api/salons/$id/services
    // ========================================================
    await Future.delayed(const Duration(milliseconds: 600));

    _services = [
      {
        'id': '1',
        'name': 'Haircut & Styling',
        'price': 1000,
        'image': 'assets/images/hairs.png',
        'bgColor': 0xFFFDE8F1,
      },
      {
        'id': '2',
        'name': 'Hair Color',
        'price': 2500,
        'image': 'assets/images/hair color.png',
        'bgColor': 0xFFEBE4F9,
      },
      {
        'id': '3',
        'name': 'Facial',
        'price': 2000,
        'image': 'assets/images/skin care.png',
        'bgColor': 0xFFFDE8F1,
      },
      {
        'id': '4',
        'name': 'Makeup',
        'price': 3500,
        'image': 'assets/images/makeup.png',
        'bgColor': 0xFFEBE4F9,
      },
      {
        'id': '5',
        'name': 'Manicure',
        'price': 1000,
        'image': 'assets/images/manicure.png',
        'bgColor': 0xFFFDE8F1,
      },
      {
        'id': '6',
        'name': 'Pedicure',
        'price': 1200,
        'image': 'assets/images/pedicure.png',
        'bgColor': 0xFFEBE4F9,
      },
      {
        'id': '7',
        'name': 'Hair Treatment',
        'price': 1800,
        'image': 'assets/images/hair treatment.png',
        'bgColor': 0xFFFDE8F1,
      },
    ];

    _isLoading = false;
    notifyListeners();
  }
}
