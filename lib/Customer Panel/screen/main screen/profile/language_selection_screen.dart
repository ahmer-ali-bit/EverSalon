import 'package:ever_salon/Customer%20Panel/provider/profile/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<LanguageProvider>();

    // Adaptive Colors
    final bg = AppColors.scaffoldBg(context);
    final cardBg = AppColors.cardBg(context);
    final textPrim = AppColors.textPrimary(context);
    final iconBg = AppColors.iconCircleBg(context);

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
                    context.tr('language'),
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
                    SizedBox(height: h * 0.02),

                    // ─── TOP GRADIENT CARD ───
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(w * 0.05),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(w * 0.04),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.language,
                            color: Colors.white,
                            size: w * 0.1,
                          ),
                          SizedBox(width: w * 0.04),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.tr('select_language'),
                                  style: TextStyle(
                                    fontSize: w * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: h * 0.005),
                                Text(
                                  context.tr('choose_language'),
                                  style: TextStyle(
                                    fontSize: w * 0.032,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.03),

                    // ─── LANGUAGE LIST ───
                    _buildLanguageOption(
                      w: w,
                      context: context,
                      nativeName: 'English',
                      englishName: context.tr('default_lang'),
                      value: 'English',
                      currentValue: provider.selectedLanguage,
                      cardBg: cardBg,
                      textPrim: textPrim,
                      onTap: () => provider.changeLanguage('English', 'en'),
                    ),
                    _buildLanguageOption(
                      w: w,
                      context: context,
                      nativeName: 'اردو',
                      englishName: 'Urdu',
                      value: 'Urdu',
                      currentValue: provider.selectedLanguage,
                      cardBg: cardBg,
                      textPrim: textPrim,
                      onTap: () => provider.changeLanguage('Urdu', 'ur'),
                    ),
                    _buildLanguageOption(
                      w: w,
                      context: context,
                      nativeName: 'العربية',
                      englishName: 'Arabic',
                      value: 'Arabic',
                      currentValue: provider.selectedLanguage,
                      cardBg: cardBg,
                      textPrim: textPrim,
                      onTap: () => provider.changeLanguage('Arabic', 'ar'),
                    ),
                    _buildLanguageOption(
                      w: w,
                      context: context,
                      nativeName: 'हिंदी',
                      englishName: 'Hindi',
                      value: 'Hindi',
                      currentValue: provider.selectedLanguage,
                      cardBg: cardBg,
                      textPrim: textPrim,
                      onTap: () => provider.changeLanguage('Hindi', 'hi'),
                    ),
                    _buildLanguageOption(
                      w: w,
                      context: context,
                      nativeName: 'বাংলা',
                      englishName: 'Bangla',
                      value: 'Bangla',
                      currentValue: provider.selectedLanguage,
                      cardBg: cardBg,
                      textPrim: textPrim,
                      onTap: () => provider.changeLanguage('Bangla', 'bn'),
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

  Widget _buildLanguageOption({
    required double w,
    required BuildContext context,
    required String nativeName,
    required String englishName,
    required String value,
    required String currentValue,
    required Color cardBg,
    required Color textPrim,
    required VoidCallback onTap,
  }) {
    final isSelected = value == currentValue;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: w * 0.03),
        padding: EdgeInsets.all(w * 0.04),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryPink.withValues(alpha: 0.05)
              : cardBg,
          borderRadius: BorderRadius.circular(w * 0.04),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryPink
                : AppColors.divider(context),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.g_translate_outlined,
              color: isSelected
                  ? AppColors.primaryPink
                  : AppColors.textSecondary(context),
              size: w * 0.05,
            ),
            SizedBox(width: w * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nativeName,
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primaryPink : textPrim,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    englishName,
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
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
