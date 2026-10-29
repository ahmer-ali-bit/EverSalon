import 'package:flutter/material.dart';

class AvailableTimeSlotsProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND - GET /api/salons/{salonId}/time-slots
  // Query: ?date=YYYY-MM-DD&beauticianId=xxx
  // ========================================================

  bool isLoading = false;

  /// Localization keys for tabs
  final List<String> periods = ['morning', 'afternoon', 'evening'];
  String selectedPeriod = 'morning';
  String? selectedTime;

  /// Mock slots — always present (backend response se replace hoga)
  final Map<String, List<String>> _allSlots = {
    'morning': [
      '09:00 AM',
      '09:30 AM',
      '10:00 AM',
      '10:30 AM',
      '11:00 AM',
      '11:30 AM',
    ],
    'afternoon': [
      '12:00 PM',
      '12:30 PM',
      '01:00 PM',
      '01:30 PM',
      '02:00 PM',
      '02:30 PM',
      '03:00 PM',
      '03:30 PM',
    ],
    'evening': [
      '04:00 PM',
      '04:30 PM',
      '05:00 PM',
      '05:30 PM',
      '06:00 PM',
      '06:30 PM',
      '07:00 PM',
      '07:30 PM',
    ],
  };

  List<String> get currentSlots {
    return List<String>.from(_allSlots[selectedPeriod] ?? []);
  }

  /// Call once when screen opens
  void init(Map<String, dynamic> bookingData) {
    // bookingData se date / beautician nikal sakte ho API ke liye
    // final date = bookingData['selectedDate'];
    // final beauticianId = bookingData['beautician']?['id'];
    // final salonId = bookingData['salon']?['id'];
    fetchTimeSlots();
  }

  Future<void> fetchTimeSlots() async {
    // IMPORTANT: slots clear NAHI karte — isliye UI flicker nahi hota
    isLoading = true;
    selectedTime = null; // sirf selection reset
    notifyListeners();

    try {
      // TODO: real API call
      // final response = await api.getTimeSlots(...);
      // _allSlots['morning'] = response.morning;
      // _allSlots['afternoon'] = response.afternoon;
      // _allSlots['evening'] = response.evening;

      await Future.delayed(const Duration(milliseconds: 250));
    } catch (e) {
      debugPrint('Error fetching time slots: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectPeriod(String periodKey) {
    if (selectedPeriod == periodKey) return;
    selectedPeriod = periodKey;
    // period change pe pehle se selected time clear (optional)
    // selectedTime = null;
    notifyListeners();
  }

  void selectTime(String time) {
    selectedTime = time;
    notifyListeners();
  }

  bool isTimeSelected(String time) => selectedTime == time;
}
