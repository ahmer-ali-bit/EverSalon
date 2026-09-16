import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_translations.dart';
import '../../../provider/profile/gift_cards_provider.dart';

class GiftCardsScreen extends StatelessWidget {
  const GiftCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GiftCardsProvider()..fetchGiftCards(),
      child: const _GiftCardsView(),
    );
  }
}

class _GiftCardsView extends StatelessWidget {
  const _GiftCardsView();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<GiftCardsProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // ─── STRICT HEADER: Back + Title sath ───
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
                    context.tr('my_gift_cards'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => provider.addNewCard(context),
                    child: Text(
                      context.tr('add_card'),
                      style: TextStyle(
                        fontSize: w * 0.035,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryPink,
                      ),
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
                  : provider.giftCards.isEmpty
                  ? Center(
                      child: Text(
                        context.tr('no_gift_cards'),
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: w * 0.04,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.02,
                      ),
                      itemCount: provider.giftCards.length,
                      separatorBuilder: (_, _) => SizedBox(height: h * 0.02),
                      itemBuilder: (context, index) {
                        final card = provider.giftCards[index];
                        return _buildGiftCard(
                          context: context,
                          w: w,
                          h: h,
                          gradient: card['gradient'],
                          balance: card['balance'],
                          cardNo: card['cardNo'],
                          validTill: card['validTill'],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGiftCard({
    required BuildContext context,
    required double w,
    required double h,
    required List<Color> gradient,
    required String balance,
    required String cardNo,
    required String validTill,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: AppColors.divider(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left side Gradient Card visual
          SizedBox(width: w * 0.03),
          Container(
            width: w * 0.35,
            height: h * 0.16,
            padding: EdgeInsets.all(w * 0.03),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(w * 0.04),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EVER SALON',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.032,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                Text(
                  context.tr('gift_card'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: w * 0.024,
                  ),
                ),
                const Spacer(),
                // Abstract shape to match design (two overlapping circles)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: w * 0.12,
                        height: w * 0.08,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      Positioned(
                        left: w * 0.04,
                        child: Container(
                          width: w * 0.08,
                          height: w * 0.08,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Right side Details
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(w * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr('balance'),
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: w * 0.03,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: h * 0.002),
                  Text(
                    balance,
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: h * 0.015),
                  Text(
                    context.tr('card_no'),
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: w * 0.03,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: h * 0.002),
                  Text(
                    cardNo,
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: w * 0.035,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: h * 0.015),
                  Text(
                    context.tr('valid_till'),
                    style: TextStyle(
                      color: AppColors.textSecondary(context),
                      fontSize: w * 0.03,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: h * 0.002),
                  Text(
                    validTill,
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontSize: w * 0.035,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
