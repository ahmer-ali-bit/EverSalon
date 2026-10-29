import 'dart:io';
import 'package:ever_salon/Customer%20Panel/provider/profile/language_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/about_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/help_center_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/language_selection_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/account_settings_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/gift_cards_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/loyalty_points_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/manage_addresses_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/my_membership_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/notifications_setting_screen.dart';
import 'package:ever_salon/Customer%20Panel/provider/profile/theme_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/payment_method_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/theme_selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_translations.dart';
import '../../../provider/profile/my_profile_provider.dart';
import 'edit_profile_screen.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyProfileProvider()..fetchProfile(),
      child: const _MyProfileView(),
    );
  }
}

class _MyProfileView extends StatelessWidget {
  const _MyProfileView();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<MyProfileProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    // ─── Adaptive Colors ───
    final bg = AppColors.scaffoldBg(context);
    final cardBg = AppColors.cardBg(context);
    final textPrim = AppColors.textPrimary(context);
    final textSec = AppColors.textSecondary(context);
    final iconBg = AppColors.iconCircleBg(context);
    final divColor = AppColors.divider(context);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ───
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.015,
              ),
              child: Row(
                children: [
                  Text(
                    context.tr('my_profile'),
                    style: TextStyle(
                      color: textPrim,
                      fontSize: w * 0.065,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AccountSettingsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: w * 0.1,
                      height: w * 0.1,
                      decoration: BoxDecoration(
                        color: iconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.settings_outlined,
                        color: textPrim,
                        size: w * 0.05,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Body ───
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
                          SizedBox(height: h * 0.01),

                          // ─── User Card ───
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(w * 0.04),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(w * 0.04),
                              border: Border.all(color: divColor),
                              boxShadow: [
                                if (!AppColors.isDark(context))
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: provider.localAvatar != null
                                      ? Image.file(
                                          provider.localAvatar!,
                                          width: w * 0.18,
                                          height: w * 0.18,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) =>
                                              _avatarFallback(
                                                context,
                                                w,
                                                iconBg,
                                              ),
                                        )
                                      : Image.asset(
                                          provider.avatarUrl,
                                          width: w * 0.18,
                                          height: w * 0.18,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) =>
                                              _avatarFallback(
                                                context,
                                                w,
                                                iconBg,
                                              ),
                                        ),
                                ),
                                SizedBox(width: w * 0.035),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        provider.name,
                                        style: TextStyle(
                                          fontSize: w * 0.045,
                                          fontWeight: FontWeight.bold,
                                          color: textPrim,
                                        ),
                                      ),
                                      SizedBox(height: h * 0.004),
                                      Text(
                                        provider.phone,
                                        style: TextStyle(
                                          fontSize: w * 0.032,
                                          color: textSec,
                                        ),
                                      ),
                                      SizedBox(height: h * 0.002),
                                      Text(
                                        provider.email,
                                        style: TextStyle(
                                          fontSize: w * 0.032,
                                          color: textSec,
                                        ),
                                      ),
                                      SizedBox(height: h * 0.01),
                                      GestureDetector(
                                        onTap: () async {
                                          final result =
                                              await Navigator.push<
                                                Map<String, dynamic>
                                              >(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const EditProfileScreen(),
                                                ),
                                              );
                                          if (result != null &&
                                              context.mounted) {
                                            context
                                                .read<MyProfileProvider>()
                                                .updateLocalProfile(
                                                  name:
                                                      result['name'] as String?,
                                                  phone:
                                                      result['phone']
                                                          as String?,
                                                  email:
                                                      result['email']
                                                          as String?,
                                                  avatar:
                                                      result['avatar'] as File?,
                                                );
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: w * 0.04,
                                            vertical: h * 0.006,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              w * 0.06,
                                            ),
                                            border: Border.all(
                                              color: AppColors.primaryPink,
                                              width: 1.2,
                                            ),
                                          ),
                                          child: Text(
                                            context.tr('edit_profile'),
                                            style: TextStyle(
                                              fontSize: w * 0.03,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryPink,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: h * 0.025),

                          // ─── Menu List ───
                          _menuItem(
                            w: w,
                            h: h,
                            icon: Icons.calendar_month_outlined,
                            title: context.tr('my_bookings'),
                            textPrim: textPrim,
                            textSec: textSec,
                            divColor: divColor,
                            onTap: () {
                              // TODO: Navigate to My Bookings
                            },
                          ),
                          _menuItem(
                            w: w,
                            h: h,
                            icon: Icons.diamond_outlined,
                            title: context.tr('loyalty_points'),
                            trailingText:
                                '${_formatPoints(provider.loyaltyPoints)} ${context.tr('pts')}',
                            textPrim: textPrim,
                            textSec: textSec,
                            divColor: divColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoyaltyPointsScreen(),
                                ),
                              );
                            },
                          ),
                          _menuItem(
                            w: w,
                            h: h,
                            icon: Icons.card_membership_outlined,
                            title: context.tr('membership'),
                            textPrim: textPrim,
                            textSec: textSec,
                            divColor: divColor,
                            trailingWidget: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.025,
                                vertical: h * 0.004,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFD4A017),
                                    Color(0xFFF5D76E),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(w * 0.03),
                              ),
                              child: Text(
                                provider.membershipTier,
                                style: TextStyle(
                                  fontSize: w * 0.028,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MyMembershipScreen(),
                                ),
                              );
                            },
                          ),
                          _menuItem(
                            w: w,
                            h: h,
                            icon: Icons.card_giftcard_outlined,
                            title: context.tr('gift_cards'),
                            trailingText:
                                '${provider.giftCardsCount} ${context.tr('cards')}',
                            textPrim: textPrim,
                            textSec: textSec,
                            divColor: divColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const GiftCardsScreen(),
                                ),
                              );
                            },
                          ),
                          _menuItem(
                            w: w,
                            h: h,
                            icon: Icons.payment_outlined,
                            title: context.tr('payment_methods'),
                            textPrim: textPrim,
                            textSec: textSec,
                            divColor: divColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PaymentMethodsScreen(),
                                ),
                              );
                            },
                          ),
                          _menuItem(
                            w: w,
                            h: h,
                            icon: Icons.location_on_outlined,
                            title: 'Addresses',
                            textPrim: textPrim,
                            textSec: textSec,
                            divColor: divColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ManageAddressesScreen(),
                                ),
                              );
                            },
                          ),
                          _menuItem(
                            w: w,
                            h: h,
                            icon: Icons.notifications_outlined,
                            title: context.tr('notification_settings'),
                            textPrim: textPrim,
                            textSec: textSec,
                            divColor: divColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const NotificationsSettingsScreen(),
                                ),
                              );
                            },
                          ),
                          _menuItem(
                            w: w,
                            h: h,
                            icon: Icons.settings_outlined,
                            title: context.tr('account_settings'),
                            textPrim: textPrim,
                            textSec: textSec,
                            divColor: divColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AccountSettingsScreen(),
                                ),
                              );
                            },
                          ),

                          // ─── APP THEME MENU ITEM ───
                          _menuItem(
                            w: w,
                            h: h,
                            icon: Icons.palette_outlined,
                            title: context.tr('app_theme'),
                            trailingText:
                                themeProvider.themeMode == ThemeMode.dark
                                ? context.tr('dark')
                                : themeProvider.themeMode == ThemeMode.light
                                ? context.tr('light')
                                : context.tr('system'),
                            textPrim: textPrim,
                            textSec: textSec,
                            divColor: divColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ThemeSelectionScreen(),
                                ),
                              );
                            },
                          ),

                          _menuItem(
                            w: w,
                            h: h,
                            icon: Icons.language_outlined,
                            title: context.tr('language'),
                            trailingText: context
                                .watch<LanguageProvider>()
                                .selectedLanguage,
                            textPrim: textPrim,
                            textSec: textSec,
                            divColor: divColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const LanguageSelectionScreen(),
                                ),
                              );
                            },
                          ),

                          _menuItem(
                            w: w,
                            h: h,
                            icon: Icons.support_agent_outlined,
                            title: context.tr('help_support'),
                            textPrim: textPrim,
                            textSec: textSec,
                            divColor: divColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HelpCenterScreen(),
                                ),
                              );
                            },
                          ),
                          _menuItem(
                            w: w,
                            h: h,
                            icon: Icons.info_outline_rounded,
                            title: 'About EverSalon',
                            trailingText: 'v1.0.0',
                            textPrim: textPrim,
                            textSec: textSec,
                            divColor: divColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AboutEverSalonScreen(),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: h * 0.02),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback(BuildContext context, double w, Color bg) {
    return Container(
      width: w * 0.18,
      height: w * 0.18,
      color: bg,
      child: Icon(
        Icons.person,
        size: w * 0.1,
        color: AppColors.textSecondary(context),
      ),
    );
  }

  String _formatPoints(int points) {
    final str = points.toString();
    if (str.length <= 3) return str;
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }

  Widget _menuItem({
    required double w,
    required double h,
    required IconData icon,
    required String title,
    String? trailingText,
    Widget? trailingWidget,
    required Color textPrim,
    required Color textSec,
    required Color divColor,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(w * 0.02),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: h * 0.016),
            child: Row(
              children: [
                Container(
                  width: w * 0.1,
                  height: w * 0.1,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(w * 0.025),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primaryPink,
                    size: w * 0.05,
                  ),
                ),
                SizedBox(width: w * 0.035),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: w * 0.038,
                      fontWeight: FontWeight.w500,
                      color: textPrim,
                    ),
                  ),
                ),
                if (trailingWidget != null) ...[
                  trailingWidget,
                  SizedBox(width: w * 0.02),
                ] else if (trailingText != null) ...[
                  Text(
                    trailingText,
                    style: TextStyle(
                      fontSize: w * 0.032,
                      fontWeight: FontWeight.w500,
                      color: textSec,
                    ),
                  ),
                  SizedBox(width: w * 0.02),
                ],
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: w * 0.035,
                  color: textSec,
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: divColor.withValues(alpha: 0.6),
        ),
      ],
    );
  }
}
