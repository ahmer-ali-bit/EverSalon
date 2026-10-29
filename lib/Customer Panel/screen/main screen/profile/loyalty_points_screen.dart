import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/loyalty_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_translations.dart';
import '../../../provider/profile/loyalty_points_provider.dart';

class LoyaltyPointsScreen extends StatelessWidget {
  const LoyaltyPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoyaltyPointsProvider()..fetchLoyaltyData(),
      child: const _LoyaltyPointsView(),
    );
  }
}

class _LoyaltyPointsView extends StatelessWidget {
  const _LoyaltyPointsView();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<LoyaltyPointsProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ─── STRICT HEADER ───
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
                  SizedBox(width: w * 0.03),
                  Center(
                    child: Text(
                      context.tr('loyalty_points'),
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.13), // Balance spacing
                ],
              ),
            ),

            // ─── BODY ───
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: h * 0.02),

                          // ─── Points Gradient Card ───
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(w * 0.05),
                            decoration: BoxDecoration(
                              gradient:
                                  AppColors.primaryGradient, // Pink to Purple
                              borderRadius: BorderRadius.circular(w * 0.05),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryPink.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context.tr('available_points'),
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: h * 0.005),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              _formatPoints(
                                                provider.availablePoints,
                                              ),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: w * 0.08,
                                                fontWeight: FontWeight.bold,
                                                height: 1.1,
                                              ),
                                            ),
                                            SizedBox(width: w * 0.02),
                                            Text(
                                              context.tr('pts'),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: w * 0.04,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: h * 0.005),
                                        Text(
                                          context.tr('earning_smiles'),
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                            fontSize: w * 0.03,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Golden Star Badge
                                    Container(
                                      width: w * 0.12,
                                      height: w * 0.12,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.star_rounded,
                                        color: const Color(0xFFFFD700), // Gold
                                        size: w * 0.08,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: h * 0.03),

                                // Progress Bar Area
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context
                                          .tr('you_are_pts_away')
                                          .replaceAll(
                                            '{pts}',
                                            '${provider.pointsAway}',
                                          )
                                          .replaceAll(
                                            '{tier}',
                                            provider.tierName,
                                          ),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: w * 0.03,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${_formatPoints(provider.availablePoints)} / ${_formatPoints(provider.targetPoints)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: w * 0.03,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: h * 0.01),
                                // Progress Track
                                Stack(
                                  children: [
                                    Container(
                                      height: h * 0.01,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          w * 0.02,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: h * 0.01,
                                      width:
                                          w *
                                          0.92 * // Card width approx
                                          provider.progressValue,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          w * 0.02,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: h * 0.04),

                          // ─── How You Earn Points ───
                          Text(
                            context.tr('how_earn_points'),
                            style: TextStyle(
                              fontSize: w * 0.045,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.02),

                          // Ways to earn List
                          ...provider.earnPointsMethods.map((method) {
                            return _buildEarnPointRow(
                              context: context,
                              w: w,
                              h: h,
                              icon: method['icon'] as IconData,
                              title: method['title'] as String,
                              pointsText: method['points'] as String,
                            );
                          }),

                          SizedBox(height: h * 0.04),
                        ],
                      ),
                    ),
            ),

            // ─── Fixed Bottom Button (Outlined) ───
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                w * 0.04,
                h * 0.02,
                w * 0.04,
                h * 0.03,
              ),
              decoration: BoxDecoration(
                color: AppColors.cardBg(context),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoyaltyHistoryScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: h * 0.065,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w * 0.08),
                    border: Border.all(
                      color: AppColors.primaryPink,
                      width: 1.5,
                    ),
                    color: AppColors.cardBg(context),
                  ),
                  child: Text(
                    context.tr('view_points_history'),
                    style: TextStyle(
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryPink,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Comma formatting for points (e.g., 2450 -> 2,450)
  String _formatPoints(int points) {
    final str = points.toString();
    if (str.length <= 3) return str;
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }

  // Row for "How you earn points" list
  Widget _buildEarnPointRow({
    required BuildContext context,
    required double w,
    required double h,
    required IconData icon,
    required String title,
    required String pointsText,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.02),
      child: Row(
        children: [
          Container(
            width: w * 0.1,
            height: w * 0.1,
            decoration: BoxDecoration(
              color: AppColors.inputBg(context),
              borderRadius: BorderRadius.circular(w * 0.025),
            ),
            child: Icon(icon, color: AppColors.primaryPurple, size: w * 0.05),
          ),
          SizedBox(width: w * 0.04),
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
          Text(
            pointsText,
            style: TextStyle(
              fontSize: w * 0.038,
              fontWeight: FontWeight.w600,
              color: AppColors.success, // Green color for points
            ),
          ),
        ],
      ),
    );
  }
}
