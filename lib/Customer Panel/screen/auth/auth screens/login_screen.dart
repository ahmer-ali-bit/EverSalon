import 'package:ever_salon/Customer%20Panel/provider/auth%20providers/login_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/auth/auth%20screens/forgot_password_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/auth/auth%20screens/register_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:ever_salon/widgets/custom_textfield.dart';
import 'package:ever_salon/widgets/validation_alert.dart';
import 'package:ever_salon/utils/validators.dart';

// 👉 SCREEN-BASED PROVIDER INJECTION
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: const _LoginScreenView(),
    );
  }
}

// 👉 ACTUAL SCREEN UI
class _LoginScreenView extends StatefulWidget {
  const _LoginScreenView();

  @override
  State<_LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<_LoginScreenView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<String> _errors = [];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final List<String> errors = [];

    // Local Validation
    final emailError = Validators.emailOrPhone(_emailController.text);
    final passError = Validators.password(_passwordController.text);
    if (emailError != null) errors.add(emailError);
    if (passError != null) errors.add(passError);
    setState(() => _errors = errors);

    // Call Provider API Action
    if (errors.isEmpty) {
      final success = await loginProvider.login(
        emailOrPhone: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (success && mounted) {
        // TODO: Navigate to Home
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.tr('login_success'))));
      } else if (!success && mounted && loginProvider.errorMessage != null) {
        setState(() => _errors = [loginProvider.errorMessage!]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Listen to Provider for loading state
    final loginProvider = Provider.of<LoginProvider>(context);

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
              SizedBox(height: screenHeight * 0.04),
              Row(
                children: [
                  Text(
                    context.tr('welcome_back'),
                    style: TextStyle(
                      fontSize: screenWidth * 0.075,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text('👋', style: TextStyle(fontSize: screenWidth * 0.065)),
                ],
              ),
              SizedBox(height: screenHeight * 0.008),
              Text(
                context.tr('login_to_continue'),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: AppColors.textSecondary(context),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              CustomTextField(
                hint: context.tr('email_or_phone'),
                prefixIcon: Icons.person_outline,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) {
                  if (_errors.isNotEmpty) setState(() => _errors = []);
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                hint: context.tr('password'),
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
                onChanged: (_) {
                  if (_errors.isNotEmpty) setState(() => _errors = []);
                },
              ),
              SizedBox(height: screenHeight * 0.015),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    context.tr('forgot_password'),
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: AppColors.primaryPink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              if (_errors.isNotEmpty) ...[
                SizedBox(height: screenHeight * 0.02),
                ValidationAlert(errors: _errors),
              ],
              SizedBox(height: screenHeight * 0.03),

              // Login Button with Loading State
              CustomButton(
                text: context.tr('login'),
                isLoading: loginProvider.isLoading,
                // onTap: _handleLogin,
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                    (route) => false,
                  );
                },
              ),

              SizedBox(height: screenHeight * 0.03),
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.divider(context))),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                    ),
                    child: Text(
                      context.tr('or'),
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: AppColors.textPrimary(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.divider(context))),
                ],
              ),
              SizedBox(height: screenHeight * 0.03),
              // Social buttons (Google, FB, Apple logic will also go in provider later if needed)
              SizedBox(height: screenHeight * 0.05),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.tr('dont_have_account'),
                      style: TextStyle(
                        fontSize: screenWidth * 0.037,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()),
                      ),
                      child: Text(
                        context.tr('register'),
                        style: TextStyle(
                          fontSize: screenWidth * 0.037,
                          color: AppColors.primaryPink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
