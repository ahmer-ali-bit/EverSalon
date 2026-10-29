import 'package:ever_salon/Customer%20Panel/provider/customer%20home%20providers/featured_salons_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/salon%20details/salon_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_button.dart';

class FeaturedSalonsScreen extends StatelessWidget {
  const FeaturedSalonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FeaturedSalonsProvider()..fetchFeaturedSalons(),
      child: const _FeaturedSalonsView(),
    );
  }
}

class _FeaturedSalonsView extends StatelessWidget {
  const _FeaturedSalonsView();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeaturedSalonsProvider>(context);
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
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Text(
                      context.tr('featured_salons'),
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

            // --- CONTENT ---
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- HERO CARD ---
                          _buildHeroCard(
                            context: context,
                            salon: provider.heroSalon,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            onFavoriteTap: () => provider.toggleHeroFavorite(),
                            onBookTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SalonDetailsScreen(
                                    salonData: provider.heroSalon,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.025),

                          // --- GRID SALONS ---
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: screenWidth * 0.03,
                                  mainAxisSpacing: screenHeight * 0.02,
                                  childAspectRatio: 0.8,
                                ),
                            itemCount: provider.gridSalons.length,
                            itemBuilder: (context, index) {
                              final salon = provider.gridSalons[index];
                              return _buildGridCard(
                                context: context,
                                salon: salon,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                                onFavoriteTap: () =>
                                    provider.toggleGridFavorite(index),
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
                          SizedBox(height: screenHeight * 0.02),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HERO CARD WIDGET ---
  Widget _buildHeroCard({
    required BuildContext context,
    required Map<String, dynamic> salon,
    required double screenWidth,
    required double screenHeight,
    required VoidCallback onFavoriteTap,
    required VoidCallback onBookTap,
  }) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.inputBg(context),
        image: DecorationImage(
          image: AssetImage(salon['image']),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ),

          // Favorite Icon
          Positioned(
            top: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: GestureDetector(
              onTap: onFavoriteTap,
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                decoration: BoxDecoration(
                  color: AppColors.cardBg(context).withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  salon['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                  color: salon['isFavorite']
                      ? AppColors.primaryPink
                      : AppColors.textSecondary(context),
                  size: screenWidth * 0.05,
                ),
              ),
            ),
          ),

          // Details & Book Button
          Positioned(
            bottom: screenWidth * 0.04,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  salon['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: screenWidth * 0.045,
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    Text(
                      "${salon['rating']} (${salon['reviews']})",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.015),
                SizedBox(
                  width: screenWidth * 0.35,
                  height: screenHeight * 0.045,
                  child: CustomButton(
                    text: context.tr('book_now'),
                    isLoading: false,
                    onTap: onBookTap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- GRID CARD WIDGET ---
  Widget _buildGridCard({
    required BuildContext context,
    required Map<String, dynamic> salon,
    required double screenWidth,
    required double screenHeight,
    required VoidCallback onFavoriteTap,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.inputBg(context),
                image: DecorationImage(
                  image: AssetImage(salon['image']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: screenWidth * 0.02,
                    right: screenWidth * 0.02,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.015),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg(
                            context,
                          ).withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          salon['isFavorite']
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: salon['isFavorite']
                              ? AppColors.primaryPink
                              : AppColors.textSecondary(context),
                          size: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            salon['name'],
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: screenHeight * 0.003),
          Row(
            children: [
              Icon(Icons.star, color: Colors.orange, size: screenWidth * 0.035),
              SizedBox(width: screenWidth * 0.01),
              Text(
                "${salon['rating']} (${salon['reviews']})",
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
