import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:root_checker_plus/root_checker_plus.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class SecurityService {
  SecurityService._();
  static final SecurityService instance = SecurityService._();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  static const String _migrationCompleteKey = 'security_migration_v1_complete';

  /// Initializes the security service, checks for root, and handles data migration.
  Future<void> initialize() async {
    await _checkRootStatus();
    await _migrateIfNecessary();
  }

  Future<void> _checkRootStatus() async {
    if (kIsWeb) return; // Skip root check on web
    try {
      if (Platform.isAndroid) {
        bool isRooted = await RootCheckerPlus.isRootChecker() ?? false;
        if (isRooted) {
          _logger.w(
            'SECURITY WARNING: Device is rooted. User data may be at risk.',
          );
        }
      } else if (Platform.isIOS) {
        bool isJailbroken = await RootCheckerPlus.isJailbreak() ?? false;
        if (isJailbroken) {
          _logger.w(
            'SECURITY WARNING: Device is jailbroken. User data may be at risk.',
          );
        }
      }
    } catch (e) {
      _logger.e('Error checking root status: $e');
    }
  }

  Future<void> _migrateIfNecessary() async {
    final prefs = await SharedPreferences.getInstance();
    final isMigrated = prefs.getBool(_migrationCompleteKey) ?? false;

    if (!isMigrated) {
      _logger.i('Starting security migration to FlutterSecureStorage...');

      // List of keys to migrate
      final keysToMigrate = [
        'app_theme_mode',
        'pref_language',
        'pref_preset_location',
        'pref_read_translation',
        'pref_read_text_scale',
        'pref_prayer_sound',
        'pref_prayer_sound_respect_silent',
        'is_first_run',
      ];

      for (String key in keysToMigrate) {
        final value = prefs.get(key);
        if (value != null) {
          await _storage.write(key: key, value: value.toString());
          _logger.d('Migrated key: $key');
        }
      }

      await prefs.setBool(_migrationCompleteKey, true);
      _logger.i('Security migration completed successfully.');
    }
  }

  /// Writes a sensitive value to secure storage.
  Future<void> writeSecure(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Reads a sensitive value from secure storage.
  Future<String?> readSecure(String key) async {
    return await _storage.read(key: key);
  }

  /// Logs a secure message (only in debug mode).
  void log(String message, {Level level = Level.info}) {
    if (kDebugMode) {
      _logger.log(level, message);
    }
  }
}
