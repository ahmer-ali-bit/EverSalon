import 'package:flutter/material.dart';

class NearbySalonsProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String currentLocation = "Bahawalpur, Pakistan";

  // ========================================================
  // TODO: BACKEND INTEGRATION - GET NEARBY SALONS API
  // Endpoint: GET /api/salons/nearby?lat={lat}&lng={lng}&radius=5
  // Returns: list of nearby salons based on user coordinates
  // ========================================================

  final List<Map<String, dynamic>> _nearbySalons = [
    {
      "id": 1,
      "name": "Glow Beauty Lounge",
      "rating": 4.8,
      "reviews": 256,
      "distance": "2.4 km",
      "image": "assets/images/glow beauty lounge.png",
      "isFavorite": false,
      // Map Coordinates (Dummy)
      "lat": 29.3957,
      "lng": 71.6833,
    },
    {
      "id": 3,
      "name": "Elegance Salon",
      "rating": 4.6,
      "reviews": 142,
      "distance": "2.7 km",
      "image": "assets/images/elegance salon.png",
      "isFavorite": false,
      "lat": 29.3980,
      "lng": 71.6850,
    },
    {
      "id": 4,
      "name": "Beauty Bliss",
      "rating": 4.5,
      "reviews": 112,
      "distance": "3.0 km",
      "image": "assets/images/beauty bliss.png",
      "isFavorite": false,
      "lat": 29.4000,
      "lng": 71.6900,
    },
  ];

  List<Map<String, dynamic>> get salons => _nearbySalons;

  void toggleFavorite(int index) {
    // ========================================================
    // TODO: BACKEND - ADD/REMOVE FAVORITE
    // ========================================================
    _nearbySalons[index]["isFavorite"] = !_nearbySalons[index]["isFavorite"];
    notifyListeners();
  }

  Future<void> fetchNearbySalons() async {
    _isLoading = true;
    notifyListeners();

    // Simulating API and GPS location delay
    await Future.delayed(const Duration(milliseconds: 800));

    _isLoading = false;
    notifyListeners();
  }

  void updateLocation() {
    // ========================================================
    // TODO: INTEGRATE GEOLOCATOR PACKAGE HERE
    // Fetch current lat/lng and update address string
    // ========================================================
    currentLocation = "Lahore, Pakistan"; // Example change
    notifyListeners();
  }
}
