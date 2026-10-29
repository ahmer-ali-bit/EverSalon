import 'package:flutter/material.dart';

class AdminWorkingHoursProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;
  bool isSaving = false;

  /// Each day: open, close, isOff, hasBreak, breakStart, breakEnd
  List<Map<String, dynamic>> days = [];

  AdminWorkingHoursProvider() {
    _loadHours();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> _loadHours() async {
    isLoading = true;
    _safeNotify();

    // TODO: BACKEND GET /api/admin/salon/working-hours
    await Future.delayed(const Duration(milliseconds: 400));

    days = [
      _day(
        'Monday',
        '10:00 AM',
        '09:00 PM',
        false,
        true,
        '02:00 PM',
        '03:00 PM',
      ),
      _day(
        'Tuesday',
        '10:00 AM',
        '09:00 PM',
        false,
        true,
        '02:00 PM',
        '03:00 PM',
      ),
      _day(
        'Wednesday',
        '10:00 AM',
        '09:00 PM',
        false,
        true,
        '02:00 PM',
        '03:00 PM',
      ),
      _day(
        'Thursday',
        '10:00 AM',
        '09:00 PM',
        false,
        true,
        '02:00 PM',
        '03:00 PM',
      ),
      _day(
        'Friday',
        '10:00 AM',
        '09:00 PM',
        false,
        true,
        '02:00 PM',
        '03:00 PM',
      ),
      _day('Saturday', '10:00 AM', '08:00 PM', false, false, '', ''),
      _day(
        'Sunday',
        '11:00 AM',
        '06:00 PM',
        true,
        false,
        '',
        '',
      ), // Off by default
    ];

    isLoading = false;
    _safeNotify();
  }

  Map<String, dynamic> _day(
    String name,
    String open,
    String close,
    bool isOff,
    bool hasBreak,
    String breakStart,
    String breakEnd,
  ) {
    return {
      'name': name,
      'open': open,
      'close': close,
      'isOff': isOff,
      'hasBreak': hasBreak,
      'breakStart': breakStart,
      'breakEnd': breakEnd,
    };
  }

  void toggleOff(int index, bool value) {
    days[index]['isOff'] = value;
    _safeNotify();
  }

  void toggleBreak(int index, bool value) {
    days[index]['hasBreak'] = value;
    if (value && (days[index]['breakStart'] as String).isEmpty) {
      days[index]['breakStart'] = '02:00 PM';
      days[index]['breakEnd'] = '03:00 PM';
    }
    _safeNotify();
  }

  void setOpen(int index, String time) {
    days[index]['open'] = time;
    _safeNotify();
  }

  void setClose(int index, String time) {
    days[index]['close'] = time;
    _safeNotify();
  }

  void setBreakStart(int index, String time) {
    days[index]['breakStart'] = time;
    _safeNotify();
  }

  void setBreakEnd(int index, String time) {
    days[index]['breakEnd'] = time;
    _safeNotify();
  }

  /// Apply Monday timings to Tue–Sat (not Sunday)
  void applyMondayToWeekdays() {
    if (days.isEmpty) return;
    final mon = days[0];
    for (int i = 1; i <= 5; i++) {
      days[i]['open'] = mon['open'];
      days[i]['close'] = mon['close'];
      days[i]['isOff'] = mon['isOff'];
      days[i]['hasBreak'] = mon['hasBreak'];
      days[i]['breakStart'] = mon['breakStart'];
      days[i]['breakEnd'] = mon['breakEnd'];
    }
    _safeNotify();
  }

  Future<bool> saveHours() async {
    isSaving = true;
    _safeNotify();

    // TODO: BACKEND PUT /api/admin/salon/working-hours
    // Backend uses this to generate customer time slots + block multi-hour services
    await Future.delayed(const Duration(seconds: 1));

    isSaving = false;
    _safeNotify();
    return true;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
