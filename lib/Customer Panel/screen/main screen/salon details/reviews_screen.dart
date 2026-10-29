import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/salon%20details%20providers/reviews_provider.dart';

/// S29 - Reviews Screen
class ReviewsScreen extends StatelessWidget {
  final Map<String, dynamic> salonData;

  const ReviewsScreen({super.key, required this.salonData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ReviewsProvider()..fetchReviews(salonData['id']?.toString() ?? '1'),
      child: const _ReviewsView(),
    );
  }
}

class _ReviewsView extends StatelessWidget {
  const _ReviewsView();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final provider = Provider.of<ReviewsProvider>(context);

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
                  SizedBox(width: screenWidth * 0.03),

                  Center(
                    child: Text(
                      context.tr('reviews_ratings'),
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.1), // Balance alignment
                ],
              ),
            ),

            // ========================
            // SCROLLABLE CONTENT
            // ========================
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: screenHeight * 0.1,
                        left: screenWidth * 0.04,
                        right: screenWidth * 0.04,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Overall Rating Section (4.8 + Stars)
                          SizedBox(height: screenHeight * 0.02),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${provider.overallRating}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                  height:
                                      1.0, // Removes extra top/bottom spacing of large font
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.04),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: screenHeight * 0.008,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: List.generate(5, (index) {
                                        return Icon(
                                          index < provider.overallRating.floor()
                                              ? Icons.star
                                              : (index < provider.overallRating
                                                    ? Icons.star_half
                                                    : Icons.star_border),
                                          color: Colors.amber,
                                          size: screenWidth * 0.045,
                                        );
                                      }),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      '(${provider.totalReviews} ${context.tr('reviews')})',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        color: AppColors.textSecondary(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // 2. Rating Breakdown Bars
                          _buildRatingBreakdown(
                            context,
                            screenWidth,
                            screenHeight,
                            provider,
                          ),

                          SizedBox(height: screenHeight * 0.03),
                          Divider(
                            color: AppColors.divider(context),
                            thickness: 1,
                            height: 1,
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // 3. User Reviews List
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.reviews.length,
                            separatorBuilder: (context, index) => Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                              ),
                              child: Divider(
                                color: AppColors.divider(context),
                                thickness: 1,
                                height: 1,
                              ),
                            ),
                            itemBuilder: (context, index) {
                              final review = provider.reviews[index];
                              return _buildReviewItem(
                                context,
                                screenWidth,
                                screenHeight,
                                review,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ),

            // ========================
            // WRITE A REVIEW BUTTON (Bottom Fixed)
            // ========================
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
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
              child: GestureDetector(
                onTap: () {
                  // ==========================================
                  // TODO: NAVIGATE TO WRITE REVIEW SCREEN (S67)
                  // ==========================================
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      color: AppColors.primaryPink,
                      size: screenWidth * 0.045,
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      context.tr('write_review'),
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPink,
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

  // ========================
  // RATING BREAKDOWN (Progress Bars)
  // ========================
  Widget _buildRatingBreakdown(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    ReviewsProvider provider,
  ) {
    return Column(
      children: [5, 4, 3, 2, 1].map((star) {
        final count = provider.ratingBreakdown[star] ?? 0;
        final percentage = count / provider.totalReviews;

        return Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.01),
          child: Row(
            children: [
              // Star Number
              SizedBox(
                width: screenWidth * 0.04,
                child: Text(
                  '$star',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
              Icon(Icons.star, color: Colors.amber, size: screenWidth * 0.035),
              SizedBox(width: screenWidth * 0.03),

              // Progress Bar Track
              Expanded(
                child: Stack(
                  children: [
                    // Empty Track
                    Container(
                      height: screenHeight * 0.008,
                      decoration: BoxDecoration(
                        color: AppColors.divider(context),
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                    ),
                    // Filled Track
                    FractionallySizedBox(
                      widthFactor: percentage,
                      child: Container(
                        height: screenHeight * 0.008,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPink,
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.02,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: screenWidth * 0.03),

              // Count Text
              SizedBox(
                width: screenWidth * 0.08, // Fixed width for alignment
                child: Text(
                  '$count',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ========================
  // INDIVIDUAL REVIEW ITEM
  // ========================
  Widget _buildReviewItem(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> review,
  ) {
    final images = (review['images'] as List<dynamic>?) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: Avatar + Name + Rating + Date
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: screenWidth * 0.05,
              backgroundColor: AppColors.inputBg(context),
              backgroundImage: AssetImage(review['userImage'] ?? ''),
              onBackgroundImageError: (e, s) {},
            ),
            SizedBox(width: screenWidth * 0.03),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review['userName'] ?? 'User Name',
                    style: TextStyle(
                      fontSize: screenWidth * 0.038,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Row(
                    children: List.generate(5, (index) {
                      final rating = (review['rating'] ?? 0.0) as double;
                      return Icon(
                        index < rating.floor() ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: screenWidth * 0.035,
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Date
            Text(
              review['date'] ?? '',
              style: TextStyle(
                fontSize: screenWidth * 0.03,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),

        SizedBox(height: screenHeight * 0.015),

        // Review Comment
        Text(
          review['comment'] ?? '',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            color: AppColors.textPrimary(context),
            height: 1.4,
          ),
        ),

        // Attached Images
        if (images.isNotEmpty) ...[
          SizedBox(height: screenHeight * 0.015),
          SizedBox(
            height: screenWidth * 0.15,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (context, index) =>
                  SizedBox(width: screenWidth * 0.02),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  child: Container(
                    width: screenWidth * 0.18,
                    color: AppColors.inputBg(context),
                    child: Image.asset(
                      images[index].toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image,
                            color: AppColors.textSecondary(context),
                            size: screenWidth * 0.05,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
