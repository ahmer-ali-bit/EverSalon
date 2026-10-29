import 'package:flutter/material.dart';

import '../customers/customer_detail_provider.dart';

class AdminLoyaltySettingsProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;
  bool isSaving = false;

  int pointsRate = AdminCustomerDetailProvider.pointsRate;
  Map<String, int> tiers = Map.from(AdminCustomerDetailProvider.tierThresholds);

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  void updatePointsRate(int rate) {
    pointsRate = rate;
    _safeNotify();
  }

  void updateTierThreshold(String tier, int threshold) {
    tiers[tier] = threshold;
    _safeNotify();
  }

  // =========================================================================
  // ⚡ BACKEND: PUT /api/admin/settings/loyalty
  // Body: { "pointsRate": 100, "tiers": {"Bronze":0,"Silver":5000,"Gold":15000,"Platinum":30000} }
  // =========================================================================
  Future<bool> saveSettings() async {
    isSaving = true;
    _safeNotify();
    await Future.delayed(const Duration(milliseconds: 600));

    // Apply globally
    AdminCustomerDetailProvider.pointsRate = pointsRate;
    AdminCustomerDetailProvider.tierThresholds = Map.from(tiers);

    isSaving = false;
    _safeNotify();
    return true;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
