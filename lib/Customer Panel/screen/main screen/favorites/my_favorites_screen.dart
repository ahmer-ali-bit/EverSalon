import 'package:ever_salon/Customer%20Panel/provider/favorites/my_favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_translations.dart';

class MyFavoritesScreen extends StatelessWidget {
  const MyFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyFavoritesProvider()..fetchFavorites(),
      child: const _MyFavoritesView(),
    );
  }
}

class _MyFavoritesView extends StatelessWidget {
  const _MyFavoritesView();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<MyFavoritesProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ─── HEADER (NO BACK BUTTON) ───
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.02,
              ),
              child: Text(
                context.tr('my_favorites'),
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontSize: w * 0.065,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // ─── TOP TABS ───
            SizedBox(
              height: h * 0.05,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                itemCount: provider.tabs.length,
                itemBuilder: (context, index) {
                  final isSelected = provider.selectedTabIndex == index;
                  return GestureDetector(
                    onTap: () => provider.setTab(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(right: w * 0.03),
                      padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppColors.primaryGradient : null,
                        color: isSelected ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryPink
                              : AppColors.divider(context),
                        ),
                      ),
                      child: Text(
                        provider.tabs[index],
                        style: TextStyle(
                          fontSize: w * 0.035,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary(context),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: h * 0.02),

            // ─── LIST BODY ───
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : provider.favoriteItems.isEmpty
                  ? Center(
                      child: Text(
                        context.tr('no_favorites'),
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: w * 0.04,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(
                        left: w * 0.04,
                        right: w * 0.04,
                        bottom: h * 0.02,
                      ),
                      itemCount: provider.favoriteItems.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: h * 0.02),
                      itemBuilder: (context, index) {
                        final item = provider.favoriteItems[index];
                        return _buildFavoriteCard(
                          context: context,
                          w: w,
                          h: h,
                          item: item,
                          onRemove: () => provider.removeFavorite(item['id']),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Favorite Card matching Design
  Widget _buildFavoriteCard({
    required BuildContext context,
    required double w,
    required double h,
    required Map<String, dynamic> item,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: EdgeInsets.all(w * 0.03),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: AppColors.divider(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(w * 0.03),
            child: Image.asset(
              item['image'],
              width: w * 0.2,
              height: w * 0.2,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: w * 0.2,
                height: w * 0.2,
                color: AppColors.inputBg(context),
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.textSecondary(context),
                  size: w * 0.08,
                ),
              ),
            ),
          ),
          SizedBox(width: w * 0.035),

          // Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: h * 0.008),
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: const Color(0xFFFFC107), // Yellow Star
                      size: w * 0.045,
                    ),
                    SizedBox(width: w * 0.01),
                    Text(
                      '${item['rating']} (${item['reviews']})',
                      style: TextStyle(
                        fontSize: w * 0.032,
                        color: AppColors.textSecondary(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item['distance'],
                      style: TextStyle(
                        fontSize: w * 0.032,
                        color: AppColors.textSecondary(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: w * 0.02),

          // Heart Icon Button
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: EdgeInsets.all(w * 0.02),
              child: Icon(
                Icons.favorite_rounded,
                color: AppColors.primaryPink,
                size: w * 0.06,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
