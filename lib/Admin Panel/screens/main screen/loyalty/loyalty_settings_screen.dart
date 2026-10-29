import 'package:ever_salon/Admin%20Panel/providers/loyalty/loyalty_setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';
import '../../../../../widgets/custom_button.dart';

class AdminLoyaltySettingsScreen extends StatelessWidget {
  const AdminLoyaltySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminLoyaltySettingsProvider(),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminLoyaltySettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
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
                        color: AppColors.inputBg(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.textPrimary(context),
                        size: w * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.04),
                  Text(
                    context.tr('Loyalty Settings'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),

            // SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Banner
                    Container(
                      padding: EdgeInsets.all(w * 0.035),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryPink.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primaryPink,
                            size: w * 0.05,
                          ),
                          SizedBox(width: w * 0.03),
                          Expanded(
                            child: Text(
                              'These rules apply to all customers automatically based on their total spending.',
                              style: TextStyle(
                                fontSize: w * 0.03,
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.03),

                    // Points Rate
                    Text(
                      'Points Earning Rate',
                      style: TextStyle(
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    SizedBox(height: h * 0.005),
                    Text(
                      'How many rupees a customer needs to spend to earn 1 point',
                      style: TextStyle(
                        fontSize: w * 0.028,
                        color: AppColors.textGrey,
                      ),
                    ),
                    SizedBox(height: h * 0.012),
                    Container(
                      padding: EdgeInsets.all(w * 0.04),
                      decoration: BoxDecoration(
                        color: AppColors.cardBg(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.divider(context)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Rs.',
                            style: TextStyle(
                              fontSize: w * 0.04,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                          SizedBox(width: w * 0.02),
                          SizedBox(
                            width: w * 0.2,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                text: provider.pointsRate.toString(),
                              ),
                              onChanged: (v) => provider.updatePointsRate(
                                int.tryParse(v) ?? 100,
                              ),
                              style: TextStyle(
                                fontSize: w * 0.05,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryPink,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          Text(
                            'spent = 1 Point',
                            style: TextStyle(
                              fontSize: w * 0.035,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.03),

                    // Tier Thresholds
                    Text(
                      'Membership Tier Thresholds',
                      style: TextStyle(
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    SizedBox(height: h * 0.005),
                    Text(
                      'Minimum points required to reach each tier',
                      style: TextStyle(
                        fontSize: w * 0.028,
                        color: AppColors.textGrey,
                      ),
                    ),
                    SizedBox(height: h * 0.012),
                    ...['Bronze', 'Silver', 'Gold', 'Platinum'].map((tier) {
                      final tierColors = {
                        'Bronze': const Color(0xFFCD7F32),
                        'Silver': const Color(0xFF808080),
                        'Gold': const Color(0xFFDAA520),
                        'Platinum': const Color(0xFF6B7B8D),
                      };
                      return Container(
                        margin: EdgeInsets.only(bottom: h * 0.015),
                        padding: EdgeInsets.all(w * 0.04),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg(context),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.divider(context)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: w * 0.03,
                              height: w * 0.08,
                              decoration: BoxDecoration(
                                color: tierColors[tier],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(width: w * 0.03),
                            Expanded(
                              child: Text(
                                tier,
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                            ),
                            Text(
                              'Min: ',
                              style: TextStyle(
                                fontSize: w * 0.03,
                                color: AppColors.textGrey,
                              ),
                            ),
                            SizedBox(
                              width: w * 0.2,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: TextEditingController(
                                  text: provider.tiers[tier].toString(),
                                ),
                                onChanged: (v) => provider.updateTierThreshold(
                                  tier,
                                  int.tryParse(v) ?? 0,
                                ),
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                            Text(
                              ' pts',
                              style: TextStyle(
                                fontSize: w * 0.03,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    SizedBox(height: h * 0.03),

                    // Preview Card
                    Container(
                      padding: EdgeInsets.all(w * 0.04),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.preview,
                                color: AppColors.textSecondary(context),
                                size: w * 0.045,
                              ),
                              SizedBox(width: w * 0.02),
                              Text(
                                'Live Preview',
                                style: TextStyle(
                                  fontSize: w * 0.035,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.01),
                          Text(
                            '• Rs. 1,000 spent = ${(1000 / provider.pointsRate).floor()} pts',
                            style: TextStyle(
                              fontSize: w * 0.032,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                          Text(
                            '• Rs. 10,000 spent = ${(10000 / provider.pointsRate).floor()} pts',
                            style: TextStyle(
                              fontSize: w * 0.032,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                          Text(
                            '• Rs. 25,000 spent = ${(25000 / provider.pointsRate).floor()} pts',
                            style: TextStyle(
                              fontSize: w * 0.032,
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h * 0.05),
                  ],
                ),
              ),
            ),

            // ✅ FIXED BOTTOM SAVE BUTTON
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                w * 0.04,
                h * 0.015,
                w * 0.04,
                h * 0.02,
              ),
              decoration: BoxDecoration(
                color: AppColors.cardBg(context),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: CustomButton(
                  text: context.tr('Save Loyalty Settings'),
                  width: double.infinity,
                  isLoading: provider.isSaving,
                  onTap: () async {
                    final ok = await provider.saveSettings();
                    if (ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Loyalty settings saved successfully!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
