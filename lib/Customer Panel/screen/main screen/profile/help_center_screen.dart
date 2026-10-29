import 'package:ever_salon/Customer%20Panel/provider/profile/help_center_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/app_feedback_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HelpCenterProvider(),
      child: const _HelpCenterView(),
    );
  }
}

class _HelpCenterView extends StatelessWidget {
  const _HelpCenterView();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<HelpCenterProvider>();

    // ─── Adaptive Colors ───
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
                    'Help Center',
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

                    // ─── TOP GRADIENT SUPPORT CARD ───
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
                            Icons.headset_mic_outlined, // Headphone icon
                            color: Colors.white,
                            size: w * 0.1,
                          ),
                          SizedBox(width: w * 0.04),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'How can we help you?',
                                  style: TextStyle(
                                    fontSize: w * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: h * 0.005),
                                Text(
                                  "We're here to support you.",
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

                    // ─── LOADING INDICATOR ───
                    if (provider.isLoading)
                      Padding(
                        padding: EdgeInsets.only(bottom: h * 0.02),
                        child: const LinearProgressIndicator(
                          color: AppColors.primaryPink,
                        ),
                      ),

                    // ─── MENU LIST ───
                    _buildHelpMenuItem(
                      w: w,
                      h: h,
                      icon: Icons.help_outline,
                      title: 'FAQs',
                      subtitle: 'Find answers to common questions',
                      textPrim: textPrim,
                      textSec: textSec,
                      divColor: divColor,
                      onTap: () {
                        // TODO: Navigate to FAQs Screen (Not in current part)
                      },
                    ),
                    _buildHelpMenuItem(
                      w: w,
                      h: h,
                      icon: Icons.email_outlined,
                      title: 'Contact Us',
                      subtitle: 'Get in touch with our team',
                      textPrim: textPrim,
                      textSec: textSec,
                      divColor: divColor,
                      onTap: () {
                        // TODO: Navigate to Contact Us Screen
                      },
                    ),
                    _buildHelpMenuItem(
                      w: w,
                      h: h,
                      icon: Icons.support_agent_outlined,
                      title: 'Live Chat',
                      subtitle: 'Chat with our support agent',
                      textPrim: textPrim,
                      textSec: textSec,
                      divColor: divColor,
                      onTap: () => provider.initiateSupportAction('chat'),
                    ),
                    _buildHelpMenuItem(
                      w: w,
                      h: h,
                      icon: Icons.report_problem_outlined,
                      title: 'Report an Issue',
                      subtitle: 'Help us improve by reporting',
                      textPrim: textPrim,
                      textSec: textSec,
                      divColor: divColor,
                      onTap: () {
                        // TODO: Open Report Issue Form
                      },
                    ),
                    _buildHelpMenuItem(
                      w: w,
                      h: h,
                      icon: Icons.feedback_outlined,
                      title: 'Feedback',
                      subtitle: 'Share your feedback with us',
                      textPrim: textPrim,
                      textSec: textSec,
                      divColor: divColor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AppFeedbackScreen(),
                          ),
                        );
                      },
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

  Widget _buildHelpMenuItem({
    required double w,
    required double h,
    required IconData icon,
    required String title,
    required String subtitle,
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
                // Icon Background Circle (Pink with low opacity)
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
                // Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: w * 0.038,
                          fontWeight: FontWeight.w600,
                          color: textPrim,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: w * 0.03, color: textSec),
                      ),
                    ],
                  ),
                ),
                // Trailing Arrow
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
