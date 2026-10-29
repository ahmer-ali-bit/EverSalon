import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminManageCategoryProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  final bool isEditMode;
  final String categoryId;

  final TextEditingController nameController = TextEditingController();

  final List<Map<String, dynamic>> availableIcons = [
    {'name': 'content_cut', 'icon': Icons.content_cut, 'label': 'Hair'},
    {'name': 'brush', 'icon': Icons.brush, 'label': 'Makeup'},
    {'name': 'face', 'icon': Icons.face, 'label': 'Skin'},
    {'name': 'pan_tool_alt', 'icon': Icons.pan_tool_alt, 'label': 'Nails'},
    {'name': 'spa', 'icon': Icons.spa, 'label': 'Spa'},
    {'name': 'favorite', 'icon': Icons.favorite, 'label': 'Bridal'},
    {'name': 'clean_hands', 'icon': Icons.clean_hands, 'label': 'Hands'},
    {'name': 'wb_sunny', 'icon': Icons.wb_sunny, 'label': 'Glow'},
  ];

  /// 'builtin' → use icon from availableIcons list
  /// 'custom'  → use uploaded gallery image
  String iconType = 'builtin';

  String selectedIconName = 'spa';
  String customImagePath = '';
  String pickedImagePath = '';

  bool isActive = true;
  int serviceCount = 0;

  AdminManageCategoryProvider({Map<String, dynamic>? initialData})
    : isEditMode = initialData != null,
      categoryId =
          initialData?['id'] ?? 'CAT_${DateTime.now().millisecondsSinceEpoch}' {
    if (initialData != null) {
      nameController.text = initialData['name'] ?? '';
      iconType = initialData['iconType'] ?? 'builtin';
      selectedIconName = initialData['icon'] ?? 'spa';
      customImagePath = initialData['customImage'] ?? '';
      isActive = initialData['isActive'] ?? true;
      serviceCount = initialData['serviceCount'] ?? 0;
    }
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  void selectIcon(String iconName) {
    iconType = 'builtin';
    selectedIconName = iconName;
    pickedImagePath = ''; // clear picked when switching to builtin
    _safeNotify();
  }

  Future<void> pickCustomImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (x != null) {
      pickedImagePath = x.path;
      iconType = 'custom';
      _safeNotify();
    }
  }

  void removeCustomImage() {
    pickedImagePath = '';
    customImagePath = '';
    iconType = 'builtin';
    _safeNotify();
  }

  void toggleStatus(bool val) {
    isActive = val;
    _safeNotify();
  }

  Future<Map<String, dynamic>?> saveCategory() async {
    if (nameController.text.trim().isEmpty) return null;

    isLoading = true;
    _safeNotify();

    // TODO: BACKEND POST/PUT /api/admin/categories (multipart for custom image)
    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    _safeNotify();

    return {
      'id': categoryId,
      'name': nameController.text.trim(),
      'iconType': iconType,
      'icon': selectedIconName,
      'customImage': pickedImagePath.isNotEmpty
          ? pickedImagePath
          : customImagePath,
      'serviceCount': serviceCount,
      'isActive': isActive,
    };
  }

  @override
  void dispose() {
    nameController.dispose();
    _isDisposed = true;
    super.dispose();
  }
}
