import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (kIsWeb) return Future.value(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble('cached_prayer_lat');
      final lng = prefs.getDouble('cached_prayer_lng');

      if (lat != null && lng != null) {
        tzdata.initializeTimeZones();
        String timeZoneName;
        try {
          final tzInfo = await FlutterTimezone.getLocalTimezone();
          timeZoneName = tzInfo.identifier;
        } catch (_) {
          timeZoneName = 'UTC';
        }
        try {
          tz.setLocalLocation(tz.getLocation(timeZoneName));
        } catch (_) {
          tz.setLocalLocation(tz.getLocation('UTC'));
        }

        final plugin = FlutterLocalNotificationsPlugin();
        await plugin.initialize(const InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'),
            iOS: DarwinInitializationSettings()));

        final repo = MuslimRepository();
        final loc = await repo.reverseGeocoder(latitude: lat, longitude: lng);
        if (loc != null) {
          final now = DateTime.now();
          final attribute = PrayerAttribute(
            calculationMethod: CalculationMethod.makkah,
            asrMethod: AsrMethod.shafii,
            higherLatitudeMethod: HigherLatitudeMethod.angleBased,
            offset: [0, 0, 0, 0, 0, 0],
          );
          
          final times = await repo.getPrayerTimes(location: loc, date: now, attribute: attribute);
          if (times != null) {
            final prayerMap = <String, DateTime>{
                'Fajr': times.fajr,
                'Sunrise': times.sunrise,
                'Dhuhr': times.dhuhr,
                'Asr': times.asr,
                'Maghrib': times.maghrib,
                'Isha': times.isha,
            };
            
            final ids = {'Fajr': 120, 'Sunrise': 121, 'Dhuhr': 122, 'Asr': 123, 'Maghrib': 124, 'Isha': 125};

            for (final entry in prayerMap.entries) {
              final prayerName = entry.key;
              final scheduled = entry.value;
              if (scheduled.isBefore(now)) continue;

              final tzTime = tz.TZDateTime.from(scheduled, tz.local);
              await plugin.zonedSchedule(
                ids[prayerName]!,
                'Prayer Time',
                '$prayerName Time',
                tzTime,
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                    'prayer_times_v2_default',
                    'Prayer times - Default',
                    channelDescription: 'Reminders for daily prayers',
                    importance: Importance.max,
                    priority: Priority.max,
                    category: AndroidNotificationCategory.alarm,
                    playSound: true,
                    audioAttributesUsage: AudioAttributesUsage.alarm,
                  ),
                ),
                androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.absoluteTime,
                payload: 'prayer:$prayerName',
              );
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Workmanager prayer background failed: $e");
    }
    return Future.value(true);
  });
}

class DailyResetService {
  static Future<void> initialize() async {
    if (kIsWeb) return;
    await Workmanager().initialize(
      callbackDispatcher,
    );
  }

  static Future<void> scheduleDailyReset() async {
    if (kIsWeb) return;
    await Workmanager().registerPeriodicTask(
      'daily_prayer_scheduler_task',
      'daily_prayer_scheduler',
      frequency: const Duration(hours: 12),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
  }
}
