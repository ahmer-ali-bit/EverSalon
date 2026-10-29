import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/appointment%20booking%20flow/qr_check_in_provider.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCheckInScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const QrCheckInScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QrCheckInProvider()..initFromBookingData(bookingData),
      child: _QrCheckInView(bookingData: bookingData),
    );
  }
}

class _QrCheckInView extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const _QrCheckInView({required this.bookingData});

  Map<String, dynamic> get salon {
    final raw = bookingData['salon'] ?? bookingData['salonData'];
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {};
  }

  String get salonName =>
      salon['name']?.toString() ??
      bookingData['salonName']?.toString() ??
      'Salon';

  String get formattedDate =>
      bookingData['formattedDate']?.toString() ??
      bookingData['selectedDate']?.toString() ??
      'N/A';

  String get selectedTime => bookingData['selectedTime']?.toString() ?? 'N/A';

  String get dateTimeLabel {
    String dateShort = formattedDate;
    if (formattedDate.contains(',')) {
      final parts = formattedDate.split(', ');
      if (parts.length >= 2) {
        final day = parts[0].length >= 3 ? parts[0].substring(0, 3) : parts[0];
        dateShort = '$day, ${parts.sublist(1).join(', ')}';
      }
    }
    return '$dateShort, $selectedTime';
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<QrCheckInProvider>();

    final scaffoldBg = AppColors.scaffoldBg(context);
    final textPrimary = AppColors.textPrimary(context);
    final textSecondary = AppColors.textSecondary(context);
    final inputBg = AppColors.inputBg(context);
    final primaryPink = AppColors.primaryPink;
    final borderColor = textPrimary.withValues(alpha: 0.12);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: provider.isLoading
            ? Center(child: CircularProgressIndicator(color: primaryPink))
            : Column(
                children: [
                  // ── HEADER ──
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
                              color: inputBg,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: textPrimary,
                              size: w * 0.05,
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.03),

                        Center(
                          child: Text(
                            context.tr('your_booking_qr'),
                            style: TextStyle(
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.1),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                      child: Column(
                        children: [
                          SizedBox(height: h * 0.02),

                          Text(
                            context.tr(
                              'Show this QR code at the salon for check-in.',
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: w * 0.038,
                              color: textSecondary,
                              height: 1.4,
                            ),
                          ),

                          SizedBox(height: h * 0.035),

                          // ── QR CARD ──
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(w * 0.06),
                            decoration: BoxDecoration(
                              color: scaffoldBg,
                              borderRadius: BorderRadius.circular(w * 0.04),
                              border: Border.all(color: borderColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(w * 0.03),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      w * 0.025,
                                    ),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: QrImageView(
                                    data: provider.qrData.isNotEmpty
                                        ? provider.qrData
                                        : provider.bookingId,
                                    version: QrVersions.auto,
                                    size: w * 0.55,
                                    backgroundColor: Colors.white,
                                    eyeStyle: const QrEyeStyle(
                                      eyeShape: QrEyeShape.square,
                                      color: Color(0xFF1F1F1F),
                                    ),
                                    dataModuleStyle: const QrDataModuleStyle(
                                      dataModuleShape: QrDataModuleShape.square,
                                      color: Color(0xFF1F1F1F),
                                    ),
                                    errorStateBuilder: (context, error) {
                                      return SizedBox(
                                        width: w * 0.55,
                                        height: w * 0.55,
                                        child: Icon(
                                          Icons.qr_code_2_rounded,
                                          size: w * 0.3,
                                          color: textSecondary,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: h * 0.035),

                          _infoRow(
                            w,
                            label: context.tr('booking_id'),
                            value: provider.bookingId,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                          ),
                          SizedBox(height: h * 0.018),
                          _infoRow(
                            w,
                            label: context.tr('date_time'),
                            value: dateTimeLabel,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                          ),
                          SizedBox(height: h * 0.018),
                          _infoRow(
                            w,
                            label: context.tr('salon'),
                            value: salonName,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                          ),

                          SizedBox(height: h * 0.025),

                          Text(
                            context.tr('Please arrive 10 minutes early'),
                            style: TextStyle(
                              fontSize: w * 0.032,
                              color: textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: h * 0.08),
                        ],
                      ),
                    ),
                  ),

                  // ── DOWNLOAD QR ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      w * 0.04,
                      h * 0.015,
                      w * 0.04,
                      h * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: scaffoldBg,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: CustomButton(
                        text: context.tr('download_qr'),
                        width: double.infinity,
                        icon: Icons.download_rounded,
                        isLoading: provider.isDownloading,
                        onTap: provider.isDownloading
                            ? null
                            : () async {
                                final ok = await provider.downloadQr();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      ok
                                          ? context.tr('qr_saved')
                                          : context.tr('qr_save_failed'),
                                    ),
                                    backgroundColor: ok
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                );
                              },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _infoRow(
    double w, {
    required String label,
    required String value,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: w * 0.32,
          child: Text(
            label,
            style: TextStyle(
              fontSize: w * 0.035,
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: w * 0.036,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
