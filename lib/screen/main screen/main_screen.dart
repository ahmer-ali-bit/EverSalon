import 'package:ever_salon/screen/main%20screen/favorites/my_favorites_screen.dart';
import 'package:ever_salon/screen/main%20screen/home/home_screen.dart';
import 'package:ever_salon/screen/main%20screen/my%20booking/my_booking_screen.dart';
import 'package:ever_salon/screen/main%20screen/profile/my_profile_screen.dart';
import 'package:ever_salon/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';

class MainScreen extends StatefulWidget {
  /// 0 Home, 1 Explore, 2 Bookings, 3 Favourites, 4 Profile
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    HomeScreen(),
    _ExplorePlaceholder(),
    MyBookingsScreen(),
    MyFavoritesScreen(),
    MyProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
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

class _ExplorePlaceholder extends StatelessWidget {
  const _ExplorePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(context.tr('explore_placeholder')));
  }
}
