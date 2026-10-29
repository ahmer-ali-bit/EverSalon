import 'package:flutter/material.dart';

class ApplyCouponProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND - GET /api/coupons
  // Verify: POST /api/coupons/verify { code, salonId, subtotal, flowType }
  // ========================================================

  bool isLoading = false;
  final TextEditingController couponController = TextEditingController();

  /// Mock coupons — backend se replace
  final List<Map<String, dynamic>> availableCoupons = [
    {
      'id': 'c1',
      'title': '20% OFF',
      'subtitle': 'On all services',
      'code': 'GLOW20',
      'validity': 'Valid till 25 May 2024',
      'discountPercent': 20,
      'icon': Icons.local_offer_rounded,
    },
    {
      'id': 'c2',
      'title': 'FLAT 15% OFF',
      'subtitle': 'On Hair Services',
      'code': 'HAIR15',
      'validity': 'Valid till 30 May 2024',
      'discountPercent': 15,
      'icon': Icons.card_giftcard_rounded,
    },
    {
      'id': 'c3',
      'title': '10% OFF',
      'subtitle': 'On First Booking',
      'code': 'FIRST10',
      'validity': 'Valid till 30 May 2024',
      'discountPercent': 10,
      'icon': Icons.percent_rounded,
    },
  ];

  /// Returns updated bookingData with discount OR null if invalid
  Map<String, dynamic>? validateAndApply(
    String code,
    Map<String, dynamic> bookingData,
  ) {
    final trimmed = code.trim().toUpperCase();
    if (trimmed.isEmpty) return null;

    Map<String, dynamic>? matched;
    for (final c in availableCoupons) {
      if ((c['code'] as String).toUpperCase() == trimmed) {
        matched = c;
        break;
      }
    }
    if (matched == null) return null;

    final int subtotal =
        bookingData['subtotal'] as int? ??
        bookingData['servicesTotal'] as int? ??
        bookingData['packagePrice'] as int? ??
        0;

    final int percent = matched['discountPercent'] as int? ?? 0;
    final int discountAmount = ((subtotal * percent) / 100).round();
    final int afterDiscount = subtotal - discountAmount;
    final int serviceTax = (afterDiscount * 0.05).round(); // 5% on discounted
    final int totalAmount = afterDiscount + serviceTax;

    return {
      ...bookingData,
      'appliedCoupon': matched,
      'discountPercent': percent,
      'discountAmount': discountAmount,
      'subtotal': subtotal,
      'serviceTax': serviceTax,
      'totalAmount': totalAmount,
    };
  }

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }
}
