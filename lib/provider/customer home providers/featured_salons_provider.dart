import 'package:flutter/material.dart';

class FeaturedSalonsProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Main Hero Featured Salon
  Map<String, dynamic> heroSalon = {
    "id": 2,
    "name": "The Glam Studio",
    "rating": 4.7,
    "reviews": 198,
    "image": "assets/images/the glam studio.png",
    "isFavorite": true,
  };

  // Other Featured Salons Grid
  List<Map<String, dynamic>> gridSalons = [
    {
      "id": 1,
      "name": "Glow Beauty Lounge",
      "rating": 4.8,
      "reviews": 256,
      "image": "assets/images/glow beauty lounge.png",
      "isFavorite": false,
    },
    {
      "id": 3,
      "name": "Elegance Salon",
      "rating": 4.6,
      "reviews": 142,
      "image": "assets/images/elegance salon.png",
      "isFavorite": false,
    },
    {
      "id": 4,
      "name": "Beauty Bliss",
      "rating": 4.5,
      "reviews": 112,
      "image": "assets/images/beauty bliss.png",
      "isFavorite": false,
    },
    {
      "id": 5,
      "name": "Radiance Studio",
      "rating": 4.4,
      "reviews": 98,
      "image": "assets/images/radiance studio.png",
      "isFavorite": false,
    },
  ];

  void toggleHeroFavorite() {
    heroSalon["isFavorite"] = !heroSalon["isFavorite"];
    notifyListeners();
  }

  void toggleGridFavorite(int index) {
    gridSalons[index]["isFavorite"] = !gridSalons[index]["isFavorite"];
    notifyListeners();
  }

  Future<void> fetchFeaturedSalons() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _isLoading = false;
    notifyListeners();
  }
}
