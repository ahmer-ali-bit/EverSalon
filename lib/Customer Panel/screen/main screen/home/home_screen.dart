import 'package:ever_salon/Customer%20Panel/provider/customer%20home%20providers/home_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/all_salons_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/categories_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/featured_salons_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/filters_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/nearby_salons_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/notifications_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/offers_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/salon%20details/salon_details_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/packages_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/package_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_textfield.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onSwitchToExplore;

  const HomeScreen({super.key, this.onSwitchToExplore});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider()..fetchHomeData(),
      child: _HomeScreenView(onSwitchToExplore: onSwitchToExplore),
    );
  }
}

class _HomeScreenView extends StatefulWidget {
  final VoidCallback? onSwitchToExplore;

  const _HomeScreenView({this.onSwitchToExplore});

  @override
  State<_HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<_HomeScreenView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryPink),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr('good_morning'),
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                color: AppColors.textPrimary(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${provider.userName}! ",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    color: AppColors.primaryPink,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "👋",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.005),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const NearbySalonsScreen(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: AppColors.primaryPink,
                                    size: screenWidth * 0.035,
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  Text(
                                    "Bahawalpur, Pakistan",
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.032,
                                      color: AppColors.textSecondary(context),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationsScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(screenWidth * 0.025),
                            decoration: BoxDecoration(
                              color: AppColors.inputBg(context),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.notifications_outlined,
                              color: AppColors.textPrimary(context),
                              size: screenWidth * 0.06,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.025),

                    // --- SEARCH BAR ---
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              widget.onSwitchToExplore?.call();
                            },
                            child: AbsorbPointer(
                              child: CustomTextField(
                                hint: context.tr('search_hint'),
                                prefixIcon: Icons.search,
                                controller: _searchController,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Container(
                          height: screenHeight * 0.065,
                          width: screenHeight * 0.065,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.tune, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const FiltersScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.025),

                    // --- PROMO BANNER ---
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OffersScreen(),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          height: screenHeight * 0.18,
                          width: double.infinity,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  provider.promoBanner['image'],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFFFCE4EC),
                                    );
                                  },
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.white.withValues(alpha: 0.85),
                                        Colors.white.withValues(alpha: 0.4),
                                        Colors.transparent,
                                      ],
                                      stops: const [0.0, 0.45, 0.7],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05,
                                  vertical: screenHeight * 0.02,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      provider.promoBanner['title'],
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary(context),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      provider.promoBanner['subtitle'],
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.032,
                                        color: AppColors.textSecondary(context),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.015),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.04,
                                        vertical: screenHeight * 0.008,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: AppColors.primaryGradient,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primaryPink
                                                .withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        "${provider.promoBanner['buttonText']}  →",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.032,
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
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // --- CATEGORIES HEADER ---
                    _buildSectionHeader(
                      title: context.tr('categories'),
                      screenWidth: screenWidth,
                      onSeeAll: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CategoriesScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // --- CATEGORIES LIST ---
                    SizedBox(
                      height: screenHeight * 0.13,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.categories.length,
                        itemBuilder: (context, index) {
                          final category = provider.categories[index];
                          return Padding(
                            padding: EdgeInsets.only(right: screenWidth * 0.04),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AllSalonsScreen(),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: screenWidth * 0.16,
                                    width: screenWidth * 0.16,
                                    padding: EdgeInsets.all(screenWidth * 0.03),
                                    decoration: BoxDecoration(
                                      color: category['bgColor'],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Image.asset(
                                      category['image'],
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.category,
                                              color: AppColors.primaryPink,
                                            );
                                          },
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    category['name'],
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.032,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),

                    // ==========================================
                    // --- PACKAGES SECTION (NEWLY ADDED) ---
                    // ==========================================
                    _buildSectionHeader(
                      title: context.tr('our_packages') ?? 'Top Packages',
                      screenWidth: screenWidth,
                      onSeeAll: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PackagesScreen(
                              salonData: const {'id': 'all'}, // Global packages
                              isBookingMode: false,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.012),

                    SizedBox(
                      height: screenHeight * 0.22,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            provider.packages.length, // From HomeProvider
                        separatorBuilder: (context, index) =>
                            SizedBox(width: screenWidth * 0.03),
                        itemBuilder: (context, index) {
                          final pkg = provider.packages[index];
                          return _buildHomePackageCard(
                            context,
                            screenWidth,
                            screenHeight,
                            pkg,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),

                    // --- FEATURED SALONS HEADER ---
                    _buildSectionHeader(
                      title: context.tr('featured_salons'),
                      screenWidth: screenWidth,
                      onSeeAll: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FeaturedSalonsScreen(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // --- FEATURED SALONS LIST ---
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.featuredSalons.length,
                      itemBuilder: (context, index) {
                        final salon = provider.featuredSalons[index];
                        return _buildSalonCard(
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
                  ],
                ),
              ),
      ),
    );
  }

  // --- SECTION HEADER WIDGET ---
  Widget _buildSectionHeader({
    required String title,
    required double screenWidth,
    required VoidCallback onSeeAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text(
            context.tr('see_all'),
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryPink,
            ),
          ),
        ),
      ],
    );
  }

  // --- HOME PACKAGE CARD ---
  Widget _buildHomePackageCard(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> pkg,
  ) {
    final includes = (pkg['includes'] as List<dynamic>?) ?? [];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PackageDetailsScreen(packageData: pkg),
          ),
        );
      },
      child: Container(
        width: screenWidth * 0.6,
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(screenWidth * 0.035),
          border: Border.all(color: AppColors.divider(context), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pkg['name'] ?? 'Package',
              style: TextStyle(
                fontSize: screenWidth * 0.038,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            SizedBox(height: screenHeight * 0.004),
            Text(
              '${context.tr('rs')} ${pkg['price'] ?? 0}',
              style: TextStyle(
                fontSize: screenWidth * 0.038,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPink,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: includes.length > 4 ? 4 : includes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.003),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.primaryPink,
                          size: screenWidth * 0.035,
                        ),
                        SizedBox(width: screenWidth * 0.015),
                        Expanded(
                          child: Text(
                            includes[index].toString(),
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: AppColors.textSecondary(context),
                            ),
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
    );
  }

  // --- SALON CARD WIDGET ---
  Widget _buildSalonCard({
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          size: screenWidth * 0.055,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.008),
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
                  SizedBox(height: screenHeight * 0.005),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
