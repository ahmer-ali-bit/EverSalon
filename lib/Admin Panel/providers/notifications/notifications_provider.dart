import 'package:flutter/material.dart';

class AdminNotificationsProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;

  List<Map<String, dynamic>> notifications = [];

  AdminNotificationsProvider() {
    _fetchNotifications();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// Unread notifications ki quantity
  int get unreadCount =>
      notifications.where((n) => n['isRead'] == false).length;

  Future<void> _fetchNotifications() async {
    isLoading = true;
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 500));

    notifications = [
      {
        'id': 'N1',
        'type': 'booking',
        'title': 'New Booking',
        'subtitle': 'Sara Khan booked Hair Spa Treatment',
        'time': '10:00 AM',
        'isRead': false,
      },
      {
        'id': 'N2',
        'type': 'payment',
        'title': 'Payment Received',
        'subtitle': 'Rs. 2,000 received from Sara Khan',
        'time': '10:05 AM',
        'isRead': false,
      },
      {
        'id': 'N3',
        'type': 'review',
        'title': 'New Review',
        'subtitle': 'Ayesha Malik left a 5-star review',
        'time': 'Yesterday',
        'isRead': true,
      },
      {
        'id': 'N4',
        'type': 'system',
        'title': 'Staff Update',
        'subtitle': 'Anaya Khan updated her profile',
        'time': '14 May',
        'isRead': true,
      },
      {
        'id': 'N5',
        'type': 'system',
        'title': 'Offer Scheduled',
        'subtitle': '20% OFF offer scheduled for tomorrow',
        'time': '14 May',
        'isRead': false,
      },
    ];

    isLoading = false;
    _safeNotify();
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n['id'] == id);
    if (index != -1 && notifications[index]['isRead'] == false) {
      notifications[index]['isRead'] = true;
      _safeNotify();
    }
  }

  void markAllAsRead() {
    for (var n in notifications) {
      n['isRead'] = true;
    }
    _safeNotify();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
