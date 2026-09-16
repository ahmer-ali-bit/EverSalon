import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/provider/my%20booking/booking_details_provider.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingDetailsScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingDetailsProvider()..initData(bookingData),
      child: const _BookingDetailsView(),
    );
  }
}

class _BookingDetailsView extends StatelessWidget {
  const _BookingDetailsView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingDetailsProvider>();
    final data = provider.bookingData;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // ---- Safe readers ----
    final salonRaw = data['salonData'] ?? data['salon'];
    final salon = salonRaw is Map
        ? Map<String, dynamic>.from(salonRaw)
        : <String, dynamic>{};

    final beauticianRaw = data['beautician'] ?? data['selectedBeautician'];
    final beautician = beauticianRaw is Map
        ? Map<String, dynamic>.from(beauticianRaw)
        : <String, dynamic>{};

    final servicesRaw = data['selectedServices'] ?? data['services'];
    String serviceName = 'Haircut & Styling';
    String duration = '60 mins';
    if (servicesRaw is List && servicesRaw.isNotEmpty) {
      final first = servicesRaw.first;
      if (first is Map) {
        serviceName = first['name']?.toString() ?? serviceName;
        final d = first['duration'];
        if (d != null) {
          duration = d is int ? '$d ${context.tr('mins')}' : d.toString();
        }
      }
    }

    final bookingId = data['bookingId']?.toString() ?? '#ES1240S15689';
    final salonName = salon['name']?.toString() ?? 'Glow Beauty Lounge';
    final address =
        salon['fullAddress']?.toString() ??
        salon['address']?.toString() ??
        'Yasrab Town, Bahawalpur, Pakistan';
    final beauticianName = beautician['name']?.toString() ?? 'Ayesha Khan';
    final beauticianRole = beautician['role']?.toString() ?? 'Senior Stylist';
    final beauticianImage =
        beautician['image']?.toString() ?? 'assets/images/beautician.png';
    final beauticianRating = beautician['rating']?.toString() ?? '4.9';
    final beauticianReviews =
        (beautician['reviews'] ?? beautician['reviewCount'] ?? '128')
            .toString();
    final formattedDate =
        data['formattedDate']?.toString() ??
        data['selectedDate']?.toString() ??
        'Wed, 15 May 2024';
    final selectedTime = data['selectedTime']?.toString() ?? '11:00 AM';
    final totalPaid =
        data['totalAmount'] ?? data['grandTotal'] ?? data['subtotal'] ?? 1000;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER (Booking Details Screen) ──
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

