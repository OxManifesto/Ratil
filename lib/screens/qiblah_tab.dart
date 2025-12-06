import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

import '../constants/localized_strings.dart';
import '../widgets/compass_background.dart';

class QiblahTab extends StatefulWidget {
  const QiblahTab({super.key, required this.strings});

  final AppStrings strings;

  @override
  State<QiblahTab> createState() => _QiblahTabState();
}

class _QiblahTabState extends State<QiblahTab> {
  StreamSubscription<CompassEvent>? _compassSubscription;
  double? _heading;
  double? _qiblahBearing;
  double? _distanceKm;
  Position? _position;
  bool _isLoading = true;
  bool _serviceDisabled = false;
  bool _permissionDeniedForever = false;
  bool _compassAvailable = true;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    setState(() {
      _isLoading = true;
      _statusMessage = null;
      _serviceDisabled = false;
      _permissionDeniedForever = false;
    });

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      setState(() {
        _serviceDisabled = true;
        _isLoading = false;
        _statusMessage =
            'Enable location services to calculate the Qiblah direction.';
      });
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      setState(() {
        _permissionDeniedForever = true;
        _isLoading = false;
        _statusMessage =
            'Location permission is permanently denied. Please enable it from system settings.';
      });
      return;
    }
    if (permission == LocationPermission.denied) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _statusMessage =
            'Location permission is required to determine the Qiblah direction.';
      });
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      final bearing = _bearingToKaaba(position.latitude, position.longitude);
      final meters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        21.4225,
        39.8262,
      );
      _listenToCompass();
      if (!mounted) return;
      setState(() {
        _position = position;
        _qiblahBearing = bearing;
        _distanceKm = meters / 1000;
        _statusMessage = null;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _statusMessage = 'Unable to determine your location. Please try again.';
      });
    }
  }

  void _listenToCompass() {
    _compassSubscription?.cancel();
    final stream = FlutterCompass.events;
    if (stream == null) {
      if (!mounted) return;
      setState(() {
        _compassAvailable = false;
        _heading = null;
      });
      return;
    }
    if (mounted) {
      setState(() {
        _compassAvailable = true;
      });
    } else {
      _compassAvailable = true;
    }
    _compassSubscription = stream.listen((event) {
      final heading = event.heading;
      if (!mounted || heading == null) return;
      setState(() => _heading = heading);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_statusMessage != null) {
      return _buildStatusCard();
    }
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        _buildCompassCard(context),
        const SizedBox(height: 16),
        _buildDetailsCard(context),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: _initialize,
            icon: const Icon(Icons.refresh),
            label: Text(widget.strings.retryLabel),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.explore, color: Colors.tealAccent.shade200, size: 36),
              const SizedBox(height: 12),
              Text(
                widget.strings.qiblahLabel,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _statusMessage ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: _initialize,
                    icon: const Icon(Icons.refresh),
                    label: Text(widget.strings.retryLabel),
                  ),
                  if (_permissionDeniedForever)
                    OutlinedButton.icon(
                      onPressed: Geolocator.openAppSettings,
                      icon: const Icon(Icons.settings),
                      label: const Text('Open settings'),
                    ),
                  if (_serviceDisabled)
                    OutlinedButton.icon(
                      onPressed: Geolocator.openLocationSettings,
                      icon: const Icon(Icons.location_on),
                      label: const Text('Enable location'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompassCard(BuildContext context) {
    final heading = _heading;
    final qiblah = _qiblahBearing;
    final headingDisplay = heading == null
        ? 'Calibrating...'
        : '${_normalizeDegrees(heading).toStringAsFixed(1)}°';
    final qiblahDisplay = qiblah == null
        ? '--'
        : '${qiblah.toStringAsFixed(1)}°';
    final difference = (heading != null && qiblah != null)
        ? _normalizeDegrees(qiblah - heading)
        : null;

    final northAngle = _degToRad(-(heading ?? 0));
    final qiblahAngle = (heading != null && qiblah != null)
        ? _degToRad(_normalizeDegrees(qiblah - heading))
        : _degToRad(qiblah ?? 0);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.explore, color: Colors.tealAccent.shade200),
              const SizedBox(width: 8),
              Text(
                widget.strings.qiblahLabel,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 230,
            width: 230,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CompassBackground(),
                Transform.rotate(
                  angle: northAngle,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Icon(
                      Icons.navigation,
                      size: 42,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: qiblahAngle,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: const Icon(
                      Icons.navigation,
                      size: 66,
                      color: Colors.tealAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildInfoChip('Heading', headingDisplay),
              _buildInfoChip('Qiblah', qiblahDisplay),
              _buildInfoChip('Guidance', _turnText(difference)),
            ],
          ),
          if (!_compassAvailable)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                'Compass sensor unavailable on this device.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    final lat = _position?.latitude;
    final lon = _position?.longitude;
    final distance = _distanceKm;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Location snapshot',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _DetailRow(
            label: 'Latitude',
            value: lat != null ? lat.toStringAsFixed(4) : '--',
          ),
          _DetailRow(
            label: 'Longitude',
            value: lon != null ? lon.toStringAsFixed(4) : '--',
          ),
          _DetailRow(
            label: 'Distance to Makkah',
            value: distance != null
                ? '${distance.toStringAsFixed(1)} km'
                : '--',
          ),
          const SizedBox(height: 12),
          Text(
            'Stand still and rotate your device until the teal arrow points forward to face the Qiblah.',
            style: const TextStyle(color: Colors.white70, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  double _bearingToKaaba(double latitude, double longitude) {
    const kaabaLat = 21.4225;
    const kaabaLon = 39.8262;
    final latRad = _degToRad(latitude);
    final kaabaLatRad = _degToRad(kaabaLat);
    final diffLon = _degToRad(kaabaLon - longitude);
    final y = sin(diffLon) * cos(kaabaLatRad);
    final x =
        cos(latRad) * sin(kaabaLatRad) -
        sin(latRad) * cos(kaabaLatRad) * cos(diffLon);
    return (_radToDeg(atan2(y, x)) + 360) % 360;
  }

  double _degToRad(double degrees) => degrees * pi / 180;
  double _radToDeg(double radians) => radians * 180 / pi;

  double _normalizeDegrees(double degrees) {
    final normalized = degrees % 360;
    return normalized >= 0 ? normalized : normalized + 360;
  }

  String _turnText(double? difference) {
    if (difference == null) {
      return 'Calibrate your device';
    }
    if (difference <= 3) {
      return 'Aligned';
    }
    if (difference > 180) {
      return 'Turn left ${(360 - difference).toStringAsFixed(1)}°';
    }
    return 'Turn right ${difference.toStringAsFixed(1)}°';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white70)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}