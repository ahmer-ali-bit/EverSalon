import 'package:ever_salon/Admin%20Panel/providers/notifications/notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class AdminNotificationsScreen extends StatelessWidget {
  const AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Agar pehle se provider available hai (Dashboard se) to use karo, warna naya banao
    final existing = context.read<AdminNotificationsProvider?>();
    if (existing != null) {
      return const _AdminNotificationsContent();
    }
    return ChangeNotifierProvider(
      create: (_) => AdminNotificationsProvider(),
      child: const _AdminNotificationsContent(),
    );
  }
}

class _AdminNotificationsContent extends StatelessWidget {
  const _AdminNotificationsContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminNotificationsProvider>();

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
                    context.tr('Notifications'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  // Badge beside title
                  if (provider.unreadCount > 0) ...[
                    SizedBox(width: w * 0.02),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.025,
                        vertical: w * 0.008,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink,
                        borderRadius: BorderRadius.circular(w * 0.04),
                      ),
                      child: Text(
                        '${provider.unreadCount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  GestureDetector(
                    onTap: provider.markAllAsRead,
                    child: Text(
                      context.tr('Mark all as read'),
                      style: TextStyle(
                        fontSize: w * 0.035,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPink,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : provider.notifications.isEmpty
                  ? Center(
                      child: Text(
                        context.tr('No notifications'),
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: w * 0.04,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.01,
                      ),
                      itemCount: provider.notifications.length,
                      separatorBuilder: (_, _) => Divider(
                        color: AppColors.inputBg(context),
                        thickness: 1.5,
                        height: h * 0.03,
                      ),
                      itemBuilder: (context, index) {
                        final item = provider.notifications[index];
                        return _buildTile(context, w, item, provider);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context,
    double w,
    Map<String, dynamic> item,
    AdminNotificationsProvider provider,
  ) {
    IconData icon;
    Color iconColor;
    Color bgColor;

    switch (item['type']) {
      case 'booking':
        icon = Icons.calendar_today_outlined;
        iconColor = AppColors.primaryPink;
        bgColor = AppColors.primaryPink.withValues(alpha: 0.1);
        break;
      case 'payment':
        icon = Icons.account_balance_wallet_outlined;
        iconColor = AppColors.success;
        bgColor = AppColors.success.withValues(alpha: 0.1);
        break;
      case 'review':
        icon = Icons.star_border_rounded;
        iconColor = Colors.orange;
        bgColor = Colors.orange.withValues(alpha: 0.1);
        break;
      default:
        icon = Icons.info_outline;
        iconColor = Colors.blue;
        bgColor = Colors.blue.withValues(alpha: 0.1);
    }

    final bool isRead = item['isRead'] == true;

    return GestureDetector(
      onTap: () => provider.markAsRead(item['id']),
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(w * 0.03),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: w * 0.055),
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] ?? '',
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: isRead ? FontWeight.w600 : FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: w * 0.01),
                  Text(
                    item['subtitle'] ?? '',
                    style: TextStyle(
                      fontSize: w * 0.035,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item['time'] ?? '',
                  style: TextStyle(
                    fontSize: w * 0.03,
                    color: AppColors.textGrey,
                  ),
                ),
                SizedBox(height: w * 0.02),
                if (!isRead)
                  Container(
                    width: w * 0.025,
                    height: w * 0.025,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryPink,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
