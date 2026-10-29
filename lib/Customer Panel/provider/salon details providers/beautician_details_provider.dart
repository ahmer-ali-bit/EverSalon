import 'package:flutter/material.dart';

class BeauticianDetailsProvider extends ChangeNotifier {
  // ========================================================
  // TODO: BACKEND INTEGRATION - GET BEAUTICIAN DETAILS API
  // Endpoint: GET /api/beauticians/{beauticianId}
  // Returns: experience, specializations, about text
  // ========================================================

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic> _beauticianData = {};
  Map<String, dynamic> get beauticianData => _beauticianData;

  void initData(Map<String, dynamic> initialData) async {
    _beauticianData = Map.from(initialData);
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    await Future.delayed(const Duration(milliseconds: 400)); // Mock API delay

    // Add extra details if not already present from list API
    _beauticianData['experience'] =
        _beauticianData['experience'] ?? '5+ Years Experience';

    final name = (_beauticianData['name'] ?? 'The beautician')
        .toString()
        .split(' ')
        .first;
    _beauticianData['about'] =
        _beauticianData['about'] ??
        '$name is a certified senior specialist with over 5 years of experience in the beauty industry. Known for exceptional attention to detail and customer satisfaction. Book an appointment to get a premium experience.';

    _beauticianData['specializations'] =
        _beauticianData['specializations'] ??
        ['Haircut', 'Hair Styling', 'Hair Treatment', 'Hair Color'];

    _isLoading = false;
    notifyListeners();
  }

  void shareBeautician() {
    // ========================================================
    // TODO: BACKEND INTEGRATION - Share beautician profile
    // ========================================================
    debugPrint('Sharing Beautician: ${_beauticianData['name']}');
  }
}
