import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/provider/my%20booking/cancel_booking_provider.dart';
import 'package:ever_salon/provider/my%20booking/my_booking_provider.dart';
import 'package:ever_salon/screen/main%20screen/main_screen.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// S46 — Cancel Booking Screen (Booking Cancelled Success UI)
class CancelBookingScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const CancelBookingScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CancelBookingProvider()
        ..initData(bookingData)
        ..loadCancelledBooking(),
      child: const _CancelBookingView(),
    );
  }
}

class _CancelBookingView extends StatelessWidget {
  const _CancelBookingView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CancelBookingProvider>();
    final data = provider.bookingData;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // Safe readers
    final salonRaw = data['salonData'] ?? data['salon'];
    final salon = salonRaw is Map
        ? Map<String, dynamic>.from(salonRaw)
        : <String, dynamic>{};

    final servicesRaw = data['selectedServices'] ?? data['services'];
    String serviceName = 'Haircut & Styling';
    if (servicesRaw is List && servicesRaw.isNotEmpty) {
      final first = servicesRaw.first;
      if (first is Map) {
        serviceName = first['name']?.toString() ?? serviceName;
      }
    }

    final salonName = salon['name']?.toString() ?? 'Glow Beauty Lounge';
    final salonImage =
        salon['image']?.toString() ?? 'assets/images/glow beauty lounge.png';
    final formattedDate =
        data['formattedDate']?.toString() ??
        data['selectedDate']?.toString() ??
        'Wed, 15 May 2024';
    final selectedTime = data['selectedTime']?.toString() ?? '11:00 AM';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER (tumhara exact format) ──
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.015,
              ),
              child: Row(
                children: [
                  // Success screen pe back optional — My Bookings pe bhej dete hain
                  GestureDetector(
                    onTap: () => _goToMyBookings(context),
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
                      context.tr('cancel_booking'),
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

            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                      child: Column(
                        children: [
                          SizedBox(height: h * 0.04),

                          // Success illustration
                          Image.asset(
                            'assets/images/booking_cancelled.png',
                            width: w * 0.42,
                            height: w * 0.42,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => Image.asset(
                              'assets/images/booking cancelled.png',
                              width: w * 0.42,
                              height: w * 0.42,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => Container(
                                width: w * 0.32,
                                height: w * 0.32,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPink.withValues(
                                    alpha: 0.12,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: w * 0.16,
                                  color: AppColors.primaryPink,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: h * 0.025),

                          Text(
                            context.tr('booking_cancelled'),
                            style: TextStyle(
                              fontSize: w * 0.055,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: h * 0.01),

                          Text(
                            context.tr('booking_cancelled_desc'),
                            style: TextStyle(
                              fontSize: w * 0.036,
                              color: AppColors.textSecondary(context),
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: h * 0.035),

                          // Booking summary card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(w * 0.035),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg(context),
                              borderRadius: BorderRadius.circular(w * 0.035),
                              border: Border.all(color: AppColors.divider(context)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    w * 0.025,
                                  ),
                                  child: Image.asset(
                                    salonImage,
                                    width: w * 0.16,
                                    height: w * 0.16,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(
width: w * 0.16,
                                    height: w * 0.16,
                                    color: AppColors.inputBg(context),
                                    child: Icon(
                                      Icons.storefront,
                                      color: AppColors.textSecondary(context),
                                    ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: w * 0.03),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        salonName,
                                        style: TextStyle(
                                          fontSize: w * 0.038,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary(context),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: h * 0.004),
                                      Text(
                                        serviceName,
                                        style: TextStyle(
                                          fontSize: w * 0.032,
                                          color: AppColors.textSecondary(context),
                                        ),
                                      ),
                                      SizedBox(height: h * 0.004),
                                      Text(
                                        '$formattedDate  ·  $selectedTime',
                                        style: TextStyle(
                                          fontSize: w * 0.03,
                                          color: AppColors.textSecondary(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: h * 0.08),
                        ],
                      ),
                    ),
            ),

            // ── BOTTOM ACTIONS ──
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      text: context.tr('back_to_bookings'),
                      width: double.infinity,
                      height: 55,
                      onTap: () => _goToMyBookings(context),
                    ),
                    SizedBox(height: h * 0.015),
                    GestureDetector(
                      onTap: () {
                        // Home / Explore — stack clear → Home tab
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainScreen(initialIndex: 0),
                          ),
                          (route) => false,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: h * 0.008),
                        child: Text(
                          context.tr('explore_salons'),
                          style: TextStyle(
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryPink,
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
    );
  }

  void _goToMyBookings(BuildContext context) {
    try {
      final myBookings = context.read<MyBookingsProvider>();
      myBookings.changeTab(2); // Cancelled tab
    } catch (e) {
      debugPrint('MyBookingsProvider tab switch: $e');
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen(initialIndex: 2)),
      (route) => false,
    );
  }
}
