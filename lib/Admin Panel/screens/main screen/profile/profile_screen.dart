import 'package:ever_salon/Admin%20Panel/providers/drawer/admin_drawer_provider.dart';
import 'package:ever_salon/Admin%20Panel/providers/profile/profile_provider.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/profile/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../constants/app_colors.dart';
import '../../../../../constants/app_translations.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminProfileProvider(),
      child: const _AdminProfileContent(),
    );
  }
}

class _AdminProfileContent extends StatelessWidget {
  const _AdminProfileContent();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final provider = context.watch<AdminProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.textPrimary(context)),
          onPressed: () {
            // Open 3D Fancy Drawer
            context.read<AdminDrawerProvider>().toggleDrawer();
          },
        ),
        title: Text(
          context.tr('Admin Profile'),
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.bold,
            fontSize: w * 0.05,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: h * 0.02,
          ),
          child: Column(
            children: [
              // --- Gradient Profile Card ---
              Container(
                padding: EdgeInsets.all(w * 0.05),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE82A78), Color(0xFF6B2A8A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(w * 0.05),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPink.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: w * 0.09,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(provider.avatar),
                      onBackgroundImageError: (_, _) {},
                      child: provider.avatar.isEmpty
                          ? Icon(
                              Icons.person,
                              color: AppColors.primaryPink,
                              size: w * 0.08,
                            )
                          : null,
                    ),
                    SizedBox(width: w * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: w * 0.01),
                          Text(
                            provider.role,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: w * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: w * 0.01),
                          Text(
                            provider.email,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: w * 0.03,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(w * 0.02),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: w * 0.05,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: h * 0.04),

              // --- Menu Items ---
              _buildMenuItem(
                context,
                w,
                Icons.person_outline,
                'Personal Information',
                null,
                () {},
              ),
              _buildMenuItem(
                context,
                w,
                Icons.lock_outline,
                'Change Password',
                null,
                () {},
              ),
              _buildMenuItem(
                context,
                w,
                Icons.security_outlined,
                'Two-Factor Authentication',
                Text(
                  provider.isTwoFactorOn ? 'On' : 'Off',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: w * 0.035,
                  ),
                ),
                () => provider.toggleTwoFactor(!provider.isTwoFactorOn),
              ),
              _buildMenuItem(
                context,
                w,
                Icons.language,
                'Language',
                Text(
                  provider.currentLanguage,
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: w * 0.035,
                  ),
                ),
                () {},
              ),
              Divider(
                color: AppColors.inputBg(context),
                thickness: 1.5,
                height: h * 0.04,
              ),

              // SETTINGS ROW
              _buildMenuItem(
                context,
                w,
                Icons.settings_outlined,
                'Settings',
                null,
                () {
                  // NAVIGATION: To Settings Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminSettingsScreen(),
                    ),
                  );
                },
              ),

              SizedBox(height: h * 0.02),

              // LOGOUT ROW
              ListTile(
                onTap: () => provider.logout(context),
                leading: Icon(
                  Icons.logout,
                  color: AppColors.primaryPink,
                  size: w * 0.06,
                ),
                title: Text(
                  context.tr('Logout'),
                  style: TextStyle(
                    color: AppColors.primaryPink,
                    fontSize: w * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                trailing: provider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.primaryPink,
                          strokeWidth: 2,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    double w,
    IconData icon,
    String title,
    Widget? trailingText,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.02),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: EdgeInsets.all(w * 0.025),
          decoration: BoxDecoration(
            color: AppColors.inputBg(context),
            borderRadius: BorderRadius.circular(w * 0.025),
          ),
          child: Icon(
            icon,
            color: AppColors.textSecondary(context),
            size: w * 0.055,
          ),
        ),
        title: Text(
          context.tr(title),
          style: TextStyle(
            color: AppColors.textPrimary(context),
            fontSize: w * 0.04,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null) ...[
              trailingText,
              SizedBox(width: w * 0.02),
            ],
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textGrey,
              size: w * 0.035,
            ),
          ],
        ),
      ),
    );
  }
}
