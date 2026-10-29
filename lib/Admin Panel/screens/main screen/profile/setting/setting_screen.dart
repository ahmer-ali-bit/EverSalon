import 'package:ever_salon/Admin%20Panel/providers/profile/setting/setting_provider.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/loyalty/loyalty_settings_screen.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/profile/setting/salon_profile_screen.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/profile/setting/working_hours_provider.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/salon%20gallery/salon_gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../constants/app_colors.dart';
import '../../../../../../constants/app_translations.dart';
import '../../catalog/addons/addons_screen.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminSettingsProvider(),
      child: const _AdminSettingsContent(),
    );
  }
}

class _AdminSettingsContent extends StatelessWidget {
  const _AdminSettingsContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // --- STRICT HEADER (Back Button + Title) ---
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
                    context.tr('Settings'),
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
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: h * 0.02,
                ),
                children: [
                  // Business Profile + Salon Information — dono same screen
                  _buildSettingsItem(
                    context,
                    w,
                    Icons.storefront_outlined,
                    'Business Profile',
                    () {
                      // NAVIGATION: Settings → AdminSalonProfileScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminSalonProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    w,
                    Icons.info_outline_rounded,
                    'Salon Information',
                    () {},
                  ),
                  _buildSettingsItem(
                    context,
                    w,
                    Icons.access_time,
                    'Working Hours',
                    () {
                      // NAVIGATION: From [Settings] → To [AdminWorkingHoursScreen]
                      // Trigger: Tap Working Hours
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminWorkingHoursScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    w,
                    Icons.photo_library_outlined,
                    'Salon Gallery',
                    () {
                      // NAVIGATION: From [Settings] → To [AdminSalonGalleryScreen]
                      // Trigger: Tap Salon Gallery
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminSalonGalleryScreen(),
                        ),
                      );
                    },
                  ),

                  _buildSettingsItem(
                    context,
                    w,
                    Icons.add_circle_outline,
                    'Add-on Services',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminAddonsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    w,
                    Icons.add_circle_outline,
                    'Loyalty Setting',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminLoyaltySettingsScreen(),
                        ),
                      );
                    },
                  ),

                  _buildSettingsItem(
                    context,
                    w,
                    Icons.payment_outlined,
                    'Payment Methods',
                    () {},
                  ),
                  _buildSettingsItem(
                    context,
                    w,
                    Icons.receipt_long_outlined,
                    'Tax Settings',
                    () {},
                  ),
                  _buildSettingsItem(
                    context,
                    w,
                    Icons.notifications_none_outlined,
                    'Notification Settings',
                    () {},
                  ),
                  _buildSettingsItem(
                    context,
                    w,
                    Icons.privacy_tip_outlined,
                    'Privacy & Security',
                    () {},
                  ),
                  _buildSettingsItem(
                    context,
                    w,
                    Icons.backup_outlined,
                    'Backup & Restore',
                    () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    double w,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.02),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: EdgeInsets.all(w * 0.025),
          decoration: BoxDecoration(
            color: AppColors.inputBg(context),
            borderRadius: BorderRadius.circular(w * 0.025),
          ),
          child: Icon(
            icon,
            color: AppColors.textSecondary(context),
            size: w * 0.055,
          ),
        ),
        title: Text(
          context.tr(title),
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontSize: w * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textGrey,
          size: w * 0.035,
        ),
      ),
    );
  }
}
