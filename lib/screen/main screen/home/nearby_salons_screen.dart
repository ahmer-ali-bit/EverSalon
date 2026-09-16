import 'package:ever_salon/provider/customer%20home%20providers/nearby_salons_provider.dart';
import 'package:ever_salon/screen/main%20screen/salon%20details/salon_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';

class NearbySalonsScreen extends StatelessWidget {
  const NearbySalonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NearbySalonsProvider()..fetchNearbySalons(),
      child: const _NearbySalonsView(),
    );
  }
}

class _NearbySalonsView extends StatelessWidget {
  const _NearbySalonsView();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NearbySalonsProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Padding(
              padding: EdgeInsets.all(padding),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.textPrimary(context),
                        size: screenWidth * 0.045,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),

                  // Title & Location Dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('nearby_salons'),
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.002),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.primaryPink,
                              size: screenWidth * 0.035,
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              provider.currentLocation,
                              style: TextStyle(
                                fontSize: screenWidth * 0.032,
                                color: AppColors.textSecondary(context),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.textSecondary(context),
                              size: screenWidth * 0.04,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // GPS Target Icon
                  GestureDetector(
                    onTap: () => provider.updateLocation(),
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.025),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg(context),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.divider(context)),
                      ),
                      child: Icon(
                        Icons.my_location,
                        color: AppColors.textPrimary(context),
                        size: screenWidth * 0.05,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- MAP AREA (Placeholder) ---
            // ========================================================
            // TODO: REPLACE THIS STACK WITH GoogleMap WIDGET
            // Use google_maps_flutter package here
            // ========================================================
            Container(
              height: screenHeight * 0.28,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: padding),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9), // Light map-like background
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider(context)),
                // Optional: Add a faint map grid pattern image here
              ),
              child: Stack(
                children: [
                  // Dummy Grid Lines to simulate map
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.2,
                      child: GridPaper(
                        color: Colors.green,
                        interval: screenWidth * 0.1,
                      ),
                    ),
                  ),

                  // User Current Location Pin (Blue)
                  Positioned(
                    top: screenHeight * 0.14,
                    left: screenWidth * 0.45,
                    child: Container(
                      width: screenWidth * 0.05,
                      height: screenWidth * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Salon Pin 1 (Pink)
                  Positioned(
                    top: screenHeight * 0.06,
                    left: screenWidth * 0.2,
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.primaryPink,
                      size: screenWidth * 0.08,
                    ),
                  ),

                  // Salon Pin 2 (Pink)
                  Positioned(
                    top: screenHeight * 0.18,
                    left: screenWidth * 0.7,
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.primaryPink,
                      size: screenWidth * 0.08,
                    ),
                  ),

                  // Salon Pin 3 (Pink)
                  Positioned(
                    top: screenHeight * 0.08,
                    left: screenWidth * 0.6,
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.primaryPink,
                      size: screenWidth * 0.08,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // --- SALONS LIST ---
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      itemCount: provider.salons.length,
                      itemBuilder: (context, index) {
                        final salon = provider.salons[index];
                        return _buildNearbySalonCard(
                          context: context,
                          salon: salon,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          onFavoriteTap: () => provider.toggleFavorite(index),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    SalonDetailsScreen(salonData: salon),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // --- NEARBY SALON CARD WIDGET ---
  Widget _buildNearbySalonCard({
    required BuildContext context,
    required Map<String, dynamic> salon,
    required double screenWidth,
    required double screenHeight,
    required VoidCallback onFavoriteTap,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.018),
        padding: EdgeInsets.all(screenWidth * 0.025),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider(context), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                salon['image'],
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

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          salon['name'],
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onFavoriteTap,
                        child: Icon(
                          salon['isFavorite']
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: salon['isFavorite']
                              ? AppColors.primaryPink
                              : AppColors.textSecondary(context),
                          size: screenWidth * 0.05,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.006),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: screenWidth * 0.04,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        "${salon['rating']} (${salon['reviews']})",
                        style: TextStyle(
                          fontSize: screenWidth * 0.032,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: AppColors.textSecondary(context),
                            size: screenWidth * 0.04,
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          Text(
                            salon['distance'],
                            style: TextStyle(
                              fontSize: screenWidth * 0.032,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                      // View on Map mini button text
                      Text(
                        context.tr('view_on_map'),
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryPink,
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
