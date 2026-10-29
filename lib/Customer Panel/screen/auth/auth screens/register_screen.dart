import 'package:ever_salon/Customer%20Panel/provider/auth%20providers/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/widgets/custom_button.dart';
import 'package:ever_salon/widgets/custom_textfield.dart';
import 'package:ever_salon/widgets/validation_alert.dart';
import 'package:ever_salon/utils/validators.dart';

// 👉 SCREEN-BASED PROVIDER INJECTION
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterProvider(),
      child: const _RegisterScreenView(),
    );
  }
}

// 👉 ACTUAL SCREEN UI
class _RegisterScreenView extends StatefulWidget {
  const _RegisterScreenView();

  @override
  State<_RegisterScreenView> createState() => _RegisterScreenViewState();
}

class _RegisterScreenViewState extends State<_RegisterScreenView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _agreedToTerms = false;
  List<String> _errors = [];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    final registerProvider = Provider.of<RegisterProvider>(
      context,
      listen: false,
    );
    final List<String> errors = [];

    final nameError = Validators.name(_nameController.text);
    final emailError = Validators.emailOrPhone(_emailController.text);
    final passError = Validators.strongPassword(_passwordController.text);
    final confirmError = Validators.confirmPassword(
      _confirmPasswordController.text,
      _passwordController.text,
    );

    if (nameError != null) errors.add(nameError);
    if (emailError != null) errors.add(emailError);
    if (passError != null) errors.add(passError);
    if (confirmError != null) errors.add(confirmError);
    if (!_agreedToTerms) errors.add(context.tr('accept_terms_error'));

    setState(() => _errors = errors);

    if (errors.isEmpty) {
      final success = await registerProvider.register(
        fullName: _nameController.text.trim(),
        emailOrPhone: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (success && mounted) {
        // TODO: Navigate to OTP Screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('registration_success'))),
        );
      } else if (!success && mounted && registerProvider.errorMessage != null) {
        setState(() => _errors = [registerProvider.errorMessage!]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Listen to Provider for loading state
    final registerProvider = Provider.of<RegisterProvider>(context);

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
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.textPrimary(context),
                  size: 26,
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Text(
                context.tr('create_account'),
                style: TextStyle(
                  fontSize: screenWidth * 0.075,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              SizedBox(height: screenHeight * 0.008),
              Text(
                context.tr('sign_up_get_started'),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: AppColors.textSecondary(context),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              CustomTextField(
                hint: context.tr('full_name'),
                prefixIcon: Icons.person_outline,
                controller: _nameController,
                onChanged: (_) {
                  if (_errors.isNotEmpty) setState(() => _errors = []);
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                hint: context.tr('email_or_phone'),
                prefixIcon: Icons.email_outlined,
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
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                hint: context.tr('confirm_password'),
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _confirmPasswordController,
                onChanged: (_) {
                  if (_errors.isNotEmpty) setState(() => _errors = []);
                },
              ),
              SizedBox(height: screenHeight * 0.02),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() {
                      _agreedToTerms = !_agreedToTerms;
                      if (_agreedToTerms && _errors.isNotEmpty) _errors = [];
                    }),
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _agreedToTerms
                            ? AppColors.primaryPink
                            : AppColors.scaffoldBg(context),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: _agreedToTerms
                              ? AppColors.primaryPink
                              : AppColors.textSecondary(context),
                          width: 1.5,
                        ),
                      ),
                      child: _agreedToTerms
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.025),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: context.tr('i_agree_to'),
                        style: TextStyle(
                          fontSize: screenWidth * 0.037,
                          color: AppColors.textPrimary(context),
                        ),
                        children: [
                          TextSpan(
                            text: context.tr('terms_conditions'),
                            style: TextStyle(
                              fontSize: screenWidth * 0.037,
                              color: AppColors.primaryPink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              if (_errors.isNotEmpty) ...[
                SizedBox(height: screenHeight * 0.02),
                ValidationAlert(errors: _errors),
              ],
              SizedBox(height: screenHeight * 0.035),

              // Register Button with Loading State
              CustomButton(
                text: context.tr('register'),
                isLoading: registerProvider.isLoading,
                onTap: _handleRegister,
              ),

              SizedBox(height: screenHeight * 0.03),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.tr('already_have_account'),
                      style: TextStyle(
                        fontSize: screenWidth * 0.037,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
