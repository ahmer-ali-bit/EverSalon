import 'dart:io';
import 'package:flutter/material.dart';

class MyProfileProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  String name = '';
  String phone = '';
  String email = '';
  String avatarUrl = '';
  File? localAvatar; // ← picked image from Edit Profile
  int loyaltyPoints = 0;
  String membershipTier = '';
  int giftCardsCount = 0;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// TODO: BACKEND INTEGRATION - GET /api/profile
  Future<void> fetchProfile() async {
    isLoading = true;
    _safeNotify();

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      // TODO: BACKEND INTEGRATION - GET /api/profile
      name = 'Zainab Fatima';
      phone = '+92 300 1234567';
      email = 'zainabfatima@gmail.com';
      avatarUrl = 'assets/images/user_avatar.png';
      loyaltyPoints = 2450;
      membershipTier = 'Gold Member';
      giftCardsCount = 2;

      isLoading = false;
      _safeNotify();
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('fetchProfile error: $e');
    }
  }

  /// Update profile after Edit Profile screen returns
  void updateLocalProfile({
    String? name,
    String? phone,
    String? email,
    File? avatar,
  }) {
    if (name != null) this.name = name;
    if (phone != null) this.phone = phone;
    if (email != null) this.email = email;
    if (avatar != null) localAvatar = avatar;
    _safeNotify();
  }
}
