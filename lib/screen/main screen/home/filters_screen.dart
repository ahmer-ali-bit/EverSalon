import 'package:ever_salon/provider/customer%20home%20providers/filters_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_button.dart';

class FiltersScreen extends StatelessWidget {
  const FiltersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FiltersProvider(),
      child: const _FiltersView(),
    );
  }
}

class _FiltersView extends StatelessWidget {
  const _FiltersView();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FiltersProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: EdgeInsets.all(padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Text(
                    context.tr('filters'),
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => provider.resetFilters(),
                    child: Text(
                      context.tr('reset'),
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error, // Red matching UI
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- FILTER SECTIONS ---
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.01),

                    // --- SORT BY ---
                    _buildSectionTitle(context, context.tr('sort_by'), screenWidth),
                    SizedBox(height: screenHeight * 0.01),
                    ...provider.sortOptions.map((option) {
                      final bool isSelected = provider.selectedSort == option;
                      return GestureDetector(
                        onTap: () => provider.setSort(option),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                          ),
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: isSelected
                                    ? AppColors.primaryPink
                                    : AppColors.textSecondary(context),
                                size: screenWidth * 0.055,
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Text(
                                option,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.038,
                                  color: AppColors.textPrimary(context),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: screenHeight * 0.03),

                    // --- DISTANCE SLIDER ---
                    _buildSectionTitle(context, context.tr('distance'), screenWidth),
                    SizedBox(height: screenHeight * 0.02),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: AppColors.primaryPink,
                        inactiveTrackColor: AppColors.divider(context),
                        thumbColor: AppColors.cardBg(context),
                        overlayColor: AppColors.primaryPink.withValues(
                          alpha: 0.2,
                        ),
                        trackHeight: 4.0,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: screenWidth * 0.03,
                        ),
                        // Custom shadow for thumb
                      ),
                      child: Slider(
                        value: provider.distance,
                        min: 0,
                        max: 20,
                        divisions: 20,
                        onChanged: (val) => provider.setDistance(val),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("0 ${context.tr('km')}", style: _sliderTextStyle(context, screenWidth)),
                          Text(
                            "${provider.distance.toInt()} ${context.tr('km')}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: AppColors.primaryPink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("20 ${context.tr('km')}", style: _sliderTextStyle(context, screenWidth)),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // --- PRICE RANGE ---
                    _buildSectionTitle(context, context.tr('price_range'), screenWidth),
                    SizedBox(height: screenHeight * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: provider.priceOptions.map((price) {
                        return Expanded(
                          child: _buildChip(
                            context: context,
                            label: price,
                            isSelected: provider.selectedPrice == price,
                            onTap: () => provider.setPrice(price),
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // --- RATING ---
                    _buildSectionTitle(context, context.tr('rating'), screenWidth),
                    SizedBox(height: screenHeight * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: provider.ratingOptions.map((rating) {
                        return Expanded(
                          child: _buildChip(
                            context: context,
                            label: rating,
                            isSelected: provider.selectedRating == rating,
                            onTap: () => provider.setRating(rating),
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            isRating: true,
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(
                      height: screenHeight * 0.1,
                    ), // Spacing for bottom button
                  ],
                ),
              ),
            ),

            // --- BOTTOM APPLY BUTTON ---
            Padding(
              padding: EdgeInsets.all(padding),
              child: CustomButton(
                text: context.tr('apply_filters'),
                isLoading: false,
                onTap: () => provider.applyFilters(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildSectionTitle(BuildContext context, String title, double screenWidth) {
    return Text(
      title,
      style: TextStyle(
        fontSize: screenWidth * 0.042,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary(context),
      ),
    );
  }

  TextStyle _sliderTextStyle(BuildContext context, double screenWidth) {
    return TextStyle(
      fontSize: screenWidth * 0.03,
      color: AppColors.textSecondary(context),
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required double screenWidth,
    required double screenHeight,
    bool isRating = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.divider(context),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.03,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : AppColors
                      .textSecondary(context), // For rating stars, we included ★ in string itself
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
