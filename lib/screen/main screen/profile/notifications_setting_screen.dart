import 'package:ever_salon/provider/profile/notifications_seting_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_translations.dart';

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationsSettingsProvider()..fetchSettings(),
      child: const _NotificationsSettingsView(),
    );
  }
}

class _NotificationsSettingsView extends StatelessWidget {
  const _NotificationsSettingsView();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<NotificationsSettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ─── HEADER: back + title sath (w * 0.03) ───
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
                    context.tr('notification_settings'),
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
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.01,
                      ),
                      itemCount: provider.settings.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.divider(context).withValues(alpha: 0.6),
                      ),
                      itemBuilder: (context, index) {
                        final item = provider.settings[index];
                        return _buildToggleRow(
                          context: context,
                          w: w,
                          h: h,
                          icon: item['icon'] as IconData,
                          title: item['title'] as String,
                          subtitle: item['subtitle'] as String,
                          value: item['value'] as bool,
                          onChanged: (val) {
                            provider.toggleSetting(index, val);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required BuildContext context,
    required double w,
    required double h,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.014),
      child: Row(
        children: [
          // Icon container
          Container(
            width: w * 0.11,
            height: w * 0.11,
            decoration: BoxDecoration(
              color: AppColors.primaryPink.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(w * 0.03),
            ),
            child: Icon(icon, color: AppColors.primaryPink, size: w * 0.05),
          ),
          SizedBox(width: w * 0.035),

          // Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: w * 0.038,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: h * 0.004),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: w * 0.03,
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Pink Toggle Switch
          Transform.scale(
            scale: 0.85,
            child: CupertinoSwitch(
              value: value,
              activeTrackColor: AppColors.primaryPink,
              inactiveTrackColor: AppColors.divider(context),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
