import 'package:flutter/material.dart';

class AdminCategoriesProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;

  List<Map<String, dynamic>> allCategories = [];

  AdminCategoriesProvider() {
    _fetchCategories();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> _fetchCategories() async {
    isLoading = true;
    _safeNotify();

    // TODO: BACKEND INTEGRATION - GET /api/admin/categories
    await Future.delayed(const Duration(milliseconds: 500));

    allCategories = [
      {
        'id': 'CAT1',
        'name': 'Hair Care',
        'icon': 'content_cut',
        'serviceCount': 12,
        'isActive': true,
      },
      {
        'id': 'CAT2',
        'name': 'Makeup & Beauty',
        'icon': 'brush',
        'serviceCount': 8,
        'isActive': true,
      },
      {
        'id': 'CAT3',
        'name': 'Skin & Facials',
        'icon': 'face',
        'serviceCount': 10,
        'isActive': true,
      },
      {
        'id': 'CAT4',
        'name': 'Nail Art & Care',
        'icon': 'pan_tool_alt',
        'serviceCount': 6,
        'isActive': true,
      },
      {
        'id': 'CAT5',
        'name': 'Spa & Massages',
        'icon': 'spa',
        'serviceCount': 5,
        'isActive': true,
      },
      {
        'id': 'CAT6',
        'name': 'Bridal & Groom',
        'icon': 'favorite',
        'serviceCount': 4,
        'isActive': false,
      },
    ];

    isLoading = false;
    _safeNotify();
  }

  void toggleStatus(String id, bool val) {
    final index = allCategories.indexWhere((c) => c['id'] == id);
    if (index != -1) {
      allCategories[index]['isActive'] = val;
      _safeNotify();
    }
  }

  void addOrUpdateCategory(Map<String, dynamic> data) {
    final index = allCategories.indexWhere((c) => c['id'] == data['id']);
    if (index != -1) {
      allCategories[index] = data;
    } else {
      allCategories.insert(0, data);
    }
    _safeNotify();
  }

  void deleteCategory(String id) {
    allCategories.removeWhere((c) => c['id'] == id);
    _safeNotify();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
