import 'package:flutter/material.dart';

class BookingDetailsProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isDownloading = false;
  bool _isDisposed = false;

  Map<String, dynamic> bookingData = {};

  void initData(Map<String, dynamic> data) {
    bookingData = Map<String, dynamic>.from(data);
    notifyListeners();
  }

  // ========================================================
  // TODO: BACKEND INTEGRATION - GET /api/bookings/{bookingId}
  // Full booking details refresh (optional)
  // ========================================================
  Future<void> fetchBookingDetails(String bookingId) async {
    isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 400));
      // TODO: replace mock with API response merge into bookingData
    } catch (e) {
      debugPrint('BookingDetails fetch error: $e');
    } finally {
      if (!_isDisposed) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  // ========================================================
  // TODO: BACKEND INTEGRATION - GET /api/bookings/{id}/invoice
  // Download / open invoice PDF
  // ========================================================
  Future<bool> downloadInvoice() async {
    isDownloading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      // TODO: download PDF / open URL from API
      return true;
    } catch (e) {
      debugPrint('Invoice download error: $e');
      return false;
    } finally {
      if (!_isDisposed) {
        isDownloading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
