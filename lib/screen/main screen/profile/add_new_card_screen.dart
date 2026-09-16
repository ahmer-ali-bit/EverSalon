import 'package:ever_salon/provider/profile/add_new_card_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_translations.dart';
import '../../../../widgets/custom_button.dart';

class AddNewCardScreen extends StatelessWidget {
  const AddNewCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddNewCardProvider(),
      child: const _AddNewCardScreenBody(),
    );
  }
}

class _AddNewCardScreenBody extends StatefulWidget {
  const _AddNewCardScreenBody();

  @override
  State<_AddNewCardScreenBody> createState() => _AddNewCardScreenBodyState();
}

class _AddNewCardScreenBodyState extends State<_AddNewCardScreenBody> {
  String t(BuildContext context, String key, String fallback) {
    final translated = context.tr(key);
    return translated == key ? fallback : translated;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddNewCardProvider>();
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ========== STRICT HEADER ==========
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
                        color: AppColors.iconCircleBg(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.textPrimary(context),
                        size: w * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  Text(
                    t(context, 'add_new_card', 'Add New Card'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // ========== BODY ==========
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.05,
                  vertical: h * 0.015,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. LIVE PINK GRADIENT CARD
                    _buildLiveCardPreview(context, provider, w, h),
                    SizedBox(height: h * 0.035),

                    // 2. CARD NUMBER
                    _buildLabel(
                      context,
                      w,
                      t(context, 'card_number', 'Card Number'),
                    ),
                    _buildTextField(
                      context: context,
                      w: w,
                      controller: provider.cardNumberController,
                      hint: '4242 4242 4242 4242',
                      keyboardType: TextInputType.number,
                      suffixIcon: Icons.credit_card,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        CardNumberFormatter(), // ← AUTO SPACE after 4 digits
                      ],
                      onChanged: provider.updateCardNumber,
                    ),
                    SizedBox(height: h * 0.02),

                    // 3. CARD HOLDER NAME
                    _buildLabel(
                      context,
                      w,
                      t(context, 'card_holder_name', 'Card Holder Name'),
                    ),
                    _buildTextField(
                      context: context,
                      w: w,
                      controller: provider.cardHolderController,
                      hint: 'Zainab Fatima',
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      onChanged: provider.updateCardHolderName,
                    ),
                    SizedBox(height: h * 0.02),

                    // 4. EXPIRY + CVV ROW
                    Row(
                      children: [
                        // Expiry Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(
                                context,
                                w,
                                t(context, 'expiry_date', 'Expiry Date'),
                              ),
                              _buildTextField(
                                context: context,
                                w: w,
                                controller: provider.expiryController,
                                hint: 'MM/YY',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                  ExpiryDateFormatter(), // ← AUTO SLASH after MM
                                ],
                                onChanged: provider.updateExpiryDate,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: w * 0.04),
                        // CVV
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(context, w, t(context, 'cvv', 'CVV')),
                              _buildTextField(
                                context: context,
                                w: w,
                                controller: provider.cvvController,
                                hint: '•••',
                                keyboardType: TextInputType.number,
                                obscureText: true,
                                suffixIcon: Icons.info_outline,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(3),
                                ],
                                onChanged: provider.updateCvv,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.025),

                    // 5. SAVE TOGGLE
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.01,
                        vertical: h * 0.005,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              t(
                                context,
                                'save_card_future',
                                'Save this card for future payments',
                              ),
                              style: TextStyle(
                                fontSize: w * 0.038,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                          Switch.adaptive(
                            value: provider.saveCardForFuture,
                            activeColor: AppColors.primaryPink,
                            onChanged: provider.toggleSaveCard,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.04),

                    // 6. SAVE BUTTON
                    CustomButton(
                      text: t(context, 'save_card', 'Save Card'),
                      isLoading: provider.isLoading,
                      onTap: () => provider.saveCard(context),
                    ),
                    SizedBox(height: h * 0.03),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== LIVE CARD PREVIEW =====================
  Widget _buildLiveCardPreview(
    BuildContext context,
    AddNewCardProvider provider,
    double w,
    double h,
  ) {
    return Container(
      width: double.infinity,
      height: h * 0.24,
      padding: EdgeInsets.symmetric(horizontal: w * 0.055, vertical: h * 0.025),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(w * 0.045),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // VISA logo top-right
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              'assets/images/visa card.png',
              width: w * 0.14,
              height: h * 0.03,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Text(
                'VISA',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  fontSize: w * 0.055,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),

          // Card Number
          Text(
            provider.formattedCardNumber,
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.055,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),

          // Holder + Expiry
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t(context, 'card_holder', 'Card Holder').toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: w * 0.028,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: h * 0.004),
                  Text(
                    provider.displayName.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.036,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t(context, 'expiry', 'Expiry').toUpperCase(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: w * 0.028,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: h * 0.004),
                  Text(
                    provider.displayExpiry,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.036,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================== HELPERS =====================
  Widget _buildLabel(BuildContext context, double w, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: hSafe(context) * 0.008),
      child: Text(
        text,
        style: TextStyle(
          fontSize: w * 0.037,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary(context),
        ),
      ),
    );
  }

  double hSafe(BuildContext context) => MediaQuery.of(context).size.height;

  Widget _buildTextField({
    required BuildContext context,
    required double w,
    required TextEditingController controller,
    required String hint,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    IconData? suffixIcon,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg(context),
        borderRadius: BorderRadius.circular(w * 0.03),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        textCapitalization: textCapitalization,
        style: TextStyle(
          color: AppColors.textPrimary(context),
          fontSize: w * 0.04,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.textSecondary(context),
            fontSize: w * 0.038,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: w * 0.038,
          ),
          suffixIcon: suffixIcon != null
              ? Icon(
                  suffixIcon,
                  color: AppColors.textSecondary(context),
                  size: w * 0.055,
                )
              : null,
        ),
      ),
    );
  }
}
