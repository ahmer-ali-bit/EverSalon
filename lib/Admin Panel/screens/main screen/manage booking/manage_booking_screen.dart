import 'package:ever_salon/Admin%20Panel/providers/drawer/admin_drawer_provider.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/manage%20booking/booking_details_screen.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/manage%20booking/calender_screen.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/manage%20booking/manual_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';
import '../../../providers/manage booking/manage_booking_provider.dart';

class ManageBookingScreen extends StatelessWidget {
  const ManageBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ManageBookingProvider(),
      child: const _ManageBookingContent(),
    );
  }
}

class _ManageBookingContent extends StatelessWidget {
  const _ManageBookingContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<ManageBookingProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.textPrimary(context)),
          onPressed: () {
            try {
              context.read<AdminDrawerProvider>().toggleDrawer();
            } catch (_) {}
          },
        ),
        title: Text(
          context.tr('Manage Bookings'),
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.calendar_month_outlined,
              color: AppColors.textPrimary(context),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminCalendarScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryPink.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () async {
            final dynamic manualResult = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminManualBookingScreen(),
              ),
            );

            // ✅ LINKED TO STATE PERSISTENCE: Save new walk-in record cleanly using provider method
            if (manualResult != null &&
                manualResult is Map<String, dynamic> &&
                context.mounted) {
              final Map<String, String> normalizedResult = {
                'id': manualResult['id']?.toString() ?? '',
                'customerName': manualResult['customerName']?.toString() ?? '',
                'customerAvatar':
                    manualResult['customerAvatar']?.toString() ?? '',
                'service': manualResult['service']?.toString() ?? '',
                'dateTime': manualResult['dateTime']?.toString() ?? '',
                'price': manualResult['price']?.toString() ?? '',
                'status': manualResult['status']?.toString() ?? 'Confirmed',
              };
              provider.addNewWalkInBooking(
                normalizedResult,
              ); // Triggers clean sync & notification
            }
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: Text(
            context.tr('New Walk-In'),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryPink),
              )
            : Column(
                children: [
                  // --- Gradient Tabs ---
                  SizedBox(
                    height: h * 0.06,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.filters.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: w * 0.03),
                      itemBuilder: (context, index) {
                        final filter = provider.filters[index];
                        final isSelected = provider.selectedFilter == filter;

                        return GestureDetector(
                          onTap: () => provider.setFilter(filter),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFFE82A78), // Primary Pink
                                        Color(0xFF6B2A8A), // Primary Purple
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: isSelected
                                  ? null
                                  : AppColors.inputBg(context),
                              borderRadius: BorderRadius.circular(w * 0.08),
                            ),
                            child: Text(
                              context.tr(filter),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary(context),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: w * 0.035,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: h * 0.01),

                  // --- Bookings List ---
                  Expanded(
                    child: provider.filteredBookings.isEmpty
                        ? Center(
                            child: Text(
                              context.tr('No bookings found'),
                              style: TextStyle(
                                color: AppColors.textSecondary(context),
                                fontSize: w * 0.038,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.04,
                              vertical: h * 0.02,
                            ),
                            itemCount: provider.filteredBookings.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: h * 0.02),
                            itemBuilder: (context, index) {
                              final booking = provider.filteredBookings[index];
                              return _buildBookingCard(context, w, booking);
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context,
    double w,
    Map<String, String> booking,
  ) {
    final statusStr = booking['status'] ?? 'Pending';

    Color statusColor;
    if (statusStr == 'Confirmed') {
      statusColor = AppColors.success;
    } else if (statusStr == 'Pending') {
      statusColor = Colors.orange;
    } else if (statusStr == 'Reschedule Pending') {
      statusColor = AppColors.primaryPurple;
    } else {
      statusColor = AppColors.error;
    }

    return GestureDetector(
      onTap: () async {
        final updated = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdminBookingDetailScreen(
              bookingData: {
                'id': booking['id'],
                'bookingId': booking['id'],
                'customerName': booking['customerName'],
                'customerPhone': '+92 300 1234567',
                'customerAvatar': booking['customerAvatar'],
                'service': booking['service'],
                'staffName': 'Anaya Khan',
                'date':
                    booking['dateTime']?.toString().split(',').first ??
                    '15 May 2024',
                'time': booking['dateTime']?.toString().contains(',') == true
                    ? booking['dateTime'].toString().split(',').last.trim()
                    : '10:00 AM',
                'duration': '60 mins',
                'amount': booking['price'],
                'paymentMethod': 'Card',
                'paymentStatus': 'Paid',
                'status': booking['status'],
                'notes': 'Prefer less heat on hair.',
              },
            ),
          ),
        );

        // ✅ LINKED TO STATE PERSISTENCE: Triggers clean status update inside static session
        if (updated != null && context.mounted) {
          context.read<ManageBookingProvider>().updateBookingStatus(
            updated['id'].toString(),
            updated['status'].toString(),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(w * 0.035),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(w * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(w * 0.02),
              child: Image.asset(
                booking['customerAvatar'] ?? '',
                width: w * 0.12,
                height: w * 0.12,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: w * 0.12,
                  height: w * 0.12,
                  color: AppColors.inputBg(context),
                  child: Icon(
                    Icons.person,
                    color: AppColors.textGrey,
                    size: w * 0.06,
                  ),
                ),
              ),
            ),
            SizedBox(width: w * 0.03),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking['customerName'] ?? '',
                    style: TextStyle(
                      fontSize: w * 0.038,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: w * 0.01),
                  Text(
                    booking['service'] ?? '',
                    style: TextStyle(
                      fontSize: w * 0.032,
                      color: AppColors.textSecondary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: w * 0.01),
                  Text(
                    booking['dateTime'] ?? '',
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.025,
                    vertical: w * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(w * 0.02),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    statusStr,
                    style: TextStyle(
                      fontSize: w * 0.025,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
                SizedBox(height: w * 0.06),
                Text(
                  booking['price'] ?? '',
                  style: TextStyle(
                    fontSize: w * 0.035,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
