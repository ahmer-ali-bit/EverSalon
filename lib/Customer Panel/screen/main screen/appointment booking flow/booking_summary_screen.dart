import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/appointment%20booking%20flow/booking_summary_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/appointment%20booking%20flow/add_note_screen.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingSummaryScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingSummaryScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingSummaryProvider()..init(bookingData),
      child: _BookingSummaryView(bookingData: bookingData),
    );
  }
}

class _BookingSummaryView extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const _BookingSummaryView({required this.bookingData});

  // -------------------------------------------------------------------
  // SAFE DATA READERS
  // -------------------------------------------------------------------
  String get flowType => bookingData['flowType']?.toString() ?? 'service';

  Map<String, dynamic> get salon {
    final raw = bookingData['salon'];
    return raw is Map ? Map<String, dynamic>.from(raw) : {};
  }

  Map<String, dynamic> get beautician {
    final raw = bookingData['beautician'];
    return raw is Map ? Map<String, dynamic>.from(raw) : {};
  }

  // Formatting strings
  String get formattedDate => bookingData['formattedDate']?.toString() ?? 'N/A';
  String get selectedTime => bookingData['selectedTime']?.toString() ?? 'N/A';

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<BookingSummaryProvider>();

    // Theme-aware colors
    final scaffoldBg = AppColors.scaffoldBg(context);
    final textPrimary = AppColors.textPrimary(context);
    final textSecondary = AppColors.textSecondary(context);
    final inputBg = AppColors.inputBg(context);
    final primaryPink = AppColors.primaryPink;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            // =================================================
            // HEADER
            // =================================================
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
                      context.tr('booking_summary'),
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

            // =================================================
            // BODY
            // =================================================
            Expanded(
              child: provider.isLoading
                  ? Center(child: CircularProgressIndicator(color: primaryPink))
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: h * 0.01),

                          // ── Salon Info Card ──
                          _buildSalonCard(
                            context,
                            w,
                            h,
                            inputBg,
                            textPrimary,
                            textSecondary,
                          ),

                          SizedBox(height: h * 0.025),

                          // ── DYNAMIC ITEM ROW (Service or Package) ──
                          if (flowType == 'package')
                            _buildPackageRow(
                              context,
                              w,
                              h,
                              primaryPink,
                              textPrimary,
                              textSecondary,
                            )
                          else
                            _buildServiceRow(
                              context,
                              w,
                              h,
                              primaryPink,
                              textPrimary,
                              textSecondary,
                            ),

                          _divider(w, h, textPrimary.withValues(alpha: 0.1)),

                          // ── Beautician Row ──
                          _buildDetailRow(
                            w,
                            h,
                            icon: Icons.person_outline_rounded,
                            label: context.tr('beautician'),
                            value: beautician['name']?.toString() ?? 'N/A',
                            primaryPink: primaryPink,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            imagePath: beautician['image']?.toString(),
                          ),

                          _divider(w, h, textPrimary.withValues(alpha: 0.1)),

                          // ── Date Row ──
                          _buildDetailRow(
                            w,
                            h,
                            icon: Icons.calendar_today_outlined,
                            label: context.tr('date'),
                            value: formattedDate,
                            primaryPink: primaryPink,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                          ),

                          _divider(w, h, textPrimary.withValues(alpha: 0.1)),

                          // ── Time Row ──
                          _buildDetailRow(
                            w,
                            h,
                            icon: Icons.access_time_rounded,
                            label: context.tr('time'),
                            value: selectedTime,
                            primaryPink: primaryPink,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                          ),

                          SizedBox(height: h * 0.03),

                          // ── Price Breakdown ──
                          Text(
                            context.tr('price_details'),
                            style: TextStyle(
                              fontSize: w * 0.042,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          SizedBox(height: h * 0.015),

                          _buildPriceRow(
                            w,
                            h,
                            label: context.tr('SubTotal'),
                            value: 'Rs. ${provider.subtotal}',
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                          ),
                          SizedBox(height: h * 0.01),
                          _buildPriceRow(
                            w,
                            h,
                            label: context.tr('Service Tax'),
                            value: 'Rs. ${provider.serviceTax}',
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                          ),
                          SizedBox(height: h * 0.012),
                          Divider(
                            color: textPrimary.withValues(alpha: 0.1),
                            thickness: 1,
                          ),
                          SizedBox(height: h * 0.012),
                          _buildPriceRow(
                            w,
                            h,
                            label: context.tr('total_amount'),
                            value: 'Rs. ${provider.totalAmount}',
                            isTotal: true,
                            primaryPink: primaryPink,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                          ),

                          SizedBox(height: h * 0.12),
                        ],
                      ),
                    ),
            ),

            // =================================================
            // BOTTOM BAR
            // =================================================
            _buildBottomBar(context, w, h, provider, scaffoldBg, textPrimary),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // WIDGET HELPERS
  // -------------------------------------------------------------------

  Widget _buildSalonCard(
    BuildContext context,
    double w,
    double h,
    Color inputBg,
    Color textPrimary,
    Color textSecondary,
  ) {
    final image = salon['image']?.toString() ?? '';
    return Container(
      padding: EdgeInsets.all(w * 0.035),
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(w * 0.035),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(w * 0.025),
            child: image.isNotEmpty
                ? Image.asset(
                    image,
                    width: w * 0.18,
                    height: w * 0.18,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(Icons.storefront),
                  )
                : Container(
                    width: w * 0.18,
                    height: w * 0.18,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.storefront),
                  ),
          ),
          SizedBox(width: w * 0.035),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  salon['name']?.toString() ?? 'Salon Name',
                  style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: h * 0.004),
                Text(
                  salon['address']?.toString() ?? 'Address',
                  style: TextStyle(fontSize: w * 0.032, color: textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: h * 0.006),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: w * 0.04),
                    SizedBox(width: w * 0.01),
                    Text(
                      '${salon['rating'] ?? '4.0'}',
                      style: TextStyle(
                        fontSize: w * 0.032,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
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

  // Shows selected services joined by comma
  Widget _buildServiceRow(
    BuildContext context,
    double w,
    double h,
    Color primaryPink,
    Color textPrimary,
    Color textSecondary,
  ) {
    final servicesList = bookingData['services'];
    String names = 'Service';
    if (servicesList is List && servicesList.isNotEmpty) {
      names = servicesList.map((s) => s['name'].toString()).join(', ');
    }

    return _buildDetailRow(
      w,
      h,
      icon: Icons.content_cut_rounded,
      label: context.tr('service'),
      value: names,
      primaryPink: primaryPink,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
    );
  }

  // Shows Package name and included items
  Widget _buildPackageRow(
    BuildContext context,
    double w,
    double h,
    Color primaryPink,
    Color textPrimary,
    Color textSecondary,
  ) {
    final pkg = bookingData['package'];
    String name = pkg?['name']?.toString() ?? 'Package';
    String includes = '';

    if (pkg != null && pkg['includes'] is List) {
      includes = (pkg['includes'] as List).join(' • ');
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.012),
      child: Row(
        children: [
          Container(
            width: w * 0.12,
            height: w * 0.12,
            decoration: BoxDecoration(
              color: primaryPink.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(w * 0.03),
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              color: primaryPink,
              size: w * 0.055,
            ),
          ),
          SizedBox(width: w * 0.035),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('package'),
                  style: TextStyle(fontSize: w * 0.03, color: textSecondary),
                ),
                SizedBox(height: h * 0.003),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: w * 0.038,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (includes.isNotEmpty) ...[
                  SizedBox(height: h * 0.002),
                  Text(
                    includes,
                    style: TextStyle(fontSize: w * 0.03, color: textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    double w,
    double h, {
    required IconData icon,
    required String label,
    required String value,
    String? imagePath,
    required Color primaryPink,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.012),
      child: Row(
        children: [
          if (imagePath != null && imagePath.isNotEmpty)
            Container(
              width: w * 0.12,
              height: w * 0.12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: textPrimary.withValues(alpha: 0.1)),
              ),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Icon(icon, color: primaryPink),
                ),
              ),
            )
          else
            Container(
              width: w * 0.12,
              height: w * 0.12,
              decoration: BoxDecoration(
                color: primaryPink.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(w * 0.03),
              ),
              child: Icon(icon, color: primaryPink, size: w * 0.055),
            ),
          SizedBox(width: w * 0.035),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: w * 0.03, color: textSecondary),
                ),
                SizedBox(height: h * 0.003),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: w * 0.038,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    double w,
    double h, {
    required String label,
    required String value,
    bool isTotal = false,
    Color? primaryPink,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? w * 0.04 : w * 0.036,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? textPrimary : textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? w * 0.045 : w * 0.036,
            fontWeight: FontWeight.bold,
            color: isTotal ? primaryPink : textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _divider(double w, double h, Color color) {
    return Divider(
      color: color,
      thickness: 1,
      height: h * 0.005,
      indent: w * 0.155,
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    double w,
    double h,
    BookingSummaryProvider provider,
    Color scaffoldBg,
    Color textPrimary,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.015, w * 0.04, h * 0.02),
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
          text: context.tr('Continue'),
          width: double.infinity,
          onTap: () {
            final updatedBooking = {
              ...bookingData,
              'subtotal': provider.subtotal,
              'serviceTax': provider.serviceTax,
              'totalAmount': provider.totalAmount,
            };

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AddNotesScreen(bookingData: updatedBooking),
              ),
            );
            debugPrint('S35 -> S36 Data: $updatedBooking');
          },
        ),
      ),
    );
  }
}
