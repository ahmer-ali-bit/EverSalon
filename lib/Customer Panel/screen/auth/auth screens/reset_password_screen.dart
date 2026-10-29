import 'package:ever_salon/Customer%20Panel/provider/auth%20providers/reset_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:ever_salon/widgets/custom_textfield.dart';
import 'package:ever_salon/widgets/validation_alert.dart';
import 'package:ever_salon/utils/validators.dart';
// import 'package:ever_salon/screens/login_screen.dart';
// import 'package:ever_salon/screens/account_created_screen.dart';

// 👉 SCREEN-BASED PROVIDER INJECTION
class ResetPasswordScreen extends StatelessWidget {
  /// Optional token received from Forgot Password / OTP flow
  final String? resetToken;

  const ResetPasswordScreen({super.key, this.resetToken});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResetPasswordProvider(),
      child: _ResetPasswordView(resetToken: resetToken),
    );
  }
}

// 👉 ACTUAL SCREEN UI
class _ResetPasswordView extends StatefulWidget {
  final String? resetToken;

  const _ResetPasswordView({this.resetToken});

  @override
  State<_ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<_ResetPasswordView> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  List<String> _errors = [];

  // Live password strength flags (UI checklist)
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Update checklist while user types new password
  void _onPasswordChanged(String value) {
    setState(() {
      _hasMinLength = Validators.hasMinLength(value);
      _hasUppercase = Validators.hasUppercase(value);
      _hasNumber = Validators.hasNumber(value);
      _hasSpecialChar = Validators.hasSpecialChar(value);

      if (_errors.isNotEmpty) _errors = [];
    });
  }

  bool get _allRulesPassed =>
      _hasMinLength && _hasUppercase && _hasNumber && _hasSpecialChar;

  void _handleResetPassword() async {
    final provider = Provider.of<ResetPasswordProvider>(context, listen: false);
    final List<String> errors = [];

    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    // Strong password + confirm match
    final passError = Validators.strongPassword(newPass);
    final confirmError = Validators.confirmPassword(confirmPass, newPass);

    if (passError != null) errors.add(passError);
    if (confirmError != null) errors.add(confirmError);

    setState(() => _errors = errors);

    if (errors.isEmpty) {
      final success = await provider.resetPassword(
        newPassword: newPass.trim(),
        confirmPassword: confirmPass.trim(),
        resetToken: widget.resetToken,
      );

      if (success && mounted) {
        // ========================================================
        // TODO: NAVIGATION AFTER SUCCESSFUL RESET
        // Usually go to Login or Account Created / Success screen
        // Example:
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (_) => const LoginScreen()),
        //   (route) => false,
        // );
        // ========================================================
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('password_reset_success'))),
        );
      } else if (!success && mounted && provider.errorMessage != null) {
        setState(() => _errors = [provider.errorMessage!]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final provider = Provider.of<ResetPasswordProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary(context),
                  size: 26,
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // Title
              Text(
                context.tr('reset_password'),
                style: TextStyle(
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),

              SizedBox(height: screenHeight * 0.008),

              // Subtitle
              Text(
                context.tr('create_new_password'),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: AppColors.textSecondary(context),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // New Password Field
              CustomTextField(
                hint: context.tr('new_password'),
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _newPasswordController,
                onChanged: _onPasswordChanged,
              ),

              SizedBox(height: screenHeight * 0.02),

              // Confirm New Password Field
              CustomTextField(
                hint: context.tr('confirm_new_password'),
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _confirmPasswordController,
                onChanged: (_) {
                  if (_errors.isNotEmpty) setState(() => _errors = []);
                },
              ),

              SizedBox(height: screenHeight * 0.03),

              // Password Rules Checklist (same as UI)
              _buildRuleItem(
                label: context.tr('at_least_8_chars'),
                isValid: _hasMinLength,
                screenWidth: screenWidth,
              ),
              SizedBox(height: screenHeight * 0.012),
              _buildRuleItem(
                label: context.tr('one_uppercase'),
                isValid: _hasUppercase,
                screenWidth: screenWidth,
              ),
              SizedBox(height: screenHeight * 0.012),
              _buildRuleItem(
                label: context.tr('one_number'),
                isValid: _hasNumber,
                screenWidth: screenWidth,
              ),
              SizedBox(height: screenHeight * 0.012),
              _buildRuleItem(
                label: context.tr('one_special_char'),
                isValid: _hasSpecialChar,
                screenWidth: screenWidth,
              ),

              // Validation / API Error Alert (row style)
              if (_errors.isNotEmpty) ...[
                SizedBox(height: screenHeight * 0.02),
                ValidationAlert(errors: _errors),
              ],

              SizedBox(height: screenHeight * 0.04),

              // Reset Password Button
              CustomButton(
                text: context.tr('reset_password'),
                isLoading: provider.isLoading,
                onTap: _handleResetPassword,
              ),

              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  /// Single checklist row with green tick when rule is passed
  Widget _buildRuleItem({
    required String label,
    required bool isValid,
    required double screenWidth,
  }) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: isValid ? AppColors.success : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isValid ? AppColors.success : AppColors.divider(context),
              width: 1.5,
            ),
          ),
          child: isValid
              ? const Icon(Icons.check, color: Colors.white, size: 14)
              : null,
        ),
        SizedBox(width: screenWidth * 0.03),
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.037,
            color: isValid
                ? AppColors.success
                : AppColors.textSecondary(context),
            fontWeight: isValid ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
