import 'package:flutter/material.dart';

class MyFavoritesProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  // Tabs: 0: Salons, 1: Services, 2: Beauticians, 3: Packages
  int selectedTabIndex = 0;

  final List<String> tabs = ['Salons', 'Services', 'Beauticians', 'Packages'];

  // Mock data lists
  List<Map<String, dynamic>> favoriteItems = [];

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// Change active tab
  void setTab(int index) {
    if (selectedTabIndex != index) {
      selectedTabIndex = index;
      fetchFavorites(); // Fetch data based on selected tab
    }
  }

  /// Fetch favorites based on selected tab
  /// TODO: BACKEND INTEGRATION - GET /api/favorites?type={tab_name}
  Future<void> fetchFavorites() async {
    isLoading = true;
    _safeNotify();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      // Mock Data changing based on tab
      if (selectedTabIndex == 0) {
        // Salons
        favoriteItems = [
          {
            'id': '1',
            'image': 'assets/images/glow beauty lounge.png',
            'title': 'Glow Beauty Lounge',
            'rating': '4.8',
            'reviews': '256',
            'distance': '2.4 km',
          },
          {
            'id': '2',
            'image': 'assets/images/the glam studio.png',
            'title': 'The Glam Studio',
            'rating': '4.7',
            'reviews': '198',
            'distance': '3.1 km',
          },
          {
            'id': '3',
            'image': 'assets/images/elegance salon.png',
            'title': 'Elegance Salon',
            'rating': '4.6',
            'reviews': '142',
            'distance': '3.8 km',
          },
          {
            'id': '4',
            'image': 'assets/images/radiance studio.png',
            'title': 'Radiance Studio',
            'rating': '4.5',
            'reviews': '98',
            'distance': '4.2 km',
          },
        ];
      } else {
        // Dummy data for other tabs
        favoriteItems = [
          {
            'id': '1',
            'image': 'assets/images/makeup copy.png',
            'title': 'Dummy ${tabs[selectedTabIndex]} 1',
            'rating': '4.9',
            'reviews': '120',
            'distance': '1.5 km',
          },
        ];
      }

      isLoading = false;
      _safeNotify();
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('fetchFavorites error: $e');
    }
  }

  /// Remove item from favorites
  /// TODO: BACKEND INTEGRATION - DELETE /api/favorites/{id}
  Future<void> removeFavorite(String id) async {
    try {
      // Optistic UI update
      favoriteItems.removeWhere((item) => item['id'] == id);
      _safeNotify();

      // TODO: BACKEND - call API to remove
      // await ApiService.removeFavorite(id);
    } catch (e) {
      debugPrint('removeFavorite error: $e');
    }
  }
}
