import 'package:ever_salon/Customer%20Panel/provider/auth%20providers/forgot_password_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/auth/auth%20screens/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:ever_salon/widgets/custom_textfield.dart';
import 'package:ever_salon/widgets/validation_alert.dart';
import 'package:ever_salon/utils/validators.dart';
// import 'package:ever_salon/screens/reset_password_screen.dart'; // Future import

// 👉 SCREEN-BASED PROVIDER INJECTION
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordProvider(),
      child: const _ForgotPasswordView(),
    );
  }
}

// 👉 ACTUAL SCREEN UI
class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  List<String> _errors = [];

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendLink() async {
    final provider = Provider.of<ForgotPasswordProvider>(
      context,
      listen: false,
    );
    final List<String> errors = [];

    // Local Validation
    final emailError = Validators.emailOrPhone(_emailController.text);
    if (emailError != null) errors.add(emailError);

    setState(() => _errors = errors);

    // Call Provider API Action if validation passes
    if (errors.isEmpty) {
      final success = await provider.sendResetLink(
        _emailController.text.trim(),
      );

      if (success && mounted) {
        // ========================================================
        // TODO: NAVIGATION TO RESET PASSWORD SCREEN OR OTP SCREEN
        // Example: Navigator.push(context, MaterialPageRoute(builder: (_) => const ResetPasswordScreen()));
        // ========================================================
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.tr('reset_link_sent'))));
      } else if (!success && mounted && provider.errorMessage != null) {
        setState(() => _errors = [provider.errorMessage!]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Listen to Provider for loading state
    final provider = Provider.of<ForgotPasswordProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button (Top Left)
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.textPrimary(context),
                    size: 26,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Illustration Image
              Image.asset(
                'assets/images/forgot_password.png', // Ensure this is added in your assets
                height: screenHeight * 0.22,
                fit: BoxFit.contain,
              ),

              SizedBox(height: screenHeight * 0.04),

              // Title
              Text(
                context.tr('forgot_password_title'),
                style: TextStyle(
                  fontSize: screenWidth * 0.065,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),

              SizedBox(height: screenHeight * 0.015),

              // Description Text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Text(
                  context.tr('forgot_password_desc'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.038,
                    color: AppColors.textSecondary(context),
                    height: 1.5,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Email / Phone Field
              CustomTextField(
                hint: context.tr('email_or_phone'),
                prefixIcon: Icons.person_outline,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) {
                  if (_errors.isNotEmpty) setState(() => _errors = []);
                },
              ),

              // Validation / API Error Alert
              if (_errors.isNotEmpty) ...[
                SizedBox(height: screenHeight * 0.02),
                ValidationAlert(errors: _errors),
              ],

              SizedBox(height: screenHeight * 0.035),

              // Send Reset Link Button
              CustomButton(
                text: context.tr('send_reset_link'),
                isLoading: provider.isLoading,
                // onTap: _handleSendLink,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpVerificationScreen(),
                    ),
                  );
                },
              ),

              SizedBox(height: screenHeight * 0.04),

              // Back to Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr('remember_password'),
                    style: TextStyle(
                      fontSize: screenWidth * 0.037,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Pops back to Login screen
                    },
                    child: Text(
                      context.tr('login'),
                      style: TextStyle(
                        fontSize: screenWidth * 0.037,
                        color: AppColors.primaryPink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
