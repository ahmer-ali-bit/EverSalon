import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/provider/my%20booking/upcoming_booking_provider.dart';
import 'package:ever_salon/screen/main%20screen/my%20booking/booking_details_screen.dart';
import 'package:ever_salon/screen/main%20screen/my%20booking/cancellation_reason_screen.dart';
import 'package:ever_salon/screen/main%20screen/my%20booking/reshedule_bkking_screen.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpcomingBookingScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const UpcomingBookingScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UpcomingBookingProvider()..initData(bookingData),
      child: const _UpcomingBookingView(),
    );
  }
}

class _UpcomingBookingView extends StatelessWidget {
  const _UpcomingBookingView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UpcomingBookingProvider>();
    final data = provider.bookingData;
    final status = (data['status']?.toString() ?? 'upcoming').toLowerCase();
    final isUpcoming = status == 'upcoming';

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // Safe data extraction
    final salon = data['salonData'] ?? data['salon'] ?? {};
    final beautician = data['beautician'] ?? data['selectedBeautician'] ?? {};

    final servicesList = data['selectedServices'] ?? data['services'] ?? [];
    String serviceName = 'Haircut & Styling';
    String duration = '60 mins';
    if (servicesList is List && servicesList.isNotEmpty) {
      serviceName = servicesList[0]['name'] ?? serviceName;
      duration = servicesList[0]['duration']?.toString() ?? duration;
    }

    final price = data['totalAmount'] ?? data['subtotal'] ?? 1000;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Custom Header
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
                      context.tr('upcoming_booking'),
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.1), // Balance for centering
                ],
              ),
            ),

            // 2. Body Details
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Salon Banner Image with Status Badge
                    Stack(
                      children: [
                        Image.asset(
                          salon['image'] ??
                              'assets/images/glow beauty lounge.png',
                          width: double.infinity,
                          height: h * 0.22,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: double.infinity,
                            height: h * 0.22,
                            color: AppColors.inputBg(context),
                            child: Icon(
                              Icons.storefront,
                              size: 50,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg(context),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              isUpcoming
                                  ? context.tr('confirmed')
                                  : status == 'cancelled'
                                  ? context.tr('cancelled')
                                  : context.tr('completed'),
                              style: TextStyle(
                                color: isUpcoming
                                    ? AppColors.success
                                    : status == 'cancelled'
                                    ? AppColors.error
                                    : AppColors.success,
                                fontWeight: FontWeight.bold,
                                fontSize: w * 0.035,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Salon Info
                    Padding(
                      padding: EdgeInsets.all(w * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            salon['name'] ?? 'Glow Beauty Lounge',
                            style: TextStyle(
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.005),
                          Text(
                            salon['address'] ?? 'Bahawalpur, Pakistan',
                            style: TextStyle(
                              fontSize: w * 0.035,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.01),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.orange,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${salon['rating'] ?? '4.8'} (${salon['totalReviews'] ?? '256'})',
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      color: AppColors.divider(context),
                      thickness: 1,
                      height: 1,
                    ),

                    // Detail Rows
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.02,
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            context,
                            Icons.spa_outlined,
                            context.tr('service'),
                            serviceName,
                            w,
                          ),
                          _buildDetailRow(
                            context,
                            Icons.person_outline,
                            context.tr('beautician'),
                            beautician['name'] ?? 'Ayesha Khan',
                            w,
                          ),
                          _buildDetailRow(
                            context,
                            Icons.calendar_today_outlined,
                            context.tr('date'),
                            data['formattedDate'] ?? 'Wed, 15 May 2024',
                            w,
                          ),
                          _buildDetailRow(
                            context,
                            Icons.access_time_rounded,
                            context.tr('time'),
                            data['selectedTime'] ?? '11:00 AM',
                            w,
                          ),
                          _buildDetailRow(
                            context,
                            Icons.timer_outlined,
                            context.tr('duration'),
                            duration,
                            w,
                          ),
                          _buildDetailRow(
                            context,
                            Icons.receipt_long_outlined,
                            context.tr('price'),
                            '${context.tr('rs')} $price',
                            w,
                          ),

                          SizedBox(height: h * 0.01),

                          // ── View Full Details → S43 (Booking Details / Invoice) ──
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        BookingDetailsScreen(bookingData: data),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(w * 0.03),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.035,
                                  vertical: h * 0.016,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPink.withValues(
                                    alpha: 0.06,
                                  ),
                                  borderRadius: BorderRadius.circular(w * 0.03),
                                  border: Border.all(
                                    color: AppColors.primaryPink.withValues(
                                      alpha: 0.25,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: w * 0.09,
                                      height: w * 0.09,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryPink.withValues(
                                          alpha: 0.12,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.receipt_long_rounded,
                                        color: AppColors.primaryPink,
                                        size: w * 0.045,
                                      ),
                                    ),
                                    SizedBox(width: w * 0.03),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            context.tr('view_full_details'),
                                            style: TextStyle(
                                              fontSize: w * 0.038,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primaryPink,
                                            ),
                                          ),
                                          SizedBox(height: h * 0.002),
                                          Text(
                                            context.tr('booking_id_invoice'),
                                            style: TextStyle(
                                              fontSize: w * 0.03,
                                              color: AppColors.textSecondary(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: w * 0.035,
                                      color: AppColors.primaryPink,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Bottom Fixed Buttons (Only visible if Upcoming)
            if (isUpcoming)
              Container(
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
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      // Reschedule Button (S44)
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final updated =
                                await Navigator.push<Map<String, dynamic>>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RescheduleBookingScreen(
                                      bookingData: data,
                                    ),
                                  ),
                                );

                            if (updated != null && context.mounted) {
                              context.read<UpcomingBookingProvider>().initData(
                                updated,
                              );
                            }
                          },
                          child: Container(
                            height: 55,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.cardBg(context),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: AppColors.primaryPink,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              context.tr('reschedule'),
                              style: TextStyle(
                                color: AppColors.primaryPink,
                                fontWeight: FontWeight.bold,
                                fontSize: w * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.03),

                      // Cancel Booking Button (S45)
                      Expanded(
                        child: CustomButton(
                          text: context.tr('cancel_booking'),
                          height: 55,
                          onTap: () {
                            // Navigate to S45 Form Screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CancellationReasonScreen(bookingData: data),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Detail Rows
  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    double w,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textSecondary(context), size: w * 0.05),
          SizedBox(width: w * 0.03),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary(context),
                fontWeight: FontWeight.w600,
                fontSize: w * 0.038,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.textSecondary(context),
                fontSize: w * 0.038,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
