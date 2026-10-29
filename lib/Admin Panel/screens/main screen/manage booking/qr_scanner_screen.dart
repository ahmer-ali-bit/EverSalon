import 'dart:io';
import 'package:ever_salon/Admin%20Panel/providers/manage%20booking/qr_scanner_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class AdminQrScannerScreen extends StatelessWidget {
  const AdminQrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminQrScannerProvider(),
      child: const _AdminQrScannerContent(),
    );
  }
}

class _AdminQrScannerContent extends StatelessWidget {
  const _AdminQrScannerContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminQrScannerProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
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
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: w * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.04),
                  Text(
                    context.tr('Scan QR Code'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    onPressed: provider.toggleTorch,
                  ),
                ],
              ),
            ),

            Expanded(
              child: provider.scannedBooking != null
                  ? _buildSuccessCard(context, w, h, provider)
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        // CAMERA FEED WITH ERROR FALLBACK FOR SIMULATOR
                        MobileScanner(
                          controller: provider.cameraController,
                          onDetect: provider.onDetect,
                          errorBuilder: (context, error) {
                            // FIXED: 2 arguments
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.08,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white54,
                                      size: w * 0.15,
                                    ),
                                    SizedBox(height: h * 0.02),
                                    Text(
                                      context.tr(
                                        'Camera unavailable (Simulator Mode)',
                                      ),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: w * 0.038,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: h * 0.01),
                                    Text(
                                      context.tr(
                                        'Tap below to test scanning without physical camera',
                                      ),
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: w * 0.03,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: h * 0.03),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryPink,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: w * 0.06,
                                          vertical: h * 0.015,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            w * 0.08,
                                          ),
                                        ),
                                      ),
                                      onPressed: provider.simulateScan,
                                      icon: const Icon(
                                        Icons.qr_code_scanner,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        context.tr('Simulate Scan'),
                                        style: TextStyle(
                                          fontSize: w * 0.038,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // SCANNER FRAME OVERLAY
                        Container(
                          height: w * 0.7,
                          width: w * 0.7,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primaryPink,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(w * 0.05),
                          ),
                        ),

                        if (provider.isScanningMock)
                          const CircularProgressIndicator(
                            color: AppColors.primaryPink,
                          ),

                        Positioned(
                          bottom: h * 0.06,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.04,
                              vertical: h * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(w * 0.02),
                            ),
                            child: Text(
                              context.tr('Align QR code within the frame'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.035,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessCard(
    BuildContext context,
    double w,
    double h,
    AdminQrScannerProvider provider,
  ) {
    final b = provider.scannedBooking!;
    final avatarPath = b['customerAvatar'] as String? ?? '';
    ImageProvider? img;
    if (avatarPath.isNotEmpty) {
      if (avatarPath.startsWith('assets/')) {
        img = AssetImage(avatarPath);
      } else {
        img = FileImage(File(avatarPath));
      }
    }

    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: w * 0.05),
          padding: EdgeInsets.all(w * 0.05),
          decoration: BoxDecoration(
            color: AppColors.cardBg(context),
            borderRadius: BorderRadius.circular(w * 0.05),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPink.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: w * 0.15,
              ),
              SizedBox(height: h * 0.01),
              Text(
                context.tr('Booking Verified!'),
                style: TextStyle(
                  fontSize: w * 0.05,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              Divider(height: h * 0.03, color: AppColors.inputBg(context)),
              Row(
                children: [
                  CircleAvatar(
                    radius: w * 0.06,
                    backgroundColor: AppColors.inputBg(context),
                    backgroundImage: img,
                    onBackgroundImageError: (_, _) {},
                    child: img == null
                        ? Icon(
                            Icons.person,
                            color: AppColors.textGrey,
                            size: w * 0.06,
                          )
                        : null,
                  ),
                  SizedBox(width: w * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b['customerName'],
                          style: TextStyle(
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        Text(
                          b['bookingId'],
                          style: TextStyle(
                            fontSize: w * 0.03,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.tr('Service:'),
                    style: TextStyle(
                      fontSize: w * 0.035,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                  Text(
                    b['service'],
                    style: TextStyle(
                      fontSize: w * 0.035,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.03),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    padding: EdgeInsets.symmetric(vertical: h * 0.018),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.08),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    context.tr('Mark as Arrived'),
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: provider.resetScanner,
                child: Text(
                  context.tr("Scan Another"),
                  style: TextStyle(color: AppColors.textGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
