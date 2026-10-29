import 'package:ever_salon/Admin%20Panel/providers/payments/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class AdminPaymentsScreen extends StatelessWidget {
  const AdminPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminPaymentsProvider()..fetchTransactions(),
      child: const _AdminPaymentsContent(),
    );
  }
}

class _AdminPaymentsContent extends StatelessWidget {
  const _AdminPaymentsContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminPaymentsProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
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
                    context.tr('Payments & Ledger'),
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
                  : Column(
                      children: [
                        // --- TOTAL REVENUE & BALANCE COUNTER BLOCKS ---
                        _buildTotalOverviewSection(context, provider, w, h),

                        // --- LEDGER FILTER TABS ---
                        _buildFilterTabs(context, provider, w, h),

                        // --- LEDGER LIST VIEW ---
                        Expanded(
                          child: provider.filteredTransactions.isEmpty
                              ? Center(
                                  child: Text(
                                    context.tr(
                                      'No transaction ledger records found.',
                                    ),
                                    style: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: w * 0.035,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w * 0.04,
                                    vertical: h * 0.01,
                                  ),
                                  itemCount:
                                      provider.filteredTransactions.length,
                                  separatorBuilder: (_, _) =>
                                      SizedBox(height: h * 0.015),
                                  itemBuilder: (context, index) {
                                    final txn =
                                        provider.filteredTransactions[index];
                                    return _buildTransactionCard(
                                      context,
                                      provider,
                                      txn,
                                      w,
                                      h,
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

  Widget _buildTotalOverviewSection(
    BuildContext context,
    AdminPaymentsProvider provider,
    double w,
    double h,
  ) {
    return Container(
      margin: EdgeInsets.all(w * 0.04),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(w * 0.05),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('TOTAL REVENUE'),
            style: TextStyle(
              color: Colors.white70,
              fontSize: w * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: h * 0.005),
          Text(
            '₨ ${provider.totalRevenue.toInt()}',
            style: TextStyle(
              color: Colors.white,
              fontSize: w * 0.075,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: h * 0.015),
          Row(
            children: [
              _buildOverviewMiniItem(
                'Pending',
                '₨ ${provider.outstandingInvoices.toInt()}',
                Icons.receipt_long_sharp,
                w,
              ),
              Container(
                width: 1,
                height: h * 0.035,
                color: Colors.white24,
                margin: EdgeInsets.symmetric(horizontal: w * 0.015),
              ),
              _buildOverviewMiniItem(
                'Refunds',
                '₨ ${provider.pendingRefundRequests.toInt()}',
                Icons.rotate_left_rounded,
                w,
              ),
              Container(
                width: 1,
                height: h * 0.035,
                color: Colors.white24,
                margin: EdgeInsets.symmetric(horizontal: w * 0.015),
              ),
              _buildOverviewMiniItem(
                'Forfeited',
                '₨ ${provider.forfeitedAmount.toInt()}',
                Icons.money_off_rounded,
                w,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewMiniItem(
    String title,
    String value,
    IconData icon,
    double w,
  ) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: w * 0.04),
          SizedBox(width: w * 0.015),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.white70, fontSize: w * 0.024),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.028,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(
    BuildContext context,
    AdminPaymentsProvider provider,
    double w,
    double h,
  ) {
    final tabs = ['All', 'Cash', 'Online', 'Pending', 'Refunds', 'No-Shows'];
    return Container(
      height: h * 0.045,
      margin: EdgeInsets.only(bottom: h * 0.015),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isActive = provider.activeFilterTab == tab;
          return GestureDetector(
            onTap: () => provider.updateFilterTab(tab),
            child: Container(
              margin: EdgeInsets.only(
                left: index == 0 ? w * 0.04 : w * 0.02,
                right: index == tabs.length - 1 ? w * 0.04 : 0,
              ),
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryPink.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(w * 0.04),
                border: Border.all(
                  color: isActive
                      ? AppColors.primaryPink
                      : AppColors.divider(context),
                  width: isActive ? 1.5 : 1,
                ),
              ),
              child: Center(
                child: Text(
                  context.tr(tab),
                  style: TextStyle(
                    color: isActive
                        ? AppColors.primaryPink
                        : AppColors.textSecondary(context),
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.03,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionCard(
    BuildContext context,
    AdminPaymentsProvider provider,
    Map<String, dynamic> txn,
    double w,
    double h,
  ) {
    final status = txn['status'] as String;
    final bookingStatus = txn['bookingStatus']?.toString() ?? '';

    Color statusColor;
    Color statusBg;
    IconData statusIcon;

    if (status == 'Paid') {
      statusColor = AppColors.success;
      statusBg = AppColors.success.withValues(alpha: 0.12);
      statusIcon = Icons.check_circle_outline;
    } else if (status == 'Pending') {
      statusColor = Colors.orange;
      statusBg = Colors.orange.withValues(alpha: 0.12);
      statusIcon = Icons.hourglass_empty;
    } else if (status == 'RefundRequested') {
      statusColor = Colors.purple;
      statusBg = Colors.purple.withValues(alpha: 0.12);
      statusIcon = Icons.rotate_left_rounded;
    } else if (status == 'Refunded') {
      statusColor = Colors.blue;
      statusBg = Colors.blue.withValues(alpha: 0.12);
      statusIcon = Icons.undo_rounded;
    } else if (status == 'Forfeited') {
      statusColor = const Color(0xFFD32F2F);
      statusBg = const Color(0xFFD32F2F).withValues(alpha: 0.12);
      statusIcon = Icons.money_off_rounded;
    } else if (status == 'No-Show Refunded') {
      statusColor = Colors.teal;
      statusBg = Colors.teal.withValues(alpha: 0.12);
      statusIcon = Icons.person_off_rounded;
    } else {
      statusColor = AppColors.textGrey;
      statusBg = AppColors.inputBg(context);
      statusIcon = Icons.receipt_outlined;
    }

    return Container(
      padding: EdgeInsets.all(w * 0.035),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(w * 0.022),
                decoration: BoxDecoration(
                  color: statusBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(statusIcon, color: statusColor, size: w * 0.045),
              ),
              SizedBox(width: w * 0.025),
              // ✅ FIXED: Expanded middle section with overflow ellipsis
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      txn['customerName'],
                      style: TextStyle(
                        fontSize: w * 0.036,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: h * 0.003),
                    // ✅ FIXED: No unconstrained Row, softWrap enabled with ellipsis
                    Text(
                      'Ref: ${txn['bookingRef']} · ${txn['dateTime']}',
                      style: TextStyle(
                        fontSize: w * 0.027,
                        color: AppColors.textGrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (bookingStatus == 'No-Show') ...[
                      SizedBox(height: h * 0.004),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'NO-SHOW',
                          style: TextStyle(
                            color: Colors.amber.shade800,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: w * 0.02),
              // Right Column (Amount + Status Badge)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₨ ${txn['amount'].toInt()}',
                    style: TextStyle(
                      fontSize: w * 0.038,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: h * 0.004),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      context.tr(status),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Action buttons for Pending
          if (status == 'Pending') ...[
            const SizedBox(height: 10),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                  icon: const Icon(Icons.check, size: 14),
                  label: Text(
                    context.tr('Mark Paid'),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => provider.markAsPaid(txn['id']),
                ),
              ],
            ),
          ],

          // Action buttons for Refund Requested
          if (status == 'RefundRequested') ...[
            const SizedBox(height: 10),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Reason: "${txn['refundReason']}"',
                style: const TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: AppColors.error,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => provider.resolveRefund(txn['id'], false),
                  child: Text(
                    context.tr('Reject'),
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                  ),
                  onPressed: () => provider.resolveRefund(txn['id'], true),
                  child: Text(
                    context.tr('Approve Refund'),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Info note for Forfeited transactions
          if (status == 'Forfeited') ...[
            const SizedBox(height: 8),
            const Divider(),
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFFD32F2F),
                  size: 13,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Advance kept per No-Show policy. ${txn['refundReason'] ?? ''}',
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: Color(0xFFD32F2F),
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],

          // Info note for No-Show Refunded transactions
          if (status == 'No-Show Refunded') ...[
            const SizedBox(height: 8),
            const Divider(),
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.teal, size: 13),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Admin approved refund despite No-Show. ${txn['refundReason'] ?? ''}',
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: Colors.teal,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
