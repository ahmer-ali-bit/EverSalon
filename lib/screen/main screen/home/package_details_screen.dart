import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/provider/salon%20details%20providers/package_details_provider.dart';
import 'package:ever_salon/screen/main%20screen/home/all_salons_screen.dart';
import 'package:ever_salon/widgets/custom_button.dart';

/// S26 - Package Details Screen
class PackageDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> packageData;
  final Map<String, dynamic>? salonData;

  const PackageDetailsScreen({
    super.key,
    required this.packageData,
    this.salonData,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PackageDetailsProvider()..initPackageData(packageData),
      child: const _PackageDetailsView(),
    );
  }
}

class _PackageDetailsView extends StatefulWidget {
  const _PackageDetailsView();

  @override
  State<_PackageDetailsView> createState() => _PackageDetailsViewState();
}

class _PackageDetailsViewState extends State<_PackageDetailsView> {
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
    final provider = Provider.of<PackageDetailsProvider>(context);
    final pkg = provider.packageData;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryPink),
            )
          : SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderImage(
                          context,
                          screenWidth,
                          screenHeight,
                          pkg,
                        ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.04,
                            screenHeight * 0.02,
                            screenWidth * 0.04,
                            0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pkg['name'] ?? 'Package Name',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.055,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              Text(
                                '${context.tr('rs')} ${pkg['price'] ?? 0}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryPink,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Divider(
                          color: AppColors.divider(context),
                          thickness: 1,
                          height: screenHeight * 0.04,
                          indent: screenWidth * 0.04,
                          endIndent: screenWidth * 0.04,
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr('package_includes') ??
                                    'Package Includes',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.042,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              _buildIncludesList(
                                context,
                                screenWidth,
                                screenHeight,
                                pkg,
                              ),
                            ],
                          ),
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
                    pkg,
                  ),

                  // BOOK BUTTON → Opens All Salons Screen
                  _buildBookNowButton(context, screenWidth, screenHeight, pkg),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderImage(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> pkg,
  ) {
    return SizedBox(
      height: screenHeight * 0.4,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.inputBg(context),
              image: DecorationImage(
                image: AssetImage(
                  pkg['coverImage'] ?? 'assets/images/bridal copy.png',
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
              height: screenHeight * 0.1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
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
    PackageDetailsProvider provider,
    Map<String, dynamic> pkg,
  ) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.only(
          top: screenHeight * 0.01,
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
              child: Expanded(
                child: Text(
                  pkg['name'] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            _buildCircleButton(
              context,
              screenWidth,
              icon: Icons.share_outlined,
              onTap: () => provider.sharePackage(),
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
          color: _isScrolled ? AppColors.textPrimary(context) : Colors.white,
          size: screenWidth * 0.05,
        ),
      ),
    );
  }

  Widget _buildIncludesList(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> pkg,
  ) {
    final includes = (pkg['includes'] as List<dynamic>?) ?? [];
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: includes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.015),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.primaryPink,
                size: screenWidth * 0.045,
              ),
              SizedBox(width: screenWidth * 0.025),
              Expanded(
                child: Text(
                  includes[index].toString(),
                  style: TextStyle(
                    fontSize: screenWidth * 0.038,
                    color: AppColors.textPrimary(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ========================
  // BOOK THIS PACKAGE BUTTON → All Salons Screen (booking mode)
  // ========================
  Widget _buildBookNowButton(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> pkg,
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
          color: AppColors.scaffoldBg(context),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: CustomButton(
            text: context.tr('book_this_package') ?? 'Book This Package',
            isLoading: false,
            onTap: () {
              // Pass package data forward - salon will be selected next
              final bookingData = {
                'package': pkg,
                'packagePrice': pkg['price'] ?? 0,
                'flowType': 'package', // Marker: this is package booking flow
              };

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AllSalonsScreen(
                    isBookingMode: true, // Enable selection mode
                    bookingData: bookingData,
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
