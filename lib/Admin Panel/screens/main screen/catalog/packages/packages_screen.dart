import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/Admin%20Panel/providers/catalog/packages_provider.dart';
import 'manage_packages_screen.dart';

class AdminPackagesScreen extends StatelessWidget {
  const AdminPackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminPackagesProvider(),
      child: const _AdminPackagesContent(),
    );
  }
}

class _AdminPackagesContent extends StatelessWidget {
  const _AdminPackagesContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminPackagesProvider>();

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
                  SizedBox(width: w * 0.03),
                  Expanded(
                    child: Text(
                      context.tr('Packages & Deals'),
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final newPkg = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminManagePackageScreen(),
                        ),
                      );
                      if (newPkg != null && context.mounted) {
                        provider.addOrUpdatePackage(
                          newPkg as Map<String, dynamic>,
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.035,
                        vertical: h * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink,
                        borderRadius: BorderRadius.circular(w * 0.06),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.white, size: w * 0.04),
                          SizedBox(width: w * 0.01),
                          Text(
                            context.tr('New Deal'),
                            style: TextStyle(
                              color: Colors.white,
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
            ),

            // SEARCH BAR
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.01,
              ),
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
                    hintText: context.tr('Search package deals...'),
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
                    contentPadding: EdgeInsets.symmetric(vertical: h * 0.015),
                  ),
                ),
              ),
            ),

            // PACKAGES LIST
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : provider.filteredPackages.isEmpty
                  ? Center(
                      child: Text(
                        context.tr('No packages found'),
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: w * 0.04,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.015,
                      ),
                      itemCount: provider.filteredPackages.length,
                      separatorBuilder: (_, _) => SizedBox(height: h * 0.02),
                      itemBuilder: (context, index) {
                        final pkg = provider.filteredPackages[index];
                        return _buildPackageCard(context, w, h, pkg, provider);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageCard(
    BuildContext context,
    double w,
    double h,
    Map<String, dynamic> pkg,
    AdminPackagesProvider provider,
  ) {
    final String imagePath = pkg['image']?.toString() ?? '';
    final List<dynamic> services =
        (pkg['includes'] ?? pkg['services']) as List<dynamic>? ?? [];
    final bool isActive = pkg['isActive'] ?? false;
    final int price = int.tryParse(pkg['price']?.toString() ?? '0') ?? 0;
    final int originalPrice =
        int.tryParse(pkg['originalPrice']?.toString() ?? '0') ?? price;
    final int saving = originalPrice > price ? (originalPrice - price) : 0;

    ImageProvider? img;
    if (imagePath.isNotEmpty) {
      if (imagePath.startsWith('assets/')) {
        img = AssetImage(imagePath);
      } else {
        img = FileImage(File(imagePath));
      }
    }

    return GestureDetector(
      onTap: () async {
        final updatedPkg = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdminManagePackageScreen(packageData: pkg),
          ),
        );
        if (updatedPkg != null && context.mounted) {
          provider.addOrUpdatePackage(updatedPkg as Map<String, dynamic>);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(w * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // COVER PHOTO + DISCOUNT BADGE
            Stack(
              children: [
                Container(
                  height: h * 0.16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(w * 0.04),
                    ),
                    color: AppColors.inputBg(context),
                    image: img != null
                        ? DecorationImage(image: img, fit: BoxFit.cover)
                        : null,
                  ),
                  child: img == null
                      ? Icon(
                          Icons.card_giftcard,
                          color: AppColors.textGrey,
                          size: w * 0.12,
                        )
                      : null,
                ),
                if (saving > 0)
                  Positioned(
                    left: w * 0.03,
                    top: w * 0.03,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.03,
                        vertical: h * 0.005,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE82A78), Color(0xFF6B2A8A)],
                        ),
                        borderRadius: BorderRadius.circular(w * 0.02),
                      ),
                      child: Text(
                        'Save Rs. $saving',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.028,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: w * 0.02,
                  top: w * 0.02,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(w * 0.04),
                    ),
                    child: Switch(
                      value: isActive,
                      activeThumbColor: AppColors.primaryPink,
                      onChanged: (val) => provider.toggleStatus(pkg['id'], val),
                    ),
                  ),
                ),
              ],
            ),

            // DETAILS
            Padding(
              padding: EdgeInsets.all(w * 0.035),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          pkg['name'] ?? '',
                          style: TextStyle(
                            fontSize: w * 0.042,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                      ),
                      Text(
                        'Rs. ${pkg['price']}',
                        style: TextStyle(
                          fontSize: w * 0.042,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPink,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.005),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: w * 0.035,
                        color: AppColors.textGrey,
                      ),
                      SizedBox(width: w * 0.015),
                      Text(
                        pkg['duration'] ?? '',
                        style: TextStyle(
                          fontSize: w * 0.03,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                      if (originalPrice > price) ...[
                        SizedBox(width: w * 0.03),
                        Text(
                          'Rs. $originalPrice',
                          style: TextStyle(
                            fontSize: w * 0.03,
                            color: AppColors.textGrey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: h * 0.012),

                  // INCLUDED SERVICES LIST
                  Text(
                    context.tr('Package Includes:'),
                    style: TextStyle(
                      fontSize: w * 0.03,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: h * 0.006),
                  Wrap(
                    spacing: w * 0.015,
                    runSpacing: h * 0.006,
                    children: services.map((s) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: w * 0.025,
                          vertical: h * 0.004,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.inputBg(context),
                          borderRadius: BorderRadius.circular(w * 0.015),
                        ),
                        child: Text(
                          '• $s',
                          style: TextStyle(
                            fontSize: w * 0.028,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
