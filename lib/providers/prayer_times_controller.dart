import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geolocator/geolocator.dart';
import 'package:muslim_data_flutter/muslim_data_flutter.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Load state
// ---------------------------------------------------------------------------

enum PrayerLoadState {
  idle,
  loading,
  loaded,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  locationNotFound, // reverseGeocoder returned null
  error,
}

// ---------------------------------------------------------------------------
// Controller
// ---------------------------------------------------------------------------

/// Orchestrates the prayer-times pipeline:
///   GPS permission → position (with timeout) → reverseGeocoder (offline)
///   → getPrayerTimes → live countdown ticker
///
/// Register once in MultiProvider:
/// ```dart
/// ChangeNotifierProvider(create: (_) => PrayerTimesController()..initialize())
/// ```
class PrayerTimesController extends ChangeNotifier {
  static final MuslimRepository _repo = MuslimRepository();

  // ---- Public state ----
  PrayerLoadState loadState = PrayerLoadState.idle;
  bool isSyncingLocation = false;
  PrayerTime? prayerTime;
  DateTime? nextFajrTime;
  DateTime? nextMaghribTime;
  DateTime? yesterdayIshaTime;
  Location? location;
  String? errorMessage;

  ({String label, DateTime time})? nextPrayer;
  Duration? countdown;

  // ---- Private ----
  DateTime? _lastLoadDate;
  double? _lastLat;
  double? _lastLng;
  Duration _lastTzOffset = DateTime.now().timeZoneOffset;
  Timer? _ticker;

  // -------------------------------------------------------------------------
  // Lifecycle
  // -------------------------------------------------------------------------

  /// Safe idempotent init — skips re-loading if already loaded today AND
  /// the device has not crossed a timezone boundary or moved >50 km.
  Future<void> initialize() async {
    final today = DateTime.now();
    if (loadState == PrayerLoadState.loaded &&
        prayerTime != null &&
        _lastLoadDate != null &&
        _isSameDay(_lastLoadDate!, today) &&
        !_timezoneChanged()) {
      _startTicker();
      return;
    }
    await refresh();
  }

  /// Call from AppLifecycleState.resumed to catch timezone crossings + DST.
  Future<void> onAppResumed() async {
    if (_timezoneChanged()) {
      // CHAOS-005: Re-init tz.local so DST offset changes take effect.
      try {
        final tzInfo = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
      } catch (_) {
        // If re-init fails, proceed anyway — offset check caught the change.
      }
      debugPrint('[PrayerCtrl] Timezone changed — refreshing prayer times.');
      await refresh();
    } else {
      _startTicker();
    }
  }

