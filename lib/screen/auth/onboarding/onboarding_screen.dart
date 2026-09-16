import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/provider/auth%20providers/onboarding%20provider/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // Onboarding Content Data
  static final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/onboarding_1.png',
      'titleKey': 'onboard_discover_title',
      'descKey': 'onboard_discover_desc',
    },
    {
      'image': 'assets/images/onboarding_2.png',
      'titleKey': 'onboard_booking_title',
      'descKey': 'onboard_booking_desc',
    },
    {
      'image': 'assets/images/onboarding_3.png',
      'titleKey': 'onboard_offers_title',
      'descKey': 'onboard_offers_desc',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg(context),
        body: SafeArea(
          child: Consumer<OnboardingProvider>(
            builder: (context, provider, _) {
              return Column(
                children: [
                  // Skip Button (Top Right)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.01,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => provider.skip(context, '/login'),
                        child: Text(
                          context.tr('skip'),
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: AppColors.textSecondary(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // PageView for Onboarding Content
                  Expanded(
                    child: PageView.builder(
                      controller: provider.pageController,
                      itemCount: _pages.length,
                      onPageChanged: provider.updatePage,
                      itemBuilder: (context, index) {
                        return _buildPage(
                          context: context,
                          image: _pages[index]['image']!,
                          title: context.tr(_pages[index]['titleKey']!),
                          desc: context.tr(_pages[index]['descKey']!),
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        );
                      },
                    ),
                  ),

                  // Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildDot(
                        context: context,
                        isActive: provider.currentPage == index,
                        screenWidth: screenWidth,
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Next / Get Started Button
                  GestureDetector(
                    onTap: () => provider.nextPage(context, '/login'),
                    child: Container(
                      width: screenWidth * 0.14,
                      height: screenHeight * 0.065,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPink.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          provider.currentPage == _pages.length - 1
                              ? Icons.check
                              : Icons.arrow_forward,
                          color: Colors.white,
                          size: screenWidth * 0.06,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Single Page Layout
  Widget _buildPage({
    required BuildContext context,
    required String image,
    required String title,
    required String desc,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Onboarding Image
          Image.asset(image, height: screenHeight * 0.4, fit: BoxFit.contain),

          SizedBox(height: screenHeight * 0.05),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.065,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),

          SizedBox(height: screenHeight * 0.02),

          // Description
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              color: AppColors.textSecondary(context),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Dots Widget
  Widget _buildDot({
    required BuildContext context,
    required bool isActive,
    required double screenWidth,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.012),
      width: isActive ? screenWidth * 0.06 : screenWidth * 0.025,
      height: screenWidth * 0.025,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryPink : AppColors.divider(context),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
