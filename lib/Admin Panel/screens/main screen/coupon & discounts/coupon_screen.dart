import 'package:ever_salon/Admin%20Panel/providers/coupon%20&%20discounts/coupon_provider.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/coupon%20&%20discounts/manage_coupon_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class AdminCouponsScreen extends StatelessWidget {
  const AdminCouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminCouponsProvider(),
      child: const _AdminCouponsContent(),
    );
  }
}

class _AdminCouponsContent extends StatelessWidget {
  const _AdminCouponsContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminCouponsProvider>();

    final typeStr = provider.selectedTabIndex == 0 ? 'coupon' : 'discount';
    final btnText = provider.selectedTabIndex == 0
        ? '+ Add New Coupon'
        : '+ Add New Discount';

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
                    context.tr('Coupons & Discounts'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),

            // TABS
            Row(
              children: [
                _buildTab(context, w, 'Coupons', 0, provider),
                _buildTab(context, w, 'Discounts', 1, provider),
              ],
            ),
            SizedBox(height: h * 0.01),

            // LIST
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.01,
                      ),
                      itemCount: provider.currentList.length,
                      separatorBuilder: (_, _) => SizedBox(height: h * 0.015),
                      itemBuilder: (context, index) {
                        final item = provider.currentList[index];
                        return _buildCard(context, w, item, provider);
                      },
                    ),
            ),

            // ADD BUTTON
            Padding(
              padding: EdgeInsets.all(w * 0.04),
              child: SizedBox(
                width: double.infinity,
                height: h * 0.065,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(w * 0.08),
                    ),
                  ),
                  onPressed: () async {
                    final newData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminManageCouponScreen(type: typeStr),
                      ),
                    );
                    if (newData != null && context.mounted) {
                      provider.addOrUpdateCoupon(
                        newData as Map<String, dynamic>,
                      );
                    }
                  },
                  child: Text(
                    context.tr(btnText),
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    double w,
    String title,
    int index,
    AdminCouponsProvider provider,
  ) {
    bool isSelected = provider.selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => provider.setTab(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: w * 0.03),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primaryPink : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            context.tr(title),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: w * 0.04,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primaryPink : AppColors.textGrey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    double w,
    Map<String, dynamic> item,
    AdminCouponsProvider provider,
  ) {
    return GestureDetector(
      onTap: () async {
        final updatedData = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AdminManageCouponScreen(couponData: item, type: item['type']),
          ),
        );
        if (updatedData != null && context.mounted) {
          provider.addOrUpdateCoupon(updatedData as Map<String, dynamic>);
        }
      },
      child: Container(
        padding: EdgeInsets.all(w * 0.035),
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(w * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(w * 0.03),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(w * 0.02),
              ),
              child: Icon(
                Icons.local_offer,
                color: AppColors.primaryPink,
                size: w * 0.06,
              ),
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['code'],
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    item['desc'],
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Valid till ${item['validity']}",
                    style: TextStyle(
                      fontSize: w * 0.028,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: item['isActive'],
              activeThumbColor: AppColors.primaryPink,
              onChanged: (val) => provider.toggleStatus(item['id'], val),
            ),
          ],
        ),
      ),
    );
  }
}
