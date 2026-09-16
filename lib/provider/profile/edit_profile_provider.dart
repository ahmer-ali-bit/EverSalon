import 'dart:io';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;
  bool isSaving = false;

  // Controllers for form fields
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  // Other fields
  String dob = '12 May 1998';
  String selectedGender = 'Female'; // 'Female', 'Male', 'Other'

  // Image handling
  File? profileImage;
  String currentImageUrl = 'assets/images/user_avatar.png';

  @override
  void dispose() {
    _isDisposed = true;
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// Fetch initial profile data to edit
  /// TODO: BACKEND INTEGRATION - GET /api/profile
  Future<void> fetchProfileData() async {
    isLoading = true;
    _safeNotify();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      // Mock Data
      nameController.text = 'Zainab Fatima';
      phoneController.text = '+92 300 1234567';
      emailController.text = 'zainabfatima@gmail.com';
      addressController.text = 'Yasrab Town, Bahawalpur, Pakistan';
      dob = '12 May 1998';
      selectedGender = 'Female';

      isLoading = false;
      _safeNotify();
    } catch (e) {
      isLoading = false;
      _safeNotify();
      debugPrint('fetchProfileData error: $e');
    }
  }

  /// Pick image from gallery
  /// Show bottom sheet: Camera or Gallery
  Future<void> showImageSourcePicker(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.sheetBg(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final w = MediaQuery.of(ctx).size.width;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: w * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: AppColors.primaryPink,
                  ),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(ctx);
                    pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: AppColors.primaryPink,
                  ),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(ctx);
                    pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Pick image from camera or gallery
  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        profileImage = File(image.path);
        _safeNotify();
      }
    } on MissingPluginException catch (e) {
      debugPrint('Image picker plugin missing: $e');
      // Plugin not registered — app needs full restart
    } catch (e) {
      debugPrint('Image picker error: $e');
    }
  }

  /// Update Date of Birth
  void updateDob(DateTime date) {
    // Simple formatting: 12 May 1998
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    dob = '${date.day} ${months[date.month - 1]} ${date.year}';
    _safeNotify();
  }

  /// Update Gender
  void setGender(String gender) {
    selectedGender = gender;
    _safeNotify();
  }

  /// Save profile changes
  /// TODO: BACKEND INTEGRATION - PUT /api/profile/update
  Future<Map<String, dynamic>?> saveProfile() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      return null;
    }

    isSaving = true;
    _safeNotify();

    try {
      await Future.delayed(const Duration(seconds: 1));

      // TODO: BACKEND - upload profileImage + fields via multipart/form-data

      isSaving = false;
      _safeNotify();

      // Return updated data so My Profile can refresh
      return {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'avatar': profileImage, // File?
      };
    } catch (e) {
      isSaving = false;
      _safeNotify();
      debugPrint('saveProfile error: $e');
      return null;
    }
  }
}
