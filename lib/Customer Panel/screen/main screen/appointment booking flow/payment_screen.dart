import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/appointment%20booking%20flow/payment_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/appointment%20booking%20flow/booking_confirmation_screen.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const PaymentScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentProvider(),
      child: _PaymentView(bookingData: bookingData),
    );
  }
}

class _PaymentView extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const _PaymentView({required this.bookingData});

  /// Service ya Package + coupon ke baad final amount
  int get amountToPay {
    return bookingData['totalAmount'] as int? ??
        bookingData['subtotal'] as int? ??
        bookingData['servicesTotal'] as int? ??
        bookingData['packagePrice'] as int? ??
        0;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<PaymentProvider>();

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
            // =================================================
            // HEADER
            // =================================================
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
                      context.tr('payment'),
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

            // =================================================
            // BODY
            // =================================================
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.01),

                    // Amount to Pay card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.045,
                        vertical: h * 0.022,
                      ),
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(w * 0.035),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.tr('amount_to_pay'),
                            style: TextStyle(
                              fontSize: w * 0.04,
                              fontWeight: FontWeight.w600,
                              color: textPrimary,
                            ),
                          ),
                          Text(
                            'Rs. $amountToPay',
                            style: TextStyle(
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.bold,
                              color: primaryPink,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Discount line (agar coupon laga ho)
                    if ((bookingData['discountAmount'] as int? ?? 0) > 0) ...[
                      SizedBox(height: h * 0.012),
                      Text(
                        '${context.tr('Discount applied')}: -Rs. ${bookingData['discountAmount']}'
                        '${bookingData['appliedCoupon'] != null ? ' (${bookingData['appliedCoupon']['code']})' : ''}',
                        style: TextStyle(
                          fontSize: w * 0.032,
                          color: AppColors.success,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],

                    SizedBox(height: h * 0.03),

                    Text(
                      context.tr('payment_methods'),
                      style: TextStyle(
                        fontSize: w * 0.042,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    SizedBox(height: h * 0.015),

                    // Payment method tiles
                    ...provider.paymentMethods.map((method) {
                      final id = method['id'] as String;
                      return _buildMethodTile(
                        context: context,
                        w: w,
                        h: h,
                        method: method,
                        isSelected: provider.isSelected(id),
                        onTap: () => provider.selectMethod(id),
                        scaffoldBg: scaffoldBg,
                        inputBg: inputBg,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        primaryPink: primaryPink,
                        borderColor: borderColor,
                      );
                    }),

                    SizedBox(height: h * 0.12),
                  ],
                ),
              ),
            ),

            // =================================================
            // BOTTOM PAY BUTTON
            // =================================================
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
                  text: '${context.tr('pay')} Rs. $amountToPay',
                  width: double.infinity,
                  isLoading: provider.isProcessing,
                  onTap: provider.isProcessing
                      ? null
                      : () async {
                          final success = await provider.processPayment(
                            bookingData,
                          );

                          if (!context.mounted) return;

                          if (success) {
                            final updatedBooking = {
                              ...bookingData,
                              'paymentMethod': provider.selectedMethod,
                              'totalAmount': amountToPay,
                              'paymentStatus': provider.selectedMethod == 'cash'
                                  ? 'pay_at_salon'
                                  : 'paid',
                            };

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingConfirmationScreen(
                                  bookingData: updatedBooking,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(context.tr('Payment failed')),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodTile({
    required BuildContext context,
    required double w,
    required double h,
    required Map<String, dynamic> method,
    required bool isSelected,
    required VoidCallback onTap,
    required Color scaffoldBg,
    required Color inputBg,
    required Color textPrimary,
    required Color textSecondary,
    required Color primaryPink,
    required Color borderColor,
  }) {
    final imagePath = method['image'] as String? ?? '';
    final icon = method['icon'] as IconData? ?? Icons.payment;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: h * 0.012),
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.035,
          vertical: h * 0.016,
        ),
        decoration: BoxDecoration(
          color: scaffoldBg,
          borderRadius: BorderRadius.circular(w * 0.03),
          border: Border.all(
            color: isSelected ? primaryPink : borderColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryPink.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Payment image (online.png, card.png, ...)
            Container(
              width: w * 0.12,
              height: w * 0.12,
              padding: EdgeInsets.all(w * 0.02),
              decoration: BoxDecoration(
                color: inputBg,
                borderRadius: BorderRadius.circular(w * 0.025),
                border: Border.all(color: borderColor),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) =>
                    Icon(icon, color: primaryPink, size: w * 0.06),
              ),
            ),
            SizedBox(width: w * 0.035),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr(method['titleKey'] as String),
                    style: TextStyle(
                      fontSize: w * 0.038,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  SizedBox(height: h * 0.003),
                  Text(
                    context.tr(method['subtitleKey'] as String),
                    style: TextStyle(fontSize: w * 0.03, color: textSecondary),
                  ),
                ],
              ),
            ),
            // Radio check
            Container(
              width: w * 0.06,
              height: w * 0.06,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? primaryPink : Colors.transparent,
                border: isSelected
                    ? null
                    : Border.all(
                        color: textSecondary.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: w * 0.035)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
