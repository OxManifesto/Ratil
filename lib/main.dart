import 'dart:async';
import 'package:ratil/utils/samsung_fix.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:permission_handler/permission_handler.dart';

import 'constants/app_language.dart';
import 'constants/localized_strings.dart';
import 'data/adhkar_data.dart';
import 'data/asmaul_husna.dart';
import 'data/surah_database.dart';
import 'screens/prayer_times_tab.dart';

import 'widgets/permission_onboarding.dart';
import 'services/daily_reset_service.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/navigation_provider.dart';
import 'theme/theme_palette.dart';
import 'services/security_service.dart';
import 'providers/prayer_times_controller.dart';

enum SettingsSection { appearance, reading, prayerLocation, about }

const Map<String, Color> kTajweedColors = {
  'ghunnah': Color(0xFFFFB74D),
  'hamzat_wasl': Color(0xFF81C784),
  'idghaam_ghunnah': Color(0xFFBA68C8),
  'idghaam_mutajanisayn': Color(0xFF4DB6AC),
  'idghaam_mutaqaribayn': Color(0xFF64B5F6),
  'idghaam_no_ghunnah': Color(0xFF9575CD),
  'idghaam_shafawi': Color(0xFFAED581),
  'ikhfa': Color(0xFFFF8A65),
  'ikhfa_shafawi': Color(0xFFFFCC80),
  'iqlab': Color(0xFFF06292),
  'lam_shamsiyyah': Color(0xFFFFF176),
  'madd_2': Color(0xFF90CAF9),
  'madd_246': Color(0xFF4FC3F7),
  'madd_6': Color(0xFF26C6DA),
  'madd_munfasil': Color(0xFF4DD0E1),
  'madd_muttasil': Color(0xFF00ACC1),
  'qalqalah': Color(0xFFE57373),
  'silent': Color(0xFF90A4AE),
};

class TajweedLegendEntry {
  const TajweedLegendEntry({
    required this.labelEn,
    required this.labelKu,
    required this.labelAr,
    required this.meaningEn,
    required this.meaningKu,
    required this.meaningAr,
  });

  final String labelEn;
  final String labelKu;
  final String labelAr;
  final String meaningEn;
  final String meaningKu;
  final String meaningAr;
}

const Map<String, TajweedLegendEntry> kTajweedLegendEntries = {
  'ghunnah': TajweedLegendEntry(
    labelEn: 'Ghunnah',
    labelKu: 'غنە',
    labelAr: 'غنة',
    meaningEn: 'Nasal sound',
    meaningKu: 'دەنگی بینی',
    meaningAr: 'صوت أنفي',
  ),
  'hamzat_wasl': TajweedLegendEntry(
    labelEn: 'Hamzat Wasl',
    labelKu: 'هەمزەی وەسل',
    labelAr: 'همزة الوصل',
    meaningEn: 'Connecting hamza',
    meaningKu: 'هەمزەی پەیوەست',
    meaningAr: 'همزة للوصل',
  ),
  'idgham_with_ghunnah': TajweedLegendEntry(
    labelEn: 'Idghaam with Ghunnah',
    labelKu: 'ئیدغام بە غنە',
    labelAr: 'إدغام بغنة',
    meaningEn: 'Assimilation with nasalization',
    meaningKu: 'یەکخستن بە غنە',
    meaningAr: 'إدغام مع غنة',
  ),
  'idgham_mutajanisayn': TajweedLegendEntry(
    labelEn: 'Idghaam Mutajanisayn',
    labelKu: 'ئیدغام متجانسین',
    labelAr: 'إدغام متجانسين',
    meaningEn: 'Similar letters merged',
    meaningKu: 'یەکخستنی پیتە هاوشێوەکان',
    meaningAr: 'إدغام الحروف المتجانسة',
  ),
  'idgham_mutaqaribayn': TajweedLegendEntry(
    labelEn: 'Idghaam Mutaqaribayn',
    labelKu: 'ئیدغام متقاربين',
    labelAr: 'إدغام متقاربين',
    meaningEn: 'Close letters merged',
    meaningKu: 'یەکخستنی پیتە نزیکەکان',
    meaningAr: 'إدغام الحروف المتقاربة',
  ),
  'idghaam_no_ghunnah': TajweedLegendEntry(
    labelEn: 'Idghaam (No Ghunnah)',
    labelKu: 'ئیدغام بێ غنە',
    labelAr: 'إدغام بلا غنة',
    meaningEn: 'Assimilation without nasalization',
    meaningKu: 'یەکخستن بێ غنە',
    meaningAr: 'إدغام بلا غنة',
  ),
  'idghaam_shafawi': TajweedLegendEntry(
    labelEn: 'Idghaam Shafawi',
    labelKu: 'ئیدغام شەفەوی',
    labelAr: 'إدغام شفوي',
    meaningEn: 'Lip assimilation',
    meaningKu: 'یەکخستن لەسەر لێو',
    meaningAr: 'إدغام شفوي',
  ),
  'ikhfa': TajweedLegendEntry(
    labelEn: 'Ikhfa',
    labelKu: 'ئێخفاء',
    labelAr: 'إخفاء',
    meaningEn: 'Concealment',
    meaningKu: 'شاردنەوە',
    meaningAr: 'إخفاء',
  ),
  'ikhfa_shafawi': TajweedLegendEntry(
    labelEn: 'Ikhfa Shafawi',
    labelKu: 'ئێخفای شەفەوی',
    labelAr: 'إخفاء شفوي',
    meaningEn: 'Lip concealment',
    meaningKu: 'شاردنەوەی شەفەوی',
    meaningAr: 'إخفاء شفوي',
  ),
  'iqlab': TajweedLegendEntry(
    labelEn: 'Iqlab',
    labelKu: 'ئیقلاب',
    labelAr: 'إقلاب',
    meaningEn: 'Change to م with nasalization',
    meaningKu: 'گۆڕینی نون بۆ میم بە غنە',
    meaningAr: 'قلب النون إلى ميم مع غنة',
  ),
  'lam_shamsiyyah': TajweedLegendEntry(
    labelEn: 'Lam Shamsiyyah',
    labelKu: 'لامی شەمسی',
    labelAr: 'لام شمسية',
    meaningEn: 'Sun-lam assimilation',
    meaningKu: 'لامی شەمسی یەکدەست دەبێت',
    meaningAr: 'إدغام لام الشمس',
  ),
  'madd_2': TajweedLegendEntry(
    labelEn: 'Madd 2',
    labelKu: 'مَد ٢',
    labelAr: 'مد ٢',
    meaningEn: '2-count elongation',
    meaningKu: 'دو هەنگاو درێژکردنەوە',
    meaningAr: 'مدّ حركتين',
  ),
  'madd_246': TajweedLegendEntry(
    labelEn: 'Madd 2/4/6',
    labelKu: 'مَد ٢/٤/٦',
    labelAr: 'مد ٢/٤/٦',
    meaningEn: '2/4/6-count elongation',
    meaningKu: 'درێژکردنەوەی ٢/٤/٦ هەنگاو',
    meaningAr: 'مدّ ٢/٤/٦ حركات',
  ),
  'madd_6': TajweedLegendEntry(
    labelEn: 'Madd 6',
    labelKu: 'مَد ٦',
    labelAr: 'مد ٦',
    meaningEn: '6-count elongation',
    meaningKu: 'شەش هەنگاو درێژکردنەوە',
    meaningAr: 'مدّ ست حركات',
  ),
  'madd_munfasil': TajweedLegendEntry(
    labelEn: 'Madd Munfasil',
    labelKu: 'مَد منفصل',
    labelAr: 'مد منفصل',
    meaningEn: 'Separated elongation',
    meaningKu: 'درێژکردنەوەی جیا',
    meaningAr: 'مد منفصل',
  ),
  'madd_muttasil': TajweedLegendEntry(
    labelEn: 'Madd Muttasil',
    labelKu: 'مَد متصل',
    labelAr: 'مد متصل',
    meaningEn: 'Joined elongation',
    meaningKu: 'درێژکردنەوەی پەیوەست',
    meaningAr: 'مد متصل',
  ),
  'qalqalah': TajweedLegendEntry(
    labelEn: 'Qalqalah',
    labelKu: 'قەلقەلە',
    labelAr: 'قلقلة',
    meaningEn: 'Echo/bounce sound',
    meaningKu: 'دەنگی ڕەنگاڵەوە',
    meaningAr: 'صوت القلقلة',
  ),
  'silent': TajweedLegendEntry(
    labelEn: 'Silent',
    labelKu: 'بێ دەنگ',
    labelAr: 'سكون',
    meaningEn: 'Silent letter',
    meaningKu: 'پیتە بێ دەنگەکان',
    meaningAr: 'حرف ساكن',
  ),
};

const double kPanelRadius = 24;
const double kCardRadius = 16;
const EdgeInsets kPagePadding = EdgeInsets.fromLTRB(14, 12, 14, 16);
const EdgeInsets kCardPadding = EdgeInsets.all(14);

const List<Prayer> kPrayerOrder = [
  Prayer.fajr,
  Prayer.sunrise,
  Prayer.dhuhr,
  Prayer.asr,
  Prayer.maghrib,
  Prayer.isha,
];

const Map<Prayer, String> kPrayerDisplayNames = {
  Prayer.fajr: 'Fajr',
  Prayer.sunrise: 'Sunrise',
  Prayer.dhuhr: 'Dhuhr',
  Prayer.asr: 'Asr',
  Prayer.maghrib: 'Maghrib',
  Prayer.isha: 'Isha',
  Prayer.ishaBefore: 'Isha (prev)',
  Prayer.fajrAfter: 'Fajr (next)',
};

const String kArabicTextAsset = 'asset/quran.json';
const Map<AppLanguage, String> kDefaultTranslationAssets = {
  AppLanguage.english: 'asset/translations/en.sahih.json',
  AppLanguage.kurdish: 'asset/translations/ku.asan.json',
  AppLanguage.arabic: 'asset/translations/ar.muyassar.json',
};

class JuzMeta {
  const JuzMeta({
    required this.number,
    required this.startSurahNumber,
    required this.startSurahName,
    required this.startVerse,
    required this.endSurahNumber,
    required this.endSurahName,
    required this.endVerse,
  });

  final int number;
  final int startSurahNumber;
  final String startSurahName;
  final int startVerse;
  final int endSurahNumber;
  final String endSurahName;
  final int endVerse;
}

class _SurahJuzRange {
  const _SurahJuzRange({required this.startVerse, required this.endVerse});

  final int startVerse;
  final int endVerse;
}

class _SurahMeta {
  const _SurahMeta({
    required this.number,
    required this.place,
    required this.type,
    required this.verseCount,
    required this.title,
    required this.titleAr,
    required this.pageStart,
    required this.juzRanges,
  });

  final int number;
  final String place;
  final String type;
  final int verseCount;
  final String title;
  final String titleAr;
  final int pageStart;
  final Map<int, _SurahJuzRange> juzRanges;
}

late final AudioPlayer sharedPlayer;

class _NavItem {
  const _NavItem({required this.icon, required this.label, this.selectedIcon});

  final IconData icon;
  final IconData? selectedIcon;
  final String label;
}

class PresetLocation {
  const PresetLocation({
    required this.name,
    required this.kurdishName,
    required this.arabicName,
    required this.latitude,
    required this.longitude,
    required this.timeZone,
  });

  final String name;
  final String kurdishName;
  final String arabicName;
  final double latitude;
  final double longitude;
  final String timeZone;

  String localizedName(AppLanguage language) {
    return switch (language) {
      AppLanguage.kurdish => kurdishName,
      AppLanguage.arabic => arabicName,
      AppLanguage.english => name,
    };
  }
}

const List<PresetLocation> kPresetLocations = [
  PresetLocation(
    name: 'Makkah, KSA',
    kurdishName: 'مەککە، سعودیا',
    arabicName: 'مكة، السعودية',
    latitude: 21.4225,
    longitude: 39.8262,
    timeZone: 'Asia/Riyadh',
  ),
  PresetLocation(
    name: 'Madinah, KSA',
    kurdishName: 'مەدینە، سعودیا',
    arabicName: 'المدينة المنورة، السعودية',
    latitude: 24.4709,
    longitude: 39.6122,
    timeZone: 'Asia/Riyadh',
  ),
  PresetLocation(
    name: 'Cairo, Egypt',
    kurdishName: 'قاهیرە، میسر',
    arabicName: 'القاهرة، مصر',
    latitude: 30.0444,
    longitude: 31.2357,
    timeZone: 'Africa/Cairo',
  ),
  PresetLocation(
    name: 'Istanbul, Turkiye',
    kurdishName: 'استانبول، تورکیا',
    arabicName: 'إسطنبول، تركيا',
    latitude: 41.0082,
    longitude: 28.9784,
    timeZone: 'Europe/Istanbul',
  ),
  PresetLocation(
    name: 'Dubai, UAE',
    kurdishName: 'دوبەی، ئیمارات',
    arabicName: 'دبي، الإمارات',
    latitude: 25.2048,
    longitude: 55.2708,
    timeZone: 'Asia/Dubai',
  ),
  PresetLocation(
    name: 'Doha, Qatar',
    kurdishName: 'دوحە، قەتەر',
    arabicName: 'الدوحة، قطر',
    latitude: 25.2854,
    longitude: 51.531,
    timeZone: 'Asia/Qatar',
  ),
  PresetLocation(
    name: 'Erbil, Kurdistan',
    kurdishName: 'هەولێر، کوردستان',
    arabicName: 'أربيل، كردستان',
    latitude: 36.1911,
    longitude: 44.009,
    timeZone: 'Asia/Baghdad',
  ),
  PresetLocation(
    name: 'Sulaymaniyah, Kurdistan',
    kurdishName: 'سلێمانی، کوردستان',
    arabicName: 'السليمانية، كردستان',
    latitude: 35.5613,
    longitude: 45.4359,
    timeZone: 'Asia/Baghdad',
  ),
  PresetLocation(
    name: 'Duhok, Kurdistan',
    kurdishName: 'دهۆک، کوردستان',
    arabicName: 'دهوك، كردستان',
    latitude: 36.8667,
    longitude: 42.9833,
    timeZone: 'Asia/Baghdad',
  ),
  PresetLocation(
    name: 'Halabja, Kurdistan',
    kurdishName: 'هەڵەبجە، کوردستان',
    arabicName: 'حلبجة، كردستان',
    latitude: 35.1776,
    longitude: 45.9861,
    timeZone: 'Asia/Baghdad',
  ),
  PresetLocation(
    name: 'Kirkuk, Kurdistan',
    kurdishName: 'کەرکوک، کوردستان',
    arabicName: 'كركوك، كردستان',
    latitude: 35.4667,
    longitude: 44.3167,
    timeZone: 'Asia/Baghdad',
  ),
  PresetLocation(
    name: 'Zakho, Kurdistan',
    kurdishName: 'زاخۆ، کوردستان',
    arabicName: 'زاخو، كردستان',
    latitude: 37.1478,
    longitude: 42.6832,
    timeZone: 'Asia/Baghdad',
  ),
  PresetLocation(
    name: 'Hajiawa, Ranya, Sulaimani',
    kurdishName: 'حاجیاوا، ڕانیە، سلێمانی',
    arabicName: 'حاجياوة، رانية، السليمانية',
    latitude: 36.2418297,
    longitude: 44.7836071,
    timeZone: 'Asia/Baghdad',
  ),
  PresetLocation(
    name: 'Ranya, Sulaimani',
    kurdishName: 'ڕانیە، سلێمانی',
    arabicName: 'رانية، السليمانية',
    latitude: 36.2476521,
    longitude: 44.8492699,
    timeZone: 'Asia/Baghdad',
  ),
  PresetLocation(
    name: 'Chawarqurna, Ranya, Sulaimani',
    kurdishName: 'چوارقورنە، ڕانیە، سلێمانی',
    arabicName: 'چوارقورنە، رانية، السليمانية',
    latitude: 36.235,
    longitude: 44.82,
    timeZone: 'Asia/Baghdad',
  ),
  PresetLocation(
    name: 'Iran',
    kurdishName: 'تەهران، ئێران',
    arabicName: 'تەهران، إيران',
    latitude: 35.6892,
    longitude: 51.389,
    timeZone: 'Asia/Tehran',
  ),
  PresetLocation(
    name: 'Kuala Lumpur, MY',
    kurdishName: 'کوالالەمپور، مالیسیا',
    arabicName: 'كوالالمبور، ماليزيا',
    latitude: 3.139,
    longitude: 101.6869,
    timeZone: 'Asia/Kuala_Lumpur',
  ),
  PresetLocation(
    name: 'Jakarta, ID',
    kurdishName: 'جاکارتا، ئیندۆنیسیا',
    arabicName: 'جاكرتا، إندونيسيا',
    latitude: -6.2088,
    longitude: 106.8456,
    timeZone: 'Asia/Jakarta',
  ),
  PresetLocation(
    name: 'London, UK',
    kurdishName: 'لەندەن، بەریتانیا',
    arabicName: 'لندن، المملكة المتحدة',
    latitude: 51.5072,
    longitude: -0.1276,
    timeZone: 'Europe/London',
  ),
  PresetLocation(
    name: 'New York, USA',
    kurdishName: 'نیویۆرک، ئەمریکا',
    arabicName: 'نيويورك، الولايات المتحدة',
    latitude: 40.7128,
    longitude: -74.006,
    timeZone: 'America/New_York',
  ),
];

class PrayerSoundOption {
  const PrayerSoundOption({
    required this.id,
    required this.label,
    required this.asset,
    required this.androidResource,
  });

  final String id;
  final String label;
  final String asset;
  final String androidResource;
}

const List<PrayerSoundOption> kPrayerSoundOptions = [
  PrayerSoundOption(
    id: 'ahmed_imadi',
    label: 'Ahmed al-Imadi',
    asset: 'asset/adhan.notifications/Ahmed_al_Imadi.mp3',
    androidResource: 'adhan_ahmed_al_imadi',
  ),
  PrayerSoundOption(
    id: 'Majed_al_Hamathani',
    label: 'Majed al Hamathani',
    asset: 'asset/adhan.notifications/Majed_al_Hamathani.mp3',
    androidResource: 'adhan_majed_al_hamathani',
  ),
  PrayerSoundOption(
    id: 'Mishary_Rashid_al_Afasy',
    label: 'Mishary Rashid al Afasy',
    asset: 'asset/adhan.notifications/Mishary_Rashid_al_Afasy.mp3',
    androidResource: 'adhan_mishary_rashid_al_afasy',
  ),
  PrayerSoundOption(
    id: 'Mokhtar_Hadj_Slimane',
    label: 'Mokhtar Hadj',
    asset: 'asset/adhan.notifications/Mokhtar_Hadj_Slimane.mp3',
    androidResource: 'adhan_mokhtar_hadj_slimane',
  ),
  PrayerSoundOption(
    id: 'Muhd_Jazy',
    label: 'Muhd Jazy',
    asset: 'asset/adhan.notifications/Muhd_Jazy.mp3',
    androidResource: 'adhan_muhd_jazy',
  ),
  PrayerSoundOption(
    id: 'Nasser_al_Qatami',
    label: 'Nasser al Qatami',
    asset: 'asset/adhan.notifications/Nasser_al_Qatami.mp3',
    androidResource: 'adhan_nasser_al_qatami',
  ),
];

String _prayerLocationLabel(AppLanguage language) {
  return switch (language) {
    AppLanguage.kurdish => 'کاتی نوێژ',
    AppLanguage.arabic => 'وقت الصلاة',
    AppLanguage.english => 'Prayer Time',
  };
}

String _currentLocationLabel(AppLanguage language) {
  return switch (language) {
    AppLanguage.kurdish => 'شوێنی ئێستا',
    AppLanguage.arabic => 'الموقع الحالي',
    AppLanguage.english => 'Current location',
  };
}

String _currentLocationDescription(AppLanguage language) {
  return switch (language) {
    AppLanguage.kurdish => 'بۆ هەژماری کاتەکانی نوێژ GPSی ئامێر بەکاربهێنە.',
    AppLanguage.arabic => 'استخدم نظام GPS لحساب أوقات الصلاة.',
    AppLanguage.english => 'Use device GPS to calculate prayer times.',
  };
}

String _presetLocationDescription(AppLanguage language, String locationName) {
  return switch (language) {
    AppLanguage.kurdish => 'ڕێکخستنی پێش‌دیارکراو بۆ $locationName بەکاربهێنە.',
    AppLanguage.arabic => 'استخدم الإحداثيات المحددة مسبقًا لـ $locationName.',
    AppLanguage.english => 'Use preset coordinates for $locationName.',
  };
}

String _prayerLocationNote(AppLanguage language) {
  return switch (language) {
    AppLanguage.kurdish =>
      'کاتەکانی نوێژ دوای گۆڕینی ئەم ڕێکخستنە نوێ دەبنەوە.',
    AppLanguage.arabic => 'تتحدّث أوقات الصلاة بعد تغيير هذا الإعداد.',
    AppLanguage.english => 'Prayer times update after you change this setting.',
  };
}

class PrayerNotificationService {
  PrayerNotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static bool _timezoneReady = false;

  static const Map<Prayer, int> _prayerIds = {
    Prayer.fajr: 120,
    Prayer.sunrise: 121,
    Prayer.dhuhr: 122,
    Prayer.asr: 123,
    Prayer.maghrib: 124,
    Prayer.isha: 125,
  };

  static Future<void> ensureInitialized() async {
    if (kIsWeb) return;
    if (!_timezoneReady) {
      tzdata.initializeTimeZones();
      final timeZoneName = await _deviceTimezone();
      try {
        tz.setLocalLocation(tz.getLocation(timeZoneName));
      } catch (_) {
        tz.setLocalLocation(tz.getLocation('UTC'));
      }
      _timezoneReady = true;
    }
    if (_initialized) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _plugin.initialize(settings);
    _initialized = true;
  }

