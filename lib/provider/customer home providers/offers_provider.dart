import 'package:flutter/material.dart';
import 'package:ever_salon/constants/app_colors.dart';

class OffersProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  final List<String> offerTabs = [
    "All Offers",
    "Discounts",
    "New User",
    "Packages",
  ];

  // ========================================================
  // TODO: BACKEND INTEGRATION - GET OFFERS API
  // Endpoint: GET /api/offers
  // Returns: list of offers (type, title, subtitle, validity, code, colorTheme)
  // UI will auto-update when this list changes from backend
  // ========================================================

  final List<Map<String, dynamic>> _allOffers = [
    {
      "id": 1,
      "type": "Discounts",
      "title": "20% OFF",
      "subtitle": "On All Services",
      "validity": "Valid till 25 May 2024",
      "code": "GLOW20",
      "icon": Icons.local_offer_rounded,
      "iconBg": const Color(0xFFF3E5F5),
      "iconColor": AppColors.primaryPurple,
    },
    {
      "id": 2,
      "type": "Packages",
      "title": "Flat 15% OFF",
      "subtitle": "On Bridal Packages",
      "validity": "Valid till 30 May 2024",
      "code": "BRIDE15",
      "icon": Icons.card_giftcard_rounded,
      "iconBg": const Color(0xFFFFF0F5),
      "iconColor": AppColors.primaryPink,
    },
    {
      "id": 3,
      "type": "New User",
      "title": "10% OFF",
      "subtitle": "On First Booking",
      "validity": "Valid till 20 May 2024",
      "code": "FIRST10",
      "icon": Icons.percent_rounded,
      "iconBg": const Color(0xFFFCE4EC),
      "iconColor": AppColors.primaryPink,
    },
  ];

  List<Map<String, dynamic>> get filteredOffers {
    if (_selectedTabIndex == 0) return _allOffers;
    final selectedType = offerTabs[_selectedTabIndex];
    return _allOffers.where((o) => o['type'] == selectedType).toList();
  }

  void changeTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  Future<void> fetchOffers() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoading = false;
    notifyListeners();
  }
}
