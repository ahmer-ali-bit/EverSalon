import 'package:flutter/material.dart';

class SearchResultsProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  String _sortBy = "Relevance";
  String get sortBy => _sortBy;

  final List<String> sortOptions = [
    "Relevance",
    "Rating: High to Low",
    "Distance: Nearest",
    "Price: Low to High",
    "Price: High to Low",
  ];

  // ========================================================
  // TODO: BACKEND INTEGRATION - SEARCH SALONS API
  // Endpoint: GET /api/search?q={query}&sort={sortBy}
  // Returns: list of matched salons based on query and sort
  // ========================================================

  final List<Map<String, dynamic>> _allResults = [
    {
      "id": 1,
      "name": "Glow Beauty Lounge",
      "rating": 4.8,
      "reviews": 256,
      "distance": "2.4 km",
      "services": "Haircut • Styling",
      "image": "assets/images/glow beauty lounge.png",
      "isFavorite": false,
    },
    {
      "id": 2,
      "name": "The Glam Studio",
      "rating": 4.7,
      "reviews": 198,
      "distance": "3.1 km",
      "services": "Haircut • Hair Color",
      "image": "assets/images/the glam studio.png",
      "isFavorite": false,
    },
    {
      "id": 3,
      "name": "Elegance Salon",
      "rating": 4.6,
      "reviews": 142,
      "distance": "3.8 km",
      "services": "Haircut • Keratin",
      "image": "assets/images/elegance salon.png",
      "isFavorite": false,
    },
    {
      "id": 4,
      "name": "Radiance Studio",
      "rating": 4.4,
      "reviews": 98,
      "distance": "4.4 km",
      "services": "Haircut • Hair Spa",
      "image": "assets/images/radiance studio.png",
      "isFavorite": false,
    },
  ];

  List<Map<String, dynamic>> get results => _allResults;

  int get resultsCount => _allResults.length;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();

    // ========================================================
    // TODO: BACKEND - Re-fetch with new sort parameter
    // fetchResults(query: _searchQuery, sort: sort);
    // ========================================================
  }

  void clearSearch() {
    _searchQuery = "";
    notifyListeners();
  }

  void toggleFavorite(int index) {
    // ========================================================
    // TODO: BACKEND INTEGRATION - ADD/REMOVE FAVORITE API
    // Endpoint: POST /api/favorites/toggle
    // Payload: { salon_id: id }
    // ========================================================
    _allResults[index]["isFavorite"] = !_allResults[index]["isFavorite"];
    notifyListeners();
  }

  Future<void> fetchResults(String query) async {
    _isLoading = true;
    _searchQuery = query;
    notifyListeners();

    // Simulating API call
    await Future.delayed(const Duration(milliseconds: 600));

    _isLoading = false;
    notifyListeners();
  }
}
