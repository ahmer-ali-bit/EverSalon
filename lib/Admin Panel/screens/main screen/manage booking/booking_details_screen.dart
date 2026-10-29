import 'dart:io';
import 'package:ever_salon/Admin%20Panel/providers/manage%20booking/booking_details_provider.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/manage%20booking/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class AdminBookingDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? bookingData;

  const AdminBookingDetailScreen({super.key, this.bookingData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminBookingDetailProvider(initialData: bookingData),
      child: const _AdminBookingDetailContent(),
    );
  }
}

class _AdminBookingDetailContent extends StatelessWidget {
  const _AdminBookingDetailContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminBookingDetailProvider>();
    final b = provider.booking;
    final status = (b['status'] ?? 'Pending').toString();
    final rescheduleRequested =
        b['rescheduleRequested'] == true || status == 'Reschedule Pending';

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
                          onTap: () => Navigator.pop(context, b),
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
                            context.tr('Booking Details'),
                            style: TextStyle(
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                        ),
                        _statusChip(context, w, status),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.01,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // RESCHEDULE PANEL
                          if (rescheduleRequested && !provider.isActionLoading)
                            _buildRescheduleRequestAlert(
                              context,
                              provider,
                              b,
                              w,
                              h,
                            ),

                          // CANCELLATION PANEL
                          if (status == 'Cancelled')
                            _buildCancellationReasonCard(context, b, w, h),

