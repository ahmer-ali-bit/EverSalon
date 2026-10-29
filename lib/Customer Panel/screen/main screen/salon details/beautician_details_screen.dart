import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/salon%20details%20providers/beautician_details_provider.dart';

/// S28 - Beautician Details Screen (Browse Only — No Book Button)
class BeauticianDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> beauticianData;
  final Map<String, dynamic>? salonData;

  const BeauticianDetailsScreen({
    super.key,
    required this.beauticianData,
    this.salonData,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BeauticianDetailsProvider()..initData(beauticianData),
      child: const _BeauticianDetailsView(),
    );
  }
}

class _BeauticianDetailsView extends StatelessWidget {
  const _BeauticianDetailsView();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final provider = Provider.of<BeauticianDetailsProvider>(context);
    final data = provider.beauticianData;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // STANDARD TOP HEADER
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.015,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        data['name'] ?? context.tr('details'),
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => provider.shareBeautician(),
                    child: Container(
                      width: screenWidth * 0.1,
                      height: screenWidth * 0.1,
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.share_outlined,
                        color: AppColors.textPrimary(context),
                        size: screenWidth * 0.05,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // SCROLLABLE CONTENT
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Beautician Image
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.04,
                              ),
                              child: Container(
                                height: screenHeight * 0.35,
                                width: double.infinity,
                                color: AppColors.inputBg(context),
                                child: Image.asset(
                                  data['image'] ??
                                      'assets/images/beautician.png',
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      color: AppColors.textSecondary(context),
                                      size: screenWidth * 0.2,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // 2. Name & Role
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['name'] ?? 'Beautician Name',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                Text(
                                  data['role'] ?? 'Specialist',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryPink,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.015),

                          // 3. Rating & Experience Row
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: screenWidth * 0.05,
                                ),
                                SizedBox(width: screenWidth * 0.01),
                                Text(
                                  '${data['rating'] ?? 0.0} (${data['reviews'] ?? 0} ${context.tr('reviews')})',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.04),
                                Icon(
                                  Icons.verified,
                                  color: AppColors.success,
                                  size: screenWidth * 0.05,
                                ),
                                SizedBox(width: screenWidth * 0.01),
                                Text(
                                  data['experience'] ?? '',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Divider(
                            color: AppColors.divider(context),
                            thickness: 1,
                            height: screenHeight * 0.03,
                            indent: screenWidth * 0.04,
                            endIndent: screenWidth * 0.04,
                          ),

                          // 4. Specializations
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr('specializations'),
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.042,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.015),
                                _buildSpecializations(
                                  context,
                                  screenWidth,
                                  screenHeight,
                                  data,
                                ),
                              ],
                            ),
                          ),

                          Divider(
                            color: AppColors.divider(context),
                            thickness: 1,
                            height: screenHeight * 0.03,
                            indent: screenWidth * 0.04,
                            endIndent: screenWidth * 0.04,
                          ),

                          // 5. About Section
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr('about'),
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.042,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Text(
                                  data['about'] ?? '',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: AppColors.textSecondary(context),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecializations(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> data,
  ) {
    final specs = (data['specializations'] as List<dynamic>?) ?? [];

    if (specs.isEmpty) {
      return Text(
        context.tr('no_specializations'),
        style: TextStyle(
          fontSize: screenWidth * 0.035,
          color: AppColors.textSecondary(context),
        ),
      );
    }

    return Wrap(
      spacing: screenWidth * 0.02,
      runSpacing: screenHeight * 0.01,
      children: specs.map((spec) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.035,
            vertical: screenHeight * 0.008,
          ),
          decoration: BoxDecoration(
            color: AppColors.inputBg(context),
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
            border: Border.all(color: AppColors.divider(context), width: 1),
          ),
          child: Text(
            spec.toString(),
            style: TextStyle(
              fontSize: screenWidth * 0.032,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary(context),
            ),
          ),
        );
      }).toList(),
    );
  }
}
