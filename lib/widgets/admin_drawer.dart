import 'package:ever_salon/Admin%20Panel/screens/main%20screen/analytics/analytics_screen.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/catalog/packages/packages_screen.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/coupon%20&%20discounts/coupon_screen.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/customers/customers_screen.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/payments/payments_screen.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/reviews/admin_reviews_screen.dart'; // IMPORT REVIEWS
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_translations.dart';

class AdminFancyDrawer extends StatelessWidget {
  final VoidCallback onClose;

  const AdminFancyDrawer({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: w,
        height: h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3A1C4A), // Dark Purple
              Color(0xFF6B2A8A), // Primary Purple
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.05,
              vertical: h * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Icon + Close button)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: w * 0.06,
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.spa,
                        color: Colors.white,
                        size: w * 0.06,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: w * 0.07,
                      ),
                      onPressed: onClose,
                    ),
                  ],
                ),
                SizedBox(height: h * 0.03),

                // Admin Details
                Text(
                  "Kiran Fatima",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.06,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  "Admin • EverSalon",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: w * 0.035,
                  ),
                ),
                SizedBox(height: h * 0.04),

                // Menu Items
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildMenuItem(
                        context: context,
                        w: w,
                        icon: Icons.people_alt_outlined,
                        title: 'Customers',
                        onTap: () {
                          onClose(); // Close drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminCustomersScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context: context,
                        w: w,
                        icon: Icons.analytics_outlined,
                        title: 'Analytics & Reports',
                        onTap: () {
                          onClose(); // Close drawer
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminAnalyticsScreen(),
                            ),
                          );
                        },
                      ),
                      // --- PAYMENTS & REVENUE ADDITION ---
                      _buildMenuItem(
                        context: context,
                        w: w,
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'Payments & Revenue',
                        onTap: () {
                          onClose();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminPaymentsScreen(),
                            ),
                          );
                        },
                      ),
                      // --- CUSTOMER REVIEWS ADDITION ---
                      _buildMenuItem(
                        context: context,
                        w: w,
                        icon: Icons.rate_review_outlined,
                        title: 'Customer Reviews',
                        onTap: () {
                          onClose();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminReviewsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context: context,
                        w: w,
                        icon: Icons.local_offer_outlined,
                        title: 'Coupons & Discounts',
                        onTap: () {
                          onClose();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminCouponsScreen(),
                            ),
                          );
                        },
                      ),

                      _buildMenuItem(
                        context: context,
                        w: w,
                        icon: Icons.card_giftcard,
                        title: 'Packages & Combos',
                        onTap: () {
                          onClose();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminPackagesScreen(),
                            ),
                          );
                        },
                      ),

                      _buildMenuItem(
                        context: context,
                        w: w,
                        icon: Icons.notifications_active_outlined,
                        title: 'Notifications',
                        onTap: () {
                          onClose();
                        },
                      ),

                      SizedBox(height: h * 0.02),
                      Divider(color: Colors.white.withValues(alpha: 0.2)),
                      SizedBox(height: h * 0.02),
                      _buildMenuItem(
                        context: context,
                        w: w,
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                // Logout Button
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: h * 0.01),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: AppColors.primaryPink,
                          size: w * 0.06,
                        ),
                        SizedBox(width: w * 0.04),
                        Text(
                          context.tr('Logout'),
                          style: TextStyle(
                            color: AppColors.primaryPink,
                            fontSize: w * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: h * 0.01),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required double w,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.02),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.03,
            vertical: w * 0.035,
          ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white.withValues(alpha: 0.9),
                size: w * 0.06,
              ),
              SizedBox(width: w * 0.04),
              Text(
                context.tr(title),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.95),
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withValues(alpha: 0.4),
                size: w * 0.035,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
