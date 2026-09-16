import 'package:flutter/material.dart';

class SelectDateProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND - GET /api/salons/{salonId}/available-dates
  // (Agar fully-booked dates disable karni hon to yahan se lao)
  // ========================================================

  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDate;

  DateTime get focusedMonth => _focusedMonth;
  DateTime? get selectedDate => _selectedDate;

  // ---------- Month label: "May 2024" ----------
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

  String get monthYearLabel =>
      '${_months[_focusedMonth.month]} ${_focusedMonth.year}';

  // ---------- Selected date label: "Wednesday, 15 May 2024" ----------
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

  String get formattedSelectedDate {
    if (_selectedDate == null) return 'Please select a date';
    final d = _selectedDate!;
    // DateTime.weekday → 1=Mon … 7=Sun
    return '${_weekdays[d.weekday - 1]}, ${d.day} ${_shortMonths[d.month]} ${d.year}';
  }

  // ---------- Navigation ----------
  void nextMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    notifyListeners();
  }

  void previousMonth() {
    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);
    final prev = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    // Past months pe nahi jaa sakte
    if (!prev.isBefore(thisMonth)) {
      _focusedMonth = prev;
      notifyListeners();
    }
  }

  // ---------- Selection ----------
  void selectDate(DateTime date) {
    if (isPastDate(date)) return;
    _selectedDate = date;
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

  /// Calendar grid ke liye cells generate karta hai
  List<DateTime?> get calendarDays {
    final year = _focusedMonth.year;
    final month = _focusedMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    // Dart weekday: 1=Mon … 7=Sun
    // Hum Sun-start chahte hain → offset = weekday % 7
    final firstWeekday = DateTime(year, month, 1).weekday; // 1-7
    final offset = firstWeekday % 7; // 0=Sun … 6=Sat

    // Fix: List literal using spread operator (growable)
    final List<DateTime?> days = [
      ...List.generate(offset, (_) => null),
      for (int d = 1; d <= daysInMonth; d++) DateTime(year, month, d),
    ];

    return days;
  }
}
