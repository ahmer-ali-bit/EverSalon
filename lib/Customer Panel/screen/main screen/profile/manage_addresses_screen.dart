import 'package:ever_salon/Customer%20Panel/provider/profile/manage_addresses_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import 'add_address_screen.dart';

class ManageAddressesScreen extends StatelessWidget {
  const ManageAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ManageAddressesProvider()..fetchAddresses(),
      child: const _ManageAddressesView(),
    );
  }
}

class _ManageAddressesView extends StatelessWidget {
  const _ManageAddressesView();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<ManageAddressesProvider>();

    final bg = AppColors.scaffoldBg(context);
    final cardBg = AppColors.cardBg(context);
    final textPrim = AppColors.textPrimary(context);
    final textSec = AppColors.textSecondary(context);
    final iconBg = AppColors.iconCircleBg(context);
    final divColor = AppColors.divider(context);

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
                    'My Addresses',
                    style: TextStyle(
                      fontSize: w * 0.05,
                      fontWeight: FontWeight.bold,
                      color: textPrim,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // Pass provider instance to Add Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: provider,
                            child: const AddAddressScreen(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      '+ Add New',
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
              child: provider.isLoading && provider.addresses.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : provider.addresses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off_outlined,
                            size: w * 0.15,
                            color: textSec,
                          ),
                          SizedBox(height: h * 0.015),
                          Text(
                            'No addresses saved',
                            style: TextStyle(
                              fontSize: w * 0.04,
                              color: textSec,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.01,
                      ),
                      itemCount: provider.addresses.length,
                      separatorBuilder: (_, _) => SizedBox(height: h * 0.015),
                      itemBuilder: (context, index) {
                        final address = provider.addresses[index];
                        return GestureDetector(
                          onTap: () {
                            // Tap card to make default
                            if (!address.isDefault) {
                              provider.setDefault(address.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${address.type} set as default',
                                  ),
                                ),
                              );
                            }
                          },
                          child: _addressCard(
                            w: w,
                            h: h,
                            context: context,
                            address: address,
                            cardBg: cardBg,
                            textPrim: textPrim,
                            textSec: textSec,
                            divColor: divColor,
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChangeNotifierProvider.value(
                                    value: provider,
                                    child: AddAddressScreen(
                                      addressToEdit: address,
                                    ),
                                  ),
                                ),
                              );
                            },
                            onDelete: () {
                              _showDeleteDialog(
                                context: context,
                                w: w,
                                h: h,
                                textPrim: textPrim,
                                textSec: textSec,
                                onConfirm: () {
                                  provider.deleteAddress(address.id);
                                  Navigator.pop(context);
                                },
                              );
                            },
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

  Widget _addressCard({
    required double w,
    required double h,
    required BuildContext context,
    required AddressModel address,
    required Color cardBg,
    required Color textPrim,
    required Color textSec,
    required Color divColor,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    IconData typeIcon = address.type == 'Home'
        ? Icons.home_outlined
        : address.type == 'Office'
        ? Icons.work_outline
        : Icons.location_on_outlined;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(
          color: address.isDefault
              ? AppColors.primaryPink.withValues(alpha: 0.4)
              : divColor,
          width: address.isDefault ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: w * 0.09,
                height: w * 0.09,
                decoration: BoxDecoration(
                  color: AppColors.primaryPink.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(w * 0.02),
                ),
                child: Icon(
                  typeIcon,
                  color: AppColors.primaryPink,
                  size: w * 0.045,
                ),
              ),
              SizedBox(width: w * 0.03),
              Text(
                address.type,
                style: TextStyle(
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.bold,
                  color: textPrim,
                ),
              ),
              if (address.isDefault) ...[
                SizedBox(width: w * 0.02),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.025,
                    vertical: h * 0.003,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPink,
                    borderRadius: BorderRadius.circular(w * 0.015),
                  ),
                  child: Text(
                    'Default',
                    style: TextStyle(
                      fontSize: w * 0.025,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: EdgeInsets.all(w * 0.015),
                  decoration: BoxDecoration(
                    color: AppColors.inputBg(context),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    size: w * 0.04,
                    color: textSec,
                  ),
                ),
              ),
              SizedBox(width: w * 0.02),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: EdgeInsets.all(w * 0.015),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    size: w * 0.04,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.012),
          Text(
            address.name,
            style: TextStyle(
              fontSize: w * 0.036,
              fontWeight: FontWeight.w600,
              color: textPrim,
            ),
          ),
          SizedBox(height: h * 0.005),
          Text(
            address.fullAddress,
            style: TextStyle(fontSize: w * 0.032, color: textSec, height: 1.35),
          ),
          SizedBox(height: h * 0.005),
          Text(
            address.phone,
            style: TextStyle(
              fontSize: w * 0.032,
              color: textSec,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog({
    required BuildContext context,
    required double w,
    required double h,
    required Color textPrim,
    required Color textSec,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.cardBg(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(w * 0.04),
          ),
          title: Text(
            'Delete Address',
            style: TextStyle(
              fontSize: w * 0.045,
              fontWeight: FontWeight.bold,
              color: textPrim,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this address? This action cannot be undone.',
            style: TextStyle(fontSize: w * 0.035, color: textSec),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: TextStyle(color: textSec, fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: onConfirm,
              child: Text(
                'Delete',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
