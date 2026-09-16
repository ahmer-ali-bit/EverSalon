import 'package:flutter/material.dart';

class MyBookingsProvider extends ChangeNotifier {
  bool isLoading = false;
  bool _isDisposed = false;
  int selectedTabIndex = 0; // 0: Upcoming, 1: Completed, 2: Cancelled

  /// All user bookings (mock + newly paid bookings)
  List<Map<String, dynamic>> allBookings = [];

  // ========================================================
  // TODO: BACKEND INTEGRATION - GET /api/bookings
  // Query: ?status=upcoming|completed|cancelled
  // ========================================================
  Future<void> fetchBookings() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    if (_isDisposed) return;

    // Agar list pehli dafa load ho rahi hai to mock data daal do
    if (allBookings.isEmpty) {
      allBookings = [
        // ------------------------------------------
        // 1. UPCOMING BOOKINGS (Tab 0 -> S42)
        // ------------------------------------------
        {
          'bookingId': '#ES1240S15689',
          'salonData': {
            'id': 's1',
            'name': 'Glow Beauty Lounge',
            'address': 'Bahawalpur, Pakistan',
            'image': 'assets/images/glow beauty lounge.png',
            'rating': '4.8',
            'totalReviews': '256',
          },
          'beautician': {
            'id': 'b1',
            'name': 'Ayesha Khan',
            'role': 'Senior Stylist',
            'image': 'assets/images/beautician.png',
            'rating': '4.9',
          },
          'selectedServices': [
            {
              'id': 'srv1',
              'name': 'Haircut & Styling',
              'price': 1000,
              'duration': '60 mins',
            },
          ],
          'formattedDate': 'Wed, 15 May 2024',
          'selectedDate': '2024-05-15',
          'selectedTime': '11:00 AM',
          'subtotal': 1000,
          'serviceTax': 50,
          'totalAmount': 1050,
          'paymentMethod': 'online',
          'paymentStatus': 'paid',
          'status': 'upcoming',
        },
        {
          'bookingId': '#ES1240S15690',
          'salonData': {
            'id': 's2',
            'name': 'The Glam Studio',
            'address': 'Model Town, Lahore',
            'image': 'assets/images/the glam studio.png',
            'rating': '4.5',
            'totalReviews': '180',
          },
          'beautician': {
            'id': 'b2',
            'name': 'Sara Malik',
            'role': 'Makeup Artist',
            'image': 'assets/images/beautician.png',
            'rating': '4.8',
          },
          'selectedServices': [
            {
              'id': 'srv2',
              'name': 'Facial',
              'price': 2000,
              'duration': '45 mins',
            },
          ],
          'formattedDate': 'Fri, 17 May 2024',
          'selectedDate': '2024-05-17',
          'selectedTime': '02:30 PM',
          'subtotal': 2000,
          'serviceTax': 100,
          'totalAmount': 2100,
          'paymentMethod': 'cash',
          'paymentStatus': 'pay_at_salon',
          'status': 'upcoming',
        },

        // ------------------------------------------
        // 2. COMPLETED BOOKINGS (Tab 1 -> S47)
        // ------------------------------------------
        {
          'bookingId': '#ES1240S20001',
          'salonData': {
            'id': 's2',
            'name': 'The Glam Studio',
            'address': 'Model Town, Lahore',
            'image': 'assets/images/the glam studio.png',
            'rating': '4.7',
            'totalReviews': '198',
          },
          'beautician': {
            'id': 'b2',
            'name': 'Sara Malik',
            'role': 'Makeup Artist',
            'image': 'assets/images/beautician.png',
            'rating': '4.8',
          },
          'selectedServices': [
            {
              'id': 'srv2',
              'name': 'Facial',
              'price': 2000,
              'duration': '45 mins',
            },
          ],
          'formattedDate': 'Fri, 10 May 2024',
          'selectedDate': '2024-05-10',
          'selectedTime': '02:30 PM',
          'subtotal': 2000,
          'serviceTax': 100,
          'totalAmount': 2100,
          'paymentMethod': 'online',
          'paymentStatus': 'paid',
          'status': 'completed',
        },

        // ------------------------------------------
        // 3. CANCELLED BOOKINGS (Tab 2 -> S43)
        // ------------------------------------------
        {
          'bookingId': '#ES1240S30001',
          'salonData': {
            'id': 's3',
            'name': 'Elegance Salon',
            'address': 'DHA, Karachi',
            'image': 'assets/images/elegance salon.png',
            'rating': '4.7',
            'totalReviews': '310',
          },
          'beautician': {
            'id': 'b3',
            'name': 'Hina Butt',
            'role': 'Hair Color Expert',
            'image': 'assets/images/beautician.png',
            'rating': '4.7',
          },
          'selectedServices': [
            {
              'id': 'srv3',
              'name': 'Hair Color',
              'price': 2500,
              'duration': '90 mins',
            },
          ],
          'formattedDate': 'Mon, 5 May 2024',
          'selectedDate': '2024-05-05',
          'selectedTime': '01:00 PM',
          'subtotal': 2500,
          'serviceTax': 125,
          'totalAmount': 2625,
          'paymentMethod': 'online',
          'paymentStatus': 'refunded',
          'status': 'cancelled',
          'cancellationReason': 'Change of plans',
        },
      ];
    }

    isLoading = false;
    notifyListeners();
  }

  // Handle Tab Switching
  void changeTab(int index) {
    selectedTabIndex = index;
    notifyListeners();
  }

  // Filter Bookings Based on Selected Tab
  List<Map<String, dynamic>> get displayedBookings {
    String statusFilter = 'upcoming';
    if (selectedTabIndex == 1) statusFilter = 'completed';
    if (selectedTabIndex == 2) statusFilter = 'cancelled';

    return allBookings
        .where((b) => (b['status']?.toString() ?? '') == statusFilter)
        .toList();
  }

  // ========================================================
  // Frontend Local Sync Helpers (Payment Success & Cancel)
  // ========================================================

  /// Pay / Confirm ke baad nayi booking list mein add karo
  void addBooking(Map<String, dynamic> bookingData) {
    if (_isDisposed) return;

    // Duplicate guard — same bookingId dobara na aaye
    final newId = bookingData['bookingId']?.toString();
    if (newId != null &&
        allBookings.any((b) => b['bookingId']?.toString() == newId)) {
      return;
    }

    final booking = Map<String, dynamic>.from(bookingData);

    booking['status'] = booking['status'] ?? 'upcoming';
    booking['bookingId'] = booking['bookingId'] ?? _generateBookingId();

    // Latest booking top pe
    allBookings.insert(0, booking);

    // Upcoming tab pe switch
    selectedTabIndex = 0;

    notifyListeners();
  }

  /// S45/S46 se Cancel hone par list mein status update karo
  void updateBookingStatus(String bookingId, String status) {
    final index = allBookings.indexWhere(
      (b) => b['bookingId']?.toString() == bookingId,
    );
    if (index != -1) {
      allBookings[index] = {...allBookings[index], 'status': status};
      notifyListeners();
    }
  }

  String _generateBookingId() {
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    return '#ES${ts.substring(ts.length - 8)}';
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
