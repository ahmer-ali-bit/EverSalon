import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/my%20booking/my_booking_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/my%20booking/booking_details_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/my%20booking/completed_booking_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/my%20booking/upcoming_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Global MyBookingsProvider (main.dart se) — naya instance NA banao
    return const _MyBookingsView();
  }
}

class _MyBookingsView extends StatelessWidget {
  const _MyBookingsView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MyBookingsProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Text(
                context.tr('my_bookings'),
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontSize: screenWidth * 0.065,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Tabs
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.inputBg(context),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    _buildTabButton(
                      context: context,
                      title: context.tr('upcoming'),
                      isSelected: provider.selectedTabIndex == 0,
                      onTap: () => provider.changeTab(0),
                    ),
                    _buildTabButton(
                      context: context,
                      title: context.tr('completed'),
                      isSelected: provider.selectedTabIndex == 1,
                      onTap: () => provider.changeTab(1),
                    ),
                    _buildTabButton(
                      context: context,
                      title: context.tr('cancelled'),
                      isSelected: provider.selectedTabIndex == 2,
                      onTap: () => provider.changeTab(2),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : provider.displayedBookings.isEmpty
                  ? Center(
                      child: Text(
                        context.tr('no_bookings'),
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.01,
                      ),
                      itemCount: provider.displayedBookings.length,
                      itemBuilder: (context, index) {
                        final booking = provider.displayedBookings[index];
                        return _buildBookingCard(context, booking, screenWidth);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? AppColors.textWhite
                  : AppColors.textSecondary(context),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width * 0.035,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context,
    Map<String, dynamic> booking,
    double screenWidth,
  ) {
    final salonRaw = booking['salonData'] ?? booking['salon'];
    final salon = salonRaw is Map
        ? Map<String, dynamic>.from(salonRaw)
        : <String, dynamic>{};

    final beauticianRaw =
        booking['beautician'] ?? booking['selectedBeautician'];
    final beautician = beauticianRaw is Map
        ? Map<String, dynamic>.from(beauticianRaw)
        : <String, dynamic>{};

    final servicesRaw = booking['selectedServices'] ?? booking['services'];
    String serviceName = 'Service';
    if (servicesRaw is List && servicesRaw.isNotEmpty) {
      final first = servicesRaw.first;
      if (first is Map) {
        serviceName = first['name']?.toString() ?? 'Service';
      }
    } else {
      serviceName = booking['serviceName']?.toString() ?? 'Service';
    }

    final status = booking['status']?.toString() ?? 'upcoming';
    late Color statusColor;
    late String statusText;
    if (status == 'upcoming') {
      statusColor = AppColors.primaryPink;
      statusText = context.tr('confirmed');
    } else if (status == 'completed') {
      statusColor = AppColors.success;
      statusText = context.tr('completed');
    } else {
      statusColor = AppColors.error;
      statusText = context.tr('cancelled');
    }

    final salonImage = salon['image']?.toString() ?? '';
    final beauticianImage = beautician['image']?.toString() ?? '';
    final beauticianName = beautician['name']?.toString() ?? 'N/A';
    final salonName = salon['name']?.toString() ?? 'Salon';
    final dateLabel =
        booking['formattedDate']?.toString() ??
        booking['selectedDate']?.toString() ??
        '';
    final timeLabel = booking['selectedTime']?.toString() ?? '';

    return GestureDetector(
      onTap: () {
        final status = booking['status']?.toString() ?? 'upcoming';

        if (status == 'upcoming') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UpcomingBookingScreen(bookingData: booking),
            ),
          );
        } else if (status == 'completed') {
          // ★ S47 yahan se open hoti hai
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CompletedBookingScreen(bookingData: booking),
            ),
          );
        } else if (status == 'cancelled') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingDetailsScreen(bookingData: booking),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppColors.divider(context), width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                salonImage,
                width: screenWidth * 0.22,
                height: screenWidth * 0.22,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: screenWidth * 0.22,
                  height: screenWidth * 0.22,
                  color: AppColors.inputBg(context),
                  child: Icon(
                    Icons.image_not_supported,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salonName,
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.042,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    serviceName,
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$dateLabel • $timeLabel',
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              beauticianImage,
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 24,
                                    height: 24,
                                    color: AppColors.inputBg(context),
                                    child: Icon(
                                      Icons.person,
                                      size: 16,
                                      color: AppColors.textSecondary(context),
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            beauticianName,
                            style: TextStyle(
                              color: AppColors.textPrimary(context),
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.032,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          border: Border.all(color: statusColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: screenWidth * 0.028,
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
    );
  }
}
