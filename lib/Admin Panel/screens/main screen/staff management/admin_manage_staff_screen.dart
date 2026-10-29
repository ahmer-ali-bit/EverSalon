import 'dart:io';
import 'package:ever_salon/Admin%20Panel/providers/staff%20management/admin_manage_staff_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class AdminManageStaffScreen extends StatelessWidget {
  final Map<String, String>? staffData;

  const AdminManageStaffScreen({super.key, this.staffData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminManageStaffProvider(initialData: staffData),
      child: const _AdminManageStaffContent(),
    );
  }
}

class _AdminManageStaffContent extends StatelessWidget {
  const _AdminManageStaffContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminManageStaffProvider>();

    // Decide which image to show
    ImageProvider? imageProvider;
    if (provider.pickedImagePath.isNotEmpty) {
      imageProvider = FileImage(File(provider.pickedImagePath));
    } else if (provider.profileImage.isNotEmpty) {
      if (provider.profileImage.startsWith('assets/')) {
        imageProvider = AssetImage(provider.profileImage);
      } else {
        imageProvider = FileImage(File(provider.profileImage));
      }
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ---------- HEADER ----------
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
                  SizedBox(width: w * 0.04),
                  Text(
                    provider.isEditMode
                        ? context.tr('Edit Staff')
                        : context.tr('Add Staff'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),

            // ---------- FORM ----------
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: h * 0.01,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar + Camera
                    Center(
                      child: GestureDetector(
                        onTap: provider.pickImage,
                        child: Stack(
                          children: [
                            Container(
                              width: w * 0.28,
                              height: w * 0.28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.inputBg(context),
                                border: Border.all(
                                  color: AppColors.primaryPink.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 2,
                                ),
                                image: imageProvider != null
                                    ? DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: imageProvider == null
                                  ? Icon(
                                      Icons.person,
                                      size: w * 0.1,
                                      color: AppColors.textGrey,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(w * 0.02),
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
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.03),

                    // Full Name
                    _buildLabel(context, w, 'Full Name'),
                    _buildTextField(
                      context,
                      w,
                      'Enter full name',
                      provider.nameController,
                      TextInputType.name,
                    ),
                    SizedBox(height: h * 0.02),

                    // Role (typeable + suggestions)
                    _buildLabel(context, w, 'Specialist / Role'),
                    _buildTextField(
                      context,
                      w,
                      'Type role or select below',
                      provider.roleController,
                      TextInputType.text,
                    ),
                    SizedBox(height: h * 0.01),
                    Wrap(
                      spacing: w * 0.02,
                      runSpacing: h * 0.01,
                      children: provider.roleSuggestions.map((role) {
                        return GestureDetector(
                          onTap: () => provider.setRoleSuggestion(role),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.03,
                              vertical: h * 0.008,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.inputBg(context),
                              borderRadius: BorderRadius.circular(w * 0.02),
                              border: Border.all(
                                color: AppColors.primaryPink.withValues(
                                  alpha: 0.25,
                                ),
                              ),
                            ),
                            child: Text(
                              role,
                              style: TextStyle(
                                fontSize: w * 0.03,
                                color: AppColors.primaryPink,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: h * 0.02),

                    // Experience + Phone
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(context, w, 'Experience (Years)'),
                              _buildTextField(
                                context,
                                w,
                                'e.g. 5',
                                provider.experienceController,
                                TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: w * 0.03),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(context, w, 'Phone Number'),
                              _buildTextField(
                                context,
                                w,
                                '+92 300...',
                                provider.phoneController,
                                TextInputType.phone,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.02),

                    // Bio
                    _buildLabel(context, w, 'Short Bio'),
                    _buildTextField(
                      context,
                      w,
                      'About the staff member...',
                      provider.bioController,
                      TextInputType.multiline,
                      maxLines: 3,
                    ),
                    SizedBox(height: h * 0.025),

                    // Active / Inactive Toggle (Edit + Add dono mein)
                    Container(
                      padding: EdgeInsets.all(w * 0.04),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg(context),
                        borderRadius: BorderRadius.circular(w * 0.04),
                        border: Border.all(color: AppColors.inputBg(context)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr('Staff Status'),
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              SizedBox(height: w * 0.01),
                              Text(
                                provider.isActive
                                    ? context.tr(
                                        'Active (Visible to customers)',
                                      )
                                    : context.tr(
                                        'Inactive (Hidden from booking)',
                                      ),
                                style: TextStyle(
                                  fontSize: w * 0.03,
                                  color: provider.isActive
                                      ? AppColors.success
                                      : AppColors.textGrey,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: provider.isActive,
                            activeThumbColor: AppColors.primaryPink,
                            activeTrackColor: AppColors.primaryPink.withValues(
                              alpha: 0.3,
                            ),
                            inactiveThumbColor: AppColors.textGrey,
                            inactiveTrackColor: AppColors.inputBg(context),
                            onChanged: provider.toggleStatus,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.04),

                    // SAVE BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: h * 0.065,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w * 0.08),
                          ),
                          elevation: 0,
                        ),
                        onPressed: provider.isLoading
                            ? null
                            : () async {
                                final result = await provider.saveStaff();
                                if (result != null && context.mounted) {
                                  // Data wapas list screen pe bhejo
                                  Navigator.pop(context, result);
                                }
                              },
                        child: provider.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                context.tr('Save Details'),
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: h * 0.03),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, double w, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.02),
      child: Text(
        context.tr(text),
        style: TextStyle(
          fontSize: w * 0.035,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary(context),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    double w,
    String hint,
    TextEditingController controller,
    TextInputType type, {
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg(context),
        borderRadius: BorderRadius.circular(w * 0.03),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        style: TextStyle(
          color: AppColors.textPrimary(context),
          fontSize: w * 0.035,
        ),
        decoration: InputDecoration(
          hintText: context.tr(hint),
          hintStyle: TextStyle(color: AppColors.textGrey, fontSize: w * 0.035),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: w * 0.035,
          ),
        ),
      ),
    );
  }
}
