import 'package:flutter/material.dart';
import 'package:ever_salon/constants/app_colors.dart';

class NotificationsProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ========================================================
  // TODO: BACKEND INTEGRATION - GET NOTIFICATIONS API
  // Endpoint: GET /api/notifications
  // Returns: list of notifications (title, message, time, type, isRead)
  // ========================================================

  final List<Map<String, dynamic>> _notifications = [
    {
      "id": 1,
      "title": "Booking Confirmed 🎉",
      "message": "Your appointment at Glow Beauty Lounge is confirmed.",
      "time": "Just now",
      "icon": Icons.event_available_rounded,
      "iconBg": const Color(0xFFFCE4EC), // Light Pink
      "iconColor": AppColors.primaryPink,
      "isRead": false,
    },
    {
      "id": 2,
      "title": "Special Offer for You!",
      "message": "Get 20% OFF on all services. Use code GLOW20.",
      "time": "2h ago",
      "icon": Icons.local_offer_rounded,
      "iconBg": const Color(0xFFFFF3E0), // Light Orange
      "iconColor": Colors.orange,
      "isRead": false,
    },
    {
      "id": 3,
      "title": "Reminder ⏰",
      "message": "Your appointment is tomorrow at 3:00 PM.",
      "time": "1d ago",
      "icon": Icons.notifications_active_rounded,
      "iconBg": const Color(0xFFE3F2FD), // Light Blue
      "iconColor": Colors.blue,
      "isRead": true,
    },
    {
      "id": 4,
      "title": "New Salon Nearby",
      "message": "Elegance Salon is now available near you!",
      "time": "2d ago",
      "icon": Icons.storefront_rounded,
      "iconBg": const Color(0xFFF3E5F5), // Light Purple
      "iconColor": AppColors.primaryPurple,
      "isRead": true,
    },
    {
      "id": 5,
      "title": "Offer Ending Soon!",
      "message": "Your 15% OFF coupon will expire tomorrow.",
      "time": "3d ago",
      "icon": Icons.timer_rounded,
      "iconBg": const Color(0xFFFFEBEE), // Light Red
      "iconColor": AppColors.error,
      "isRead": true,
    },
  ];

  List<Map<String, dynamic>> get notifications => _notifications;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    // Simulating API delay
    await Future.delayed(const Duration(milliseconds: 600));

    _isLoading = false;
    notifyListeners();
  }

  void markAsRead(int index) {
    if (!_notifications[index]["isRead"]) {
      _notifications[index]["isRead"] = true;
      notifyListeners();

      // ========================================================
      // TODO: BACKEND - MARK NOTIFICATION AS READ API
      // Endpoint: PUT /api/notifications/{id}/read
      // ========================================================
    }
  }
}
