import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_translations.dart';
import '../../../provider/profile/edit_profile_provider.dart';
import '../../../widgets/custom_button.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileProvider()..fetchProfileData(),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatelessWidget {
  const _EditProfileView();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<EditProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ─── STRICT HEADER ───
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.015,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: w * 0.1,
                      height: w * 0.1,
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.textPrimary(context),
                        size: w * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  Expanded(
                    child: Center(
                      child: Text(
                        context.tr('edit_profile'),
                        style: TextStyle(
                          fontSize: w * 0.05,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                  ),
                  // Trailing check icon (Save shortcut)
                  GestureDetector(
                    onTap: () async {
                      if (!provider.isSaving) {
                        _handleSave(context, provider);
                      }
                    },
                    child: Container(
                      width: w * 0.1,
                      height: w * 0.1,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.check,
                        color: AppColors.textPrimary(context),
                        size: w * 0.06,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── BODY ───
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: h * 0.02),
                          // ─── Avatar Section ───
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  width: w * 0.28,
                                  height: w * 0.28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.inputBg(context),
                                    border: Border.all(
                                      color: AppColors.divider(context),
                                      width: 2,
                                    ),
                                    image: provider.profileImage != null
                                        ? DecorationImage(
                                            image: FileImage(
                                              provider.profileImage!,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: provider.profileImage == null
                                      ? ClipOval(
                                          child: Image.asset(
                                            provider.currentImageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) => Icon(
                                              Icons.person,
                                              size: w * 0.15,
                                              color: AppColors.textSecondary(context),
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                // Camera Icon Badge
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () =>
                                        provider.showImageSourcePicker(context),
                                    child: Container(
                                      width: w * 0.08,
                                      height: w * 0.08,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryPink,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: w * 0.04,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: h * 0.04),

                          // ─── Form Fields ───
                          _buildTextField(
                            context: context,
                            w: w,
                            h: h,
                            label: context.tr('full_name'),
                            controller: provider.nameController,
                          ),
                          SizedBox(height: h * 0.02),

                          _buildTextField(
                            context: context,
                            w: w,
                            h: h,
                            label: context.tr('phone_number'),
                            controller: provider.phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: h * 0.02),

                          _buildTextField(
                            context: context,
                            w: w,
                            h: h,
                            label: context.tr('email_address'),
                            controller: provider.emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: h * 0.02),

                          // Date of Birth Field
                          Text(
                            context.tr('date_of_birth'),
                            style: TextStyle(
                              fontSize: w * 0.035,
                              color: AppColors.textPrimary(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: h * 0.01),
                          GestureDetector(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime(1998, 5, 12),
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: AppColors.primaryPink,
                                        onPrimary: Colors.white,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null) {
                                provider.updateDob(pickedDate);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.04,
                                vertical: h * 0.018,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.inputBg(context),
                                borderRadius: BorderRadius.circular(w * 0.02),
                                border: Border.all(
                                  color: AppColors.divider(context),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    provider.dob,
                                    style: TextStyle(
                                      fontSize: w * 0.04,
                                      color: AppColors.textPrimary(context),
                                    ),
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.textSecondary(context),
                                    size: w * 0.06,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.02),

                          // Gender Radio Buttons
                          Text(
                            context.tr('gender'),
                            style: TextStyle(
                              fontSize: w * 0.035,
                              color: AppColors.textPrimary(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: h * 0.01),
                          Row(
                            children: [
                              _buildRadioButton(
                                context: context,
                                w: w,
                                label: context.tr('female'),
                                isSelected: provider.selectedGender == 'Female',
                                onTap: () => provider.setGender('Female'),
                              ),
                              SizedBox(width: w * 0.06),
                              _buildRadioButton(
                                context: context,
                                w: w,
                                label: context.tr('male'),
                                isSelected: provider.selectedGender == 'Male',
                                onTap: () => provider.setGender('Male'),
                              ),
                              SizedBox(width: w * 0.06),
                              _buildRadioButton(
                                context: context,
                                w: w,
                                label: context.tr('other'),
                                isSelected: provider.selectedGender == 'Other',
                                onTap: () => provider.setGender('Other'),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.02),

                          // Address Field
                          _buildTextField(
                            context: context,
                            w: w,
                            h: h,
                            label: context.tr('address'),
                            controller: provider.addressController,
                            maxLines: 3,
                          ),
                          SizedBox(height: h * 0.04), // Bottom padding
                        ],
                      ),
                    ),
            ),

            // ─── Fixed Bottom Button ───
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                w * 0.04,
                h * 0.02,
                w * 0.04,
                h * 0.03, // Extra padding for SafeArea bottom
              ),
              decoration: BoxDecoration(
                color: AppColors.cardBg(context),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: CustomButton(
                text: context.tr('save_changes'),
                isLoading: provider.isSaving,
                onTap: () => _handleSave(context, provider),
                width: double.infinity,
                height: h * 0.065,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Handle Save Action
  void _handleSave(BuildContext context, EditProfileProvider provider) async {
    final result = await provider.saveProfile();
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('profile_updated')),
          backgroundColor: AppColors.success,
        ),
      );
      // Return data back to My Profile Screen
      Navigator.pop(context, result);
    }
  }

  // Custom TextField Builder
  Widget _buildTextField({
    required BuildContext context,
    required double w,
    required double h,
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: w * 0.035,
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: h * 0.01),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: w * 0.04,
            color: AppColors.textPrimary(context),
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: w * 0.04,
              vertical: h * 0.018,
            ),
            filled: true,
            fillColor: AppColors.inputBg(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(w * 0.02),
              borderSide: BorderSide(color: AppColors.divider(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(w * 0.02),
              borderSide: BorderSide(color: AppColors.divider(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(w * 0.02),
              borderSide: const BorderSide(color: AppColors.primaryPink),
            ),
          ),
        ),
      ],
    );
  }

  // Custom Radio Button Builder (Design match)
  Widget _buildRadioButton({
    required BuildContext context,
    required double w,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: w * 0.05,
            height: w * 0.05,
            padding: EdgeInsets.all(w * 0.008),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryPink
                    : AppColors.textSecondary(context),
                width: 1.5,
              ),
            ),
            child: isSelected
                ? Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryPink,
                    ),
                  )
                : null,
          ),
          SizedBox(width: w * 0.02),
          Text(
            label,
            style: TextStyle(
              fontSize: w * 0.038,
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
