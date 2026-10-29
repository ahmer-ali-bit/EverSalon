import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Customer%20Panel/provider/appointment%20booking%20flow/booking_confirmation_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/appointment%20booking%20flow/qr_check_in_screen.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingConfirmationScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingConfirmationProvider()..confirmBooking(bookingData),
      child: _BookingConfirmationView(bookingData: bookingData),
    );
  }
}

class _BookingConfirmationView extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const _BookingConfirmationView({required this.bookingData});

  // ---------- SAFE DATA READERS ----------
  String get flowType => bookingData['flowType']?.toString() ?? 'service';

  Map<String, dynamic> get salon {
    final raw = bookingData['salon'] ?? bookingData['salonData'];
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {};
  }

  String get salonName =>
      salon['name']?.toString() ??
      bookingData['salonName']?.toString() ??
      'Salon';

  Map<String, dynamic> get beautician {
    final raw = bookingData['beautician'] ?? bookingData['selectedBeautician'];
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {};
  }

  String get beauticianName => beautician['name']?.toString() ?? 'N/A';

  /// Service names OR package name safely
  String get itemLabel {
    if (flowType == 'package') {
      final pkg = bookingData['package'];
      if (pkg is Map) return pkg['name']?.toString() ?? 'Package';
      return bookingData['packageName']?.toString() ?? 'Package';
    }
    // Service flow
    final services = bookingData['services'] ?? bookingData['selectedServices'];
    if (services is List && services.isNotEmpty) {
      return services
          .whereType<Map>()
          .map((s) => s['name']?.toString() ?? '')
          .where((n) => n.isNotEmpty)
          .join(', ');
    }
    return bookingData['serviceName']?.toString() ?? 'Service';
  }

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
    return '$dateShort  ·  $selectedTime';
  }

  int get totalPaid {
    final raw =
        bookingData['totalAmount'] ??
        bookingData['subtotal'] ??
        bookingData['servicesTotal'] ??
        bookingData['packagePrice'] ??
        0;
    if (raw is int) return raw;
    if (raw is double) return raw.round();
    return int.tryParse(raw.toString()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<BookingConfirmationProvider>();

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
                      vertical: h * 0.01,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          },
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
                        const Spacer(),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                      child: Column(
                        children: [
                          SizedBox(height: h * 0.02),

                          // ── SUCCESS IMAGE ──
                          Image.asset(
                            'assets/images/booking confirm.png',
                            width: w * 0.45,
                            height: w * 0.45,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => Container(
                              width: w * 0.45,
                              height: w * 0.45,
                              decoration: BoxDecoration(
                                color: primaryPink.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: primaryPink,
                                size: w * 0.22,
                              ),
                            ),
                          ),

                          SizedBox(height: h * 0.025),

                          Text(
                            context.tr('booking_confirmed'),
                            style: TextStyle(
                              fontSize: w * 0.055,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: h * 0.01),

                          Text(
                            context.tr(
                              'Your appointment has been booked\nsuccessfully.',
                            ),
                            style: TextStyle(
                              fontSize: w * 0.036,
                              color: textSecondary,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: h * 0.035),

                          // ── DETAILS CARD ──
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(w * 0.045),
                            decoration: BoxDecoration(
                              color: scaffoldBg,
                              borderRadius: BorderRadius.circular(w * 0.04),
                              border: Border.all(color: borderColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Salon Name
                                Row(
                                  children: [
                                    Icon(
                                      Icons.storefront_rounded,
                                      color: primaryPink,
                                      size: w * 0.05,
                                    ),
                                    SizedBox(width: w * 0.025),
                                    Expanded(
                                      child: Text(
                                        salonName,
                                        style: TextStyle(
                                          fontSize: w * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: h * 0.015),
                                Divider(color: borderColor, height: 1),
                                SizedBox(height: h * 0.015),

                                // Date & Time
                                _detailLine(
                                  w,
                                  icon: Icons.calendar_today_outlined,
                                  text: dateTimeLabel,
                                  textPrimary: textPrimary,
                                  textSecondary: textSecondary,
                                ),
                                SizedBox(height: h * 0.012),

                                // Beautician & Service/Package
                                _detailLine(
                                  w,
                                  icon: Icons.person_outline_rounded,
                                  text: '$beauticianName  ·  $itemLabel',
                                  textPrimary: textPrimary,
                                  textSecondary: textSecondary,
                                ),

                                SizedBox(height: h * 0.015),
                                Divider(color: borderColor, height: 1),
                                SizedBox(height: h * 0.015),

                                // Total Paid
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context.tr('total_paid'),
                                      style: TextStyle(
                                        fontSize: w * 0.038,
                                        fontWeight: FontWeight.w600,
                                        color: textPrimary,
                                      ),
                                    ),
                                    Text(
                                      'Rs. $totalPaid',
                                      style: TextStyle(
                                        fontSize: w * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: primaryPink,
                                      ),
                                    ),
                                  ],
                                ),

                                if (provider.bookingId != null) ...[
                                  SizedBox(height: h * 0.012),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        context.tr('booking_id'),
                                        style: TextStyle(
                                          fontSize: w * 0.032,
                                          color: textSecondary,
                                        ),
                                      ),
                                      Text(
                                        provider.bookingId!,
                                        style: TextStyle(
                                          fontSize: w * 0.032,
                                          fontWeight: FontWeight.w600,
                                          color: textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],

                                if (bookingData['paymentStatus'] ==
                                    'pay_at_salon') ...[
                                  SizedBox(height: h * 0.01),
                                  Text(
                                    context.tr('Pay at Salon'),
                                    style: TextStyle(
                                      fontSize: w * 0.03,
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          SizedBox(height: h * 0.04),
                        ],
                      ),
                    ),
                  ),

                  // ── BOTTOM ACTIONS ──
                  _buildBottomButtons(
                    context,
                    w,
                    h,
                    provider,
                    scaffoldBg,
                    primaryPink,
                    textPrimary,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _detailLine(
    double w, {
    required IconData icon,
    required String text,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Row(
      children: [
        Icon(icon, color: textSecondary, size: w * 0.045),
        SizedBox(width: w * 0.025),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: w * 0.035,
              color: textPrimary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(
    BuildContext context,
    double w,
    double h,
    BookingConfirmationProvider provider,
    Color scaffoldBg,
    Color primaryPink,
    Color textPrimary,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.01, w * 0.04, h * 0.02),
      color: scaffoldBg,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              text: context.tr('view_my_bookings'),
              width: double.infinity,
              onTap: () {
                final dataForNext = {
                  ...bookingData,
                  'bookingId': provider.bookingId,
                  'status': 'upcoming',
                };
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QrCheckInScreen(bookingData: dataForNext),
                  ),
                );
              },
            ),

            SizedBox(height: h * 0.015),

            GestureDetector(
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: h * 0.01),
                child: Text(
                  context.tr('back_to_home'),
                  style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.w600,
                    color: primaryPink,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
