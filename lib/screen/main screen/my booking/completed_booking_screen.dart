import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/provider/my%20booking/completed_booking_provider.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompletedBookingScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const CompletedBookingScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CompletedBookingProvider()..initData(bookingData),
      child: const _CompletedBookingView(),
    );
  }
}

class _CompletedBookingView extends StatelessWidget {
  const _CompletedBookingView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CompletedBookingProvider>();
    final data = provider.bookingData;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // Safe data extraction
    final salonRaw = data['salonData'] ?? data['salon'];
    final salon = salonRaw is Map
        ? Map<String, dynamic>.from(salonRaw)
        : <String, dynamic>{};

    final beauticianRaw = data['beautician'] ?? data['selectedBeautician'];
    final beautician = beauticianRaw is Map
        ? Map<String, dynamic>.from(beauticianRaw)
        : <String, dynamic>{};

    final servicesRaw = data['selectedServices'] ?? data['services'];
    String serviceName = 'Facial';
    if (servicesRaw is List && servicesRaw.isNotEmpty) {
      final first = servicesRaw.first;
      if (first is Map) {
        serviceName = first['name']?.toString() ?? serviceName;
      }
    }

    final salonName = salon['name']?.toString() ?? 'The Glam Studio';
    final salonImage =
        salon['image']?.toString() ?? 'assets/images/the glam studio.png';
    final formattedDate =
        data['formattedDate']?.toString() ??
        data['selectedDate']?.toString() ??
        'Fri, 10 May 2024';
    final selectedTime = data['selectedTime']?.toString() ?? '02:30 PM';
    final beauticianName = beautician['name']?.toString() ?? 'Sara Malik';
    final beauticianImage =
        beautician['image']?.toString() ?? 'assets/images/beautician.png';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
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
                  Expanded(
                    child: Center(
                      child: Text(
                        context.tr('completed'),
                        style: TextStyle(
                          fontSize: w * 0.05,
                          fontWeight: FontWeight.bold,
                          color: AppColors
                              .success, // Green color matching S47 design
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.13), // Balance spacing
                ],
              ),
            ),

            // ── BODY ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.02),

                    // 1. Completed Booking Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(w * 0.035),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg(context),
                        borderRadius: BorderRadius.circular(w * 0.04),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Salon Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(w * 0.03),
                            child: Image.asset(
                              salonImage,
                              width: w * 0.22,
                              height: w * 0.22,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                width: w * 0.22,
                                height: w * 0.22,
                                color: AppColors.inputBg(context),
                                child: Icon(
                                  Icons.storefront,
                                  color: AppColors.textSecondary(context),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: w * 0.035),

                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  salonName,
                                  style: TextStyle(
                                    fontSize: w * 0.042,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: h * 0.005),
                                Text(
                                  serviceName,
                                  style: TextStyle(
                                    fontSize: w * 0.034,
                                    color: AppColors.textSecondary(context),
                                  ),
                                ),
                                SizedBox(height: h * 0.005),
                                Text(
                                  '$formattedDate • $selectedTime',
                                  style: TextStyle(
                                    fontSize: w * 0.032,
                                    color: AppColors.textSecondary(context),
                                  ),
                                ),
                                SizedBox(height: h * 0.015),

                                // Beautician & Badge Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Beautician info
                                    Row(
                                      children: [
                                        ClipOval(
                                          child: Image.asset(
                                            beauticianImage,
                                            width: w * 0.06,
                                            height: w * 0.06,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) =>
                                                Container(
                                                  width: w * 0.06,
                                                  height: w * 0.06,
                                                  color: AppColors.inputBg(context),
                                                  child: Icon(
                                                    Icons.person,
                                                    size: w * 0.03,
                                                    color: AppColors.textSecondary(context),
                                                  ),
                                                ),
                                          ),
                                        ),
                                        SizedBox(width: w * 0.015),
                                        Text(
                                          beauticianName,
                                          style: TextStyle(
                                            fontSize: w * 0.032,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Completed Badge
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: w * 0.02,
                                        vertical: h * 0.004,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.success.withValues(
                                          alpha: 0.1,
                                        ),
                                        border: Border.all(
                                          color: AppColors.success,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          w * 0.03,
                                        ),
                                      ),
                                      child: Text(
                                        context.tr('completed'),
                                        style: TextStyle(
                                          color: AppColors.success,
                                          fontSize: w * 0.026,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.04),

                    // 2. Rating Section
                    Text(
                      context.tr('how_was_experience'),
                      style: TextStyle(
                        fontSize: w * 0.045,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    SizedBox(height: h * 0.015),

                    // Stars
                    Row(
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () => provider.setRating(index + 1),
                          child: Padding(
                            padding: EdgeInsets.only(right: w * 0.03),
                            child: Icon(
                              Icons.star_rounded,
                              size: w * 0.1,
                              color: index < provider.currentRating
                                  ? AppColors.primaryPink
                                  : AppColors.divider(context),
                            ),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: h * 0.04),

                    // 3. Review Textarea
                    Text(
                      context.tr('write_review_optional'),
                      style: TextStyle(
                        fontSize: w * 0.038,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    SizedBox(height: h * 0.01),

                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(w * 0.03),
                        border: Border.all(color: AppColors.divider(context)),
                      ),
                      child: TextFormField(
                        controller: provider.reviewController,
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: w * 0.036,
                          color: AppColors.textPrimary(context),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Amazing service! Highly recommended.',
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

            // ── BOTTOM: Submit Review Button ──
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
                  text: context.tr('submit_review'),
                  width: double.infinity,
                  height: 55,
                  isLoading: provider.isSubmitting,
                  // Disable until at least 1 star is selected
                  isEnabled:
                      provider.currentRating > 0 && !provider.isSubmitting,
                  onTap: provider.currentRating == 0 || provider.isSubmitting
                      ? null
                      : () async {
                          final success = await provider.submitReview();
                          if (!context.mounted) return;

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.tr('review_submitted'),
                                ),
                                backgroundColor: AppColors.success,
                              ),
                            );
                            Navigator.pop(context); // Go back to My Bookings
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.tr('review_failed'),
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
