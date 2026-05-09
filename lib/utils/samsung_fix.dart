import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ratil/theme/theme_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/localized_strings.dart';

class SamsungFix {
  static const MethodChannel _channel = MethodChannel('com.krd.ratil/device');
  static const String _prefKey = 'samsung_fix_shown';

  static Future<void> checkAndFix(
    BuildContext context,
    AppStrings strings,
  ) async {
    if (kIsWeb || !Platform.isAndroid) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_prefKey) == true) return;

      final String? manufacturer = await _channel.invokeMethod(
        'getManufacturer',
      );
      if (manufacturer != null &&
          manufacturer.toLowerCase().contains('samsung')) {
        if (context.mounted) {
          _showSamsungDialog(context, prefs, strings);
        }
      }
    } catch (e) {
      debugPrint("Samsung check failed: $e");
    }
  }

  static void _showSamsungDialog(
    BuildContext context,
    SharedPreferences prefs,
    AppStrings strings,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final palette = ThemePalette.of(context);
        return AlertDialog(
          backgroundColor: palette.cardColor,
          title: Text(
            strings.samsungAlertTitle,
            style: TextStyle(
              color: palette.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            strings.samsungAlertContent,
            style: TextStyle(color: palette.textColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                prefs.setBool(_prefKey, true);
                Navigator.of(context).pop();
              },
              child: Text(
                strings.laterButton,
                style: TextStyle(color: palette.mutedTextColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: palette.accent,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _channel.invokeMethod('openBatterySettings');
                prefs.setBool(_prefKey, true);
                Navigator.of(context).pop();
              },
              child: Text(strings.fixNowButton),
            ),
          ],
        );
      },
    );
  }
}
