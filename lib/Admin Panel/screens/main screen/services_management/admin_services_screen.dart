import 'dart:io';
import 'package:ever_salon/Admin%20Panel/providers/drawer/admin_drawer_provider.dart';
import 'package:ever_salon/Admin%20Panel/providers/services%20management/admin_services_provider.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/services_management/admin_manage_services_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class AdminServicesScreen extends StatelessWidget {
  const AdminServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminServicesProvider(),
      child: const _AdminServicesContent(),
    );
  }
}

class _AdminServicesContent extends StatelessWidget {
  const _AdminServicesContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminServicesProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.textPrimary(context)),
          onPressed: () {
            context.read<AdminDrawerProvider>().toggleDrawer();
          },
        ),
        title: Text(
          context.tr('Services'),
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
                final newService = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminManageServiceScreen(),
                  ),
                );
                if (newService != null && context.mounted) {
                  provider.addOrUpdateService(
                    newService as Map<String, dynamic>,
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.only(right: w * 0.04),
                child: Text(
                  context.tr('+ Add Service'),
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
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: h * 0.01,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.inputBg(context),
                  borderRadius: BorderRadius.circular(w * 0.03),
                ),
                child: TextField(
                  onChanged: provider.updateSearch,
                  decoration: InputDecoration(
                    hintText: context.tr('Search services...'),
                    hintStyle: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: w * 0.035,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.textGrey,
                      size: w * 0.05,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: h * 0.015),
                  ),
                ),
              ),
            ),

            // List
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.01,
                      ),
                      itemCount: provider.filteredServices.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: h * 0.015),
                      itemBuilder: (context, index) {
                        final service = provider.filteredServices[index];
                        return _buildServiceCard(context, w, service, provider);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    double w,
    Map<String, dynamic> service,
    AdminServicesProvider provider,
  ) {
    final String name = service['name'] ?? '';
    final String duration = service['duration'] ?? '';
    final String price = service['price']?.toString() ?? '';
    final String imagePath = service['image'] ?? '';
    final String categoryName = service['categoryName'] ?? '';
    final bool isActive = service['isActive'] ?? false;
    final String id = service['id'];

    ImageProvider? imageProvider;
    if (imagePath.isNotEmpty) {
      if (imagePath.startsWith('assets/')) {
        imageProvider = AssetImage(imagePath);
      } else {
        imageProvider = FileImage(File(imagePath));
      }
    }

    return GestureDetector(
      onTap: () async {
        final updatedService = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdminManageServiceScreen(serviceData: service),
          ),
        );
        if (updatedService != null && context.mounted) {
          provider.addOrUpdateService(updatedService as Map<String, dynamic>);
        }
      },
      child: Container(
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
            // Service Image
            Container(
              width: w * 0.15,
              height: w * 0.15,
              decoration: BoxDecoration(
                color: AppColors.inputBg(context),
                borderRadius: BorderRadius.circular(w * 0.02),
                image: imageProvider != null
                    ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                    : null,
              ),
              child: imageProvider == null
                  ? Icon(Icons.spa, color: AppColors.textGrey, size: w * 0.08)
                  : null,
            ),
            SizedBox(width: w * 0.03),

            // Details
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
                  if (categoryName.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.02,
                        vertical: w * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(w * 0.015),
                      ),
                      child: Text(
                        categoryName,
                        style: TextStyle(
                          fontSize: w * 0.025,
                          color: AppColors.primaryPink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  SizedBox(height: w * 0.01),
                  Row(
                    children: [
                      Text(
                        duration,
                        style: TextStyle(
                          fontSize: w * 0.032,
                          color: AppColors.textSecondary(context),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                        child: Text(
                          "|",
                          style: TextStyle(
                            fontSize: w * 0.032,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      ),
                      Text(
                        "Rs. $price",
                        style: TextStyle(
                          fontSize: w * 0.032,
                          color: AppColors.textSecondary(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Active Toggle
            Switch(
              value: isActive,
              activeThumbColor: AppColors.primaryPink,
              onChanged: (val) => provider.toggleServiceStatus(id, val),
            ),
          ],
        ),
      ),
    );
  }
}
