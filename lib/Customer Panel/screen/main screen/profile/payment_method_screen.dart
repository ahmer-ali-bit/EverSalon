import 'package:ever_salon/Customer%20Panel/provider/profile/payment_method_provider.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/add_new_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentMethodsProvider(),
      child: const _PaymentMethodsScreenBody(),
    );
  }
}

class _PaymentMethodsScreenBody extends StatefulWidget {
  const _PaymentMethodsScreenBody();

  @override
  State<_PaymentMethodsScreenBody> createState() =>
      _PaymentMethodsScreenBodyState();
}

class _PaymentMethodsScreenBodyState extends State<_PaymentMethodsScreenBody> {
  // Safe Translation Helper: Agar key na mile to beautiful fallback text dikhaye
  String t(BuildContext context, String key, String fallback) {
    String translated = context.tr(key) ?? key;
    return translated == key ? fallback : translated;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentMethodsProvider>();
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // STRICT HEADER FORMAT
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
                    t(context, 'payment_methods', 'Payment Methods'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewCardScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(w * 0.02),
                      child: Icon(
                        Icons.add,
                        color: AppColors.textPrimary(context),
                        size: w * 0.065,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // BODY
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: w * 0.05,
                          vertical: h * 0.02,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SECTION 1: SAVED CARDS
                            Text(
                              t(context, 'saved_cards', 'Saved Cards'),
                              style: TextStyle(
                                fontSize: w * 0.042,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                            SizedBox(height: h * 0.015),

                            ...provider.savedCards.map(
                              (card) =>
                                  _buildSavedCardItem(context, card, w, h),
                            ),

                            SizedBox(height: h * 0.035),

                            // SECTION 2: ADD NEW PAYMENT METHOD
                            Text(
                              t(
                                context,
                                'add_new_payment_method',
                                'Add New Payment Method',
                              ),
                              style: TextStyle(
                                fontSize: w * 0.042,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                            SizedBox(height: h * 0.015),

                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.cardBg(context),
                                borderRadius: BorderRadius.circular(w * 0.03),
                                border: Border.all(
                                  color: AppColors.divider(
                                    context,
                                  ).withValues(alpha: 0.5),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  _buildActionItem(
                                    context: context,
                                    w: w,
                                    h: h,
                                    icon: Icons.credit_card_outlined,
                                    title: t(
                                      context,
                                      'add_new_card',
                                      'Add New Card',
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddNewCardScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildActionItem(
                                    context: context,
                                    w: w,
                                    h: h,
                                    imageAsset: 'assets/images/jazz easy.png',
                                    title: t(
                                      context,
                                      'jazzcash_easypaisa',
                                      'JazzCash / EasyPaisa',
                                    ),
                                    onTap: () {},
                                  ),
                                  _buildActionItem(
                                    context: context,
                                    w: w,
                                    h: h,
                                    icon: Icons.account_balance_outlined,
                                    title: t(
                                      context,
                                      'bank_transfer',
                                      'Bank Transfer',
                                    ),
                                    onTap: () {},
                                    showDivider: false,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: h * 0.05),

                            // BOTTOM SECURITY INFO
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  color: AppColors.textSecondary(context),
                                  size: w * 0.035,
                                ),
                                SizedBox(width: w * 0.02),
                                Text(
                                  t(
                                    context,
                                    'payment_secure_info',
                                    'Your payment information is 100% secure.',
                                  ),
                                  style: TextStyle(
                                    fontSize: w * 0.032,
                                    color: AppColors.textSecondary(context),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: h * 0.04),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedCardItem(
    BuildContext context,
    SavedCardModel card,
    double w,
    double h,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: h * 0.015),
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.02),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.03),
        border: Border.all(
          color: AppColors.divider(context).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Card Logo container
          Container(
            width: w * 0.12,
            height: w * 0.08,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.isDark(context)
                  ? AppColors.scaffoldBg(context)
                  : AppColors.inputFill,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Image.asset(
              card.imageAsset,
              fit: BoxFit.contain,
              width: w * 0.08,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.credit_card,
                color: AppColors.textSecondary(context),
                size: w * 0.05,
              ),
            ),
          ),
          SizedBox(width: w * 0.04),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${card.brand} ${card.maskedNumber}',
                  style: TextStyle(
                    fontSize: w * 0.038,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: h * 0.003),
                Text(
                  'Expiry ${card.expiry}',
                  style: TextStyle(
                    fontSize: w * 0.032,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          // Trailing Action
          if (card.isDefault)
            Text(
              t(context, 'default', 'Default'),
              style: TextStyle(
                fontSize: w * 0.032,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPink,
              ),
            )
          else
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary(context),
              size: w * 0.04,
            ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required double w,
    required double h,
    IconData? icon,
    String? imageAsset,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(w * 0.03),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.04,
              vertical: h * 0.02,
            ),
            child: Row(
              children: [
                if (imageAsset != null)
                  Image.asset(
                    imageAsset,
                    width: w * 0.06,
                    height: w * 0.06,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColors.textPrimary(context),
                      size: w * 0.06,
                    ),
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    color: AppColors.textPrimary(context),
                    size: w * 0.06,
                  ),
                SizedBox(width: w * 0.035),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: w * 0.038,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary(context),
                  size: w * 0.04,
                ),
              ],
            ),
          ),
          if (showDivider)
            Divider(
              color: AppColors.divider(context).withValues(alpha: 0.5),
              height: 1,
              indent: w * 0.13, // Divider aligns with text
              endIndent: w * 0.04,
            ),
        ],
      ),
    );
  }
}
