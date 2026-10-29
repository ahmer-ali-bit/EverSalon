import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../constants/app_colors.dart';
import '../../../../../../constants/app_translations.dart';
import '../../../../providers/catalog/manage_addon_provider.dart';

class AdminManageAddonScreen extends StatelessWidget {
  final Map<String, dynamic>? addonData;

  const AdminManageAddonScreen({super.key, this.addonData});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminManageAddonProvider(initialData: addonData),
      child: const _AdminManageAddonContent(),
    );
  }
}

class _AdminManageAddonContent extends StatelessWidget {
  const _AdminManageAddonContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminManageAddonProvider>();

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
                        ? context.tr('Edit Add-on')
                        : context.tr('Add New Add-on'),
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
                    _buildLabel(context, w, 'Add-on Service Name'),
                    _buildTextField(
                      context,
                      w,
                      'e.g. False Mink Lashes / Hair Mask',
                      provider.nameController,
                      TextInputType.text,
                    ),
                    SizedBox(height: h * 0.02),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(context, w, 'Extra Price (Rs.)'),
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
                              _buildLabel(context, w, 'Extra Time'),
                              _buildTextField(
                                context,
                                w,
                                'e.g. 15 mins',
                                provider.durationController,
                                TextInputType.text,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.025),

                    // APPLICABLE CATEGORY
                    _buildLabel(context, w, 'Applicable Category'),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(w * 0.03),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: provider.selectedCategory,
                          isExpanded: true,
                          dropdownColor: AppColors.cardBg(context),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          style: TextStyle(
                            color: AppColors.textPrimary(context),
                            fontSize: w * 0.035,
                            fontWeight: FontWeight.w500,
                          ),
                          items: provider.categories
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                          onChanged: (v) {
                            if (v != null) provider.setCategory(v);
                          },
                        ),
                      ),
                    ),
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
                                context.tr('Status'),
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              Text(
                                provider.isActive
                                    ? context.tr('Available for bookings')
                                    : context.tr('Disabled'),
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
                                final res = await provider.saveAddon();
                                if (res != null && context.mounted) {
                                  Navigator.pop(context, res);
                                }
                              },
                        child: provider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                context.tr('Save Add-on'),
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
    TextInputType type,
  ) => Container(
    decoration: BoxDecoration(
      color: AppColors.inputBg(context),
      borderRadius: BorderRadius.circular(w * 0.03),
    ),
    child: TextField(
      controller: controller,
      keyboardType: type,
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
