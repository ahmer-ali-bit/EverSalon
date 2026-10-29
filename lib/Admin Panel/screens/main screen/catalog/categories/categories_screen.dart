import 'dart:io';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/catalog/categories/manage_categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../constants/app_colors.dart';
import '../../../../../../constants/app_translations.dart';
import '../../../../providers/catalog/categories_provider.dart';

class AdminCategoriesScreen extends StatelessWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminCategoriesProvider(),
      child: const _AdminCategoriesContent(),
    );
  }
}

class _AdminCategoriesContent extends StatelessWidget {
  const _AdminCategoriesContent();

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
    final provider = context.watch<AdminCategoriesProvider>();

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
                      context.tr('Service Categories'),
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final newCat = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminManageCategoryScreen(),
                        ),
                      );
                      if (newCat != null && context.mounted) {
                        provider.addOrUpdateCategory(
                          newCat as Map<String, dynamic>,
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
                            context.tr('Add Category'),
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

            // INFORMATIVE TIP
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: Text(
                context.tr(
                  'Categories help customers filter services easily on the client app.',
                ),
                style: TextStyle(
                  fontSize: w * 0.03,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ),
            SizedBox(height: h * 0.015),

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
                      itemCount: provider.allCategories.length,
                      separatorBuilder: (_, _) => SizedBox(height: h * 0.015),
                      itemBuilder: (context, index) {
                        final cat = provider.allCategories[index];
                        return _buildCategoryCard(context, w, cat, provider);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    double w,
    Map<String, dynamic> cat,
    AdminCategoriesProvider provider,
  ) {
    final iconType = cat['iconType'] ?? 'builtin';
    final customImagePath = cat['customImage']?.toString() ?? '';

    ImageProvider? customImg;
    if (iconType == 'custom' && customImagePath.isNotEmpty) {
      if (customImagePath.startsWith('assets/')) {
        customImg = AssetImage(customImagePath);
      } else {
        customImg = FileImage(File(customImagePath));
      }
    }

    return GestureDetector(
      onTap: () async {
        final updated = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdminManageCategoryScreen(categoryData: cat),
          ),
        );
        if (updated != null && context.mounted) {
          provider.addOrUpdateCategory(updated as Map<String, dynamic>);
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
              width: w * 0.13,
              height: w * 0.13,
              decoration: BoxDecoration(
                gradient: iconType == 'builtin'
                    ? const LinearGradient(
                        colors: [Color(0xFFE82A78), Color(0xFF6B2A8A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: iconType == 'custom' ? AppColors.inputBg(context) : null,
                borderRadius: BorderRadius.circular(w * 0.03),
                image: customImg != null
                    ? DecorationImage(image: customImg, fit: BoxFit.cover)
                    : null,
              ),
              child: iconType == 'builtin'
                  ? Icon(
                      _getIconData(cat['icon'] ?? 'spa'),
                      color: Colors.white,
                      size: w * 0.065,
                    )
                  : null,
            ),
            SizedBox(width: w * 0.035),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat['name'] ?? '',
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${cat['serviceCount']} ${context.tr('services included')}',
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: cat['isActive'] ?? true,
              activeThumbColor: AppColors.primaryPink,
              onChanged: (val) => provider.toggleStatus(cat['id'], val),
            ),
          ],
        ),
      ),
    );
  }
}
