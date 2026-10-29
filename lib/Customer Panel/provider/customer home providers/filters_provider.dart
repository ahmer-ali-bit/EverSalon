import 'package:flutter/material.dart';

class FiltersProvider extends ChangeNotifier {
  // --- States ---
  String _selectedSort = "Recommended";
  double _distance = 5.0; // in km
  String _selectedPrice = "Rs. 1000 - 3000";
  String _selectedRating = "★ 4.5+";

  // --- Getters ---
  String get selectedSort => _selectedSort;
  double get distance => _distance;
  String get selectedPrice => _selectedPrice;
  String get selectedRating => _selectedRating;

  // --- Options ---
  final List<String> sortOptions = ["Recommended", "Top Rated", "Nearest"];
  final List<String> priceOptions = [
    "Rs. 0 - 1000",
    "Rs. 1000 - 3000",
    "Rs. 3000+",
  ];
  final List<String> ratingOptions = ["★ 4.0+", "★ 4.5+", "★ 5.0"];

  // --- Setters ---
  void setSort(String sort) {
    _selectedSort = sort;
    notifyListeners();
  }

  void setDistance(double val) {
    _distance = val;
    notifyListeners();
  }

  void setPrice(String price) {
    _selectedPrice = price;
    notifyListeners();
  }

  void setRating(String rating) {
    _selectedRating = rating;
    notifyListeners();
  }

  void resetFilters() {
    _selectedSort = "Recommended";
    _distance = 5.0;
    _selectedPrice = "Rs. 0 - 1000";
    _selectedRating = "★ 4.0+";
    notifyListeners();
  }

  void applyFilters(BuildContext context) {
    // ========================================================
    // TODO: BACKEND INTEGRATION - APPLY FILTERS
    // Here you will pass these selected values back to the
    // SearchResultsProvider or call the Filter API directly.
    // Example Payload:
    // { sort: _selectedSort, distance: _distance, price: _selectedPrice, rating: _selectedRating }
    // ========================================================

    // Pass true to indicate filters were applied successfully
    Navigator.pop(context, true);
  }
}
