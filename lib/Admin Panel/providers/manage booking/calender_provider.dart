import 'package:flutter/material.dart';

class AdminCalendarProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;

  DateTime selectedDate = DateTime.now();
  String selectedStaff = 'All';

  final List<String> staffList = [
    'All',
    'Anaya Khan',
    'Sana Fatima',
    'Maria Noor',
    'Hira Malik',
  ];

  List<Map<String, dynamic>> timeSlots = [];

  AdminCalendarProvider() {
    _fetchSchedule();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    _fetchSchedule();
  }

  void selectStaff(String staff) {
    selectedStaff = staff;
    _safeNotify();
  }

  Future<void> _fetchSchedule() async {
    isLoading = true;
    _safeNotify();

    // Mock API Delay
    await Future.delayed(const Duration(milliseconds: 500));

    // REAL-WORLD MOCK DATA WITH DURATIONS
    List<Map<String, dynamic>> actualBookings = [
      {
        'id': 'ESR1240516',
        'customerName': 'Sara Khan',
        'service': 'Hair Spa Treatment',
        'staffName': 'Anaya Khan',
        'time': '10:00 AM',
        'durationMins': 60, // 1 Hour Service
        'status': 'Confirmed',
        'customerAvatar': 'assets/images/users/sara.png',
        'paymentMethod': 'Card',
        'amount': 'Rs. 2,000',
      },
      {
        'id': 'ESR1240517',
        'customerName': 'Ayesha Malik',
        'service': 'Bridal Makeup',
        'staffName': 'Maria Noor',
        'time': '11:00 AM',
        'durationMins': 180, // 3 HOURS LONG SERVICE (11 AM to 2 PM)
        'status': 'Confirmed',
        'customerAvatar': 'assets/images/users/ayesha.png',
        'paymentMethod': 'Cash',
        'amount': 'Rs. 15,000',
      },
      {
        'id': 'ESR1240518',
        'customerName': 'Hina Fatima',
        'service': 'Hair Cut',
        'staffName': 'Sana Fatima',
        'time': '03:00 PM',
        'durationMins': 60,
        'status': 'Pending',
        'customerAvatar': 'assets/images/users/hina.png',
        'paymentMethod': 'Card',
        'amount': 'Rs. 1,500',
      },
    ];

    // Generate Hourly Slots (09:00 AM to 08:00 PM)
    List<String> hours = [
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '01:00 PM',
      '02:00 PM',
      '03:00 PM',
      '04:00 PM',
      '05:00 PM',
      '06:00 PM',
      '07:00 PM',
      '08:00 PM',
    ];

    timeSlots = hours.map((hourStr) {
      Map<String, dynamic>? activeBooking;
      bool isContinued = false;

      for (var b in actualBookings) {
        // Staff filter check (if a staff is selected, only process their bookings)
        if (selectedStaff != 'All' && b['staffName'] != selectedStaff) continue;

        String bTime = b['time'];
        int duration = b['durationMins'];

        if (bTime == hourStr) {
          activeBooking = b;
          isContinued = false; // Main start of the booking
          break;
        } else if (_isHourWithinBooking(hourStr, bTime, duration)) {
          activeBooking = b;
          isContinued = true; // Ongoing service from previous hours
          break;
        }
      }

      if (activeBooking != null) {
        return {
          'time': hourStr,
          'isBooked': true,
          'isContinued': isContinued,
          'booking': activeBooking,
        };
      } else {
        return {'time': hourStr, 'isBooked': false, 'isContinued': false};
      }
    }).toList();

    isLoading = false;
    _safeNotify();
  }

  // CORE LOGIC: Check if this hourly slot falls inside a multi-hour service
  bool _isHourWithinBooking(
    String currentHourStr,
    String startHourStr,
    int durationMins,
  ) {
    if (durationMins <= 60) return false;

    int currentMins = _timeToMinutes(currentHourStr);
    int startMins = _timeToMinutes(startHourStr);
    int endMins = startMins + durationMins;

    // Example: Start 11:00 (660), Dur 120 (end 780). Current 12:00 (720).
    // 720 > 660 AND 720 < 780 => True (Overlapping)
    return currentMins > startMins && currentMins < endMins;
  }

  int _timeToMinutes(String timeStr) {
    // Parser for "10:00 AM" or "02:00 PM"
    List<String> parts = timeStr.split(' ');
    List<String> timeParts = parts[0].split(':');
    int h = int.parse(timeParts[0]);
    int m = int.parse(timeParts[1]);
    if (parts[1] == 'PM' && h != 12) h += 12;
    if (parts[1] == 'AM' && h == 12) h = 0;
    return (h * 60) + m;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
