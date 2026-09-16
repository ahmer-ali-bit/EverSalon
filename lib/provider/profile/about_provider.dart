import 'package:flutter/material.dart';

class AboutProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  final String appVersion = '1.0.0';
  final String appName = 'EverSalon';
  final String description =
      'Your ultimate beauty companion. Book your favorite services, manage appointments and enjoy exclusive offers.';

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// Open external social / store links
  Future<void> openLink(String type) async {
    isLoading = true;
    _safeNotify();

    try {
      // TODO: BACKEND INTEGRATION - Replace with real URLs + url_launcher
      await Future.delayed(const Duration(milliseconds: 400));

      // Examples:
      // Facebook  -> https://facebook.com/eversalon
      // Instagram -> https://instagram.com/eversalon
      // TikTok    -> https://tiktok.com/@eversalon
      // Rate Us   -> App Store / Play Store link
      // Terms     -> https://eversalon.com/terms
      // Privacy   -> https://eversalon.com/privacy

      debugPrint('Open link: $type');

      isLoading = false;
      _safeNotify();
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('openLink error: $e');
    }
  }
}
