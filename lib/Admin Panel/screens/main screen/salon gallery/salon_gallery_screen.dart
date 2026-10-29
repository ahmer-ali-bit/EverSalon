import 'dart:io';
import 'package:ever_salon/Admin%20Panel/providers/salon%20gallery/salon_gallery_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class AdminSalonGalleryScreen extends StatelessWidget {
  const AdminSalonGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminSalonGalleryProvider(),
      child: const _AdminSalonGalleryContent(),
    );
  }
}

class _AdminSalonGalleryContent extends StatelessWidget {
  const _AdminSalonGalleryContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminSalonGalleryProvider>();
    final list = provider.filteredPhotos;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
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
                  SizedBox(width: w * 0.03),
                  Expanded(
                    child: Text(
                      context.tr('Salon Gallery'),
                      style: TextStyle(
                        fontSize: w * 0.05,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: provider.isUploading
                        ? null
                        : () => _showAddSheet(context, w, provider),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.03,
                        vertical: h * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink,
                        borderRadius: BorderRadius.circular(w * 0.06),
                      ),
                      child: provider.isUploading
                          ? SizedBox(
                              width: w * 0.04,
                              height: w * 0.04,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: Colors.white,
                                  size: w * 0.045,
                                ),
                                SizedBox(width: w * 0.015),
                                Text(
                                  context.tr('Add'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.032,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),

            // ONLY: All | Interior | Exterior
            SizedBox(
              height: h * 0.05,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                scrollDirection: Axis.horizontal,
                itemCount: provider.categories.length,
                separatorBuilder: (_, _) => SizedBox(width: w * 0.02),
                itemBuilder: (context, index) {
                  final cat = provider.categories[index];
                  final selected = provider.selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => provider.setCategory(cat),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.01,
                      ),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(
                                colors: [Color(0xFFE82A78), Color(0xFF6B2A8A)],
                              )
                            : null,
                        color: selected ? null : AppColors.inputBg(context),
                        borderRadius: BorderRadius.circular(w * 0.08),
                      ),
                      child: Center(
                        child: Text(
                          context.tr(cat),
                          style: TextStyle(
                            fontSize: w * 0.032,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: selected
                                ? Colors.white
                                : AppColors.textSecondary(context),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: h * 0.012),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              child: Text(
                context.tr(
                  'Only salon interior & exterior photos. Staff photos → Staff screen. Service photos → Services. Package photos → Packages.',
                ),
                style: TextStyle(
                  fontSize: w * 0.028,
                  color: AppColors.textSecondary(context),
                  height: 1.35,
                ),
              ),
            ),
            SizedBox(height: h * 0.015),

            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    )
                  : list.isEmpty
                  ? _empty(context, w, h, provider)
                  : GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.005,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: w * 0.03,
                        mainAxisSpacing: w * 0.03,
                        childAspectRatio: 0.95,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return _photoCard(context, w, list[index], provider);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSheet(
    BuildContext context,
    double w,
    AdminSalonGalleryProvider provider,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.05)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(w * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.tr('Add Salon Photo'),
                  style: TextStyle(
                    fontSize: w * 0.042,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: w * 0.04),
                ListTile(
                  leading: Icon(
                    Icons.weekend_outlined,
                    color: AppColors.primaryPink,
                  ),
                  title: Text(
                    context.tr('Interior'),
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    context.tr('Inside salon photos'),
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: AppColors.textGrey,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    provider.addPhoto(forceCategory: 'Interior');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.storefront_outlined,
                    color: AppColors.primaryPink,
                  ),
                  title: Text(
                    context.tr('Exterior'),
                    style: TextStyle(
                      color: AppColors.textPrimary(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    context.tr('Outside / front view'),
                    style: TextStyle(
                      fontSize: w * 0.03,
                      color: AppColors.textGrey,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    provider.addPhoto(forceCategory: 'Exterior');
                  },
                ),
                SizedBox(height: w * 0.02),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _empty(
    BuildContext context,
    double w,
    double h,
    AdminSalonGalleryProvider provider,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.storefront_outlined,
            size: w * 0.16,
            color: AppColors.textGrey,
          ),
          SizedBox(height: h * 0.02),
          Text(
            context.tr('No salon photos yet'),
            style: TextStyle(
              fontSize: w * 0.04,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: h * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.1),
            child: Text(
              context.tr('Add interior or exterior photos of your salon only'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: w * 0.032,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
          SizedBox(height: h * 0.025),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(w * 0.08),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.06,
                vertical: h * 0.014,
              ),
            ),
            onPressed: () => _showAddSheet(context, w, provider),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              context.tr('Add Photo'),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: w * 0.035,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoCard(
    BuildContext context,
    double w,
    Map<String, dynamic> photo,
    AdminSalonGalleryProvider provider,
  ) {
    final path = photo['path']?.toString() ?? '';
    final cat = photo['category']?.toString() ?? 'Interior';
    final isLocal = photo['isLocal'] == true;
    final id = photo['id']?.toString() ?? '';

    ImageProvider? img;
    if (path.isNotEmpty) {
      if (isLocal || !path.startsWith('assets/')) {
        img = FileImage(File(path));
      } else {
        img = AssetImage(path);
      }
    }

    return GestureDetector(
      onTap: () => _options(context, w, photo, provider),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg(context),
          borderRadius: BorderRadius.circular(w * 0.035),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (img != null)
              Image(
                image: img,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.inputBg(context),
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textGrey,
                    size: w * 0.1,
                  ),
                ),
              )
            else
              Container(
                color: AppColors.inputBg(context),
                child: Icon(
                  Icons.image,
                  color: AppColors.textGrey,
                  size: w * 0.1,
                ),
              ),
            Positioned(
              left: w * 0.02,
              top: w * 0.02,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.025,
                  vertical: w * 0.01,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(w * 0.02),
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              right: w * 0.02,
              top: w * 0.02,
              child: Container(
                padding: EdgeInsets.all(w * 0.015),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: w * 0.04,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _options(
    BuildContext context,
    double w,
    Map<String, dynamic> photo,
    AdminSalonGalleryProvider provider,
  ) {
    final id = photo['id']?.toString() ?? '';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.05)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(w * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('Photo options'),
                  style: TextStyle(
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: w * 0.03),
                Text(
                  context.tr('Category'),
                  style: TextStyle(
                    fontSize: w * 0.032,
                    color: AppColors.textGrey,
                  ),
                ),
                SizedBox(height: w * 0.02),
                Row(
                  children: [
                    _catChip(
                      context,
                      w,
                      'Interior',
                      photo['category'] == 'Interior',
                      () {
                        provider.changeCategory(id, 'Interior');
                        Navigator.pop(ctx);
                      },
                    ),
                    SizedBox(width: w * 0.02),
                    _catChip(
                      context,
                      w,
                      'Exterior',
                      photo['category'] == 'Exterior',
                      () {
                        provider.changeCategory(id, 'Exterior');
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
                SizedBox(height: w * 0.02),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.delete_outline, color: AppColors.error),
                  title: Text(
                    context.tr('Delete Photo'),
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                      fontSize: w * 0.038,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    provider.deletePhoto(id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _catChip(
    BuildContext context,
    double w,
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.04,
          vertical: w * 0.025,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryPink : AppColors.inputBg(context),
          borderRadius: BorderRadius.circular(w * 0.06),
        ),
        child: Text(
          context.tr(label),
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary(context),
            fontWeight: FontWeight.w600,
            fontSize: w * 0.032,
          ),
        ),
      ),
    );
  }
}
