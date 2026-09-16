import 'package:flutter/material.dart';

class SalonLocationProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND INTEGRATION - GET SALON LOCATION API
  // Endpoint: GET /api/salons/{id}/location
  // Returns: lat, lng, fullAddress, openTime, closeTime, phone, distance
  // ========================================================

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic> _locationData = {};
  Map<String, dynamic> get locationData => _locationData;

  void initLocationData(Map<String, dynamic> salonData) async {
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    await Future.delayed(const Duration(milliseconds: 300));

    // Merge salon data + location defaults (backend-ready)
    _locationData = {
      'id': salonData['id'] ?? '1',
      'name': salonData['name'] ?? 'Glow Beauty Lounge',
      'fullAddress':
          salonData['fullAddress'] ??
          salonData['address'] ??
          'Yasrab Town, Near Shell Pump, Bahawalpur, Pakistan',
      'distance': salonData['distance'] ?? '2.4 km',
      'openTime': salonData['openTime'] ?? '10:00 AM',
      'closeTime': salonData['closeTime'] ?? '9:00 PM',
      'openDays': salonData['openDays'] ?? 'Mon - Sun',
      'phone': salonData['phone'] ?? '+92 300 1234567',
      'latitude': salonData['latitude'] ?? 29.3956,
      'longitude': salonData['longitude'] ?? 71.6836,
      'isOpen': salonData['isOpen'] ?? true,
    };

    _isLoading = false;
    notifyListeners();
  }

  void openDirections() {
    // ========================================================
    // TODO: BACKEND INTEGRATION - Open Google Maps / Apple Maps
    // Use url_launcher:
    // final lat = locationData['latitude'];
    // final lng = locationData['longitude'];
    // launchUrl(Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng'));
    // ========================================================
    debugPrint(
      'Opening directions to: ${_locationData['latitude']}, ${_locationData['longitude']}',
    );
  }

  void callSalon() {
    // ========================================================
    // TODO: BACKEND INTEGRATION - Launch phone dialer
    // Use url_launcher:
    // launchUrl(Uri.parse('tel:${locationData['phone']}'));
    // ========================================================
    debugPrint('Calling salon: ${_locationData['phone']}');
  }
}
