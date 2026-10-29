import 'package:flutter/material.dart';

class AdminBookingDetailProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;
  bool isActionLoading = false;

  Map<String, dynamic> booking = {};

  AdminBookingDetailProvider({Map<String, dynamic>? initialData}) {
    if (initialData != null) {
      booking = Map<String, dynamic>.from(initialData);
      _sanitizeInitialData();
      isLoading = false;
    } else {
      _fetchDetail();
    }
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  void _sanitizeInitialData() {
    booking['rescheduleRequested'] ??=
        booking['status'] == 'Reschedule Pending';
    booking['requestedDate'] ??= '18 May 2024';
    booking['requestedTime'] ??= '02:30 PM';
    booking['cancellationReason'] ??= 'Sudden personal emergency occurred.';
    booking['cancellationNotes'] ??=
        'Client called and apologized for the late cancellation.';
  }

  Future<void> _fetchDetail() async {
    isLoading = true;
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 400));

    booking = {
      'id': 'ESR1240516',
      'bookingId': 'ESR1240516',
      'customerName': 'Sara Khan',
      'customerPhone': '+92 300 1234567',
      'customerAvatar': 'assets/images/users/sara.png',
      'service': 'Hair Spa Treatment',
      'staffName': 'Anaya Khan',
      'staffRole': 'Senior Stylist',
      'date': '15 May 2024',
      'time': '10:00 AM',
      'duration': '60 mins',
      'amount': 'Rs. 2,000',
      'paymentMethod': 'Card',
      'paymentStatus':
          'Paid', // Custom Statuses: Paid | Unpaid | Forfeited | Refunded
      'status': 'Confirmed',
      'notes': 'Sensitive skin, prefer less heat on hair.',
      'salonName': 'My Salon',
      'rescheduleRequested': false,
      'requestedDate': '18 May 2024',
      'requestedTime': '02:30 PM',
      'cancellationReason': '',
      'cancellationNotes': '',
    };

    isLoading = false;
    _safeNotify();
  }

  Future<bool> updateStatus(String newStatus) async {
    isActionLoading = true;
    _safeNotify();

    // TODO: BACKEND - PATCH /api/admin/bookings/:id/status
    await Future.delayed(const Duration(milliseconds: 600));

    booking['status'] = newStatus;
    if (newStatus == 'Cancelled') {
      booking['cancellationReason'] ??= 'Cancelled by Salon Administration';
    }

    isActionLoading = false;
    _safeNotify();
    return true;
  }

  Future<bool> resolveReschedule(bool approved) async {
    isActionLoading = true;
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 650));

    if (approved) {
      booking['date'] = booking['requestedDate'];
      booking['time'] = booking['requestedTime'];
      booking['status'] = 'Confirmed';
    } else {
      booking['status'] = 'Confirmed';
    }

    booking['rescheduleRequested'] = false;
    isActionLoading = false;
    _safeNotify();
    return true;
  }

  // ✅ UPGRADED: Handle No-Show with Refund/Forfeit Policy
  // API Endpoint: PATCH /api/admin/bookings/{id}/no-show
  // Body: { "paymentAction": "forfeit" / "refund" / "none" }
  Future<bool> markAsNoShow({required String paymentAction}) async {
    isActionLoading = true;
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 500));

    booking['status'] = 'No-Show';

    if (paymentAction == 'forfeit') {
      booking['paymentStatus'] = 'Forfeited'; // Keep advanced money
    } else if (paymentAction == 'refund') {
      booking['paymentStatus'] = 'Refunded'; // Return money
    } else {
      booking['paymentStatus'] = 'Unpaid'; // Standard unpaid case (Cash option)
    }

    isActionLoading = false;
    _safeNotify();
    return true;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
