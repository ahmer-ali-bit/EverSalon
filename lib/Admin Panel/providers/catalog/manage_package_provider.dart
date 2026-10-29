import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminManagePackageProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  final bool isEditMode;
  final String packageId;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController originalPriceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  // Available services list for multi-select
  final List<String> availableServices = [
    'HD Bridal Makeup',
    'Signature Party Makeup',
    'Hair Cut & Styling',
    'Hair Spa Treatment',
    'Blowdry & Styling',
    'Hydra Facial',
    'Bridal Facial',
    'Deluxe Manicure & Pedicure',
    'Express Manicure',
    'Head & Shoulder Massage',
    'Hair Mask Treatment',
  ];

  List<String> selectedServices = [];
  String packageImage = '';
  String pickedImagePath = '';
  bool isActive = true;

  AdminManagePackageProvider({Map<String, dynamic>? initialData})
    : isEditMode = initialData != null,
      packageId =
          initialData?['id'] ?? 'PKG_${DateTime.now().millisecondsSinceEpoch}' {
    if (initialData != null) {
      nameController.text = initialData['name'] ?? '';
      priceController.text = initialData['price']?.toString() ?? '';
      originalPriceController.text =
          initialData['originalPrice']?.toString() ?? '';
      durationController.text = initialData['duration'] ?? '';
      descController.text = initialData['desc'] ?? '';
      packageImage = initialData['image'] ?? '';
      isActive = initialData['isActive'] ?? true;
      selectedServices = List<String>.from(
        initialData['services'] ?? <String>[],
      );
    }
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  void toggleServiceSelection(String serviceName) {
    if (selectedServices.contains(serviceName)) {
      selectedServices.remove(serviceName);
    } else {
      selectedServices.add(serviceName);
    }
    _safeNotify();
  }

  void toggleStatus(bool val) {
    isActive = val;
    _safeNotify();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (x != null) {
      pickedImagePath = x.path;
      _safeNotify();
    }
  }

  Future<Map<String, dynamic>?> savePackage() async {
    if (nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        selectedServices.isEmpty) {
      return null;
    }

    isLoading = true;
    _safeNotify();

    // TODO: BACKEND POST/PUT /api/admin/packages
    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    _safeNotify();

    return {
      'id': packageId,
      'name': nameController.text.trim(),
      'price': priceController.text.trim(),
      'originalPrice': originalPriceController.text.trim().isNotEmpty
          ? originalPriceController.text.trim()
          : priceController.text.trim(),
      'duration': durationController.text.trim().isEmpty
          ? '2 hrs'
          : durationController.text.trim(),
      'desc': descController.text.trim(),
      'services': selectedServices,
      'isActive': isActive,
      'image': pickedImagePath.isNotEmpty ? pickedImagePath : packageImage,
    };
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    originalPriceController.dispose();
    durationController.dispose();
    descController.dispose();
    _isDisposed = true;
    super.dispose();
  }
}
