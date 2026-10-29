import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectDateProvider extends ChangeNotifier {
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDate;

  DateTime get focusedMonth => _focusedMonth;
  DateTime? get selectedDate => _selectedDate;

  void nextMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    notifyListeners();
  }

  void previousMonth() {
    final now = DateTime.now();
    final currentRealMonth = DateTime(now.year, now.month);
    final prevMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);

    if (!prevMonth.isBefore(currentRealMonth)) {
      _focusedMonth = prevMonth;
      notifyListeners();
    }
  }

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

  bool isSameDay(DateTime date1, DateTime? date2) {
    if (date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<DateTime?> get calendarDays {
    final year = _focusedMonth.year;
    final month = _focusedMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;

    final firstWeekday = DateTime(year, month, 1).weekday;
    final offset = firstWeekday % 7;

    final List<DateTime?> days = List.generate(offset, (_) => null);
    for (int d = 1; d <= daysInMonth; d++) {
      days.add(DateTime(year, month, d));
    }
    return days;
  }

  String get monthYearLabel => DateFormat('MMMM yyyy').format(_focusedMonth);

  String get formattedSelectedDate {
    if (_selectedDate == null) return '';
    return DateFormat('EEEE, d MMMM yyyy').format(_selectedDate!);
  }
}
