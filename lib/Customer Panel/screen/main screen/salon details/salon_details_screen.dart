import 'package:ever_salon/Customer%20Panel/provider/salon%20details%20providers/salon_details_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/salon%20details/beautician_details_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/salon%20details/beauticians_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/package_details_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/packages_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/salon%20details/reviews_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/salon%20details/salon_location_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/salon%20details/service_details_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/salon%20details/services_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_button.dart';

/// S21 - Salon Details Screen
class SalonDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> salonData;

  const SalonDetailsScreen({super.key, required this.salonData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SalonDetailsProvider()..initializeSalonData(salonData),
      child: const _SalonDetailsView(),
    );
  }
}

class _SalonDetailsView extends StatefulWidget {
  const _SalonDetailsView();

  @override
  State<_SalonDetailsView> createState() => _SalonDetailsViewState();
}

class _SalonDetailsViewState extends State<_SalonDetailsView> {
  late ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final double threshold = MediaQuery.of(context).size.height * 0.25;
    if (_scrollController.offset > threshold && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= threshold && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final provider = Provider.of<SalonDetailsProvider>(context);
    final salon = provider.salonData;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryPink),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderImage(
                        context,
                        screenWidth,
                        screenHeight,
                        salon,
                      ),
                      _buildSalonInfoCard(
                        context,
                        screenWidth,
                        screenHeight,
                        salon,
                      ),
                      _buildActionRow(
                        context,
                        screenWidth,
                        screenHeight,
                        provider,
                      ),
                      Divider(
                        color: AppColors.divider(context),
                        thickness: 1,
                        height: screenHeight * 0.03,
                        indent: screenWidth * 0.04,
                        endIndent: screenWidth * 0.04,
                      ),
                      _buildOpeningHours(
                        context,
                        screenWidth,
                        screenHeight,
                        salon,
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Divider(
                        color: AppColors.divider(context),
                        thickness: 1,
                        height: screenHeight * 0.01,
                        indent: screenWidth * 0.04,
                        endIndent: screenWidth * 0.04,
                      ),
                      _buildAboutSection(
                        context,
                        screenWidth,
                        screenHeight,
                        provider,
                        salon,
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Divider(
                        color: AppColors.divider(context),
                        thickness: 1,
                        height: screenHeight * 0.01,
                        indent: screenWidth * 0.04,
                        endIndent: screenWidth * 0.04,
                      ),
                      _buildGalleryPreview(
                        context,
                        screenWidth,
                        screenHeight,
                        provider,
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Divider(
                        color: AppColors.divider(context),
                        thickness: 1,
                        height: screenHeight * 0.01,
                        indent: screenWidth * 0.04,
                        endIndent: screenWidth * 0.04,
                      ),
                      _buildServicesPreview(
                        context,
                        screenWidth,
                        screenHeight,
                        provider,
                        salon,
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Divider(
                        color: AppColors.divider(context),
                        thickness: 1,
                        height: screenHeight * 0.01,
                        indent: screenWidth * 0.04,
                        endIndent: screenWidth * 0.04,
                      ),
                      _buildPackagesPreview(
                        context,
                        screenWidth,
                        screenHeight,
                        provider,
                        salon,
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Divider(
                        color: AppColors.divider(context),
                        thickness: 1,
                        height: screenHeight * 0.01,
                        indent: screenWidth * 0.04,
                        endIndent: screenWidth * 0.04,
                      ),
                      _buildBeauticiansPreview(
                        context,
                        screenWidth,
                        screenHeight,
                        provider,
                        salon,
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Divider(
                        color: AppColors.divider(context),
                        thickness: 1,
                        height: screenHeight * 0.01,
                        indent: screenWidth * 0.04,
                        endIndent: screenWidth * 0.04,
                      ),
                      _buildReviewsPreview(
                        context,
                        screenWidth,
                        screenHeight,
                        provider,
                        salon,
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Divider(
                        color: AppColors.divider(context),
                        thickness: 1,
                        height: screenHeight * 0.01,
                        indent: screenWidth * 0.04,
                        endIndent: screenWidth * 0.04,
                      ),
                      _buildLocationPreview(
                        context,
                        screenWidth,
                        screenHeight,
                        provider,
                        salon,
                      ),
                      SizedBox(height: screenHeight * 0.12),
                    ],
                  ),
                ),
                _buildFixedHeader(
                  context,
                  screenWidth,
                  screenHeight,
                  provider,
                  salon,
                ),
                _buildBookAppointmentButton(
                  context,
                  screenWidth,
                  screenHeight,
                  salon,
                ),
              ],
            ),
    );
  }

