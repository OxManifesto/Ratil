import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import '../theme/theme_palette.dart';
import '../constants/localized_strings.dart';

class ImsakiyaView extends StatelessWidget {
  const ImsakiyaView({
    super.key,
    required this.coordinates,
    required this.params,
    required this.timezone,
    required this.strings,
  });

  final Coordinates coordinates;
  final CalculationParameters params;
  final String timezone;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final palette = ThemePalette.of(context);
    // Generate list for the current Hijri month (assuming Ramadan or current)
    final nowHijri = HijriCalendar.now();
    final daysInMonth = nowHijri.lengthOfMonth;
    final currentYear = nowHijri.hYear;
    final currentMonth = nowHijri.hMonth;

    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        title: Text(strings.imsakiyaTitle),
        backgroundColor: palette.background,
        foregroundColor: palette.textColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: palette.panelColor,
            child: Row(
              children: [
                _buildHeaderCell(strings.dayHeader, flex: 2, palette: palette),
                _buildHeaderCell(strings.fajrLabel, flex: 3, palette: palette),
                _buildHeaderCell(strings.dhuhrLabel, flex: 3, palette: palette),
                _buildHeaderCell(strings.asrLabel, flex: 3, palette: palette),
                _buildHeaderCell(
                  strings.maghribLabel,
                  flex: 3,
                  palette: palette,
                ),
                _buildHeaderCell(strings.ishaLabel, flex: 3, palette: palette),
              ],
            ),
          ),
          // List
          Expanded(
            child: ListView.separated(
              itemCount: daysInMonth,
              separatorBuilder: (c, i) =>
                  Divider(height: 1, color: palette.cardBorder),
              itemBuilder: (context, index) {
                final day = index + 1;
                // Create Hijri date to get the Gregorian date
                final hDate = HijriCalendar()
                  ..hYear = currentYear
                  ..hMonth = currentMonth
                  ..hDay = day;

                final gDate = hDate.hijriToGregorian(
                  currentYear,
                  currentMonth,
                  day,
                );

                final prayerTimes = PrayerTimes(
                  coordinates: coordinates,
                  date: gDate,
                  calculationParameters: params,
                  precision: true,
                );

                final isToday = day == nowHijri.hDay;

                return Container(
                  color: isToday
                      ? palette.accent.withValues(alpha: 0.1)
                      : Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      _buildCell(
                        // ignore: unnecessary_brace_in_string_interps
                        '${strings.dayHeader} $day\n${_formatDate(gDate)}',
                        flex: 2,
                        palette: palette,
                        isBold: true,
                      ),
                      _buildCell(
                        _formatTime(prayerTimes.fajr.toLocal()),
                        flex: 3,
                        palette: palette,
                      ),
                      _buildCell(
                        _formatTime(prayerTimes.dhuhr.toLocal()),
                        flex: 3,
                        palette: palette,
                      ),
                      _buildCell(
                        _formatTime(prayerTimes.asr.toLocal()),
                        flex: 3,
                        palette: palette,
                      ),
                      _buildCell(
                        _formatTime(prayerTimes.maghrib.toLocal()),
                        flex: 3,
                        palette: palette,
                        color: palette.accent,
                      ),
                      _buildCell(
                        _formatTime(prayerTimes.isha.toLocal()),
                        flex: 3,
                        palette: palette,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    // Basic localized months using generic logic or strings if available,
    // otherwise fallback to simple number/English for now as intl wasn't requested widely yet.
    // Ideally use DateFormat.MMMd().format(date) but checking imports.
    // For now keeping simpler to avoid new import issues, or just using numbers.
    return '${date.day}/${date.month}';
  }

  Widget _buildHeaderCell(
    String text, {
    required int flex,
    required ThemePalette palette,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: palette.mutedTextColor,
        ),
      ),
    );
  }

  Widget _buildCell(
    String text, {
    required int flex,
    required ThemePalette palette,
    bool isBold = false,
    Color? color,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
          color: color ?? palette.textColor,
        ),
      ),
    );
  }
}
