import 'dart:io';
import 'package:ever_salon/Admin%20Panel/providers/services%20management/admin_manage_services_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class AdminManageServiceScreen extends StatelessWidget {
  final Map<String, dynamic>? serviceData;

  const AdminManageServiceScreen({super.key, this.serviceData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminManageServiceProvider(initialData: serviceData),
      child: const _AdminManageServiceContent(),
    );
  }
}

class _AdminManageServiceContent extends StatelessWidget {
  const _AdminManageServiceContent();

  IconData _getIconData(String name) {
    switch (name) {
      case 'content_cut':
        return Icons.content_cut;
      case 'brush':
        return Icons.brush;
      case 'face':
        return Icons.face;
      case 'pan_tool_alt':
        return Icons.pan_tool_alt;
      case 'favorite':
        return Icons.favorite;
      case 'clean_hands':
        return Icons.clean_hands;
      case 'wb_sunny':
        return Icons.wb_sunny;
      default:
        return Icons.spa;
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminManageServiceProvider>();

    ImageProvider? imageProvider;
    if (provider.pickedImagePath.isNotEmpty) {
      imageProvider = FileImage(File(provider.pickedImagePath));
    } else if (provider.serviceImage.isNotEmpty) {
      if (provider.serviceImage.startsWith('assets/')) {
        imageProvider = AssetImage(provider.serviceImage);
      } else {
        imageProvider = FileImage(File(provider.serviceImage));
      }
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
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
                        ? context.tr('Edit Service')
                        : context.tr('Add Service'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: h * 0.01,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE PICKER
                    Center(
                      child: GestureDetector(
                        onTap: provider.pickImage,
                        child: Stack(
                          children: [
                            Container(
                              width: w * 0.35,
                              height: w * 0.35,
                              decoration: BoxDecoration(
                                color: AppColors.inputBg(context),
                                borderRadius: BorderRadius.circular(w * 0.04),
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
                                      Icons.spa,
                                      size: w * 0.12,
                                      color: AppColors.textGrey,
                                    )
                                  : null,
                            ),
                            Positioned(
                              bottom: -5,
                              right: -5,
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
                    SizedBox(height: h * 0.04),

                    // NAME
                    _buildLabel(context, w, 'Service Name'),
                    _buildTextField(
                      context,
                      w,
                      'e.g. Hair Spa Treatment',
                      provider.nameController,
                      TextInputType.name,
                    ),
                    SizedBox(height: h * 0.02),

                    // ⭐ CATEGORY SELECTOR
                    _buildLabel(context, w, 'Service Category'),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(w * 0.03),
                        border: provider.selectedCategoryId == null
                            ? Border.all(
                                color: AppColors.error.withValues(alpha: 0.3),
                              )
                            : null,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: provider.selectedCategoryId,
                          isExpanded: true,
                          hint: Text(
                            context.tr('Select a category'),
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: w * 0.035,
                            ),
                          ),
                          dropdownColor: AppColors.cardBg(context),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.textSecondary(context),
                          ),
                          style: TextStyle(
                            color: AppColors.textPrimary(context),
                            fontSize: w * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                          items: provider.availableCategories.map((cat) {
                            return DropdownMenuItem<String>(
                              value: cat['id'],
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(w * 0.015),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFE82A78),
                                          Color(0xFF6B2A8A),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        w * 0.015,
                                      ),
                                    ),
                                    child: Icon(
                                      _getIconData(cat['icon'] ?? 'spa'),
                                      color: Colors.white,
                                      size: w * 0.035,
                                    ),
                                  ),
                                  SizedBox(width: w * 0.025),
                                  Text(cat['name']),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: provider.setCategory,
                        ),
                      ),
                    ),
                    if (provider.selectedCategoryId == null)
                      Padding(
                        padding: EdgeInsets.only(top: w * 0.01, left: w * 0.02),
                        child: Text(
                          context.tr('* Category is required'),
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: w * 0.028,
                          ),
                        ),
                      ),
                    SizedBox(height: h * 0.02),

                    // PRICE + DURATION
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(context, w, 'Price (Rs.)'),
                              _buildTextField(
                                context,
                                w,
                                'e.g. 1500',
                                provider.priceController,
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
                              _buildLabel(context, w, 'Duration'),
                              _buildTextField(
                                context,
                                w,
                                'e.g. 45 mins',
                                provider.durationController,
                                TextInputType.text,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.01),

                    Wrap(
                      spacing: w * 0.02,
                      runSpacing: h * 0.01,
                      children: provider.durationSuggestions.map((dur) {
                        return GestureDetector(
                          onTap: () => provider.setDurationSuggestion(dur),
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
                              dur,
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

                    _buildLabel(context, w, 'Description'),
                    _buildTextField(
                      context,
                      w,
                      'Service description...',
                      provider.descController,
                      TextInputType.multiline,
                      maxLines: 3,
                    ),
                    SizedBox(height: h * 0.025),

                    // STATUS
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
                                context.tr('Service Status'),
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              Text(
                                provider.isActive
                                    ? context.tr('Active (Visible)')
                                    : context.tr('Inactive (Hidden)'),
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
                        ),
                        onPressed: provider.isLoading
                            ? null
                            : () async {
                                final result = await provider.saveService();
                                if (result == null && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        context.tr(
                                          'Please fill name, price and category',
                                        ),
                                      ),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                  return;
                                }
                                if (result != null && context.mounted) {
                                  Navigator.pop(context, result);
                                }
                              },
                        child: provider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                context.tr('Save Service'),
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