  static Future<String> _deviceTimezone() async {
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      return tzInfo.identifier;
    } catch (_) {
      return 'UTC';
    }
  }

  static Future<bool> requestPermissions() async {
    if (kIsWeb) return false;
    await ensureInitialized();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final androidKnown =
        await android?.requestNotificationsPermission() ?? false;
        
    if (Platform.isAndroid) {
      await Permission.scheduleExactAlarm.request();
    }
    
    final androidAlarms =
        await android?.requestExactAlarmsPermission() ?? true;
    // For Android 13+ (SDK 33), POST_NOTIFICATIONS must be requested at runtime
    // but the plugin's requestNotificationsPermission handles it.
    // Ensure exact alarm permission is also requested if needed.

    final darwin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final darwinGranted =
        await darwin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        true;

    return (androidKnown && androidAlarms) || darwinGranted;
  }

  static Future<void> schedulePrayerNotifications({
    required Map<Prayer, DateTime> times,
    required Set<Prayer> enabledPrayers,
    required Map<Prayer, String> labels,
    required String title,
    required PrayerSoundOption sound,
    required bool respectSilentMode,
  }) async {
    if (kIsWeb) return;
    await ensureInitialized();
    await _clearPrayerNotifications();
    final now = DateTime.now();
    final channelId = 'prayer_times_v2_${sound.id}';
    final channelName = 'Prayer times - ${sound.label}';
    final androidSound = RawResourceAndroidNotificationSound(
      sound.androidResource,
    );

    for (final entry in times.entries) {
      final prayer = entry.key;
      if (!enabledPrayers.contains(prayer)) continue;
      final scheduled = entry.value;
      final id = _prayerIds[prayer];
      if (id == null || scheduled.isBefore(now)) continue;

      final tzTime = tz.TZDateTime.from(scheduled, tz.local);
      final label = labels[prayer] ?? prayer.name;
      await _plugin.zonedSchedule(
        id,
        title,
        'هەموو تلاوەتەکان و موصەحەفی تەواو لە ناو ئەپەکەدایە، پێویستت بە ئینتەرنێت نییە.',
        tzTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: 'Reminders for daily prayers',
            importance: Importance.max,
            priority: Priority.max,
            ticker: 'ticker',
            category: AndroidNotificationCategory.alarm,
            playSound: true,
            sound: androidSound,
            audioAttributesUsage: AudioAttributesUsage.alarm,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'prayer:$label',
      );
    }
  }

  static Future<void> cancelPrayerNotifications() async {
    if (kIsWeb) return;
    await ensureInitialized();
    await _clearPrayerNotifications();
  }

  static Future<void> _clearPrayerNotifications() async {
    for (final id in _prayerIds.values) {
      await _plugin.cancel(id);
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BootloaderApp());
}

class BootloaderApp extends StatefulWidget {
  const BootloaderApp({super.key});

  @override
  State<BootloaderApp> createState() => _BootloaderAppState();
}

class _BootloaderAppState extends State<BootloaderApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Execute all heavy operations asynchronously without blocking the UI thread.
    await Future.wait([
      _initSecurity(),
      _initTimezonesAndAudio(),
      _initNotifications(),
      _initDailyReset(),
    ]);

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  Future<void> _initSecurity() async {
    try {
      await SecurityService.instance.initialize();
    } catch (e) {
      debugPrint("SecurityService init failed: $e");
    }
  }

  Future<void> _initTimezonesAndAudio() async {
    try {
      tzdata.initializeTimeZones();
    } catch (e) {
      debugPrint("Timezone init failed: $e");
    }
    try {
      // AudioPlayer instantiation can be heavy; delaying it prevents jank.
      sharedPlayer = AudioPlayer();
    } catch (e) {
      debugPrint("Failed to initialize sharedPlayer: $e");
    }
  }

  Future<void> _initNotifications() async {
    try {
      await PrayerNotificationService.ensureInitialized();
    } catch (e) {
      debugPrint("PrayerNotificationService init failed: $e");
    }
  }

  Future<void> _initDailyReset() async {
    try {
      await DailyResetService.initialize();
      DailyResetService.scheduleDailyReset();
    } catch (e) {
      debugPrint("DailyResetService init failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark, // Keeps ambient dark-mode to avoid flash
        home: Scaffold(
          backgroundColor: const Color(0xFF121212), // Background Main alias
          body: const Center(
            child: SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                color: Color(0xFF10B981), // Primary Brand alias
              ),
            ),
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => PrayerTimesController()),
      ],
      child: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ratil',
      themeMode: themeProvider.mode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const QuranHomePage(),
    );
  }
}

class QuranHomePage extends StatefulWidget {
  const QuranHomePage({super.key});

  @override
  State<QuranHomePage> createState() => _QuranHomePageState();
}

