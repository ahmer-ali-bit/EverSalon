import 'package:ever_salon/Customer%20Panel/provider/profile/about_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/share_app_sceen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
// Jab S99 ban jaye tab yeh uncomment karna:
// import 'share_app_screen.dart';

class AboutEverSalonScreen extends StatelessWidget {
  const AboutEverSalonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AboutProvider(),
      child: const _AboutEverSalonView(),
    );
  }
}

class _AboutEverSalonView extends StatelessWidget {
  const _AboutEverSalonView();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AboutProvider>();

    // Adaptive Colors
    final bg = AppColors.scaffoldBg(context);
    final textPrim = AppColors.textPrimary(context);
    final textSec = AppColors.textSecondary(context);
    final iconBg = AppColors.iconCircleBg(context);
    final divColor = AppColors.divider(context);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ─── STRICT HEADER FORMAT ───
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
                        color: iconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: textPrim,
                        size: w * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  Text(
                    'About EverSalon',
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: textPrim,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // ─── BODY ───
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  children: [
                    SizedBox(height: h * 0.03),

                    // ─── LOGO ───
                    Container(
                      width: w * 0.22,
                      height: w * 0.22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPink.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.spa_rounded, // placeholder logo icon
                        color: Colors.white,
                        size: w * 0.11,
                      ),
                    ),

                    SizedBox(height: h * 0.02),

                    // ─── APP NAME ───
                    Text(
                      provider.appName,
                      style: TextStyle(
                        fontSize: w * 0.055,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPink,
                      ),
                    ),
                    SizedBox(height: h * 0.006),

                    // ─── VERSION ───
                    Text(
                      'Version ${provider.appVersion}',
                      style: TextStyle(
                        fontSize: w * 0.032,
                        color: textSec,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: h * 0.02),

                    // ─── DESCRIPTION ───
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      child: Text(
                        provider.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: w * 0.034,
                          color: textSec,
                          height: 1.45,
                        ),
                      ),
                    ),

                    SizedBox(height: h * 0.03),

                    // ─── SOCIAL ICONS ROW (USING ASSETS) ───
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialImageButton(
                          w: w,
                          context: context,
                          assetPath: 'assets/images/facebook.png',
                          onTap: () => provider.openLink('facebook'),
                        ),
                        SizedBox(width: w * 0.05),
                        _socialImageButton(
                          w: w,
                          context: context,
                          assetPath: 'assets/images/instagram.png',
                          onTap: () => provider.openLink('instagram'),
                        ),
                        SizedBox(width: w * 0.05),
                        _socialImageButton(
                          w: w,
                          context: context,
                          assetPath: 'assets/images/tiktok.png',
                          onTap: () => provider.openLink('tiktok'),
                        ),
                      ],
                    ),

                    SizedBox(height: h * 0.035),

                    // ─── DIVIDER LINE ───
                    Divider(color: divColor.withValues(alpha: 0.6)),

                    SizedBox(height: h * 0.01),

                    // ─── MENU LIST ───
                    _aboutMenuItem(
                      w: w,
                      h: h,
                      icon: Icons.description_outlined,
                      title: 'Terms & Conditions',
                      textPrim: textPrim,
                      textSec: textSec,
                      divColor: divColor,
                      onTap: () => provider.openLink('terms'),
                    ),
                    _aboutMenuItem(
                      w: w,
                      h: h,
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      textPrim: textPrim,
                      textSec: textSec,
                      divColor: divColor,
                      onTap: () => provider.openLink('privacy'),
                    ),
                    _aboutMenuItem(
                      w: w,
                      h: h,
                      icon: Icons.star_outline_rounded,
                      title: 'Rate Us',
                      textPrim: textPrim,
                      textSec: textSec,
                      divColor: divColor,
                      onTap: () => provider.openLink('rate'),
                    ),
                    _aboutMenuItem(
                      w: w,
                      h: h,
                      icon: Icons.share_outlined,
                      title: 'Share App',
                      textPrim: textPrim,
                      textSec: textSec,
                      divColor: divColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ShareAppScreen(),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: h * 0.04),

                    // ─── FOOTER COPYRIGHT ───
                    Text(
                      'A Product by Evermont Global Technologies',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: w * 0.028, color: textSec),
                    ),
                    SizedBox(height: h * 0.008),
                    Text(
                      '© ${DateTime.now().year} EverSalon. All rights reserved.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: w * 0.026,
                        color: textSec.withValues(alpha: 0.7),
                      ),
                    ),

                    SizedBox(height: h * 0.04),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Social Images
  Widget _socialImageButton({
    required double w,
    required BuildContext context,
    required String assetPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w * 0.12,
        height: w * 0.12,
        padding: EdgeInsets.all(w * 0.025), // Padding so image fits nicely
        decoration: BoxDecoration(
          color: AppColors.inputBg(context),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.divider(context).withValues(alpha: 0.5),
          ),
          boxShadow: [
            if (!AppColors.isDark(context))
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => Icon(
            Icons.image_not_supported_outlined,
            size: w * 0.05,
            color: AppColors.textSecondary(context),
          ), // Error builder agar image load na ho
        ),
      ),
    );
  }

  // Helper Widget for Menu Items
  Widget _aboutMenuItem({
    required double w,
    required double h,
    required IconData icon,
    required String title,
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
