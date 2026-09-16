import 'package:ever_salon/provider/appointment%20booking%20flow/available_time_slot_provider.dart';
import 'package:ever_salon/screen/main%20screen/appointment%20booking%20flow/booking_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_button.dart';
// TODO: S35 Ban'ne ke baad import add karna
// import 'package:ever_salon/screen/booking/booking_summary_screen.dart';

class AvailableTimeSlotsScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const AvailableTimeSlotsScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    final salonId = bookingData['salonData']?['id']?.toString() ?? '1';
    final date = bookingData['selectedDate']?.toString() ?? '';
    final beauticianId = bookingData['beautician']?['id']?.toString();

    return ChangeNotifierProvider<AvailableTimeSlotsProvider>(
      create: (_) =>
          AvailableTimeSlotsProvider()
            ..init(salonId: salonId, date: date, beauticianId: beauticianId),
      child: _AvailableTimeSlotsView(bookingData: bookingData),
    );
  }
}

class _AvailableTimeSlotsView extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const _AvailableTimeSlotsView({required this.bookingData});

  String _dateLabel(BuildContext context) {
    final formatted = bookingData['formattedDate']?.toString();
    if (formatted != null && formatted.isNotEmpty) {
      final parts = formatted.split(', ');
      if (parts.length >= 2) {
        final dayShort = parts[0].length >= 3
            ? parts[0].substring(0, 3)
            : parts[0];
        return '$dayShort, ${parts[1]}';
      }
      return formatted;
    }
    return context.tr('select_time_slot');
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Consumer<AvailableTimeSlotsProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                // ================= HEADER =================
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
                          context.tr('available_time_slots'),
                          style: TextStyle(
                            fontSize: w * 0.048,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.1),
                    ],
                  ),
                ),

                // ================= DATE SUBHEADER =================
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _dateLabel(context),
                      style: TextStyle(
                        fontSize: w * 0.038,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: h * 0.02),

                // ================= PERIOD TABS (Morning, Afternoon, Evening) =================
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                  child: Container(
                    height: h * 0.055,
                    decoration: BoxDecoration(
                      color: AppColors.inputBg(context),
                      borderRadius: BorderRadius.circular(w * 0.03),
                    ),
                    child: Row(
                      children: provider.periods.map((period) {
                        final isSelected = provider.selectedPeriod == period;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => provider.selectPeriod(period),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              margin: EdgeInsets.all(w * 0.01),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? AppColors.primaryGradient
                                    : null,
                                color: isSelected ? null : Colors.transparent,
                                borderRadius: BorderRadius.circular(w * 0.025),
                              ),
                              child: Center(
                                child: Text(
                                  period,
                                  style: TextStyle(
                                    fontSize: w * 0.035,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textSecondary(context),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                SizedBox(height: h * 0.025),

                // ================= TIME SLOTS GRID =================
                Expanded(
                  child: provider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryPink,
                          ),
                        )
                      : _buildSlotsGrid(context, w, h, provider),
                ),

                // ================= BOTTOM CONFIRMATION BAR =================
                _buildBottomSection(context, w, h, provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSlotsGrid(
    BuildContext context,
    double w,
    double h,
    AvailableTimeSlotsProvider provider,
  ) {
    final slots = provider.currentSlots;

    if (slots.isEmpty) {
      return Center(
        child: Text(
          context.tr('no_time_slots'),
          style: TextStyle(color: AppColors.textSecondary(context), fontSize: w * 0.04),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
      itemCount: slots.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: h * 0.015,
        crossAxisSpacing: w * 0.03,
        childAspectRatio: 2.3,
      ),
      itemBuilder: (context, index) {
        final slot = slots[index];
        final time = slot['time'] as String;
        final isSelected = provider.isTimeSelected(time);

        return GestureDetector(
          onTap: () => provider.selectTime(time),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.primaryGradient : null,
              color: isSelected ? null : AppColors.cardBg(context),
              borderRadius: BorderRadius.circular(w * 0.025),
              border: Border.all(
                color: isSelected ? Colors.transparent : AppColors.divider(context),
                width: 1.2,
              ),
            ),
            child: Center(
              child: Text(
                time,
                style: TextStyle(
                  fontSize: w * 0.033,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textPrimary(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection(
    BuildContext context,
    double w,
    double h,
    AvailableTimeSlotsProvider provider,
  ) {
    final hasSelection = provider.selectedTime != null;

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
            // Selected Time Card
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
                          context.tr('selected_time'),
                          style: TextStyle(
                            fontSize: w * 0.03,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                        SizedBox(height: h * 0.004),
                        Text(
                          hasSelection
                              ? provider.selectedTime!
                              : context.tr('please_select_time'),
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
                    Icons.access_time_rounded,
                    color: AppColors.primaryPink,
                    size: w * 0.055,
                  ),
                ],
              ),
            ),

            SizedBox(height: h * 0.015),

            // Continue Button
            CustomButton(
              text: context.tr('continue'),
              width: double.infinity,
              onTap: hasSelection
                  ? () {
                      final updatedBooking = {
                        ...bookingData,
                        'selectedTime': provider.selectedTime,
                        'selectedPeriod': provider.selectedPeriod,
                      };

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BookingSummaryScreen(bookingData: updatedBooking),
                        ),
                      );

                      debugPrint('S34 -> S35 Data: $updatedBooking');
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.tr('please_select_slot')),
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
