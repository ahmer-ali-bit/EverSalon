import 'package:flutter/material.dart';
import '../catalog/packages_provider.dart';

class AdminManualBookingProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = true;
  bool isCreatingBooking = false;

  List<Map<String, dynamic>> customersList = [];
  List<Map<String, dynamic>> servicesList = [];
  List<Map<String, dynamic>> staffList = [];
  List<String> availableSlots = [];

  Map<String, dynamic>? selectedCustomer;
  List<Map<String, dynamic>> selectedServices = [];
  Map<String, dynamic>? selectedPackage;
  Map<String, dynamic>? selectedStaff;
  DateTime? selectedDate;
  String? selectedTimeSlot;
  String paymentMethod = 'Cash';
  String selectionMode = 'services';

  AdminManualBookingProvider();

  List<Map<String, dynamic>> get packagesList =>
      AdminPackagesProvider.activePackagesGlobal;

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // ✅ Safe Helper: Converts String, int, or double to double safely
  static double parsePrice(dynamic val) {
    if (val == null) return 0.0;
    if (val is num) return val.toDouble();
    if (val is String) {
      final clean = val
          .replaceAll('Rs.', '')
          .replaceAll('Rs', '')
          .replaceAll(',', '')
          .trim();
      return double.tryParse(clean) ?? 0.0;
    }
    return 0.0;
  }

  Future<void> fetchRequiredData() async {
    isLoading = true;
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 500));

    customersList = [
      {
        'id': 'C1',
        'name': 'Sara Khan',
        'phone': '+92 300 1234567',
        'tag': 'VIP',
      },
      {
        'id': 'C2',
        'name': 'Ayesha Malik',
        'phone': '+92 301 2345678',
        'tag': 'VIP',
      },
      {
        'id': 'C3',
        'name': 'Hina Fatima',
        'phone': '+92 302 3456789',
        'tag': 'Regular',
      },
      {
        'id': 'C4',
        'name': 'Zainab Noor',
        'phone': '+92 303 4567890',
        'tag': 'Regular',
      },
    ];

    servicesList = [
      {
        'id': 'S1',
        'name': 'Hair Spa Treatment',
        'price': 2000.0,
        'duration': '45 mins',
      },
      {
        'id': 'S2',
        'name': 'Bridal Makeup',
        'price': 5500.0,
        'duration': '120 mins',
      },
      {
        'id': 'S3',
        'name': 'Hair Cut & Styling',
        'price': 1200.0,
        'duration': '30 mins',
      },
      {
        'id': 'S4',
        'name': 'Classic Pedicure',
        'price': 1500.0,
        'duration': '40 mins',
      },
      {
        'id': 'S5',
        'name': 'Facial Glow',
        'price': 1800.0,
        'duration': '60 mins',
      },
      {
        'id': 'S6',
        'name': 'Gel Manicure',
        'price': 1200.0,
        'duration': '35 mins',
      },
      {
        'id': 'S7',
        'name': 'Threading & Waxing',
        'price': 800.0,
        'duration': '25 mins',
      },
    ];

    staffList = [
      {
        'id': 'ST_1',
        'name': 'Anaya Khan',
        'role': 'Senior Beautician',
        'avatar': '',
      },
      {
        'id': 'ST_2',
        'name': 'Kiran Fatima',
        'role': 'Hair Expert',
        'avatar': '',
      },
      {'id': 'ST_3', 'name': 'Ayesha Malik', 'role': 'Nail Tech', 'avatar': ''},
    ];

    isLoading = false;
    _safeNotify();
  }

  Future<void> updateAvailableSlots() async {
    if (selectedDate == null || selectedStaff == null) {
      availableSlots = [];
      _safeNotify();
      return;
    }

    availableSlots = [];
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 200));

    if (selectedStaff!['id'] == 'ST_2') {
      availableSlots = [
        '09:00 AM',
        '10:00 AM',
        '11:00 AM',
        '02:00 PM',
        '04:00 PM',
      ];
    } else {
      availableSlots = [
        '10:30 AM',
        '11:30 AM',
        '01:00 PM',
        '03:30 PM',
        '05:00 PM',
        '06:00 PM',
      ];
    }

    if (selectedTimeSlot != null &&
        !availableSlots.contains(selectedTimeSlot)) {
      selectedTimeSlot = null;
    }

    _safeNotify();
  }

  void selectCustomer(Map<String, dynamic> customer) {
    selectedCustomer = customer;
    _safeNotify();
  }

  void switchSelectionMode(String mode) {
    selectionMode = mode;
    if (mode == 'services') {
      selectedPackage = null;
    } else {
      selectedServices.clear();
    }
    _safeNotify();
  }

  void selectPackage(Map<String, dynamic>? package) {
    selectedPackage = package;
    _safeNotify();
  }

  // ✅ Type-safe toggle
  void toggleServiceSelection(Map<String, dynamic> service) {
    final index = selectedServices.indexWhere(
      (s) => s['id']?.toString() == service['id']?.toString(),
    );
    if (index != -1) {
      selectedServices.removeAt(index);
    } else {
      selectedServices.add({
        'id': service['id'],
        'name': service['name'],
        'price': parsePrice(service['price']),
        'duration': service['duration'] ?? '',
        'isCustom': false,
      });
    }
    _safeNotify();
  }

  void updateServicePrice(String serviceId, double newPrice) {
    final index = selectedServices.indexWhere(
      (s) => s['id']?.toString() == serviceId,
    );
    if (index != -1) {
      selectedServices[index]['price'] = newPrice;
      _safeNotify();
    }
  }

  void addCustomService(String name, double price, String duration) {
    final customService = {
      'id': 'CUSTOM_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'price': price,
      'duration': duration,
      'isCustom': true,
    };
    selectedServices.add(customService);
    _safeNotify();
  }

  void removeService(String serviceId) {
    selectedServices.removeWhere((s) => s['id']?.toString() == serviceId);
    _safeNotify();
  }

  void selectStaff(Map<String, dynamic> staff) {
    selectedStaff = staff;
    updateAvailableSlots();
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    updateAvailableSlots();
  }

  void selectTimeSlot(String time) {
    selectedTimeSlot = time;
    _safeNotify();
  }

  void selectPaymentMethod(String method) {
    paymentMethod = method;
    _safeNotify();
  }

  // ✅ 100% Safe Subtotal Calculation (No crashes regardless of string or num)
  double get subtotal {
    if (selectionMode == 'package' && selectedPackage != null) {
      return parsePrice(selectedPackage!['price']);
    }
    return selectedServices.fold(0.0, (sum, s) => sum + parsePrice(s['price']));
  }

  double get serviceTax => subtotal * 0.10;
  double get totalAmount => subtotal + serviceTax;

  bool get canSubmit {
    final hasCatalog =
        selectionMode == 'services' && selectedServices.isNotEmpty;
    final hasPackage = selectionMode == 'package' && selectedPackage != null;
    return selectedCustomer != null &&
        (hasCatalog || hasPackage) &&
        selectedStaff != null &&
        selectedDate != null &&
        selectedTimeSlot != null;
  }

  void registerWalkInCustomer(String name, String phone) {
    final newCust = {
      'id': 'C_TEMP_${DateTime.now().millisecondsSinceEpoch}',
      'name': name,
      'phone': phone,
      'tag': 'New',
    };
    customersList.insert(0, newCust);
    selectedCustomer = newCust;
    _safeNotify();
  }

  Future<Map<String, dynamic>?> submitManualBooking() async {
    if (!canSubmit) return null;

    isCreatingBooking = true;
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 1000));

    String serviceDisplay = '';
    if (selectionMode == 'package' && selectedPackage != null) {
      serviceDisplay = '📦 ${selectedPackage!['name']}';
    } else {
      serviceDisplay = selectedServices.map((s) => s['name']).join(', ');
    }

    final Map<String, dynamic> createdRecord = {
      'id':
          'ESR${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      'customerName': selectedCustomer!['name'],
      'customerAvatar': '',
      'service': serviceDisplay,
      'dateTime':
          '${selectedDate!.day} ${_monthName(selectedDate!.month)} ${selectedDate!.year}, $selectedTimeSlot',
      'price': 'Rs. ${totalAmount.toInt()}',
      'status': 'Confirmed',
    };

    isCreatingBooking = false;
    _safeNotify();
    return createdRecord;
  }

  String _monthName(int m) {
    const names = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return names[m];
  }
}
