import 'dart:io';
import 'package:ever_salon/Admin%20Panel/providers/customers/customer_provider.dart.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/customers/customer_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class AdminCustomersScreen extends StatelessWidget {
  const AdminCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminCustomersProvider(),
      child: const _AdminCustomersContent(),
    );
  }
}

class _AdminCustomersContent extends StatelessWidget {
  const _AdminCustomersContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminCustomersProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // --- STRICT HEADER (Back Button + Title side by side) ---
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.015,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context), // Back to Main Screen
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
                    context.tr('Customers'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),

            // --- Search Bar & Filter ---
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.01,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(w * 0.03),
                      ),
                      child: TextField(
                        onChanged: provider.updateSearch,
                        style: TextStyle(
                          color: AppColors.textPrimary(context),
                          fontSize: w * 0.035,
                        ),
                        decoration: InputDecoration(
                          hintText: context.tr('Search customers...'),
                          hintStyle: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: w * 0.035,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.textGrey,
                            size: w * 0.05,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: h * 0.015,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  GestureDetector(
                    onTap: () {
                      // NAVIGATION: Open Filter Bottom Sheet (Future Feature)
                    },
                    child: Container(
                      padding: EdgeInsets.all(w * 0.03),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(w * 0.03),
                      ),
                      child: Icon(
                        Icons.filter_alt_outlined,
                        color: AppColors.textPrimary(context),
                        size: w * 0.06,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- Customers List ---
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
                      itemCount: provider.filteredCustomers.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: h * 0.015),
                      itemBuilder: (context, index) {
                        final customer = provider.filteredCustomers[index];
                        return _buildCustomerCard(context, w, customer);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard(
    BuildContext context,
    double w,
    Map<String, dynamic> customer,
  ) {
    Color tagColor;
    Color tagBgColor;

    if (customer['tag'] == 'VIP') {
      tagColor = AppColors.primaryPink;
      tagBgColor = AppColors.primaryPink.withValues(alpha: 0.1);
    } else if (customer['tag'] == 'New') {
      tagColor = AppColors.success;
      tagBgColor = AppColors.success.withValues(alpha: 0.1);
    } else {
      tagColor = AppColors.textGrey;
      tagBgColor = AppColors.inputBg(context);
    }

    final avatar = customer['avatar'] as String? ?? '';
    ImageProvider? imageProvider;
    if (avatar.isNotEmpty) {
      if (avatar.startsWith('assets/')) {
        imageProvider = AssetImage(avatar);
      } else {
        imageProvider = FileImage(File(avatar));
      }
    }

    return GestureDetector(
      onTap: () {
        // ENHANCED NAVIGATION: Push to the newly created Detail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AdminCustomerDetailScreen(customerId: customer['id'] ?? ''),
          ),
        );
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
            // Avatar
            CircleAvatar(
              radius: w * 0.065,
              backgroundColor: AppColors.inputBg(context),
              backgroundImage: imageProvider,
              onBackgroundImageError: (_, _) {},
              child: imageProvider == null
                  ? Icon(
                      Icons.person,
                      color: AppColors.textGrey,
                      size: w * 0.06,
                    )
                  : null,
            ),
            SizedBox(width: w * 0.03),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer['name'] ?? '',
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: w * 0.01),
                  Text(
                    customer['phone'] ?? '',
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                  SizedBox(height: w * 0.01),
                  Text(
                    '${customer['bookings']} ${context.tr('Bookings')}',
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),

            // Tag
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.03,
                vertical: w * 0.01,
              ),
              decoration: BoxDecoration(
                color: tagBgColor,
                borderRadius: BorderRadius.circular(w * 0.03),
                border: Border.all(color: tagColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                customer['tag'] ?? '',
                style: TextStyle(
                  fontSize: w * 0.025,
                  fontWeight: FontWeight.bold,
                  color: tagColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
