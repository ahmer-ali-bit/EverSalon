import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/appointment%20booking%20flow/select_date_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/appointment%20booking%20flow/available_time_slot_screen.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:ever_salon/constants/app_colors.dart';
// import 'package:ever_salon/widgets/custom_button.dart';
// import 'package:ever_salon/utils/localization_extension.dart';
// import 'package:ever_salon/screens/available_time_slots_screen.dart'; // Uncomment baad mein

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

    // Dynamic Theme Colors
    final scaffoldBg = AppColors.scaffoldBg(context);
    final textPrimary = AppColors.textPrimary(context);
    final textSecondary = AppColors.textSecondary(context);
    final inputBg = AppColors.inputBg(context);
    final primaryPink = AppColors.primaryPink;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
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
                      context.tr('select_date'),
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

            // CALENDAR BODY
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                child: Column(
                  children: [
                    SizedBox(height: h * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: provider.previousMonth,
                          child: Icon(
                            Icons.chevron_left_rounded,
                            size: w * 0.08,
                            color: textPrimary,
                          ),
                        ),
                        Text(
                          provider.monthYearLabel,
                          style: TextStyle(
                            fontSize: w * 0.048,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: provider.nextMonth,
                          child: Icon(
                            Icons.chevron_right_rounded,
                            size: w * 0.08,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.025),
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
                                (day) => Expanded(
                                  child: Center(
                                    child: Text(
                                      day,
                                      style: TextStyle(
                                        fontSize: w * 0.033,
                                        fontWeight: FontWeight.w600,
                                        color: textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    SizedBox(height: h * 0.015),

                    // Dates Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.calendarDays.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: h * 0.01,
                        crossAxisSpacing: w * 0.01,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final date = provider.calendarDays[index];
                        if (date == null) return const SizedBox.shrink();

                        final isSelected = provider.isSameDay(
                          date,
                          provider.selectedDate,
                        );
                        final isPast = provider.isPastDate(date);
                        final isToday = provider.isSameDay(
                          date,
                          DateTime.now(),
                        );

                        return GestureDetector(
                          onTap: isPast
                              ? null
                              : () => provider.selectDate(date),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? primaryPink
                                  : Colors.transparent,
                              border: isToday && !isSelected
                                  ? Border.all(color: primaryPink, width: 1.5)
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
                                      ? textSecondary.withValues(alpha: 0.35)
                                      : isSelected
                                      ? Colors.white
                                      : textPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: h * 0.04),
                  ],
                ),
              ),
            ),

            // BOTTOM BAR
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.015,
                      ),
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(w * 0.03),
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
                                    color: textSecondary,
                                  ),
                                ),
                                SizedBox(height: h * 0.004),
                                Text(
                                  provider.selectedDate != null
                                      ? provider.formattedSelectedDate
                                      : context.tr('Please select date'),
                                  style: TextStyle(
                                    fontSize: w * 0.038,
                                    fontWeight: FontWeight.bold,
                                    color: provider.selectedDate != null
                                        ? textPrimary
                                        : textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.calendar_today_outlined,
                            color: primaryPink,
                            size: w * 0.055,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.015),
                    CustomButton(
                      text: context.tr('Continue'),
                      onTap: provider.selectedDate != null
                          ? () {
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
                            }
                          : null,
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
}
