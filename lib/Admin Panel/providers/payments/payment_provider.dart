import 'package:flutter/material.dart';

class AdminPaymentsProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;

  // Aggregate Revenue Parameters
  double totalRevenue = 158400.0;
  double outstandingInvoices = 18900.0;
  double pendingRefundRequests = 4500.0;
  double forfeitedAmount = 3200.0; // ✅ NEW: No-Show forfeited funds

  // State Filtering Properties
  String activeFilterTab = 'All';
  List<Map<String, dynamic>> transactionLedger = [];

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // =========================================================================
  // ⚡ BACKEND INTEGRATION - GET TRANSACTION LIST
  // API Endpoint: GET /api/admin/payments
  // Query Parameters: status={Paid, Pending, RefundRequested, Forfeited, Refunded, No-Show}
  // =========================================================================
  Future<void> fetchTransactions() async {
    isLoading = true;
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 600));

    transactionLedger = [
      {
        'id': 'TXN_9901',
        'customerName': 'Sara Khan',
        'dateTime': '24 Oct 2023, 10:30 AM',
        'amount': 15000.0,
        'method': 'Online',
        'status': 'Paid',
        'bookingRef': 'B9901',
        'bookingStatus': 'Completed',
      },
      {
        'id': 'TXN_9582',
        'customerName': 'Ayesha Malik',
        'dateTime': '12 Sep 2023, 05:00 PM',
        'amount': 4500.0,
        'method': 'Card',
        'status': 'Paid',
        'bookingRef': 'B9582',
        'bookingStatus': 'Completed',
      },
      {
        'id': 'TXN_8110',
        'customerName': 'Hina Fatima',
        'dateTime': 'Today, 11:00 AM',
        'amount': 4200.0,
        'method': 'Cash',
        'status': 'Pending',
        'bookingRef': 'B8110',
        'bookingStatus': 'Pending',
      },
      {
        'id': 'TXN_3202',
        'customerName': 'Zainab Noor',
        'dateTime': 'Yesterday, 02:00 PM',
        'amount': 4500.0,
        'method': 'Online',
        'status': 'RefundRequested',
        'bookingRef': 'B3202',
        'bookingStatus': 'Cancelled',
        'refundReason': 'Cancelled booking prior to 24 hrs constraint.',
      },
      {
        'id': 'TXN_2209',
        'customerName': 'Maria Ahmed',
        'dateTime': '05 Nov 2023, 04:00 PM',
        'amount': 14700.0,
        'method': 'Online',
        'status': 'Refunded',
        'bookingRef': 'B2209',
        'bookingStatus': 'Cancelled',
      },
      // ✅ NEW: No-Show Forfeited Transaction
      {
        'id': 'TXN_7701',
        'customerName': 'Fatima Ali',
        'dateTime': '10 Nov 2023, 03:00 PM',
        'amount': 3200.0,
        'method': 'Online',
        'status': 'Forfeited', // ✅ Customer paid online but never showed up
        'bookingRef': 'B7701',
        'bookingStatus': 'No-Show',
        'refundReason':
            'Customer did not arrive. Advance payment forfeited per salon policy.',
      },
      // ✅ NEW: No-Show Refunded Transaction
      {
        'id': 'TXN_6601',
        'customerName': 'Sana Riaz',
        'dateTime': '08 Nov 2023, 01:00 PM',
        'amount': 2500.0,
        'method': 'Card',
        'status': 'No-Show Refunded', // ✅ Admin chose to refund the no-show
        'bookingRef': 'B6601',
        'bookingStatus': 'No-Show',
        'refundReason':
            'Customer called later with valid emergency. Admin approved refund.',
      },
    ];

    isLoading = false;
    _safeNotify();
  }

  void updateFilterTab(String newTab) {
    activeFilterTab = newTab;
    _safeNotify();
  }

  List<Map<String, dynamic>> get filteredTransactions {
    if (activeFilterTab == 'All') return transactionLedger;
    if (activeFilterTab == 'Refunds') {
      return transactionLedger
          .where(
            (txn) =>
                txn['status'] == 'RefundRequested' ||
                txn['status'] == 'Refunded' ||
                txn['status'] == 'No-Show Refunded',
          )
          .toList();
    }
    if (activeFilterTab == 'No-Shows') {
      return transactionLedger
          .where(
            (txn) =>
                txn['status'] == 'Forfeited' ||
                txn['status'] == 'No-Show Refunded',
          )
          .toList();
    }
    if (activeFilterTab == 'Pending') {
      return transactionLedger
          .where((txn) => txn['status'] == 'Pending')
          .toList();
    }
    return transactionLedger
        .where((txn) => txn['method'] == activeFilterTab)
        .toList();
  }

  Future<void> markAsPaid(String transactionId) async {
    final index = transactionLedger.indexWhere(
      (element) => element['id'] == transactionId,
    );
    if (index != -1) {
      final txnAmt = transactionLedger[index]['amount'] as double;
      transactionLedger[index]['status'] = 'Paid';
      transactionLedger[index]['method'] = 'Cash';
      outstandingInvoices -= txnAmt;
      totalRevenue += txnAmt;
      _safeNotify();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  Future<void> resolveRefund(String transactionId, bool isApproved) async {
    final index = transactionLedger.indexWhere(
      (element) => element['id'] == transactionId,
    );
    if (index != -1) {
      final txnAmt = transactionLedger[index]['amount'] as double;
      if (isApproved) {
        transactionLedger[index]['status'] = 'Refunded';
        totalRevenue -= txnAmt;
      } else {
        transactionLedger[index]['status'] = 'Paid';
      }
      pendingRefundRequests -= txnAmt;
      _safeNotify();
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }
}
