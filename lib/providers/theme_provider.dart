import 'package:flutter/material.dart';
import '../services/security_service.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _prefKey = 'app_theme_mode';
  ThemeMode _mode = ThemeMode.system;

  ThemeProvider() {
    _loadFromSecureStorage();
  }

  ThemeMode get mode => _mode;

  void setThemeMode(ThemeMode newMode) {
    if (_mode == newMode) return;
    _mode = newMode;
    _saveToSecureStorage();
    notifyListeners();
  }

  Future<void> _loadFromSecureStorage() async {
    final savedValue = await SecurityService.instance.readSecure(_prefKey);
    if (savedValue != null) {
      _mode = ThemeMode.values.firstWhere(
        (e) => e.name == savedValue,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  Future<void> _saveToSecureStorage() async {
    await SecurityService.instance.writeSecure(_prefKey, _mode.name);
  }
}
