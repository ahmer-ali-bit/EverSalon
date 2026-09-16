import 'package:flutter/material.dart';

class CancellationReasonProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSubmitting = false;
  bool _isDisposed = false;

  Map<String, dynamic> bookingData = {};

  final TextEditingController notesController = TextEditingController();

  final List<String> reasons = [
    'Change of plans',
    'Schedule conflict',
    'Found another salon',
    'Emergency / Personal reason',
    'Other',
  ];

  String selectedReason = 'Change of plans';

  void initData(Map<String, dynamic> data) {
    bookingData = Map<String, dynamic>.from(data);
    notifyListeners();
  }

  void selectReason(String reason) {
    selectedReason = reason;
    notifyListeners();
  }

  // ========================================================
  // TODO: BACKEND INTEGRATION - POST /api/bookings/{id}/cancel
  // Body: { "reason": selectedReason, "notes": notesController.text }
  // Cancellation Reason Screen
  // ========================================================
  Future<bool> submitCancellation() async {
    isSubmitting = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      bookingData = {
        ...bookingData,
        'status': 'cancelled',
        'cancellationReason': selectedReason,
        'cancellationNotes': notesController.text.trim(),
      };

      return true;
    } catch (e) {
      debugPrint('CancellationReason submit error: $e');
      return false;
    } finally {
      if (!_isDisposed) {
        isSubmitting = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    notesController.dispose();
    super.dispose();
  }
}
