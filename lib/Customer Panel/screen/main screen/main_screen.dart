import 'package:ever_salon/Customer%20Panel/screen/main%20screen/favorites/my_favorites_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/home_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/home/salon_search_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/my%20booking/my_booking_screen.dart';
import 'package:ever_salon/Customer%20Panel/screen/main%20screen/profile/my_profile_screen.dart';
import 'package:ever_salon/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:ever_salon/constants/app_colors.dart';

class MainScreen extends StatefulWidget {
  /// 0 Home, 1 Explore, 2 Bookings, 3 Favourites, 4 Profile
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _screens = [
      HomeScreen(onSwitchToExplore: _switchToExploreTab),
      const SalonSearchScreen(showBackButton: false),
      MyBookingsScreen(),
      MyFavoritesScreen(),
      MyProfileScreen(),
    ];
  }

  void _switchToExploreTab() {
    setState(() {
      _currentIndex = 1;
    });
  }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(context),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
