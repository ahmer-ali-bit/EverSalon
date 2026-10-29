import 'package:flutter/material.dart';

class AdminStaffProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;

  List<Map<String, String>> allStaff = [];

  AdminStaffProvider() {
    _fetchStaff();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> _fetchStaff() async {
    isLoading = true;
    _safeNotify();

    // TODO: BACKEND INTEGRATION - GET /api/admin/staff
    await Future.delayed(const Duration(milliseconds: 500));

    allStaff = [
      {
        'id': 'ST1',
        'name': 'Anaya Khan',
        'role': 'Senior Stylist',
        'status': 'Active',
        'avatar': 'assets/images/staff/anaya.png',
        'experience': '8',
        'phone': '+92 300 1111111',
        'bio': 'Senior stylist with 8 years of experience.',
      },
      {
        'id': 'ST2',
        'name': 'Sana Fatima',
        'role': 'Hair Specialist',
        'status': 'Active',
        'avatar': 'assets/images/staff/sana.png',
        'experience': '5',
        'phone': '+92 300 2222222',
        'bio': 'Expert in hair treatments and coloring.',
      },
      {
        'id': 'ST3',
        'name': 'Maria Noor',
        'role': 'Makeup Artist',
        'status': 'Active',
        'avatar': 'assets/images/staff/maria.png',
        'experience': '6',
        'phone': '+92 300 3333333',
        'bio': 'Bridal and party makeup specialist.',
      },
      {
        'id': 'ST4',
        'name': 'Hira Malik',
        'role': 'Nail Expert',
        'status': 'Inactive',
        'avatar': 'assets/images/staff/hira.png',
        'experience': '3',
        'phone': '+92 300 4444444',
        'bio': 'Nail art and manicure expert.',
      },
      {
        'id': 'ST5',
        'name': 'Nida Ahmed',
        'role': 'Therapist',
        'status': 'Active',
        'avatar': 'assets/images/staff/nida.png',
        'experience': '4',
        'phone': '+92 300 5555555',
        'bio': 'Relaxing spa and therapy specialist.',
      },
    ];

    isLoading = false;
    _safeNotify();
  }

  void addOrUpdateStaff(Map<String, String> staffData) {
    final index = allStaff.indexWhere((s) => s['id'] == staffData['id']);
    if (index != -1) {
      allStaff[index] = staffData; // UPDATE existing
    } else {
      allStaff.insert(0, staffData); // ADD new at top
    }
    _safeNotify();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
