import 'package:flutter/material.dart';

class AdminManageAddonProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  final bool isEditMode;
  final String addonId;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  final List<String> categories = [
    'General / All',
    'Makeup',
    'Hair Care',
    'Skin Care',
    'Nails',
    'Spa & Massage',
  ];

  String selectedCategory = 'General / All';
  bool isActive = true;

  AdminManageAddonProvider({Map<String, dynamic>? initialData})
    : isEditMode = initialData != null,
      addonId =
          initialData?['id'] ?? 'AD_${DateTime.now().millisecondsSinceEpoch}' {
    if (initialData != null) {
      nameController.text = initialData['name'] ?? '';
      priceController.text = initialData['price']?.toString() ?? '';
      durationController.text = initialData['duration'] ?? '';
      selectedCategory = initialData['category'] ?? 'General / All';
      isActive = initialData['isActive'] ?? true;
    }
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  void setCategory(String cat) {
    selectedCategory = cat;
    _safeNotify();
  }

  void toggleStatus(bool val) {
    isActive = val;
    _safeNotify();
  }

  Future<Map<String, dynamic>?> saveAddon() async {
    if (nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty) {
      return null;
    }

    isLoading = true;
    _safeNotify();

    // TODO: BACKEND POST/PUT /api/admin/addons
    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    _safeNotify();

    return {
      'id': addonId,
      'name': nameController.text.trim(),
      'price': priceController.text.trim(),
      'duration': durationController.text.trim().isEmpty
          ? '15 mins'
          : durationController.text.trim(),
      'category': selectedCategory,
      'isActive': isActive,
    };
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    durationController.dispose();
    _isDisposed = true;
    super.dispose();
  }
}
