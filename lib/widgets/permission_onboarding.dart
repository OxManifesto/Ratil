import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import '../theme/theme_palette.dart';
import '../constants/localized_strings.dart';

import '../services/security_service.dart';

class PermissionOnboarding extends StatefulWidget {
  const PermissionOnboarding({
    super.key,
    required this.palette,
    required this.strings,
    required this.onDone,
  });

  final ThemePalette palette;
  final AppStrings strings;
  final VoidCallback onDone;

  @override
  State<PermissionOnboarding> createState() => _PermissionOnboardingState();
}

class _PermissionOnboardingState extends State<PermissionOnboarding> {
  int _step = 0;
  bool _loading = false;

  Future<void> _handleContinue() async {
    setState(() => _loading = true);

    try {
      if (_step == 0) {
        // Location Permission
        var permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (mounted) {
          setState(() {
            _step = 1;
            _loading = false;
          });
        }
      } else if (_step == 1) {
        // Notification Permission
        final plugin = FlutterLocalNotificationsPlugin();

        if (Theme.of(context).platform == TargetPlatform.android) {
          final android = plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
          await android?.requestNotificationsPermission();
          await android?.requestExactAlarmsPermission();
        } else if (Theme.of(context).platform == TargetPlatform.iOS) {
          await plugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true);
        }

        // Complete
        await SecurityService.instance.writeSecure('is_first_run', 'false');
        if (mounted) {
          widget.onDone();
        }
      }
    } catch (e) {
      SecurityService.instance.log(
        'Error in onboarding: $e',
        level: Level.error,
      );
      if (mounted) {
        setState(() => _loading = false);
        // On error, proceed anyway so user isn't stuck
        await SecurityService.instance.writeSecure('is_first_run', 'false');
        widget.onDone();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 0 = Location, 1 = Notification
    final isLocation = _step == 0;

    final title = isLocation
        ? widget.strings.locationAccessTitle
        : widget.strings.notificationAccessTitle;
    final desc = isLocation
        ? widget.strings.locationAccessDesc
        : widget.strings.notificationAccessDesc;
    final icon = isLocation ? Icons.location_on : Icons.notifications_active;

    return Scaffold(
      backgroundColor: widget.palette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: widget.palette.heroHighlight,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: widget.palette.accent),
              ),
              const SizedBox(height: 32),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.palette.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.palette.mutedTextColor,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: _loading ? null : _handleContinue,
                  style: FilledButton.styleFrom(
                    backgroundColor: widget.palette.accent,
                    foregroundColor: widget.palette.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _loading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: widget.palette.background,
                          ),
                        )
                      : Text(
                          widget.strings.continueLabel,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