                          // CUSTOMER PROFILE CARD
                          _sectionCard(
                            context,
                            w,
                            child: Row(
                              children: [
                                _avatar(
                                  context,
                                  w,
                                  b['customerAvatar']?.toString() ?? '',
                                ),
                                SizedBox(width: w * 0.03),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        b['customerName']?.toString() ??
                                            'Customer',
                                        style: TextStyle(
                                          fontSize: w * 0.042,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary(context),
                                        ),
                                      ),
                                      SizedBox(height: w * 0.01),
                                      Text(
                                        b['customerPhone']?.toString() ?? '',
                                        style: TextStyle(
                                          fontSize: w * 0.032,
                                          color: AppColors.textSecondary(
                                            context,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.phone_outlined,
                                    color: AppColors.primaryPink,
                                    size: w * 0.06,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${context.tr("Calling")} ${b["customerName"]}...',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: h * 0.02),

                          // BOOKING INFO
                          Text(
                            context.tr('Appointment Info'),
                            style: TextStyle(
                              fontSize: w * 0.04,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.012),
                          _sectionCard(
                            context,
                            w,
                            child: Column(
                              children: [
                                _infoRow(
                                  context,
                                  w,
                                  'Booking ID',
                                  b['bookingId']?.toString() ??
                                      b['id']?.toString() ??
                                      '',
                                ),
                                _divider(context),
                                _infoRow(
                                  context,
                                  w,
                                  'Service',
                                  b['service']?.toString() ?? '',
                                ),
                                _divider(context),
                                _infoRow(
                                  context,
                                  w,
                                  'Staff',
                                  b['staffName']?.toString() ?? 'Any',
                                ),
                                _divider(context),
                                _infoRow(
                                  context,
                                  w,
                                  'Date',
                                  b['date']?.toString() ?? '',
                                ),
                                _divider(context),
                                _infoRow(
                                  context,
                                  w,
                                  'Time',
                                  b['time']?.toString() ?? '',
                                ),
                                _divider(context),
                                _infoRow(
                                  context,
                                  w,
                                  'Duration',
                                  b['duration']?.toString() ?? '',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: h * 0.02),

                          // PAYMENT
                          Text(
                            context.tr('Payment'),
                            style: TextStyle(
                              fontSize: w * 0.04,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.012),
                          _sectionCard(
                            context,
                            w,
                            child: Column(
                              children: [
                                _infoRow(
                                  context,
                                  w,
                                  'Amount',
                                  b['amount']?.toString() ?? '',
                                ),
                                _divider(context),
                                _infoRow(
                                  context,
                                  w,
                                  'Method',
                                  b['paymentMethod']?.toString() ?? '',
                                ),
                                _divider(context),
                                _infoRow(
                                  context,
                                  w,
                                  'Payment Status',
                                  b['paymentStatus']?.toString() ?? '',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: h * 0.02),

                          // NOTES
                          if ((b['notes']?.toString() ?? '').isNotEmpty) ...[
                            Text(
                              context.tr('Customer Notes'),
                              style: TextStyle(
                                fontSize: w * 0.04,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                            SizedBox(height: h * 0.012),
                            _sectionCard(
                              context,
                              w,
                              child: Text(
                                b['notes'].toString(),
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  color: AppColors.textSecondary(context),
                                  height: 1.4,
                                ),
                              ),
                            ),
                            SizedBox(height: h * 0.02),
                          ],

                          // QR CHECK-IN ENTRY (ONLY FOR PENDING BOOKINGS)
                          if (status == 'Pending') ...[
                            GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const AdminQrScannerScreen(),
                                  ),
                                );

                                if (result == true && context.mounted) {
                                  provider.updateStatus('Confirmed');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        context.tr(
                                          'Customer checked-in & Booking Confirmed!',
                                        ),
                                      ),
                                      backgroundColor: AppColors.success,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: h * 0.018,
                                  horizontal: w * 0.04,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.inputBg(context),
                                  borderRadius: BorderRadius.circular(w * 0.03),
                                  border: Border.all(
                                    color: AppColors.primaryPink.withValues(
                                      alpha: 0.3,
                                    ),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.qr_code_scanner,
                                      color: AppColors.primaryPink,
                                      size: w * 0.06,
                                    ),
                                    SizedBox(width: w * 0.03),
                                    Expanded(
                                      child: Text(
                                        context.tr('Scan QR / Check-in'),
                                        style: TextStyle(
                                          fontSize: w * 0.038,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryPink,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: w * 0.035,
                                      color: AppColors.primaryPink,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: h * 0.02),
                          ],

                          SizedBox(height: h * 0.12),
                        ],
                      ),
                    ),
                  ),

                  // BOTTOM ACTIONS
                  if (!provider.isActionLoading)
                    _bottomActions(context, w, h, provider, status, b)
                  else
                    Padding(
                      padding: EdgeInsets.all(w * 0.04),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryPink,
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Widget _buildRescheduleRequestAlert(
    BuildContext context,
    AdminBookingDetailProvider provider,
    Map<String, dynamic> b,
    double w,
    double h,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: h * 0.02),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: AppColors.primaryPurple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(
          color: AppColors.primaryPurple.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.primaryPurple,
                size: 20,
              ),
              SizedBox(width: w * 0.02),
              Text(
                context.tr('Reschedule Request Pending'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryPurple,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.01),
          Text(
            'Requested Slot: ${b["requestedDate"]} at ${b["requestedTime"]}',
            style: TextStyle(
              fontSize: w * 0.032,
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: h * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => provider.resolveReschedule(false),
                child: Text(
                  context.tr('Reject'),
                  style: const TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: w * 0.03),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => provider.resolveReschedule(true),
                child: Text(context.tr('Approve')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCancellationReasonCard(
    BuildContext context,
    Map<String, dynamic> b,
    double w,
    double h,
  ) {
    final reason =
        b['cancellationReason']?.toString() ?? 'No specific reason reported';
    final notes = b['cancellationNotes']?.toString() ?? '';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: h * 0.025),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.cancel_presentation_sharp,
                color: AppColors.error,
                size: 20,
              ),
              SizedBox(width: w * 0.02),
              Text(
                context.tr('Cancellation Log'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.01),
          Text(
            'Reason: "$reason"',
            style: TextStyle(
              fontSize: w * 0.035,
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          if (notes.isNotEmpty) ...[
            SizedBox(height: h * 0.005),
            Text(
              'Additional Notes: $notes',
              style: TextStyle(
                fontSize: w * 0.03,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _bottomActions(
    BuildContext context,
    double w,
    double h,
    AdminBookingDetailProvider provider,
    String status,
    Map<String, dynamic> b,
  ) {
    if (status == 'Completed' || status == 'Cancelled' || status == 'No-Show') {
      return Padding(
        padding: EdgeInsets.fromLTRB(w * 0.04, 0, w * 0.04, h * 0.02),
        child: SizedBox(
          width: double.infinity,
          height: h * 0.06,
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context, provider.booking),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryPink),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(w * 0.08),
              ),
            ),
            child: Text(
              context.tr('Back to Bookings'),
              style: TextStyle(
                color: AppColors.primaryPink,
                fontWeight: FontWeight.bold,
                fontSize: w * 0.038,
              ),
            ),
          ),
        ),
      );
    }

    if (status == 'Pending') {
      return Container(
        padding: EdgeInsets.fromLTRB(w * 0.04, w * 0.03, w * 0.04, h * 0.02),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: h * 0.058,
            child: OutlinedButton(
              onPressed: () async {
                final ok = await provider.updateStatus('Cancelled');
                if (ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.tr('Booking cancelled')),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.error.withValues(alpha: 0.7)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(w * 0.08),
                ),
              ),
              child: Text(
                context.tr('Cancel Booking'),
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.038,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // CONFIRMED BOOKINGS (COMPLETE, NO-SHOW, OR CANCEL ACTIONS):
    return Container(
      padding: EdgeInsets.fromLTRB(w * 0.04, w * 0.03, w * 0.04, h * 0.02),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: _outlineBtn(
                    context,
                    w,
                    h,
                    'Cancel',
                    AppColors.error,
                    () async {
                      await provider.updateStatus('Cancelled');
                    },
                  ),
                ),
                SizedBox(width: w * 0.03),
                Expanded(
                  flex: 2,
                  child: _fillBtn(context, w, h, 'Mark Complete', () async {
                    final ok = await provider.updateStatus('Completed');
                    if (ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.tr('Booking completed')),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  }),
                ),
              ],
            ),
            SizedBox(height: h * 0.015),
            SizedBox(
              width: double.infinity,
              height: h * 0.045,
              child: TextButton.icon(
                icon: const Icon(
                  Icons.person_off_outlined,
                  color: Colors.amber,
                  size: 16,
                ),
                label: Text(
                  context.tr('Mark as Customer No-Show'),
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                onPressed: () => _handleNoShowAction(context, provider, b),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ NEW: Handle advanced online payment conditions upon No-Show trigger
  void _handleNoShowAction(
    BuildContext context,
    AdminBookingDetailProvider provider,
    Map<String, dynamic> b,
  ) {
    final isAlreadyPaid = b['paymentStatus'] == 'Paid';

    if (!isAlreadyPaid) {
      // Direct action if booking is unpaid (Standard Cash flow)
      provider.markAsNoShow(paymentAction: 'none').then((ok) {
        if (ok && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.tr(
                  'Customer registered as No-Show. Status updated to Unpaid.',
                ),
              ),
              backgroundColor: Colors.amber,
            ),
          );
        }
      });
      return;
    }

    // Trigger Decision Dialog for Advanced Online Paid Bookings
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('Paid No-Show Policy')),
        content: Text(
          context.tr(
            'This customer has already paid Rs. ${b["amount"]} via Online/Card. How would you like to handle the funds?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.tr('Cancel'),
              style: const TextStyle(color: AppColors.textGrey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              provider.markAsNoShow(paymentAction: 'forfeit');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.tr('Customer marked as No-Show. Funds Forfeited.'),
                  ),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: Text(context.tr('Forfeit (Keep Money)')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              provider.markAsNoShow(paymentAction: 'refund');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.tr(
                      'Customer marked as No-Show. Refund Dispatched.',
                    ),
                  ),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(context.tr('Refund Customer')),
          ),
        ],
      ),
    );
  }

  Widget _fillBtn(
    BuildContext context,
    double w,
    double h,
    String text,
    VoidCallback onTap,
  ) {
    return SizedBox(
      height: h * 0.058,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPink,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(w * 0.08),
          ),
        ),
        child: Text(
          context.tr(text),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: w * 0.036,
          ),
        ),
      ),
    );
  }

  Widget _outlineBtn(
    BuildContext context,
    double w,
    double h,
    String text,
    Color color,
    VoidCallback onTap,
  ) {
    return SizedBox(
      height: h * 0.058,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withValues(alpha: 0.7)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(w * 0.08),
          ),
        ),
        child: Text(
          context.tr(text),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: w * 0.036,
          ),
        ),
      ),
    );
  }

  Widget _statusChip(BuildContext context, double w, String status) {
    Color c;
    if (status == 'Confirmed') {
      c = AppColors.success;
    } else if (status == 'Pending') {
      c = Colors.orange;
    } else if (status == 'Completed') {
      c = Colors.blue;
    } else if (status == 'Reschedule Pending') {
      c = AppColors.primaryPurple;
    } else if (status == 'No-Show') {
      c = Colors.amber;
    } else {
      c = AppColors.error;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.015),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(w * 0.02),
        border: Border.all(color: c.withValues(alpha: 0.4)),
      ),
      child: Text(
        context.tr(status),
        style: TextStyle(
          fontSize: w * 0.028,
          fontWeight: FontWeight.bold,
          color: c,
        ),
      ),
    );
  }

  Widget _sectionCard(BuildContext context, double w, {required Widget child}) {
    return Container(
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
      child: child,
    );
  }

  Widget _infoRow(BuildContext context, double w, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: w * 0.015),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: w * 0.32,
            child: Text(
              context.tr(label),
              style: TextStyle(
                fontSize: w * 0.033,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: w * 0.033,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(height: 1, color: AppColors.inputBg(context));
  }

  Widget _avatar(BuildContext context, double w, String path) {
    ImageProvider? img;
    if (path.isNotEmpty) {
      if (path.startsWith('assets/')) {
        img = AssetImage(path);
      } else {
        img = FileImage(File(path));
      }
    }
    return CircleAvatar(
      radius: w * 0.065,
      backgroundColor: AppColors.inputBg(context),
      backgroundImage: img,
      onBackgroundImageError: img != null ? (_, _) {} : null,
      child: img == null
          ? Icon(Icons.person, color: AppColors.textGrey, size: w * 0.06)
          : null,
    );
  }
}
