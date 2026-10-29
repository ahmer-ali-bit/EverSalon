import 'package:ever_salon/Admin%20Panel/providers/coupon%20&%20discounts/manage_coupon_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class AdminManageCouponScreen extends StatelessWidget {
  final Map<String, dynamic>? couponData;
  final String type;

  const AdminManageCouponScreen({
    super.key,
    this.couponData,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          AdminManageCouponProvider(initialData: couponData, type: type),
      child: const _AdminManageCouponContent(),
    );
  }
}

class _AdminManageCouponContent extends StatelessWidget {
  const _AdminManageCouponContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminManageCouponProvider>();

    final titleText = provider.isEditMode
        ? (provider.type == 'coupon' ? 'Edit Coupon' : 'Edit Discount')
        : (provider.type == 'coupon' ? 'Add Coupon' : 'Add Discount');

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
                    context.tr(titleText),
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
                    _buildLabel(
                      context,
                      w,
                      provider.type == 'coupon'
                          ? 'Coupon Code'
                          : 'Discount Title',
                    ),
                    _buildTextField(
                      context,
                      w,
                      'e.g. WELCOME10',
                      provider.codeController,
                    ),
                    SizedBox(height: h * 0.02),

                    _buildLabel(context, w, 'Description'),
                    _buildTextField(
                      context,
                      w,
                      'e.g. Flat 10% OFF',
                      provider.descController,
                      maxLines: 2,
                    ),
                    SizedBox(height: h * 0.02),

                    _buildLabel(context, w, 'Validity Date'),
                    _buildTextField(
                      context,
                      w,
                      'e.g. 31 May 2024',
                      provider.dateController,
                    ),
                    SizedBox(height: h * 0.03),

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
                                    ? context.tr('Active')
                                    : context.tr('Inactive'),
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
                                final result = await provider.saveCoupon();
                                if (result != null && context.mounted) {
                                  Navigator.pop(context, result);
                                }
                              },
                        child: provider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
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
    TextEditingController controller, {
    int maxLines = 1,
  }) => Container(
    decoration: BoxDecoration(
      color: AppColors.inputBg(context),
      borderRadius: BorderRadius.circular(w * 0.03),
    ),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        color: AppColors.textPrimary(context),
        fontSize: w * 0.035,
      ),
      decoration: InputDecoration(
        hintText: context.tr(hint),
        hintStyle: TextStyle(color: AppColors.textGrey),
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(w * 0.04),
      ),
    ),
  );
}
