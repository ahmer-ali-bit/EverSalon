import 'package:ever_salon/provider/profile/manage_addresses_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_colors.dart';
import '../../../../widgets/custom_button.dart';

class AddAddressScreen extends StatefulWidget {
  final AddressModel? addressToEdit; // Agar null ho toh Add, warna Edit

  const AddAddressScreen({super.key, this.addressToEdit});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedType = 'Home';
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    // Edit mode: data pre-fill karo
    if (widget.addressToEdit != null) {
      _nameController.text = widget.addressToEdit!.name;
      _phoneController.text = widget.addressToEdit!.phone;
      _addressController.text = widget.addressToEdit!.fullAddress;
      _selectedType = widget.addressToEdit!.type;
      _isDefault = widget.addressToEdit!.isDefault;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<ManageAddressesProvider>();

    // Adaptive Colors
    final bg = AppColors.scaffoldBg(context);
    final textPrim = AppColors.textPrimary(context);
    final textSec = AppColors.textSecondary(context);
    final iconBg = AppColors.iconCircleBg(context);
    final divColor = AppColors.divider(context);
    final inputBg = AppColors.inputBg(context);

    final isEditMode = widget.addressToEdit != null;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // ─── HEADER ───
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
                        color: iconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: textPrim,
                        size: w * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  Text(
                    isEditMode ? 'Edit Address' : 'Add New Address',
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: textPrim,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // ─── BODY ───
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: h * 0.02),

                    // TYPE CHIPS
                    Text(
                      'Address Type',
                      style: TextStyle(
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.bold,
                        color: textPrim,
                      ),
                    ),
                    SizedBox(height: h * 0.015),
                    Row(
                      children: [
                        _typeChip(
                          w,
                          h,
                          'Home',
                          Icons.home_outlined,
                          textPrim,
                          inputBg,
                          divColor,
                        ),
                        SizedBox(width: w * 0.03),
                        _typeChip(
                          w,
                          h,
                          'Office',
                          Icons.work_outline,
                          textPrim,
                          inputBg,
                          divColor,
                        ),
                        SizedBox(width: w * 0.03),
                        _typeChip(
                          w,
                          h,
                          'Other',
                          Icons.location_on_outlined,
                          textPrim,
                          inputBg,
                          divColor,
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.03),

                    // FORM FIELDS
                    _buildTextField(
                      w,
                      h,
                      _nameController,
                      'Full Name',
                      'Enter receiver name',
                      Icons.person_outline,
                      inputBg,
                      divColor,
                      textPrim,
                      textSec,
                    ),
                    SizedBox(height: h * 0.02),
                    _buildTextField(
                      w,
                      h,
                      _phoneController,
                      'Phone Number',
                      'Enter phone number',
                      Icons.phone_outlined,
                      inputBg,
                      divColor,
                      textPrim,
                      textSec,
                      isPhone: true,
                    ),
                    SizedBox(height: h * 0.02),
                    _buildTextField(
                      w,
                      h,
                      _addressController,
                      'Detailed Address',
                      'Street, House No, City',
                      Icons.map_outlined,
                      inputBg,
                      divColor,
                      textPrim,
                      textSec,
                      maxLines: 3,
                    ),
                    SizedBox(height: h * 0.03),

                    // DEFAULT TOGGLE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Set as Default',
                              style: TextStyle(
                                fontSize: w * 0.04,
                                fontWeight: FontWeight.bold,
                                color: textPrim,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Use this address for future bookings',
                              style: TextStyle(
                                fontSize: w * 0.032,
                                color: textSec,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _isDefault,
                          onChanged: (val) => setState(() => _isDefault = val),
                          activeThumbColor: AppColors.primaryPink,
                          activeTrackColor: AppColors.primaryPink.withValues(
                            alpha: 0.3,
                          ),
                          inactiveThumbColor: textSec,
                          inactiveTrackColor: inputBg,
                        ),
                      ],
                    ),
                    SizedBox(height: h * 0.05),
                  ],
                ),
              ),
            ),

            // ─── BUTTON ───
            Padding(
              padding: EdgeInsets.all(w * 0.04),
              child: CustomButton(
                text: isEditMode ? 'Update Address' : 'Save Address',
                isLoading: provider.isLoading,
                onTap: () async {
                  if (_nameController.text.trim().isEmpty ||
                      _phoneController.text.trim().isEmpty ||
                      _addressController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  final newModel = AddressModel(
                    id: isEditMode
                        ? widget.addressToEdit!.id
                        : DateTime.now().millisecondsSinceEpoch.toString(),
                    type: _selectedType,
                    name: _nameController.text.trim(),
                    fullAddress: _addressController.text.trim(),
                    phone: _phoneController.text.trim(),
                    isDefault: _isDefault,
                  );

                  final success = isEditMode
                      ? await provider.updateAddress(newModel)
                      : await provider.addAddress(newModel);

                  if (success && context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeChip(
    double w,
    double h,
    String title,
    IconData icon,
    Color textPrim,
    Color inputBg,
    Color divColor,
  ) {
    final isSelected = _selectedType == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = title),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: h * 0.015),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryPink.withValues(alpha: 0.1)
                : inputBg,
            borderRadius: BorderRadius.circular(w * 0.03),
            border: Border.all(
              color: isSelected ? AppColors.primaryPink : divColor,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primaryPink : textPrim,
                size: w * 0.055,
              ),
              SizedBox(height: h * 0.005),
              Text(
                title,
                style: TextStyle(
                  fontSize: w * 0.032,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.primaryPink : textPrim,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    double w,
    double h,
    TextEditingController controller,
    String label,
    String hint,
    IconData icon,
    Color inputBg,
    Color divColor,
    Color textPrim,
    Color textSec, {
    int maxLines = 1,
    bool isPhone = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: w * 0.038,
            fontWeight: FontWeight.w600,
            color: textPrim,
          ),
        ),
        SizedBox(height: h * 0.01),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
          style: TextStyle(color: textPrim, fontSize: w * 0.04),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: textSec, fontSize: w * 0.035),
            filled: true,
            fillColor: inputBg,
            prefixIcon: maxLines == 1
                ? Icon(icon, color: textSec, size: w * 0.05)
                : Padding(
                    padding: EdgeInsets.only(bottom: h * 0.06),
                    child: Icon(icon, color: textSec, size: w * 0.05),
                  ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(w * 0.03),
              borderSide: BorderSide(color: divColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(w * 0.03),
              borderSide: const BorderSide(color: AppColors.primaryPink),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: h * 0.018,
              horizontal: w * 0.04,
            ),
          ),
        ),
      ],
    );
  }
}
