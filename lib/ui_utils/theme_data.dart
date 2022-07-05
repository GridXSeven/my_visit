import 'package:flutter/foundation.dart';

class ThemeDataBrain extends ChangeNotifier {
  bool isDark = false;

  void changeTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
