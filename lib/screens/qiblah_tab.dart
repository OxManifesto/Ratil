import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

import '../constants/localized_strings.dart';
import '../constants/app_colors.dart';

// ---------------------------------------------------------------------------
// Main Screen Orchestrator
// ---------------------------------------------------------------------------

/// Orchestrates the Qiblah feature by handling offline GPS location fetching,
/// calculating the static bearing to the Kaaba, and delegating the high-frequency
/// sensor stream to its specialized descendant widget (`QiblahCompassDisplay`).
class QiblahTab extends StatefulWidget {
  const QiblahTab({super.key, required this.strings});
  
  final AppStrings strings;

  @override
  State<QiblahTab> createState() => _QiblahTabState();
}

class _QiblahTabState extends State<QiblahTab> {
  bool _isLoading = true;
  String? _errorMessage;
  bool _needsLocationSettings = false;
  
  double? _qiblahBearing;
  Position? _position;
  double? _distanceKm;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _needsLocationSettings = false;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'Enable location services to calculate Qiblah.';
          _needsLocationSettings = true;
          _isLoading = false;
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
          _errorMessage = 'Location permission is permanently denied. Please enable it in system settings.';
          _needsLocationSettings = true;
          _isLoading = false;
        });
        return;
      }
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'Location permission is required to determine Qiblah.';
          _isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      final bearing = _calculateBearingToKaaba(position.latitude, position.longitude);
      final distance = Geolocator.distanceBetween(
        position.latitude, position.longitude, 21.422487, 39.826206,
      );

      if (!mounted) return;
      setState(() {
        _position = position;
        _qiblahBearing = bearing;
        _distanceKm = distance / 1000;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      // Handles timeouts or edge-case GPS availability failures cleanly.
      setState(() {
        _errorMessage = 'Unable to determine your precise location. Please try again.';
        _isLoading = false;
      });
    }
  }

  /// Calculates the exact great-circle bearing to the Kaaba coordinates.
  double _calculateBearingToKaaba(double lat, double lon) {
    const double kaabaLat = 21.422487;
    const double kaabaLon = 39.826206;
    
    final double lat1 = _degToRad(lat);
    final double lat2 = _degToRad(kaabaLat);
    final double dLon = _degToRad(kaabaLon - lon);

    final double y = sin(dLon) * cos(lat2);
    final double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    
    final double bearingRadians = atan2(y, x);
    return (_radToDeg(bearingRadians) + 360) % 360;
  }

  double _degToRad(double degrees) => degrees * pi / 180.0;
  double _radToDeg(double radians) => radians * 180.0 / pi;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryBrand));
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.explore_off, size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              if (_needsLocationSettings)
                OutlinedButton.icon(
                  onPressed: Geolocator.openLocationSettings,
                  icon: const Icon(Icons.settings),
                  label: const Text('Location Settings'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppColors.textPrimary),
                ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _initializeLocation,
                icon: const Icon(Icons.refresh),
                label: Text(widget.strings.retryLabel),
                style: FilledButton.styleFrom(backgroundColor: AppColors.primaryBrand),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          children: [
            const Icon(Icons.explore, color: AppColors.primaryBrand),
            const SizedBox(width: 8),
            Text(
              widget.strings.qiblahLabel,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        // Pass strictly what is needed: the target bearing to Kaaba.
        QiblahCompassDisplay(targetBearing: _qiblahBearing!),
        const SizedBox(height: 48),
        _LocationDetailsCard(
          lat: _position!.latitude,
          lon: _position!.longitude,
          distanceKm: _distanceKm!,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Stream Container & Alignment Logic
// ---------------------------------------------------------------------------

/// The isolated sub-tree that rebuilds upon high-frequency sensor events.
/// Binds `FlutterCompass.events` to the visual `QiblahNeedle`.
class QiblahCompassDisplay extends StatefulWidget {
  const QiblahCompassDisplay({super.key, required this.targetBearing});
  
  final double targetBearing;

  @override
  State<QiblahCompassDisplay> createState() => _QiblahCompassDisplayState();
}

class _QiblahCompassDisplayState extends State<QiblahCompassDisplay> {
  // Tracks alignment entrance for exclusive one-time haptic triggering.
  bool _wasAligned = false;

  /// Returns the shortest angular distance bounded between -180 and 180 degrees.
  double _getShortestAngleDifference(double heading, double target) {
    double diff = (target - heading) % 360;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return diff;
  }

  @override
  Widget build(BuildContext context) {
    if (FlutterCompass.events == null) {
      return const CalibrationWarning(
        message: 'Your device does not have a compass sensor.',
      );
    }

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CalibrationWarning(message: 'Error reading sensor: ${snapshot.error}');
        }
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 320,
            child: Center(child: CircularProgressIndicator(color: AppColors.primaryBrand)),
          );
        }

        final event = snapshot.data;
        if (event == null || event.heading == null) {
          return const CalibrationWarning(
            message: 'Your device does not have a compass sensor.',
          );
        }

        // Display elegant prompt if magnetomoter accuracy drops below standard confidence levels.
        final bool needsCalibration = event.accuracy != null && event.accuracy! > 25;

        // ignore: no_leading_underscores_for_local_identifiers
        final double _deviceHeadingStream = event.heading!;
        
        // Exact mathematical difference mapping physical device forward to Kaaba coordinates.
        final double difference = _getShortestAngleDifference(
          _deviceHeadingStream, 
          widget.targetBearing,
        );
        
        // Exactly threshold tolerance of ±2 degrees.
        final bool isAligned = difference.abs() <= 2.0;

        // Perform tactile payload exactly once when intersecting the threshold block.
        if (isAligned && !_wasAligned) {
          HapticFeedback.mediumImpact();
          _wasAligned = true;
        } else if (!isAligned && _wasAligned) {
          _wasAligned = false;
        }

        // Calculates Qiblah trajectory mathematically enforcing user-supplied requirement:
        // Needle Angle = (Qiblah Bearing - Device Heading) * (pi / 180)
        // ignore: no_leading_underscores_for_local_identifiers
        final double _qiblahAlignmentAngle = difference * (pi / 180.0);

        return Column(
          children: [
            if (needsCalibration)
              const Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: CalibrationWarning(
                  message: 'Sensor accuracy is low. Move your phone in a figure-8 motion to calibrate.',
                  isWarning: true,
                ),
              ),
            
            SizedBox(
              height: 320,
              width: 320,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Positioned.fill(child: QiblahCompassDial()),
                  QiblahNeedle(
                    targetAngleRadians: _qiblahAlignmentAngle,
                    isAligned: isAligned,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              isAligned 
                  ? 'Aligned to Qiblah' 
                  : difference > 0 
                      ? 'Turn Right ${(difference).toStringAsFixed(0)}°' 
                      : 'Turn Left ${(difference.abs()).toStringAsFixed(0)}°',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isAligned ? AppColors.primaryBrand : AppColors.textPrimary,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Human-Grade UI Widgets
// ---------------------------------------------------------------------------

class QiblahCompassDial extends StatelessWidget {
  const QiblahCompassDial({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CompassDialPainter(
        trackColor: AppColors.textSecondary.withValues(alpha: 0.15),
      ),
    );
  }
}

/// Draws an aesthetic, minimalist compass track using purely mathematics instead of assets.
class _CompassDialPainter extends CustomPainter {
  const _CompassDialPainter({required this.trackColor});
  
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;
    
    final Paint paint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Outer ticks generated dynamically at 5 degree intervals.
    for (int i = 0; i < 72; i++) {
        final double angle = i * 5 * (pi / 180.0);
        // Highlight 45-degree primary markers.
        final double innerRadius = (i % 9 == 0) ? radius * 0.85 : radius * 0.93;
        
        final double dx1 = center.dx + innerRadius * cos(angle);
        final double dy1 = center.dy + innerRadius * sin(angle);
        
        final double dx2 = center.dx + radius * cos(angle);
        final double dy2 = center.dy + radius * sin(angle);
        
        paint.strokeWidth = (i % 9 == 0) ? 2.5 : 1.0;
        canvas.drawLine(Offset(dx1, dy1), Offset(dx2, dy2), paint);
    }
    
    // Draw an immaculate inner containment ring.
    paint.strokeWidth = 1.0;
    canvas.drawCircle(center, radius * 0.7, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// State-wrapper resolving native animated continuous rotations for `turns`.
/// Without this `turns` trick, the needle snaps violently across 360-degree barriers.
class QiblahNeedle extends StatefulWidget {
  const QiblahNeedle({
    super.key, 
    required this.targetAngleRadians, 
    required this.isAligned,
  });
  
  final double targetAngleRadians;
  final bool isAligned;

  @override
  State<QiblahNeedle> createState() => _QiblahNeedleState();
}

class _QiblahNeedleState extends State<QiblahNeedle> {
  double _turns = 0;

  @override
  void initState() {
    super.initState();
    _turns = widget.targetAngleRadians / (2 * pi);
  }

  @override
  void didUpdateWidget(QiblahNeedle oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    final double newTurns = widget.targetAngleRadians / (2 * pi);
    double diff = newTurns - _turns;
    
    // Normalize absolute difference cleanly into the optimal -0.5 to 0.5 turn range.
    while (diff > 0.5) {
      diff -= 1.0;
    }
    while (diff < -0.5) {
      diff += 1.0;
    }
    
    _turns += diff;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: _turns,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic, // Butter-smooth interpolation logic here.
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.explore,
            size: 64,
            // Visually illuminate the icon with emerald green upon strict alignment.
            color: widget.isAligned ? AppColors.primaryBrand : AppColors.textPrimary,
            shadows: widget.isAligned 
              ? [const BoxShadow(color: AppColors.primaryBrand, blurRadius: 24)] 
              : [],
          ),
          const SizedBox(height: 8),
          Container(
            height: 60,
            width: 4,
            decoration: BoxDecoration(
              color: widget.isAligned ? AppColors.primaryBrand : AppColors.textPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Geometrical offset to center the hinge.
          const SizedBox(height: 70), 
        ],
      ),
    );
  }
}

/// A humanized diagnostic widget overlay explaining raw physical sensor issues.
class CalibrationWarning extends StatelessWidget {
  const CalibrationWarning({
    super.key, 
    required this.message, 
    this.isWarning = false,
  });
  
  final String message;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isWarning 
            ? AppColors.surfaceCard 
            : AppColors.accentError.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isWarning 
            ? AppColors.primaryBrand.withValues(alpha: 0.5)
            : AppColors.accentError,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isWarning ? Icons.vibration : Icons.warning_amber_rounded,
            color: isWarning ? AppColors.primaryBrand : AppColors.accentError,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isWarning ? AppColors.textPrimary : AppColors.accentError,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationDetailsCard extends StatelessWidget {
  const _LocationDetailsCard({
    required this.lat, 
    required this.lon, 
    required this.distanceKm,
  });
  
  final double lat;
  final double lon;
  final double distanceKm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GPS Coordinates',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          _Row('Latitude', lat.toStringAsFixed(4)),
          _Row('Longitude', lon.toStringAsFixed(4)),
          _Row('Distance to Kaaba', '${distanceKm.toStringAsFixed(1)} km'),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);
  
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
