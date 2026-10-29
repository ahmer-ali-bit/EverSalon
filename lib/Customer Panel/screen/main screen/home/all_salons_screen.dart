import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/customer%20home%20providers/all_salons_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/salon%20details/beauticians_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/salon%20details/salon_details_screen.dart';

class AllSalonsScreen extends StatelessWidget {
  final bool isBookingMode;
  final bool isPackageBooking;
  final Map<String, dynamic>? bookingData;

  const AllSalonsScreen({
    super.key,
    this.isBookingMode = false,
    this.isPackageBooking = false,
    this.bookingData,
  });

  bool get effectiveBookingMode => isBookingMode || isPackageBooking;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AllSalonsProvider()..fetchSalons(),
      child: _AllSalonsView(
        isBookingMode: effectiveBookingMode,
        bookingData: bookingData,
      ),
    );
  }
}

class _AllSalonsView extends StatelessWidget {
  final bool isBookingMode;
  final Map<String, dynamic>? bookingData;

  const _AllSalonsView({this.isBookingMode = false, this.bookingData});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final provider = Provider.of<AllSalonsProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.015,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: screenWidth * 0.1,
                      height: screenWidth * 0.1,
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.textPrimary(context),
                        size: screenWidth * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Text(
                      isBookingMode
                          ? (context.tr('Select Salon') ?? 'Select Salon')
                          : (context.tr('all_salons') ?? 'All Salons'),
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Booking mode banner — shows selected package info
            if (isBookingMode && bookingData?['package'] != null)
              _buildBookingBanner(context, screenWidth, screenHeight),

            // FILTER TABS (only in browse mode)
            if (!isBookingMode)
              _buildFilterTabs(context, screenWidth, screenHeight, provider),

            // SALONS LIST
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.015,
                        bottom: screenHeight * 0.04,
                        left: screenWidth * 0.04,
                        right: screenWidth * 0.04,
                      ),
                      itemCount: provider.salons.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: screenHeight * 0.015),
                      itemBuilder: (context, index) {
                        final salon = provider.salons[index];
                        return _buildSalonCard(
                          context,
                          screenWidth,
                          screenHeight,
                          salon,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Banner showing selected package (booking mode)
  Widget _buildBookingBanner(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    final pkg = bookingData!['package'];
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.005,
      ),
      padding: EdgeInsets.all(screenWidth * 0.035),
      decoration: BoxDecoration(
        color: AppColors.primaryPink.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        border: Border.all(
          color: AppColors.primaryPink.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.card_giftcard,
            color: AppColors.primaryPink,
            size: screenWidth * 0.06,
          ),
          SizedBox(width: screenWidth * 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('selected_package') ?? 'Selected Package',
                  style: TextStyle(
                    fontSize: screenWidth * 0.03,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                Text(
                  '${pkg['name']}  •  ${context.tr('rs')} ${pkg['price']}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPink,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Filter tabs (browse mode)
  Widget _buildFilterTabs(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    AllSalonsProvider provider,
  ) {
    final tabs = ['All', 'Popular', 'Nearby', 'Top Rated'];
    return SizedBox(
      height: screenHeight * 0.05,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        itemCount: tabs.length,
        separatorBuilder: (_, _) => SizedBox(width: screenWidth * 0.02),
        itemBuilder: (context, index) {
          final selected = provider.selectedTab == index;
          return GestureDetector(
            onTap: () => provider.selectTab(index),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.01,
              ),
              decoration: BoxDecoration(
                gradient: selected ? AppColors.primaryGradient : null,
                color: selected ? null : AppColors.inputBg(context),
                borderRadius: BorderRadius.circular(screenWidth * 0.06),
              ),
              child: Center(
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? Colors.white
                        : AppColors.textPrimary(context),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSalonCard(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> salon,
  ) {
    return GestureDetector(
      onTap: () {
        if (isBookingMode) {
          final updatedBooking = {
            ...?bookingData,
            'flowType': 'package',
            'salon': Map<String, dynamic>.from(salon),
            'salonData': Map<String, dynamic>.from(salon),
          };

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BeauticiansScreen(
                salonData: Map<String, dynamic>.from(salon),
                isBookingMode: true,
                bookingData: updatedBooking,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SalonDetailsScreen(salonData: salon),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(screenWidth * 0.035),
          border: Border.all(color: AppColors.divider(context), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.025),
              child: Image.asset(
                salon['image'] ?? 'assets/images/glow beauty lounge.png',
                height: screenWidth * 0.22,
                width: screenWidth * 0.22,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: screenWidth * 0.22,
                    width: screenWidth * 0.22,
                    color: AppColors.inputBg(context),
                    child: Icon(
                      Icons.storefront,
                      color: AppColors.textSecondary(context),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon['name'] ?? 'Salon',
                    style: TextStyle(
                      fontSize: screenWidth * 0.042,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: screenWidth * 0.04,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        "${salon['rating'] ?? 0.0} (${salon['reviews'] ?? 0})",
                        style: TextStyle(
                          fontSize: screenWidth * 0.032,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColors.textSecondary(context),
                        size: screenWidth * 0.04,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Expanded(
                        child: Text(
                          salon['address'] ?? salon['distance'] ?? '',
                          style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            color: AppColors.textSecondary(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // In booking mode: show arrow indicator
            if (isBookingMode)
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryPink,
                size: screenWidth * 0.04,
              ),
          ],
        ),
      ),
    );
  }
}
