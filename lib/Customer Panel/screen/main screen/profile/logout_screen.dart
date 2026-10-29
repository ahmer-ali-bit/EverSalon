import 'package:ever_salon/Customer%20Panel/provider/profile/logout_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/auth/auth%20screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../widgets/custom_button.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LogoutProvider(),
      child: const _LogoutView(),
    );
  }
}

class _LogoutView extends StatelessWidget {
  const _LogoutView();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<LogoutProvider>();

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
                    'Logout',
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

            // ─── CENTER CONTENT ───
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // ─── LOGOUT ICON CIRCLE ───
                    Container(
                      width: w * 0.28,
                      height: w * 0.28,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryPink.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        color: AppColors.primaryPink,
                        size: w * 0.13,
                      ),
                    ),

                    SizedBox(height: h * 0.04),

                    // ─── TITLE ───
                    Text(
                      'Are you sure?',
                      style: TextStyle(
                        fontSize: w * 0.06,
                        fontWeight: FontWeight.bold,
                        color: textPrim,
                      ),
                    ),

                    SizedBox(height: h * 0.012),

                    // ─── SUBTITLE ───
                    Text(
                      'You will be logged out from your account.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: w * 0.038,
                        color: textSec,
                        height: 1.4,
                      ),
                    ),

                    const Spacer(),

                    // ─── BUTTONS ───
                    // 1) Pink Logout Button
                    CustomButton(
                      text: 'Logout',
                      isLoading: provider.isLoading,
                      onTap: () async {
                        final success = await provider.performLogout();
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Successfully logged out!'),
                            ),
                          );

                          // TODO: Navigate to Login Screen and clear route stack
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );

                          Navigator.pop(context); // Fallback pop for demo
                        }
                      },
                    ),

                    SizedBox(height: h * 0.018),

                    // 2) Outlined Cancel Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: double.infinity,
                        height: h * 0.065,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(w * 0.08),
                          border: Border.all(color: divColor, width: 1.5),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.w600,
                            color: textPrim,
                          ),
                        ),
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
}
