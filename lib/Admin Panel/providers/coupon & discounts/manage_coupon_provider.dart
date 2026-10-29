import 'package:flutter/material.dart';

class AdminManageCouponProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  final bool isEditMode;
  final String couponId;
  final String type; // 'coupon' or 'discount'

  final TextEditingController codeController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  bool isActive = true;

  AdminManageCouponProvider({
    Map<String, dynamic>? initialData,
    required this.type,
  }) : isEditMode = initialData != null,
       couponId =
           initialData?['id'] ??
           'CPN_${DateTime.now().millisecondsSinceEpoch}' {
    if (initialData != null) {
      codeController.text = initialData['code'] ?? '';
      descController.text = initialData['desc'] ?? '';
      dateController.text = initialData['validity'] ?? '';
      isActive = initialData['isActive'] ?? true;
    }
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  void toggleStatus(bool val) {
    isActive = val;
    _safeNotify();
  }

  Future<Map<String, dynamic>?> saveCoupon() async {
    if (codeController.text.trim().isEmpty ||
        descController.text.trim().isEmpty) {
      return null;
    }

    isLoading = true;
    _safeNotify();

    await Future.delayed(const Duration(seconds: 1)); // Mock save API

    isLoading = false;
    _safeNotify();

    return {
      'id': couponId,
      'code': codeController.text.trim().toUpperCase(),
      'desc': descController.text.trim(),
      'validity': dateController.text.trim().isEmpty
          ? '31 Dec 2024'
          : dateController.text.trim(),
      'isActive': isActive,
      'type': type,
    };
  }

  @override
  void dispose() {
    codeController.dispose();
    descController.dispose();
    dateController.dispose();
    _isDisposed = true;
    super.dispose();
  }
}
