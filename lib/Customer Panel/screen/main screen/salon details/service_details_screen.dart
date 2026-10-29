import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/salon%20details%20providers/service_details_provider.dart';

/// S24 - Service Details Screen (Browse Only — No Book Button)
class ServiceDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> serviceData;
  final Map<String, dynamic>? salonData;

  const ServiceDetailsScreen({
    super.key,
    required this.serviceData,
    this.salonData,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServiceDetailsProvider()..initServiceData(serviceData),
      child: const _ServiceDetailsView(),
    );
  }
}

class _ServiceDetailsView extends StatefulWidget {
  const _ServiceDetailsView();

  @override
  State<_ServiceDetailsView> createState() => _ServiceDetailsViewState();
}

class _ServiceDetailsViewState extends State<_ServiceDetailsView> {
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
    final provider = Provider.of<ServiceDetailsProvider>(context);
    final service = provider.serviceData;

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
                          service,
                        ),

                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.04,
                            screenHeight * 0.02,
                            screenWidth * 0.04,
                            0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  service['name'] ?? 'Service Name',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary(context),
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Text(
                                '${context.tr('rs')} ${service['price'] ?? 0}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryPink,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: AppColors.primaryPink,
                                size: screenWidth * 0.045,
                              ),
                              SizedBox(width: screenWidth * 0.015),
                              Text(
                                '${context.tr('duration_label')} ${service['duration'] ?? 'N/A'}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary(context),
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

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.01,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr('about_service'),
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.008),
                              Text(
                                service['about'] ?? '',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: AppColors.textSecondary(context),
                                  height: 1.5,
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

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.01,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr('service_includes'),
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.012),
                              _buildIncludesList(
                                context,
                                screenWidth,
                                screenHeight,
                                service,
                              ),
                            ],
                          ),
                        ),

                        // Small bottom padding (no fixed button now)
                        SizedBox(height: screenHeight * 0.04),
                      ],
                    ),
                  ),

                  _buildFixedHeader(
                    context,
                    screenWidth,
                    screenHeight,
                    provider,
                    service,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderImage(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    Map<String, dynamic> service,
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
                  service['coverImage'] ??
                      'assets/images/hair spa treatment.png',
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
    ServiceDetailsProvider provider,
    Map<String, dynamic> service,
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
                  service['name'] ?? '',
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
              onTap: () => provider.shareService(),
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
    Map<String, dynamic> service,
  ) {
    final includes = (service['includes'] as List<dynamic>?) ?? [];
    if (includes.isEmpty) {
      return Text(
        'Details not available.',
        style: TextStyle(
          fontSize: screenWidth * 0.035,
          color: AppColors.textSecondary(context),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: includes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.01),
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
                    fontSize: screenWidth * 0.035,
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
}
