import 'package:ever_salon/Customer%20Panel/provider/customer%20home%20providers/offers_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OffersProvider()..fetchOffers(),
      child: const _OffersView(),
    );
  }
}

class _OffersView extends StatelessWidget {
  const _OffersView();

  void _copyCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(context.tr('code_copied').replaceAll('{code}', code)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OffersProvider>(context);
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
    final double padding = w * 0.04;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── HEADER ──
            Padding(
              padding: EdgeInsets.fromLTRB(padding, padding, padding, h * 0.01),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(w * 0.02),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.textPrimary(context),
                        size: w * 0.045,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  Text(
                    context.tr('offers'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),

            // ── TABS ──
            SizedBox(
              height: h * 0.05,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: padding),
                itemCount: provider.offerTabs.length,
                itemBuilder: (context, index) {
                  final bool selected = provider.selectedTabIndex == index;
                  return GestureDetector(
                    onTap: () => provider.changeTab(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(right: w * 0.025),
                      padding: EdgeInsets.symmetric(horizontal: w * 0.045),
                      decoration: BoxDecoration(
                        gradient: selected ? AppColors.primaryGradient : null,
                        color: selected ? null : AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: selected
                              ? Colors.transparent
                              : AppColors.divider(context),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        provider.offerTabs[index],
                        style: TextStyle(
                          fontSize: w * 0.033,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: h * 0.02),

            // ── OFFERS LIST ──
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : provider.filteredOffers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_offer_outlined,
                            size: w * 0.18,
                            color: AppColors.divider(context),
                          ),
                          SizedBox(height: h * 0.015),
                          Text(
                            context.tr('no_offers'),
                            style: TextStyle(
                              color: AppColors.textSecondary(context),
                              fontSize: w * 0.04,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      itemCount: provider.filteredOffers.length,
                      itemBuilder: (context, index) {
                        return _buildOfferCard(
                          context: context,
                          offer: provider.filteredOffers[index],
                          w: w,
                          h: h,
                          onCopy: () => _copyCode(
                            context,
                            provider.filteredOffers[index]['code'],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── OFFER CARD (matches UI image) ──
  Widget _buildOfferCard({
    required BuildContext context,
    required Map<String, dynamic> offer,
    required double w,
    required double h,
    required VoidCallback onCopy,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: h * 0.018),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left colored accent strip
              Container(
                width: 5,
                decoration: BoxDecoration(gradient: AppColors.primaryGradient),
              ),

              // Main content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(w * 0.035),
                  child: Row(
                    children: [
                      // Icon circle
                      Container(
                        height: w * 0.14,
                        width: w * 0.14,
                        decoration: BoxDecoration(
                          color: offer['iconBg'],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          offer['icon'],
                          color: offer['iconColor'],
                          size: w * 0.07,
                        ),
                      ),
                      SizedBox(width: w * 0.035),

                      // Text content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Title + Subtitle
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${offer['title']} ",
                                    style: TextStyle(
                                      fontSize: w * 0.042,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary(context),
                                    ),
                                  ),
                                  TextSpan(
                                    text: offer['subtitle'],
                                    style: TextStyle(
                                      fontSize: w * 0.032,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: h * 0.004),
                            Text(
                              offer['validity'],
                              style: TextStyle(
                                fontSize: w * 0.028,
                                color: AppColors.textSecondary(context),
                              ),
                            ),
                            SizedBox(height: h * 0.012),

                            // Code row
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.03,
                                      vertical: h * 0.008,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryPink.withValues(
                                        alpha: 0.06,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.primaryPink.withValues(
                                          alpha: 0.25,
                                        ),
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Text(
                                      "${context.tr('use_code')} ${offer['code']}",
                                      style: TextStyle(
                                        fontSize: w * 0.03,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryPink,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: w * 0.025),

                                // Copy button
                                GestureDetector(
                                  onTap: onCopy,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.04,
                                      vertical: h * 0.008,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primaryPink
                                              .withValues(alpha: 0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      context.tr('copy'),
                                      style: TextStyle(
                                        fontSize: w * 0.03,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
