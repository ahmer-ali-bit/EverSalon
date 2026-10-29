import 'package:flutter/material.dart';

class NotificationsSettingsProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;
  bool isSaving = false;

  // Toggle states
  List<Map<String, dynamic>> settings = [];

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// TODO: BACKEND INTEGRATION - GET /api/settings/notifications
  Future<void> fetchSettings() async {
    isLoading = true;
    _safeNotify();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // TODO: BACKEND INTEGRATION - GET /api/settings/notifications
      settings = [
        {
          'id': 'booking_confirmations',
          'icon': Icons.calendar_month_outlined,
          'title': 'Booking Confirmations',
          'subtitle': 'Get notified on booking status',
          'value': true,
        },
        {
          'id': 'reminders',
          'icon': Icons.notifications_active_outlined,
          'title': 'Reminders',
          'subtitle': 'Get reminders for upcoming bookings',
          'value': true,
        },
        {
          'id': 'offers',
          'icon': Icons.local_offer_outlined,
          'title': 'Offers & Discounts',
          'subtitle': 'Receive offers and discount alerts',
          'value': true,
        },
        {
          'id': 'new_services',
          'icon': Icons.auto_awesome_outlined,
          'title': 'New Services',
          'subtitle': 'Get notified about new services',
          'value': true,
        },
        {
          'id': 'loyalty_points',
          'icon': Icons.diamond_outlined,
          'title': 'Loyalty Points Updates',
          'subtitle': 'Get notified on points & rewards',
          'value': true,
        },
        {
          'id': 'promotions',
          'icon': Icons.campaign_outlined,
          'title': 'Promotions',
          'subtitle': 'Receive promotional notifications',
          'value': false, // OFF in design
        },
        {
          'id': 'email',
          'icon': Icons.email_outlined,
          'title': 'Email Notifications',
          'subtitle': 'Receive email notifications',
          'value': true,
        },
      ];

      isLoading = false;
      _safeNotify();
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('fetchSettings error: $e');
    }
  }

  /// Toggle a single setting
  /// TODO: BACKEND INTEGRATION - PUT /api/settings/notifications
  Future<void> toggleSetting(int index, bool newValue) async {
    if (index < 0 || index >= settings.length) return;

    // Optimistic UI update
    settings[index]['value'] = newValue;
    _safeNotify();

    try {
      // TODO: BACKEND INTEGRATION - PUT /api/settings/notifications
      // await api.updateNotificationSetting(settings[index]['id'], newValue);
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      // Revert on failure
      settings[index]['value'] = !newValue;
      _safeNotify();
      debugPrint('toggleSetting error: $e');
    }
  }
}
