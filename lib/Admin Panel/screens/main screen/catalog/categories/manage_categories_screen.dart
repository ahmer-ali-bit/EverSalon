import 'dart:io';
import 'package:ever_salon/Admin%20Panel/providers/catalog/manage_categories_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../constants/app_colors.dart';
import '../../../../../../constants/app_translations.dart';

class AdminManageCategoryScreen extends StatelessWidget {
  final Map<String, dynamic>? categoryData;

  const AdminManageCategoryScreen({super.key, this.categoryData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminManageCategoryProvider(initialData: categoryData),
      child: const _AdminManageCategoryContent(),
    );
  }
}

class _AdminManageCategoryContent extends StatelessWidget {
  const _AdminManageCategoryContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminManageCategoryProvider>();

    // Custom Image ImageProvider
    ImageProvider? customImg;
    if (provider.pickedImagePath.isNotEmpty) {
      customImg = FileImage(File(provider.pickedImagePath));
    } else if (provider.customImagePath.isNotEmpty) {
      if (provider.customImagePath.startsWith('assets/')) {
        customImg = AssetImage(provider.customImagePath);
      } else {
        customImg = FileImage(File(provider.customImagePath));
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
                        ? context.tr('Edit Category')
                        : context.tr('Add Category'),
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
                padding: EdgeInsets.all(w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LIVE PREVIEW
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(w * 0.045),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE82A78), Color(0xFF6B2A8A)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(w * 0.04),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryPink.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child:
                                provider.iconType == 'custom' &&
                                    customImg != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      w * 0.02,
                                    ),
                                    child: Image(
                                      image: customImg,
                                      width: w * 0.1,
                                      height: w * 0.1,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    _getBuiltinIcon(provider),
                                    color: Colors.white,
                                    size: w * 0.1,
                                  ),
                          ),
                          SizedBox(height: h * 0.008),
                          Text(
                            provider.nameController.text.isEmpty
                                ? context.tr('Preview')
                                : provider.nameController.text,
                            style: TextStyle(
                              fontSize: w * 0.032,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.025),

                    _buildLabel(context, w, 'Category Name'),
                    _buildTextField(
                      context,
                      w,
                      'e.g. Hair Care, Skin & Facials',
                      provider.nameController,
                    ),
                    SizedBox(height: h * 0.03),

                    // ICON TYPE SEGMENTED BAR
                    _buildLabel(context, w, 'Icon Source'),
                    Container(
                      padding: EdgeInsets.all(w * 0.01),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(w * 0.06),
                      ),
                      child: Row(
                        children: [
                          _buildSegmentTab(
                            context,
                            w,
                            'Built-in Icons',
                            Icons.emoji_symbols,
                            provider.iconType == 'builtin',
                            () {
                              provider.selectIcon(provider.selectedIconName);
                            },
                          ),
                          _buildSegmentTab(
                            context,
                            w,
                            'Upload from Gallery',
                            Icons.image_outlined,
                            provider.iconType == 'custom',
                            () async {
                              await provider.pickCustomImage();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.02),

                    // If custom image mode
                    if (provider.iconType == 'custom') ...[
                      Container(
                        padding: EdgeInsets.all(w * 0.04),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg(context),
                          borderRadius: BorderRadius.circular(w * 0.04),
                          border: Border.all(color: AppColors.inputBg(context)),
                        ),
                        child: Column(
                          children: [
                            if (customImg != null)
                              Column(
                                children: [
                                  Container(
                                    width: w * 0.28,
                                    height: w * 0.28,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        w * 0.03,
                                      ),
                                      border: Border.all(
                                        color: AppColors.primaryPink.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 2,
                                      ),
                                      image: DecorationImage(
                                        image: customImg,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: h * 0.015),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: provider.pickCustomImage,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: w * 0.04,
                                            vertical: h * 0.01,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryPink
                                                .withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(
                                              w * 0.06,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.refresh,
                                                size: w * 0.04,
                                                color: AppColors.primaryPink,
                                              ),
                                              SizedBox(width: w * 0.015),
                                              Text(
                                                context.tr('Change'),
                                                style: TextStyle(
                                                  color: AppColors.primaryPink,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: w * 0.032,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: w * 0.03),
                                      GestureDetector(
                                        onTap: provider.removeCustomImage,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: w * 0.04,
                                            vertical: h * 0.01,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.error.withValues(
                                              alpha: 0.1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              w * 0.06,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.delete_outline,
                                                size: w * 0.04,
                                                color: AppColors.error,
                                              ),
                                              SizedBox(width: w * 0.015),
                                              Text(
                                                context.tr('Remove'),
                                                style: TextStyle(
                                                  color: AppColors.error,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: w * 0.032,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            else
                              GestureDetector(
                                onTap: provider.pickCustomImage,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w * 0.06,
                                    vertical: h * 0.02,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryPink,
                                    borderRadius: BorderRadius.circular(
                                      w * 0.06,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.file_upload_outlined,
                                        color: Colors.white,
                                        size: w * 0.05,
                                      ),
                                      SizedBox(width: w * 0.02),
                                      Text(
                                        context.tr('Choose from Gallery'),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: w * 0.035,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(height: h * 0.008),
                            Text(
                              context.tr(
                                'Square image recommended (500x500 px)',
                              ),
                              style: TextStyle(
                                fontSize: w * 0.028,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Built-in Icons Grid
                      Container(
                        padding: EdgeInsets.all(w * 0.03),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg(context),
                          borderRadius: BorderRadius.circular(w * 0.04),
                          border: Border.all(color: AppColors.inputBg(context)),
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemCount: provider.availableIcons.length,
                          itemBuilder: (context, index) {
                            final item = provider.availableIcons[index];
                            final isSelected =
                                provider.iconType == 'builtin' &&
                                provider.selectedIconName == item['name'];

                            return GestureDetector(
                              onTap: () => provider.selectIcon(item['name']),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryPink.withValues(
                                          alpha: 0.15,
                                        )
                                      : AppColors.inputBg(context),
                                  borderRadius: BorderRadius.circular(w * 0.03),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryPink
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      item['icon'] as IconData,
                                      color: isSelected
                                          ? AppColors.primaryPink
                                          : AppColors.textSecondary(context),
                                      size: w * 0.07,
                                    ),
                                    SizedBox(height: h * 0.005),
                                    Text(
                                      item['label'].toString(),
                                      style: TextStyle(
                                        fontSize: w * 0.025,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? AppColors.primaryPink
                                            : AppColors.textSecondary(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    SizedBox(height: h * 0.03),

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
                                context.tr('Category Visibility'),
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              Text(
                                provider.isActive
                                    ? context.tr('Visible in customer app')
                                    : context.tr('Hidden'),
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
                    SizedBox(height: h * 0.05),

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
                                final res = await provider.saveCategory();
                                if (res != null && context.mounted) {
                                  Navigator.pop(context, res);
                                }
                              },
                        child: provider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                context.tr('Save Category'),
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getBuiltinIcon(AdminManageCategoryProvider provider) {
    final match = provider.availableIcons.firstWhere(
      (i) => i['name'] == provider.selectedIconName,
      orElse: () => {'icon': Icons.spa},
    );
    return match['icon'] as IconData;
  }

  Widget _buildSegmentTab(
    BuildContext context,
    double w,
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: w * 0.028),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryPink : Colors.transparent,
            borderRadius: BorderRadius.circular(w * 0.06),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : AppColors.textSecondary(context),
                size: w * 0.04,
              ),
              SizedBox(width: w * 0.015),
              Flexible(
                child: Text(
                  context.tr(label),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : AppColors.textSecondary(context),
                    fontWeight: FontWeight.w600,
                    fontSize: w * 0.03,
                  ),
                ),
              ),
            ],
          ),
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
  ) => Container(
    decoration: BoxDecoration(
      color: AppColors.inputBg(context),
      borderRadius: BorderRadius.circular(w * 0.03),
    ),
    child: TextField(
      controller: controller,
      onChanged: (_) =>
          context.read<AdminManageCategoryProvider>().notifyListeners(),
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
