import 'package:ever_salon/screen/auth/auth%20screens/login_screen.dart';
import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  int _currentPage = 0;
  final PageController pageController = PageController();

  int get currentPage => _currentPage;

  final int totalPages = 3;

  void updatePage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage(BuildContext context, String nextRoute) {
    if (_currentPage < totalPages - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.bounceIn,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }

  void skip(BuildContext context, String nextRoute) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}
