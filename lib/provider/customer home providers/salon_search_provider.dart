import 'package:flutter/material.dart';

class SalonSearchProvider extends ChangeNotifier {
  String _searchQuery = "";
  String get searchQuery => _searchQuery;

  // ========================================================
  // TODO: BACKEND INTEGRATION - GET SEARCH DATA
  // Endpoint: GET /api/search/initial-data
  // Returns: user's recent searches & popular searches
  // ========================================================

  List<String> recentSearches = [
    "Glow Beauty Lounge",
    "Haircut near me",
    "Facial",
    "Nail Extension",
  ];

  List<String> popularSearches = [
    "Haircut",
    "Makeup",
    "Facial",
    "Spa",
    "Nail Art",
    "Hair Color",
    "Bridal Makeup",
    "Keratin Treatment",
  ];

  // Mock database for live autocomplete suggestions
  final List<String> _allKeywords = [
    "Glow Beauty Lounge",
    "The Glam Studio",
    "Elegance Salon",
    "Beauty Bliss",
    "Radiance Studio",
    "Haircut",
    "Hair Color",
    "Hair Spa",
    "Facial Glow",
    "Nail Art",
    "Keratin Treatment",
    "Bridal Makeup",
    "Party Makeup",
  ];

  void updateQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearQuery() {
    _searchQuery = "";
    notifyListeners();
  }

  void clearRecentSearches() {
    // ========================================================
    // TODO: BACKEND - Clear recent searches for user
    // Endpoint: DELETE /api/search/recent
    // ========================================================
    recentSearches.clear();
    notifyListeners();
  }

  void addRecentSearch(String query) {
    if (query.trim().isEmpty) return;

    // ========================================================
    // TODO: BACKEND - Add new recent search
    // Endpoint: POST /api/search/recent
    // Payload: { query: "search_term" }
    // ========================================================

    if (recentSearches.contains(query)) {
      recentSearches.remove(query);
    }
    recentSearches.insert(0, query);
    notifyListeners();
  }

  // Get live suggestions based on typing
  List<String> get liveSuggestions {
    if (_searchQuery.isEmpty) return [];
    return _allKeywords
        .where((k) => k.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }
}
