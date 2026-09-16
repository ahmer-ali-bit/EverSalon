import 'package:flutter/material.dart';

class AvailableTimeSlotsProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND INTEGRATION - GET /api/salons/{salonId}/time-slots
  // Query parameters: ?date=2024-05-15&beauticianId=xxx
  // ========================================================

  bool isLoading = false;

  // Periods / Tabs
  final List<String> periods = ['Morning', 'Afternoon', 'Evening'];
  String selectedPeriod = 'Morning';

  // Selected time slot
  String? selectedTime;

  // Mock Slots Data — All slots set to available
  final Map<String, List<Map<String, dynamic>>> _allSlots = {
    'Morning': [
      {'time': '09:00 AM', 'available': true},
      {'time': '09:30 AM', 'available': true},
      {'time': '10:00 AM', 'available': true},
      {'time': '10:30 AM', 'available': true},
      {'time': '11:00 AM', 'available': true},
      {'time': '11:30 AM', 'available': true},
    ],
    'Afternoon': [
      {'time': '12:00 PM', 'available': true},
      {'time': '12:30 PM', 'available': true},
      {'time': '01:00 PM', 'available': true},
      {'time': '01:30 PM', 'available': true},
      {'time': '02:00 PM', 'available': true},
      {'time': '02:30 PM', 'available': true},
      {'time': '03:00 PM', 'available': true},
      {'time': '03:30 PM', 'available': true},
    ],
    'Evening': [
      {'time': '04:00 PM', 'available': true},
      {'time': '04:30 PM', 'available': true},
      {'time': '05:00 PM', 'available': true},
      {'time': '05:30 PM', 'available': true},
      {'time': '06:00 PM', 'available': true},
      {'time': '06:30 PM', 'available': true},
      {'time': '07:00 PM', 'available': true},
      {'time': '07:30 PM', 'available': true},
    ],
  };

  List<Map<String, dynamic>> get currentSlots {
    return List<Map<String, dynamic>>.from(_allSlots[selectedPeriod] ?? []);
  }

  void init({
    required String salonId,
    required String date,
    String? beauticianId,
  }) {
    fetchTimeSlots(salonId: salonId, date: date, beauticianId: beauticianId);
  }

  Future<void> fetchTimeSlots({
    required String salonId,
    required String date,
    String? beauticianId,
  }) async {
    isLoading = true;
    selectedTime = null;
    notifyListeners();

    try {
      // TODO: API GET Call simulation
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      debugPrint("Error fetching time slots: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectPeriod(String period) {
    if (selectedPeriod == period) return;
    selectedPeriod = period;
    notifyListeners();
  }

  void selectTime(String time) {
    selectedTime = time;
    notifyListeners();
  }

  bool isTimeSelected(String time) => selectedTime == time;
}
