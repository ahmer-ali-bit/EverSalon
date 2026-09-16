import 'package:ever_salon/provider/customer%20home%20providers/notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationsProvider()..fetchNotifications(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationsProvider>(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Padding(
              padding: EdgeInsets.all(padding),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.textPrimary(context),
                        size: screenWidth * 0.045,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Text(
                      context.tr('notifications'),
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- NOTIFICATIONS LIST ---
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : provider.notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: screenWidth * 0.2,
                            color: AppColors.divider(context),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            context.tr('no_notifications'),
                            style: TextStyle(
                              color: AppColors.textSecondary(context),
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: padding,
                        vertical: screenHeight * 0.01,
                      ),
                      itemCount: provider.notifications.length,
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.01,
                        ),
                        child: Divider(
                          color: AppColors.divider(context),
                          thickness: 1,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        final notification = provider.notifications[index];
                        return _buildNotificationItem(
                          context: context,
                          notification: notification,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          onTap: () => provider.markAsRead(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // --- NOTIFICATION ITEM WIDGET ---
  Widget _buildNotificationItem({
    required BuildContext context,
    required Map<String, dynamic> notification,
    required double screenWidth,
    required double screenHeight,
    required VoidCallback onTap,
  }) {
    final bool isUnread = !notification['isRead'];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent, // Makes the whole row clickable
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Icon
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                color: notification['iconBg'],
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification['icon'],
                color: notification['iconColor'],
                size: screenWidth * 0.06,
              ),
            ),
            SizedBox(width: screenWidth * 0.035),

            // Middle Content (Title + Message)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['title'],
                    style: TextStyle(
                      fontSize: screenWidth * 0.038,
                      fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    notification['message'],
                    style: TextStyle(
                      fontSize: screenWidth * 0.032,
                      color: isUnread
                          ? AppColors.textPrimary(context).withValues(alpha: 0.8)
                          : AppColors.textSecondary(context),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: screenWidth * 0.02),

            // Right Time & Unread Indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  notification['time'],
                  style: TextStyle(
                    fontSize: screenWidth * 0.028,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                if (isUnread)
                  Container(
                    height: screenWidth * 0.025,
                    width: screenWidth * 0.025,
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