                  Center(
                    child: Text(
                      context.tr('booking_details'),
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  Spacer(),
                  // More / options icon (S43 design)
                  GestureDetector(
                    onTap: () => _showOptionsSheet(context, data, w, h),
                    child: Container(
                      width: w * 0.1,
                      height: w * 0.1,
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.more_vert_rounded,
                        color: AppColors.textPrimary(context),
                        size: w * 0.055,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── BODY ──
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.01,
                      ),
                      child: Column(
                        children: [
                          // Details card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(w * 0.045),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg(context),
                              borderRadius: BorderRadius.circular(w * 0.04),
                              border: Border.all(color: AppColors.divider(context)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Booking ID (pink value)
                                _labelValueRow(
                                  context,
                                  w,
                                  label: context.tr('booking_id'),
                                  value: bookingId,
                                  valueColor: AppColors.primaryPink,
                                  valueBold: true,
                                ),
                                _divider(context, h),

                                _labelValueRow(
                                  context,
                                  w,
                                  label: context.tr('salon'),
                                  value: salonName,
                                ),
                                _divider(context, h),

                                _labelValueRow(
                                  context,
                                  w,
                                  label: context.tr('address'),
                                  value: address,
                                  maxLines: 2,
                                ),
                                _divider(context, h),

                                _labelValueRow(
                                  context,
                                  w,
                                  label: context.tr('service'),
                                  value: serviceName,
                                ),
                                _divider(context, h),

                                // Beautician row with photo
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: w * 0.28,
                                      child: Text(
                                        context.tr('beautician'),
                                        style: TextStyle(
                                          fontSize: w * 0.036,
                                          color: AppColors.textSecondary(context),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ClipOval(
                                            child: Image.asset(
                                              beauticianImage,
                                              width: w * 0.11,
                                              height: w * 0.11,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, _, _) =>
                                                  Container(
                                                    width: w * 0.11,
                                                    height: w * 0.11,
                                                    color: AppColors.inputBg(context),
                                                    child: Icon(
                                                      Icons.person,
                                                      size: w * 0.06,
                                                      color: AppColors.textSecondary(context),
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          SizedBox(width: w * 0.025),
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
Text(
                                                    beauticianName,
                                                    style: TextStyle(
                                                      fontSize: w * 0.036,
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColors.textPrimary(context),
                                                    ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: h * 0.002),
Text(
                                                    beauticianRole,
                                                    style: TextStyle(
                                                      fontSize: w * 0.03,
                                                      color: AppColors.textSecondary(context),
                                                    ),
                                                  ),
                                                SizedBox(height: h * 0.003),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star_rounded,
                                                      color: Colors.amber,
                                                      size: w * 0.035,
                                                    ),
                                                    SizedBox(width: w * 0.01),
Text(
                                                        '$beauticianRating ($beauticianReviews)',
                                                        style: TextStyle(
                                                          fontSize: w * 0.028,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              AppColors.textPrimary(context),
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
                                  ],
                                ),
                                _divider(context, h),

                                _labelValueRow(
                                  context,
                                  w,
                                  label: context.tr('date'),
                                  value: formattedDate,
                                ),
                                _divider(context, h),

                                _labelValueRow(
                                  context,
                                  w,
                                  label: context.tr('time'),
                                  value: selectedTime,
                                ),
                                _divider(context, h),

                                _labelValueRow(
                                  context,
                                  w,
                                  label: context.tr('duration'),
                                  value: duration,
                                ),
                                _divider(context, h),

                                // Total Paid
                                _labelValueRow(
                                  context,
                                  w,
                                  label: context.tr('total_paid'),
                                  value: '${context.tr('rs')} $totalPaid',
                                  valueColor: AppColors.primaryPink,
                                  valueBold: true,
                                  labelBold: true,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: h * 0.12),
                        ],
                      ),
                    ),
            ),

            // ── BOTTOM: View Invoice ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                w * 0.04,
                h * 0.015,
                w * 0.04,
                h * 0.02,
              ),
              decoration: BoxDecoration(
                color: AppColors.cardBg(context),
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
                  text: context.tr('view_invoice'),
                  icon: Icons.download_rounded,
                  width: double.infinity,
                  height: 55,
                  isLoading: provider.isDownloading,
                  onTap: provider.isDownloading
                      ? null
                      : () async {
                          final ok = await provider.downloadInvoice();
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                ok
                                    ? context.tr('invoice_ready')
                                    : context.tr('invoice_failed'),
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

  Widget _divider(BuildContext context, double h) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.014),
      child: Divider(color: AppColors.divider(context), height: 1),
    );
  }

  Widget _labelValueRow(
    BuildContext context,
    double w, {
    required String label,
    required String value,
    Color? valueColor,
    bool valueBold = false,
    bool labelBold = false,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: maxLines > 1
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: w * 0.28,
          child: Text(
            label,
            style: TextStyle(
              fontSize: w * 0.036,
              color: AppColors.textSecondary(context),
              fontWeight: labelBold ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: w * 0.036,
              fontWeight: valueBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary(context),
            ),
          ),
        ),
      ],
    );
  }

  void _showOptionsSheet(
    BuildContext context,
    Map<String, dynamic> data,
    double w,
    double h,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.sheetBg(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.05)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.04,
              vertical: h * 0.02,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: w * 0.12,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: h * 0.02),
                ListTile(
                  leading: const Icon(
                    Icons.qr_code_2_rounded,
                    color: AppColors.primaryPink,
                  ),
                  title: Text(
                    context.tr('qr_checkin'),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: w * 0.04,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    // TODO: Navigate to S49 QR Check-in Screen
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => QrCheckInScreen(bookingData: data),
                    //   ),
                    // );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.share_outlined,
                    color: AppColors.textPrimary(context),
                  ),
                  title: Text(
                    context.tr('share_booking'),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: w * 0.04,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    // TODO: share booking summary
                  },
                ),
                SizedBox(height: h * 0.01),
              ],
            ),
          ),
        );
      },
    );
  }
}
