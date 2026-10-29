import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/my%20booking/my_booking_provider.dart';
import 'package:ever_salon/Customer%20Panel/provider/my%20booking/reshedule_booking_provider.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RescheduleBookingScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const RescheduleBookingScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RescheduleBookingProvider()
        ..initData(bookingData)
        ..fetchAvailableDates(),
      child: const _RescheduleBookingView(),
    );
  }
}

class _RescheduleBookingView extends StatelessWidget {
  const _RescheduleBookingView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RescheduleBookingProvider>();
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER (Reschedule Booking Screen) ──
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
                      context.tr('reschedule_booking'),
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
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: h * 0.01),

                          // ── Select New Date ──
                          Text(
                            context.tr('select_new_date'),
                            style: TextStyle(
                              fontSize: w * 0.042,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.015),

                          // Calendar card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(w * 0.04),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg(context),
                              borderRadius: BorderRadius.circular(w * 0.04),
                              border: Border.all(
                                color: AppColors.divider(context),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Month navigation
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => provider.previousMonth(),
                                      child: Icon(
                                        Icons.chevron_left_rounded,
                                        size: w * 0.07,
                                        color: AppColors.textPrimary(context),
                                      ),
                                    ),
                                    Text(
                                      provider.monthYearLabel,
                                      style: TextStyle(
                                        fontSize: w * 0.042,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary(context),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => provider.nextMonth(),
                                      child: Icon(
                                        Icons.chevron_right_rounded,
                                        size: w * 0.07,
                                        color: AppColors.textPrimary(context),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: h * 0.015),

                                // Weekday headers (Sun → Sat)
                                Row(
                                  children:
                                      [
                                            context.tr('sun'),
                                            context.tr('mon'),
                                            context.tr('tue'),
                                            context.tr('wed'),
                                            context.tr('thu'),
                                            context.tr('fri'),
                                            context.tr('sat'),
                                          ]
                                          .map(
                                            (d) => Expanded(
                                              child: Center(
                                                child: Text(
                                                  d,
                                                  style: TextStyle(
                                                    fontSize: w * 0.03,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.textSecondary(
                                                          context,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                                SizedBox(height: h * 0.01),

                                // Days grid
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: provider.calendarDays.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 7,
                                        mainAxisSpacing: 6,
                                        crossAxisSpacing: 6,
                                      ),
                                  itemBuilder: (context, index) {
                                    final day = provider.calendarDays[index];
                                    if (day == null) {
                                      return const SizedBox.shrink();
                                    }

                                    final isPast = provider.isPastDate(day);
                                    final isSelected = provider.isSameDay(
                                      day,
                                      provider.selectedDate,
                                    );

                                    return GestureDetector(
                                      onTap: isPast
                                          ? null
                                          : () => provider.selectDate(day),
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: isSelected
                                              ? AppColors.primaryGradient
                                              : null,
                                          color: isSelected
                                              ? null
                                              : Colors.transparent,
                                        ),
                                        child: Text(
                                          '${day.day}',
                                          style: TextStyle(
                                            fontSize: w * 0.035,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? AppColors.textWhite
                                                : isPast
                                                ? AppColors.textSecondary(
                                                    context,
                                                  ).withValues(alpha: 0.35)
                                                : AppColors.textPrimary(
                                                    context,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: h * 0.025),

                          // ── Select Time Slot ──
                          Text(
                            context.tr('select_time_slot'),
                            style: TextStyle(
                              fontSize: w * 0.042,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.015),

                          // Time grid (3 columns like S44 design)
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.timeSlots.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: h * 0.012,
                                  crossAxisSpacing: w * 0.025,
                                  childAspectRatio: 2.6,
                                ),
                            itemBuilder: (context, index) {
                              final time = provider.timeSlots[index];
                              final isSelected = provider.selectedTime == time;

                              return GestureDetector(
                                onTap: () => provider.selectTime(time),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? AppColors.primaryGradient
                                        : null,
                                    color: isSelected
                                        ? null
                                        : AppColors.inputBg(context),
                                    borderRadius: BorderRadius.circular(
                                      w * 0.06,
                                    ),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.transparent
                                          : AppColors.divider(context),
                                    ),
                                  ),
                                  child: Text(
                                    time,
                                    style: TextStyle(
                                      fontSize: w * 0.032,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? AppColors.textWhite
                                          : AppColors.textPrimary(context),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: h * 0.12),
                        ],
                      ),
                    ),
            ),

            // ── BOTTOM: Confirm Reschedule ──
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
                  text: context.tr('confirm_reschedule'),
                  width: double.infinity,
                  height: 55,
                  isLoading: provider.isSubmitting,
                  isEnabled: provider.canConfirm && !provider.isSubmitting,
                  onTap: !provider.canConfirm || provider.isSubmitting
                      ? null
                      : () async {
                          final success = await provider.confirmReschedule();
                          if (!context.mounted) return;

                          if (success) {
                            // Sync global My Bookings list
                            try {
                              final myBookings = context
                                  .read<MyBookingsProvider>();
                              final id = provider.bookingData['bookingId']
                                  ?.toString();

                              // Update existing booking in list if present
                              if (id != null) {
                                final list = myBookings.allBookings;
                                final idx = list.indexWhere(
                                  (b) => b['bookingId']?.toString() == id,
                                );
                                if (idx != -1) {
                                  list[idx] = {
                                    ...list[idx],
                                    ...provider.bookingData,
                                  };
                                  myBookings.selectedTabIndex = 0;
                                  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                                  myBookings.notifyListeners();
                                } else {
                                  myBookings.addBooking(provider.bookingData);
                                }
                              }
                            } catch (e) {
                              debugPrint('MyBookings sync failed: $e');
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(context.tr('reschedule_success')),
                                backgroundColor: AppColors.success,
                              ),
                            );

                            // Back to Upcoming Details / My Bookings
                            Navigator.pop(context, provider.bookingData);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(context.tr('reschedule_failed')),
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