  Widget _buildHeaderImage(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> salon,
  ) {
    return SizedBox(
      height: screenHeight * 0.35,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: screenHeight * 0.35,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.inputBg(context),
              image: DecorationImage(
                image: AssetImage(
                  salon['image'] ?? 'assets/salon details/salon_cover.png',
                ),
                fit: BoxFit.cover,
                onError: (_, _) {},
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.15,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFixedHeader(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    SalonDetailsProvider provider,
    Map<String, dynamic> salon,
  ) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.only(
          top: topPadding + (screenHeight * 0.01),
          bottom: screenHeight * 0.01,
          left: screenWidth * 0.04,
          right: screenWidth * 0.04,
        ),
        decoration: BoxDecoration(
          color: _isScrolled
              ? AppColors.scaffoldBg(context)
              : Colors.transparent,
          boxShadow: _isScrolled
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCircleButton(
              context,
              screenWidth,
              icon: Icons.arrow_back_ios_new,
              onTap: () => Navigator.pop(context),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: _isScrolled ? 1.0 : 0.0,
              child: Text(
                salon['name'] ?? '',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ),
            Row(
              children: [
                _buildCircleButton(
                  context,
                  screenWidth,
                  icon: provider.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  forceActiveColor: provider.isFavorite,
                  onTap: () => provider.toggleFavorite(),
                ),
                SizedBox(width: screenWidth * 0.025),
                _buildCircleButton(
                  context,
                  screenWidth,
                  icon: Icons.share_outlined,
                  onTap: () => provider.shareSalon(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(
    BuildContext context,
    double screenWidth, {
    required IconData icon,
    bool forceActiveColor = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: screenWidth * 0.1,
        height: screenWidth * 0.1,
        decoration: BoxDecoration(
          color: _isScrolled
              ? AppColors.inputBg(context)
              : Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: forceActiveColor
              ? AppColors.primaryPink
              : (_isScrolled ? AppColors.textPrimary(context) : Colors.white),
          size: screenWidth * 0.05,
        ),
      ),
    );
  }

  Widget _buildSalonInfoCard(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> salon,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.04,
        right: screenWidth * 0.04,
        top: screenHeight * 0.02,
        bottom: screenHeight * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  salon['name'] ?? 'Salon Name',
                  style: TextStyle(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ),
              if (salon['isOpen'] == true)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.025,
                    vertical: screenHeight * 0.004,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(screenWidth * 0.015),
                  ),
                  child: Text(
                    context.tr('open_now'),
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: screenHeight * 0.008),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: screenWidth * 0.045),
              SizedBox(width: screenWidth * 0.01),
              Text(
                '${salon['rating'] ?? 0.0}',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),
              SizedBox(width: screenWidth * 0.01),
              Text(
                '(${salon['reviewCount'] ?? 0})',
                style: TextStyle(
                  fontSize: screenWidth * 0.032,
                  color: AppColors.textSecondary(context),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                '•',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: AppColors.textSecondary(context),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                salon['type'] ?? 'Unisex Salon',
                style: TextStyle(
                  fontSize: screenWidth * 0.032,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.008),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.primaryPink,
                size: screenWidth * 0.04,
              ),
              SizedBox(width: screenWidth * 0.01),
              Text(
                '${salon['distance'] ?? '0 ${context.tr('km')}'}',
                style: TextStyle(
                  fontSize: screenWidth * 0.032,
                  color: AppColors.textSecondary(context),
                ),
              ),
              SizedBox(width: screenWidth * 0.01),
              Text(
                '•',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: AppColors.textSecondary(context),
                ),
              ),
              SizedBox(width: screenWidth * 0.01),
              Expanded(
                child: Text(
                  salon['address'] ?? 'Address',
                  style: TextStyle(
                    fontSize: screenWidth * 0.032,
                    color: AppColors.textSecondary(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    SalonDetailsProvider provider,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionItem(
            context,
            screenWidth,
            screenHeight,
            icon: Icons.call_outlined,
            label: context.tr('call'),
            onTap: () => provider.callSalon(),
          ),
          _buildActionItem(
            context,
            screenWidth,
            screenHeight,
            icon: Icons.near_me_outlined,
            label: context.tr('direction'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SalonLocationScreen(salonData: provider.salonData),
                ),
              );
            },
          ),
          _buildActionItem(
            context,
            screenWidth,
            screenHeight,
            icon: provider.isFavorite
                ? Icons.bookmark
                : Icons.bookmark_border_outlined,
            label: context.tr('save'),
            onTap: () => provider.toggleFavorite(),
          ),
          _buildActionItem(
            context,
            screenWidth,
            screenHeight,
            icon: Icons.share_outlined,
            label: context.tr('share'),
            onTap: () => provider.shareSalon(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    double screenWidth,
    double screenHeight, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: screenWidth * 0.12,
            height: screenWidth * 0.12,
            decoration: BoxDecoration(
              color: AppColors.inputBg(context),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.divider(context), width: 1),
            ),
            child: Icon(
              icon,
              color: AppColors.textPrimary(context),
              size: screenWidth * 0.055,
            ),
          ),
          SizedBox(height: screenHeight * 0.006),
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningHours(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> salon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: Row(
        children: [
          Text(
            context.tr('opening_hours'),
            style: TextStyle(
              fontSize: screenWidth * 0.038,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          const Spacer(),
          Text(
            '${salon['openTime'] ?? '10:00 AM'} - ${salon['closeTime'] ?? '9:00 PM'}',
            style: TextStyle(
              fontSize: screenWidth * 0.032,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(width: screenWidth * 0.015),
          Icon(
            Icons.arrow_forward_ios,
            size: screenWidth * 0.03,
            color: AppColors.textSecondary(context),
          ),
          SizedBox(width: screenWidth * 0.02),
          Text(
            salon['openDays'] ?? 'Mon - Sun',
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    SalonDetailsProvider provider,
    Map<String, dynamic> salon,
  ) {
    final aboutText = salon['about'] ?? '';
    final displayText = provider.isAboutExpanded
        ? aboutText
        : (aboutText.length > 120
              ? '${aboutText.substring(0, 120)}...'
              : aboutText);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayText,
            style: TextStyle(
              fontSize: screenWidth * 0.033,
              color: AppColors.textSecondary(context),
              height: 1.5,
            ),
          ),
          if (aboutText.length > 120)
            GestureDetector(
              onTap: () => provider.toggleAboutExpanded(),
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.005),
                child: Text(
                  provider.isAboutExpanded
                      ? context.tr('show_less')
                      : context.tr('read_more'),
                  style: TextStyle(
                    fontSize: screenWidth * 0.033,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPink,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGalleryPreview(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    SalonDetailsProvider provider,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('gallery'),
                style: TextStyle(
                  fontSize: screenWidth * 0.042,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  context.tr('see_all'),
                  style: TextStyle(
                    fontSize: screenWidth * 0.033,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPink,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.012),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: screenHeight * 0.01,
              mainAxisSpacing: screenHeight * 0.01,
              childAspectRatio: 1.3,
            ),
            itemCount: provider.galleryPreview.length > 4
                ? 4
                : provider.galleryPreview.length,
            itemBuilder: (context, index) {
              final image = provider.galleryPreview[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
                child: Container(
                  color: AppColors.inputBg(context),
                  child: Image.asset(
                    image['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      color: AppColors.inputBg(context),
                      child: Icon(
                        Icons.image_outlined,
                        color: AppColors.textSecondary(context),
                        size: screenWidth * 0.1,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServicesPreview(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    SalonDetailsProvider provider,
    Map<String, dynamic> salon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('our_services'),
                style: TextStyle(
                  fontSize: screenWidth * 0.042,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ServicesScreen(
                        salonData: salon,
                        isBookingMode: false,
                        bookingData: const {},
                      ),
                    ),
                  );
                },
                child: Text(
                  context.tr('see_all'),
                  style: TextStyle(
                    fontSize: screenWidth * 0.033,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPink,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.012),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: provider.servicesPreview.length > 4
                ? 4
                : provider.servicesPreview.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: screenHeight * 0.01),
            itemBuilder: (context, index) => _buildServiceItem(
              context,
              screenWidth,
              screenHeight,
              provider.servicesPreview[index],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> service,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceDetailsScreen(serviceData: service),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.035,
          vertical: screenHeight * 0.012,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          border: Border.all(color: AppColors.divider(context), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.12,
              height: screenWidth * 0.12,
              padding: EdgeInsets.all(screenWidth * 0.02),
              decoration: BoxDecoration(
                color: Color(service['color'] ?? 0xFFF8F8FA),
                borderRadius: BorderRadius.circular(screenWidth * 0.025),
              ),
              child: Image.asset(
                service['image'] ?? 'assets/images/hairs.png',
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Icon(
                  Icons.spa,
                  color: AppColors.textSecondary(context),
                  size: screenWidth * 0.05,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.035),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['name'] ?? 'Service',
                    style: TextStyle(
                      fontSize: screenWidth * 0.037,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.003),
                  Text(
                    '${context.tr('from_rs')} ${service['price'] ?? 0}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.032,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: screenWidth * 0.04,
              color: AppColors.textSecondary(context),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // PACKAGES PREVIEW (UPDATED NAVIGATION FLAG)
  // ==========================================================
  Widget _buildPackagesPreview(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    SalonDetailsProvider provider,
    Map<String, dynamic> salon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('our_packages'),
                style: TextStyle(
                  fontSize: screenWidth * 0.042,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PackagesScreen(
                        salonData: salon,
                        isBookingMode: false,
                      ),
                    ),
                  );
                },
                child: Text(
                  context.tr('see_all'),
                  style: TextStyle(
                    fontSize: screenWidth * 0.033,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPink,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.012),
          SizedBox(
            height: screenHeight * 0.22,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: provider.packagesPreview.length,
              separatorBuilder: (context, index) =>
                  SizedBox(width: screenWidth * 0.03),
              itemBuilder: (context, index) => _buildPackageCard(
                context,
                screenWidth,
                screenHeight,
                provider.packagesPreview[index],
                salon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> pkg,
    Map<String, dynamic> salon,
  ) {
    final includes = (pkg['includes'] as List<dynamic>?) ?? [];
    return GestureDetector(
      onTap: () {
        // ✅ FIX: salon ki jagah salonData pass karo
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PackageDetailsScreen(
              packageData: pkg,
              salonData: salon, // <--- Correct parameter name!
              skipSalonSelection: true,
            ),
          ),
        );
      },
      child: Container(
        width: screenWidth * 0.55,
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(screenWidth * 0.035),
          border: Border.all(color: AppColors.divider(context), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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

  Widget _buildBeauticiansPreview(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    SalonDetailsProvider provider,
    Map<String, dynamic> salon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('our_beauticians'),
                style: TextStyle(
                  fontSize: screenWidth * 0.042,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BeauticiansScreen(
                        salonData: salon,
                        isBookingMode: false,
                        bookingData: const {},
                      ),
                    ),
                  );
                },
                child: Text(
                  context.tr('see_all'),
                  style: TextStyle(
                    fontSize: screenWidth * 0.033,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPink,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.012),
          SizedBox(
            height: screenHeight * 0.1,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: provider.beauticiansPreview.length,
              separatorBuilder: (context, index) =>
                  SizedBox(width: screenWidth * 0.04),
              itemBuilder: (context, index) {
                final beautician = provider.beauticiansPreview[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            BeauticianDetailsScreen(beauticianData: beautician),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.07,
                        backgroundColor: AppColors.inputBg(context),
                        backgroundImage: AssetImage(beautician['image'] ?? ''),
                        onBackgroundImageError: (e, s) {},
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        (beautician['name'] ?? 'Name')
                            .toString()
                            .split(' ')
                            .first,
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary(context),
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
    );
  }

  Widget _buildReviewsPreview(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    SalonDetailsProvider provider,
    Map<String, dynamic> salon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('reviews'),
                style: TextStyle(
                  fontSize: screenWidth * 0.042,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReviewsScreen(salonData: salon),
                    ),
                  );
                },
                child: Text(
                  context.tr('see_all'),
                  style: TextStyle(
                    fontSize: screenWidth * 0.033,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPink,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            children: [
              Text(
                '${salon['rating'] ?? 0.0}',
                style: TextStyle(
                  fontSize: screenWidth * 0.09,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      final rating = (salon['rating'] ?? 0.0) as double;
                      return Icon(
                        index < rating.floor()
                            ? Icons.star
                            : (index < rating
                                  ? Icons.star_half
                                  : Icons.star_border),
                        color: Colors.amber,
                        size: screenWidth * 0.04,
                      );
                    }),
                  ),
                  SizedBox(height: screenHeight * 0.003),
                  Text(
                    '(${salon['reviewCount'] ?? 0} Reviews)',
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (provider.reviewsPreview.isNotEmpty) ...[
            SizedBox(height: screenHeight * 0.012),
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                color: AppColors.inputBg(context),
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.05,
                        backgroundColor: AppColors.divider(context),
                        backgroundImage: AssetImage(
                          provider.reviewsPreview.first['userImage'] ?? '',
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.025),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.reviewsPreview.first['userName'] ??
                                  'User',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                            Row(
                              children: List.generate(5, (index) {
                                final r =
                                    (provider.reviewsPreview.first['rating'] ??
                                            0.0)
                                        as double;
                                return Icon(
                                  index < r.floor()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: screenWidth * 0.032,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        provider.reviewsPreview.first['date'] ?? '',
                        style: TextStyle(
                          fontSize: screenWidth * 0.028,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Text(
                    provider.reviewsPreview.first['comment'] ?? '',
                    style: TextStyle(
                      fontSize: screenWidth * 0.032,
                      color: AppColors.textSecondary(context),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationPreview(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    SalonDetailsProvider provider,
    Map<String, dynamic> salon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('location'),
                style: TextStyle(
                  fontSize: screenWidth * 0.042,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SalonLocationScreen(salonData: salon),
                    ),
                  );
                },
                child: Text(
                  context.tr('view_on_map'),
                  style: TextStyle(
                    fontSize: screenWidth * 0.033,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPink,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.012),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SalonLocationScreen(salonData: salon),
                ),
              );
            },
            child: Container(
              height: screenHeight * 0.18,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(screenWidth * 0.035),
                border: Border.all(color: AppColors.divider(context), width: 1),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.map_outlined,
                      size: screenWidth * 0.15,
                      color: AppColors.textSecondary(
                        context,
                      ).withValues(alpha: 0.3),
                    ),
                  ),
                  Center(
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.primaryPink,
                      size: screenWidth * 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: AppColors.primaryPink,
                size: screenWidth * 0.045,
              ),
              SizedBox(width: screenWidth * 0.015),
              Expanded(
                child: Text(
                  salon['fullAddress'] ??
                      salon['address'] ??
                      'Address not available',
                  style: TextStyle(
                    fontSize: screenWidth * 0.032,
                    color: AppColors.textSecondary(context),
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookAppointmentButton(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> salon,
  ) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.015,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: CustomButton(
            text: context.tr('book_appointment'),
            isLoading: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ServicesScreen(
                    salonData: salon,
                    isBookingMode: true,
                    bookingData: const {},
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
