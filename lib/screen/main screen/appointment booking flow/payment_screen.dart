import 'package:ever_salon/provider/appointment%20booking%20flow/payment_provider.dart';
import 'package:ever_salon/provider/my%20booking/my_booking_provider.dart';
import 'package:ever_salon/screen/main%20screen/appointment%20booking%20flow/booking_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_button.dart';

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

  int get amountToPay {
    return bookingData['totalAmount'] as int? ??
        bookingData['grandTotal'] as int? ??
        bookingData['totalServicePrice'] as int? ??
        0;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<PaymentProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER (Payment Screen) ──
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
                      context.tr('payment'),
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

            // ── BODY (Payment Screen) ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.01),

                    // Amount to Pay Box
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.045,
                        vertical: h * 0.022,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(w * 0.035),
                        border: Border.all(color: AppColors.divider(context)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.tr('amount_to_pay'),
                            style: TextStyle(
                              fontSize: w * 0.04,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          Text(
                            '${context.tr('rs')} $amountToPay',
                            style: TextStyle(
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPink,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.03),

                    Text(
                      context.tr('payment_methods'),
                      style: TextStyle(
                        fontSize: w * 0.042,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),

                    SizedBox(height: h * 0.015),

                    // Payment Methods Tiles (using Images)
                    ...provider.paymentMethods.map((method) {
                      return _buildMethodTile(
                        context: context,
                        w: w,
                        h: h,
                        method: method,
                        isSelected: provider.isSelected(method['id'] as String),
                        onTap: () =>
                            provider.selectMethod(method['id'] as String),
                      );
                    }),

                    SizedBox(height: h * 0.12),
                  ],
                ),
              ),
            ),

            // ── BOTTOM PAY BUTTON ──
            _buildBottomBar(context, w, h, provider),
          ],
        ),
      ),
    );
  }

  // Individual Payment Method Tile with Image Asset
  Widget _buildMethodTile({
    required BuildContext context,
    required double w,
    required double h,
    required Map<String, dynamic> method,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final imagePath = method['image'] as String? ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: h * 0.012),
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.035,
          vertical: h * 0.016,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(w * 0.03),
          border: Border.all(
            color: isSelected ? AppColors.primaryPink : AppColors.divider(context),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryPink.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Payment Method Image Container
            Container(
              width: w * 0.12,
              height: w * 0.12,
              padding: EdgeInsets.all(w * 0.02),
              decoration: BoxDecoration(
                color: AppColors.inputBg(context),
                borderRadius: BorderRadius.circular(w * 0.025),
                border: Border.all(
                  color: AppColors.divider(context).withValues(alpha: 0.5),
                ),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Icon(
                  Icons.payment_rounded,
                  color: AppColors.primaryPink,
                  size: w * 0.06,
                ),
              ),
            ),

            SizedBox(width: w * 0.035),

            // Method Name & Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['title']?.toString() ?? '',
                    style: TextStyle(
                      fontSize: w * 0.038,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: h * 0.003),
                  Text(
                    method['subtitle']?.toString() ?? '',
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),

            // Radio Circle
            Container(
              width: w * 0.06,
              height: w * 0.06,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected ? AppColors.primaryGradient : null,
                border: isSelected
                    ? null
                    : Border.all(
                        color: AppColors.textSecondary(context).withValues(alpha: 0.4),
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

  Widget _buildBottomBar(
    BuildContext context,
    double w,
    double h,
    PaymentProvider provider,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.015, w * 0.04, h * 0.02),
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
          text: '${context.tr('pay')} ${context.tr('rs')} $amountToPay',
          width: double.infinity,
          isLoading: provider.isProcessing,
          onTap: provider.isProcessing
              ? null
              : () async {
                  final success = await provider.processPayment(bookingData);

                  if (!context.mounted) return;

                  if (success) {
                    // Booking ID generate (ya backend se aayega)
                    final ts = DateTime.now().millisecondsSinceEpoch.toString();
                    final bookingId = '#ES${ts.substring(ts.length - 8)}';

                    final updatedBooking = {
                      ...bookingData,
                      'bookingId': bookingId,
                      'paymentMethod': provider.selectedMethod,
                      'totalAmount': amountToPay,
                      'paymentStatus': provider.selectedMethod == 'cash'
                          ? 'pay_at_salon'
                          : 'paid',
                      'status': 'upcoming', // My Bookings → Upcoming tab
                    };

                    // ★ GLOBAL LIST MEIN ADD — Bookings tab yahi dikhayegi
                    try {
                      context.read<MyBookingsProvider>().addBooking(
                        updatedBooking,
                      );
                    } catch (e) {
                      debugPrint('MyBookingsProvider not found in tree: $e');
                    }

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
                        content: Text(context.tr('payment_failed')),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
        ),
      ),
    );
  }
}