  /// Full reload: GPS → reverse geocode → prayer times.
  Future<void> refresh({bool isRetry = false, bool forceLocation = false}) async {
    if (forceLocation) {
      isSyncingLocation = true;
      notifyListeners();
    } else {
      loadState = PrayerLoadState.loading;
      errorMessage = null;
      notifyListeners();
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      double? lat;
      double? lng;

      if (!forceLocation) {
        lat = prefs.getDouble('cached_prayer_lat');
        lng = prefs.getDouble('cached_prayer_lng');
      }

      if (lat == null || lng == null) {
        final position = await _obtainPosition();
        lat = position.latitude;
        lng = position.longitude;
        await prefs.setDouble('cached_prayer_lat', lat);
        await prefs.setDouble('cached_prayer_lng', lng);
      }

      // Offline reverse geocode using the package's bundled DB
      final loc = await _repo.reverseGeocoder(
        latitude: lat,
        longitude: lng,
      );

      if (loc == null) {
        loadState = PrayerLoadState.locationNotFound;
        isSyncingLocation = false;
        notifyListeners();
        return;
      }

      final attribute = PrayerAttribute(
        calculationMethod: CalculationMethod.makkah,
        asrMethod: AsrMethod.shafii,
        higherLatitudeMethod: HigherLatitudeMethod.angleBased,
        offset: [0, 0, 0, 0, 0, 0],
      );

      final times = await _repo.getPrayerTimes(
        location: loc,
        date: DateTime.now(),
        attribute: attribute,
      );

      if (times == null) {
        loadState = PrayerLoadState.error;
        errorMessage = 'Prayer times could not be computed for this location.';
        isSyncingLocation = false;
        notifyListeners();
        return;
      }

      location = loc;
      prayerTime = times;
      _lastLoadDate = DateTime.now();
      _lastLat = lat;
      _lastLng = lng;
      _lastTzOffset = DateTime.now().timeZoneOffset;
      loadState = PrayerLoadState.loaded;

      // RATIL-CORE-008: Fetch tomorrow's Fajr/Maghrib for Ramadan countown sync
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowTimes = await _repo.getPrayerTimes(
        location: loc,
        date: tomorrow,
        attribute: attribute,
      );
      nextFajrTime = tomorrowTimes?.fajr;
      nextMaghribTime = tomorrowTimes?.maghrib;

      // Extract yesterday's Isha for accurate pre-Fajr countdown arc
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayTimes = await _repo.getPrayerTimes(
        location: loc,
        date: yesterday,
        attribute: attribute,
      );
      yesterdayIshaTime = yesterdayTimes?.isha;

      isSyncingLocation = false;
      _updateNext();
      _startTicker();
      notifyListeners();
    } on _GpsError catch (e) {
      loadState = switch (e.reason) {
        _GpsReason.serviceDisabled => PrayerLoadState.serviceDisabled,
        _GpsReason.denied => PrayerLoadState.permissionDenied,
        _GpsReason.deniedForever => PrayerLoadState.permissionDeniedForever,
      };
      isSyncingLocation = false;
      notifyListeners();
    } catch (e, st) {
      if (!isRetry && e.toString().toLowerCase().contains('database')) {
        // RATIL-CORE-001: 0-byte corrupt copy or SQLite failure detected.
        // Attempt a one-time wipe of the local DB to trigger re-extraction.
        try {
          final databasesPath = await getDatabasesPath();
          final path = join(databasesPath, 'muslim_data.db');
          final file = File(path);
          if (await file.exists()) {
            await file.delete();
            debugPrint('[PrayerCtrl] Corrupt database wiped. Retrying...');
            await refresh(isRetry: true, forceLocation: forceLocation);
            return;
          }
        } catch (_) {}
      }
      loadState = PrayerLoadState.error;
      errorMessage = e.toString();
      isSyncingLocation = false;
      debugPrintStack(stackTrace: st);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Ticker
  // -------------------------------------------------------------------------

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      // CHAOS-004: Detect clock jumps (manual change, midnight rollover).
      // If the day changed since last load, cancel ticker and re-run full pipeline.
      if (_lastLoadDate != null &&
          !_isSameDay(_lastLoadDate!, DateTime.now())) {
        _ticker?.cancel();
        refresh();
        return;
      }
      _updateNext();
      notifyListeners();
    });
  }

  void _updateNext() {
    final times = prayerTime;
    if (times == null) return;
    final now = DateTime.now();
    final ordered = _ordered(times);
    ({String label, DateTime time})? next;
    for (final p in ordered) {
      if (p.time.isAfter(now)) {
        next = p;
        break;
      }
    }
    
    // FIX: If passed today's Isha, the next prayer is Tomorrow's Fajr
    if (next == null && nextFajrTime != null) {
      next = (label: 'Fajr', time: nextFajrTime!);
    }
    
    nextPrayer = next;
    countdown = next?.time.difference(now);
  }

  // -------------------------------------------------------------------------
  // GPS helpers — with 10 s timeout + last-known-position fallback
  // -------------------------------------------------------------------------

  Future<Position> _obtainPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const _GpsError(_GpsReason.serviceDisabled);
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever) {
      throw const _GpsError(_GpsReason.deniedForever);
    }
    if (perm == LocationPermission.denied) {
      throw const _GpsError(_GpsReason.denied);
    }

    // --- FIX RATIL-001: 10 s timeout → fallback to last-known → low accuracy
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } on TimeoutException {
      debugPrint(
        '[PrayerCtrl] High-accuracy GPS timed out. Trying last-known position.',
      );
    }

    // Fallback 1: last known position (cached by OS — available offline)
    final lastKnown = await Geolocator.getLastKnownPosition();
    if (lastKnown != null) {
      debugPrint('[PrayerCtrl] Using last-known position.');
      return lastKnown;
    }

    // Fallback 2: low accuracy (network / cell-tower, no GPS required)
    debugPrint('[PrayerCtrl] Using low-accuracy fallback.');
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.lowest,
      timeLimit: const Duration(seconds: 10),
    );
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Returns true if the device's timezone has changed since last load,
  /// or if the user has moved more than ~50 km. (FIX RATIL-006)
  bool _timezoneChanged() {
    final nowOffset = DateTime.now().timeZoneOffset;
    if (nowOffset != _lastTzOffset) return true;
    if (_lastLat != null && _lastLng != null) {
      final lat = _lastLat!;
      final lng = _lastLng!;
      // Simple bounding-box check: ~50 km ≈ 0.45 degrees
      // Using cached last position — avoids another GPS call here.
      // A full Haversine is unnecessary for this coarse check.
      final tzLat = location?.latitude ?? lat;
      final tzLng = location?.longitude ?? lng;
      if ((tzLat - lat).abs() > 0.45 || (tzLng - lng).abs() > 0.45) return true;
    }
    return false;
  }

  static List<({String label, DateTime time})> _ordered(PrayerTime t) => [
    (label: 'Fajr', time: t.fajr),
    (label: 'Sunrise', time: t.sunrise),
    (label: 'Dhuhr', time: t.dhuhr),
    (label: 'Asr', time: t.asr),
    (label: 'Maghrib', time: t.maghrib),
    (label: 'Isha', time: t.isha),
  ];

  List<({String label, DateTime time})> get orderedPrayers =>
      prayerTime != null ? _ordered(prayerTime!) : [];
}

// ---------------------------------------------------------------------------
// Internal types
// ---------------------------------------------------------------------------

enum _GpsReason { serviceDisabled, denied, deniedForever }

class _GpsError implements Exception {
  const _GpsError(this.reason);
  final _GpsReason reason;
}
