import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminManageServiceProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  final bool isEditMode;
  final String serviceId;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final List<String> durationSuggestions = [
    '30 mins',
    '45 mins',
    '60 mins',
    '90 mins',
    '120 mins',
  ];

  /// Categories loaded from AdminCategoriesProvider ki jaisi hi mock data.
  /// Real project mein backend se same source aayega.
  List<Map<String, dynamic>> availableCategories = [];
  String? selectedCategoryId;

  String serviceImage = '';
  String pickedImagePath = '';
  bool isActive = true;

  AdminManageServiceProvider({Map<String, dynamic>? initialData})
    : isEditMode = initialData != null,
      serviceId =
          initialData?['id'] ?? 'SRV_${DateTime.now().millisecondsSinceEpoch}' {
    _loadCategories();

    if (initialData != null) {
      nameController.text = initialData['name'] ?? '';
      priceController.text = initialData['price']?.toString() ?? '';
      durationController.text = initialData['duration'] ?? '';
      serviceImage = initialData['image'] ?? '';
      isActive = initialData['isActive'] ?? true;
      selectedCategoryId = initialData['categoryId'];
      descController.text =
          initialData['desc'] ?? 'A premium service for our valuable clients.';
    }
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// Ideally yeh backend se aana chahiye — abhi ke liye same mock jo
  /// AdminCategoriesProvider mein hai wo mirror ki hai. Backend integration
  /// ke waqt central source use hoga.
  Future<void> _loadCategories() async {
    // TODO: BACKEND - GET /api/admin/categories (only active)
    await Future.delayed(const Duration(milliseconds: 300));

    availableCategories = [
      {'id': 'CAT1', 'name': 'Hair Care', 'icon': 'content_cut'},
      {'id': 'CAT2', 'name': 'Makeup & Beauty', 'icon': 'brush'},
      {'id': 'CAT3', 'name': 'Skin & Facials', 'icon': 'face'},
      {'id': 'CAT4', 'name': 'Nail Art & Care', 'icon': 'pan_tool_alt'},
      {'id': 'CAT5', 'name': 'Spa & Massages', 'icon': 'spa'},
      {'id': 'CAT6', 'name': 'Bridal & Groom', 'icon': 'favorite'},
    ];

    // Agar edit mode mein hai lekin category select nahi hai to first select karo
    if (selectedCategoryId == null && availableCategories.isNotEmpty) {
      selectedCategoryId = availableCategories.first['id'];
    }

    _safeNotify();
  }

  void setCategory(String? id) {
    selectedCategoryId = id;
    _safeNotify();
  }

  Map<String, dynamic>? get selectedCategory {
    if (selectedCategoryId == null) return null;
    try {
      return availableCategories.firstWhere(
        (c) => c['id'] == selectedCategoryId,
      );
    } catch (_) {
      return null;
    }
  }

  void setDurationSuggestion(String duration) {
    durationController.text = duration;
    _safeNotify();
  }

  void toggleStatus(bool val) {
    isActive = val;
    _safeNotify();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      pickedImagePath = image.path;
      _safeNotify();
    }
  }

  Future<Map<String, dynamic>?> saveService() async {
    if (nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        selectedCategoryId == null) {
      return null;
    }

    isLoading = true;
    _safeNotify();

    // TODO: BACKEND POST/PUT /api/admin/services
    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    _safeNotify();

    final cat = selectedCategory;

    return {
      'id': serviceId,
      'name': nameController.text.trim(),
      'price': priceController.text.trim(),
      'duration': durationController.text.trim().isEmpty
          ? '30 mins'
          : durationController.text.trim(),
      'desc': descController.text.trim(),
      'isActive': isActive,
      'image': pickedImagePath.isNotEmpty ? pickedImagePath : serviceImage,
      'categoryId': selectedCategoryId,
      'categoryName': cat?['name'] ?? '',
    };
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    durationController.dispose();
    descController.dispose();
    _isDisposed = true;
    super.dispose();
  }
}
