import 'package:flutter/material.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double iconSize = screenWidth * 0.065; // Responsive icon size
    final double fontSize = screenWidth * 0.028; // Responsive font size

    return Container(
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: AppColors.scaffoldBg(context),
        type: BottomNavigationBarType.fixed, // Keeps all items visible
        selectedItemColor: AppColors.primaryPink,
        unselectedItemColor: AppColors.textSecondary(context),
        selectedLabelStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0, // Handled by Container's boxShadow
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: iconSize),
            activeIcon: Icon(Icons.home, size: iconSize),
            label: context.tr('nav_home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: iconSize),
            label: context.tr('nav_explore'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined, size: iconSize),
            activeIcon: Icon(Icons.event_note, size: iconSize),
            label: context.tr('nav_bookings'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, size: iconSize),
            activeIcon: Icon(Icons.favorite, size: iconSize),
            label: context.tr('nav_favorites'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: iconSize),
            activeIcon: Icon(Icons.person, size: iconSize),
            label: context.tr('nav_profile'),
          ),
        ],
      ),
    );
  }
}
