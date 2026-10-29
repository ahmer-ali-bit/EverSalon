import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../constants/app_colors.dart';
import '../../../../../../constants/app_translations.dart';
import '../../../../providers/catalog/manage_package_provider.dart';

class AdminManagePackageScreen extends StatelessWidget {
  final Map<String, dynamic>? packageData;

  const AdminManagePackageScreen({super.key, this.packageData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminManagePackageProvider(initialData: packageData),
      child: const _AdminManagePackageContent(),
    );
  }
}

class _AdminManagePackageContent extends StatelessWidget {
  const _AdminManagePackageContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminManagePackageProvider>();

    ImageProvider? imageProvider;
    if (provider.pickedImagePath.isNotEmpty) {
      imageProvider = FileImage(File(provider.pickedImagePath));
    } else if (provider.packageImage.isNotEmpty) {
      if (provider.packageImage.startsWith('assets/')) {
        imageProvider = AssetImage(provider.packageImage);
      } else {
        imageProvider = FileImage(File(provider.packageImage));
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
                        ? context.tr('Edit Package')
                        : context.tr('Create Package Deal'),
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
                    // COVER IMAGE PICKER
                    _buildLabel(context, w, 'Package Cover Image'),
                    GestureDetector(
                      onTap: provider.pickImage,
                      child: Container(
                        height: h * 0.18,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.inputBg(context),
                          borderRadius: BorderRadius.circular(w * 0.04),
                          border: Border.all(
                            color: AppColors.primaryPink.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          image: imageProvider != null
                              ? DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: imageProvider == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: AppColors.primaryPink,
                                    size: w * 0.1,
                                  ),
                                  SizedBox(height: h * 0.01),
                                  Text(
                                    context.tr('Upload Package Banner'),
                                    style: TextStyle(
                                      color: AppColors.textSecondary(context),
                                      fontSize: w * 0.032,
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: h * 0.025),

                    // PACKAGE NAME
                    _buildLabel(context, w, 'Package Name'),
                    _buildTextField(
                      context,
                      w,
                      'e.g. Royal Bridal Deal',
                      provider.nameController,
                      TextInputType.text,
                    ),
                    SizedBox(height: h * 0.02),

                    // PRICING (Deal Price + Original Price)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(context, w, 'Deal Price (Rs.)'),
                              _buildTextField(
                                context,
                                w,
                                'e.g. 25000',
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
                              _buildLabel(context, w, 'Original Price (Rs.)'),
                              _buildTextField(
                                context,
                                w,
                                'e.g. 32000',
                                provider.originalPriceController,
                                TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.02),

                    // DURATION
                    _buildLabel(context, w, 'Total Estimated Duration'),
                    _buildTextField(
                      context,
                      w,
                      'e.g. 4 hrs 30 mins',
                      provider.durationController,
                      TextInputType.text,
                    ),
                    SizedBox(height: h * 0.025),

                    // MULTI-SELECT INCLUDED SERVICES
                    _buildLabel(
                      context,
                      w,
                      'Select Included Services (${provider.selectedServices.length} selected)',
                    ),
                    Container(
                      padding: EdgeInsets.all(w * 0.03),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg(context),
                        borderRadius: BorderRadius.circular(w * 0.03),
                        border: Border.all(color: AppColors.inputBg(context)),
                      ),
                      child: Wrap(
                        spacing: w * 0.02,
                        runSpacing: h * 0.01,
                        children: provider.availableServices.map((service) {
                          final isSelected = provider.selectedServices.contains(
                            service,
                          );
                          return GestureDetector(
                            onTap: () =>
                                provider.toggleServiceSelection(service),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.03,
                                vertical: h * 0.008,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryPink
                                    : AppColors.inputBg(context),
                                borderRadius: BorderRadius.circular(w * 0.06),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryPink
                                      : Colors.transparent,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isSelected ? Icons.check : Icons.add,
                                    size: w * 0.035,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textSecondary(context),
                                  ),
                                  SizedBox(width: w * 0.015),
                                  Text(
                                    service,
                                    style: TextStyle(
                                      fontSize: w * 0.03,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textPrimary(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: h * 0.025),

                    // DESCRIPTION
                    _buildLabel(context, w, 'Description'),
                    _buildTextField(
                      context,
                      w,
                      'Describe package benefits...',
                      provider.descController,
                      TextInputType.multiline,
                      maxLines: 3,
                    ),
                    SizedBox(height: h * 0.025),

                    // STATUS TOGGLE
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
                                context.tr('Package Status'),
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              Text(
                                provider.isActive
                                    ? context.tr('Active (Visible in app)')
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
                                final res = await provider.savePackage();
                                if (res != null && context.mounted) {
                                  Navigator.pop(context, res);
                                }
                              },
                        child: provider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                context.tr('Save Package'),
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

  Widget _buildLabel(BuildContext context, double w, String text) => Padding(
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

  Widget _buildTextField(
    BuildContext context,
    double w,
    String hint,
    TextEditingController controller,
    TextInputType type, {
    int maxLines = 1,
  }) => Container(
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
