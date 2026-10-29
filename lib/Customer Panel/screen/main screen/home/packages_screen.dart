import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/salon%20details%20providers/packages_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/salon%20details/beauticians_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/package_details_screen.dart';
import 'package:ever_salon/widgets/custom_button.dart';

/// S25 - Packages Screen
/// - isBookingMode = false → Browse (tap → Package Details with salon, skip All Salons)
/// - isBookingMode = true  → Single-select + confirm → Beauticians
class PackagesScreen extends StatelessWidget {
  final Map<String, dynamic> salonData;
  final bool isBookingMode;
  final Map<String, dynamic>? bookingData;

  const PackagesScreen({
    super.key,
    required this.salonData,
    this.isBookingMode = false,
    this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          PackagesProvider()..fetchPackages(salonData['id']?.toString() ?? '1'),
      child: _PackagesView(
        salonData: salonData,
        isBookingMode: isBookingMode,
        bookingData: bookingData,
      ),
    );
  }
}

class _PackagesView extends StatelessWidget {
  final Map<String, dynamic> salonData;
  final bool isBookingMode;
  final Map<String, dynamic>? bookingData;

  const _PackagesView({
    required this.salonData,
    required this.isBookingMode,
    this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final provider = Provider.of<PackagesProvider>(context);

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
                    child: Center(
                      child: Text(
                        isBookingMode
                            ? context.tr('select_package')
                            : context.tr('our_packages'),
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.1),
                ],
              ),
            ),

            // Skip (booking mode only)
            if (isBookingMode)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => _goToBeauticians(context, null),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.005,
                      ),
                      child: Text(
                        context.tr('skip_arrow'),
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryPink,
                        ),
                      ),
                    ),
                  ),
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
                      itemCount: provider.packages.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: screenHeight * 0.02),
                      itemBuilder: (context, index) {
                        final pkg = provider.packages[index];
                        return _buildPackageCard(
                          context,
                          screenWidth,
                          screenHeight,
                          pkg,
                          provider,
                        );
                      },
                    ),
            ),

            if (isBookingMode)
              _buildBottomBar(context, screenWidth, screenHeight, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> pkg,
    PackagesProvider provider,
  ) {
    final includes = (pkg['includes'] as List<dynamic>?) ?? [];
    final selected = provider.isSelected(pkg['id']);

    return GestureDetector(
      onTap: () {
        if (isBookingMode) {
          // Booking flow: select on this screen
          provider.selectPackage(pkg);
        } else {
          // ✅ BROWSE (See All from Salon Details):
          // Package Details + salon → Book pe All Salons NAHI, seedha Beauticians
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PackageDetailsScreen(
                packageData: pkg,
                salonData: salonData,
                skipSalonSelection: true,
              ),
            ),
          );
        }
      },
      child: Container(
        height: screenHeight * 0.22,
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          border: Border.all(
            color: selected
                ? AppColors.primaryPink
                : AppColors.divider(context),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.035),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pkg['name'] ?? 'Package Name',
                          style: TextStyle(
                            fontSize: screenWidth * 0.042,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          '${context.tr('rs')} ${pkg['price'] ?? 0}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryPink,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Expanded(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: includes.length > 4
                                ? 4
                                : includes.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: screenHeight * 0.005,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: AppColors.textPrimary(context),
                                      size: screenWidth * 0.035,
                                    ),
                                    SizedBox(width: screenWidth * 0.015),
                                    Expanded(
                                      child: Text(
                                        includes[index].toString(),
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.03,
                                          color: AppColors.textSecondary(
                                            context,
                                          ),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(screenWidth * 0.04),
                      bottomRight: Radius.circular(screenWidth * 0.04),
                    ),
                    child: Container(
                      height: double.infinity,
                      color: AppColors.inputBg(context),
                      child: Image.asset(
                        pkg['image'] ?? 'assets/images/bridal.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.image_outlined,
                              color: AppColors.textSecondary(context),
                              size: screenWidth * 0.08,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (isBookingMode && selected)
              Positioned(
                top: screenWidth * 0.025,
                right: screenWidth * 0.025,
                child: Container(
                  width: screenWidth * 0.07,
                  height: screenWidth * 0.07,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryPink,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: screenWidth * 0.045,
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
    PackagesProvider provider,
  ) {
    final selected = provider.selectedPackage;

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
                      ? context.tr('no_package_selected')
                      : context.tr('selected_label'),
                  style: TextStyle(
                    fontSize: screenWidth * 0.032,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                SizedBox(height: screenHeight * 0.003),
                Text(
                  selected == null
                      ? context.tr('optional_skip')
                      : '${selected['name']}  •  ${context.tr('rs')} ${selected['price']}',
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
              onTap: () => _goToBeauticians(context, selected),
            ),
          ),
        ],
      ),
    );
  }

  void _goToBeauticians(BuildContext context, Map<String, dynamic>? selected) {
    final updatedBooking = {
      ...?bookingData,
      'flowType': 'package',
      'package': selected,
      'packagePrice': selected?['price'] ?? 0,
      'salon': salonData,
      'salonData': salonData,
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
  }
}
