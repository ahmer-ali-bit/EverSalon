import 'package:ever_salon/Admin%20Panel/providers/profile/setting/salon_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../constants/app_colors.dart';
import '../../../../../../constants/app_translations.dart';

class AdminSalonLocationScreen extends StatelessWidget {
  final String? initialAddress;

  const AdminSalonLocationScreen({super.key, this.initialAddress});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminSalonLocationProvider(initialAddress: initialAddress),
      child: const _AdminSalonLocationContent(),
    );
  }
}

class _AdminSalonLocationContent extends StatelessWidget {
  const _AdminSalonLocationContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminSalonLocationProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryPink),
              )
            : Column(
                children: [
                  // HEADER
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.04,
                      vertical: h * 0.015,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: w * 0.1,
                            height: w * 0.1,
                            decoration: BoxDecoration(
                              color: AppColors.inputBg(context),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: AppColors.textPrimary(context),
                              size: w * 0.05,
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.03),
                        Expanded(
                          child: Text(
                            context.tr('Salon Location'),
                            style: TextStyle(
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr(
                              'Tap on map to place pin. Customer app shows this on Salon Location.',
                            ),
                            style: TextStyle(
                              fontSize: w * 0.03,
                              color: AppColors.textSecondary(context),
                              height: 1.35,
                            ),
                          ),
                          SizedBox(height: h * 0.015),

                          // MOCK MAP
                          Text(
                            context.tr('Map Pin'),
                            style: TextStyle(
                              fontSize: w * 0.035,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.01),
                          _buildMockMap(context, w, h, provider),
                          SizedBox(height: h * 0.012),

                          // Lat / Lng display
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.035,
                              vertical: h * 0.012,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.inputBg(context),
                              borderRadius: BorderRadius.circular(w * 0.03),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.my_location,
                                  size: w * 0.045,
                                  color: AppColors.primaryPink,
                                ),
                                SizedBox(width: w * 0.025),
                                Expanded(
                                  child: Text(
                                    'Lat ${provider.latitude.toStringAsFixed(4)}  ·  Lng ${provider.longitude.toStringAsFixed(4)}',
                                    style: TextStyle(
                                      fontSize: w * 0.03,
                                      color: AppColors.textSecondary(context),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: h * 0.012),

                          // Use current location (mock)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: provider.useCurrentLocationMock,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: AppColors.primaryPink.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(w * 0.08),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: h * 0.014,
                                ),
                              ),
                              icon: Icon(
                                Icons.gps_fixed,
                                color: AppColors.primaryPink,
                                size: w * 0.05,
                              ),
                              label: Text(
                                context.tr('Use Current Location'),
                                style: TextStyle(
                                  color: AppColors.primaryPink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.035,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.025),

                          // ADDRESS FIELDS
                          _label(context, w, 'Full Address'),
                          _field(
                            context,
                            w,
                            'Street, area, city...',
                            provider.addressController,
                            maxLines: 2,
                          ),
                          SizedBox(height: h * 0.018),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _label(context, w, 'City'),
                                    _field(
                                      context,
                                      w,
                                      'City',
                                      provider.cityController,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: w * 0.03),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _label(context, w, 'Area'),
                                    _field(
                                      context,
                                      w,
                                      'Area / Town',
                                      provider.areaController,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.018),

                          _label(context, w, 'Landmark'),
                          _field(
                            context,
                            w,
                            'e.g. Near Shell Pump',
                            provider.landmarkController,
                          ),
                          SizedBox(height: h * 0.03),

                          // Preview card (customer-style)
                          Text(
                            context.tr('Customer Preview'),
                            style: TextStyle(
                              fontSize: w * 0.035,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.01),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(w * 0.04),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg(context),
                              borderRadius: BorderRadius.circular(w * 0.04),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(w * 0.03),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryPink.withValues(
                                      alpha: 0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.location_on,
                                    color: AppColors.primaryPink,
                                    size: w * 0.06,
                                  ),
                                ),
                                SizedBox(width: w * 0.03),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        provider.areaController.text.isEmpty
                                            ? context.tr('Salon Area')
                                            : provider.areaController.text,
                                        style: TextStyle(
                                          fontSize: w * 0.038,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary(context),
                                        ),
                                      ),
                                      SizedBox(height: w * 0.01),
                                      Text(
                                        provider.addressController.text,
                                        style: TextStyle(
                                          fontSize: w * 0.032,
                                          color: AppColors.textSecondary(
                                            context,
                                          ),
                                          height: 1.35,
                                        ),
                                      ),
                                      if (provider
                                          .landmarkController
                                          .text
                                          .isNotEmpty) ...[
                                        SizedBox(height: w * 0.01),
                                        Text(
                                          provider.landmarkController.text,
                                          style: TextStyle(
                                            fontSize: w * 0.03,
                                            color: AppColors.primaryPink,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: h * 0.04),

                          SizedBox(
                            width: double.infinity,
                            height: h * 0.06,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryPink,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(w * 0.08),
                                ),
                              ),
                              onPressed: provider.isSaving
                                  ? null
                                  : () async {
                                      final ok = await provider.saveLocation();
                                      if (!context.mounted) return;
                                      if (ok) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              context.tr('Location saved'),
                                            ),
                                            backgroundColor: AppColors.success,
                                          ),
                                        );
                                        Navigator.pop(context, {
                                          'address': provider
                                              .addressController
                                              .text
                                              .trim(),
                                          'city': provider.cityController.text
                                              .trim(),
                                          'lat': provider.latitude,
                                          'lng': provider.longitude,
                                        });
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              context.tr(
                                                'Please fill address and city',
                                              ),
                                            ),
                                            backgroundColor: AppColors.error,
                                          ),
                                        );
                                      }
                                    },
                              child: provider.isSaving
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      context.tr('Save Location'),
                                      style: TextStyle(
                                        fontSize: w * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: h * 0.03),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildMockMap(
    BuildContext context,
    double w,
    double h,
    AdminSalonLocationProvider provider,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mapW = constraints.maxWidth;
        final mapH = h * 0.28;

        return GestureDetector(
          onTapDown: (details) {
            provider.updatePin(details.localPosition, Size(mapW, mapH));
          },
          onPanUpdate: (details) {
            provider.updatePin(details.localPosition, Size(mapW, mapH));
          },
          child: Container(
            width: mapW,
            height: mapH,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(w * 0.04),
              border: Border.all(color: AppColors.inputBg(context)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFE8F0E8),
                  const Color(0xFFD4E4F0),
                  AppColors.inputBg(context),
                ],
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Fake roads
                CustomPaint(
                  size: Size(mapW, mapH),
                  painter: _MockMapPainter(
                    roadColor: AppColors.textGrey.withValues(alpha: 0.25),
                  ),
                ),
                // Grid feel
                ...List.generate(4, (i) {
                  return Positioned(
                    left: mapW * (0.2 * (i + 1)),
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 1,
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                  );
                }),
                // Pin
                Positioned(
                  left: mapW * provider.pinX - w * 0.04,
                  top: mapH * provider.pinY - w * 0.08,
                  child: Column(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.primaryPink,
                        size: w * 0.09,
                      ),
                      Container(
                        width: w * 0.02,
                        height: w * 0.02,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPink.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                // Hint
                Positioned(
                  left: w * 0.03,
                  bottom: w * 0.03,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.025,
                      vertical: w * 0.012,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(w * 0.02),
                    ),
                    child: Text(
                      context.tr('Tap or drag to move pin'),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.028,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _label(BuildContext context, double w, String t) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.02),
      child: Text(
        context.tr(t),
        style: TextStyle(
          fontSize: w * 0.035,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary(context),
        ),
      ),
    );
  }

  Widget _field(
    BuildContext context,
    double w,
    String hint,
    TextEditingController c, {
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg(context),
        borderRadius: BorderRadius.circular(w * 0.03),
      ),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        onChanged: (_) {
          // Live Customer Preview update
          context.read<AdminSalonLocationProvider>().onFieldChanged();
        },
        style: TextStyle(
          color: AppColors.textPrimary(context),
          fontSize: w * 0.035,
        ),
        decoration: InputDecoration(
          hintText: context.tr(hint),
          hintStyle: TextStyle(color: AppColors.textGrey, fontSize: w * 0.035),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: w * 0.035,
          ),
        ),
      ),
    );
  }
}

class _MockMapPainter extends CustomPainter {
  final Color roadColor;
  _MockMapPainter({required this.roadColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = roadColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.25,
        size.width,
        size.height * 0.4,
      );
    canvas.drawPath(path, paint);

    final path2 = Path()
      ..moveTo(size.width * 0.2, 0)
      ..lineTo(size.width * 0.35, size.height)
      ..moveTo(0, size.height * 0.7)
      ..lineTo(size.width, size.height * 0.55);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
