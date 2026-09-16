import 'package:ever_salon/provider/appointment%20booking%20flow/booking_summary_provider.dart';
import 'package:ever_salon/screen/main%20screen/appointment%20booking%20flow/add_note_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_button.dart';
// TODO: S36 Ban'ne ke baad uncomment kar lena
// import 'package:ever_salon/screen/booking/add_notes_screen.dart';

class BookingSummaryScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingSummaryScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingSummaryProvider()..initFromBookingData(bookingData),
      child: _BookingSummaryView(bookingData: bookingData),
    );
  }
}

class _BookingSummaryView extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const _BookingSummaryView({required this.bookingData});

  // =========================================================
  // SAFE DATA READERS
  // =========================================================

  Map<String, dynamic> get salon {
    final raw = bookingData['salonData'] ?? bookingData['salon'];
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {};
  }

  String get salonName =>
      salon['name']?.toString() ??
      bookingData['salonName']?.toString() ??
      'Glow Beauty Lounge';

  String get salonAddress =>
      salon['address']?.toString() ??
      salon['location']?.toString() ??
      'Bahawalpur, Pakistan';

  String get salonRating {
    final r = salon['rating'] ?? bookingData['rating'];
    return r?.toString() ?? '4.8';
  }

  String get salonReviews {
    final r =
        salon['totalReviews'] ??
        salon['reviews'] ??
        bookingData['totalReviews'];
    return r?.toString() ?? '256';
  }

  String get salonImage =>
      salon['image']?.toString() ??
      salon['imageUrl']?.toString() ??
      'assets/images/salon_1.png';

  Map<String, dynamic> get beautician {
    final raw = bookingData['beautician'] ?? bookingData['selectedBeautician'];
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {};
  }

  String get beauticianName => beautician['name']?.toString() ?? 'N/A';

  String get beauticianImage =>
      beautician['image']?.toString() ??
      beautician['imageUrl']?.toString() ??
      'assets/images/beautician.png';

  List<Map<String, dynamic>> get services {
    final raw = bookingData['selectedServices'] ?? bookingData['services'];
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    if (raw is Map) return [Map<String, dynamic>.from(raw)];
    return [];
  }

  String get serviceNames {
    if (services.isEmpty) {
      return bookingData['serviceName']?.toString() ?? 'Service Name';
    }
    return services
        .map((s) => s['name']?.toString() ?? '')
        .where((n) => n.isNotEmpty)
        .join(', ');
  }

  String get serviceImage {
    if (services.isNotEmpty) {
      return services.first['image']?.toString() ??
          services.first['imageUrl']?.toString() ??
          'assets/images/service_haircut.png';
    }
    return bookingData['serviceImage']?.toString() ??
        'assets/images/service_haircut.png';
  }

  int get servicesTotalPrice {
    if (services.isEmpty) {
      return bookingData['totalServicePrice'] as int? ??
          bookingData['subtotal'] as int? ??
          0;
    }
    int total = 0;
    for (final s in services) {
      total += (s['price'] as int? ?? s['amount'] as int? ?? 0);
    }
    return total > 0 ? total : (bookingData['totalServicePrice'] as int? ?? 0);
  }

  String get formattedDate =>
      bookingData['formattedDate']?.toString() ??
      bookingData['selectedDate']?.toString() ??
      'N/A';

  String get selectedTime => bookingData['selectedTime']?.toString() ?? 'N/A';

  // =========================================================
  // BUILD
  // =========================================================
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<BookingSummaryProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
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
                      context.tr('booking_summary'),
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.1),
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
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: h * 0.01),

                          // ── Salon Card ──
                          _buildSalonCard(context, w, h),

                          SizedBox(height: h * 0.025),

                          // ── Detail Rows (with images for Service & Beautician) ──
                          _buildDetailRow(
                            context,
                            w,
                            h,
                            icon: Icons.content_cut_rounded,
                            label: context.tr('service'),
                            value: serviceNames,
                            trailing: '${context.tr('rs')} $servicesTotalPrice',
                            imagePath: serviceImage, // ✅ Image Added
                          ),
                          _divider(context, w, h),
                          _buildDetailRow(
                            context,
                            w,
                            h,
                            icon: Icons.person_outline_rounded,
                            label: context.tr('beautician'),
                            value: beauticianName,
                            trailing: '${context.tr('rs')} 0',
                            imagePath: beauticianImage, // ✅ Image Added
                          ),
                          _divider(context, w, h),
                          _buildDetailRow(
                            context,
                            w,
                            h,
                            icon: Icons.calendar_today_outlined,
                            label: context.tr('date'),
                            value: formattedDate,
                          ),
                          _divider(context, w, h),
                          _buildDetailRow(
                            context,
                            w,
                            h,
                            icon: Icons.access_time_rounded,
                            label: context.tr('time'),
                            value: selectedTime,
                          ),
                          _divider(context, w, h),
                          _buildDetailRow(
                            context,
                            w,
                            h,
                            icon: Icons.timelapse_rounded,
                            label: context.tr('duration'),
                            value: provider.durationLabel,
                          ),

                          SizedBox(height: h * 0.03),

                          // ── Price Breakdown ──
                          Text(
                            context.tr('price_details'),
                            style: TextStyle(
                              fontSize: w * 0.042,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.015),

                          _buildPriceRow(
                            context,
                            w,
                            h,
                            label: context.tr('subtotal'),
                            value: '${context.tr('rs')} ${provider.subtotal}',
                          ),
                          SizedBox(height: h * 0.01),
                          _buildPriceRow(
                            context,
                            w,
                            h,
                            label: context.tr('service_tax'),
                            value: '${context.tr('rs')} ${provider.serviceTax}',
                          ),
                          SizedBox(height: h * 0.012),
                          Divider(
                            color: AppColors.divider(context),
                            thickness: 1,
                          ),
                          SizedBox(height: h * 0.012),
                          _buildPriceRow(
                            context,
                            w,
                            h,
                            label: context.tr('total_amount'),
                            value: '${context.tr('rs')} ${provider.totalAmount}',
                            isTotal: true,
                          ),

                          SizedBox(height: h * 0.12),
                        ],
                      ),
                    ),
            ),

            // ── BOTTOM CONTINUE BUTTON ──
            _buildBottomBar(context, w, h, provider),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SALON CARD WIDGET
  // =========================================================
  Widget _buildSalonCard(BuildContext context, double w, double h) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.035),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.035),
        border: Border.all(color: AppColors.divider(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(w * 0.025),
            child: _buildImageOrIcon(
              context,
              salonImage,
              w * 0.18,
              Icons.storefront_rounded,
              w,
            ),
          ),
          SizedBox(width: w * 0.035),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  salonName,
                  style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: h * 0.004),
                Text(
                  salonAddress,
                  style: TextStyle(
                    fontSize: w * 0.032,
                    color: AppColors.textSecondary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: h * 0.006),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: w * 0.04),
                    SizedBox(width: w * 0.01),
                    Text(
                      '$salonRating ($salonReviews)',
                      style: TextStyle(
                        fontSize: w * 0.032,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DETAIL ROW (WITH CIRCULAR IMAGE SUPPORT)
  // =========================================================
  Widget _buildDetailRow(
    BuildContext context,
    double w,
    double h, {
    required IconData icon,
    required String label,
    required String value,
    String? trailing,
    String? imagePath, // Optional image path parameter
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.012),
      child: Row(
        children: [
          // ── If imagePath exists, show circular image, else pink icon box ──
          if (imagePath != null && imagePath.isNotEmpty)
            Container(
              width: w * 0.12,
              height: w * 0.12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.inputBg(context),
                border: Border.all(color: AppColors.divider(context)),
              ),
              child: ClipOval(
                child: _buildImageOrIcon(context, imagePath, w * 0.12, icon, w),
              ),
            )
          else
            Container(
              width: w * 0.12,
              height: w * 0.12,
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(w * 0.03),
              ),
              child: Icon(icon, color: AppColors.primaryPink, size: w * 0.055),
            ),

          SizedBox(width: w * 0.035),

          // ── Text Content ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: w * 0.03,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                SizedBox(height: h * 0.003),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: w * 0.038,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // ── Trailing Price ──
          if (trailing != null)
            Text(
              trailing,
              style: TextStyle(
                fontSize: w * 0.036,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
              ),
            ),
        ],
      ),
    );
  }

  // Helper to handle network vs asset images gracefully
  Widget _buildImageOrIcon(
    BuildContext context,
    String path,
    double size,
    IconData fallbackIcon,
    double w,
  ) {
    if (path.startsWith('http')) {
      return Image.network(
        path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _fallbackIconBox(context, size, fallbackIcon, w),
      );
    }
    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _fallbackIconBox(context, size, fallbackIcon, w),
    );
  }

  Widget _fallbackIconBox(BuildContext context, double size, IconData icon, double w) {
    return Container(
      width: size,
      height: size,
      color: AppColors.inputBg(context),
      child: Center(
        child: Icon(icon, color: AppColors.primaryPink, size: w * 0.06),
      ),
    );
  }

  Widget _divider(BuildContext context, double w, double h) {
    return Divider(
      color: AppColors.divider(context),
      thickness: 1,
      height: h * 0.005,
      indent: w * 0.155, // Adjusted to match image width + padding
    );
  }

  // =========================================================
  // PRICE ROW
  // =========================================================
  Widget _buildPriceRow(
    BuildContext context,
    double w,
    double h, {
    required String label,
    required String value,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? w * 0.04 : w * 0.036,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppColors.textPrimary(context) : AppColors.textSecondary(context),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? w * 0.045 : w * 0.036,
            fontWeight: FontWeight.bold,
            color: isTotal ? AppColors.primaryPink : AppColors.textPrimary(context),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // BOTTOM BAR
  // =========================================================
  Widget _buildBottomBar(
    BuildContext context,
    double w,
    double h,
    BookingSummaryProvider provider,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.015, w * 0.04, h * 0.02),
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
          text: context.tr('continue'),
          width: double.infinity,
          onTap: () {
            final updatedBooking = {
              ...bookingData,
              // Update details so that next screen gets everything properly
              'salonData': {
                ...salon,
                'name': salonName,
                'address': salonAddress,
                'rating': salonRating,
                'totalReviews': salonReviews,
                'image': salonImage,
              },
              'selectedServices': services,
              'subtotal': provider.subtotal,
              'serviceTax': provider.serviceTax,
              'totalAmount': provider.totalAmount,
              'durationMinutes': provider.durationMinutes,
            };

            // TODO: Navigate to S36 - Add Notes
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddNotesScreen(bookingData: updatedBooking),
              ),
            );

            debugPrint('S35 → S36: $updatedBooking');
          },
        ),
      ),
    );
  }
}
