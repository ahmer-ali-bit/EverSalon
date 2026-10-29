import 'package:ever_salon/Admin%20Panel/providers/manage%20booking/calender_provider.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/manage%20booking/booking_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class AdminCalendarScreen extends StatelessWidget {
  const AdminCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminCalendarProvider(),
      child: const _AdminCalendarContent(),
    );
  }
}

class _AdminCalendarContent extends StatelessWidget {
  const _AdminCalendarContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminCalendarProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
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
                  SizedBox(width: w * 0.04),
                  Text(
                    context.tr('Schedule Calendar'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),

            // --- DATE STRIP ---
            _buildDateStrip(context, w, h, provider),
            SizedBox(height: h * 0.015),

            // --- STAFF FILTERS ---
            SizedBox(
              height: h * 0.045,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                scrollDirection: Axis.horizontal,
                itemCount: provider.staffList.length,
                separatorBuilder: (_, _) => SizedBox(width: w * 0.02),
                itemBuilder: (context, index) {
                  final staff = provider.staffList[index];
                  final isSelected = provider.selectedStaff == staff;
                  return GestureDetector(
                    onTap: () => provider.selectStaff(staff),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.008,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryPink
                            : AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(w * 0.06),
                      ),
                      child: Text(
                        staff,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary(context),
                          fontSize: w * 0.032,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: h * 0.01),
            Divider(color: AppColors.inputBg(context), thickness: 1.5),

            // --- TIMELINE ---
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.02,
                      ),
                      itemCount: provider.timeSlots.length,
                      itemBuilder: (context, index) {
                        final slot = provider.timeSlots[index];
                        return _buildTimelineRow(context, w, h, slot);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateStrip(
    BuildContext context,
    double w,
    double h,
    AdminCalendarProvider provider,
  ) {
    final now = DateTime.now();
    return SizedBox(
      height: h * 0.085,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        separatorBuilder: (_, _) => SizedBox(width: w * 0.025),
        itemBuilder: (context, index) {
          final date = now.add(Duration(days: index));
          final isSelected =
              provider.selectedDate.day == date.day &&
              provider.selectedDate.month == date.month;

          final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
          final dayName = days[date.weekday - 1];

          return GestureDetector(
            onTap: () => provider.selectDate(date),
            child: Container(
              width: w * 0.14,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFFE82A78), Color(0xFF6B2A8A)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
                color: isSelected ? null : AppColors.cardBg(context),
                borderRadius: BorderRadius.circular(w * 0.035),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : AppColors.inputBg(context),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: isSelected
                          ? Colors.white70
                          : AppColors.textSecondary(context),
                    ),
                  ),
                  SizedBox(height: h * 0.005),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimelineRow(
    BuildContext context,
    double w,
    double h,
    Map<String, dynamic> slot,
  ) {
    final timeStr = slot['time'] as String;
    final isBooked = slot['isBooked'] as bool;
    final isContinued = slot['isContinued'] as bool;
    final booking = slot['booking'] as Map<String, dynamic>?;

    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TIME LABEL
          SizedBox(
            width: w * 0.18,
            child: Padding(
              padding: EdgeInsets.only(top: h * 0.015),
              child: Text(
                timeStr,
                style: TextStyle(
                  fontSize: w * 0.032,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ),
          ),

          // TIMELINE CONTENT
          Expanded(
            child: _buildSlotContent(
              context,
              w,
              h,
              isBooked,
              isContinued,
              booking,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotContent(
    BuildContext context,
    double w,
    double h,
    bool isBooked,
    bool isContinued,
    Map<String, dynamic>? booking,
  ) {
    if (!isBooked || booking == null) {
      // EMPTY SLOT
      return Container(
        height: h * 0.06,
        decoration: BoxDecoration(
          color: AppColors.inputBg(context).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(w * 0.03),
          border: Border.all(
            color: AppColors.inputBg(context),
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Text(
            context.tr('Slot Available'),
            style: TextStyle(
              fontSize: w * 0.03,
              color: AppColors.textGrey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    if (isContinued) {
      // ONGOING SERVICE SLOT (Block 2nd/3rd hour)
      return Container(
        height: h * 0.06,
        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
        decoration: BoxDecoration(
          color: AppColors.primaryPink.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(w * 0.03),
          border: Border.all(
            color: AppColors.primaryPink.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.more_time,
              color: AppColors.primaryPink.withValues(alpha: 0.7),
              size: w * 0.05,
            ),
            SizedBox(width: w * 0.02),
            Expanded(
              child: Text(
                "Ongoing • ${booking['service']} (${booking['staffName']})",
                style: TextStyle(
                  fontSize: w * 0.032,
                  color: AppColors.primaryPink,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    // MAIN BOOKING START SLOT
    Color statusColor;
    if (booking['status'] == 'Confirmed') {
      statusColor = AppColors.success;
    } else if (booking['status'] == 'Pending')
      statusColor = Colors.orange;
    else
      statusColor = Colors.blue; // Completed

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdminBookingDetailScreen(bookingData: booking),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(w * 0.035),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(w * 0.04),
          border: Border.all(color: statusColor.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: h * 0.05,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking['customerName'],
                    style: TextStyle(
                      fontSize: w * 0.038,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "${booking['service']} • ${booking['staffName']}",
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.025,
                vertical: w * 0.01,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(w * 0.02),
              ),
              child: Text(
                booking['status'],
                style: TextStyle(
                  fontSize: w * 0.025,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
