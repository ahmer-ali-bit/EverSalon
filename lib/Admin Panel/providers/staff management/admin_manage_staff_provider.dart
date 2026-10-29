import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminManageStaffProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  final bool isEditMode;
  final String staffId;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final List<String> roleSuggestions = [
    'Senior Stylist',
    'Hair Specialist',
    'Makeup Artist',
    'Nail Expert',
    'Therapist',
  ];

  String profileImage = '';
  String pickedImagePath = '';
  bool isActive = true;

  AdminManageStaffProvider({Map<String, String>? initialData})
    : isEditMode = initialData != null,
      staffId =
          initialData?['id'] ?? 'ST_${DateTime.now().millisecondsSinceEpoch}' {
    if (initialData != null) {
      // EDIT MODE - fill all fields
      nameController.text = initialData['name'] ?? '';
      roleController.text = initialData['role'] ?? '';
      experienceController.text = initialData['experience'] ?? '';
      phoneController.text = initialData['phone'] ?? '';
      bioController.text = initialData['bio'] ?? '';
      profileImage = initialData['avatar'] ?? '';
      isActive = (initialData['status'] ?? 'Active') == 'Active';
    }
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  void setRoleSuggestion(String role) {
    roleController.text = role;
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

  Future<Map<String, String>?> saveStaff() async {
    if (nameController.text.trim().isEmpty) return null;
    if (roleController.text.trim().isEmpty) return null;

    isLoading = true;
    _safeNotify();

    // TODO: BACKEND INTEGRATION - POST/PUT /api/admin/staff
    await Future.delayed(const Duration(seconds: 1));

    isLoading = false;
    _safeNotify();

    // Return complete data map so list can update
    return {
      'id': staffId,
      'name': nameController.text.trim(),
      'role': roleController.text.trim(),
      'experience': experienceController.text.trim().isEmpty
          ? '0'
          : experienceController.text.trim(),
      'phone': phoneController.text.trim(),
      'bio': bioController.text.trim(),
      'status': isActive ? 'Active' : 'Inactive',
      'avatar': pickedImagePath.isNotEmpty ? pickedImagePath : profileImage,
    };
  }

  @override
  void dispose() {
    nameController.dispose();
    roleController.dispose();
    experienceController.dispose();
    phoneController.dispose();
    bioController.dispose();
    _isDisposed = true;
    super.dispose();
  }
}
