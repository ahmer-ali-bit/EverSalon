import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/appointment%20booking%20flow/apply_coupon_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/appointment%20booking%20flow/payment_screen.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  void _applyCode(
    BuildContext context,
    String code,
    ApplyCouponProvider provider,
  ) {
    final updated = provider.validateAndApply(code, bookingData);

    if (updated == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('Invalid Coupon')),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PaymentScreen(bookingData: updated)),
    );
  }

  void _skip(BuildContext context) {
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

    final scaffoldBg = AppColors.scaffoldBg(context);
    final textPrimary = AppColors.textPrimary(context);
    final textSecondary = AppColors.textSecondary(context);
    final inputBg = AppColors.inputBg(context);
    final primaryPink = AppColors.primaryPink;
    final borderColor = textPrimary.withValues(alpha: 0.12);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER ──
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
                        color: inputBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: textPrimary,
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
                        color: textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.1),
                ],
              ),
            ),

            // ── BODY ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.02),

                    Text(
                      context.tr('Have coupon code'),
                      style: TextStyle(
                        fontSize: w * 0.038,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    SizedBox(height: h * 0.015),

                    // Input + Apply
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: h * 0.065,
                            decoration: BoxDecoration(
                              color: inputBg,
                              borderRadius: BorderRadius.circular(w * 0.03),
                              border: Border.all(color: borderColor),
                            ),
                            child: TextField(
                              controller: provider.couponController,
                              textCapitalization: TextCapitalization.characters,
                              style: TextStyle(
                                fontSize: w * 0.04,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: context.tr('Enter coupon code'),
                                hintStyle: TextStyle(
                                  fontSize: w * 0.036,
                                  fontWeight: FontWeight.normal,
                                  color: textSecondary,
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
                          onTap: () => _applyCode(
                            context,
                            provider.couponController.text,
                            provider,
                          ),
                          child: Container(
                            height: h * 0.065,
                            padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                            decoration: BoxDecoration(
                              color: primaryPink,
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
                        color: textPrimary,
                      ),
                    ),
                    SizedBox(height: h * 0.02),

                    // Coupon cards (Offers-style)
                    ...provider.availableCoupons.map((coupon) {
                      return _buildCouponCard(
                        context: context,
                        w: w,
                        h: h,
                        coupon: coupon,
                        scaffoldBg: scaffoldBg,
                        inputBg: inputBg,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        primaryPink: primaryPink,
                        borderColor: borderColor,
                        onApply: () => _applyCode(
                          context,
                          coupon['code'].toString(),
                          provider,
                        ),
                      );
                    }),

                    SizedBox(height: h * 0.02),
                  ],
                ),
              ),
            ),

            // ── SKIP → PAYMENT ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                w * 0.04,
                h * 0.015,
                w * 0.04,
                h * 0.02,
              ),
              decoration: BoxDecoration(
                color: scaffoldBg,
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
                  text: context.tr('Skip'),
                  width: double.infinity,
                  onTap: () => _skip(context),
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
    required Color scaffoldBg,
    required Color inputBg,
    required Color textPrimary,
    required Color textSecondary,
    required Color primaryPink,
    required Color borderColor,
    required VoidCallback onApply,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: h * 0.018),
      decoration: BoxDecoration(
        color: scaffoldBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left primary strip
              Container(width: 5, color: primaryPink),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(w * 0.035),
                  child: Row(
                    children: [
                      // Icon light bg
                      Container(
                        height: w * 0.14,
                        width: w * 0.14,
                        decoration: BoxDecoration(
                          color: primaryPink.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          coupon['icon'] as IconData? ?? Icons.percent_rounded,
                          color: primaryPink,
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
                                      color: textPrimary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: coupon['subtitle']?.toString() ?? '',
                                    style: TextStyle(
                                      fontSize: w * 0.032,
                                      fontWeight: FontWeight.w500,
                                      color: textSecondary,
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
                                color: textSecondary,
                              ),
                            ),
                            SizedBox(height: h * 0.012),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.03,
                                vertical: h * 0.006,
                              ),
                              decoration: BoxDecoration(
                                color: primaryPink.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: primaryPink.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Text(
                                '${context.tr('code')}: ${coupon['code']}',
                                style: TextStyle(
                                  fontSize: w * 0.03,
                                  fontWeight: FontWeight.bold,
                                  color: primaryPink,
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
                            color: primaryPink,
                            borderRadius: BorderRadius.circular(8),
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
