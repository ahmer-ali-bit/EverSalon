import 'package:ever_salon/provider/auth%20providers/otp_provider.dart';
import 'package:ever_salon/screen/auth/auth%20screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:ever_salon/widgets/validation_alert.dart';
// import 'package:ever_salon/screens/account_created_screen.dart';
// import 'package:ever_salon/screens/reset_password_screen.dart';

// 👉 SCREEN-BASED PROVIDER INJECTION
class OtpVerificationScreen extends StatelessWidget {
  final String phoneOrEmail;

  const OtpVerificationScreen({
    super.key,
    this.phoneOrEmail =
        '+92 300 1234567', // Pass real value from Register / Forgot Password
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OtpProvider(),
      child: _OtpVerificationView(phoneOrEmail: phoneOrEmail),
    );
  }
}

// 👉 ACTUAL SCREEN UI
class _OtpVerificationView extends StatefulWidget {
  final String phoneOrEmail;

  const _OtpVerificationView({required this.phoneOrEmail});

  @override
  State<_OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<_OtpVerificationView> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  List<String> _errors = [];

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  // Verify button / auto-submit when 4 digits entered
  void _handleVerify() async {
    final provider = Provider.of<OtpProvider>(context, listen: false);
    final otp = _otpController.text.trim();

    if (otp.length < 4) {
      setState(() => _errors = [context.tr('enter_otp_error')]);
      return;
    }

    setState(() => _errors = []);

    final success = await provider.verifyOtp(
      otp: otp,
      phoneOrEmail: widget.phoneOrEmail,
    );

    if (success && mounted) {
      // ========================================================
      // TODO: NAVIGATION AFTER SUCCESSFUL OTP
      // From Register  -> AccountCreatedScreen / Home
      // From Forgot    -> ResetPasswordScreen
      // Example:
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const AccountCreatedScreen()),
      // );
      // ========================================================
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr('otp_verified'))),
      );
    } else if (!success && mounted && provider.errorMessage != null) {
      setState(() => _errors = [provider.errorMessage!]);
    }
  }

  // Resend OTP
  void _handleResend() async {
    final provider = Provider.of<OtpProvider>(context, listen: false);
    if (!provider.canResend) return;

    final success = await provider.resendOtp(phoneOrEmail: widget.phoneOrEmail);

    if (success && mounted) {
      _otpController.clear();
      setState(() => _errors = []);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.tr('otp_resent'))));
    } else if (!success && mounted && provider.errorMessage != null) {
      setState(() => _errors = [provider.errorMessage!]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final provider = Provider.of<OtpProvider>(context);

    // Pinput theme — matches EverSalon pink UI
    final defaultPinTheme = PinTheme(
      width: screenWidth * 0.16,
      height: screenWidth * 0.16,
      textStyle: TextStyle(
        fontSize: screenWidth * 0.06,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary(context),
      ),
      decoration: BoxDecoration(
        color: AppColors.inputBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider(context)),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryPink, width: 1.8),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.primaryPink.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryPink),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error),
      ),
    );

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
              // Back Button
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

              SizedBox(height: screenHeight * 0.05),

              // Title
              Text(
                context.tr('verify_your_number'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.065,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),

              SizedBox(height: screenHeight * 0.015),

              // Subtitle + phone/email
              Text(
                context.tr('enter_4digit_code'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.038,
                  color: AppColors.textSecondary(context),
                ),
              ),
              SizedBox(height: screenHeight * 0.006),
              Text(
                widget.phoneOrEmail,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              // 👉 Pinput (4-digit OTP) — system keyboard opens automatically
              Pinput(
                length: 4,
                controller: _otpController,
                focusNode: _otpFocusNode,
                autofocus: true,
                keyboardType: TextInputType.number,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                errorPinTheme: errorPinTheme,
                forceErrorState: _errors.isNotEmpty,
                separatorBuilder: (index) =>
                    SizedBox(width: screenWidth * 0.04),
                onCompleted: (pin) {
                  // Auto-verify when user fills all 4 digits
                  _handleVerify();
                },
                onChanged: (value) {
                  if (_errors.isNotEmpty) setState(() => _errors = []);
                },
              ),

              SizedBox(height: screenHeight * 0.03),

              // Resend row with timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr('resend_code_in'),
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                  if (!provider.canResend)
                    Text(
                      provider.timerText, // e.g. 00:28
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryPink,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: provider.isLoading ? null : _handleResend,
                      child: Text(
                        context.tr('resend'),
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryPink,
                        ),
                      ),
                    ),
                ],
              ),

              // Validation / API error (row-style alert)
              if (_errors.isNotEmpty) ...[
                SizedBox(height: screenHeight * 0.025),
                ValidationAlert(errors: _errors),
              ],

              SizedBox(height: screenHeight * 0.05),

              // Verify Button
              CustomButton(
                text: context.tr('verify'),
                isLoading: provider.isLoading,
                // onTap: _handleVerify,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen(),
                    ),
                  );
                },
              ),

              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
