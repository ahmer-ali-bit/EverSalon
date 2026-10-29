import 'package:ever_salon/Admin%20Panel/providers/drawer/admin_drawer_provider.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/profile/profile_screen.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/services_management/admin_services_screen.dart';
import 'package:ever_salon/Admin%20Panel/screens/main%20screen/staff%20management/admin_staff_screen.dart';
import 'package:ever_salon/widgets/admin_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants/app_colors.dart';
import '../../../../widgets/admin_bottom_navbar.dart';
import 'dashboard/admin_dashboard_screen.dart';
import 'manage booking/manage_booking_screen.dart';

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminDrawerProvider(),
      child: const _AdminMainContent(),
    );
  }
}

class _AdminMainContent extends StatefulWidget {
  const _AdminMainContent();

  @override
  State<_AdminMainContent> createState() => _AdminMainContentState();
}

class _AdminMainContentState extends State<_AdminMainContent> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AdminDashboardScreen(), // 0
    const ManageBookingScreen(), // 1
    const AdminStaffScreen(), // 2
    const AdminServicesScreen(), // 3
    const AdminProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final drawerProvider = context.watch<AdminDrawerProvider>();

    double xOffset = drawerProvider.isOpen ? w * 0.65 : 0;
    double yOffset = drawerProvider.isOpen ? h * 0.1 : 0;
    double scaleFactor = drawerProvider.isOpen ? 0.8 : 1.0;
    double borderRadius = drawerProvider.isOpen ? w * 0.08 : 0.0;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: Stack(
        children: [
          // 1. DRAWER LAYER (Bottom layer - Direct Taps allowed)
          AdminFancyDrawer(onClose: drawerProvider.closeDrawer),

          // 2. MAIN APP SCREEN LAYER (Shifted right when drawer is open)
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuart,
            decoration: BoxDecoration(
              color: AppColors.scaffoldBg(context),
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: drawerProvider.isOpen
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 25,
                        offset: const Offset(-5, 10),
                      ),
                    ]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Stack(
                children: [
                  // Main Content
                  Scaffold(
                    body: IgnorePointer(
                      ignoring: drawerProvider.isOpen,
                      child: IndexedStack(
                        index: _currentIndex,
                        children: _screens,
                      ),
                    ),
                    bottomNavigationBar: AdminBottomNavbar(
                      currentIndex: _currentIndex,
                      onTap: _onTabTapped,
                    ),
                  ),

                  // TAP OVERLAY ONLY ON SHRUNK MAIN SCREEN (To close drawer on tapping main screen)
                  if (drawerProvider.isOpen)
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: drawerProvider.closeDrawer,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
