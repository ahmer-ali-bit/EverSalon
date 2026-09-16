import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/provider/my%20booking/cancellation_reason_provider.dart';
import 'package:ever_salon/provider/my%20booking/my_booking_provider.dart';
import 'package:ever_salon/screen/main%20screen/my%20booking/cancel_booking_screen.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// S45 — Cancellation Reason Screen (form: reason + notes)
class CancellationReasonScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const CancellationReasonScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CancellationReasonProvider()..initData(bookingData),
      child: const _CancellationReasonView(),
    );
  }
}

class _CancellationReasonView extends StatelessWidget {
  const _CancellationReasonView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CancellationReasonProvider>();
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER (exact format) ──
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
                      context.tr('cancellation_reason'),
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

            // ── BODY ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Column(
                  children: [
                    SizedBox(height: h * 0.015),

                    // Illustration
                    Center(
                      child: Image.asset(
                        'assets/images/booking cofirm.png',
                        width: w * 0.45,
                        height: w * 0.45,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => Image.asset(
                          'assets/images/booking confirm.png',
                          width: w * 0.45,
                          height: w * 0.45,
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => Container(
                            width: w * 0.4,
                            height: w * 0.4,
                            decoration: BoxDecoration(
                              color: AppColors.primaryPink.withValues(
                                alpha: 0.08,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.event_busy_rounded,
                              size: w * 0.2,
                              color: AppColors.primaryPink,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.02),

                    Text(
                      context.tr('are_you_sure'),
                      style: TextStyle(
                        fontSize: w * 0.052,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: h * 0.008),

                    Text(
                      context.tr('cancel_booking_desc'),
                      style: TextStyle(
                        fontSize: w * 0.035,
                        color: AppColors.textSecondary(context),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: h * 0.03),

                    // Select Reason
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.tr('select_reason'),
                        style: TextStyle(
                          fontSize: w * 0.038,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.008),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: w * 0.035),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(w * 0.03),
                        border: Border.all(color: AppColors.divider(context)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: provider.selectedReason,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textPrimary(context),
                            size: w * 0.06,
                          ),
                          isExpanded: true,
                          style: TextStyle(
                            fontSize: w * 0.038,
                            color: AppColors.textPrimary(context),
                            fontWeight: FontWeight.w500,
                          ),
                          items: provider.reasons.map((reason) {
                            return DropdownMenuItem<String>(
                              value: reason,
                              child: Text(reason),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) provider.selectReason(val);
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.02),

                    // Additional notes
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.tr('additional_notes'),
                        style: TextStyle(
                          fontSize: w * 0.038,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.008),

                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(w * 0.03),
                        border: Border.all(color: AppColors.divider(context)),
                      ),
                      child: TextFormField(
                        controller: provider.notesController,
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: w * 0.036,
                          color: AppColors.textPrimary(context),
                        ),
                        decoration: InputDecoration(
                          hintText: context.tr('write_notes'),
                          hintStyle: TextStyle(
                            fontSize: w * 0.035,
                            color: AppColors.textSecondary(context),
                          ),
                          contentPadding: EdgeInsets.all(w * 0.035),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.04),
                  ],
                ),
              ),
            ),

            // ── BOTTOM: Cancel Booking button ──
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
                  text: context.tr('cancel_booking'),
                  width: double.infinity,
                  height: 55,
                  isLoading: provider.isSubmitting,
                  onTap: provider.isSubmitting
                      ? null
                      : () async {
                          final success = await provider.submitCancellation();
                          if (!context.mounted) return;

                          if (success) {
                            // Global My Bookings list update
                            try {
                              final myBookings = context
                                  .read<MyBookingsProvider>();
                              final id = provider.bookingData['bookingId']
                                  ?.toString();
                              if (id != null) {
                                myBookings.updateBookingStatus(id, 'cancelled');
                                myBookings.changeTab(2); // Cancelled tab
                              }
                            } catch (e) {
                              debugPrint('MyBookings cancel sync error: $e');
                            }

                            if (!context.mounted) return;

                            // S45 → S46 Cancel Booking (success)
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CancelBookingScreen(
                                  bookingData: provider.bookingData,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.tr('cancellation_failed'),
                                ),
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
}