class _QuranHomePageState extends State<QuranHomePage>
    with WidgetsBindingObserver {
  static const _prefLanguageKey = 'pref_language';
  static const _prefPrayerLocationKey = 'pref_preset_location';
  static const _prefReadTranslationKey = 'pref_read_translation';
  static const _prefReadTextScaleKey = 'pref_read_text_scale';
  static const _prefPrayerSoundKey = 'pref_prayer_sound';
  static const _prefPrayerSoundRespectKey = 'pref_prayer_sound_respect_silent';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final PageController _pageController = PageController(); // Moved to NavigationProvider
  // int _currentPage = 0; // Moved to NavigationProvider
  AppLanguage _language = AppLanguage.kurdish;
  late TranslationOption _readTranslation;
  double _readTextScale = 0.98;
  PresetLocation? _prayerLocation;
  PrayerSoundOption _prayerSound = kPrayerSoundOptions.first;
  bool _prayerSoundRespectSilent = true;
  bool _isFirstRun = true;
  bool _loadingPreferences = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (localizedStrings.containsKey(_language)) {
        SamsungFix.checkAndFix(context, localizedStrings[_language]!);
      }
    });
    _readTranslation = _defaultTranslationFor(_language);
    _restoreAppPreferences();
    WidgetsBinding.instance.addObserver(this); // RATIL-006
  }

  DateTime? _lastResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final now = DateTime.now();
      if (_lastResume != null &&
          now.difference(_lastResume!) < const Duration(seconds: 2)) {
        return; // RATIL-CORE-003: debounce lifecycle thrashing
      }
      _lastResume = now;
      // Detect timezone crossings while app was backgrounded.
      context.read<PrayerTimesController>().onAppResumed();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // RATIL-006
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = ThemePalette.of(context);
    final navProvider = Provider.of<NavigationProvider>(context);

    if (_loadingPreferences) {
      return Container(color: palette.background);
    }

    final strings = localizedStrings[_language]!;

    if (_isFirstRun) {
      return PermissionOnboarding(
        palette: palette,
        strings: strings,
        onDone: () {
          setState(() => _isFirstRun = false);
        },
      );
    }

    final isRtlLayout = strings.direction == TextDirection.rtl;
    final navItems = _buildNavItems(strings);
    
    // Bounds check to resolve out-of-bounds cache
    final safeIndex = navProvider.currentIndex.clamp(0, navItems.length - 1);
    if (navProvider.currentIndex != safeIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navProvider.setTabIndex(safeIndex);
      });
    }
    
    final currentLabel = navItems[safeIndex].label;
    return Directionality(
      textDirection: strings.direction,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          // Root screen handles back by doing nothing or minimizing;
          // in this case, we prevent the crash by not popping.
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: palette.background,
          drawer: isRtlLayout
              ? null
              : _buildDrawer(
                  strings: strings,
                  palette: palette,
                  items: navItems,
                  isRtl: isRtlLayout,
                ),
          endDrawer: isRtlLayout
              ? _buildDrawer(
                  strings: strings,
                  palette: palette,
                  items: navItems,
                  isRtl: isRtlLayout,
                )
              : null,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: palette.gradients.first,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(
                      strings: strings,
                      palette: palette,
                      currentLabel: currentLabel,
                      isRtl: isRtlLayout,
                      settingsIndex: navItems.length - 1,
                    ),

                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: palette.panelColor,
                          borderRadius: BorderRadius.circular(kPanelRadius),
                          border: Border.all(color: palette.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black.withValues(alpha: 0.35)
                                  : Colors.black.withValues(alpha: 0.1),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(kPanelRadius),
                          child: PageView(
                            controller: navProvider.pageController,
                            physics: const BouncingScrollPhysics(),
                            onPageChanged: navProvider.onPageChanged,
                            children: [
                              QuranAudioTab(
                                strings: strings,
                                language: _language,
                              ),
                              QuranReadTab(
                                strings: strings,
                                language: _language,
                                translation: _readTranslation,
                                textScale: _readTextScale,
                              ),
                              QiblahTab(strings: strings),
                              PrayerTimesTab(
                                strings: strings,
                                palette: palette,
                                language: _language,
                                presetLocation: _prayerLocation,
                                prayerSound: _prayerSound,
                                respectSilentMode: _prayerSoundRespectSilent,
                              ),
                              ZikrTab(
                                strings: strings,
                                palette: palette,
                                language: _language,
                              ),
                              AsmaulHusnaTab(
                                strings: strings,
                                language: _language,
                              ),
                              KidsPrayerTab(
                                strings: strings,
                                language: _language,
                                palette: palette,
                              ),
                              SettingsTab(
                                strings: strings,
                                currentLanguage: _language,
                                currentTranslation: _readTranslation,
                                readTextScale: _readTextScale,
                                onReadTranslationChanged:
                                    _handleReadTranslationChanged,
                                onReadTextScaleChanged:
                                    _handleReadTextScaleChanged,
                                palette: palette,
                                prayerLocation: _prayerLocation,
                                onPrayerLocationChanged:
                                    _handlePrayerLocationChanged,
                                prayerSound: _prayerSound,
                                onPrayerSoundChanged: _handlePrayerSoundChanged,
                                prayerSoundRespectSilent:
                                    _prayerSoundRespectSilent,
                                onPrayerSoundRespectSilentChanged:
                                    _handlePrayerSoundRespectSilentChanged,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleNavigationTap(int index) {
    Provider.of<NavigationProvider>(context, listen: false).setTabIndex(index);
  }

  TranslationOption _defaultTranslationFor(
    AppLanguage language, {
    List<TranslationOption>? options,
  }) {
    final candidates = options ?? kTranslationOptions;
    final asset = kDefaultTranslationAssets[language];
    if (asset != null) {
      for (final option in candidates) {
        if (option.asset == asset) {
          return option;
        }
      }
    }
    if (candidates.isNotEmpty) {
      return candidates.first;
    }
    return _fallbackTranslationOptions.first;
  }

  TranslationOption _translationForId(
    String? id, {
    List<TranslationOption>? options,
    AppLanguage? language,
  }) {
    final candidates = options ?? kTranslationOptions;
    if (id != null) {
      for (final option in candidates) {
        if (option.id == id) return option;
      }
    }
    return _defaultTranslationFor(language ?? _language, options: candidates);
  }

  void _handleLanguageChanged(AppLanguage lang) {
    if (_language == lang) return;
    setState(() => _language = lang);
    _persistLanguage(lang);
  }

  void _handleReadTranslationChanged(TranslationOption option) {
    setState(() => _readTranslation = option);
    _persistReadTranslation(option.id);
  }

  void _handleReadTextScaleChanged(double value) {
    final clamped = value.clamp(0.85, 1.2);
    setState(() => _readTextScale = clamped);
    _persistReadTextScale(clamped);
  }

  void _handlePrayerLocationChanged(PresetLocation? preset) {
    setState(() => _prayerLocation = preset);
    _persistPrayerLocation(preset);
  }

  void _handlePrayerSoundChanged(PrayerSoundOption option) {
    setState(() => _prayerSound = option);
    _persistPrayerSound(option.id);
  }

  void _handlePrayerSoundRespectSilentChanged(bool value) {
    setState(() => _prayerSoundRespectSilent = value);
    _persistPrayerSoundRespectSilent(value);
  }

  Future<void> _restoreAppPreferences() async {
    final translationOptions = await _loadTranslationOptions();
    final security = SecurityService.instance;

    final langCode = await security.readSecure(_prefLanguageKey);
    final presetLocationName = await security.readSecure(
      _prefPrayerLocationKey,
    );
    final readTranslationId = await security.readSecure(
      _prefReadTranslationKey,
    );
    final readTextScaleStr = await security.readSecure(_prefReadTextScaleKey);
    final prayerSoundId = await security.readSecure(_prefPrayerSoundKey);
    final prayerSoundRespectStr = await security.readSecure(
      _prefPrayerSoundRespectKey,
    );

    final readTextScale = readTextScaleStr != null
        ? double.tryParse(readTextScaleStr)
        : null;
    final prayerSoundRespect = prayerSoundRespectStr != null
        ? prayerSoundRespectStr == 'true'
        : null;

    final resolvedLanguage = langCode != null
        ? AppLanguage.values.firstWhere(
            (l) => l.name == langCode,
            orElse: () => _language,
          )
        : _language;

    final resolvedPrayerSound = kPrayerSoundOptions.firstWhere(
      (option) => option.id == prayerSoundId,
      orElse: () => kPrayerSoundOptions.first,
    );

    final resolvedTranslation = _translationForId(
      readTranslationId,
      options: translationOptions,
      language: resolvedLanguage,
    );

    final isFirstRunStr = await security.readSecure('is_first_run');
    final isFirstRun = isFirstRunStr != null ? isFirstRunStr == 'true' : true;

    setState(() {
      kTranslationOptions = translationOptions;
      _language = resolvedLanguage;
      _prayerSound = resolvedPrayerSound;
      _prayerSoundRespectSilent = prayerSoundRespect ?? true;
      if (presetLocationName != null) {
        final match = kPresetLocations
            .where((location) => location.name == presetLocationName)
            .toList();
        if (match.isNotEmpty) {
          _prayerLocation = match.first;
        }
      }
      _readTranslation = resolvedTranslation;
      if (readTextScale != null) {
        _readTextScale = readTextScale.clamp(0.85, 1.2);
      }
      _isFirstRun = isFirstRun;
      _loadingPreferences = false;
    });
  }

  Future<void> _persistLanguage(AppLanguage lang) async {
    await SecurityService.instance.writeSecure(_prefLanguageKey, lang.name);
  }

  Future<void> _persistPrayerLocation(PresetLocation? preset) async {
    if (preset == null) {
      // For now, we don't have a specific deleteSecure, but writing empty or null works
      await SecurityService.instance.writeSecure(_prefPrayerLocationKey, '');
      return;
    }
    await SecurityService.instance.writeSecure(
      _prefPrayerLocationKey,
      preset.name,
    );
  }

  Future<void> _persistPrayerSound(String id) async {
    await SecurityService.instance.writeSecure(_prefPrayerSoundKey, id);
  }

  Future<void> _persistPrayerSoundRespectSilent(bool value) async {
    await SecurityService.instance.writeSecure(
      _prefPrayerSoundRespectKey,
      value.toString(),
    );
  }

  Future<void> _persistReadTranslation(String id) async {
    await SecurityService.instance.writeSecure(_prefReadTranslationKey, id);
  }

  Future<void> _persistReadTextScale(double value) async {
    await SecurityService.instance.writeSecure(
      _prefReadTextScaleKey,
      value.toString(),
    );
  }

  Future<void> _persistAudioBookmarks(List<String> list) async {
    await SecurityService.instance.writeSecure(
      'audio_bookmarks',
      json.encode(list),
    );
  }

  Future<void> _persistReadBookmarks(List<dynamic> list) async {
    await SecurityService.instance.writeSecure(
      'read_bookmarks',
      json.encode(list),
    );
  }

  void _openDrawer(bool isRtl) {
    final state = _scaffoldKey.currentState;
    if (state == null) return;
    if (isRtl) {
      state.openEndDrawer();
    } else {
      state.openDrawer();
    }
  }

  List<_NavItem> _buildNavItems(AppStrings strings) {
    return <_NavItem>[
      _NavItem(icon: Icons.headphones_outlined, label: strings.listenLabel),
      _NavItem(
        icon: Icons.menu_book_outlined,
        selectedIcon: Icons.menu_book,
        label: strings.readLabel,
      ),
      _NavItem(
        icon: Icons.explore_outlined,
        selectedIcon: Icons.explore,
        label: strings.qiblahLabel,
      ),
      _NavItem(
        icon: Icons.access_alarms,
        selectedIcon: Icons.alarm,
        label: strings.prayerTimesLabel,
      ),
      _NavItem(
        icon: Icons.self_improvement_outlined,
        selectedIcon: Icons.self_improvement,
        label: strings.zikrLabel,
      ),
      _NavItem(
        icon: Icons.auto_awesome_outlined,
        selectedIcon: Icons.auto_awesome,
        label: strings.namesLabel,
      ),
      _NavItem(
        icon: Icons.child_care,
        selectedIcon: Icons.family_restroom,
        label: strings.kidsLearningLabel,
      ),
      _NavItem(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings,
        label: strings.settingsLabel,
      ),
    ];
  }

  Widget _buildHeader({
    required AppStrings strings,
    required ThemePalette palette,
    required String currentLabel,
    required bool isRtl,
    required int settingsIndex,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: palette.navBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: palette.navBorder),
          ),
          child: IconButton(
            tooltip: 'Menu',
            onPressed: () => _openDrawer(isRtl),
            icon: Icon(Icons.menu, color: palette.textColor, size: 18),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.appTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                currentLabel,
                style: TextStyle(color: palette.mutedTextColor, fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: strings.settingsLabel,
          onPressed: () => _handleNavigationTap(settingsIndex),
          icon: Icon(Icons.settings_outlined, color: palette.textColor),
        ),
      ],
    );
  }

  Widget _navIcon(
    _NavItem item,
    bool selected,
    ThemePalette palette,
    Color textColor,
  ) {
    return Icon(
      selected ? (item.selectedIcon ?? item.icon) : item.icon,
      size: 18,
      color: textColor,
    );
  }

  Widget _buildDrawer({
    required AppStrings strings,
    required ThemePalette palette,
    required List<_NavItem> items,
    required bool isRtl,
  }) {
    final navProvider = Provider.of<NavigationProvider>(context);

    Widget buildItem(_NavItem item, int index) {
      final selected = navProvider.currentIndex == index;
      final textColor = selected ? palette.textColor : palette.mutedTextColor;
      return Material(
        color: selected ? palette.navIndicator : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: _navIcon(item, selected, palette, textColor),
          title: Text(
            item.label,
            style: TextStyle(
              color: textColor,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          trailing: selected
              ? Icon(
                  isRtl ? Icons.chevron_left : Icons.chevron_right,
                  color: palette.accent,
                  size: 18,
                )
              : null,
          onTap: () {
            Navigator.of(context).maybePop();
            _handleNavigationTap(index);
          },
        ),
      );
    }

    final safeIndex = navProvider.currentIndex.clamp(0, items.length - 1);
    final currentLabel = items[safeIndex].label;
    return Drawer(
      backgroundColor: palette.navBackground,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: isRtl
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        strings.appTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: palette.textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentLabel,
                    style: TextStyle(color: palette.mutedTextColor),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: palette.panelColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: palette.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.language,
                              color: palette.accent,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              strings.languageLabel,
                              style: TextStyle(
                                color: palette.textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: palette.heroHighlight,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: palette.cardBorder),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<AppLanguage>(
                              value: _language,
                              isExpanded: true,
                              dropdownColor: palette.navBackground,
                              iconEnabledColor: palette.textColor,
                              style: TextStyle(
                                color: palette.textColor,
                                fontWeight: FontWeight.w600,
                              ),
                              items: AppLanguage.values
                                  .map(
                                    (lang) => DropdownMenuItem<AppLanguage>(
                                      value: lang,
                                      child: Text(
                                        localizedStrings[lang]!.languageName,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (lang) {
                                if (lang == null || lang == _language) return;
                                _handleLanguageChanged(lang);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                itemBuilder: (context, index) => buildItem(items[index], index),
                separatorBuilder: (context, index) => const SizedBox(height: 6),
                itemCount: items.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _childrenTabLabel {
    return switch (_language) {
      AppLanguage.kurdish => 'منداڵان',
      AppLanguage.arabic => 'قسم الأطفال',
      _ => 'Kids',
    };
  }
}

class QuranAudioTab extends StatefulWidget {
  const QuranAudioTab({
    super.key,
    required this.strings,
    required this.language,
  });

  final AppStrings strings;
  final AppLanguage language;

  @override
  State<QuranAudioTab> createState() => _QuranAudioTabState();
}

class AudioCollection {
  const AudioCollection({
    required this.id,
    required this.label,
    required this.manifestAsset,
    required this.subtitleBuilder,
  });

  final String id;
  final String label;
  final String manifestAsset;
  final String Function(AppStrings) subtitleBuilder;

  String subtitle(AppStrings strings) => subtitleBuilder(strings);
}

const Map<String, String> kAudioCollectionManifests = {
  'recitation': 'link/Al-Quran-Ul-KarimRecitedByQariAbdulBasitAbdulSamad.txt',
  'english': 'link/Al_Quran-English_Translation.txt',
  'kurdish': 'link/Al_Quran-Kurdish_Translation.txt',
  'sharif': 'link/Quran_Al-Qari_Sharif.txt',
  'yasser': 'link/yasser Al Dosari.txt',
  'raad': 'link/Raad-Al_Kurdi.txt',
  'maher': 'link/maher.txt',
  'khalid': 'link/Khalid aljalil.txt',
  'hazaa': 'link/Hazaa Al Balushi.txt',
  'mosad': 'link/Abdulrhman Mosad.txt',
  'fares': 'link/Fares Abbad.txt',
  'ali': 'link/Ali-Alhuthaifi.txt',
  'ghamdi': 'link/Al-Ghamdi.txt',
  'agamy': 'link/Ahmed El Agamy.txt',
  'minshawi': 'link/Al-Minshawi.txt',
  'allheadan': 'link/allheadan.txt',
  'ayman': 'link/Ayman-Roshdy-Sweed.txt',
  'majid': 'link/Majid-Alzamil.txt',
  'tariq': 'link/Tariq Muhammad.txt',
  'khader': 'link/Ahmed Khader.txt',
};

const Map<String, String> kAudioCollectionNames = {
  'yasser': 'Yasser Al Dosari',
  'raad': 'Raad Al Kurdi',
  'maher': 'Maher Al-Muaiqly',
  'khalid': 'Khalid Al-Jalil',
  'hazaa': 'Hazaa Al Balushi',
  'mosad': 'Abdulrhman Mosad',
  'fares': 'Fares Abbad',
  'ali': 'Ali Al-Huthaifi',
  'ghamdi': 'Saad Al-Ghamdi',
  'agamy': 'Ahmed Al-Ajmy',
  'minshawi': 'Al-Minshawi',
  'allheadan': 'Abdullah Al-Haydan',
  'ayman': 'Ayman Rushdi Sweed',
  'majid': 'Majid Al Zamil',
  'tariq': 'Tariq Muhammad',
  'khader': 'Ahmed Khader',
};

const Map<String, List<int>> kAudioCustomSurahIndexes = {
  'yasser': kFullSurahIndexes,
  'raad': kFullSurahIndexes,
  'maher': kFullSurahIndexes,
  'khalid': kFullSurahIndexes,
  'mosad': kMosadSurahIndexes,
  'hazaa': kHazaaSurahIndexes,
  'sharif': kSharifSurahIndexes,
  'fares': kFullSurahIndexes,
  'ali': kFullSurahIndexes,
  'ghamdi': kFullSurahIndexes,
  'agamy': kFullSurahIndexes,
  'minshawi': kFullSurahIndexes,
  'allheadan': kFullSurahIndexes,
  'ayman': kFullSurahIndexes,
  'majid': kFullSurahIndexes,
  'tariq': kTariqSurahIndexes,
  'khader': kKhaderSurahIndexes,
};

List<AudioCollection> buildAudioCollections(AppStrings strings) {
  final List<AudioCollection> base = [
    AudioCollection(
      id: 'recitation',
      label: strings.recitationLabel,
      manifestAsset: kAudioCollectionManifests['recitation']!,
      subtitleBuilder: (s) => s.recitationSubtitle,
    ),
    AudioCollection(
      id: 'english',
      label: strings.englishTranslationLabel,
      manifestAsset: kAudioCollectionManifests['english']!,
      subtitleBuilder: (s) => s.englishTranslationSubtitle,
    ),
    AudioCollection(
      id: 'kurdish',
      label: strings.kurdishTranslationLabel,
      manifestAsset: kAudioCollectionManifests['kurdish']!,
      subtitleBuilder: (s) => s.kurdishTranslationSubtitle,
    ),
    AudioCollection(
      id: 'sharif',
      label: strings.qariSharifLabel,
      manifestAsset: kAudioCollectionManifests['sharif']!,
      subtitleBuilder: (s) => s.qariSharifSubtitle,
    ),
  ];

  for (final entry in kAudioCollectionManifests.entries) {
    if (entry.key == 'recitation' ||
        entry.key == 'english' ||
        entry.key == 'kurdish' ||
        entry.key == 'sharif') {
      continue;
    }
    final fallbackName = kAudioCollectionNames[entry.key] ?? entry.key;
    base.add(
      AudioCollection(
        id: entry.key,
        label: strings.reciterNames[entry.key] ?? fallbackName,
        manifestAsset: entry.value,
        subtitleBuilder: (s) => s.reciterNames[entry.key] ?? fallbackName,
      ),
    );
  }
  return base;
}

Future<void> configureAudioSession() async {
  try {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  } catch (e) {
    if (kDebugMode) {
      debugPrint('AudioSession config failed: $e');
    }
  }
}

String normalizeGoogleDriveUrl(String url) {
  Uri? parsed;
  try {
    parsed = Uri.parse(url);
  } catch (_) {
    return url;
  }

  if (parsed.host.contains('drive.google.com')) {
    final fileId = parsed.queryParameters['id'];
    if (fileId != null && fileId.isNotEmpty) {
      return Uri.https('drive.usercontent.google.com', '/download', {
        'id': fileId,
        'export': 'download',
        'confirm': 't',
      }).toString();
    }
  }

  if (parsed.host.contains('drive.usercontent.google.com')) {
    final params = Map<String, String>.from(parsed.queryParameters);
    final fileId = params['id'];
    if (fileId != null && fileId.isNotEmpty) {
      params['export'] = params['export'] ?? 'download';
      params['confirm'] = params['confirm'] ?? 't';
      return Uri.https(parsed.host, parsed.path, params).toString();
    }
  }

  return url;
}

String resolveAudioUrl(String url) {
  final normalized = normalizeGoogleDriveUrl(url);
  if (kIsWeb) {
    final encoded = Uri.encodeComponent(normalized);
    return 'https://corsproxy.io/?$encoded';
  }
  return normalized;
}

class _QuranAudioTabState extends State<QuranAudioTab>
    with AutomaticKeepAliveClientMixin {
  late final AudioPlayer _player;
  final List<StreamSubscription> _playerSubscriptions = [];
  List<SurahAudio> _tracks = const [];
  bool _isLoading = true;
  bool _initError = false;
  String? _errorMessage;
  SurahAudio? _currentTrack;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Duration? _scrubPosition;
  bool _isPlaying = false;
  bool _playlistReady = false;
  Map<String, List<SurahAudio>> _tracksByCollection = {};
  late AudioCollection _selectedCollection;
  final Map<String, String> _downloadedPaths = {};
  final Map<String, double> _downloadProgress = {};
  String? _audioSearchQuery;
  final Set<String> _audioBookmarks = {};
  bool _showAudioBookmarksOnly = false;
  int _audioDeathRetries = 0;

  /// FIX RATIL-005: generation counter — incremented on every new load.
  /// Any async load whose generation doesn't match the current one is discarded.
  int _loadGeneration = 0;

  late List<AudioCollection> _collections;
  late AppLanguage _currentLanguage;

  @override
  void initState() {
    super.initState();
    try {
      _player = AudioPlayer();
    } catch (e) {
      debugPrint("Failed to initialize _player: $e");
    }
    _collections = buildAudioCollections(widget.strings);
    _currentLanguage = widget.language;
    _selectedCollection = _collections.first;
    _initAsync();
    _loadAudioBookmarks();
    _loadPersistedState(); // FIX RATIL-010: restore reciter + language
    
    // Self-Healing ExoPlayer Wrapper: Watch for native AudioTrack bounds
    _playerSubscriptions.add(
      _player.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace st) async {
        if (e is PlayerException) {
          final msg = e.message?.toLowerCase() ?? '';
          if (msg.contains('-6') || msg.contains('-32') || msg.contains('audiotrack') || msg.contains('offload')) {
             if (_audioDeathRetries < 3) {
                 _audioDeathRetries++;
                 debugPrint('[ExoPlayerHealer] Hardware track death ($msg). Self-healing try $_audioDeathRetries / 3');
                 try {
                   final currentIndex = _player.currentIndex ?? 0;
                   await _player.stop();
                   await Future.delayed(const Duration(milliseconds: 250));
                   // Rebuild exactly from the current tracks to force non-offloaded decoder
                   final recoveryPlaylist = _buildPlaylist(_tracks, _selectedCollection);
                   await _player.setAudioSource(recoveryPlaylist, initialIndex: currentIndex, initialPosition: _currentPosition);
                   await _player.play();
                 } catch (recoveryError) {
                   debugPrint('[ExoPlayerHealer] Recovery attempt failed: $recoveryError');
                 }
             } else {
                 debugPrint('[ExoPlayerHealer] Exhausted native audio retries.');
             }
          }
        }
      }),
    );

    _playerSubscriptions.add(
      _player.currentIndexStream.listen((index) {
        if (!mounted) return;
        if (index == null || index < 0 || index >= _tracks.length) return;
        setState(() {
          _currentTrack = _tracks[index];
        });
      }),
    );
    _playerSubscriptions.add(
      _player.positionStream.listen((pos) {
        if (!mounted) return;
        setState(() => _currentPosition = pos);
      }),
    );
    _playerSubscriptions.add(
      _player.durationStream.listen((dur) {
        if (!mounted || dur == null) return;
        setState(() => _totalDuration = dur);
      }),
    );
    _playerSubscriptions.add(
      _player.playerStateStream.listen((state) {
        if (!mounted) return;
        setState(() => _isPlaying = state.playing);
      }),
    );
  }

  @override
  void didUpdateWidget(covariant QuranAudioTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language != widget.language) {
      _handleLanguageChange(widget.language);
    }
    if (oldWidget.strings != widget.strings) {
      final updated = buildAudioCollections(widget.strings);
      AudioCollection? newSelection;
      for (final c in updated) {
        if (c.id == _selectedCollection.id) {
          newSelection = c;
          break;
        }
      }
      setState(() {
        _collections = updated;
        _selectedCollection = newSelection ?? updated.first;
      });
    }
  }

  Future<void> _initAsync() async {
    await configureAudioSession();
    await _subscribeAudioSessionEvents(); // CHAOS-001 + CHAOS-002
    await _loadAudioAssets();
  }

  // CHAOS-001: Pause immediately when a BT headset/earbuds disconnect.
  // CHAOS-002: Smart pause/resume around transient audio focus losses
  //            (navigation voice, phone calls, notification sounds).
  bool _wasPlayingBeforeInterruption = false;

  Future<void> _subscribeAudioSessionEvents() async {
    try {
      final session = await AudioSession.instance;

      // CHAOS-001 — Rogue Speaker: pause on BECOMING_NOISY.
      _playerSubscriptions.add(
        session.becomingNoisyEventStream.listen((_) {
          if (_isPlaying) _player.pause();
        }),
      );

      // CHAOS-002 — Phantom Navigator: smart pause/resume on focus loss.
      _playerSubscriptions.add(
        session.interruptionEventStream.listen((event) {
          if (event.begin) {
            _wasPlayingBeforeInterruption = _isPlaying;
            if (_wasPlayingBeforeInterruption) _player.pause();
          } else {
            // Only auto-resume if the interruption ended naturally
            // (not if the user manually paused during the interruption).
            if (_wasPlayingBeforeInterruption &&
                event.type != AudioInterruptionType.unknown) {
              _player.play();
            }
            _wasPlayingBeforeInterruption = false;
          }
        }),
      );
    } catch (e) {
      debugPrint('[Audio] AudioSession subscription failed: $e');
    }
  }

  Future<void> _loadAudioAssets() async {
    final gen = ++_loadGeneration; // FIX RATIL-005: stamp this load
    setState(() {
      _isLoading = true;
      _initError = false;
      _errorMessage = null;
    });
    final discovered = await _discoverTracksByCollection();
    final selectedCollection =
        _firstCollectionWithTracks(discovered) ?? _selectedCollection;
    final selectedTracks =
        discovered[selectedCollection.id] ?? const <SurahAudio>[];
    if (!mounted) return;
    if (gen != _loadGeneration) {
      return; // FIX RATIL-005: stale — newer load started
    }
    setState(() {
      _tracksByCollection = discovered;
      _selectedCollection = selectedCollection;
      _tracks = selectedTracks;
      _currentTrack = _tracks.isNotEmpty ? _tracks.first : null;
      _isLoading = false;
      _playlistReady = false;
    });
    if (selectedTracks.isEmpty) {
      setState(() {
        _initError = true;
        _errorMessage = widget.strings.noAudioMessage;
      });
      return;
    }
    await _preparePlaylist(selectedTracks, selectedCollection);
  }

  Future<void> _loadAudioBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('audio_bookmarks');
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = json.decode(raw) as List<dynamic>;
      final urls = <String>[];
      for (final entry in decoded) {
        final value = entry.toString();
        if (value.isEmpty || urls.contains(value)) continue;
        urls.add(value);
      }
      if (!mounted) return;
      setState(() {
        _audioBookmarks
          ..clear()
          ..addAll(urls);
      });
    } catch (_) {}
  }

  Future<void> _saveAudioBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _audioBookmarks.toList();
    await prefs.setString('audio_bookmarks', json.encode(list));
  }

  // FIX RATIL-010: Persist selected reciter and language across cold restarts.
  static const _kReciterKey = 'audio_last_reciter_id';
  static const _kLanguageKey = 'audio_last_language';

  Future<void> _loadPersistedState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString(_kReciterKey);
    final savedLang = prefs.getString(_kLanguageKey);
    if (!mounted) return;
    setState(() {
      if (savedId != null) {
        final match = _collections.where((c) => c.id == savedId).toList();
        if (match.isNotEmpty) _selectedCollection = match.first;
      }
      if (savedLang != null) {
        final lang = AppLanguage.values
            .where((l) => l.name == savedLang)
            .toList();
        if (lang.isNotEmpty) _currentLanguage = lang.first;
      }
    });
  }

  Future<void> _savePersistedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ok1 = await prefs.setString(_kReciterKey, _selectedCollection.id);
      final ok2 = await prefs.setString(_kLanguageKey, _currentLanguage.name);
      if (!ok1 || !ok2) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Storage full: preferences not saved.'),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('[Persist] Save failed: $e');
    }
  }

  void _toggleAudioBookmark(SurahAudio track) {
    final url = track.url;
    setState(() {
      if (_audioBookmarks.contains(url)) {
        _audioBookmarks.remove(url);
      } else {
        _audioBookmarks.add(url);
      }
    });
    _saveAudioBookmarks();
  }

  Future<Map<String, List<SurahAudio>>> _discoverTracksByCollection() async {
    try {
      String? basePath;
      if (!kIsWeb) {
        final downloadsDir = await getApplicationDocumentsDirectory();
        basePath = downloadsDir.path;
      }
      final Map<String, List<SurahAudio>> grouped = {};
      for (final collection in _collections) {
        final linksRaw = await rootBundle.loadString(collection.manifestAsset);
        final rawLines = linksRaw.split('\n');
        // FIX RATIL-004: iterate by fixed 0..113 index — never filter, never shift.
        final tracks = <SurahAudio>[]; // declared per-collection, not per-loop
        for (var i = 0; i < 114; i++) {
          final rawLine = i < rawLines.length ? rawLines[i].trim() : '';
          final validUrl = rawLine.isNotEmpty && rawLine.startsWith('http');
          final sourceUrl = validUrl ? rawLine : '';
          String? localPath;
          if (validUrl && basePath != null) {
            final localFile = File('$basePath/${_fileNameForUrl(sourceUrl)}');
            final exists = await localFile.exists();
            if (exists) {
              localPath = localFile.path;
              _downloadedPaths[sourceUrl] = localPath;
            }
          }
          final title = _titleFor(_currentLanguage, collection.id, i);
          final resolvedUrl = validUrl ? resolveAudioUrl(sourceUrl) : '';
          tracks.add(
            SurahAudio(title: title, url: resolvedUrl, localPath: localPath),
          );
        }
        grouped[collection.id] = tracks;
      }
      return grouped;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Manifest discovery failed: $e');
      }
      return {};
    }
  }

  void _handleLanguageChange(AppLanguage language) {
    _currentLanguage = language;
    if (_tracksByCollection.isEmpty) {
      return;
    }
    final Map<String, List<SurahAudio>> updated = {};
    _tracksByCollection.forEach((id, tracks) {
      final rebuilt = <SurahAudio>[];
      for (var i = 0; i < tracks.length; i++) {
        final track = tracks[i];
        final localizedTitle = _titleFor(language, id, i);
        rebuilt.add(
          SurahAudio(
            title: localizedTitle.isNotEmpty ? localizedTitle : track.title,
            url: track.url,
            localPath: track.localPath,
          ),
        );
      }
      updated[id] = rebuilt;
    });
    final refreshedTracks =
        updated[_selectedCollection.id] ?? const <SurahAudio>[];
    SurahAudio? newCurrent;
    if (refreshedTracks.isNotEmpty && _currentTrack != null) {
      newCurrent = refreshedTracks.firstWhere(
        (t) => t.url == _currentTrack!.url,
        orElse: () => refreshedTracks.first,
      );
    } else if (refreshedTracks.isNotEmpty) {
      newCurrent = refreshedTracks.first;
    }
    setState(() {
      _tracksByCollection = updated;
      _tracks = refreshedTracks;
      _currentTrack = newCurrent;
    });
  }

  AudioCollection? _firstCollectionWithTracks(
    Map<String, List<SurahAudio>> grouped,
  ) {
    for (final collection in _collections) {
      final tracks = grouped[collection.id];
      if (tracks != null && tracks.isNotEmpty) return collection;
    }
    return null;
  }

  Future<void> _preparePlaylist(
    List<SurahAudio> tracks,
    AudioCollection collection,
  ) async {
    try {
      final playlist = _buildPlaylist(tracks, collection);
      if (_player.playing) {
        await _player.stop();
      }
      await _player.setAudioSource(playlist);
      setState(() {
        _playlistReady = true;
        _initError = false;
        _errorMessage = null;
      });
    } on PlayerException catch (e) {
      // CHAOS-003: Captive portal returns HTML / 404. ExoPlayer throws
      // PlayerException with a non-audio content-type. Show a clear error.
      if (!mounted) return;
      setState(() {
        _initError = true;
        _playlistReady = false;
        _errorMessage =
            'Audio source error (${e.code}): Check your internet connection or try again later.';
      });
      debugPrint('[Audio] PlayerException in setAudioSource: ${e.message}');
      try {
        await _player.stop();
      } catch (_) {}
    } on PlayerInterruptedException {
      // Reciter was switched mid-load — the generation counter handles this.
      debugPrint('[Audio] Player interrupted — newer load in progress.');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _initError = true;
        _playlistReady = false;
        _errorMessage = 'Unexpected audio error. Please try again.';
      });
      debugPrint('[Audio] Unknown audio init error: $e');
      try {
        await _player.stop();
      } catch (_) {}
    }
  }

  String _fileNameForUrl(String url) {
    final safe = base64Url.encode(utf8.encode(url));
    return 'audio_$safe.mp3';
  }

  String _titleFor(AppLanguage language, String collectionId, int index) {
    final custom = kAudioCustomSurahIndexes[collectionId];
    final titles = _titlesForLanguage(language);
    if (custom != null) {
      if (index < custom.length) {
        final surahNumber = custom[index];
        if (surahNumber > 0 && surahNumber <= titles.length) {
          return titles[surahNumber - 1];
        }
      }
      return '';
    }
    if (index < titles.length) {
      return titles[index];
    }
    return '';
  }

  List<String> _titlesForLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.arabic:
        return kSurahNamesArabic;
      case AppLanguage.kurdish:
        return kSurahNamesKurdish;
      case AppLanguage.english:
        return kSurahNamesEnglish;
    }
  }

  ConcatenatingAudioSource _buildPlaylist(
    List<SurahAudio> tracks,
    AudioCollection collection,
  ) {
    return ConcatenatingAudioSource(
      children: tracks.map((track) {
        final local = _downloadedPaths[track.url] ?? track.localPath;
        final uri = local != null ? Uri.file(local) : Uri.parse(track.url);
        return AudioSource.uri(
          uri,
          tag: MediaItem(
            id: track.url,
            album: collection.label,
            title: track.title,
            artist: collection.subtitle(widget.strings),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _togglePlay(SurahAudio track) async {
    if (!_playlistReady) {
      await _preparePlaylist(_tracks, _selectedCollection);
      if (!_playlistReady) return;
    }
    final index = _tracks.indexWhere((t) => t.url == track.url);
    if (index == -1) return;
    if (!_playlistReady) return;
    if (_player.currentIndex != index) {
      await _player.seek(Duration.zero, index: index);
      await _player.play();
    } else {
      if (_isPlaying) {
        await _player.pause();
      } else {
        await _player.play();
      }
    }
  }

  List<SurahAudio> _filterTracks() {
    final q = (_audioSearchQuery ?? '').trim().toLowerCase();
    Iterable<SurahAudio> filtered = _tracks;
    if (_showAudioBookmarksOnly) {
      filtered = filtered.where((t) => _audioBookmarks.contains(t.url));
    }
    if (q.isNotEmpty) {
      filtered = filtered.where((t) {
        final title = t.title.toLowerCase();
        if (title.contains(q)) return true;
        // Allow numeric search by surah number at the end of the title.
        final digits = RegExp(r'(\d+)').firstMatch(title)?.group(1);
        return digits != null && digits.startsWith(q);
      });
    }
    return filtered.toList(growable: false);
  }

  Future<void> _downloadAndSave(SurahAudio track) async {
    if (kIsWeb) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Offline downloads are not supported on web yet.'),
        ),
      );
      return;
    }
    final url = track.url;
    if (_downloadProgress.containsKey(url)) return;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${_fileNameForUrl(url)}');
    setState(() {
      _downloadProgress[url] = 0.0;
    });

    final client = http.Client();
    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);
      if (response.statusCode >= 400) {
        throw Exception('HTTP ${response.statusCode}');
      }
      final total = response.contentLength;
      int received = 0;
      final sink = file.openWrite();
      await for (final chunk in response.stream) {
        received += chunk.length;
        sink.add(chunk);
        if (total != null) {
          setState(() {
            _downloadProgress[url] = received / total;
          });
        }
      }
      await sink.flush();
      await sink.close();
      if (!mounted) return;
      setState(() {
        _downloadedPaths[url] = file.path;
        _downloadProgress.remove(url);
        _tracks = _tracks
            .map((t) => t.url == url ? t.withLocalPath(file.path) : t)
            .toList(growable: false);
        _tracksByCollection[_selectedCollection.id] = _tracks;
      });
      await _preparePlaylist(_tracks, _selectedCollection);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _downloadProgress.remove(url);
      });
      if (kDebugMode) {
        debugPrint('Download failed: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed for ${track.title}')),
      );
    } finally {
      client.close();
    }
  }

  Widget _buildCollectionSelector() {
    final palette = ThemePalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: palette.panelColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AudioCollection>(
          value: _selectedCollection,
          isExpanded: true,
          dropdownColor: palette.navBackground,
          iconEnabledColor: palette.textColor,
          style: TextStyle(
            color: palette.textColor,
            fontWeight: FontWeight.w600,
          ),
          items: _collections
              .map(
                (collection) => DropdownMenuItem<AudioCollection>(
                  value: collection,
                  child: Text(collection.label),
                ),
              )
              .toList(),
          onChanged: (collection) {
            if (collection == null || collection.id == _selectedCollection.id) {
              return;
            }
            _switchToCollection(collection);
          },
        ),
      ),
    );
  }

  // CHAOS-007: Debounce — ignore rapid reciter taps within 300 ms.
  DateTime? _lastCollectionSwitch;

  Future<void> _switchToCollection(AudioCollection collection) async {
    // 300 ms debounce: discard taps that arrive too quickly.
    final now = DateTime.now();
    if (_lastCollectionSwitch != null &&
        now.difference(_lastCollectionSwitch!) <
            const Duration(milliseconds: 300)) {
      return;
    }
    _lastCollectionSwitch = now;

    final tracks = _tracksByCollection[collection.id] ?? const <SurahAudio>[];
    setState(() {
      _selectedCollection = collection;
      _tracks = tracks;
      _currentTrack = tracks.isNotEmpty ? tracks.first : null;
      _playlistReady = false;
      _initError = false;
      _errorMessage = null;
    });

    // CHAOS-007: Flush the native ExoPlayer queue before loading new source.
    try {
      await _player.stop();
    } catch (_) {}

    if (tracks.isEmpty) {
      setState(() {
        _initError = true;
        _errorMessage = widget.strings.noAudioMessage;
      });
      return;
    }
    await _savePersistedState(); // persist the new reciter choice
    await _preparePlaylist(tracks, collection);
  }

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) return '--:--';
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    for (final sub in _playerSubscriptions) {
      sub.cancel();
    }
    _player.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final palette = ThemePalette.of(context);
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final errorText = _initError
        ? _errorMessage ??
              'Failed to load audio assets. Please reinstall or check storage.'
        : null;
    final visibleTracks = _filterTracks();
    final hasTracks = visibleTracks.isNotEmpty;
    final emptyMessage = _showAudioBookmarksOnly
        ? 'No bookmarked surahs yet.'
        : widget.strings.noAudioMessage;

    return Column(
      children: [
        _buildCollectionSelector(),
        const SizedBox(height: 10),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  errorText,
                  style: TextStyle(
                    color: palette.mutedTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _loadAudioAssets,
                  icon: const Icon(Icons.refresh),
                  label: Text(widget.strings.retryLabel),
                ),
              ],
            ),
          )
        else
          _buildNowPlayingCard(),
        if (_tracks.isNotEmpty) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) =>
                  setState(() => _audioSearchQuery = value.trim()),
              decoration: InputDecoration(
                hintText: 'Search surah',
                prefixIcon: Icon(
                  Icons.search,
                  color: ThemePalette.of(context).mutedTextColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  selected: !_showAudioBookmarksOnly,
                  label: const Text('All'),
                  onSelected: (_) =>
                      setState(() => _showAudioBookmarksOnly = false),
                ),
                ChoiceChip(
                  selected: _showAudioBookmarksOnly,
                  label: Text('Bookmarks (${_audioBookmarks.length})'),
                  onSelected: (_) =>
                      setState(() => _showAudioBookmarksOnly = true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 1),
        Expanded(
          child: hasTracks
              ? ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: visibleTracks.length,
                  itemBuilder: (context, index) {
                    final track = visibleTracks[index];
                    final isSelected = track.url == _currentTrack?.url;
                    final isPlaying = isSelected && _isPlaying;
                    final localPath =
                        _downloadedPaths[track.url] ?? track.localPath;
                    final downloading = _downloadProgress[track.url];
                    final isBookmarked = _audioBookmarks.contains(track.url);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? palette.navIndicator
                              : palette.cardColor,
                          borderRadius: BorderRadius.circular(kCardRadius),
                          border: Border.all(
                            color: isSelected
                                ? palette.accent
                                : palette.cardBorder,
                            width: 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: palette.accent.withValues(
                                      alpha: 0.18,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ]
                              : null,
                        ),
                        child: ListTile(
                          title: Text(
                            track.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: palette.textColor,
                            ),
                            textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: true,
                              applyHeightToLastDescent: true,
                            ),
                            overflow: TextOverflow.clip,
                          ),
                          subtitle: Text(
                            _selectedCollection.subtitle(widget.strings),
                            style: TextStyle(
                              color: palette.mutedTextColor,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: isBookmarked
                                    ? 'Remove bookmark'
                                    : 'Bookmark',
                                icon: Icon(
                                  isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_add_outlined,
                                ),
                                color: isBookmarked
                                    ? palette.accent
                                    : palette.mutedTextColor,
                                onPressed: () => _toggleAudioBookmark(track),
                              ),
                              if (downloading != null)
                                SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: CircularProgressIndicator(
                                    value: downloading,
                                    strokeWidth: 3,
                                    color: palette.accent,
                                  ),
                                )
                              else
                                IconButton(
                                  tooltip: localPath != null
                                      ? 'Downloaded'
                                      : 'Download for offline',
                                  icon: Icon(
                                    localPath != null
                                        ? Icons.check_circle
                                        : Icons.download_for_offline_outlined,
                                  ),
                                  color: localPath != null
                                      ? palette.accent
                                      : palette.mutedTextColor,
                                  onPressed: localPath != null
                                      ? null
                                      : () => _downloadAndSave(track),
                                ),
                              IconButton(
                                iconSize: 35,
                                icon: Icon(
                                  isPlaying
                                      ? Icons.pause_circle
                                      : Icons.play_circle,
                                ),
                                color: palette.accent,
                                onPressed: () => _togglePlay(track),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      emptyMessage,
                      style: TextStyle(color: palette.mutedTextColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildNowPlayingCard() {
    final palette = ThemePalette.of(context);
    if (_currentTrack == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: palette.cardColor,
          borderRadius: BorderRadius.circular(kCardRadius),
          border: Border.all(color: palette.cardBorder),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: palette.mutedTextColor, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.strings.selectInstruction,
                style: TextStyle(color: palette.mutedTextColor, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }
    if (!_playlistReady) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: palette.cardColor,
          borderRadius: BorderRadius.circular(kCardRadius),
          border: Border.all(color: palette.cardBorder),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: palette.accent,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.strings.preparingAudio,
                style: TextStyle(color: palette.mutedTextColor, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    final maxMillis = _totalDuration.inMilliseconds == 0
        ? 1
        : _totalDuration.inMilliseconds;
    final sliderBaseValue = (_scrubPosition ?? _currentPosition).inMilliseconds;
    final clampedSliderValue = sliderBaseValue.clamp(0, maxMillis);
    final sliderValue = clampedSliderValue.toDouble();
    final displayPosition = Duration(milliseconds: clampedSliderValue.round());

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.strings.nowPlaying,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _currentTrack!.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            _selectedCollection.subtitle(widget.strings),
            style: TextStyle(color: palette.mutedTextColor, fontSize: 12),
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              value: sliderValue,
              min: 0,
              max: maxMillis.toDouble(),
              activeColor: palette.accent,
              inactiveColor: palette.cardBorder,
              onChangeStart: (value) {
                setState(() {
                  _scrubPosition = Duration(milliseconds: value.round());
                });
              },
              onChanged: (value) {
                setState(() {
                  _scrubPosition = Duration(milliseconds: value.round());
                });
              },
              onChangeEnd: (value) async {
                final newPosition = Duration(milliseconds: value.round());
                setState(() {
                  _scrubPosition = null;
                  _currentPosition = newPosition;
                });
                await _player.seek(newPosition);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(displayPosition),
                style: TextStyle(color: palette.mutedTextColor),
              ),
              Text(
                _formatDuration(_totalDuration),
                style: TextStyle(color: palette.mutedTextColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: 'Previous',
                iconSize: 32,
                onPressed: _player.hasPrevious ? _player.seekToPrevious : null,
                icon: const Icon(Icons.skip_previous),
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: _isPlaying ? 'Pause' : 'Play',
                iconSize: 40,
                onPressed: () => _togglePlay(_currentTrack!),
                icon: Icon(
                  _isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: 'Next',
                iconSize: 32,
                onPressed: _player.hasNext ? _player.seekToNext : null,
                icon: const Icon(Icons.skip_next),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TranslationOption {
  const TranslationOption({
    required this.id,
    required this.label,
    required this.asset,
  });

  final String id;
  final String label;
  final String asset;
}

const List<TranslationOption> _fallbackTranslationOptions = [
  TranslationOption(
    id: 'en.sahih',
    label: 'English - Sahih',
    asset: 'asset/translations/en.sahih.json',
  ),
  TranslationOption(
    id: 'ku.asan',
    label: 'Kurdish - Asan',
    asset: 'asset/translations/ku.asan.json',
  ),
  TranslationOption(
    id: 'ar.muyassar',
    label: 'Arabic - Muyassar',
    asset: 'asset/translations/ar.muyassar.json',
  ),
];

List<TranslationOption> kTranslationOptions = List<TranslationOption>.from(
  _fallbackTranslationOptions,
);

class _TranslationCatalogEntry {
  const _TranslationCatalogEntry({
    required this.id,
    required this.language,
    required this.translator,
  });

  final String id;
  final String language;
  final String translator;

  factory _TranslationCatalogEntry.fromJson(Map<String, dynamic> json) {
    return _TranslationCatalogEntry(
      id: (json['id'] ?? '').toString(),
      language: (json['language'] ?? '').toString(),
      translator: (json['translator'] ?? '').toString(),
    );
  }
}

const Map<String, String> _translationLanguageNames = {
  'ar': 'Arabic',
  'az': 'Azerbaijani',
  'bg': 'Bulgarian',
  'bn': 'Bengali',
  'bs': 'Bosnian',
  'cs': 'Czech',
  'de': 'German',
  'dv': 'Divehi',
  'en': 'English',
  'es': 'Spanish',
  'fa': 'Persian',
  'fr': 'French',
  'ha': 'Hausa',
  'hi': 'Hindi',
  'id': 'Indonesian',
  'it': 'Italian',
  'ja': 'Japanese',
  'ko': 'Korean',
  'ku': 'Kurdish',
  'ml': 'Malayalam',
  'ms': 'Malay',
  'nl': 'Dutch',
  'no': 'Norwegian',
  'pl': 'Polish',
  'pt': 'Portuguese',
  'ro': 'Romanian',
  'ru': 'Russian',
  'sd': 'Sindhi',
  'so': 'Somali',
  'sq': 'Albanian',
  'sv': 'Swedish',
};

String _translationLanguageName(String code) {
  return _translationLanguageNames[code] ?? code.toUpperCase();
}

String _formatTranslatorName(String raw) {
  if (raw.isEmpty) return raw;
  final spaced = raw.replaceAll(RegExp(r'[_-]+'), ' ');
  final words = spaced.split(' ');
  return words
      .where((word) => word.isNotEmpty)
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}

List<TranslationOption> _buildTranslationOptionsFromCatalog(
  List<_TranslationCatalogEntry> entries,
) {
  if (entries.isEmpty) {
    return List<TranslationOption>.from(_fallbackTranslationOptions);
  }
  final totals = <String, int>{};
  for (final entry in entries) {
    totals.update(entry.language, (value) => value + 1, ifAbsent: () => 1);
  }
  final seen = <String, int>{};
  return entries.map((entry) {
    final languageName = _translationLanguageName(entry.language);
    final total = totals[entry.language] ?? 1;
    final index = (seen[entry.language] ?? 0) + 1;
    seen[entry.language] = index;
    final indexSuffix = total > 1 ? ' $index' : '';
    final translatorSuffix = total > 1 && entry.translator.isNotEmpty
        ? ' (${_formatTranslatorName(entry.translator)})'
        : '';
    return TranslationOption(
      id: entry.id,
      label: '$languageName$indexSuffix$translatorSuffix',
      asset: 'asset/translations/${entry.id}.json',
    );
  }).toList();
}

Future<List<TranslationOption>> _loadTranslationOptions() async {
  try {
    final raw = await rootBundle.loadString('asset/translations/index.json');
    final decoded = json.decode(raw) as List<dynamic>;
    final entries = decoded
        .whereType<Map<String, dynamic>>()
        .map(_TranslationCatalogEntry.fromJson)
        .where((entry) => entry.id.isNotEmpty)
        .toList();
    return _buildTranslationOptionsFromCatalog(entries);
  } catch (_) {
    return List<TranslationOption>.from(_fallbackTranslationOptions);
  }
}

class _ArabicSurah {
  const _ArabicSurah({
    required this.number,
    required this.name,
    required this.transliteration,
    required this.verses,
  });

  final int number;
  final String name;
  final String transliteration;
  final List<_ArabicVerse> verses;
}

class _ArabicVerse {
  const _ArabicVerse({
    required this.number,
    required this.section,
    required this.content,
  });

  final int number;
  final int section;
  final String content;
}

class _VerseDisplay {
  const _VerseDisplay({
    required this.surahNumber,
    required this.surahTitle,
    required this.surahArabic,
    required this.verseNumber,
    required this.section,
    required this.arabic,
    required this.translation,
  });

  final int surahNumber;
  final String surahTitle;
  final String surahArabic;
  final int verseNumber;
  final int section;
  final String arabic;
  final String translation;
}

class _TajweedSegment {
  const _TajweedSegment({
    required this.start,
    required this.end,
    required this.rule,
  });

  final int start;
  final int end;
  final String rule;
}

class _SurahSummary {
  const _SurahSummary({
    required this.surahNumber,
    required this.surahTitle,
    required this.surahArabic,
    required this.section,
    required this.verseCount,
    required this.verses,
  });

  final int surahNumber;
  final String surahTitle;
  final String surahArabic;
  final int section;
  final int verseCount;
  final List<_VerseDisplay> verses;
}

class _JuzGroup {
  const _JuzGroup({
    required this.number,
    required this.startSurahTitle,
    required this.verses,
    required this.surahSummaries,
  });

  final int number;
  final String startSurahTitle;
  final List<_VerseDisplay> verses;
  final List<_SurahSummary> surahSummaries;
}

enum _ReadLabel {
  readHint,
  quranTab,
  bookmarksTab,
  searchHint,
  searchHelper,
  searchResults,
  continues,
  noResults,
  noBookmarks,
  medinan,
  meccan,
  verse,
  verses,
  surah,
  surahs,
  page,
  firstWord,
  translationUnavailable,
  copy,
  share,
  bookmark,
  saved,
  nowPlaying,
  stop,
  previous,
  next,
  selectSurah,
  audioUnavailable,
  audioError,
}

class QuranReadTab extends StatefulWidget {
  const QuranReadTab({
    super.key,
    required this.strings,
    required this.language,
    required this.translation,
    required this.textScale,
  });

  final AppStrings strings;
  final AppLanguage language;
  final TranslationOption translation;
  final double textScale;

  @override
  State<QuranReadTab> createState() => _QuranReadTabState();
}

class _QuranReadTabState extends State<QuranReadTab> {
  bool _loading = true;
  String? _error;
  List<_JuzGroup> _juzGroups = [];
  Map<String, _VerseDisplay> _bookmarks = {};
  bool _showBookmarks = false;
  final Map<int, String> _arabicSurahNames = {};
  final Map<int, JuzMeta> _juzMetaByNumber = {};
  final Map<int, _SurahMeta> _surahMetaByNumber = {};
  final Map<int, Map<int, List<_TajweedSegment>>> _tajweedBySurah = {};
  final Set<int> _tajweedLoading = {};
  final Map<int, int> _surahPageStarts = {};
  String _searchQuery = '';
  late final AudioPlayer _juzPlayer;
  StreamSubscription<PlayerState>? _juzPlayerSubscription;
  List<AudioCollection> _audioCollections = const [];
  AudioCollection? _selectedAudioCollection;
  final Map<String, List<String>> _audioUrlsByCollection = {};
  bool _audioLoading = false;
  late final AudioPlayer _versePlayer;
  StreamSubscription<PlayerState>? _versePlayerSubscription;
  final Map<int, String> _verseAudioAssetsBySurah = {};
  final Map<int, List<String>> _verseAudioUrlsBySurah = {};
  bool _verseAudioLoading = false;
  String? _currentVerseAudioKey;
  bool _isVersePlaying = false;
  int? _playingSurahNumber;
  String? _currentAudioUrl;
  bool _isJuzPlaying = false;
  static const Set<int> _repeatableSurahs = {2, 4};
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Duration? _scrubPosition;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration?>? _durationSubscription;

  @override
  void initState() {
    super.initState();
    try {
      _juzPlayer = AudioPlayer();
    } catch (e) {
      debugPrint("Failed to initialize _juzPlayer: $e");
    }
    try {
      _versePlayer = AudioPlayer();
    } catch (e) {
      debugPrint("Failed to initialize _versePlayer: $e");
    }
    _loadTexts();
    _loadBookmarks();
    _initJuzAudio();
    _versePlayerSubscription = _versePlayer.playerStateStream.listen((state) {
      if (!mounted) return;
      final completed = state.processingState == ProcessingState.completed;
      setState(() {
        _isVersePlaying = state.playing && !completed;
        if (completed) {
          _currentVerseAudioKey = null;
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant QuranReadTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language != widget.language ||
        oldWidget.translation.id != widget.translation.id) {
      _loadTexts();
    }
    if (oldWidget.strings != widget.strings) {
      _refreshAudioCollections();
    }
  }

  @override
  void dispose() {
    _juzPlayerSubscription?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _juzPlayer.dispose();
    _versePlayerSubscription?.cancel();
    _versePlayer.dispose();
    super.dispose();
  }

  void _initJuzAudio() {
    _audioCollections = buildAudioCollections(widget.strings);
    _selectedAudioCollection = _audioCollections.isEmpty
        ? null
        : _audioCollections.first;
    _juzPlayerSubscription = _juzPlayer.playerStateStream.listen((state) {
      if (!mounted) return;
      final isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _juzPlayer.seek(Duration.zero);
        _juzPlayer.pause();
        setState(() {
          _currentPosition = Duration.zero;
          _scrubPosition = null;
          _isJuzPlaying = false;
        });
        return;
      }
      setState(() => _isJuzPlaying = isPlaying);
    });
    _positionSubscription = _juzPlayer.positionStream.listen((position) {
      if (!mounted) return;
      if (_scrubPosition != null) return;
      setState(() => _currentPosition = position);
    });
    _durationSubscription = _juzPlayer.durationStream.listen((duration) {
      if (!mounted) return;
      setState(() => _totalDuration = duration ?? Duration.zero);
    });
    configureAudioSession();
  }

  void _refreshAudioCollections() {
    final updated = buildAudioCollections(widget.strings);
    AudioCollection? nextSelection;
    if (_selectedAudioCollection != null) {
      for (final c in updated) {
        if (c.id == _selectedAudioCollection!.id) {
          nextSelection = c;
          break;
        }
      }
    }
    setState(() {
      _audioCollections = updated;
      _selectedAudioCollection = nextSelection ?? updated.first;
    });
  }

  String _readLabel(_ReadLabel label) {
    final s = widget.strings;
    return switch (label) {
      _ReadLabel.readHint => s.quranReadHint,
      _ReadLabel.quranTab => s.quranTabLabel,
      _ReadLabel.bookmarksTab => s.bookmarksLabel,
      _ReadLabel.searchHint => s.searchHint,
      _ReadLabel.searchHelper => s.searchHelper,
      _ReadLabel.searchResults => s.searchResultsLabel,
      _ReadLabel.continues => s.continueLabel,
      _ReadLabel.noResults => s.noResultsLabel,
      _ReadLabel.noBookmarks => s.noBookmarksLabel,
      _ReadLabel.medinan => s.medinanLabel,
      _ReadLabel.meccan => s.meccanLabel,
      _ReadLabel.verse => s.verseLabel,
      _ReadLabel.verses => s.versesLabel,
      _ReadLabel.surah => s.surahLabel,
      _ReadLabel.surahs => s.surahsLabel,
      _ReadLabel.page => s.pageLabel,
      _ReadLabel.firstWord => s.firstWordLabel,
      _ReadLabel.translationUnavailable => s.translationUnavailableMessage,
      _ReadLabel.copy => s.copyLabel,
      _ReadLabel.share => s.shareLabel,
      _ReadLabel.bookmark => s.bookmarkLabel,
      _ReadLabel.saved => s.savedLabel,
      _ReadLabel.nowPlaying => s.nowPlaying,
      _ReadLabel.stop => s.stopLabel,
      _ReadLabel.previous => s.previousLabel,
      _ReadLabel.next => s.nextLabel,
      _ReadLabel.selectSurah => s.selectSurahLabel,
      _ReadLabel.audioUnavailable => s.audioUnavailableMessage,
      _ReadLabel.audioError => s.audioErrorMessage,
    };
  }

  String _surahCountText(int count) {
    final label = count == 1
        ? widget.strings.surahLabel
        : widget.strings.surahsLabel;
    return '$count $label';
  }

  String _verseCountText(int count) {
    final label = count == 1
        ? widget.strings.verseLabel
        : widget.strings.versesLabel;
    return '$count $label';
  }

  String _juzLabel(int number) {
    final labelNumber = number.toString().padLeft(2, '0');
    return '${widget.strings.juzLabel} $labelNumber';
  }

  JuzMeta? _juzInfo(int number) {
    return _juzMetaByNumber[number];
  }

  String _juzRangeLabel(JuzMeta info) {
    final startName = _surahLabelForJuz(
      info.startSurahNumber,
      info.startSurahName,
    );
    final endName = _surahLabelForJuz(info.endSurahNumber, info.endSurahName);
    final verseLabel = _readLabel(_ReadLabel.verse);
    return '$startName $verseLabel ${info.startVerse} - '
        '$endName $verseLabel ${info.endVerse}';
  }

  String _surahLabelForJuz(int surahNumber, String fallback) {
    final name = _surahNameForLanguage(surahNumber);
    if (name.startsWith('Surah ') && fallback.isNotEmpty) {
      return fallback;
    }
    return name;
  }

  String _surahNameForLanguage(int surahNumber) {
    final List<String> names = switch (widget.language) {
      AppLanguage.arabic => kSurahNamesArabic,
      AppLanguage.kurdish => kSurahNamesKurdish,
      AppLanguage.english => kSurahNamesEnglish,
    };
    if (surahNumber <= 0 || surahNumber > names.length) {
      return 'Surah $surahNumber';
    }
    return names[surahNumber - 1];
  }

  String _audioActionLabel(bool isPlaying) {
    switch (widget.language) {
      case AppLanguage.arabic:
        return isPlaying ? 'إيقاف مؤقت' : 'تشغيل';
      case AppLanguage.kurdish:
        return isPlaying ? 'وەستان' : 'گوێگرتن';
      case AppLanguage.english:
        return isPlaying ? 'Pause' : 'Play';
    }
  }

  String _audioUnavailableMessage(String surahLabel, String reciterLabel) {
    switch (widget.language) {
      case AppLanguage.arabic:
        return 'الصوت غير متاح للسورة $surahLabel مع $reciterLabel.';
      case AppLanguage.kurdish:
        return 'دەنگ بەردەست نییە بۆ $surahLabel لەگەڵ $reciterLabel.';
      case AppLanguage.english:
        return 'Audio not available for $surahLabel with $reciterLabel.';
    }
  }

  String _verseAudioKey(_VerseDisplay verse) {
    return '${verse.surahNumber}:${verse.verseNumber}';
  }

  Future<void> _ensureVerseAudioAssets() async {
    if (_verseAudioAssetsBySurah.isNotEmpty) return;
    final raw = await rootBundle.loadString('AssetManifest.json');
    final data = json.decode(raw) as Map<String, dynamic>;
    for (final asset in data.keys) {
      if (!asset.startsWith('asset/Audio_link/')) continue;
      final filename = asset.split('/').last;
      final match = RegExp(r'^(\d+)').firstMatch(filename);
      if (match == null) continue;
      final number = int.tryParse(match.group(1) ?? '');
      if (number == null) continue;
      _verseAudioAssetsBySurah[number] = asset;
    }
  }

  Future<List<String>> _loadVerseAudioUrls(int surahNumber) async {
    final cached = _verseAudioUrlsBySurah[surahNumber];
    if (cached != null) return cached;
    await _ensureVerseAudioAssets();
    final asset = _verseAudioAssetsBySurah[surahNumber];
    if (asset == null) return const [];
    final raw = await rootBundle.loadString(asset);
    final urls = raw
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);
    _verseAudioUrlsBySurah[surahNumber] = urls;
    return urls;
  }

  int _audioIndexForVerse(_VerseDisplay verse, int urlCount) {
    final verseCount = _surahMetaByNumber[verse.surahNumber]?.verseCount ?? 0;
    final baseIndex = verse.verseNumber - 1;
    if (verseCount <= 0 || urlCount == verseCount) {
      return baseIndex;
    }
    final diff = urlCount - verseCount;
    if (diff == 1 && verse.surahNumber != 1) {
      return baseIndex + 1;
    }
    if (diff == -1 && baseIndex > 0) {
      return baseIndex - 1;
    }
    if (diff.abs() <= 1) {
      return baseIndex + diff;
    }
    return baseIndex;
  }

  Future<void> _toggleVerseAudio(_VerseDisplay verse) async {
    if (_verseAudioLoading) return;
    setState(() => _verseAudioLoading = true);
    try {
      final urls = await _loadVerseAudioUrls(verse.surahNumber);
      final index = _audioIndexForVerse(verse, urls.length);
      if (index < 0 || index >= urls.length) {
        _showAudioSnack(_readLabel(_ReadLabel.audioUnavailable));
        return;
      }
      final url = resolveAudioUrl(urls[index]);
      final key = _verseAudioKey(verse);
      final isSame = _currentVerseAudioKey == key;
      if (isSame && _isVersePlaying) {
        await _versePlayer.pause();
      } else {
        await _juzPlayer.pause();
        await _versePlayer.setAudioSource(AudioSource.uri(Uri.parse(url)));
        await _versePlayer.play();
        _currentVerseAudioKey = key;
      }
    } catch (_) {
      _showAudioSnack(_readLabel(_ReadLabel.audioError));
    } finally {
      if (mounted) {
        setState(() => _verseAudioLoading = false);
      }
    }
  }

  Future<void> _switchAudioCollection(AudioCollection collection) async {
    if (_selectedAudioCollection?.id == collection.id) return;
    setState(() {
      _selectedAudioCollection = collection;
      _playingSurahNumber = null;
      _currentAudioUrl = null;
      _isJuzPlaying = false;
      _currentPosition = Duration.zero;
      _totalDuration = Duration.zero;
      _scrubPosition = null;
    });
    await _juzPlayer.stop();
  }

  Future<List<String>> _loadCollectionUrls(AudioCollection collection) async {
    final cached = _audioUrlsByCollection[collection.id];
    if (cached != null) return cached;
    final raw = await rootBundle.loadString(collection.manifestAsset);
    final urls = raw
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty && line.startsWith('http'))
        .toList(growable: false);
    _audioUrlsByCollection[collection.id] = urls;
    return urls;
  }

  int _audioIndexForSurah(AudioCollection collection, int surahNumber) {
    final custom = kAudioCustomSurahIndexes[collection.id];
    if (custom == null) return surahNumber - 1;
    return custom.indexOf(surahNumber);
  }

  Future<void> _toggleSurahAudio({
    required int surahNumber,
    required String surahLabel,
  }) async {
    final collection = _selectedAudioCollection;
    if (collection == null || _audioLoading) return;
    setState(() => _audioLoading = true);
    try {
      final urls = await _loadCollectionUrls(collection);
      final index = _audioIndexForSurah(collection, surahNumber);
      if (index < 0 || index >= urls.length) {
        _showAudioSnack(_audioUnavailableMessage(surahLabel, collection.label));
        return;
      }
      final url = resolveAudioUrl(urls[index]);
      final isSameAudio = _currentAudioUrl == url;
      if (isSameAudio) {
        if (_isJuzPlaying) {
          await _juzPlayer.pause();
        } else {
          await _juzPlayer.play();
        }
      } else {
        await _juzPlayer.setUrl(url);
        await _juzPlayer.play();
      }
      if (!mounted) return;
      setState(() {
        _playingSurahNumber = surahNumber;
        _currentAudioUrl = url;
        if (!isSameAudio) {
          _currentPosition = Duration.zero;
          _totalDuration = Duration.zero;
          _scrubPosition = null;
        }
      });
    } catch (_) {
      _showAudioSnack(_readLabel(_ReadLabel.audioError));
    } finally {
      if (mounted) {
        setState(() => _audioLoading = false);
      }
    }
  }

  void _showAudioSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _loadMetadata() async {
    if (_juzMetaByNumber.isNotEmpty && _surahMetaByNumber.isNotEmpty) {
      return;
    }
    try {
      final rawJuz = await rootBundle.loadString('asset/juz.json');
      final rawSurah = await rootBundle.loadString('asset/surah.json');
      final juzData = json.decode(rawJuz) as List<dynamic>;
      final surahData = json.decode(rawSurah) as List<dynamic>;

      final juzMap = <int, JuzMeta>{};
      for (final item in juzData) {
        if (item is! Map<String, dynamic>) continue;
        final number = _parseIntValue(item['index']);
        final start = item['start'] as Map<String, dynamic>? ?? {};
        final end = item['end'] as Map<String, dynamic>? ?? {};
        final startSurahNumber = _parseIntValue(start['index']);
        final endSurahNumber = _parseIntValue(end['index']);
        final startVerse = _parseVerseKey(start['verse']?.toString() ?? '');
        final endVerse = _parseVerseKey(end['verse']?.toString() ?? '');
        if (number == 0) continue;
        juzMap[number] = JuzMeta(
          number: number,
          startSurahNumber: startSurahNumber,
          startSurahName: (start['name'] ?? '').toString(),
          startVerse: startVerse,
          endSurahNumber: endSurahNumber,
          endSurahName: (end['name'] ?? '').toString(),
          endVerse: endVerse,
        );
      }

      final surahMap = <int, _SurahMeta>{};
      for (final item in surahData) {
        if (item is! Map<String, dynamic>) continue;
        final number = _parseIntValue(item['index']);
        if (number == 0) continue;
        final rawTitleAr = (item['titleAr'] ?? '').toString();
        final titleAr = rawTitleAr.runes.any((r) => r >= 0x0600 && r <= 0x06FF)
            ? rawTitleAr
            : '';
        final juzRanges = <int, _SurahJuzRange>{};
        final juzList = item['juz'] as List<dynamic>? ?? [];
        for (final segment in juzList) {
          if (segment is! Map<String, dynamic>) continue;
          final juzNumber = _parseIntValue(segment['index']);
          final verse = segment['verse'] as Map<String, dynamic>? ?? {};
          final start = _parseVerseKey(verse['start']?.toString() ?? '');
          final end = _parseVerseKey(verse['end']?.toString() ?? '');
          if (juzNumber == 0) continue;
          juzRanges[juzNumber] = _SurahJuzRange(
            startVerse: start,
            endVerse: end,
          );
        }
        surahMap[number] = _SurahMeta(
          number: number,
          place: (item['place'] ?? '').toString(),
          type: (item['type'] ?? '').toString(),
          verseCount: _parseIntValue(item['count']),
          title: (item['title'] ?? '').toString(),
          titleAr: titleAr,
          pageStart: _parseIntValue(item['pages']),
          juzRanges: juzRanges,
        );
      }

      _juzMetaByNumber
        ..clear()
        ..addAll(juzMap);
      _surahMetaByNumber
        ..clear()
        ..addAll(surahMap);
      _surahPageStarts
        ..clear()
        ..addAll({
          for (final entry in surahMap.entries)
            entry.key: entry.value.pageStart,
        });
    } catch (_) {}
  }

  int _parseVerseKey(String raw) {
    final match = RegExp(r'(\d+)').firstMatch(raw);
    if (match == null) return 0;
    return int.tryParse(match.group(1) ?? '') ?? 0;
  }

  int _parseIntValue(Object? value) {
    if (value is int) return value;
    if (value is num) return value.round();
    final raw = value?.toString() ?? '';
    final match = RegExp(r'(\d+)').firstMatch(raw);
    if (match == null) return 0;
    return int.tryParse(match.group(1) ?? '') ?? 0;
  }

  Future<void> _loadTexts() async {
    setState(() {
      _loading = true;
      _error = null;
      _juzGroups = [];
    });
    try {
      final metaFuture = _loadMetadata();
      final arabicRaw = await rootBundle.loadString(kArabicTextAsset);
      final translationRaw = await rootBundle.loadString(
        widget.translation.asset,
      );
      await metaFuture;
      final arabic = _parseArabic(arabicRaw);
      final translations = _parseTranslations(translationRaw);
      final verses = _buildVerseDisplays(arabic, translations);
      final grouped = _groupVersesByJuz(verses);
      if (!mounted) return;
      setState(() {
        _juzGroups = grouped;
        _loading = false;
      });
      _syncBookmarkArabic();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Unable to load Quran text. Please check translation assets.';
      });
    }
  }

  int _juzForVerse(int surahNumber, int verseNumber) {
    final meta = _surahMetaByNumber[surahNumber];
    if (meta != null) {
      for (final entry in meta.juzRanges.entries) {
        final range = entry.value;
        if (verseNumber >= range.startVerse && verseNumber <= range.endVerse) {
          return entry.key;
        }
      }
    }
    return 1;
  }

  List<_ArabicSurah> _parseArabic(String raw) {
    final data = json.decode(raw);
    _arabicSurahNames.clear();
    final parsed = <_ArabicSurah>[];
    if (data is List<dynamic>) {
      for (final item in data) {
        final verses = (item['verses'] as List<dynamic>? ?? [])
            .map(
              (verse) => _ArabicVerse(
                number: (verse['number'] ?? 0) as int,
                section: (verse['section'] ?? 0) as int,
                content: (verse['content'] ?? '').toString(),
              ),
            )
            .toList();
        final number = (item['number'] ?? 0) as int;
        final name = (item['name'] ?? '').toString();
        final transliteration = (item['transliteration'] ?? '').toString();
        _arabicSurahNames[number] = name.isEmpty ? transliteration : name;
        parsed.add(
          _ArabicSurah(
            number: number,
            name: name,
            transliteration: transliteration,
            verses: verses,
          ),
        );
      }
      return parsed;
    }
    if (data is Map<String, dynamic>) {
      final keys =
          data.keys.map((key) => int.tryParse(key)).whereType<int>().toList()
            ..sort();
      for (final number in keys) {
        final items = data[number.toString()] as List<dynamic>? ?? [];
        final verses = <_ArabicVerse>[];
        for (final verse in items) {
          if (verse is! Map<String, dynamic>) continue;
          final verseNumber = _parseIntValue(verse['verse']);
          if (verseNumber == 0) continue;
          verses.add(
            _ArabicVerse(
              number: verseNumber,
              section: _juzForVerse(number, verseNumber),
              content: (verse['text'] ?? '').toString(),
            ),
          );
        }
        final meta = _surahMetaByNumber[number];
        final name = meta?.titleAr ?? '';
        final transliteration = meta?.title ?? '';
        _arabicSurahNames[number] = name.isEmpty ? transliteration : name;
        parsed.add(
          _ArabicSurah(
            number: number,
            name: name,
            transliteration: transliteration,
            verses: verses,
          ),
        );
      }
    }
    return parsed;
  }

  Map<int, Map<int, String>> _parseTranslations(String raw) {
    final data = json.decode(raw) as List<dynamic>;
    final result = <int, Map<int, String>>{};
    for (final item in data) {
      final surahNumber = item['number'];
      if (surahNumber == null) continue;
      final verses = <int, String>{};
      for (final verse in item['verses'] as List<dynamic>? ?? []) {
        final number = verse['number'];
        if (number == null) continue;
        verses[number as int] = (verse['translation'] ?? '').toString();
      }
      result[surahNumber as int] = verses;
    }
    return result;
  }

  List<_VerseDisplay> _buildVerseDisplays(
    List<_ArabicSurah> arabic,
    Map<int, Map<int, String>> translations,
  ) {
    final verses = <_VerseDisplay>[];
    for (final surah in arabic) {
      final translationMap = translations[surah.number];
      final meta = _surahMetaByNumber[surah.number];
      final metaTitle = meta?.title ?? '';
      final surahTitle = metaTitle.isNotEmpty
          ? metaTitle
          : surah.number <= kSurahTitlesEnglish.length
          ? kSurahTitlesEnglish[surah.number - 1]
          : 'Surah ${surah.number}';
      final metaArabic = meta?.titleAr ?? '';
      final surahArabic = metaArabic.isNotEmpty
          ? metaArabic
          : _arabicSurahNames[surah.number] ?? surah.transliteration;
      for (final verse in surah.verses) {
        final section = verse.section == 0 ? 1 : verse.section;
        verses.add(
          _VerseDisplay(
            surahNumber: surah.number,
            surahTitle: surahTitle,
            surahArabic: surahArabic,
            verseNumber: verse.number,
            section: section,
            arabic: verse.content,
            translation: translationMap?[verse.number] ?? '',
          ),
        );
      }
    }
    verses.sort((a, b) {
      final sectionCompare = a.section.compareTo(b.section);
      if (sectionCompare != 0) return sectionCompare;
      final surahCompare = a.surahNumber.compareTo(b.surahNumber);
      if (surahCompare != 0) return surahCompare;
      return a.verseNumber.compareTo(b.verseNumber);
    });
    return verses;
  }

  List<_SurahSummary> _buildSurahSummaries(List<_VerseDisplay> verses) {
    final map = <int, List<_VerseDisplay>>{};
    for (final verse in verses) {
      map.putIfAbsent(verse.surahNumber, () => []).add(verse);
    }
    _surahPageStarts.clear();
    var cumulativeVerses = 0;
    final summaries = map.entries.map((entry) {
      final list = List<_VerseDisplay>.from(entry.value)
        ..sort((a, b) => a.verseNumber.compareTo(b.verseNumber));
      final first = list.first;
      final meta = _surahMetaByNumber[entry.key];
      final pageStart =
          meta?.pageStart ?? 1 + (cumulativeVerses ~/ 10); // approximate paging
      _surahPageStarts[entry.key] = pageStart;
      cumulativeVerses += list.length;
      return _SurahSummary(
        surahNumber: entry.key,
        surahTitle: first.surahTitle,
        surahArabic: first.surahArabic,
        section: first.section,
        verseCount: meta?.verseCount ?? list.length,
        verses: list,
      );
    }).toList()..sort((a, b) => a.surahNumber.compareTo(b.surahNumber));
    return summaries;
  }

  List<_JuzGroup> _groupVersesByJuz(List<_VerseDisplay> verses) {
    final grouped = <int, List<_VerseDisplay>>{};
    final groupedBySurah = <int, Map<int, List<_VerseDisplay>>>{};
    for (final verse in verses) {
      grouped.putIfAbsent(verse.section, () => []).add(verse);
      final perJuz = groupedBySurah.putIfAbsent(
        verse.section,
        () => <int, List<_VerseDisplay>>{},
      );
      perJuz.putIfAbsent(verse.surahNumber, () => []).add(verse);
    }

    final juzNumbers = grouped.keys.toList()..sort();
    final result = <_JuzGroup>[];
    for (final number in juzNumbers) {
      final juzVerses = grouped[number]!;
      final firstSurahOrder = <int, int>{};
      for (var i = 0; i < juzVerses.length; i++) {
        firstSurahOrder.putIfAbsent(juzVerses[i].surahNumber, () => i);
      }
      final surahMap = groupedBySurah[number] ?? {};
      final summaries = surahMap.entries.map((entry) {
        final versesForSurah = List<_VerseDisplay>.from(entry.value)
          ..sort((a, b) => a.verseNumber.compareTo(b.verseNumber));
        final first = versesForSurah.first;
        return _SurahSummary(
          surahNumber: entry.key,
          surahTitle: first.surahTitle,
          surahArabic: first.surahArabic,
          section: number,
          verseCount: versesForSurah.length,
          verses: versesForSurah,
        );
      }).toList();
      summaries.sort((a, b) {
        final orderA = firstSurahOrder[a.surahNumber] ?? 0;
        final orderB = firstSurahOrder[b.surahNumber] ?? 0;
        return orderA.compareTo(orderB);
      });
      result.add(
        _JuzGroup(
          number: number,
          startSurahTitle: juzVerses.first.surahTitle,
          verses: juzVerses,
          surahSummaries: summaries,
        ),
      );
    }
    return result;
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('read_bookmarks');
    if (raw == null || raw.isEmpty) return;
    try {
      final data = json.decode(raw) as List<dynamic>;
      final loaded = <String, _VerseDisplay>{};
      for (final item in data) {
        if (item is Map<String, dynamic>) {
          final key = item['key'] as String?;
          final surahNumber = item['surah'] as int?;
          final verseNumber = item['verse'] as int?;
          final section = item['section'] as int? ?? 1;
          final arabic = item['arabic'] as String? ?? '';
          final translation = item['translation'] as String? ?? '';
          final surahTitle = item['surahTitle'] as String? ?? '';
          final surahArabic =
              item['surahArabic'] as String? ??
              (surahNumber == null ? '' : _arabicSurahNames[surahNumber] ?? '');
          if (key != null && surahNumber != null && verseNumber != null) {
            loaded[key] = _VerseDisplay(
              surahNumber: surahNumber,
              surahTitle: surahTitle,
              surahArabic: surahArabic,
              verseNumber: verseNumber,
              section: section,
              arabic: arabic,
              translation: translation,
            );
          }
        }
      }
      setState(() => _bookmarks = loaded);
    } catch (_) {}
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _bookmarks.entries.map((entry) {
      final v = entry.value;
      return {
        'key': entry.key,
        'surah': v.surahNumber,
        'verse': v.verseNumber,
        'section': v.section,
        'arabic': v.arabic,
        'translation': v.translation,
        'surahTitle': v.surahTitle,
        'surahArabic': v.surahArabic,
      };
    }).toList();
    await prefs.setString('read_bookmarks', json.encode(list));
  }

  void _syncBookmarkArabic() {
    if (_bookmarks.isEmpty || _arabicSurahNames.isEmpty) return;
    final updated = <String, _VerseDisplay>{};
    var changed = false;
    _bookmarks.forEach((key, v) {
      final arabicName = v.surahArabic.isNotEmpty
          ? v.surahArabic
          : _arabicSurahNames[v.surahNumber] ?? '';
      if (arabicName == v.surahArabic || arabicName.isEmpty) {
        updated[key] = v;
        return;
      }
      changed = true;
      updated[key] = _VerseDisplay(
        surahNumber: v.surahNumber,
        surahTitle: v.surahTitle,
        surahArabic: arabicName,
        verseNumber: v.verseNumber,
        section: v.section,
        arabic: v.arabic,
        translation: v.translation,
      );
    });
    if (changed && mounted) {
      setState(() => _bookmarks = updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return _buildErrorCard();
    }
    final content = _showBookmarks ? _buildBookmarksList() : _buildJuzList();
    return ListView(
      padding: kPagePadding,
      children: [
        _buildHeader(),
        const SizedBox(height: 14),
        _buildSearchAndLayout(),
        const SizedBox(height: 14),
        content,
      ],
    );
  }

  Widget _buildHeader() {
    final palette = ThemePalette.of(context);
    return Container(
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, color: palette.accent),
              const SizedBox(width: 8),
              Text(
                widget.strings.readLabel,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _readLabel(_ReadLabel.readHint),
            style: TextStyle(color: palette.mutedTextColor, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _buildInfoPill(
                icon: Icons.translate,
                label: widget.translation.label,
              ),
              _buildInfoPill(
                icon: Icons.text_fields,
                label: '${(widget.textScale * 100).round()}%',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildModeToggle(palette),
        ],
      ),
    );
  }

  Widget _buildModeToggle(ThemePalette palette) {
    return ToggleButtons(
      isSelected: [!_showBookmarks, _showBookmarks],
      onPressed: (index) {
        setState(() => _showBookmarks = index == 1);
      },
      borderRadius: BorderRadius.circular(kCardRadius),
      selectedColor: palette.background,
      fillColor: palette.accent,
      color: palette.textColor,
      borderColor: palette.cardBorder,
      selectedBorderColor: palette.accent,
      constraints: const BoxConstraints(minHeight: 36),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Icon(Icons.menu_book, size: 16),
              const SizedBox(width: 6),
              Text(_readLabel(_ReadLabel.quranTab)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Icon(Icons.bookmarks_outlined, size: 16),
              const SizedBox(width: 6),
              Text(_readLabel(_ReadLabel.bookmarksTab)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSurahAudioControls(_SurahSummary surah) {
    final palette = ThemePalette.of(context);
    if (_audioCollections.isEmpty) {
      return Text(
        widget.strings.noAudioMessage,
        style: TextStyle(color: palette.mutedTextColor, fontSize: 12),
      );
    }
    final isCurrent = _playingSurahNumber == surah.surahNumber;
    final isPlaying = isCurrent && _isJuzPlaying;
    final reciterLabel = _selectedAudioCollection?.label ?? '';
    final totalDuration = isCurrent ? _totalDuration : Duration.zero;
    final position = isCurrent
        ? (_scrubPosition ?? _currentPosition)
        : Duration.zero;
    final maxMillis = totalDuration.inMilliseconds == 0
        ? 1
        : totalDuration.inMilliseconds;
    final sliderValue = position.inMilliseconds.clamp(0, maxMillis).toDouble();
    return Container(
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.headphones, size: 18, color: palette.accent),
              const SizedBox(width: 8),
              Text(
                _readLabel(_ReadLabel.nowPlaying),
                style: TextStyle(
                  color: palette.textColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (_audioLoading)
                const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _displaySurahTitle(surah.surahTitle),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (reciterLabel.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              reciterLabel,
              style: TextStyle(color: palette.mutedTextColor, fontSize: 12),
            ),
          ],
          const SizedBox(height: 6),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              value: sliderValue,
              min: 0,
              max: maxMillis.toDouble(),
              activeColor: palette.accent,
              inactiveColor: palette.cardBorder,
              onChangeStart: isCurrent
                  ? (value) {
                      setState(() {
                        _scrubPosition = Duration(milliseconds: value.round());
                      });
                    }
                  : null,
              onChanged: isCurrent
                  ? (value) {
                      setState(() {
                        _scrubPosition = Duration(milliseconds: value.round());
                      });
                    }
                  : null,
              onChangeEnd: isCurrent
                  ? (value) async {
                      final newPosition = Duration(milliseconds: value.round());
                      setState(() {
                        _scrubPosition = null;
                        _currentPosition = newPosition;
                      });
                      await _juzPlayer.seek(newPosition);
                    }
                  : null,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatReadDuration(position),
                style: TextStyle(color: palette.mutedTextColor),
              ),
              Text(
                _formatReadDuration(totalDuration),
                style: TextStyle(color: palette.mutedTextColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: _readLabel(_ReadLabel.previous),
                iconSize: 32,
                onPressed: surah.surahNumber > 1
                    ? () => _playNeighborSurah(surah.surahNumber - 1)
                    : null,
                icon: const Icon(Icons.skip_previous),
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: _audioActionLabel(isPlaying),
                iconSize: 40,
                onPressed: () => _toggleSurahAudio(
                  surahNumber: surah.surahNumber,
                  surahLabel: _surahNameForLanguage(surah.surahNumber),
                ),
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: _readLabel(_ReadLabel.next),
                iconSize: 32,
                onPressed: surah.surahNumber < kSurahTitlesEnglish.length
                    ? () => _playNeighborSurah(surah.surahNumber + 1)
                    : null,
                icon: const Icon(Icons.skip_next),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${widget.strings.reciterCommonLabel}:',
            style: TextStyle(
              color: palette.mutedTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          _buildReciterChips(),
        ],
      ),
    );
  }

  Future<void> _playNeighborSurah(int surahNumber) async {
    if (surahNumber < 1 || surahNumber > kSurahTitlesEnglish.length) {
      return;
    }
    await _toggleSurahAudio(
      surahNumber: surahNumber,
      surahLabel: _surahNameForLanguage(surahNumber),
    );
  }

  String _formatReadDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Widget _buildReciterChips() {
    final palette = ThemePalette.of(context);
    final selectedId = _selectedAudioCollection?.id;
    final isRtl = widget.strings.direction == TextDirection.rtl;
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: isRtl,
        itemCount: _audioCollections.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final collection = _audioCollections[index];
          final isSelected = collection.id == selectedId;
          return ChoiceChip(
            label: Text(collection.label),
            selected: isSelected,
            selectedColor: palette.accent.withValues(alpha: 0.2),
            backgroundColor: palette.cardColor,
            side: BorderSide(
              color: isSelected ? palette.accent : palette.cardBorder,
            ),
            labelStyle: TextStyle(
              color: palette.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            onSelected: (_) => _switchAudioCollection(collection),
          );
        },
      ),
    );
  }

  Widget _buildInfoPill({required IconData icon, required String label}) {
    final palette = ThemePalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: palette.panelColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: palette.mutedTextColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: palette.textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndLayout() {
    final palette = ThemePalette.of(context);
    return Container(
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value) {
              setState(() => _searchQuery = value.trim());
            },
            style: TextStyle(
              color: palette.textColor,
              fontSize: 15 * widget.textScale,
            ),
            decoration: InputDecoration(
              hintText: _readLabel(_ReadLabel.searchHint),
              hintStyle: TextStyle(color: palette.mutedTextColor),
              prefixIcon: Icon(Icons.search, color: palette.accent),
              filled: true,
              fillColor: palette.panelColor,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kCardRadius),
                borderSide: BorderSide(color: palette.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kCardRadius),
                borderSide: BorderSide(color: palette.accent),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.tune, size: 14, color: palette.mutedTextColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _readLabel(_ReadLabel.searchHelper),
                  style: TextStyle(color: palette.mutedTextColor, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJuzList() {
    final filtered = _filteredJuzGroups();
    if (filtered.isEmpty) {
      return _emptySearch();
    }
    if (_searchQuery.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchHeader(filtered),
          const SizedBox(height: 12),
          ...filtered.map((juz) => _buildJuzStyledSection(juz)),
        ],
      );
    }
    final seenSurahs = <int>{};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: filtered
          .map((juz) => _buildJuzStyledSection(juz, seenSurahs: seenSurahs))
          .toList(),
    );
  }

  Widget _buildSearchHeader(List<_JuzGroup> groups) {
    final palette = ThemePalette.of(context);
    final totalSurahs = groups.fold<int>(
      0,
      (sum, group) => sum + group.surahSummaries.length,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: palette.panelColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: palette.accent, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _readLabel(_ReadLabel.searchResults),
              style: TextStyle(
                color: palette.textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            _surahCountText(totalSurahs),
            style: TextStyle(
              color: palette.mutedTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJuzStyledSection(_JuzGroup juz, {Set<int>? seenSurahs}) {
    final uniqueSurahs = <_SurahSummary>[];
    final perJuzSeen = <int>{};
    for (final surah in juz.surahSummaries) {
      if (!perJuzSeen.add(surah.surahNumber)) continue;
      final isRepeatable = _repeatableSurahs.contains(surah.surahNumber);
      if (seenSurahs != null &&
          seenSurahs.contains(surah.surahNumber) &&
          !isRepeatable) {
        continue;
      }
      uniqueSurahs.add(surah);
      if (!isRepeatable) {
        seenSurahs?.add(surah.surahNumber);
      }
    }
    if (uniqueSurahs.isEmpty && seenSurahs == null) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildJuzSectionHeader(juz.number),
        const SizedBox(height: 6),
        if (uniqueSurahs.isNotEmpty)
          ...uniqueSurahs.map(
            (surah) => _buildJuzSurahCard(surah, juzNumber: juz.number),
          )
        else if (seenSurahs != null)
          _buildJuzContinuationCard(juz),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildJuzSectionHeader(int juzNumber) {
    final palette = ThemePalette.of(context);
    final info = _juzInfo(juzNumber);
    final rangeLabel = info == null ? null : _juzRangeLabel(info);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _juzLabel(juzNumber),
                style: TextStyle(
                  color: palette.textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        palette.accent.withValues(alpha: 0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (rangeLabel != null) ...[
            const SizedBox(height: 6),
            Text(
              rangeLabel,
              style: TextStyle(
                color: palette.mutedTextColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildJuzContinuationCard(_JuzGroup juz) {
    final palette = ThemePalette.of(context);
    final firstVerse = juz.verses.isNotEmpty ? juz.verses.first.verseNumber : 1;
    final info = _juzInfo(juz.number);
    final rangeText = info == null
        ? '${_readLabel(_ReadLabel.verse)} $firstVerse'
        : _juzRangeLabel(info);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: juz.surahSummaries.isNotEmpty
          ? () => _openSurahDetail(juz.surahSummaries.first)
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: palette.panelColor,
          border: Border.all(color: palette.cardBorder),
        ),
        child: Row(
          children: [
            _juzStarBadge(juz.number),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _readLabel(_ReadLabel.continues),
                    style: TextStyle(
                      color: palette.textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rangeText,
                    style: TextStyle(
                      color: palette.mutedTextColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.double_arrow, color: palette.mutedTextColor),
          ],
        ),
      ),
    );
  }

  Widget _buildJuzSurahCard(_SurahSummary surah, {required int juzNumber}) {
    final palette = ThemePalette.of(context);
    final title = _displaySurahTitle(surah.surahTitle);
    final metaLabels = _surahMetaLabels(surah, juzNumber);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _openSurahDetail(surah),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              palette.cardColor,
              palette.cardColor.withValues(alpha: 0.9),
              palette.panelColor,
            ],
          ),
          border: Border.all(color: palette.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -18,
              top: -24,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: palette.accent.withValues(alpha: 0.08),
                ),
              ),
            ),
            Row(
              textDirection: TextDirection.ltr,
              children: [
                _juzStarBadge(surah.surahNumber),
                const SizedBox(width: 10),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: palette.textColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        if (metaLabels.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: metaLabels
                                .map((label) => _buildTinyChip(label))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        surah.surahArabic,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: palette.accent,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTinyChip(String text) {
    final palette = ThemePalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: palette.heroHighlight.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: palette.textColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _surahMetaLine(_SurahSummary surah) {
    final revelation = _isMedinan(surah.surahNumber)
        ? _readLabel(_ReadLabel.medinan)
        : _readLabel(_ReadLabel.meccan);
    final firstVerse = surah.verses.isNotEmpty
        ? surah.verses.first.verseNumber
        : 1;
    return '$revelation - ${_verseCountText(surah.verseCount)} - '
        '${_readLabel(_ReadLabel.verse)} $firstVerse';
  }

  Widget _juzStarBadge(int number) {
    final palette = ThemePalette.of(context);
    return SizedBox(
      width: 38,
      height: 38,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipPath(
            clipper: const _StarClipper(points: 8, innerRadiusRatio: 0.65),
            child: Container(
              decoration: BoxDecoration(
                color: palette.cardBorder,
                boxShadow: [
                  BoxShadow(
                    color: palette.accent.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2),
            child: ClipPath(
              clipper: const _StarClipper(points: 8, innerRadiusRatio: 0.65),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFEAD07A),
                      Color(0xFFD6A94B),
                      Color(0xFFB8872E),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: TextStyle(
                      color: palette.background,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarksList() {
    final entries = _bookmarks.values.toList()
      ..sort((a, b) {
        final keyA =
            '${a.section.toString().padLeft(2, '0')}-${a.surahNumber.toString().padLeft(3, '0')}-${a.verseNumber.toString().padLeft(3, '0')}';
        final keyB =
            '${b.section.toString().padLeft(2, '0')}-${b.surahNumber.toString().padLeft(3, '0')}-${b.verseNumber.toString().padLeft(3, '0')}';
        return keyA.compareTo(keyB);
      });
    if (entries.isEmpty) {
      final palette = ThemePalette.of(context);
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          padding: kCardPadding,
          decoration: BoxDecoration(
            color: palette.cardColor,
            borderRadius: BorderRadius.circular(kCardRadius),
            border: Border.all(color: palette.cardBorder),
          ),
          child: Row(
            children: [
              Icon(Icons.bookmark_border, color: palette.mutedTextColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _readLabel(_ReadLabel.noBookmarks),
                  style: TextStyle(color: palette.mutedTextColor),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: entries
          .map(
            (v) => _buildVerseTile(v, showJuz: true, messengerContext: context),
          )
          .toList(),
    );
  }

  String _displaySurahTitle(String raw) {
    final withoutNumber = raw.replaceFirst(RegExp(r'^\d+\s*'), '');
    final withoutPrefix = withoutNumber.replaceFirst(
      RegExp(r'^(surah|sura|surat)\s+', caseSensitive: false),
      '',
    );
    return withoutPrefix.trim();
  }

  bool _isMedinan(int surahNumber) {
    final meta = _surahMetaByNumber[surahNumber];
    if (meta != null) {
      final place = meta.place.toLowerCase();
      final type = meta.type.toLowerCase();
      if (place.contains('medina') || type.contains('madani')) {
        return true;
      }
      if (place.contains('mecca') || type.contains('makki')) {
        return false;
      }
    }
    const medinan = <int>{
      2,
      3,
      4,
      5,
      8,
      9,
      24,
      33,
      47,
      48,
      49,
      57,
      58,
      59,
      60,
      61,
      62,
      63,
      64,
      65,
      66,
      76,
      98,
      99,
      110,
    };
    return medinan.contains(surahNumber);
  }

  _SurahJuzRange? _surahRangeForJuz(_SurahSummary surah, int juzNumber) {
    final meta = _surahMetaByNumber[surah.surahNumber];
    final fromMeta = meta?.juzRanges[juzNumber];
    if (fromMeta != null) return fromMeta;
    if (surah.verses.isEmpty) return null;
    final start = surah.verses.first.verseNumber;
    final end = surah.verses.last.verseNumber;
    return _SurahJuzRange(startVerse: start, endVerse: end);
  }

  int _rangeCount(_SurahJuzRange range) {
    final count = range.endVerse - range.startVerse + 1;
    return count > 0 ? count : 1;
  }

  String _verseRangeLabel(_SurahJuzRange range) {
    if (range.startVerse == range.endVerse) {
      return '${_readLabel(_ReadLabel.verse)} ${range.startVerse}';
    }
    return '${_readLabel(_ReadLabel.verse)} '
        '${range.startVerse}-${range.endVerse}';
  }

  List<String> _surahMetaLabels(
    _SurahSummary surah,
    int juzNumber, {
    bool includePage = false,
    bool includeJuzRange = true,
  }) {
    final labels = <String>[];
    labels.add(
      _isMedinan(surah.surahNumber)
          ? _readLabel(_ReadLabel.medinan)
          : _readLabel(_ReadLabel.meccan),
    );
    final meta = _surahMetaByNumber[surah.surahNumber];
    final range = includeJuzRange ? _surahRangeForJuz(surah, juzNumber) : null;
    final verseCount = range != null
        ? _rangeCount(range)
        : (meta?.verseCount ?? surah.verseCount);
    labels.add(_verseCountText(verseCount));
    if (range != null) {
      labels.add(_verseRangeLabel(range));
    }
    if (includePage) {
      final page = meta?.pageStart ?? 0;
      if (page > 0) {
        labels.add('${_readLabel(_ReadLabel.page)} $page');
      }
    }
    return labels;
  }

  List<_JuzGroup> _filteredJuzGroups() {
    final query = _searchQuery.toLowerCase();
    if (query.isEmpty) return _juzGroups;
    final matches = <_JuzGroup>[];
    for (final juz in _juzGroups) {
      final filteredSurahs = juz.surahSummaries
          .where((s) => _matchesSummary(s, query))
          .toList();
      if (filteredSurahs.isNotEmpty) {
        matches.add(
          _JuzGroup(
            number: juz.number,
            startSurahTitle: juz.startSurahTitle,
            verses: juz.verses,
            surahSummaries: filteredSurahs,
          ),
        );
      }
    }
    return matches;
  }

  bool _matchesSummary(_SurahSummary summary, String query) {
    if (summary.surahTitle.toLowerCase().contains(query) ||
        summary.surahArabic.toLowerCase().contains(query)) {
      return true;
    }
    for (final v in summary.verses) {
      if (v.translation.toLowerCase().contains(query) ||
          v.arabic.toLowerCase().contains(query)) {
        return true;
      }
    }
    return false;
  }

  Widget _emptySearch() {
    final palette = ThemePalette.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.search_off, color: palette.mutedTextColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _readLabel(_ReadLabel.noResults),
              style: TextStyle(color: palette.mutedTextColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahCard(
    _SurahSummary surah, {
    bool showVerses = false,
    BuildContext? messengerContext,
  }) {
    final palette = ThemePalette.of(context);
    final metaLabels = _surahMetaLabels(
      surah,
      surah.section,
      includeJuzRange: false,
    );
    if (!showVerses) {
      return InkWell(
        borderRadius: BorderRadius.circular(kCardRadius),
        onTap: () => _openSurahDetail(surah),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: palette.panelColor,
            borderRadius: BorderRadius.circular(kCardRadius),
            border: Border.all(color: palette.cardBorder),
          ),
          child: Row(
            children: [
              _surahBadge(surah.surahNumber),
              const SizedBox(width: 10),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _displaySurahTitle(surah.surahTitle),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: palette.textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      if (metaLabels.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: metaLabels
                              .map((label) => _buildTinyChip(label))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  surah.surahArabic,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.accent,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSurahDetailHeader(surah),
        ...surah.verses.map(
          (v) => _buildVerseTile(v, messengerContext: messengerContext),
        ),
      ],
    );
  }

  Widget _buildSurahDetailHeader(_SurahSummary surah) {
    final palette = ThemePalette.of(context);
    final metaLabels = _surahMetaLabels(
      surah,
      surah.section,
      includePage: true,
      includeJuzRange: false,
    );
    final tajweedLegend = _buildTajweedLegend(surah.surahNumber, palette);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Row(
        children: [
          _surahBadge(surah.surahNumber),
          const SizedBox(width: 12),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _displaySurahTitle(surah.surahTitle),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: palette.textColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  if (metaLabels.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: metaLabels
                          .map((label) => _buildTinyChip(label))
                          .toList(),
                    ),
                  ],
                  if (tajweedLegend != null) ...[
                    const SizedBox(height: 10),
                    tajweedLegend,
                  ],
                ],
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              surah.surahArabic,
              style: TextStyle(
                color: palette.accent,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _surahMetaRow(_SurahSummary surah) {
    final palette = ThemePalette.of(context);
    final revelation = _isMedinan(surah.surahNumber)
        ? _readLabel(_ReadLabel.medinan)
        : _readLabel(_ReadLabel.meccan);
    final meta = _surahMetaByNumber[surah.surahNumber];
    final page =
        meta?.pageStart ?? _surahPageStarts[surah.surahNumber] ?? surah.section;
    return Text(
      '$revelation | ${_verseCountText(meta?.verseCount ?? surah.verseCount)} | ${_readLabel(_ReadLabel.page)} $page',
      style: TextStyle(
        color: palette.mutedTextColor,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }

  void _openSurahDetail(_SurahSummary surah) {
    final palette = ThemePalette.of(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          backgroundColor: palette.background,
          appBar: AppBar(
            backgroundColor: palette.background,
            foregroundColor: palette.textColor,
            elevation: 0,
            title: Text(_displaySurahTitle(surah.surahTitle)),
          ),
          body: ListView(
            padding: kPagePadding,
            children: [
              _buildSurahCard(surah, showVerses: true, messengerContext: ctx),
            ],
          ),
        ),
      ),
    );
  }

  Widget _surahBadge(int number) {
    final palette = ThemePalette.of(context);
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: palette.accent.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        border: Border.all(
          color: palette.background.withValues(alpha: 0.6),
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        number.toString(),
        style: TextStyle(
          color: palette.background,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _tajweedColorForRule(String rule, Color fallback) {
    return kTajweedColors[rule] ?? fallback;
  }

  Future<void> _ensureTajweedLoaded(int surahNumber) async {
    if (_tajweedBySurah.containsKey(surahNumber) ||
        _tajweedLoading.contains(surahNumber)) {
      return;
    }
    _tajweedLoading.add(surahNumber);
    try {
      final raw = await rootBundle.loadString(
        'asset/tajweed/surah_$surahNumber.json',
      );
      final data = json.decode(raw) as Map<String, dynamic>;
      final verses = data['verse'] as Map<String, dynamic>? ?? {};
      final parsed = <int, List<_TajweedSegment>>{};
      verses.forEach((key, value) {
        final verseNumber = _parseVerseKey(key.toString());
        final segments = <_TajweedSegment>[];
        for (final segment in value as List<dynamic>? ?? []) {
          if (segment is! Map<String, dynamic>) continue;
          segments.add(
            _TajweedSegment(
              start: _parseIntValue(segment['start']),
              end: _parseIntValue(segment['end']),
              rule: (segment['rule'] ?? '').toString(),
            ),
          );
        }
        segments.sort((a, b) => a.start.compareTo(b.start));
        parsed[verseNumber] = segments;
      });
      if (!mounted) return;
      setState(() => _tajweedBySurah[surahNumber] = parsed);
    } catch (_) {
      if (mounted) {
        setState(() => _tajweedBySurah[surahNumber] = {});
      }
    } finally {
      _tajweedLoading.remove(surahNumber);
    }
  }

  List<TextSpan> _tajweedSpans(_VerseDisplay verse, TextStyle baseStyle) {
    final text = verse.arabic;
    if (text.isEmpty) {
      return [TextSpan(text: text)];
    }
    final segments = _tajweedBySurah[verse.surahNumber]?[verse.verseNumber];
    if (segments == null || segments.isEmpty) {
      return [TextSpan(text: text)];
    }
    final spans = <TextSpan>[];
    var cursor = 0;
    for (final segment in segments) {
      final start = segment.start.clamp(0, text.length).toInt();
      final end = segment.end.clamp(0, text.length - 1).toInt();
      if (start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, start)));
      }
      final endIndex = end + 1;
      if (endIndex > start && endIndex <= text.length) {
        spans.add(
          TextSpan(
            text: text.substring(start, endIndex),
            style: baseStyle.copyWith(
              color: _tajweedColorForRule(segment.rule, baseStyle.color!),
            ),
          ),
        );
        cursor = endIndex;
      }
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }
    return spans;
  }

  Widget _buildTajweedText(_VerseDisplay verse, ThemePalette palette) {
    final baseStyle = TextStyle(
      fontSize: 20 * widget.textScale,
      height: 1.6,
      color: palette.textColor,
    );
    final spans = _tajweedSpans(verse, baseStyle);
    return RichText(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.start,
      text: TextSpan(style: baseStyle, children: spans),
    );
  }

  String _tajweedLegendTitle() {
    switch (widget.language) {
      case AppLanguage.arabic:
        return 'ألوان التجويد';
      case AppLanguage.kurdish:
        return 'ڕەنگەکانی تەجوید';
      case AppLanguage.english:
        return 'Tajweed colors';
    }
  }

  String _tajweedLabelForRule(String rule) {
    final entry = kTajweedLegendEntries[rule];
    if (entry != null) {
      return switch (widget.language) {
        AppLanguage.kurdish => entry.labelKu,
        AppLanguage.arabic => entry.labelAr,
        AppLanguage.english => entry.labelEn,
      };
    }
    final cleaned = rule.replaceAll('_', ' ').trim();
    if (cleaned.isEmpty) return 'Tajweed';
    final words = cleaned.split(' ');
    final titled = words
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .toList();
    return titled.join(' ');
  }

  Widget _buildTajweedLegendChip(String rule, ThemePalette palette) {
    final color = _tajweedColorForRule(rule, palette.mutedTextColor);
    final label = _tajweedLabelForRule(rule);
    final entry = kTajweedLegendEntries[rule];
    final meaning = entry == null
        ? ''
        : switch (widget.language) {
            AppLanguage.kurdish => entry.meaningKu,
            AppLanguage.arabic => entry.meaningAr,
            AppLanguage.english => entry.meaningEn,
          };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: palette.panelColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: palette.textColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (meaning.isNotEmpty)
                Text(
                  meaning,
                  style: TextStyle(
                    color: palette.mutedTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget? _buildTajweedLegend(int surahNumber, ThemePalette palette) {
    final segments = _tajweedBySurah[surahNumber];
    if (segments == null || segments.isEmpty) return null;
    final rules = <String>{};
    for (final verseSegments in segments.values) {
      for (final segment in verseSegments) {
        if (segment.rule.isNotEmpty) {
          rules.add(segment.rule);
        }
      }
    }
    if (rules.isEmpty) return null;
    final sorted = rules.toList()..sort();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _tajweedLegendTitle(),
          style: TextStyle(
            color: palette.mutedTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: sorted
              .map((rule) => _buildTajweedLegendChip(rule, palette))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildVerseTile(
    _VerseDisplay verse, {
    bool showJuz = false,
    BuildContext? messengerContext,
  }) {
    final palette = ThemePalette.of(context);
    if (!_tajweedBySurah.containsKey(verse.surahNumber) &&
        !_tajweedLoading.contains(verse.surahNumber)) {
      _ensureTajweedLoaded(verse.surahNumber);
    }
    final surahName = _displaySurahTitle(verse.surahTitle);
    final surahLabel = verse.surahArabic.isEmpty
        ? surahName
        : '$surahName - ${verse.surahArabic}';
    final isSaved = _bookmarks.containsKey(_bookmarkKey(verse));
    final verseAudioKey = _verseAudioKey(verse);
    final isVerseCurrent = _currentVerseAudioKey == verseAudioKey;
    final isVersePlaying = isVerseCurrent && _isVersePlaying;
    final isVerseLoading = _verseAudioLoading && isVerseCurrent;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: palette.heroHighlight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: palette.cardBorder),
                ),
                child: Text(
                  showJuz
                      ? _juzLabel(verse.section)
                      : '${verse.surahNumber}:${verse.verseNumber}',
                  style: TextStyle(
                    color: palette.textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  surahLabel,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.mutedTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isSaved)
                Icon(Icons.bookmark, size: 18, color: palette.accent),
            ],
          ),
          const SizedBox(height: 10),
          _buildTajweedText(verse, palette),
          const SizedBox(height: 10),
          Text(
            verse.translation.isEmpty
                ? _readLabel(_ReadLabel.translationUnavailable)
                : verse.translation,
            style: TextStyle(
              color: palette.mutedTextColor,
              height: 1.5,
              fontWeight: FontWeight.w600,
              fontSize: 14 * widget.textScale,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _verseActionButton(
                icon: isVerseLoading
                    ? Icons.hourglass_top
                    : isVersePlaying
                    ? Icons.pause_circle
                    : Icons.play_circle,
                label: _audioActionLabel(isVersePlaying),
                onTap: isVerseLoading ? () {} : () => _toggleVerseAudio(verse),
              ),
              _verseActionButton(
                icon: Icons.content_copy,
                label: _readLabel(_ReadLabel.copy),
                onTap: () =>
                    _copyVerse(verse, messengerContext: messengerContext),
              ),
              _verseActionButton(
                icon: Icons.share,
                label: _readLabel(_ReadLabel.share),
                onTap: () => _shareVerse(verse),
              ),
              _verseActionButton(
                icon: isSaved
                    ? Icons.bookmark_added
                    : Icons.bookmark_add_outlined,
                label: isSaved
                    ? _readLabel(_ReadLabel.saved)
                    : _readLabel(_ReadLabel.bookmark),
                onTap: () => _toggleBookmark(verse),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    final palette = ThemePalette.of(context);
    return Center(
      child: Padding(
        padding: kCardPadding,
        child: Container(
          padding: kCardPadding,
          decoration: BoxDecoration(
            color: palette.heroHighlight,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: palette.cardBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.menu_book, color: palette.accent, size: 32),
              const SizedBox(height: 10),
              Text(
                _error ?? 'Unable to load Quran text.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: palette.background,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _loadTexts,
                icon: const Icon(Icons.refresh),
                label: Text(widget.strings.retryLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _bookmarkKey(_VerseDisplay verse) =>
      '${verse.surahNumber}:${verse.verseNumber}';

  void _toggleBookmark(_VerseDisplay verse) {
    final key = _bookmarkKey(verse);
    setState(() {
      if (_bookmarks.containsKey(key)) {
        _bookmarks.remove(key);
      } else {
        _bookmarks[key] = verse;
      }
    });
    _saveBookmarks();
  }

  void _copyVerse(_VerseDisplay verse, {BuildContext? messengerContext}) {
    final text = _verseText(verse);
    Clipboard.setData(ClipboardData(text: text));
    _showSnack(
      '${widget.strings.copiedMessage} (${verse.surahNumber}:${verse.verseNumber})',
      messengerContext: messengerContext,
    );
  }

  void _shareVerse(_VerseDisplay verse) {
    final text = _verseText(verse);
    Share.share(
      text,
      subject:
          '${_readLabel(_ReadLabel.quranTab)} ${verse.surahNumber}:${verse.verseNumber}',
    );
  }

  String _verseText(_VerseDisplay verse) {
    final title = _displaySurahTitle(verse.surahTitle);
    return '$title (${verse.surahNumber}:${verse.verseNumber})\n${verse.arabic}\n${verse.translation}';
  }

  void _showSnack(String message, {BuildContext? messengerContext}) {
    final targetContext = messengerContext ?? context;
    ScaffoldMessenger.of(targetContext).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      targetContext,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _verseActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final palette = ThemePalette.of(context);
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: palette.heroHighlight,
        foregroundColor: palette.textColor,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: palette.cardBorder),
        ),
      ),
      icon: Icon(icon, size: 16),
      label: Text(label),
    );
  }
}

class _StarClipper extends CustomClipper<Path> {
  const _StarClipper({this.points = 8, this.innerRadiusRatio = 0.6});

  final int points;
  final double innerRadiusRatio;

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.shortestSide / 2;
    final innerRadius = outerRadius * innerRadiusRatio;
    final angleStep = pi / points;
    final path = Path();
    for (var i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = i * angleStep - pi / 2;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _StarClipper oldClipper) {
    return oldClipper.points != points ||
        oldClipper.innerRadiusRatio != innerRadiusRatio;
  }
}

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
        _statusMessage = widget.strings.qiblahServiceDisabledMessage;
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
        _statusMessage = widget.strings.qiblahPermissionForeverMessage;
      });
      return;
    }
    if (permission == LocationPermission.denied) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _statusMessage = widget.strings.qiblahPermissionDeniedMessage;
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
        _statusMessage = widget.strings.qiblahLocationUnavailableMessage;
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
      padding: kPagePadding,
      children: [
        _buildHeroHeader(context),
        const SizedBox(height: 16),
        _buildCompassCard(context),
        const SizedBox(height: 14),
        _buildDetailsCard(context),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.end,
          spacing: 12,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: _initialize,
              icon: const Icon(Icons.refresh),
              label: Text(widget.strings.retryLabel),
            ),
            if (!_compassAvailable)
              OutlinedButton.icon(
                onPressed: _listenToCompass,
                icon: const Icon(Icons.explore),
                label: const Text('Retry compass'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    final lat = _position?.latitude;
    final lon = _position?.longitude;
    final distance = _distanceKm;
    final heading = _heading;
    final guidance = _turnText(
      (heading != null && _qiblahBearing != null)
          ? _normalizeDegrees(_qiblahBearing! - heading)
          : null,
    );
    final palette = ThemePalette.of(context);
    final textColor = palette.textColor;
    final muted = palette.mutedTextColor;

    return _glassCard(
      padding: kCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: palette.accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.explore, color: palette.accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.strings.qiblahLabel,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Face Makkah with live compass guidance.',
                      style: TextStyle(color: muted, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _metricPill(
                widget.strings.qiblahDistanceLabel,
                distance != null ? '${distance.toStringAsFixed(1)} km' : '--',
              ),
              _metricPill(
                widget.strings.qiblahLatitudeLabel,
                lat != null ? lat.toStringAsFixed(4) : '--',
              ),
              _metricPill(
                widget.strings.qiblahLongitudeLabel,
                lon != null ? lon.toStringAsFixed(4) : '--',
              ),
              _metricPill(
                widget.strings.qiblahHeadingLabel,
                heading != null
                    ? '${_normalizeDegrees(heading).toStringAsFixed(1)}°'
                    : widget.strings.qiblahCalibratingLabel,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: palette.heroHighlight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: palette.cardBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.navigation, color: palette.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    guidance,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                if (!_compassAvailable)
                  Icon(Icons.warning_amber_rounded, color: palette.accent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final palette = ThemePalette.of(context);
    return Center(
      child: Padding(
        padding: kCardPadding,
        child: Container(
          padding: kCardPadding,
          decoration: BoxDecoration(
            color: palette.heroHighlight,
            borderRadius: BorderRadius.circular(kCardRadius),
            border: Border.all(color: palette.cardBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.explore, color: palette.accent, size: 36),
              const SizedBox(height: 12),
              Text(
                widget.strings.qiblahLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: palette.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _statusMessage ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(color: palette.mutedTextColor),
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
                      label: Text(widget.strings.openSettingsLabel),
                    ),
                  if (_serviceDisabled)
                    OutlinedButton.icon(
                      onPressed: Geolocator.openLocationSettings,
                      icon: const Icon(Icons.location_on),
                      label: Text(widget.strings.enableLocationLabel),
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
        ? widget.strings.qiblahCalibratingLabel
        : '';
    final qiblahDisplay = qiblah == null ? '--' : '°';
    final difference = (heading != null && qiblah != null)
        ? _normalizeDegrees(qiblah - heading)
        : null;

    final northAngle = _degToRad(-(heading ?? 0));
    final qiblahAngle = (heading != null && qiblah != null)
        ? _degToRad(_normalizeDegrees(qiblah - heading))
        : _degToRad(qiblah ?? 0);
    final palette = ThemePalette.of(context);
    final textColor = palette.textColor;
    final muted = palette.mutedTextColor;

    return _glassCard(
      padding: kCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.explore, color: palette.accent),
              const SizedBox(width: 8),
              Text(
                'Live Compass',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: palette.heroHighlight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  headingDisplay,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: palette.accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 260,
            width: 260,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        palette.accent.withValues(alpha: 0.18),
                        palette.heroHighlight,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: palette.accent.withValues(alpha: 0.25),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                const _CompassBackground(),
                Transform.rotate(
                  angle: northAngle,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Icon(Icons.navigation, size: 42, color: muted),
                  ),
                ),
                Transform.rotate(
                  angle: qiblahAngle,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: palette.accent.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.navigation,
                        size: 64,
                        color: palette.background,
                      ),
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
              _buildInfoChip(widget.strings.qiblahHeadingLabel, headingDisplay),
              _buildInfoChip(widget.strings.qiblahLabel, qiblahDisplay),
              _buildInfoChip(
                widget.strings.qiblahGuidanceLabel,
                _turnText(difference),
              ),
            ],
          ),
          if (!_compassAvailable)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                widget.strings.qiblahCompassUnavailableMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: palette.accent, fontSize: 12),
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
    final palette = ThemePalette.of(context);
    final textColor = palette.textColor;
    final muted = palette.mutedTextColor;

    return _glassCard(
      padding: kCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: palette.accent),
              const SizedBox(width: 8),
              Text(
                widget.strings.qiblahLocationSnapshotLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _DetailRow(
            label: widget.strings.qiblahLatitudeLabel,
            value: lat != null ? lat.toStringAsFixed(4) : '--',
          ),
          _DetailRow(
            label: widget.strings.qiblahLongitudeLabel,
            value: lon != null ? lon.toStringAsFixed(4) : '--',
          ),
          _DetailRow(
            label: widget.strings.qiblahDistanceLabel,
            value: distance != null
                ? '${distance.toStringAsFixed(1)} km'
                : '--',
          ),
          const SizedBox(height: 12),
          Text(
            widget.strings.qiblahInstructionLabel,
            style: TextStyle(color: muted, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    final palette = ThemePalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: palette.heroHighlight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(color: palette.mutedTextColor, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: palette.textColor,
            ),
          ),
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
    final strings = widget.strings;
    if (difference == null) {
      return strings.qiblahCalibratePrompt;
    }
    if (difference <= 3) {
      return strings.qiblahAlignedLabel;
    }
    if (difference > 180) {
      final value = '${(360 - difference).toStringAsFixed(1)}°';
      return strings.qiblahTurnLeftFormat.replaceFirst('{degrees}', value);
    }
    final value = '${difference.toStringAsFixed(1)}°';
    return strings.qiblahTurnRightFormat.replaceFirst('{degrees}', value);
  }

  Widget _glassCard({
    required Widget child,
    EdgeInsetsGeometry padding = kCardPadding,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemePalette.of(context).panelColor,
            ThemePalette.of(context).heroHighlight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: ThemePalette.of(context).cardBorder),
        boxShadow: [
          BoxShadow(
            color: ThemePalette.of(context).accent.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _metricPill(String label, String value) {
    final palette = ThemePalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: palette.heroHighlight,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: palette.mutedTextColor, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: palette.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompassBackground extends StatelessWidget {
  const _CompassBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.02),
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(color: ThemePalette.of(context).cardBorder),
      ),
      child: const Stack(
        children: [
          _CardinalLabel(label: 'N', alignment: Alignment.topCenter),
          _CardinalLabel(label: 'S', alignment: Alignment.bottomCenter),
          _CardinalLabel(label: 'E', alignment: Alignment.centerRight),
          _CardinalLabel(label: 'W', alignment: Alignment.centerLeft),
        ],
      ),
    );
  }
}

class _CardinalLabel extends StatelessWidget {
  const _CardinalLabel({required this.label, required this.alignment});

  final String label;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ThemePalette.of(context).mutedTextColor,
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = ThemePalette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: palette.mutedTextColor)),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: palette.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

enum _AsmaSort { number, name }

class AsmaulHusnaTab extends StatefulWidget {
  const AsmaulHusnaTab({
    super.key,
    required this.strings,
    required this.language,
  });

  final AppStrings strings;
  final AppLanguage language;

  @override
  State<AsmaulHusnaTab> createState() => _AsmaulHusnaTabState();
}

class _AsmaulHusnaTabState extends State<AsmaulHusnaTab> {
  String _query = '';
  bool _showMeaning = true;
  _AsmaSort _sortMode = _AsmaSort.number;

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final filtered = kAsmaulHusna.where((entry) {
      if (query.isEmpty) return true;
      final meaning = entry.meaningFor(widget.language).toLowerCase();
      return entry.transliteration.toLowerCase().contains(query) ||
          meaning.contains(query) ||
          entry.number.toString().startsWith(query);
    }).toList();
    filtered.sort((a, b) {
      if (_sortMode == _AsmaSort.name) {
        return a.transliteration.toLowerCase().compareTo(
          b.transliteration.toLowerCase(),
        );
      }
      return a.number.compareTo(b.number);
    });

    return ListView(
      padding: kPagePadding,
      physics: const BouncingScrollPhysics(),
      children: [
        _buildNamesHeader(context, filtered.length),
        const SizedBox(height: 12),
        _buildControlsCard(context),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          _buildEmptyState(context)
        else
          ...filtered.map(
            (entry) => _AsmaNameCard(
              entry: entry,
              strings: widget.strings,
              language: widget.language,
              showMeaning: _showMeaning,
            ),
          ),
      ],
    );
  }

  Widget _buildNamesHeader(BuildContext context, int count) {
    final palette = ThemePalette.of(context);
    return Container(
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kPanelRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: palette.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.auto_awesome, color: palette.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.strings.namesLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.strings.namesSubtitle,
                  style: TextStyle(color: palette.mutedTextColor),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: palette.heroHighlight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: palette.cardBorder),
            ),
            child: Text(
              '${count.toString().padLeft(2, '0')}/${kAsmaulHusna.length}',
              style: TextStyle(
                color: palette.textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsCard(BuildContext context) {
    final palette = ThemePalette.of(context);
    return Container(
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: widget.strings.namesSearchHint,
              prefixIcon: Icon(Icons.search, color: palette.mutedTextColor),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: widget.strings.resetLabel,
                      onPressed: () => setState(() => _query = ''),
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildControlChip(
                icon: Icons.format_list_numbered,
                label: '1-99',
                selected: _sortMode == _AsmaSort.number,
                onSelected: () => setState(() => _sortMode = _AsmaSort.number),
              ),
              _buildControlChip(
                icon: Icons.sort_by_alpha,
                label: 'A-Z',
                selected: _sortMode == _AsmaSort.name,
                onSelected: () => setState(() => _sortMode = _AsmaSort.name),
              ),
              _buildControlChip(
                icon: Icons.translate,
                label: widget.strings.meaningLabel,
                selected: _showMeaning,
                onSelected: () => setState(() => _showMeaning = !_showMeaning),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlChip({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    final palette = ThemePalette.of(context);
    final chipTextColor = selected ? palette.background : palette.textColor;
    return ChoiceChip(
      selectedColor: palette.accent.withValues(alpha: 0.2),
      backgroundColor: palette.panelColor,
      side: BorderSide(color: selected ? palette.accent : palette.cardBorder),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: chipTextColor),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: chipTextColor)),
        ],
      ),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final palette = ThemePalette.of(context);
    return Container(
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.heroHighlight,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: palette.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.search_off, color: palette.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.strings.namesEmptyLabel,
              style: TextStyle(color: palette.mutedTextColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _AsmaNameCard extends StatelessWidget {
  const _AsmaNameCard({
    required this.entry,
    required this.strings,
    required this.language,
    required this.showMeaning,
  });

  final AsmaulHusnaEntry entry;
  final AppStrings strings;
  final AppLanguage language;
  final bool showMeaning;

  String _shareLabel() {
    return switch (language) {
      AppLanguage.kurdish => 'هاوبەشکردن',
      AppLanguage.arabic => 'مشاركة',
      AppLanguage.english => 'Share',
    };
  }

  String _shareText() {
    final meaning = entry.meaningFor(language);
    final buffer = StringBuffer()
      ..writeln(entry.arabic)
      ..writeln(entry.transliteration);
    if (meaning.isNotEmpty) {
      buffer.writeln(meaning);
    }
    return buffer.toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    final palette = ThemePalette.of(context);
    final meaning = entry.meaningFor(language);
    final meaningLabelText =
        '${strings.meaningLabel} (${strings.languageName})';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: palette.accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: palette.cardBorder),
                ),
                child: Text(
                  entry.number.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: palette.textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.transliterationLabel,
                      style: TextStyle(
                        color: palette.mutedTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.transliteration,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                        color: palette.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              entry.arabic,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: palette.textColor,
              ),
            ),
          ),
          if (showMeaning && meaning.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              meaningLabelText,
              style: TextStyle(
                color: palette.mutedTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              meaning,
              style: TextStyle(color: palette.mutedTextColor, height: 1.35),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _AsmaActionButton(
                icon: Icons.content_copy,
                label: strings.copyLabel,
                onTap: () {
                  Clipboard.setData(ClipboardData(text: _shareText()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(strings.copiedMessage)),
                  );
                },
              ),
              _AsmaActionButton(
                icon: Icons.share,
                label: _shareLabel(),
                onTap: () => Share.share(_shareText()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AsmaActionButton extends StatelessWidget {
  const _AsmaActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = ThemePalette.of(context);
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: palette.heroHighlight,
        foregroundColor: palette.textColor,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: palette.cardBorder),
        ),
      ),
      icon: Icon(icon, size: 16),
      label: Text(label),
    );
  }
}

class ZikrTab extends StatefulWidget {
  const ZikrTab({
    super.key,
    required this.strings,
    required this.palette,
    required this.language,
  });

  final AppStrings strings;
  final ThemePalette palette;
  final AppLanguage language;

  @override
  State<ZikrTab> createState() => _ZikrTabState();
}

class _ZikrTabState extends State<ZikrTab> with AutomaticKeepAliveClientMixin {
  String _selectedCategory = 'morning';
  final Map<int, int> _counts = {};

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final categories = [
      (
        key: 'morning',
        label: widget.strings.zikrMorningLabel,
        icon: Icons.wb_sunny_outlined,
      ),
      (
        key: 'evening',
        label: widget.strings.zikrEveningLabel,
        icon: Icons.nightlight_round,
      ),

      (
        key: 'daily',
        label: widget.strings.zikrGeneralLabel,
        icon: Icons.all_inclusive,
      ),
      (key: 'all', label: widget.strings.zikrAllLabel, icon: Icons.layers),
    ];
    final filtered = _selectedCategory == 'all'
        ? kAdhkarItems
        : kAdhkarItems
              .where((item) => item.category == _selectedCategory)
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.strings.zikrLabel,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.strings.zikrSubtitle,
                style: TextStyle(color: widget.palette.mutedTextColor),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = cat.key == _selectedCategory;
                    final chipTextColor = isSelected
                        ? widget.palette.background
                        : widget.palette.textColor;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        selectedColor: widget.palette.accent.withValues(
                          alpha: 1.0,
                        ),
                        backgroundColor: widget.palette.panelColor,
                        side: BorderSide(
                          color: isSelected
                              ? widget.palette.accent
                              : widget.palette.cardBorder,
                        ),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(cat.icon, size: 16, color: chipTextColor),
                            const SizedBox(width: 6),
                            Text(
                              cat.label,
                              style: TextStyle(color: chipTextColor),
                            ),
                          ],
                        ),
                        selected: isSelected,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = cat.key),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final item = filtered[index];
              final globalIndex = kAdhkarItems.indexOf(item);
              final target = item.repeat;
              final current = _counts[globalIndex] ?? 0;
              final progress = target > 0
                  ? (current / target).clamp(0.0, 1.0)
                  : 0.0;
              return _buildZikrCard(
                context,
                item: item,
                index: globalIndex,
                current: current,
                target: target,
                progress: progress,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildZikrCard(
    BuildContext context, {
    required AdhkarItem item,
    required int index,
    required int current,
    required int target,
    required double progress,
  }) {
    final palette = widget.palette;
    final categoryLabel = switch (item.category) {
      'morning' => widget.strings.zikrMorningLabel,
      'evening' => widget.strings.zikrEveningLabel,
      _ => widget.strings.zikrGeneralLabel,
    };
    final translationText = item.translationFor(widget.language);
    final translationLabel =
        '${widget.strings.translationLabel} (${widget.strings.languageName})';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: kCardPadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
        color: palette.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: palette.accent.withValues(alpha: 0.1),
                  ),
                  child: Text(
                    categoryLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: palette.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (item.reference.isNotEmpty)
                Expanded(
                  child: Text(
                    item.reference,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: palette.mutedTextColor,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: widget.strings.copyLabel,
                    onPressed: () => _copyItem(item),
                    icon: const Icon(Icons.copy_rounded),
                  ),
                  IconButton(
                    tooltip: widget.strings.resetLabel,
                    onPressed: () => setState(() => _counts.remove(index)),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.arabic,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.transliteration,
            style: TextStyle(
              color: palette.mutedTextColor,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          if (translationText.isNotEmpty) ...[
            Text(
              translationLabel,
              style: TextStyle(
                color: palette.mutedTextColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              translationText,
              style: TextStyle(color: palette.mutedTextColor, height: 1.4),
            ),
          ],
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: palette.cardBorder.withValues(alpha: 0.4),
              color: palette.accent,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${widget.strings.zikrCounterLabel}: $current / $target',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => _incrementCounter(index, target),
                icon: const Icon(Icons.add),
                label: Text(widget.strings.zikrCounterLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _incrementCounter(int index, int target) {
    setState(() {
      final current = _counts[index] ?? 0;
      final next = current + 1;
      _counts[index] = target == 0 ? next : (next > target ? target : next);
    });
  }

  Future<void> _copyItem(AdhkarItem item) async {
    final text = [
      item.arabic,
      item.transliteration,
      item.translationFor(widget.language),
    ].join('\n');
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(widget.strings.copiedMessage)));
  }

  @override
  bool get wantKeepAlive => true;
}

class SettingsTab extends StatefulWidget {
  const SettingsTab({
    super.key,
    required this.strings,
    required this.currentLanguage,
    required this.currentTranslation,
    required this.readTextScale,
    required this.onReadTranslationChanged,
    required this.onReadTextScaleChanged,
    required this.palette,
    required this.prayerLocation,
    required this.onPrayerLocationChanged,
    required this.prayerSound,
    required this.onPrayerSoundChanged,
    required this.prayerSoundRespectSilent,
    required this.onPrayerSoundRespectSilentChanged,
  });

  final AppStrings strings;
  final AppLanguage currentLanguage;
  final TranslationOption currentTranslation;
  final double readTextScale;
  final ValueChanged<TranslationOption> onReadTranslationChanged;
  final ValueChanged<double> onReadTextScaleChanged;
  final ThemePalette palette;
  final PresetLocation? prayerLocation;
  final ValueChanged<PresetLocation?> onPrayerLocationChanged;
  final PrayerSoundOption prayerSound;
  final ValueChanged<PrayerSoundOption> onPrayerSoundChanged;
  final bool prayerSoundRespectSilent;
  final ValueChanged<bool> onPrayerSoundRespectSilentChanged;

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  SettingsSection _selectedSection = SettingsSection.appearance;
  late final AudioPlayer _previewPlayer;
  StreamSubscription<PlayerState>? _previewSubscription;
  String? _previewSoundId;
  bool _previewPlaying = false;
  bool _previewLoading = false;

  @override
  void initState() {
    super.initState();
    try {
      _previewPlayer = AudioPlayer();
    } catch (e) {
      debugPrint("Failed to initialize _previewPlayer: $e");
    }
    _previewSubscription = _previewPlayer.playerStateStream.listen((state) {
      if (!mounted) return;
      setState(() => _previewPlaying = state.playing);
    });
  }

  @override
  void dispose() {
    _previewSubscription?.cancel();
    _previewPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;
    return ListView(
      padding: kCardPadding,
      children: [
        Text(
          strings.settingsLabel,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _buildSectionSelector(),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _buildSectionContent(context),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSectionContent(BuildContext context) {
    final content = switch (_selectedSection) {
      SettingsSection.appearance => _buildAppearanceSection(context),
      SettingsSection.reading => _buildReadingCard(context),
      SettingsSection.prayerLocation => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationCard(context),
          const SizedBox(height: 16),
          _buildPrayerSoundCard(context),
        ],
      ),
      SettingsSection.about => _buildAboutSection(context),
    };
    return Container(key: ValueKey(_selectedSection), child: content);
  }

  Widget _buildAppearanceSection(BuildContext context) {
    final strings = widget.strings;
    final palette = widget.palette;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.panelColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.appearanceLabel,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildThemeOption(
            context,
            mode: ThemeMode.system,
            label: strings.systemThemeLabel,
            icon: Icons.brightness_auto,
            current: themeProvider.mode,
            onChanged: themeProvider.setThemeMode,
          ),
          const Divider(height: 1),
          _buildThemeOption(
            context,
            mode: ThemeMode.light,
            label: strings.lightThemeLabel,
            icon: Icons.light_mode,
            current: themeProvider.mode,
            onChanged: themeProvider.setThemeMode,
          ),
          const Divider(height: 1),
          _buildThemeOption(
            context,
            mode: ThemeMode.dark,
            label: strings.darkThemeLabel,
            icon: Icons.dark_mode,
            current: themeProvider.mode,
            onChanged: themeProvider.setThemeMode,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required ThemeMode mode,
    required String label,
    required IconData icon,
    required ThemeMode current,
    required ValueChanged<ThemeMode> onChanged,
  }) {
    final palette = widget.palette;
    final isSelected = current == mode;

    return InkWell(
      onTap: () => onChanged(mode),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? palette.accent.withValues(alpha: 0.1)
                    : palette.heroHighlight.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? palette.accent : palette.textColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: palette.textColor,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: palette.accent, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionSelector() {
    final strings = widget.strings;
    final palette = widget.palette;
    final sections = [
      (
        section: SettingsSection.appearance,
        label: strings.appearanceLabel,
        icon: Icons.palette_outlined,
      ),
      (
        section: SettingsSection.reading,
        label: strings.readLabel,
        icon: Icons.menu_book,
      ),
      (
        section: SettingsSection.prayerLocation,
        label: _prayerLocationLabel(widget.currentLanguage),
        icon: Icons.place,
      ),
      (
        section: SettingsSection.about,
        label: strings.aboutLabel,
        icon: Icons.info_outline,
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: sections.map((option) {
        final selected = option.section == _selectedSection;
        return ChoiceChip(
          selected: selected,
          selectedColor: palette.heroHighlight,
          backgroundColor: palette.panelColor,
          side: BorderSide(
            color: selected ? palette.accent : palette.cardBorder,
          ),
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                option.icon,
                size: 18,
                color: selected ? palette.accent : palette.textColor,
              ),
              const SizedBox(width: 6),
              Text(
                option.label,
                style: TextStyle(
                  color: palette.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          onSelected: (_) {
            setState(() => _selectedSection = option.section);
          },
        );
      }).toList(),
    );
  }

  Widget _buildReadingCard(BuildContext context) {
    final palette = widget.palette;
    final strings = widget.strings;
    final scalePercent = (widget.readTextScale * 100).round();
    return Container(
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, color: palette.accent),
              const SizedBox(width: 10),
              Text(
                strings.readLabel,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            strings.translationLabel,
            style: TextStyle(color: palette.mutedTextColor),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: palette.heroHighlight,
              borderRadius: BorderRadius.circular(kCardRadius),
              border: Border.all(color: palette.cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<TranslationOption>(
                value: widget.currentTranslation,
                isExpanded: true,
                dropdownColor: palette.navBackground,
                iconEnabledColor: palette.textColor,
                style: TextStyle(
                  color: palette.textColor,
                  fontWeight: FontWeight.w600,
                ),
                items: kTranslationOptions
                    .map(
                      (option) => DropdownMenuItem<TranslationOption>(
                        value: option,
                        child: Text(option.label),
                      ),
                    )
                    .toList(),
                onChanged: (option) {
                  if (option != null) {
                    widget.onReadTranslationChanged(option);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                strings.fontSizeLabel,
                style: TextStyle(color: palette.mutedTextColor),
              ),
              const Spacer(),
              Text(
                '$scalePercent%',
                style: TextStyle(
                  color: palette.textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Slider(
            value: widget.readTextScale,
            min: 0.85,
            max: 1.2,
            divisions: 7,
            label: '$scalePercent%',
            onChanged: widget.onReadTextScaleChanged,
          ),
          Row(
            children: [
              Text(
                'A',
                style: TextStyle(
                  color: palette.mutedTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'A',
                style: TextStyle(
                  color: palette.mutedTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context) {
    final palette = widget.palette;
    final language = widget.currentLanguage;
    final preset = widget.prayerLocation;
    final isCurrent = preset == null;
    final currentLocationLabel = _currentLocationLabel(language);
    final locationName = isCurrent
        ? currentLocationLabel
        : preset.localizedName(language);
    final description = isCurrent
        ? _currentLocationDescription(language)
        : _presetLocationDescription(language, locationName);
    final dropdownItems = <DropdownMenuItem<PresetLocation?>>[
      DropdownMenuItem<PresetLocation?>(
        value: null,
        child: Text(currentLocationLabel),
      ),
      ...kPresetLocations.map(
        (preset) => DropdownMenuItem<PresetLocation?>(
          value: preset,
          child: Text(preset.localizedName(language)),
        ),
      ),
    ];

    return Container(
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.place, color: palette.accent),
              const SizedBox(width: 10),
              Text(
                _prayerLocationLabel(language),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(description, style: TextStyle(color: palette.mutedTextColor)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: palette.heroHighlight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: palette.cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<PresetLocation?>(
                value: preset,
                isExpanded: true,
                dropdownColor: palette.navBackground,
                iconEnabledColor: palette.textColor,
                style: TextStyle(
                  color: palette.textColor,
                  fontWeight: FontWeight.w600,
                ),
                items: dropdownItems,
                onChanged: widget.onPrayerLocationChanged,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _prayerLocationNote(language),
            style: TextStyle(color: palette.mutedTextColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _previewPrayerSound(PrayerSoundOption sound) async {
    if (_previewPlaying && _previewSoundId == sound.id) {
      await _previewPlayer.stop();
      return;
    }
    setState(() {
      _previewLoading = true;
      _previewSoundId = sound.id;
    });
    try {
      await _previewPlayer.setAudioSource(AudioSource.asset(sound.asset));
      await _previewPlayer.play();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to play the selected sound.')),
      );
    } finally {
      if (mounted) {
        setState(() => _previewLoading = false);
      }
    }
  }

  Widget _buildPrayerSoundCard(BuildContext context) {
    final palette = widget.palette;
    final sound = widget.prayerSound;
    final isTesting = _previewPlaying && _previewSoundId == sound.id;
    return Container(
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.volume_up, color: palette.accent),
              const SizedBox(width: 10),
              Text(
                widget.strings.adhanSoundLabel,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Choose the sound for prayer time alerts.',
            style: TextStyle(color: palette.mutedTextColor),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: palette.heroHighlight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: palette.cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<PrayerSoundOption>(
                value: sound,
                isExpanded: true,
                dropdownColor: palette.navBackground,
                iconEnabledColor: palette.textColor,
                style: TextStyle(
                  color: palette.textColor,
                  fontWeight: FontWeight.w600,
                ),
                items: kPrayerSoundOptions
                    .map(
                      (option) => DropdownMenuItem<PrayerSoundOption>(
                        value: option,
                        child: Text(option.label),
                      ),
                    )
                    .toList(),
                onChanged: (option) async {
                  if (option == null || option.id == sound.id) return;
                  if (_previewPlaying) {
                    await _previewPlayer.stop();
                  }
                  widget.onPrayerSoundChanged(option);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Use phone volume (mute with silent)',
                  style: TextStyle(color: palette.mutedTextColor),
                ),
              ),
              Switch.adaptive(
                value: widget.prayerSoundRespectSilent,
                onChanged: widget.onPrayerSoundRespectSilentChanged,
                thumbColor: WidgetStatePropertyAll(palette.accent),
                trackColor: WidgetStatePropertyAll(
                  palette.accent.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _previewLoading
                ? null
                : () => _previewPrayerSound(sound),
            icon: Icon(isTesting ? Icons.stop : Icons.play_arrow),
            label: Text(isTesting ? 'Stop test' : 'Test sound'),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final strings = widget.strings;
    final socialLinks = [
      _SocialLink(
        icon: FontAwesomeIcons.facebook,
        url: 'https://www.facebook.com/share/1AbQgZCHrf/',
        label: strings.facebookLabel,
        color: const Color(0xFF1877F2),
      ),
      _SocialLink(
        icon: FontAwesomeIcons.whatsapp,
        url: 'https://wa.me/qr/SU3ES4U33UHPC1',
        label: strings.whatsappLabel,
        color: const Color(0xFF25D366),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.aboutLabel,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _InfoCard(
          icon: Icons.person,
          title: strings.creatorTitle,
          description: strings.creatorDescription,
        ),
        const SizedBox(height: 12),
        _InfoCard(
          icon: Icons.favorite,
          title: strings.purposeTitle,
          description: strings.purposeDesc,
        ),
        const SizedBox(height: 18),
        Text(
          strings.findMeLabel,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: socialLinks
              .map((link) => _SocialButton(link: link))
              .toList(),
        ),
      ],
    );
  }
}

class _SocialLink {
  const _SocialLink({
    required this.icon,
    required this.url,
    required this.label,
    this.color,
  });

  final IconData icon;
  final String url;
  final String label;
  final Color? color;
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.link});

  final _SocialLink link;

  @override
  Widget build(BuildContext context) {
    final palette = ThemePalette.of(context);
    final background = link.color ?? palette.cardColor;
    final foreground = link.color != null
        ? palette.background
        : palette.textColor;
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
      ),
      onPressed: () => _launchExternal(link.url),
      icon: Icon(link.icon),
      label: Text(link.label),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final palette = ThemePalette.of(context);
    return Container(
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: palette.accent),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(color: palette.mutedTextColor, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _launchExternal(String url) async {
  final uri = Uri.parse(url);
  final canExternal = await canLaunchUrl(uri);
  if (canExternal) {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (launched) return;
  }
  // Fallback to in-app webview/browser if no external handler.
  final fallbackLaunched = await launchUrl(
    uri,
    mode: LaunchMode.platformDefault,
  );
  if (!fallbackLaunched) {
    debugPrint('Cannot launch $url');
  }
}

class KidsPrayerTab extends StatelessWidget {
  const KidsPrayerTab({
    super.key,
    required this.strings,
    required this.language,
    required this.palette,
  });

  final AppStrings strings;
  final AppLanguage language;
  final ThemePalette palette;

  String _t(String en, String ku, String ar) {
    return switch (language) {
      AppLanguage.kurdish => ku,
      AppLanguage.arabic => ar,
      _ => en,
    };
  }

  @override
  Widget build(BuildContext context) {
    final videoAssets = {
      AppLanguage.kurdish: 'asset/video/kurdish_prayer.mp4',
      AppLanguage.arabic: 'asset/video/arabic_prayer.mp4',
      AppLanguage.english: 'asset/video/english_prayer.mp4',
    };
    final videoAsset =
        videoAssets[language] ?? videoAssets[AppLanguage.english]!;
    final sections = [
      (
        title: _t("Rak'ah Counts", 'ژمارەی ڕەکاتەکان', 'عدد الركعات'),
        body: _t(
          'Fajr: 2\nDhuhr: 4\nAsr: 4\nMaghrib: 3\nIsha: 4\nWitr: 1-3 (after Isha)',
          'فەجر: ٢\nنیووەڕۆ: ٤\nعەسر: ٤\nمەغریب: ٣\nعیشا: ٤\nوتر: ١-٣ (دوای عیشا)',
          'الفجر: ٢\nالظهر: ٤\nالعصر: ٤\nالمغرب: ٣\nالعشاء: ٤\nالوتر: ١-٣ (بعد العشاء)',
        ),
      ),
    ];

    final surahCards = [
      _KidsSurahCardData(
        title: _t('Al-Fatiha', 'سوورەی فاتحە', 'سورة الفاتحة'),
        description: _t(
          'Opening chapter of the Quran.',
          'سوورەی دەستپێکی قورئان.',
          'سورة افتتاح القرآن.',
        ),
        arabic:
            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\nالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ\nالرَّحْمَٰنِ الرَّحِيمِ\nمَالِكِ يَوْمِ الدِّينِ\nإِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\nاهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ\nصِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
        transliteration:
            "Bismillahir rahmanir rahim\nAlhamdu lillahi rabbil 'alamin\nAr-rahmanir rahim\nMaliki yawmid-din\nIyyaka na'budu wa iyyaka nasta'in\nIhdinas-siratal-mustaqim\nSiratal-ladhina an'amta 'alayhim ghayril-maghdubi 'alayhim walad-dallin",
      ),
      _KidsSurahCardData(
        title: _t(
          'At-Tahiyyat (Tashahhud)',
          'تەشەهەد (التحیات)',
          'التشهد (التحيات)',
        ),
        description: _t(
          'Sitting supplication said before salam.',
          'دوعای دانیشتن پێش سەلام.',
          'دعاء الجلوس قبل السلام.',
        ),
        arabic:
            'ٱلتَّحِيَّاتُ لِلّٰهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ، ٱلسَّلَامُ عَلَيْكَ أَيُّهَا ٱلنَّبِيُّ وَرَحْمَةُ ٱللّٰهِ وَبَرَكَاتُهُ، ٱلسَّلَامُ عَلَيْنَا وَعَلَىٰ عِبَادِ ٱللّٰهِ ٱلصَّالِحِينَ، أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا ٱللّٰهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ.',
        transliteration:
            'At-tahiyyatu lillahi was-salawatu wat-tayyibat, as-salamu \'alayka ayyuhan-nabiyyu wa rahmatullahi wa barakatuh, as-salamu \'alayna wa \'ala \'ibadillahis-salihin, ash-hadu an la ilaha illallahu wa ash-hadu anna Muhammadan \'abduhu wa rasuluh.',
      ),
      _KidsSurahCardData(
        title: _t('Al-Falaq', 'سوورەی فەلەق', 'سورة الفلق'),
        description: _t(
          'Protection from harm and darkness.',
          'پاراستن لە خراپی و تاریکی.',
          'حماية من الشر والظلام.',
        ),
        arabic:
            'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ\nمِن شَرِّ مَا خَلَقَ\nوَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ\nوَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ\nوَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ',
        transliteration:
            "Qul a'udhu bi rabbil-falaq\nMin sharri ma khalaq\nWa min sharri ghasiqin idha waqab\nWa min sharri an-naffathati fil-'uqad\nWa min sharri hasidin idha hasad",
      ),
      _KidsSurahCardData(
        title: _t('An-Nas', 'سوورەی ناس', 'سورة الناس'),
        description: _t(
          'Seeking refuge with the Lord of people.',
          'پەنا بردن بۆ پەروەردگاری خەڵک.',
          'الاستعاذة برب الناس.',
        ),
        arabic:
            'قُلْ أَعُوذُ بِرَبِّ النَّاسِ\nمَلِكِ النَّاسِ\nإِلَٰهِ النَّاسِ\nمِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ\nالَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ\nمِنَ الْجِنَّةِ وَالنَّاسِ',
        transliteration:
            "Qul a'udhu bi rabbin-nas\nMalikin-nas\nIlahin-nas\nMin sharri al-waswasil-khannas\nAlladhi yuwaswisu fi sudurin-nas\nMinal-jinnati wan-nas",
      ),
    ];

    return ListView(
      padding: kPagePadding,
      children: [
        Text(
          strings.learnPrayerLabel,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          _t(
            "Simple steps, rak'ah counts, and key surahs with easy phrases.",
            'هەنگاوە سادەکان، ژمارەی ڕەکاتەکان، و سوورە گرنگەکان بە وشەی ئاسان.',
            'خطوات بسيطة، وعدد الركعات، وسور مهمة بعبارات سهلة.',
          ),
          style: TextStyle(color: palette.mutedTextColor),
        ),
        const SizedBox(height: 16),
        _VideoCard(
          title: _t(
            'How to Pray (Video)',
            'چۆنیەتی نوێژکردن (ڤیدیۆ)',
            'كيفية الصلاة (فيديو)',
          ),
          description: _t(
            'Step-by-step prayer demo.',
            'ڕێنمایی هەنگاو بە هەنگاو بۆ نوێژکردن.',
            'شرح خطوة بخطوة للصلاة.',
          ),
          url: videoAsset,
          palette: palette,
        ),
        const SizedBox(height: 16),
        ...sections.map(
          (section) => _InfoCard(
            icon: Icons.info_outline,
            title: section.title,
            description: section.body,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          strings.surahListLabel,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...surahCards.map(
          (data) => _KidsSurahCard(data: data, palette: palette),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _KidsSurahCardData {
  const _KidsSurahCardData({
    required this.title,
    required this.description,
    required this.arabic,
    required this.transliteration,
  });

  final String title;
  final String description;
  final String arabic;
  final String transliteration;
}

class _VideoCard extends StatelessWidget {
  const _VideoCard({
    required this.title,
    required this.description,
    required this.url,
    required this.palette,
  });

  final String title;
  final String description;
  final String url;
  final ThemePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.ondemand_video, color: palette.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(description, style: TextStyle(color: palette.mutedTextColor)),
          const SizedBox(height: 12),
          _InlineVideoPlayer(url: url, palette: palette),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _InlineVideoPlayer extends StatefulWidget {
  const _InlineVideoPlayer({required this.url, required this.palette});

  final String url;
  final ThemePalette palette;

  @override
  State<_InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<_InlineVideoPlayer> {
  VideoPlayerController? _controller;
  Future<void>? _initFuture;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeController();
  }

  @override
  void didUpdateWidget(covariant _InlineVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      setState(() {
        _initFuture = _initializeController();
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    final ctrl = _controller;
    if (ctrl == null || !ctrl.value.isInitialized) return;
    if (ctrl.value.isPlaying) {
      ctrl.pause();
    } else {
      ctrl.play();
    }
    setState(() {});
  }

  Future<void> _initializeController() async {
    _controller?.dispose();
    _controller = null;
    _error = null;
    try {
      final controller = await _buildController(widget.url);
      await controller.initialize();
      controller.setLooping(true);
      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _error = controller.value.hasError
            ? (controller.value.errorDescription ?? 'Unable to load video')
            : null;
      });
    } catch (e) {
      debugPrint('Video init failed for ${widget.url}: $e');
      if (!mounted) return;
      setState(() {
        _controller = null;
        _error = 'Unable to load video';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _buildPlaceholder(child: const CircularProgressIndicator());
        }

        if (_error != null) {
          return _buildPlaceholder(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Video unavailable'),
                const SizedBox(height: 6),
                Text(
                  _error!,
                  style: TextStyle(color: widget.palette.mutedTextColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _initFuture = _initializeController();
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final ctrl = _controller;
        if (ctrl == null || !ctrl.value.isInitialized) {
          return _buildPlaceholder(child: const Text('Video unavailable'));
        }

        final aspect = ctrl.value.aspectRatio == 0
            ? 16 / 9
            : ctrl.value.aspectRatio;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: aspect,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(ctrl),
                    if (!ctrl.value.isPlaying)
                      Container(
                        color: Colors.black45,
                        child: IconButton.filled(
                          iconSize: 48,
                          style: IconButton.styleFrom(
                            backgroundColor: widget.palette.accent,
                          ),
                          onPressed: _togglePlay,
                          icon: const Icon(Icons.play_arrow),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: _togglePlay,
                  icon: Icon(
                    (_controller?.value.isPlaying ?? false)
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${_formatDuration(ctrl.value.position)} / ${_formatDuration(ctrl.value.duration)}',
                  style: TextStyle(color: widget.palette.mutedTextColor),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    return '${d.inHours > 0 ? '${two(d.inHours)}:' : ''}$m:$s';
  }

  String _normalizeDriveUrl(String url) {
    Uri? parsed;
    try {
      parsed = Uri.parse(url);
    } catch (_) {
      return url;
    }

    if (parsed.host.contains('drive.google.com')) {
      final fileId = parsed.queryParameters['id'];
      if (fileId != null && fileId.isNotEmpty) {
        return Uri.https('drive.usercontent.google.com', '/download', {
          'id': fileId,
          'export': 'download',
          'confirm': 't',
        }).toString();
      }
    }

    if (parsed.host.contains('drive.usercontent.google.com')) {
      final params = Map<String, String>.from(parsed.queryParameters);
      final fileId = params['id'];
      if (fileId != null && fileId.isNotEmpty) {
        params['export'] = params['export'] ?? 'download';
        params['confirm'] = params['confirm'] ?? 't';
        return Uri.https(parsed.host, parsed.path, params).toString();
      }
    }

    return url;
  }

  Future<VideoPlayerController> _buildController(String source) async {
    try {
      if (source.startsWith('asset/')) {
        if (kIsWeb) {
          final assetUrl = _assetUrlForWeb(source);
          return VideoPlayerController.networkUrl(
            Uri.parse(assetUrl),
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
          );
        }
        return VideoPlayerController.asset(
          source,
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        );
      }

      return VideoPlayerController.networkUrl(
        Uri.parse(_normalizeDriveUrl(source)),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
    } catch (e) {
      debugPrint("Failed to build VideoPlayerController: $e");
      // Return a basic controller to avoid crash, or handle empty state in UI
      return VideoPlayerController.networkUrl(Uri.parse(''));
    }
  }

  String _assetUrlForWeb(String assetPath) {
    final normalized = assetPath.startsWith('/')
        ? assetPath.substring(1)
        : assetPath;
    return 'assets/$normalized';
  }

  Widget _buildPlaceholder({Widget? child}) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.palette.cardBorder),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _KidsSurahCard extends StatelessWidget {
  const _KidsSurahCard({required this.data, required this.palette});

  final _KidsSurahCardData data;
  final ThemePalette palette;

  @override
  Widget build(BuildContext context) {
    final data = this.data;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: kCardPadding,
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, color: palette.accent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  data.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.description,
            style: TextStyle(color: palette.mutedTextColor),
          ),
          const SizedBox(height: 12),
          Text(
            data.arabic,
            textAlign: TextAlign.start,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 8),
          Text(
            data.transliteration,
            style: TextStyle(color: palette.mutedTextColor, height: 1.4),
          ),
        ],
      ),
    );
  }
}
