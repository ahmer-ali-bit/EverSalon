import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/membership_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_translations.dart';
import '../../../provider/profile/my_membership_provider.dart';
import '../../../../widgets/custom_button.dart';

class MyMembershipScreen extends StatelessWidget {
  const MyMembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyMembershipProvider()..fetchMembership(),
      child: const _MyMembershipView(),
    );
  }
}

class _MyMembershipView extends StatelessWidget {
  const _MyMembershipView();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<MyMembershipProvider>();

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
                      context.tr('my_membership'),
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.13), // Balancing spacer
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

                          // ─── GOLD MEMBERSHIP CARD ───
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(w * 0.05),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFE6C875), // Light Gold
                                  Color(0xFFC0953E), // Dark Gold
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(w * 0.05),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFC0953E,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Crown Icon
                                    Icon(
                                      Icons.workspace_premium_outlined,
                                      color: Colors.white,
                                      size: w * 0.1,
                                    ),
                                    SizedBox(width: w * 0.03),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          provider.tierName,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w * 0.05,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                        SizedBox(height: h * 0.005),
                                        Text(
                                          context.tr(
                                            'enjoy_exclusive_benefits',
                                          ),
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                            fontSize: w * 0.032,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: h * 0.05),
                                // Footer of card
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context.tr('member_since'),
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            fontSize: w * 0.03,
                                          ),
                                        ),
                                        SizedBox(height: h * 0.005),
                                        Text(
                                          provider.memberSince,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          context.tr('member_id'),
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            fontSize: w * 0.03,
                                          ),
                                        ),
                                        SizedBox(height: h * 0.005),
                                        Text(
                                          provider.memberId,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w * 0.035,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: h * 0.04),

                          // ─── MEMBERSHIP BENEFITS ───
                          Text(
                            context.tr('membership_benefits'),
                            style: TextStyle(
                              fontSize: w * 0.045,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.02),

                          // Benefits Checkmark List
                          ...provider.benefits.map((benefit) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: h * 0.015),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(w * 0.008),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryPink,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: w * 0.03,
                                    ),
                                  ),
                                  SizedBox(width: w * 0.03),
                                  Expanded(
                                    child: Text(
                                      benefit,
                                      style: TextStyle(
                                        fontSize: w * 0.038,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          SizedBox(height: h * 0.04),
                        ],
                      ),
                    ),
            ),

            // ─── FIXED BOTTOM BUTTON ───
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                w * 0.04,
                h * 0.02,
                w * 0.04,
                h * 0.03, // Extra padding for safe area bottom
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
              child: CustomButton(
                text: context.tr('view_membership_details'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MembershipDetailsScreen(),
                    ),
                  );
                },
                width: double.infinity,
                height: h * 0.065,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
