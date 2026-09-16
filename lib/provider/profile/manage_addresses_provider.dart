import 'package:flutter/material.dart';

class AddressModel {
  String id;
  String type; // Home, Office, Other
  String name;
  String fullAddress;
  String phone;
  bool isDefault;

  AddressModel({
    required this.id,
    required this.type,
    required this.name,
    required this.fullAddress,
    required this.phone,
    this.isDefault = false,
  });
}

class ManageAddressesProvider extends ChangeNotifier {
  bool _isDisposed = false;
  bool isLoading = false;

  List<AddressModel> addresses = [];

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  /// 1. Fetch Addresses
  Future<void> fetchAddresses() async {
    if (addresses.isNotEmpty) return; // Prevent re-fetching if already loaded

    isLoading = true;
    _safeNotify();

    try {
      await Future.delayed(const Duration(milliseconds: 800)); // Mock API delay

      addresses = [
        AddressModel(
          id: '1',
          type: 'Home',
          name: 'Zainab Fatima',
          fullAddress: 'Yasrab Town, Near Shell Pump, Bahawalpur, Pakistan',
          phone: '+92 300 1234567',
          isDefault: true,
        ),
        AddressModel(
          id: '2',
          type: 'Office',
          name: 'Zainab Fatima',
          fullAddress: 'Model Town, Bahawalpur, Pakistan',
          phone: '+92 300 7654321',
          isDefault: false,
        ),
      ];

      isLoading = false;
      _safeNotify();
    } catch (e) {
      isLoading = false;
      _safeNotify();
    }
  }

  /// 2. Add New Address
  Future<bool> addAddress(AddressModel newAddress) async {
    isLoading = true;
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 600)); // Mock API

    // Agar naya address default hai, toh baaqi sab false kar do
    if (newAddress.isDefault) {
      for (var a in addresses) {
        a.isDefault = false;
      }
    } else if (addresses.isEmpty) {
      // Agar pehla address hai, toh automatically default hoga
      newAddress.isDefault = true;
    }

    addresses.add(newAddress);
    isLoading = false;
    _safeNotify();
    return true;
  }

  /// 3. Update/Edit Address
  Future<bool> updateAddress(AddressModel updatedAddress) async {
    isLoading = true;
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 600)); // Mock API

    if (updatedAddress.isDefault) {
      for (var a in addresses) {
        a.isDefault = false;
      }
    }

    final index = addresses.indexWhere((a) => a.id == updatedAddress.id);
    if (index != -1) {
      addresses[index] = updatedAddress;
    }

    isLoading = false;
    _safeNotify();
    return true;
  }

  /// 4. Delete Address
  Future<void> deleteAddress(String id) async {
    isLoading = true;
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 500)); // Mock API

    addresses.removeWhere((a) => a.id == id);

    // Agar deleted default tha aur baqi bach gaye, toh pehle ko default bana do
    if (addresses.isNotEmpty && !addresses.any((a) => a.isDefault)) {
      addresses.first.isDefault = true;
    }

    isLoading = false;
    _safeNotify();
  }

  /// 5. Set as Default
  Future<void> setDefault(String id) async {
    isLoading = true;
    _safeNotify();

    await Future.delayed(const Duration(milliseconds: 300)); // Mock API

    for (var a in addresses) {
      a.isDefault = (a.id == id);
    }

    isLoading = false;
    _safeNotify();
  }
}
