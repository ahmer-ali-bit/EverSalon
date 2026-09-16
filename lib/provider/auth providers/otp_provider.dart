import 'dart:async';
import 'package:flutter/material.dart';

class OtpProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  int _remainingSeconds = 30; // Resend timer (UI: 00:28 style)
  Timer? _timer;
  bool _canResend = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get remainingSeconds => _remainingSeconds;
  bool get canResend => _canResend;

  // Formatted timer text -> 00:28
  String get timerText {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  OtpProvider() {
    startTimer();
  }

  // Start / restart resend countdown
  void startTimer() {
    _canResend = false;
    _remainingSeconds = 30;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _canResend = true;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  // ========================================================
  // BACKEND INTEGRATION: VERIFY OTP API
  // ========================================================
  Future<bool> verifyOtp({
    required String otp,
    required String phoneOrEmail,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: CALL ACTUAL REST API HERE
      // Example:
      // final response = await http.post(
      //   Uri.parse('https://api.eversalon.com/auth/verify-otp'),
      //   body: {
      //     'otp': otp,
      //     'phone': phoneOrEmail,
      //   },
      // );
      //
      // if (response.statusCode == 200) {
      //   // OTP verified — save token if returned
      //   return true;
      // } else {
      //   _errorMessage = jsonDecode(response.body)['message'] ?? 'Invalid OTP';
      //   return false;
      // }

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Demo: accept 2479 as valid OTP (change/remove in production)
      if (otp == '2479') {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = 'Invalid OTP. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Verification failed. Please check your network.';
      notifyListeners();
      return false;
    }
  }

  // ========================================================
  // BACKEND INTEGRATION: RESEND OTP API
  // ========================================================
  Future<bool> resendOtp({required String phoneOrEmail}) async {
    if (!_canResend) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: CALL ACTUAL REST API HERE
      // Example:
      // final response = await http.post(
      //   Uri.parse('https://api.eversalon.com/auth/resend-otp'),
      //   body: {'phone': phoneOrEmail},
      // );
      //
      // if (response.statusCode == 200) {
      //   startTimer();
      //   return true;
      // }

      await Future.delayed(const Duration(seconds: 1));

      _isLoading = false;
      startTimer(); // Restart 30s timer after successful resend
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to resend OTP. Try again.';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
