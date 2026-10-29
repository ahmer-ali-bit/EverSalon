import 'package:ever_salon/Customer%20Panel/provider/profile/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../constants/app_colors.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final themeProvider = context.watch<ThemeProvider>();

    // Dynamic colors for real-time dark mode feel
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = AppColors.scaffoldBg(context);
    final textColor = AppColors.textPrimary(context);
    final iconBgColor = AppColors.inputBg(context);
    final cardColor = AppColors.cardBg(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: iconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: textColor,
                        size: w * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  Text(
                    'Theme',
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: textColor,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.02),
                    Text(
                      'Choose Your Theme',
                      style: TextStyle(
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: h * 0.02),

                    // Light Mode Option
                    _buildThemeOption(
                      context: context,
                      w: w,
                      title: 'Light Mode',
                      subtitle: 'Always light theme',
                      icon: Icons.light_mode_outlined,
                      isSelected: themeProvider.themeMode == ThemeMode.light,
                      onTap: () => themeProvider.setTheme(ThemeMode.light),
                      cardColor: cardColor,
                      textColor: textColor,
                    ),
                    SizedBox(height: h * 0.015),

                    // Dark Mode Option (Black Background Feel)
                    _buildThemeOption(
                      context: context,
                      w: w,
                      title: 'Dark Mode',
                      subtitle: 'Always dark theme',
                      icon: Icons.dark_mode_outlined,
                      isSelected: themeProvider.themeMode == ThemeMode.dark,
                      onTap: () => themeProvider.setTheme(ThemeMode.dark),
                      cardColor: cardColor,
                      textColor: textColor,
                    ),
                    SizedBox(height: h * 0.015),

                    // System Default Option
                    _buildThemeOption(
                      context: context,
                      w: w,
                      title: 'System Default',
                      subtitle: 'Use device settings',
                      icon: Icons.settings_system_daydream_outlined,
                      isSelected: themeProvider.themeMode == ThemeMode.system,
                      onTap: () => themeProvider.setTheme(ThemeMode.system),
                      cardColor: cardColor,
                      textColor: textColor,
                    ),

                    SizedBox(height: h * 0.04),

                    // ─── PREVIEW SECTION ───
                    Text(
                      'Preview',
                      style: TextStyle(
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: h * 0.02),

                    // Mock Chat/Booking Bubble Preview
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(w * 0.04),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(w * 0.04),
                        border: Border.all(
                          color: AppColors.divider(
                            context,
                          ).withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: w * 0.04,
                                backgroundColor: AppColors.primaryPink
                                    .withValues(alpha: 0.1),
                                child: Icon(
                                  Icons.face_3,
                                  color: AppColors.primaryPink,
                                  size: w * 0.05,
                                ),
                              ),
                              SizedBox(width: w * 0.03),
                              Text(
                                'EverSalon',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.035,
                                  color: textColor,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Today',
                                style: TextStyle(
                                  fontSize: w * 0.03,
                                  color: AppColors.textSecondary(context),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.015),
                          Container(
                            padding: EdgeInsets.all(w * 0.035),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2C2C2E)
                                  : AppColors.inputBg(context),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(w * 0.04),
                                bottomLeft: Radius.circular(w * 0.04),
                                bottomRight: Radius.circular(w * 0.04),
                              ),
                            ),
                            child: Text(
                              'Your beauty, our priority!',
                              style: TextStyle(
                                fontSize: w * 0.035,
                                color: textColor,
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.015),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.04,
                                vertical: h * 0.01,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryPink,
                                borderRadius: BorderRadius.circular(w * 0.04),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Let's book now",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: w * 0.03,
                                    ),
                                  ),
                                  SizedBox(width: w * 0.02),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: w * 0.035,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildThemeOption({
    required BuildContext context,
    required double w,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required Color cardColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryPink.withValues(alpha: 0.05)
              : cardColor,
          borderRadius: BorderRadius.circular(w * 0.04),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryPink
                : AppColors.divider(context).withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(w * 0.02),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryPink : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : AppColors.textSecondary(context),
                size: w * 0.05,
              ),
            ),
            SizedBox(width: w * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primaryPink : textColor,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            // Radio button icon manually designed for better UI
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? AppColors.primaryPink
                  : AppColors.textSecondary(context),
              size: w * 0.06,
            ),
          ],
        ),
      ),
    );
  }
}
