import 'package:flutter/material.dart';

class RescheduleBookingProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isSubmitting = false;
  bool _isDisposed = false;

  Map<String, dynamic> bookingData = {};

  // Calendar state (same pattern as SelectDateProvider / S33)
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDate;

  DateTime get focusedMonth => _focusedMonth;
  DateTime? get selectedDate => _selectedDate;

  // Time slots
  String? selectedTime;
  final List<String> timeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  static const List<String> _months = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> _shortMonths = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String get monthYearLabel =>
      '${_months[_focusedMonth.month]} ${_focusedMonth.year}';

  String get formattedSelectedDate {
    if (_selectedDate == null) return '';
    final d = _selectedDate!;
    return '${_weekdays[d.weekday - 1]}, ${d.day} ${_shortMonths[d.month]} ${d.year}';
  }

  /// Short label for booking card: "Wed, 15 May 2024"
  String get shortFormattedDate {
    if (_selectedDate == null) return '';
    final d = _selectedDate!;
    final dayShort = _weekdays[d.weekday - 1].substring(0, 3);
    return '$dayShort, ${d.day} ${_shortMonths[d.month]} ${d.year}';
  }

  void initData(Map<String, dynamic> data) {
    bookingData = Map<String, dynamic>.from(data);

    // Pre-select current booking date/time if parseable (optional UX)
    final existingTime = data['selectedTime']?.toString();
    if (existingTime != null && timeSlots.contains(existingTime)) {
      selectedTime = existingTime;
    }

    // TODO: BACKEND - GET /api/salons/{salonId}/available-dates
    notifyListeners();
  }

  // ========================================================
  // TODO: BACKEND INTEGRATION - GET /api/salons/{id}/available-dates
  // ========================================================
  Future<void> fetchAvailableDates() async {
    isLoading = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      debugPrint('fetchAvailableDates error: $e');
    } finally {
      if (!_isDisposed) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  // ========================================================
  // TODO: BACKEND INTEGRATION - GET /api/salons/{id}/time-slots
  // Query: ?date=YYYY-MM-DD&beauticianId=
  // ========================================================
  Future<void> fetchTimeSlotsForDate(DateTime date) async {
    // Keep UI snappy; slots already mock-available
    notifyListeners();
  }

  void nextMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    notifyListeners();
  }

  void previousMonth() {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);
    final prev = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    if (!prev.isBefore(thisMonth)) {
      _focusedMonth = prev;
      notifyListeners();
    }
  }

  void selectDate(DateTime date) {
    if (isPastDate(date)) return;
    _selectedDate = date;
    // Reset time when date changes (fresh slot pick)
    // selectedTime = null; // uncomment if you want force re-pick
    fetchTimeSlotsForDate(date);
    notifyListeners();
  }

  void selectTime(String time) {
    selectedTime = time;
    notifyListeners();
  }

  bool isPastDate(DateTime date) {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    return date.isBefore(today);
  }

  bool isSameDay(DateTime a, DateTime? b) {
    if (b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<DateTime?> get calendarDays {
    final year = _focusedMonth.year;
    final month = _focusedMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday; // 1=Mon … 7=Sun
    final offset = firstWeekday % 7; // Sun-start grid

    return [
      ...List.generate(offset, (_) => null),
      for (int d = 1; d <= daysInMonth; d++) DateTime(year, month, d),
    ];
  }

  bool get canConfirm => _selectedDate != null && selectedTime != null;

  // ========================================================
  // TODO: BACKEND INTEGRATION - PUT /api/bookings/{id}/reschedule
  // Body: { date, time, beauticianId? }
  // ========================================================
  Future<bool> confirmReschedule() async {
    if (!canConfirm) return false;

    isSubmitting = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // Updated booking map for local list sync
      bookingData = {
        ...bookingData,
        'selectedDate':
            '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
        'formattedDate': shortFormattedDate,
        'selectedTime': selectedTime,
        'status': 'upcoming',
      };

      return true;
    } catch (e) {
      debugPrint('confirmReschedule error: $e');
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
    super.dispose();
  }
}
