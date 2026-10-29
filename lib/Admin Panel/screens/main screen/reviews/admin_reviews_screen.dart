import 'package:ever_salon/Admin%20Panel/providers/reviews/admin_reviews_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';
import '../../../../../widgets/custom_button.dart';

class AdminReviewsScreen extends StatelessWidget {
  const AdminReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminReviewsProvider()..fetchAllReviews(),
      child: const _AdminReviewsContent(),
    );
  }
}

class _AdminReviewsContent extends StatelessWidget {
  const _AdminReviewsContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminReviewsProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // --- STANDARD BACK/HEADER ---
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
                    context.tr('Manage Reviews'),
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // --- RATINGS ANALYTICS SUMMARY CARD ---
                        SliverToBoxAdapter(
                          child: _buildBreakdownSummaryCard(
                            context,
                            provider,
                            w,
                            h,
                          ),
                        ),

                        // --- INTERACTIVE HORIZONTAL FILTERS ---
                        SliverToBoxAdapter(
                          child: _buildFilterSection(context, provider, w, h),
                        ),

                        // --- PAGINATED FEEDBACK TIMELINE LIST ---
                        SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.04,
                            vertical: h * 0.01,
                          ),
                          sliver: provider.filteredReviews.isEmpty
                              ? SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Center(
                                    child: Text(
                                      context.tr(
                                        'No reviews match your selected filter.',
                                      ),
                                      style: TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: w * 0.035,
                                      ),
                                    ),
                                  ),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final review =
                                          provider.filteredReviews[index];
                                      return _buildAdminReviewCard(
                                        context,
                                        provider,
                                        review,
                                        w,
                                        h,
                                      );
                                    },
                                    childCount: provider.filteredReviews.length,
                                  ),
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

  Widget _buildBreakdownSummaryCard(
    BuildContext context,
    AdminReviewsProvider provider,
    double w,
    double h,
  ) {
    return Container(
      margin: EdgeInsets.all(w * 0.04),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.045),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Numeric Big Rating
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${provider.averageRating}',
                style: TextStyle(
                  fontSize: w * 0.12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                  height: 1.0,
                ),
              ),
              SizedBox(height: h * 0.005),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < provider.averageRating.floor()
                        ? Icons.star
                        : Icons.star_half,
                    color: Colors.amber,
                    size: w * 0.04,
                  );
                }),
              ),
              SizedBox(height: h * 0.01),
              Text(
                '${provider.totalReviewsCount} ${context.tr('Reviews')}',
                style: TextStyle(color: AppColors.textGrey, fontSize: w * 0.03),
              ),
            ],
          ),
          SizedBox(width: w * 0.06),

          // Right: Dynamic Star Bars
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final count = provider.ratingBreakdown[star] ?? 0;
                final pct = provider.totalReviewsCount == 0
                    ? 0.0
                    : count / provider.totalReviewsCount;
                return Padding(
                  padding: EdgeInsets.only(bottom: h * 0.004),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style: TextStyle(
                          fontSize: w * 0.028,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: w * 0.01),
                      Icon(Icons.star, color: Colors.amber, size: w * 0.03),
                      SizedBox(width: w * 0.02),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: pct,
                            backgroundColor: AppColors.inputBg(context),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primaryPink,
                            ),
                            minHeight: 5,
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.02),
                      SizedBox(
                        width: w * 0.06,
                        child: Text(
                          '$count',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: w * 0.028,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    AdminReviewsProvider provider,
    double w,
    double h,
  ) {
    return Container(
      height: h * 0.05,
      margin: EdgeInsets.only(bottom: h * 0.01),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 6, // All, 5*, 4*, 3*, 2*, 1*
        itemBuilder: (context, index) {
          final isSelected = provider.selectedFilterStars == index;
          final title = index == 0 ? context.tr('All Ratings') : '$index ★';
          return GestureDetector(
            onTap: () => provider.setRatingFilter(index),
            child: Container(
              margin: EdgeInsets.only(
                left: index == 0 ? w * 0.04 : w * 0.02,
                right: index == 5 ? w * 0.04 : 0,
              ),
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryPink
                    : AppColors.cardBg(context),
                borderRadius: BorderRadius.circular(w * 0.06),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryPink
                      : AppColors.divider(context),
                ),
              ),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : AppColors.textPrimary(context),
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.032,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdminReviewCard(
    BuildContext context,
    AdminReviewsProvider provider,
    Map<String, dynamic> review,
    double w,
    double h,
  ) {
    final hasReply = (review['adminReply'] as String).isNotEmpty;
    final isHidden = review['isHidden'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: h * 0.025),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: isHidden
            ? AppColors.inputBg(context).withValues(alpha: 0.5)
            : AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.045),
        border: Border.all(
          color: isHidden
              ? AppColors.error.withValues(alpha: 0.3)
              : AppColors.divider(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              CircleAvatar(
                radius: w * 0.05,
                backgroundColor: AppColors.inputBg(context),
                child: Icon(
                  Icons.person,
                  color: AppColors.textGrey,
                  size: w * 0.05,
                ),
              ),
              SizedBox(width: w * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review['customerName'],
                          style: TextStyle(
                            fontSize: w * 0.035,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        if (isHidden) ...[
                          SizedBox(width: w * 0.02),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              context.tr('HIDDEN'),
                              style: const TextStyle(
                                color: AppColors.error,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: h * 0.002),
                    Text(
                      'Used: ${review['serviceUsed']}',
                      style: TextStyle(
                        fontSize: w * 0.028,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: List.generate(5, (starIdx) {
                      return Icon(
                        starIdx < (review['rating'] as double).toInt()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: w * 0.035,
                      );
                    }),
                  ),
                  SizedBox(height: h * 0.004),
                  Text(
                    review['date'],
                    style: TextStyle(
                      fontSize: w * 0.025,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: h * 0.015),

          // User Comment
          Text(
            review['comment'],
            style: TextStyle(
              fontSize: w * 0.035,
              color: AppColors.textPrimary(context),
              height: 1.4,
            ),
          ),
          SizedBox(height: h * 0.015),

          // Administrative Response Box
          if (hasReply)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(w * 0.03),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(w * 0.03),
                border: Border.all(
                  color: AppColors.primaryPink.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.reply,
                        color: AppColors.primaryPink,
                        size: 14,
                      ),
                      SizedBox(width: w * 0.015),
                      Text(
                        context.tr('Your Response'),
                        style: const TextStyle(
                          color: AppColors.primaryPink,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.005),
                  Text(
                    review['adminReply'],
                    style: TextStyle(
                      fontSize: w * 0.032,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: h * 0.015),
          const Divider(),
          SizedBox(height: h * 0.005),

          // Action Toolbar Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildTextAction(
                context,
                icon: Icons.reply_outlined,
                label: hasReply ? 'Edit Reply' : 'Reply',
                color: AppColors.primaryPink,
                onTap: () => _openReplySheet(
                  context,
                  provider,
                  review['id'],
                  review['adminReply'],
                  w,
                  h,
                ),
              ),
              SizedBox(width: w * 0.05),
              _buildTextAction(
                context,
                icon: isHidden ? Icons.visibility : Icons.visibility_off,
                label: isHidden ? 'Show Review' : 'Hide Review',
                color: Colors.amber.shade800,
                onTap: () => provider.toggleReviewVisibility(review['id']),
              ),
              SizedBox(width: w * 0.05),
              _buildTextAction(
                context,
                icon: Icons.delete_sweep_outlined,
                label: 'Delete',
                color: AppColors.error,
                onTap: () {
                  _showDeleteConfirm(context, () {
                    provider.deleteReview(review['id']);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            context.tr(label),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('Delete Review?')),
        content: Text(
          context.tr(
            'This action is irreversible and permanently removes the client feedback.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.tr('Cancel'),
              style: const TextStyle(color: AppColors.textGrey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: Text(context.tr('Delete')),
          ),
        ],
      ),
    );
  }

  void _openReplySheet(
    BuildContext context,
    AdminReviewsProvider provider,
    String reviewId,
    String existingReply,
    double w,
    double h,
  ) {
    final replyController = TextEditingController(text: existingReply);
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.sheetBg(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.05)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: w * 0.04,
                right: w * 0.04,
                top: w * 0.05,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('Reply to Review'),
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.02),
                  TextField(
                    controller: replyController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: context.tr(
                        'Enter professional management response...',
                      ),
                      fillColor: AppColors.inputBg(context),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  CustomButton(
                    text: context.tr('Submit Response'),
                    isLoading: isSaving,
                    onTap: () async {
                      if (replyController.text.trim().isEmpty) return;
                      setModalState(() => isSaving = true);
                      await provider.replyToReview(
                        reviewId,
                        replyController.text.trim(),
                      );
                      setModalState(() => isSaving = false);
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.tr('Review response recorded!'),
                            ),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: h * 0.04),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
