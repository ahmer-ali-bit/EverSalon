import 'package:ever_salon/Customer%20Panel/screen/main%20screen/appointment%20booking%20flow/select_date_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/salon%20details%20providers/beauticians_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/salon%20details/beautician_details_screen.dart';
import 'package:ever_salon/widgets/custom_button.dart';

/// S27 - Beauticians Screen
/// - isBookingMode = false → Browse only (tap opens details)
/// - isBookingMode = true  → Single-select with confirm bar (Booking flow)
class BeauticiansScreen extends StatelessWidget {
  final Map<String, dynamic> salonData;
  final bool isBookingMode;
  final Map<String, dynamic>? bookingData;

  const BeauticiansScreen({
    super.key,
    required this.salonData,
    this.isBookingMode = false,
    this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          BeauticiansProvider()
            ..fetchBeauticians(salonData['id']?.toString() ?? '1'),
      child: _BeauticiansView(
        salonData: salonData,
        isBookingMode: isBookingMode,
        bookingData: bookingData,
      ),
    );
  }
}

class _BeauticiansView extends StatelessWidget {
  final Map<String, dynamic> salonData;
  final bool isBookingMode;
  final Map<String, dynamic>? bookingData;

  const _BeauticiansView({
    required this.salonData,
    required this.isBookingMode,
    this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final provider = Provider.of<BeauticiansProvider>(context);

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

                  Center(
                    child: Text(
                      isBookingMode
                          ? context.tr('select_beautician')
                          : context.tr('our_beauticians'),
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.1),
                ],
              ),
            ),

            // LIST
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.01,
                        bottom: isBookingMode
                            ? screenHeight * 0.14
                            : screenHeight * 0.04,
                        left: screenWidth * 0.04,
                        right: screenWidth * 0.04,
                      ),
                      itemCount: provider.beauticians.length,
                      separatorBuilder: (_, _) => Divider(
                        color: AppColors.divider(context),
                        thickness: 1,
                        height: screenHeight * 0.03,
                      ),
                      itemBuilder: (context, index) {
                        final b = provider.beauticians[index];
                        return _buildBeauticianRow(
                          context,
                          screenWidth,
                          screenHeight,
                          b,
                          provider,
                        );
                      },
                    ),
            ),

            // BOTTOM CONFIRM BAR
            if (isBookingMode)
              _buildBottomBar(context, screenWidth, screenHeight, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildBeauticianRow(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> b,
    BeauticiansProvider provider,
  ) {
    final selected = provider.isSelected(b['id']);

    return GestureDetector(
      onTap: () {
        if (isBookingMode) {
          provider.selectBeautician(b);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BeauticianDetailsScreen(beauticianData: b),
            ),
          );
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: screenWidth * 0.08,
              backgroundColor: AppColors.inputBg(context),
              backgroundImage: AssetImage(
                b['image'] ?? 'assets/images/beautician.png',
              ),
              onBackgroundImageError: (_, _) {},
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    b['name'] ?? 'Beautician Name',
                    style: TextStyle(
                      fontSize: screenWidth * 0.042,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.003),
                  Text(
                    b['role'] ?? 'Specialist',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: screenWidth * 0.04,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        '${b['rating'] ?? 0.0}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        '(${b['reviews'] ?? 0})',
                        style: TextStyle(
                          fontSize: screenWidth * 0.032,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Trailing: radio (booking) or favorite heart (browse)
            if (isBookingMode)
              Container(
                width: screenWidth * 0.06,
                height: screenWidth * 0.06,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.primaryPink : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? AppColors.primaryPink
                        : AppColors.divider(context),
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: screenWidth * 0.04,
                      )
                    : null,
              )
            else
              GestureDetector(
                onTap: () => provider.toggleFavorite(b['id']),
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  child: Icon(
                    b['isFavorite'] == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: b['isFavorite'] == true
                        ? AppColors.primaryPink
                        : AppColors.textSecondary(context),
                    size: screenWidth * 0.06,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    BeauticiansProvider provider,
  ) {
    final selected = provider.selectedBeautician;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.015,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selected == null
                      ? context.tr('no_selection')
                      : context.tr('selected_label'),
                  style: TextStyle(
                    fontSize: screenWidth * 0.032,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                SizedBox(height: screenHeight * 0.003),
                Text(
                  selected == null
                      ? context.tr('choose_beautician')
                      : '${selected['name']}  •  ${selected['role']}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.038,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: screenWidth * 0.35,
            child: CustomButton(
              text: context.tr('confirm_label'),
              isLoading: false,
              onTap: () {
                if (selected == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr('select_beautician_error')),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                final updatedBooking = {
                  ...?bookingData,
                  'beautician': selected,
                };

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SelectDateScreen(bookingData: updatedBooking),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
