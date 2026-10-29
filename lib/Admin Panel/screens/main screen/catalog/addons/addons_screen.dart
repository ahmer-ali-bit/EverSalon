import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../constants/app_colors.dart';
import '../../../../../../constants/app_translations.dart';
import '../../../../providers/catalog/addons_provider.dart';
import 'manage_addon_screen.dart';

class AdminAddonsScreen extends StatelessWidget {
  const AdminAddonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminAddonsProvider(),
      child: const _AdminAddonsContent(),
    );
  }
}

class _AdminAddonsContent extends StatelessWidget {
  const _AdminAddonsContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminAddonsProvider>();

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
                      context.tr('Add-on Services'),
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final newAddon = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminManageAddonScreen(),
                        ),
                      );
                      if (newAddon != null && context.mounted) {
                        provider.addOrUpdateAddon(
                          newAddon as Map<String, dynamic>,
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
                            context.tr('New Add-on'),
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

            // SEARCH
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
                    hintText: context.tr('Search add-ons...'),
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
                      itemCount: provider.filteredAddons.length,
                      separatorBuilder: (_, _) => SizedBox(height: h * 0.015),
                      itemBuilder: (context, index) {
                        final addon = provider.filteredAddons[index];
                        return _buildAddonCard(context, w, addon, provider);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddonCard(
    BuildContext context,
    double w,
    Map<String, dynamic> addon,
    AdminAddonsProvider provider,
  ) {
    return GestureDetector(
      onTap: () async {
        final updated = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdminManageAddonScreen(addonData: addon),
          ),
        );
        if (updated != null && context.mounted) {
          provider.addOrUpdateAddon(updated as Map<String, dynamic>);
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
                borderRadius: BorderRadius.circular(w * 0.025),
              ),
              child: Icon(
                Icons.add_circle_outline,
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
                    addon['name'] ?? '',
                    style: TextStyle(
                      fontSize: w * 0.038,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "${addon['category']} • ${addon['duration']}",
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "+ Rs. ${addon['price']}",
              style: TextStyle(
                fontSize: w * 0.035,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPink,
              ),
            ),
            SizedBox(width: w * 0.02),
            Switch(
              value: addon['isActive'] ?? true,
              activeThumbColor: AppColors.primaryPink,
              onChanged: (val) => provider.toggleStatus(addon['id'], val),
            ),
          ],
        ),
      ),
    );
  }
}
