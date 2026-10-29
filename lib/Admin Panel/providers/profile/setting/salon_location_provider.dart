import 'package:flutter/material.dart';

class AdminSalonLocationProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;
  bool isSaving = false;

  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();

  double latitude = 29.3956;
  double longitude = 71.6836;
  double pinX = 0.52;
  double pinY = 0.48;

  AdminSalonLocationProvider({String? initialAddress}) {
    if (initialAddress != null && initialAddress.isNotEmpty) {
      addressController.text = initialAddress;
    }
    _loadLocation();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// Live preview update when typing
  void onFieldChanged() => _safeNotify();

  Future<void> _loadLocation() async {
    isLoading = true;
    _safeNotify();

    // TODO: BACKEND GET /api/admin/salon/location
    await Future.delayed(const Duration(milliseconds: 400));

    if (addressController.text.isEmpty) {
      addressController.text =
          'Yasrab Town, Near Shell Pump, Bahawalpur, Pakistan';
    }
    if (cityController.text.isEmpty) cityController.text = 'Bahawalpur';
    if (areaController.text.isEmpty) areaController.text = 'Yasrab Town';
    if (landmarkController.text.isEmpty) {
      landmarkController.text = 'Near Shell Pump';
    }

    latitude = 29.3956;
    longitude = 71.6836;
    pinX = 0.52;
    pinY = 0.48;

    isLoading = false;
    _safeNotify();
  }

  void updatePin(Offset local, Size mapSize) {
    if (mapSize.width <= 0 || mapSize.height <= 0) return;
    pinX = (local.dx / mapSize.width).clamp(0.08, 0.92);
    pinY = (local.dy / mapSize.height).clamp(0.08, 0.92);
    latitude = 29.3900 + (0.5 - pinY) * 0.02;
    longitude = 71.6800 + (pinX - 0.5) * 0.02;
    _safeNotify();
  }

  void useCurrentLocationMock() {
    // TODO: geolocator later
    pinX = 0.5;
    pinY = 0.5;
    latitude = 29.3956;
    longitude = 71.6836;
    landmarkController.text = 'Current location (mock)';
    _safeNotify();
  }

  Future<bool> saveLocation() async {
    if (addressController.text.trim().isEmpty) return false;
    if (cityController.text.trim().isEmpty) return false;

    isSaving = true;
    _safeNotify();

    // TODO: BACKEND PUT /api/admin/salon/location
    await Future.delayed(const Duration(seconds: 1));

    isSaving = false;
    _safeNotify();
    return true;
  }

  @override
  void dispose() {
    addressController.dispose();
    cityController.dispose();
    areaController.dispose();
    landmarkController.dispose();
    _isDisposed = true;
    super.dispose();
  }
}
