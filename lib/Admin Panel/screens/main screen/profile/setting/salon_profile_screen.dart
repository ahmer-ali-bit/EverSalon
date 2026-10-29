import 'dart:io';
import 'package:ever_salon/Admin%20Panel/providers/profile/setting/salon_profile_provider.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/profile/setting/salon_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../constants/app_colors.dart';
import '../../../../../../constants/app_translations.dart';

class AdminSalonProfileScreen extends StatelessWidget {
  const AdminSalonProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminSalonProfileProvider(),
      child: const _AdminSalonProfileContent(),
    );
  }
}

class _AdminSalonProfileContent extends StatelessWidget {
  const _AdminSalonProfileContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminSalonProfileProvider>();

    ImageProvider? coverImg;
    if (provider.pickedCoverPath.isNotEmpty) {
      coverImg = FileImage(File(provider.pickedCoverPath));
    } else if (provider.coverImage.isNotEmpty &&
        provider.coverImage.startsWith('assets/')) {
      coverImg = AssetImage(provider.coverImage);
    }

    ImageProvider? logoImg;
    if (provider.pickedLogoPath.isNotEmpty) {
      logoImg = FileImage(File(provider.pickedLogoPath));
    } else if (provider.logoImage.isNotEmpty &&
        provider.logoImage.startsWith('assets/')) {
      logoImg = AssetImage(provider.logoImage);
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: SafeArea(
        child: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryPink),
              )
            : Column(
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
                        Text(
                          context.tr('Salon Profile'),
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
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.01,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // COVER IMAGE
                          Text(
                            context.tr('Cover Photo'),
                            style: TextStyle(
                              fontSize: w * 0.035,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.01),
                          GestureDetector(
                            onTap: provider.pickCover,
                            child: Stack(
                              children: [
                                Container(
                                  height: h * 0.18,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.inputBg(context),
                                    borderRadius: BorderRadius.circular(
                                      w * 0.04,
                                    ),
                                    image: coverImg != null
                                        ? DecorationImage(
                                            image: coverImg,
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: coverImg == null
                                      ? Center(
                                          child: Icon(
                                            Icons.add_photo_alternate_outlined,
                                            size: w * 0.12,
                                            color: AppColors.textGrey,
                                          ),
                                        )
                                      : null,
                                ),
                                Positioned(
                                  right: w * 0.03,
                                  bottom: w * 0.03,
                                  child: Container(
                                    padding: EdgeInsets.all(w * 0.02),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryPink,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: w * 0.04,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: h * 0.02),

                          // LOGO
                          Text(
                            context.tr('Salon Logo'),
                            style: TextStyle(
                              fontSize: w * 0.035,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: h * 0.01),
                          Center(
                            child: GestureDetector(
                              onTap: provider.pickLogo,
                              child: Stack(
                                children: [
                                  Container(
                                    width: w * 0.22,
                                    height: w * 0.22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.inputBg(context),
                                      border: Border.all(
                                        color: AppColors.primaryPink.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 2,
                                      ),
                                      image: logoImg != null
                                          ? DecorationImage(
                                              image: logoImg,
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: logoImg == null
                                        ? Icon(
                                            Icons.storefront,
                                            size: w * 0.1,
                                            color: AppColors.textGrey,
                                          )
                                        : null,
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(w * 0.015),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryPink,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: w * 0.035,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.025),

                          _label(context, w, 'Salon Name'),
                          _field(
                            context,
                            w,
                            'Enter salon name',
                            provider.nameController,
                            TextInputType.name,
                          ),
                          SizedBox(height: h * 0.018),

                          _label(context, w, 'Tagline'),
                          _field(
                            context,
                            w,
                            'Short tagline',
                            provider.taglineController,
                            TextInputType.text,
                          ),
                          SizedBox(height: h * 0.018),

                          _label(context, w, 'Phone'),
                          _field(
                            context,
                            w,
                            '+92 300...',
                            provider.phoneController,
                            TextInputType.phone,
                          ),
                          SizedBox(height: h * 0.018),

                          _label(context, w, 'Email'),
                          _field(
                            context,
                            w,
                            'salon@email.com',
                            provider.emailController,
                            TextInputType.emailAddress,
                          ),
                          SizedBox(height: h * 0.018),

                          _label(context, w, 'About Salon'),
                          _field(
                            context,
                            w,
                            'Describe your salon...',
                            provider.aboutController,
                            TextInputType.multiline,
                            maxLines: 4,
                          ),
                          SizedBox(height: h * 0.018),

                          _label(context, w, 'Address (text)'),
                          _field(
                            context,
                            w,
                            'Full address',
                            provider.addressController,
                            TextInputType.streetAddress,
                            maxLines: 2,
                          ),
                          SizedBox(height: h * 0.012),

                          // Set Location shortcut
                          GestureDetector(
                            onTap: () async {
                              // NAVIGATION: From [AdminSalonProfileScreen] → To [AdminSalonLocationScreen]
                              // Trigger: Tap Set Map Location
                              // Data passed: current address text
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AdminSalonLocationScreen(
                                    initialAddress:
                                        provider.addressController.text,
                                  ),
                                ),
                              );

                              // Wapas aane par address (aur related) update
                              if (result != null &&
                                  result is Map &&
                                  context.mounted) {
                                final address = result['address']?.toString();
                                if (address != null && address.isNotEmpty) {
                                  provider.addressController.text = address;
                                }
                                // optional: agar provider mein city field baad mein add ho
                                // provider can notify if needed
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.tr('Location updated on profile'),
                                    ),
                                    backgroundColor: AppColors.success,
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.016,
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.inputBg(context),
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.03,
                                ),
                                border: Border.all(
                                  color: AppColors.primaryPink.withValues(
                                    alpha: 0.25,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: AppColors.primaryPink,
                                    size:
                                        MediaQuery.of(context).size.width *
                                        0.055,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  Expanded(
                                    child: Text(
                                      context.tr('Set Map Location'),
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                            0.036,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary(context),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size:
                                        MediaQuery.of(context).size.width *
                                        0.035,
                                    color: AppColors.textGrey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.02),

                          // Unisex toggle
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.04,
                              vertical: h * 0.008,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg(context),
                              borderRadius: BorderRadius.circular(w * 0.03),
                              border: Border.all(
                                color: AppColors.inputBg(context),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.tr('Unisex Salon'),
                                        style: TextStyle(
                                          fontSize: w * 0.038,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary(context),
                                        ),
                                      ),
                                      Text(
                                        context.tr(
                                          'Shown on customer salon details',
                                        ),
                                        style: TextStyle(
                                          fontSize: w * 0.028,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: provider.isUnisex,
                                  activeThumbColor: AppColors.primaryPink,
                                  onChanged: provider.toggleUnisex,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: h * 0.04),

                          SizedBox(
                            width: double.infinity,
                            height: h * 0.06,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryPink,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(w * 0.08),
                                ),
                              ),
                              onPressed: provider.isSaving
                                  ? null
                                  : () async {
                                      final ok = await provider.saveProfile();
                                      if (!context.mounted) return;
                                      if (ok) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              context.tr('Salon profile saved'),
                                            ),
                                            backgroundColor: AppColors.success,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              context.tr(
                                                'Please fill name and phone',
                                              ),
                                            ),
                                            backgroundColor: AppColors.error,
                                          ),
                                        );
                                      }
                                    },
                              child: provider.isSaving
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      context.tr('Save Profile'),
                                      style: TextStyle(
                                        fontSize: w * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: h * 0.03),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _label(BuildContext context, double w, String t) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.02),
      child: Text(
        context.tr(t),
        style: TextStyle(
          fontSize: w * 0.035,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary(context),
        ),
      ),
    );
  }

  Widget _field(
    BuildContext context,
    double w,
    String hint,
    TextEditingController c,
    TextInputType type, {
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg(context),
        borderRadius: BorderRadius.circular(w * 0.03),
      ),
      child: TextField(
        controller: c,
        keyboardType: type,
        maxLines: maxLines,
        style: TextStyle(
          color: AppColors.textPrimary(context),
          fontSize: w * 0.035,
        ),
        decoration: InputDecoration(
          hintText: context.tr(hint),
          hintStyle: TextStyle(color: AppColors.textGrey, fontSize: w * 0.035),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: w * 0.035,
          ),
        ),
      ),
    );
  }
}
