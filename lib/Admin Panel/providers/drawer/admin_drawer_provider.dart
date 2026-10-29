import 'package:flutter/material.dart';

class AdminDrawerProvider extends ChangeNotifier {
  bool isOpen = false;

  void toggleDrawer() {
    isOpen = !isOpen;
    notifyListeners();
  }

  void closeDrawer() {
    if (isOpen) {
      isOpen = false;
      notifyListeners();
    }
  }

  void openDrawer() {
    if (!isOpen) {
      isOpen = true;
      notifyListeners();
    }
  }
}
