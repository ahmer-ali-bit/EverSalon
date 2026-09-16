import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_translations.dart';
import '../../../provider/profile/membership_details_provider.dart';

class MembershipDetailsScreen extends StatelessWidget {
  const MembershipDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MembershipDetailsProvider()..fetchMembershipDetails(),
      child: const _MembershipDetailsView(),
    );
  }
}

class _MembershipDetailsView extends StatelessWidget {
  const _MembershipDetailsView();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<MembershipDetailsProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ─── HEADER: back + title sath (NO center) ───
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
                  Text(
                    context.tr('membership_details'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
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
                          SizedBox(height: h * 0.015),

                          // ─── GOLD MEMBER CARD ───
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(w * 0.05),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE6C875), Color(0xFFC0953E)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(w * 0.05),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFC0953E,
                                  ).withValues(alpha: 0.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Crown + Title + Stars
                                Row(
                                  children: [
                                    Icon(
                                      Icons.workspace_premium,
                                      color: Colors.white,
                                      size: w * 0.09,
                                    ),
                                    SizedBox(width: w * 0.025),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          provider.tierName,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w * 0.048,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                                        SizedBox(height: h * 0.004),
                                        Row(
                                          children: List.generate(
                                            provider.starCount,
                                            (i) => Icon(
                                              Icons.star_rounded,
                                              color: const Color(0xFFFFF3C4),
                                              size: w * 0.04,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(height: h * 0.035),

                                // Valid Till + Status
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          context.tr('valid_till'),
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.85,
                                            ),
                                            fontSize: w * 0.03,
                                          ),
                                        ),
                                        SizedBox(height: h * 0.004),
                                        Text(
                                          provider.validTill,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w * 0.038,
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
                                          context.tr('status'),
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.85,
                                            ),
                                            fontSize: w * 0.03,
                                          ),
                                        ),
                                        SizedBox(height: h * 0.004),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: w * 0.03,
                                            vertical: h * 0.004,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.25,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              w * 0.03,
                                            ),
                                          ),
                                          child: Text(
                                            provider.status,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: w * 0.032,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: h * 0.035),

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

                          ...provider.benefits.map((b) {
                            return _benefitRow(
                              context: context,
                              w: w,
                              h: h,
                              icon: b['icon'] as IconData,
                              title: b['title'] as String,
                              subtitle: b['subtitle'] as String,
                            );
                          }),

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

  Widget _benefitRow({
    required BuildContext context,
    required double w,
    required double h,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: h * 0.022),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: w * 0.11,
            height: w * 0.11,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E7), // soft gold tint
              borderRadius: BorderRadius.circular(w * 0.03),
            ),
            child: Icon(icon, color: const Color(0xFFC0953E), size: w * 0.055),
          ),
          SizedBox(width: w * 0.035),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: w * 0.038,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: h * 0.004),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: w * 0.032,
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
