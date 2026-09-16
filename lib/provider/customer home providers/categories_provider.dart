import 'package:flutter/material.dart';

class CategoriesProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  // ========================================================
  // TODO: BACKEND INTEGRATION - GET ALL CATEGORIES API
  // Endpoint: GET /api/categories
  // Returns: list of all service categories
  // ========================================================

  final List<Map<String, dynamic>> _allCategories = [
    {
      "name": "Hair",
      "image": "assets/images/hairs.png",
      "bgColor": Color(0xFFEDE7F6),
    },
    {
      "name": "Makeup",
      "image": "assets/images/makeup.png",
      "bgColor": Color(0xFFFCE4EC),
    },
    {
      "name": "Nails",
      "image": "assets/images/nails.png",
      "bgColor": Color(0xFFFFF0F5),
    },
    {
      "name": "Skin Care",
      "image": "assets/images/skin care.png",
      "bgColor": Color(0xFFF3E5F5),
    },
    {
      "name": "Spa",
      "image": "assets/images/spa.png",
      "bgColor": Color(0xFFF5EEE6),
    },
    {
      "name": "Lashes",
      "image": "assets/images/lashes.png",
      "bgColor": Color(0xFFFFF3E0),
    },
    {
      "name": "Brows",
      "image": "assets/images/brows.png",
      "bgColor": Color(0xFFFBE9E7),
    },
    {
      "name": "Body Care",
      "image": "assets/images/body care.png",
      "bgColor": Color(0xFFFFEBEE),
    },
    {
      "name": "Bridal",
      "image": "assets/images/bridal.png",
      "bgColor": Color(0xFFF8BBD0),
    },
    {
      "name": "Massage",
      "image": "assets/images/massage.png",
      "bgColor": Color(0xFFFFE0B2),
    },
    {
      "name": "Men's Care",
      "image": "assets/images/men's care.png",
      "bgColor": Color(0xFFFFF9C4),
    },
    {
      "name": "More",
      "image": "assets/images/more.png",
      "bgColor": Color(0xFFFFE4EC),
    },
  ];

  // Filtered list based on search
  List<Map<String, dynamic>> get categories {
    if (_searchQuery.isEmpty) return _allCategories;
    return _allCategories
        .where(
          (cat) => cat['name'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    // Simulating API call
    await Future.delayed(const Duration(milliseconds: 500));

    _isLoading = false;
    notifyListeners();
  }
}
