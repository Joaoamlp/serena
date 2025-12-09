import 'package:flutter/material.dart';

class FloatingButtonController extends ChangeNotifier {
  bool isEnabled = false;

  void toggle() {
    isEnabled = !isEnabled;
    notifyListeners();
  }

  void enable() {
    isEnabled = true;
    notifyListeners();
  }

  void disable() {
    isEnabled = false;
    notifyListeners();
  }
}
