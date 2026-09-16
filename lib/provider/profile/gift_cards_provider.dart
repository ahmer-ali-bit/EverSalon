import 'package:flutter/material.dart';

class GiftCardsProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  // List of gift cards
  List<Map<String, dynamic>> giftCards = [];

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// Fetch gift cards data
  /// TODO: BACKEND INTEGRATION - GET /api/giftcards
  Future<void> fetchGiftCards() async {
    isLoading = true;
    _safeNotify();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      // Mock Data
      giftCards = [
        {
          'id': '1',
          'balance': 'Rs. 2,000',
          'cardNo': 'GC5624 2356 9856',
          'validTill': '30 Dec 2024',
          'gradient': const [
            Color(0xFFE82A78),
            Color(0xFF6B2A8A),
          ], // Pink to Purple
        },
        {
          'id': '2',
          'balance': 'Rs. 1,250',
          'cardNo': 'GC8890 6677 1122',
          'validTill': '15 Aug 2024',
          'gradient': const [
            Color(0xFF5E35B1),
            Color(0xFF3949AB),
          ], // Purple variations
        },
      ];

      isLoading = false;
      _safeNotify();
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('fetchGiftCards error: $e');
    }
  }

  /// Action to add a new card
  void addNewCard(BuildContext context) {
    // TODO: Navigate to Add Gift Card Screen (Not in Part 6 scope) or show modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Card feature coming soon!')),
    );
  }
}
