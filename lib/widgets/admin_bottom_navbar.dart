import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AdminBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: w * 0.015),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primaryPink,
            unselectedItemColor: AppColors.textGrey,
            selectedFontSize: w * 0.028,
            unselectedFontSize: w * 0.028,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined, size: w * 0.06),
                activeIcon: Icon(Icons.dashboard, size: w * 0.06),
                label: 'Dashboard', // Clean text - NO underscores
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined, size: w * 0.06),
                activeIcon: Icon(Icons.calendar_month, size: w * 0.06),
                label: 'Bookings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline, size: w * 0.06),
                activeIcon: Icon(Icons.people, size: w * 0.06),
                label: 'Staff',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.spa_outlined, size: w * 0.06),
                activeIcon: Icon(Icons.spa, size: w * 0.06),
                label: 'Services',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                  size: w * 0.06,
                ), // Profile Icon
                activeIcon: Icon(Icons.person, size: w * 0.06),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
