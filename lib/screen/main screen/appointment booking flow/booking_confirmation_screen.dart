import 'package:ever_salon/provider/appointment%20booking%20flow/booking_confirmation_provider.dart';
import 'package:ever_salon/screen/main%20screen/appointment%20booking%20flow/qr_check_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_button.dart';
// TODO: QR Check-in / Home / My Bookings screens ke imports
// import 'package:ever_salon/screen/booking/qr_check_in_screen.dart';
// import 'package:ever_salon/screen/main_screen/home_screen.dart';
// import 'package:ever_salon/screen/main_screen/my_bookings_screen.dart';

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

  // ---------- Safe data readers ----------
  Map<String, dynamic> get salon {
    final raw = bookingData['salonData'] ?? bookingData['salon'];
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {};
  }

  String get salonName =>
      salon['name']?.toString() ??
      bookingData['salonName']?.toString() ??
      'Glow Beauty Lounge';

  Map<String, dynamic> get beautician {
    final raw = bookingData['beautician'] ?? bookingData['selectedBeautician'];
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {};
  }

  String get beauticianName => beautician['name']?.toString() ?? 'N/A';

  List<Map<String, dynamic>> get services {
    final raw = bookingData['selectedServices'] ?? bookingData['services'];
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return [];
  }

  String get serviceNames {
    if (services.isEmpty) {
      return bookingData['serviceName']?.toString() ?? 'Haircut & Styling';
    }
    return services
        .map((s) => s['name']?.toString() ?? '')
        .where((n) => n.isNotEmpty)
        .join(', ');
  }

  String get formattedDate =>
      bookingData['formattedDate']?.toString() ??
      bookingData['selectedDate']?.toString() ??
      'N/A';

  String get selectedTime => bookingData['selectedTime']?.toString() ?? 'N/A';

  String get dateTimeLabel {
    // "Wed, 15 May 2024 · 11:00 AM"
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
    return bookingData['totalAmount'] as int? ??
        bookingData['grandTotal'] as int? ??
        bookingData['totalServicePrice'] as int? ??
        0;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<BookingConfirmationProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryPink),
              )
            : Column(
                children: [
                  // =================================================
                  // HEADER (minimal — no back on success usually,
                  // but design shows small back; keep for safety)
                  // =================================================
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.04,
                      vertical: h * 0.01,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Success ke baad back = home
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          },
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

                          // =================================================
                          // SUCCESS IMAGE — booking_confirm.png
                          // =================================================
                          Image.asset(
                            'assets/images/booking confirm.png',
                            width: w * 0.45,
                            height: w * 0.45,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => Container(
                              width: w * 0.45,
                              height: w * 0.45,
                              decoration: BoxDecoration(
                                color: AppColors.primaryPink.withValues(
                                  alpha: 0.08,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.primaryPink,
                                size: w * 0.22,
                              ),
                            ),
                          ),

                          SizedBox(height: h * 0.025),

                          // Title
                          Text(
                            context.tr('booking_confirmed'),
                            style: TextStyle(
                              fontSize: w * 0.055,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: h * 0.01),

                          // Subtitle
                          Text(
                            context.tr('appointment_booked'),
                            style: TextStyle(
                              fontSize: w * 0.036,
                              color: AppColors.textSecondary(context),
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: h * 0.035),

                          // =================================================
                          // BOOKING DETAILS CARD
                          // =================================================
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(w * 0.045),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg(context),
                              borderRadius: BorderRadius.circular(w * 0.04),
                              border: Border.all(
                                color: AppColors.divider(context),
                              ),
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
                                // Salon name
                                Row(
                                  children: [
                                    Icon(
                                      Icons.storefront_rounded,
                                      color: AppColors.primaryPink,
                                      size: w * 0.05,
                                    ),
                                    SizedBox(width: w * 0.025),
                                    Expanded(
                                      child: Text(
                                        salonName,
                                        style: TextStyle(
                                          fontSize: w * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary(context),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: h * 0.015),
                                Divider(
                                  color: AppColors.divider(context),
                                  height: 1,
                                ),
                                SizedBox(height: h * 0.015),

                                // Date & Time
                                _detailLine(
                                  context,
                                  w,
                                  h,
                                  icon: Icons.calendar_today_outlined,
                                  text: dateTimeLabel,
                                ),
                                SizedBox(height: h * 0.012),

                                // Beautician · Service
                                _detailLine(
                                  context,
                                  w,
                                  h,
                                  icon: Icons.person_outline_rounded,
                                  text: '$beauticianName  ·  $serviceNames',
                                ),
                                SizedBox(height: h * 0.015),
                                Divider(
                                  color: AppColors.divider(context),
                                  height: 1,
                                ),
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
                                        color: AppColors.textPrimary(context),
                                      ),
                                    ),
                                    Text(
                                      '${context.tr('rs')} $totalPaid',
                                      style: TextStyle(
                                        fontSize: w * 0.045,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryPink,
                                      ),
                                    ),
                                  ],
                                ),

                                // Booking ID (optional small)
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
                                          color: AppColors.textSecondary(context),
                                        ),
                                      ),
                                      Text(
                                        provider.bookingId!,
                                        style: TextStyle(
                                          fontSize: w * 0.032,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary(context),
                                        ),
                                      ),
                                    ],
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

                  // =================================================
                  // BOTTOM BUTTONS
                  // =================================================
                  _buildBottomButtons(context, w, h, provider),
                ],
              ),
      ),
    );
  }

  Widget _detailLine(
    BuildContext context,
    double w,
    double h, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary(context), size: w * 0.045),
        SizedBox(width: w * 0.025),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: w * 0.035,
              color: AppColors.textPrimary(context),
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
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(w * 0.04, h * 0.01, w * 0.04, h * 0.02),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // View My Bookings
            CustomButton(
              text: context.tr('view_my_bookings'),
              width: double.infinity,
              onTap: () {
                final dataForNext = {
                  ...bookingData,
                  'bookingId': provider.bookingId,
                };

                // TODO: Navigate to My Bookings screen
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
                //   (route) => false,
                // );

                // Temporary: go to QR Check-in (S40) if you want
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QrCheckInScreen(bookingData: dataForNext),
                  ),
                );

                debugPrint('View My Bookings → $dataForNext');
              },
            ),

            SizedBox(height: h * 0.015),

            // Back to Home
            GestureDetector(
              onTap: () {
                // Clear stack → Home
                Navigator.of(context).popUntil((route) => route.isFirst);

                // TODO: Agar named routes / bottom nav index set karna ho:
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(builder: (_) => const HomeScreen()),
                //   (route) => false,
                // );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: h * 0.01),
                child: Text(
                  context.tr('back_to_home'),
                  style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryPink,
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
