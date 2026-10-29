import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/salon%20details%20providers/salon_location_provider.dart';

/// S30 - Salon Location Screen
class SalonLocationScreen extends StatelessWidget {
  final Map<String, dynamic> salonData;

  const SalonLocationScreen({super.key, required this.salonData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SalonLocationProvider()..initLocationData(salonData),
      child: const _SalonLocationView(),
    );
  }
}

class _SalonLocationView extends StatelessWidget {
  const _SalonLocationView();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final provider = Provider.of<SalonLocationProvider>(context);
    final data = provider.locationData;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ========================
            // STANDARD TOP HEADER
            // ========================
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
                  Expanded(
                    child: Center(
                      child: Text(
                        context.tr('salon_location'),
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                  ),
                  // Balance alignment
                  SizedBox(width: screenWidth * 0.1),
                ],
              ),
            ),

            // ========================
            // CONTENT
            // ========================
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : Column(
                      children: [
                        // ========================
                        // MAP SECTION
                        // ========================
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFE8F5E9,
                              ), // Light green map bg
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.04,
                              ),
                              border: Border.all(
                                color: AppColors.divider(context),
                                width: 1,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Map placeholder pattern / icon
                                Center(
                                  child: Icon(
                                    Icons.map_outlined,
                                    size: screenWidth * 0.25,
                                    color: AppColors.textSecondary(
                                      context,
                                    ).withValues(alpha: 0.25),
                                  ),
                                ),

                                // Soft area labels (mock map feel)
                                Positioned(
                                  top: screenHeight * 0.04,
                                  left: screenWidth * 0.06,
                                  child: Text(
                                    'Yasrab Town',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.03,
                                      color: AppColors.textSecondary(
                                        context,
                                      ).withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: screenHeight * 0.08,
                                  right: screenWidth * 0.08,
                                  child: Text(
                                    'Model Town A',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.028,
                                      color: AppColors.textSecondary(
                                        context,
                                      ).withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: screenHeight * 0.12,
                                  left: screenWidth * 0.1,
                                  child: Text(
                                    'Farid Gate',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.028,
                                      color: AppColors.textSecondary(
                                        context,
                                      ).withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),

                                // Pink location pin (center)
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: AppColors.primaryPink,
                                        size: screenWidth * 0.14,
                                      ),
                                      // Pin shadow/dot
                                      Container(
                                        width: screenWidth * 0.025,
                                        height: screenWidth * 0.01,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            screenWidth * 0.02,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // ========================
                        // SALON INFO CARD
                        // ========================
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg(context),
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.04,
                            ),
                            border: Border.all(
                              color: AppColors.divider(context),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name + Distance row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      data['name'] ?? 'Salon Name',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary(context),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    data['distance'] ?? '0 ${context.tr('km')}',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryPink,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.01),

                              // Address
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: AppColors.primaryPink,
                                    size: screenWidth * 0.045,
                                  ),
                                  SizedBox(width: screenWidth * 0.015),
                                  Expanded(
                                    child: Text(
                                      data['fullAddress'] ?? 'Address',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.033,
                                        color: AppColors.textSecondary(context),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.01),

                              // Opening hours
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: AppColors.textSecondary(context),
                                    size: screenWidth * 0.04,
                                  ),
                                  SizedBox(width: screenWidth * 0.015),
                                  Text(
                                    '${context.tr('open_hours_prefix')} ${data['openTime'] ?? '10:00 AM'} - ${data['closeTime'] ?? '9:00 PM'}',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.033,
                                      color: AppColors.textSecondary(context),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // ========================
                        // ACTION BUTTONS (Directions + Call Now)
                        // ========================
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                          ),
                          child: Row(
                            children: [
                              // Directions (outlined)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => provider.openDirections(),
                                  child: Container(
                                    height: screenHeight * 0.06,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        screenWidth * 0.03,
                                      ),
                                      border: Border.all(
                                        color: AppColors.primaryPink,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.near_me_outlined,
                                          color: AppColors.primaryPink,
                                          size: screenWidth * 0.05,
                                        ),
                                        SizedBox(width: screenWidth * 0.02),
                                        Text(
                                          context.tr('direction'),
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.038,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryPink,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: screenWidth * 0.03),

                              // Call Now (filled pink)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => provider.callSalon(),
                                  child: Container(
                                    height: screenHeight * 0.06,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(
                                        screenWidth * 0.03,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.call,
                                          color: Colors.white,
                                          size: screenWidth * 0.05,
                                        ),
                                        SizedBox(width: screenWidth * 0.02),
                                        Text(
                                          context.tr('call_now'),
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.038,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.025),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
