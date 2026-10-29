import 'package:ever_salon/Admin%20Panel/providers/drawer/admin_drawer_provider.dart';
import 'package:ever_salon/Admin%20Panel/providers/notifications/notifications_provider.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/notifications/notifications_screen.dart';
import 'package:ever_salon/widgets/admin_notifications_bedge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_translations.dart';
import '../../../providers/dashboard/admin_dashboard_provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminDashboardProvider(),
      child: const _AdminDashboardContent(),
    );
  }
}

class _AdminDashboardContent extends StatelessWidget {
  const _AdminDashboardContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminDashboardProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.textPrimary(context)),
          onPressed: () {
            // Open 3D Animated Drawer
            context.read<AdminDrawerProvider>().toggleDrawer();
          },
        ),
        title: Text(
          context.tr('Dashboard'),
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: w * 0.05,
          ),
        ),
        centerTitle: true,
        actions: [
          // Badge ke liye NotificationsProvider inject
          ChangeNotifierProvider(
            create: (_) => AdminNotificationsProvider(),
            child: Consumer<AdminNotificationsProvider>(
              builder: (context, notifProvider, _) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: notifProvider,
                            child: const AdminNotificationsScreen(),
                          ),
                        ),
                      );
                      // Wapas aane pe count refresh (agar mark as read hua)
                    },
                    icon: AdminNotificationBadge(
                      count: notifProvider.unreadCount,
                      child: Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.textPrimary(context),
                        size: MediaQuery.of(context).size.width * 0.065,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryPink),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: h * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Today's Overview Header ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.tr("Today's Overview"),
                          style: TextStyle(
                            fontSize: w * 0.045,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.03,
                            vertical: h * 0.005,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.inputBg(context),
                            borderRadius: BorderRadius.circular(w * 0.02),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: provider.selectedDate,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                              ),
                              style: TextStyle(
                                color: AppColors.textSecondary(context),
                                fontSize: w * 0.035,
                              ),
                              items: ["May 15, 2024", "May 14, 2024"]
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) provider.updateDate(val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.02),

                    // --- Stats Grid ---
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: w * 0.03,
                      mainAxisSpacing: h * 0.015,
                      childAspectRatio: 1.5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildStatCard(
                          context,
                          w,
                          "Bookings",
                          provider.stats['bookings'],
                        ),
                        _buildStatCard(
                          context,
                          w,
                          "Revenue",
                          provider.stats['revenue'],
                        ),
                        _buildStatCard(
                          context,
                          w,
                          "Customers",
                          provider.stats['customers'],
                        ),
                        _buildStatCard(
                          context,
                          w,
                          "Services",
                          provider.stats['services'],
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.03),

                    // --- Recent Bookings Header ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.tr('Recent Bookings'),
                          style: TextStyle(
                            fontSize: w * 0.045,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // NAVIGATION: To Bookings Tab
                          },
                          child: Text(
                            context.tr('View All'),
                            style: TextStyle(
                              fontSize: w * 0.035,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.015),

                    // --- Recent Bookings List ---
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.recentBookings.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: h * 0.015),
                      itemBuilder: (context, index) {
                        final item = provider.recentBookings[index];
                        return _buildBookingTile(context, w, item);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    double w,
    String title,
    Map<String, String>? data,
  ) {
    final valueText = data?['value'] ?? '0';
    final trendText = data?['trend'] ?? '+0%';

    return Container(
      padding: EdgeInsets.all(w * 0.035),
      decoration: BoxDecoration(
        color: AppColors.primaryPink.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: AppColors.primaryPink.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: w * 0.035,
              color: AppColors.textSecondary(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            valueText,
            style: TextStyle(
              fontSize: w * 0.045,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                trendText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
              Text(
                " vs yesterday",
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingTile(
    BuildContext context,
    double w,
    Map<String, String> item,
  ) {
    final customerName = item['customerName'] ?? 'Customer';
    final serviceName = item['service'] ?? 'Service';
    final timeStr = item['time'] ?? '';
    final statusStr = item['status'] ?? 'Pending';
    final imagePath = item['image'] ?? '';

    final bool isConfirmed = statusStr == 'Confirmed';

    return Container(
      padding: EdgeInsets.all(w * 0.03),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(w * 0.02),
            child: imagePath.isNotEmpty
                ? Image.asset(
                    imagePath,
                    width: w * 0.12,
                    height: w * 0.12,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: w * 0.12,
                      height: w * 0.12,
                      color: AppColors.inputBg(context),
                      child: Icon(
                        Icons.person,
                        size: w * 0.06,
                        color: AppColors.textGrey,
                      ),
                    ),
                  )
                : Container(
                    width: w * 0.12,
                    height: w * 0.12,
                    color: AppColors.inputBg(context),
                    child: Icon(
                      Icons.person,
                      size: w * 0.06,
                      color: AppColors.textGrey,
                    ),
                  ),
          ),
          SizedBox(width: w * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: TextStyle(
                    fontSize: w * 0.035,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: w * 0.01),
                Text(
                  serviceName,
                  style: TextStyle(
                    fontSize: w * 0.03,
                    color: AppColors.textSecondary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeStr,
                style: TextStyle(
                  fontSize: w * 0.03,
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: w * 0.015),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.02,
                  vertical: w * 0.005,
                ),
                decoration: BoxDecoration(
                  color: isConfirmed
                      ? AppColors.success.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(w * 0.015),
                  border: Border.all(
                    color: isConfirmed
                        ? AppColors.success.withValues(alpha: 0.5)
                        : Colors.orange.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  statusStr,
                  style: TextStyle(
                    fontSize: w * 0.025,
                    fontWeight: FontWeight.bold,
                    color: isConfirmed ? AppColors.success : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
