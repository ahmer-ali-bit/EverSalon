import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_translations.dart';
import '../../../provider/profile/loyalty_history_provider.dart';

class LoyaltyHistoryScreen extends StatelessWidget {
  const LoyaltyHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoyaltyHistoryProvider()..fetchHistory(),
      child: const _LoyaltyHistoryView(),
    );
  }
}

class _LoyaltyHistoryView extends StatelessWidget {
  const _LoyaltyHistoryView();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<LoyaltyHistoryProvider>();

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
                      context.tr('points_history'),
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
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filter Dropdown
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.04,
                            vertical: h * 0.01,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                            decoration: BoxDecoration(
                              color: AppColors.inputBg(context),
                              borderRadius: BorderRadius.circular(w * 0.02),
                              border: Border.all(
                                color: AppColors.divider(context),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: provider.selectedFilter,
                                isExpanded: true,
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.textPrimary(context),
                                  size: w * 0.06,
                                ),
                                style: TextStyle(
                                  fontSize: w * 0.038,
                                  color: AppColors.textPrimary(context),
                                  fontWeight: FontWeight.w500,
                                ),
                                items: provider.filterOptions.map((
                                  String value,
                                ) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    provider.setFilter(newValue);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),

                        // History List
                        Expanded(
                          child: provider.historyData.isEmpty
                              ? Center(
                                  child: Text(
                                    context.tr('no_history'),
                                    style: TextStyle(
                                      color: AppColors.textSecondary(context),
                                      fontSize: w * 0.04,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.only(
                                    left: w * 0.04,
                                    right: w * 0.04,
                                    bottom: h * 0.04,
                                  ),
                                  itemCount: provider.historyData.length,
                                  itemBuilder: (context, sectionIndex) {
                                    final section =
                                        provider.historyData[sectionIndex];
                                    final month = section['month'] as String;
                                    final List transactions =
                                        section['transactions'];

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: h * 0.02),
                                        // Month Header
                                        Text(
                                          month,
                                          style: TextStyle(
                                            fontSize: w * 0.04,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary(context),
                                          ),
                                        ),
                                        SizedBox(height: h * 0.015),
                                        // Transactions for this month
                                        ...transactions.map((tx) {
                                          return _buildTransactionCard(
                                            context: context,
                                            w: w,
                                            h: h,
                                            title: tx['title'],
                                            subtitle: tx['subtitle'],
                                            points: tx['points'],
                                            date: tx['date'],
                                            isPositive: tx['isPositive'],
                                            icon: tx['icon'],
                                          );
                                        }),
                                      ],
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Individual Transaction Row
  Widget _buildTransactionCard({
    required BuildContext context,
    required double w,
    required double h,
    required String title,
    required String subtitle,
    required String points,
    required String date,
    required bool isPositive,
    required IconData icon,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: h * 0.012),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Circle
              Container(
                width: w * 0.12,
                height: w * 0.12,
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isPositive ? AppColors.success : AppColors.error,
                  size: w * 0.055,
                ),
              ),
              SizedBox(width: w * 0.035),

              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: w * 0.038,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    SizedBox(height: h * 0.005),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: w * 0.032,
                        color: AppColors.textSecondary(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Points & Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$points ${context.tr('pts')}',
                    style: TextStyle(
                      fontSize: w * 0.038,
                      fontWeight: FontWeight.bold,
                      color: isPositive ? AppColors.success : AppColors.error,
                    ),
                  ),
                  SizedBox(height: h * 0.005),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: AppColors.divider(context).withValues(alpha: 0.5),
        ),
      ],
    );
  }
}
