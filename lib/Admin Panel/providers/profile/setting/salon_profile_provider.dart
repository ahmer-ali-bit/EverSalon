import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminSalonProfileProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;
  bool isSaving = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController taglineController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String coverImage = '';
  String logoImage = '';
  String pickedCoverPath = '';
  String pickedLogoPath = '';

  bool isUnisex = true;
  bool isOpenNow = true; // display flag; real open from working hours

  AdminSalonProfileProvider() {
    _loadProfile();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  Future<void> _loadProfile() async {
    isLoading = true;
    _safeNotify();

    // TODO: BACKEND GET /api/admin/salon/profile
    await Future.delayed(const Duration(milliseconds: 400));

    nameController.text = 'Glow Beauty Lounge';
    taglineController.text = 'Beauty meets perfection';
    phoneController.text = '+92 300 1234567';
    emailController.text = 'info@glowbeauty.com';
    aboutController.text =
        'Welcome to Glow Beauty Lounge, where beauty meets perfection. We offer premium services with professional care.';
    addressController.text =
        'Yasrab Town, Near Shell Pump, Bahawalpur, Pakistan';
    coverImage = 'assets/images/salons/glow_cover.png';
    logoImage = 'assets/images/salons/glow_logo.png';
    isUnisex = true;

    isLoading = false;
    _safeNotify();
  }

  void toggleUnisex(bool v) {
    isUnisex = v;
    _safeNotify();
  }

  Future<void> pickCover() async {
    final x = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (x != null) {
      pickedCoverPath = x.path;
      _safeNotify();
    }
  }

  Future<void> pickLogo() async {
    final x = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (x != null) {
      pickedLogoPath = x.path;
      _safeNotify();
    }
  }

  Future<bool> saveProfile() async {
    if (nameController.text.trim().isEmpty) return false;
    if (phoneController.text.trim().isEmpty) return false;

    isSaving = true;
    _safeNotify();

    // TODO: BACKEND PUT /api/admin/salon/profile (multipart for images)
    await Future.delayed(const Duration(seconds: 1));

    isSaving = false;
    _safeNotify();
    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    taglineController.dispose();
    phoneController.dispose();
    emailController.dispose();
    aboutController.dispose();
    addressController.dispose();
    _isDisposed = true;
    super.dispose();
  }
}
