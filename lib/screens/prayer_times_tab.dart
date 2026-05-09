import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_language.dart';
import '../constants/localized_strings.dart';
import '../providers/prayer_times_controller.dart';
import '../theme/theme_palette.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const double _kRadius = 20.0;

// ---------------------------------------------------------------------------
// PrayerTimesTab — public widget
// ---------------------------------------------------------------------------

class PrayerTimesTab extends StatefulWidget {
  const PrayerTimesTab({
    super.key,
    required this.strings,
    required this.palette,
    required this.language,
    required this.presetLocation,
    required this.prayerSound,
    required this.respectSilentMode,
  });

  final AppStrings strings;
  final ThemePalette palette;
  final AppLanguage language;
  final dynamic presetLocation;
  final dynamic prayerSound;
  final bool respectSilentMode;

  @override
  State<PrayerTimesTab> createState() => _PrayerTimesTabState();
}

class _PrayerTimesTabState extends State<PrayerTimesTab>
    with AutomaticKeepAliveClientMixin {
  bool _notificationsEnabled = false;
  bool _scheduling = false;
  bool _permissionMissing = false;
  final Set<String> _enabledPrayers = {
    'Fajr',
    'Sunrise',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<PrayerTimesController>().initialize();
    });
  }

  @override
  bool get wantKeepAlive => true;

  // -------------------------------------------------------------------------
  // Notification helpers
  // -------------------------------------------------------------------------

  Future<void> _toggleNotifications(bool enabled) async {
    if (enabled) {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        final isIgnoring = await Permission.ignoreBatteryOptimizations.isGranted;
        if (!isIgnoring) {
          _showSnack("Please select 'Unrestricted' battery usage to ensure alarms fire exactly on time.");
          try {
            await const MethodChannel('com.krd.ratil/device')
                .invokeMethod('openBatterySettings');
          } catch (_) {}
        }
      }
      await _scheduleNotifications();
    } else {
      if (!kIsWeb) {
        final plugin = FlutterLocalNotificationsPlugin();
        for (final id in [120, 121, 122, 123, 124, 125]) {
          await plugin.cancel(id);
        }
      }
      if (!mounted) return;
      setState(() => _notificationsEnabled = false);
    }
  }

  Future<void> _scheduleNotifications() async {
    if (kIsWeb) {
      _showSnack(widget.strings.notificationUnavailable);
      return;
    }
    setState(() {
      _scheduling = true;
      _permissionMissing = false;
    });

    final plugin = FlutterLocalNotificationsPlugin();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await plugin.initialize(settings);

    final androidPlugin = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final granted =
        await androidPlugin?.requestNotificationsPermission() ?? false;
    final alarmGranted =
        await androidPlugin?.requestExactAlarmsPermission() ?? false;

    if (!mounted) return;
    if (!granted || !alarmGranted) {
      setState(() {
        _permissionMissing = true;
        _notificationsEnabled = false;
        _scheduling = false;
      });
      _showSnack(widget.strings.permissionRequest);
      return;
    }

    if (!mounted) return;
    setState(() {
      _notificationsEnabled = true;
      _scheduling = false;
    });
    _showSnack(widget.strings.alertsScheduled);
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.surfaceCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<PrayerTimesController>(
      builder: (context, ctrl, _) {
        return switch (ctrl.loadState) {
          PrayerLoadState.idle || PrayerLoadState.loading => _buildLoading(),
          PrayerLoadState.loaded => _buildLoaded(context, ctrl),
          PrayerLoadState.serviceDisabled ||
          PrayerLoadState.permissionDenied ||
          PrayerLoadState.permissionDeniedForever => _buildPermissionCard(
            context,
            ctrl,
          ),
          PrayerLoadState.locationNotFound ||
          PrayerLoadState.error => _buildErrorCard(context, ctrl),
        };
      },
    );
  }

  // ---- Loading ----

  Widget _buildLoading() {
    final palette = widget.palette;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: palette.accent,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.strings.loadingLabel,
            style: TextStyle(color: palette.mutedTextColor, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ---- Permission card ----

  Widget _buildPermissionCard(
    BuildContext context,
    PrayerTimesController ctrl,
  ) {
    final palette = widget.palette;
    final isForever = ctrl.loadState == PrayerLoadState.permissionDeniedForever;
    final isService = ctrl.loadState == PrayerLoadState.serviceDisabled;

    final String message;
    if (isService) {
      message = widget.strings.qiblahServiceDisabledMessage;
    } else if (isForever) {
      message = widget.strings.qiblahPermissionForeverMessage;
    } else {
      message = widget.strings.qiblahPermissionDeniedMessage;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: palette.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: palette.cardBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: palette.accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_searching_rounded,
                  size: 40,
                  color: palette.accent,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.strings.prayerTimesLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: palette.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: palette.mutedTextColor, height: 1.45),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: ctrl.refresh,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(widget.strings.retryLabel),
                    style: FilledButton.styleFrom(
                      backgroundColor: palette.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  if (isForever)
                    OutlinedButton.icon(
                      onPressed: Geolocator.openAppSettings,
                      icon: const Icon(Icons.settings_rounded, size: 18),
                      label: Text(widget.strings.openSettingsLabel),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: palette.accent,
                        side: BorderSide(color: palette.accent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  if (isService)
                    OutlinedButton.icon(
                      onPressed: Geolocator.openLocationSettings,
                      icon: const Icon(Icons.location_on_rounded, size: 18),
                      label: Text(widget.strings.enableLocationLabel),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: palette.accent,
                        side: BorderSide(color: palette.accent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Error card ----

  Widget _buildErrorCard(BuildContext context, PrayerTimesController ctrl) {
    final palette = widget.palette;
    final isNotFound = ctrl.loadState == PrayerLoadState.locationNotFound;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: palette.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: palette.cardBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isNotFound
                    ? Icons.location_off_rounded
                    : Icons.error_outline_rounded,
                color: isNotFound ? palette.accent : AppColors.accentError,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                isNotFound
                    ? 'Location not found in offline database. Try refreshing.'
                    : (ctrl.errorMessage ?? widget.strings.loadError),
                textAlign: TextAlign.center,
                style: TextStyle(color: palette.mutedTextColor),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: ctrl.refresh,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(widget.strings.retryLabel),
                style: FilledButton.styleFrom(
                  backgroundColor: palette.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Main loaded layout ----

  Widget _buildLoaded(BuildContext context, PrayerTimesController ctrl) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildLocationBar(context, ctrl),
        const SizedBox(height: 14),
        _buildHeroCountdownCard(context, ctrl),
        const SizedBox(height: 14),
        _buildNotificationRow(context),
        const SizedBox(height: 14),
        ...ctrl.orderedPrayers.map((p) => _buildPrayerCard(context, ctrl, p)),
      ],
    );
  }

  // ---- Location info bar ----

  Widget _buildLocationBar(BuildContext context, PrayerTimesController ctrl) {
    final palette = widget.palette;
    final loc = ctrl.location!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(_kRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _InfoPill(
                  icon: Icons.place_rounded,
                  label: '${loc.name}, ${loc.countryCode}',
                  palette: palette,
                ),
                _InfoPill(
                  icon: Icons.my_location_rounded,
                  label:
                      '${loc.latitude.toStringAsFixed(3)}, '
                      '${loc.longitude.toStringAsFixed(3)}',
                  palette: palette,
                ),
                _InfoPill(
                  icon: Icons.calendar_today_rounded,
                  label: _formatDate(DateTime.now()),
                  palette: palette,
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => ctrl.refresh(forceLocation: true),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ctrl.isSyncingLocation
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: palette.mutedTextColor,
                        ),
                      )
                    : Icon(
                        Icons.refresh_rounded,
                        size: 18,
                        color: palette.mutedTextColor,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- Hero countdown card ----

  Widget _buildHeroCountdownCard(
    BuildContext context,
    PrayerTimesController ctrl,
  ) {
    final palette = widget.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final next = ctrl.nextPrayer;
    final nextName = next?.label ?? '--';
    final nextTimeStr = next != null ? _formatTime(next.time) : '--:--';
    final countdownStr = _formatCountdown(ctrl.countdown);

    // Arc fraction: elapsed / interval between previous and next prayer
    double fraction = 0.0;
    if (next != null && ctrl.countdown != null) {
      final ordered = ctrl.orderedPrayers;
      final nextIdx = ordered.indexWhere((p) => p.label == next.label);
      
      DateTime? prevTime;
      if (nextIdx > 0) {
        prevTime = ordered[nextIdx - 1].time;
      } else if (nextIdx == 0) {
        // Next is Fajr. Are we before today's Fajr, or after today's Isha?
        if (DateTime.now().isBefore(ordered.first.time)) {
          // Before today's Fajr -> Previous was yesterday's Isha
          prevTime = ctrl.yesterdayIshaTime;
        } else {
          // After today's Isha -> Previous was today's Isha
          prevTime = ordered.last.time;
        }
      }

      if (prevTime != null) {
        // RATIL-CORE-004: Guard against missing or NaN times from the DB at extreme latitudes
        try {
          final intervalSecs = next.time.difference(prevTime).inSeconds;
          if (intervalSecs > 0) {
            final elapsedSecs = intervalSecs - ctrl.countdown!.inSeconds;
            fraction = (elapsedSecs / intervalSecs).clamp(0.0, 1.0);
          }
        } catch (_) {
          // Gracefully degrade the arc if calculation fails
          fraction = 0.0;
        }
      }
    }

    final accentColor = palette.accent;
    final cardGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A2B20), Color(0xFF0D1B14)],
          )
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accentColor.withValues(alpha: 0.08),
              accentColor.withValues(alpha: 0.02),
            ],
          );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row
          Row(
            children: [
              Icon(
                Icons.access_time_filled_rounded,
                color: accentColor,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                widget.strings.nextPrayerLabel,
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(DateTime.now()),
                style: TextStyle(color: palette.mutedTextColor, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Arc + centre info
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.45 > 160
                ? 160
                : MediaQuery.of(context).size.width * 0.45,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(160, 160),
                  painter: _ArcPainter(
                    fraction: fraction,
                    accentColor: accentColor,
                    trackColor: palette.cardBorder.withValues(alpha: 0.4),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      nextName,
                      style: TextStyle(
                        color: palette.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      nextTimeStr,
                      style: TextStyle(
                        color: palette.mutedTextColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        countdownStr,
                        textScaler: TextScaler.linear(
                          MediaQuery.textScalerOf(
                            context,
                          ).scale(1.0).clamp(1.0, 1.3),
                        ),
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'until ${nextName == '--' ? widget.strings.nextPrayerLabel : nextName}',
            style: TextStyle(color: palette.mutedTextColor, fontSize: 11.5),
          ),
        ],
      ),
    );
  }

  // ---- Notification master toggle ----

  Widget _buildNotificationRow(BuildContext context) {
    final palette = widget.palette;
    final subtitle = kIsWeb
        ? 'Notifications unavailable on web.'
        : _notificationsEnabled
        ? '${widget.strings.alertsScheduled} (${_enabledPrayers.length} prayers)'
        : _permissionMissing
        ? widget.strings.permissionRequest
        : widget.strings.prayerNotificationsLabel;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(_kRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: palette.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _notificationsEnabled
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_outlined,
              color: palette.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.strings.prayerNotificationsLabel,
                  style: TextStyle(
                    color: palette.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: palette.mutedTextColor,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          if (_scheduling)
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: palette.accent,
              ),
            )
          else
            Switch.adaptive(
              value: _notificationsEnabled,
              onChanged: kIsWeb ? null : _toggleNotifications,
              thumbColor: WidgetStatePropertyAll(palette.accent),
              trackColor: WidgetStatePropertyAll(
                palette.accent.withValues(alpha: 0.3),
              ),
            ),
        ],
      ),
    );
  }

  // ---- Individual prayer card ----

  Widget _buildPrayerCard(
    BuildContext context,
    PrayerTimesController ctrl,
    ({String label, DateTime time}) prayer,
  ) {
    final palette = widget.palette;
    final isNext = ctrl.nextPrayer?.label == prayer.label;
    final enabled = _enabledPrayers.contains(prayer.label);
    final isPast = prayer.time.isBefore(DateTime.now()) && !isNext;
    final accentColor = palette.accent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isNext
              ? accentColor.withValues(alpha: 0.12)
              : palette.cardColor,
          borderRadius: BorderRadius.circular(_kRadius),
          border: Border.all(
            color: isNext
                ? accentColor.withValues(alpha: 0.5)
                : palette.cardBorder,
            width: isNext ? 1.5 : 1,
          ),
          boxShadow: isNext
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Icon bubble
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isNext
                    ? accentColor.withValues(alpha: 0.2)
                    : palette.heroHighlight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _prayerIcon(prayer.label),
                color: isNext
                    ? accentColor
                    : isPast
                    ? palette.mutedTextColor
                    : palette.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Name + inline countdown
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _localizedLabel(prayer.label),
                    style: TextStyle(
                      color: isPast && !isNext
                          ? palette.mutedTextColor
                          : palette.textColor,
                      fontSize: 15,
                      fontWeight: isNext ? FontWeight.w800 : FontWeight.w600,
                    ),
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: true,
                      applyHeightToLastDescent: true,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                  if (isNext && ctrl.countdown != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '− ${_formatCountdown(ctrl.countdown)}',
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Time
            Text(
              _formatTime(prayer.time),
              style: TextStyle(
                color: isNext
                    ? accentColor
                    : isPast
                    ? palette.mutedTextColor
                    : palette.textColor,
                fontSize: isNext ? 17 : 15,
                fontWeight: isNext ? FontWeight.w800 : FontWeight.w600,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 4),

            // Per-prayer notification switch (compact)
            Transform.scale(
              scale: 0.75,
              child: Switch.adaptive(
                value: enabled,
                onChanged: kIsWeb
                    ? null
                    : (v) => setState(() {
                        if (v) {
                          _enabledPrayers.add(prayer.label);
                        } else {
                          _enabledPrayers.remove(prayer.label);
                        }
                      }),
                thumbColor: WidgetStatePropertyAll(
                  isNext ? accentColor : palette.accent,
                ),
                trackColor: WidgetStatePropertyAll(
                  palette.accent.withValues(alpha: 0.25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  String _localizedLabel(String label) => switch (label) {
    'Fajr' => widget.strings.fajrLabel,
    'Sunrise' => widget.strings.sunriseLabel,
    'Dhuhr' => widget.strings.dhuhrLabel,
    'Asr' => widget.strings.asrLabel,
    'Maghrib' => widget.strings.maghribLabel,
    'Isha' => widget.strings.ishaLabel,
    _ => label,
  };

  IconData _prayerIcon(String label) => switch (label) {
    'Fajr' => Icons.night_shelter_rounded,
    'Sunrise' => Icons.wb_sunny_rounded,
    'Dhuhr' => Icons.brightness_high_rounded,
    'Asr' => Icons.wb_twilight_rounded,
    'Maghrib' => Icons.nightlight_outlined,
    'Isha' => Icons.dark_mode_rounded,
    _ => Icons.access_time,
  };

  String _formatTime(DateTime time) {
    final local = time.toLocal();
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final suffix = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }

  String _formatCountdown(Duration? d) {
    if (d == null || d.isNegative) {
      return '--'; // CHAOS-004: prevents phantom negative displays
    }
    final h = d.inHours;
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  String _formatDate(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[(date.weekday - 1) % 7]}, ${date.day} ${months[date.month - 1]}';
  }
}

// ---------------------------------------------------------------------------
// Arc painter
// ---------------------------------------------------------------------------

class _ArcPainter extends CustomPainter {
  const _ArcPainter({
    required this.fraction,
    required this.accentColor,
    required this.trackColor,
  });

  final double fraction;
  final Color accentColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 8;
    const strokeWidth = 7.0;
    const startAngle = -pi / 2; // 12 o'clock

    // Track ring
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2 * pi,
      false,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Progress arc
    if (fraction > 0.005) {
      final shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + 2 * pi * fraction,
        colors: [accentColor.withValues(alpha: 0.6), accentColor],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        2 * pi * fraction,
        false,
        Paint()
          ..shader = shader
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );

      // Glowing dot at tip
      final tipAngle = startAngle + 2 * pi * fraction;
      final tipX = center.dx + radius * cos(tipAngle);
      final tipY = center.dy + radius * sin(tipAngle);
      canvas.drawCircle(
        Offset(tipX, tipY),
        strokeWidth / 1.6,
        Paint()..color = accentColor,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) =>
      oldDelegate.fraction != fraction ||
      oldDelegate.accentColor != accentColor;
}

// ---------------------------------------------------------------------------
// Info Pill widget
// ---------------------------------------------------------------------------

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
    required this.palette,
  });

  final IconData icon;
  final String label;
  final ThemePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: palette.heroHighlight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: palette.mutedTextColor),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: palette.textColor,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
