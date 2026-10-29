import 'package:ever_salon/Customer%20Panel/screen/main%20screen/salon%20details/beauticians_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/salon%20details%20providers/services_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/salon%20details/service_details_screen.dart';
import 'package:ever_salon/widgets/custom_button.dart';

/// S23 - Services Screen
/// - isBookingMode = false → Browse only (tap opens details)
/// - isBookingMode = true  → Multi-select with confirm bar (Booking flow)
class ServicesScreen extends StatelessWidget {
  final Map<String, dynamic> salonData;
  final bool isBookingMode;
  final Map<String, dynamic>? bookingData;

  const ServicesScreen({
    super.key,
    required this.salonData,
    this.isBookingMode = false,
    this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ServicesProvider()..fetchServices(salonData['id']?.toString() ?? '1'),
      child: _ServicesView(
        salonData: salonData,
        isBookingMode: isBookingMode,
        bookingData: bookingData,
      ),
    );
  }
}

class _ServicesView extends StatelessWidget {
  final Map<String, dynamic> salonData;
  final bool isBookingMode;
  final Map<String, dynamic>? bookingData;

  const _ServicesView({
    required this.salonData,
    required this.isBookingMode,
    this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final provider = Provider.of<ServicesProvider>(context);

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
                          ? context.tr('select_services')
                          : context.tr('our_services'),
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

            // SERVICES LIST
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
                      itemCount: provider.services.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: screenHeight * 0.015),
                      itemBuilder: (context, index) {
                        final service = provider.services[index];
                        return _buildServiceCard(
                          context,
                          screenWidth,
                          screenHeight,
                          service,
                          provider,
                        );
                      },
                    ),
            ),

            // BOTTOM CONFIRM BAR (booking mode only)
            if (isBookingMode)
              _buildBottomBar(context, screenWidth, screenHeight, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> service,
    ServicesProvider provider,
  ) {
    final selected = provider.isSelected(service['id']);

    return GestureDetector(
      onTap: () {
        if (isBookingMode) {
          provider.toggleSelection(service);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ServiceDetailsScreen(serviceData: service),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.035,
          vertical: screenHeight * 0.015,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(screenWidth * 0.035),
          border: Border.all(
            color: selected
                ? AppColors.primaryPink
                : AppColors.divider(context),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.13,
              height: screenWidth * 0.13,
              padding: EdgeInsets.all(screenWidth * 0.025),
              decoration: BoxDecoration(
                color: Color(service['bgColor'] ?? 0xFFF8F8FA),
                borderRadius: BorderRadius.circular(screenWidth * 0.025),
              ),
              child: Image.asset(
                service['image'] ?? 'assets/images/hairs.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.spa,
                    color: AppColors.textSecondary(context),
                    size: screenWidth * 0.05,
                  );
                },
              ),
            ),
            SizedBox(width: screenWidth * 0.035),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['name'] ?? 'Service Name',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.004),
                  Text(
                    '${context.tr('from_rs')} ${service['price'] ?? 0}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            // Trailing widget: radio (booking) or arrow (browse)
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
              Icon(
                Icons.arrow_forward_ios,
                size: screenWidth * 0.045,
                color: AppColors.textSecondary(context),
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
    ServicesProvider provider,
  ) {
    final count = provider.selectedServices.length;

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
                  '$count Item${count == 1 ? '' : 's'} ${context.tr('selected_label')}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.032,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                SizedBox(height: screenHeight * 0.003),
                Text(
                  '${context.tr('rs')} ${provider.totalPrice}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: screenWidth * 0.4,
            child: CustomButton(
              text: context.tr('confirm_label'),
              isLoading: false,
              onTap: () {
                if (count == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr('select_at_least_one')),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  return;
                }

                final updatedBooking = {
                  ...?bookingData,
                  'salon': salonData,
                  'services': provider.selectedServices,
                  'servicesTotal': provider.totalPrice,
                };

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BeauticiansScreen(
                      salonData: salonData,
                      isBookingMode: true,
                      bookingData: updatedBooking,
                    ),
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
