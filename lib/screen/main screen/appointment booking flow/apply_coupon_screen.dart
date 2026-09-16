import 'package:ever_salon/provider/appointment%20booking%20flow/apply_coupon_provider.dart';
import 'package:ever_salon/screen/main%20screen/appointment%20booking%20flow/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_button.dart';

class ApplyCouponScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const ApplyCouponScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ApplyCouponProvider(),
      child: _ApplyCouponView(bookingData: bookingData),
    );
  }
}

class _ApplyCouponView extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const _ApplyCouponView({required this.bookingData});

  void _handleApplyCoupon(
    BuildContext context,
    String code,
    ApplyCouponProvider provider,
  ) {
    if (code.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('enter_valid_coupon')),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final updatedBooking = provider.validateAndApplyCoupon(code, bookingData);

    if (updatedBooking != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context
                .tr('coupon_applied')
                .replaceAll('{code}', code.toUpperCase()),
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 1),
        ),
      );

      // Navigate to Payment Screen with updated discounted booking data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentScreen(bookingData: updatedBooking),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('invalid_coupon')),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _handleSkip(BuildContext context) {
    // Navigate to Payment Screen without applying coupon
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(bookingData: bookingData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<ApplyCouponProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER (Apply Coupon Screen) ──
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.015,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: w * 0.1,
                      height: w * 0.1,
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.textPrimary(context),
                        size: w * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.03),

                  Center(
                    child: Text(
                      context.tr('apply_coupon'),
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.1),
                ],
              ),
            ),

            // ── BODY (Apply Coupon Screen) ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.02),

                    Text(
                      context.tr('have_coupon'),
                      style: TextStyle(
                        fontSize: w * 0.038,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    SizedBox(height: h * 0.015),

                    // Coupon Input + Apply Button
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: h * 0.065,
                            decoration: BoxDecoration(
                              color: AppColors.inputBg(context),
                              borderRadius: BorderRadius.circular(w * 0.03),
                              border: Border.all(color: AppColors.divider(context)),
                            ),
                            child: TextField(
                              controller: provider.couponController,
                              textCapitalization: TextCapitalization.characters,
                              style: TextStyle(
                                fontSize: w * 0.04,
                                color: AppColors.textPrimary(context),
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: context.tr('enter_coupon'),
                                hintStyle: TextStyle(
                                  fontSize: w * 0.036,
                                  color: AppColors.textSecondary(context),
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: w * 0.04,
                                  vertical: h * 0.02,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.03),
                        GestureDetector(
                          onTap: () => _handleApplyCoupon(
                            context,
                            provider.couponController.text.trim(),
                            provider,
                          ),
                          child: Container(
                            height: h * 0.065,
                            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(w * 0.03),
                            ),
                            child: Center(
                              child: Text(
                                context.tr('apply'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w * 0.038,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.035),

                    Text(
                      context.tr('available_coupons'),
                      style: TextStyle(
                        fontSize: w * 0.042,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    SizedBox(height: h * 0.02),

                    // Available Coupons List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.availableCoupons.length,
                      itemBuilder: (context, index) {
                        final coupon = provider.availableCoupons[index];
                        return _buildCouponCard(
                          context: context,
                          w: w,
                          h: h,
                          coupon: coupon,
                          onApply: () => _handleApplyCoupon(
                            context,
                            coupon['code'].toString(),
                            provider,
                          ),
                        );
                      },
                    ),

                    SizedBox(height: h * 0.02),
                  ],
                ),
              ),
            ),

            // ── BOTTOM SKIP TO PAYMENT ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                w * 0.04,
                h * 0.015,
                w * 0.04,
                h * 0.02,
              ),
              decoration: BoxDecoration(
                color: AppColors.cardBg(context),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: CustomButton(
                  text: context.tr('skip_to_payment'),
                  width: double.infinity,
                  onTap: () => _handleSkip(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponCard({
    required BuildContext context,
    required double w,
    required double h,
    required Map<String, dynamic> coupon,
    required VoidCallback onApply,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: h * 0.018),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left side primary color strip
              Container(
                width: 5,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(w * 0.035),
                  child: Row(
                    children: [
                      // Icon with light background
                      Container(
                        height: w * 0.14,
                        width: w * 0.14,
                        decoration: BoxDecoration(
                          color:
                              coupon['iconBg'] as Color? ??
                              const Color(0xFFFCE4EC),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          coupon['icon'] as IconData? ?? Icons.percent_rounded,
                          color:
                              coupon['iconColor'] as Color? ??
                              AppColors.primaryPink,
                          size: w * 0.07,
                        ),
                      ),
                      SizedBox(width: w * 0.035),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${coupon['title']} ',
                                    style: TextStyle(
                                      fontSize: w * 0.042,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary(context),
                                    ),
                                  ),
                                  TextSpan(
                                    text: coupon['subtitle']?.toString() ?? '',
                                    style: TextStyle(
                                      fontSize: w * 0.032,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: h * 0.004),
                            Text(
                              coupon['validity']?.toString() ?? '',
                              style: TextStyle(
                                fontSize: w * 0.028,
                                color: AppColors.textSecondary(context),
                              ),
                            ),
                            SizedBox(height: h * 0.012),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.03,
                                vertical: h * 0.006,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryPink.withValues(
                                  alpha: 0.06,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primaryPink.withValues(
                                    alpha: 0.25,
                                  ),
                                ),
                              ),
                              child: Text(
                                '${context.tr('code')}: ${coupon['code']}',
                                style: TextStyle(
                                  fontSize: w * 0.03,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryPink,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: onApply,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.04,
                            vertical: h * 0.008,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryPink.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            context.tr('apply'),
                            style: TextStyle(
                              fontSize: w * 0.03,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
