import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  final _settingsBox = Hive.box('settingsBox');
  bool _isDarkMode = false;

  ThemeProvider() {
    // Muat preferensi tema saat inisialisasi
    _isDarkMode = _settingsBox.get('isDarkMode', defaultValue: false);
  }

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool isOn) {
    _isDarkMode = isOn;
    _settingsBox.put('isDarkMode', isOn);
    notifyListeners();
  }
}
