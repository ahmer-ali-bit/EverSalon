import 'dart:io';
import 'package:ever_salon/Admin%20Panel/providers/drawer/admin_drawer_provider.dart';
import 'package:ever_salon/Admin%20Panel/providers/staff%20management/admin_staff_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';
import 'admin_manage_staff_screen.dart';

class AdminStaffScreen extends StatelessWidget {
  const AdminStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminStaffProvider(),
      child: const _AdminStaffContent(),
    );
  }
}

class _AdminStaffContent extends StatelessWidget {
  const _AdminStaffContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminStaffProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.textPrimary(context)),
          onPressed: () {
            // Open 3D Animated Drawer
            context.read<AdminDrawerProvider>().toggleDrawer();
          },
        ),
        title: Text(
          context.tr('Staff'),
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: w * 0.05,
          ),
        ),
        centerTitle: true,
        actions: [
          Center(
            child: GestureDetector(
              onTap: () async {
                // ADD STAFF
                final newData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminManageStaffScreen(),
                  ),
                );
                if (newData != null && context.mounted) {
                  provider.addOrUpdateStaff(newData as Map<String, String>);
                }
              },
              child: Padding(
                padding: EdgeInsets.only(right: w * 0.04),
                child: Text(
                  context.tr('+ Add Staff'),
                  style: TextStyle(
                    color: AppColors.primaryPink,
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.035,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryPink),
              )
            : ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: h * 0.02,
                ),
                itemCount: provider.allStaff.length,
                separatorBuilder: (_, _) => SizedBox(height: h * 0.015),
                itemBuilder: (context, index) {
                  final staff = provider.allStaff[index];
                  return _buildStaffCard(context, w, staff, provider);
                },
              ),
      ),
    );
  }

  Widget _buildStaffCard(
    BuildContext context,
    double w,
    Map<String, String> staff,
    AdminStaffProvider provider,
  ) {
    final name = staff['name'] ?? '';
    final role = staff['role'] ?? '';
    final status = staff['status'] ?? 'Inactive';
    final avatar = staff['avatar'] ?? '';
    final isActive = status == 'Active';
    final statusColor = isActive ? AppColors.success : AppColors.textGrey;

    ImageProvider? imageProvider;
    if (avatar.isNotEmpty) {
      if (avatar.startsWith('assets/')) {
        imageProvider = AssetImage(avatar);
      } else {
        imageProvider = FileImage(File(avatar));
      }
    }

    return Container(
      padding: EdgeInsets.all(w * 0.03),
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        borderRadius: BorderRadius.circular(w * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: w * 0.065,
            backgroundColor: AppColors.inputBg(context),
            backgroundImage: imageProvider,
            onBackgroundImageError: (_, _) {},
            child: imageProvider == null
                ? Icon(Icons.person, color: AppColors.textGrey, size: w * 0.06)
                : null,
          ),
          SizedBox(width: w * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: w * 0.038,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: w * 0.01),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: w * 0.032,
                    color: AppColors.textSecondary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.025,
                  vertical: w * 0.01,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.inputBg(context),
                  borderRadius: BorderRadius.circular(w * 0.03),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: w * 0.025,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
              SizedBox(width: w * 0.03),
              GestureDetector(
                onTap: () async {
                  // EDIT STAFF - poora data pass karo
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminManageStaffScreen(staffData: staff),
                    ),
                  );
                  if (updated != null && context.mounted) {
                    provider.addOrUpdateStaff(updated as Map<String, String>);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(w * 0.015),
                  decoration: BoxDecoration(
                    color: AppColors.inputBg(context),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    size: w * 0.045,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
