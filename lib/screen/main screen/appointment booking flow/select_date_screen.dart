import 'package:ever_salon/provider/appointment%20booking%20flow/select_date_provider.dart';
import 'package:ever_salon/screen/main%20screen/appointment%20booking%20flow/available_time_slot_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_button.dart';

class SelectDateScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const SelectDateScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectDateProvider(),
      child: _SelectDateView(bookingData: bookingData),
    );
  }
}

class _SelectDateView extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const _SelectDateView({required this.bookingData});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<SelectDateProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
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
                  // Back button
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

                  // Title
                  Center(
                    child: Text(
                      context.tr('select_date'),
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  // Spacer for balance
                  SizedBox(width: w * 0.1),
                ],
              ),
            ),

            // =================================================
            // CALENDAR BODY
            // =================================================
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Column(
                  children: [
                    SizedBox(height: h * 0.02),

                    // ---- Month / Year header with arrows ----
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: provider.previousMonth,
                          child: Icon(
                            Icons.chevron_left_rounded,
                            size: w * 0.08,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        Text(
                          provider.monthYearLabel,
                          style: TextStyle(
                            fontSize: w * 0.048,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        GestureDetector(
                          onTap: provider.nextMonth,
                          child: Icon(
                            Icons.chevron_right_rounded,
                            size: w * 0.08,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.025),

                    // ---- Weekday labels ----
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
                                        fontSize: w * 0.033,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary(context),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),

                    SizedBox(height: h * 0.015),

                    // ---- Dates Grid ----
                    _buildDatesGrid(context, w, h, provider),

                    SizedBox(height: h * 0.04),
                  ],
                ),
              ),
            ),

            // =================================================
            // BOTTOM SECTION  (Selected Date + Full-width Button)
            // Exact match with design image
            // =================================================
            _buildBottomSection(context, w, h, provider),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // DATES GRID
  // ----------------------------------------------------------
  Widget _buildDatesGrid(BuildContext context, double w, double h, SelectDateProvider provider) {
    final days = provider.calendarDays;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: days.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: h * 0.01,
        crossAxisSpacing: w * 0.01,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final date = days[index];

        // Empty cell (leading blanks)
        if (date == null) return const SizedBox.shrink();

        final isSelected = provider.isSameDay(date, provider.selectedDate);
        final isPast = provider.isPastDate(date);
        final isToday = provider.isSameDay(
          date,
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
        );

        return GestureDetector(
          onTap: isPast ? null : () => provider.selectDate(date),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Selected → solid pink
              color: isSelected ? AppColors.primaryPink : Colors.transparent,
              // Today (unselected) → light pink ring
              border: isToday && !isSelected
                  ? Border.all(color: AppColors.primaryPink, width: 1.5)
                  : null,
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: w * 0.038,
                  fontWeight: isSelected || isToday
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: isPast
                      ? AppColors.textSecondary(context).withValues(alpha: 0.35)
                      : isSelected
                      ? Colors.white
                      : AppColors.textPrimary(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------
  // BOTTOM: Selected Date card + Full-width Continue
  // ----------------------------------------------------------
  Widget _buildBottomSection(
    BuildContext context,
    double w,
    double h,
    SelectDateProvider provider,
  ) {
    final hasSelection = provider.selectedDate != null;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---------- Selected Date Display ----------
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.015,
              ),
              decoration: BoxDecoration(
                color: AppColors.inputBg(context),
                borderRadius: BorderRadius.circular(w * 0.03),
                border: Border.all(color: AppColors.divider(context)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('selected_date'),
                          style: TextStyle(
                            fontSize: w * 0.03,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                        SizedBox(height: h * 0.004),
                        Text(
                          provider.formattedSelectedDate,
                          style: TextStyle(
                            fontSize: w * 0.038,
                            fontWeight: FontWeight.bold,
                            color: hasSelection
                                ? AppColors.textPrimary(context)
                                : AppColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.primaryPink,
                    size: w * 0.055,
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.015),

            // ---------- Full-width Continue Button ----------
            CustomButton(
              text: context.tr('continue'),
              width: double.infinity,
              onTap: hasSelection
                  ? () {
                      // Previous screens ka saara data + selected date
                      final updatedBooking = {
                        ...bookingData,
                        'selectedDate': provider.selectedDate!
                            .toIso8601String(),
                        'formattedDate': provider.formattedSelectedDate,
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AvailableTimeSlotsScreen(
                            bookingData: updatedBooking,
                          ),
                        ),
                      );

                      debugPrint('S33 → S34 bookingData: $updatedBooking');
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.tr('select_date_first')),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}
