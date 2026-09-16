import 'package:flutter/material.dart';
import 'package:ever_salon/constants/app_colors.dart';

class ApplyCouponProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND INTEGRATION - GET /api/coupons
  // Apply verify: POST /api/coupons/verify
  // ========================================================

  bool isLoading = false;
  final TextEditingController couponController = TextEditingController();

  // Available Coupons — same style data as Offers
  final List<Map<String, dynamic>> _availableCoupons = [
    {
      'id': 1,
      'title': '20% OFF',
      'subtitle': 'On all services',
      'code': 'GLOW20',
      'validity': 'Valid till 25 May 2024',
      'discountPercent': 20,
      'icon': Icons.local_offer_rounded,
      'iconBg': const Color(0xFFF3E5F5),
      'iconColor': AppColors.primaryPurple,
    },
    {
      'id': 2,
      'title': 'FLAT 15% OFF',
      'subtitle': 'On Hair Services',
      'code': 'HAIR15',
      'validity': 'Valid till 30 May 2024',
      'discountPercent': 15,
      'icon': Icons.card_giftcard_rounded,
      'iconBg': const Color(0xFFFFF0F5),
      'iconColor': AppColors.primaryPink,
    },
    {
      'id': 3,
      'title': '10% OFF',
      'subtitle': 'On First Booking',
      'code': 'FIRST10',
      'validity': 'Valid till 30 May 2024',
      'discountPercent': 10,
      'icon': Icons.percent_rounded,
      'iconBg': const Color(0xFFFCE4EC),
      'iconColor': AppColors.primaryPink,
    },
  ];

  List<Map<String, dynamic>> get availableCoupons => _availableCoupons;

  Map<String, dynamic>? validateAndApplyCoupon(
    String code,
    Map<String, dynamic> currentBookingData,
  ) {
    if (code.trim().isEmpty) return null;

    final coupon = _availableCoupons.cast<Map<String, dynamic>?>().firstWhere(
      (c) => c!['code'].toString().toUpperCase() == code.trim().toUpperCase(),
      orElse: () => null,
    );

    if (coupon == null) return null;

    final int subtotal =
        currentBookingData['subtotal'] as int? ??
        currentBookingData['totalServicePrice'] as int? ??
        0;
    final int percent = coupon['discountPercent'] as int? ?? 0;
    final int discountAmount = ((subtotal * percent) / 100).round();
    final int serviceTax = ((subtotal - discountAmount) * 0.05).round();
    final int totalAmount = subtotal - discountAmount + serviceTax;

    return {
      ...currentBookingData,
      'appliedCoupon': coupon,
      'discountAmount': discountAmount,
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
