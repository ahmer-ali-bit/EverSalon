import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/appointment%20booking%20flow/available_time_slot_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/appointment%20booking%20flow/booking_summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/widgets/custom_button.dart';

class AvailableTimeSlotsScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const AvailableTimeSlotsScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AvailableTimeSlotsProvider()..init(bookingData),
      child: _AvailableTimeSlotsView(bookingData: bookingData),
    );
  }
}

class _AvailableTimeSlotsView extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const _AvailableTimeSlotsView({required this.bookingData});

  String get _shortDateLabel {
    final formatted = bookingData['formattedDate']?.toString() ?? '';
    if (formatted.isEmpty) return '';
    final parts = formatted.split(', ');
    if (parts.length >= 2) {
      final dayShort = parts[0].length >= 3
          ? parts[0].substring(0, 3)
          : parts[0];
      return '$dayShort, ${parts[1]}';
    }
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AvailableTimeSlotsProvider>();

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
                      context.tr('available_time_slots'),
                      style: TextStyle(
                        fontSize: w * 0.048,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.1),
                ],
              ),
            ),

            // ── DATE LABEL ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _shortDateLabel.isNotEmpty
                      ? _shortDateLabel
                      : context.tr('select_time'),
                  style: TextStyle(
                    fontSize: w * 0.038,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ),
            ),
            SizedBox(height: h * 0.02),

            // ── TABS ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: Container(
                height: h * 0.055,
                decoration: BoxDecoration(
                  color: inputBg,
                  borderRadius: BorderRadius.circular(w * 0.03),
                ),
                child: Row(
                  children: provider.periods.map((periodKey) {
                    final isSelected = provider.selectedPeriod == periodKey;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => provider.selectPeriod(periodKey),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.all(w * 0.01),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryPink
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(w * 0.025),
                          ),
                          child: Center(
                            child: Text(
                              context.tr(periodKey),
                              style: TextStyle(
                                fontSize: w * 0.035,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : textSecondary,
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
            SizedBox(height: h * 0.02),

            // ── TIME SLOTS GRID ──
            // FIX: loader OVERLAY style — slots hamesha neeche rehte hain
            // isliye "gaib" nahi hote
            Expanded(
              child: Stack(
                children: [
                  // Slots always built
                  _buildSlotsGrid(
                    context,
                    w,
                    h,
                    provider,
                    scaffoldBg,
                    textPrimary,
                    primaryPink,
                    borderColor,
                  ),

                  // Soft loading overlay (optional)
                  if (provider.isLoading)
                    Container(
                      color: scaffoldBg.withValues(alpha: 0.35),
                      child: Center(
                        child: SizedBox(
                          width: w * 0.08,
                          height: w * 0.08,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: primaryPink,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── BOTTOM BAR ──
            _buildBottomBar(
              context,
              w,
              h,
              provider,
              scaffoldBg,
              inputBg,
              textPrimary,
              textSecondary,
              primaryPink,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotsGrid(
    BuildContext context,
    double w,
    double h,
    AvailableTimeSlotsProvider provider,
    Color scaffoldBg,
    Color textPrimary,
    Color primaryPink,
    Color borderColor,
  ) {
    final slots = provider.currentSlots;

    if (slots.isEmpty) {
      return Center(
        child: Text(
          context.tr('no_slots_available'),
          style: TextStyle(
            color: textPrimary.withValues(alpha: 0.5),
            fontSize: w * 0.04,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(w * 0.04, 0, w * 0.04, h * 0.02),
      itemCount: slots.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: h * 0.015,
        crossAxisSpacing: w * 0.03,
        childAspectRatio: 2.3,
      ),
      itemBuilder: (context, index) {
        final time = slots[index];
        final isSelected = provider.isTimeSelected(time);

        return GestureDetector(
          onTap: () => provider.selectTime(time),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: isSelected ? primaryPink : scaffoldBg,
              borderRadius: BorderRadius.circular(w * 0.025),
              border: Border.all(
                color: isSelected ? Colors.transparent : borderColor,
                width: 1.2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: primaryPink.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                time,
                style: TextStyle(
                  fontSize: w * 0.033,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : textPrimary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    double w,
    double h,
    AvailableTimeSlotsProvider provider,
    Color scaffoldBg,
    Color inputBg,
    Color textPrimary,
    Color textSecondary,
    Color primaryPink,
  ) {
    final hasSelection = provider.selectedTime != null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.015, w * 0.04, h * 0.02),
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
              width: double.infinity,
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
                          context.tr('selected_time'),
                          style: TextStyle(
                            fontSize: w * 0.03,
                            color: textSecondary,
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
                            color: hasSelection ? textPrimary : textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.access_time_rounded,
                    color: primaryPink,
                    size: w * 0.055,
                  ),
                ],
              ),
            ),
            SizedBox(height: h * 0.015),
            CustomButton(
              text: context.tr('Continue'),
              width: double.infinity,
              onTap: hasSelection
                  ? () {
                      // package + service dono flows ka data aage jaega
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
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
