import 'package:ever_salon/provider/profile/account_setting_provider.dart';
import 'package:ever_salon/screen/main%20screen/profile/logout_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_translations.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountSettingsProvider(),
      child: const _AccountSettingsView(),
    );
  }
}

class _AccountSettingsView extends StatelessWidget {
  const _AccountSettingsView();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AccountSettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ─── HEADER: Back + Title sath ───
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
                  Text(
                    context.tr('account_settings'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),

            // ─── BODY ───
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      child: Column(
                        children: [
                          SizedBox(height: h * 0.02),

                          // Standard Menu Items
                          _buildMenuItem(
                            context: context,
                            w: w,
                            h: h,
                            icon: Icons.lock_outline_rounded,
                            title: context.tr('change_password'),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    context.tr('change_password_soon'),
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            context: context,
                            w: w,
                            h: h,
                            icon: Icons.shield_outlined,
                            title: context.tr('privacy_policy'),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    context.tr('privacy_policy_soon'),
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            context: context,
                            w: w,
                            h: h,
                            icon: Icons.description_outlined,
                            title: context.tr('terms_conditions_title'),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    context.tr('terms_conditions_soon'),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: h * 0.01),

                          // Danger Items (Red)
                          _buildDangerItem(
                            context: context,
                            w: w,
                            h: h,
                            icon: Icons.delete_outline_rounded,
                            title: context.tr('delete_account'),
                            onTap: () => _showConfirmationDialog(
                              context: context,
                              title: context.tr('delete_account'),
                              content: context.tr('delete_account_confirm'),
                              confirmText: context.tr('delete'),
                              onConfirm: () => provider.deleteAccount(context),
                            ),
                          ),
                          _buildDangerItem(
                            context: context,
                            w: w,
                            h: h,
                            icon: Icons.logout_rounded,
                            title: context.tr('log_out'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LogoutScreen(),
                                ),
                              );
                            },
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

  // Standard Menu Row (Black text, arrow forward)
  Widget _buildMenuItem({
    required BuildContext context,
    required double w,
    required double h,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(w * 0.02),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: h * 0.018),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.textPrimary(context),
                  size: w * 0.06,
                ),
                SizedBox(width: w * 0.04),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: w * 0.038,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: w * 0.035,
                  color: AppColors.textSecondary(context),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: AppColors.divider(context).withValues(alpha: 0.6),
        ),
      ],
    );
  }

  // Danger Menu Row (Red text/icon, no arrow)
  Widget _buildDangerItem({
    required BuildContext context,
    required double w,
    required double h,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(w * 0.02),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: h * 0.018),
            child: Row(
              children: [
                Icon(icon, color: AppColors.error, size: w * 0.06),
                SizedBox(width: w * 0.04),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: w * 0.038,
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: AppColors.divider(context).withValues(alpha: 0.6),
        ),
      ],
    );
  }

  // Confirmation Dialog
  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(ctx),
          ),
        ),
        content: Text(
          content,
          style: TextStyle(color: AppColors.textSecondary(ctx)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              ctx.tr('cancel'),
              style: TextStyle(color: AppColors.textSecondary(ctx)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: Text(
              confirmText,
              style: const TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
