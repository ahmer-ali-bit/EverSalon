import 'dart:io';
import 'package:ever_salon/Admin%20Panel/providers/customers/customer_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';
import '../../../../../widgets/custom_button.dart';

class AdminCustomerDetailScreen extends StatelessWidget {
  final String customerId;
  const AdminCustomerDetailScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          AdminCustomerDetailProvider()..fetchCustomerDetails(customerId),
      child: const _AdminCustomerDetailContent(),
    );
  }
}

class _AdminCustomerDetailContent extends StatelessWidget {
  const _AdminCustomerDetailContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminCustomerDetailProvider>();

    if (provider.isLoading) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBg(context),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primaryPink),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.015,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                        context.tr('Customer Profile'),
                        style: TextStyle(
                          fontSize: w * 0.05,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                  _buildBlockButton(context, provider, w),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildProfileHeaderCard(context, provider, w, h),
                    _buildStatsRow(context, provider, w, h),
                    // ✅ NEW: AUTO LOYALTY & MEMBERSHIP CARD
                    _buildLoyaltyCard(context, provider, w, h),
                    _buildSegmentationControl(context, provider, w),
                    _buildNotesCard(context, provider, w),
                    _buildFavoriteServices(context, provider, w),
                    _buildBookingHistoryList(context, provider, w, h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ LOYALTY & MEMBERSHIP AUTO CARD
  Widget _buildLoyaltyCard(
    BuildContext context,
    AdminCustomerDetailProvider provider,
    double w,
    double h,
  ) {
    final tierColors = {
      'Bronze': const Color(0xFFCD7F32),
      'Silver': const Color(0xFFC0C0C0),
      'Gold': const Color(0xFFFFD700),
      'Platinum': const Color(0xFFE5E4E2),
    };
    final tierColor = tierColors[provider.membershipTier] ?? AppColors.textGrey;
    final tierGradient = {
      'Bronze': const LinearGradient(
        colors: [Color(0xFFCD7F32), Color(0xFF8B4513)],
      ),
      'Silver': const LinearGradient(
        colors: [Color(0xFFC0C0C0), Color(0xFF808080)],
      ),
      'Gold': const LinearGradient(
        colors: [Color(0xFFFFD700), Color(0xFFDAA520)],
      ),
      'Platinum': const LinearGradient(
        colors: [Color(0xFFE5E4E2), Color(0xFFB0C4DE)],
      ),
    };

    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.015),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        gradient: tierGradient[provider.membershipTier],
        borderRadius: BorderRadius.circular(w * 0.045),
        boxShadow: [
          BoxShadow(
            color: tierColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.diamond, color: Colors.white, size: w * 0.06),
                  SizedBox(width: w * 0.02),
                  Text(
                    '${provider.membershipTier} Member',
                    style: TextStyle(
                      fontSize: w * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.03,
                  vertical: w * 0.01,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(w * 0.03),
                ),
                child: Text(
                  '${provider.loyaltyPoints} pts',
                  style: TextStyle(
                    fontSize: w * 0.035,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.015),

          // Progress to next tier
          if (provider.membershipTier != 'Platinum') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress to ${provider.nextTierName}',
                  style: TextStyle(fontSize: w * 0.028, color: Colors.white70),
                ),
                Text(
                  '${provider.nextTierPointsNeeded} pts needed',
                  style: TextStyle(
                    fontSize: w * 0.028,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.008),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: provider.nextTierProgress,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6,
              ),
            ),
            SizedBox(height: h * 0.015),
          ],

          // Tier Benefits
          Text(
            'Tier Benefits:',
            style: TextStyle(
              fontSize: w * 0.03,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: h * 0.005),
          _buildBenefitRow('🎁', 'Birthday discount 20% OFF', w),
          if (provider.membershipTier == 'Silver' ||
              provider.membershipTier == 'Gold' ||
              provider.membershipTier == 'Platinum')
            _buildBenefitRow('⭐', 'Priority booking slots', w),
          if (provider.membershipTier == 'Gold' ||
              provider.membershipTier == 'Platinum')
            _buildBenefitRow('💎', 'Free hair spa every 5th visit', w),
          if (provider.membershipTier == 'Platinum')
            _buildBenefitRow('👑', 'Dedicated personal stylist', w),

          SizedBox(height: h * 0.015),
          const Divider(color: Colors.white24),
          SizedBox(height: h * 0.01),

          // Admin Action: Adjust Points
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildPointsActionButton(context, provider, '+500', 500, w),
              SizedBox(width: w * 0.02),
              _buildPointsActionButton(context, provider, '-200', -200, w),
              SizedBox(width: w * 0.02),
              _buildPointsActionButton(context, provider, 'Custom', 0, w),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(String emoji, String text, double w) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2),
      child: Text(
        '$emoji  $text',
        style: TextStyle(fontSize: w * 0.028, color: Colors.white70),
      ),
    );
  }

  Widget _buildPointsActionButton(
    BuildContext context,
    AdminCustomerDetailProvider provider,
    String label,
    int points,
    double w,
  ) {
    return GestureDetector(
      onTap: () {
        if (points != 0) {
          provider.adjustPoints(points, 'Manual adjustment');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${points > 0 ? "+" : ""}$points points adjusted!'),
              backgroundColor: AppColors.success,
            ),
          );
        } else {
          _openCustomPointsSheet(context, provider, w);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.03,
          vertical: w * 0.012,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(w * 0.02),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: w * 0.028,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _openCustomPointsSheet(
    BuildContext context,
    AdminCustomerDetailProvider provider,
    double w,
  ) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.sheetBg(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.05)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: w * 0.04,
            right: w * 0.04,
            top: w * 0.05,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Adjust Points',
                style: TextStyle(
                  fontSize: w * 0.045,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter points (use - for deduction)',
                  fillColor: AppColors.inputBg(context),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              CustomButton(
                text: 'Apply',
                onTap: () {
                  final pts = int.tryParse(ctrl.text.trim()) ?? 0;
                  if (pts != 0) {
                    provider.adjustPoints(pts, 'Manual adjustment');
                    Navigator.pop(context);
                  }
                },
              ),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  // --- REST OF EXISTING WIDGETS (unchanged) ---

  Widget _buildBlockButton(
    BuildContext context,
    AdminCustomerDetailProvider provider,
    double w,
  ) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(provider.isBlocked ? 'Unblock?' : 'Block?'),
            content: Text(
              provider.isBlocked
                  ? 'Allow bookings again.'
                  : 'Restrict from booking.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: provider.isBlocked
                      ? AppColors.success
                      : AppColors.error,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  provider.toggleBlockStatus();
                  Navigator.pop(context);
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.03,
          vertical: w * 0.015,
        ),
        decoration: BoxDecoration(
          color: provider.isBlocked
              ? AppColors.success.withValues(alpha: 0.15)
              : AppColors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(w * 0.04),
          border: Border.all(
            color: provider.isBlocked
                ? AppColors.success.withValues(alpha: 0.3)
                : AppColors.error.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              provider.isBlocked ? Icons.lock_open : Icons.block_flipped,
              color: provider.isBlocked ? AppColors.success : AppColors.error,
              size: w * 0.04,
            ),
            SizedBox(width: w * 0.015),
            Text(
              context.tr(provider.isBlocked ? 'Unblock' : 'Block'),
              style: TextStyle(
                color: provider.isBlocked ? AppColors.success : AppColors.error,
                fontSize: w * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard(
    BuildContext context,
    AdminCustomerDetailProvider provider,
    double w,
    double h,
  ) {
    final avatar = provider.avatar;
    ImageProvider? imageProvider;
    if (avatar.isNotEmpty) {
      imageProvider = avatar.startsWith('assets/')
          ? AssetImage(avatar)
          : FileImage(File(avatar));
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.01),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.045),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: w * 0.09,
                backgroundColor: AppColors.inputBg(context),
                backgroundImage: imageProvider,
                onBackgroundImageError: imageProvider != null
                    ? (_, _) {}
                    : null,
                child: imageProvider == null
                    ? Icon(
                        Icons.person,
                        color: AppColors.textGrey,
                        size: w * 0.09,
                      )
                    : null,
              ),
              SizedBox(width: w * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: TextStyle(
                        fontSize: w * 0.048,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    SizedBox(height: h * 0.005),
                    Text(
                      provider.phone,
                      style: TextStyle(
                        fontSize: w * 0.032,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                    Text(
                      provider.email,
                      style: TextStyle(
                        fontSize: w * 0.032,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.02),
          const Divider(),
          SizedBox(height: h * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickAction(
                context,
                icon: Icons.phone_forwarded_outlined,
                label: 'Call',
                color: Colors.blue,
                onTap: () {},
                w: w,
              ),
              _buildQuickAction(
                context,
                icon: Icons.local_offer_outlined,
                label: 'Send Offer',
                color: AppColors.primaryPink,
                onTap: () {},
                w: w,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required double w,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(w * 0.03),
      child: Container(
        width: w * 0.4,
        padding: EdgeInsets.symmetric(vertical: w * 0.02),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(w * 0.03),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: w * 0.045),
            SizedBox(width: w * 0.02),
            Text(
              context.tr(label),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: w * 0.035,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    AdminCustomerDetailProvider provider,
    double w,
    double h,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatCard(
            context,
            'Bookings',
            '${provider.bookingHistory.length}',
            Icons.history,
            Colors.amber,
            w,
          ),
          _buildStatCard(
            context,
            'Spent (Rs.)',
            '₨ ${provider.totalSpending.toInt()}',
            Icons.account_balance_wallet_outlined,
            Colors.teal,
            w,
          ),
          _buildStatCard(
            context,
            'Loyalty',
            '${provider.loyaltyPoints} pts',
            Icons.star_outline_rounded,
            AppColors.primaryPink,
            w,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color accentColor,
    double w,
  ) {
    return Container(
      width: w * 0.285,
      padding: EdgeInsets.all(w * 0.03),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: w * 0.05),
          SizedBox(height: w * 0.02),
          Text(
            value,
            style: TextStyle(
              fontSize: w * 0.035,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: w * 0.005),
          Text(
            context.tr(title),
            style: TextStyle(
              fontSize: w * 0.025,
              color: AppColors.textSecondary(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentationControl(
    BuildContext context,
    AdminCustomerDetailProvider provider,
    double w,
  ) {
    final tags = ['Regular', 'VIP', 'Problematic'];
    final colors = [AppColors.textGrey, AppColors.primaryPink, AppColors.error];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.01),
      padding: EdgeInsets.all(w * 0.03),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('Segmentation Tag'),
            style: TextStyle(
              fontSize: w * 0.035,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: w * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(tags.length, (index) {
              final active = provider.tag == tags[index];
              return GestureDetector(
                onTap: () => provider.updateTag(tags[index]),
                child: Container(
                  width: w * 0.26,
                  padding: EdgeInsets.symmetric(vertical: w * 0.02),
                  decoration: BoxDecoration(
                    color: active
                        ? colors[index].withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(w * 0.03),
                    border: Border.all(
                      color: active
                          ? colors[index]
                          : AppColors.divider(context),
                      width: active ? 1.5 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      context.tr(tags[index]),
                      style: TextStyle(
                        color: active
                            ? colors[index]
                            : AppColors.textSecondary(context),
                        fontWeight: FontWeight.bold,
                        fontSize: w * 0.03,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(
    BuildContext context,
    AdminCustomerDetailProvider provider,
    double w,
  ) {
    final controller = TextEditingController(text: provider.notes);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.015),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.045),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('Internal Staff Notes'),
            style: TextStyle(
              fontSize: w * 0.038,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: w * 0.02),
          TextField(
            controller: controller,
            maxLines: 3,
            onChanged: (text) => provider.updateNotes(text),
            style: TextStyle(
              color: AppColors.textPrimary(context),
              fontSize: w * 0.035,
            ),
            decoration: InputDecoration(
              hintText: 'Add notes...',
              hintStyle: TextStyle(
                color: AppColors.textGrey,
                fontSize: w * 0.032,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(w * 0.03),
              ),
              fillColor: AppColors.inputBg(context),
              filled: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteServices(
    BuildContext context,
    AdminCustomerDetailProvider provider,
    double w,
  ) {
    if (provider.favoriteServices.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.01),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.045),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('Frequently Booked'),
            style: TextStyle(
              fontSize: w * 0.038,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: w * 0.02),
          Wrap(
            spacing: w * 0.02,
            runSpacing: w * 0.015,
            children: provider.favoriteServices
                .map(
                  (s) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.03,
                      vertical: w * 0.015,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPink.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(w * 0.03),
                      border: Border.all(
                        color: AppColors.primaryPink.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      s,
                      style: TextStyle(
                        fontSize: w * 0.03,
                        color: AppColors.primaryPink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingHistoryList(
    BuildContext context,
    AdminCustomerDetailProvider provider,
    double w,
    double h,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.015),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.045),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('Booking History'),
            style: TextStyle(
              fontSize: w * 0.038,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: h * 0.015),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.bookingHistory.length,
            separatorBuilder: (_, _) =>
                Divider(color: AppColors.divider(context)),
            itemBuilder: (context, index) {
              final item = provider.bookingHistory[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: h * 0.005),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(w * 0.02),
                      decoration: BoxDecoration(
                        color: AppColors.inputBg(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.event_available,
                        color: AppColors.primaryPink,
                        size: w * 0.05,
                      ),
                    ),
                    SizedBox(width: w * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['service'] ?? '',
                            style: TextStyle(
                              color: AppColors.textPrimary(context),
                              fontWeight: FontWeight.bold,
                              fontSize: w * 0.035,
                            ),
                          ),
                          Text(
                            '${item['dateTime']} | ${item['staff']}',
                            style: TextStyle(
                              color: AppColors.textSecondary(context),
                              fontSize: w * 0.028,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₨ ${(item['amount'] as double).toInt()}',
                      style: TextStyle(
                        color: AppColors.textPrimary(context),
                        fontWeight: FontWeight.bold,
                        fontSize: w * 0.035,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
