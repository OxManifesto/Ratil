import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants/app_language.dart';
import 'data/adhkar_data.dart';
import 'data/asmaul_husna.dart';
import 'data/surah_database.dart';

enum AppThemeStyle { aurora, dune, midnight, forest, royal }

enum SettingsSection { appearance, language, about }

class ThemePalette {
  const ThemePalette({
    required this.gradients,
    required this.panelColor,
    required this.cardColor,
    required this.cardBorder,
    required this.navBackground,
    required this.navBorder,
    required this.navIndicator,
    required this.accent,
    required this.chipColor,
    required this.heroHighlight,
  });

  final List<List<Color>> gradients;
  final Color panelColor;
  final Color cardColor;
  final Color cardBorder;
  final Color navBackground;
  final Color navBorder;
  final Color navIndicator;
  final Color accent;
  final Color chipColor;
  final Color heroHighlight;
}

const Map<AppThemeStyle, ThemePalette> kThemePalettes = {
  AppThemeStyle.aurora: ThemePalette(
    gradients: [
      [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
      [Color(0xFF1D2B64), Color(0xFF1D976C), Color(0xFF93F9B9)],
      [Color(0xFF42275A), Color(0xFF734B6D), Color(0xFFC2FFD8)],
    ],
    panelColor: Color(0x66152233),
    cardColor: Color(0x331C3A4B),
    cardBorder: Color(0x3349C5B6),
    navBackground: Color(0xAA101B2B),
    navBorder: Color(0x2249C5B6),
    navIndicator: Color(0x4449C5B6),
    accent: Color(0xFF4FFFB0),
    chipColor: Color(0x3349C5B6),
    heroHighlight: Color(0x1AFFFFFF),
  ),
  AppThemeStyle.dune: ThemePalette(
    gradients: [
      [Color(0xFFFF512F), Color(0xFFF09819), Color(0xFFED8D00)],
      [Color(0xFF8E2DE2), Color(0xFFDA4453), Color(0xFFFAD961)],
      [Color(0xFFE96443), Color(0xFF904E95), Color(0xFFFFC371)],
    ],
    panelColor: Color(0x661E0F08),
    cardColor: Color(0x33FFE0B2),
    cardBorder: Color(0x33FFD180),
    navBackground: Color(0xAAB24C14),
    navBorder: Color(0x33FFD180),
    navIndicator: Color(0x44FFAB40),
    accent: Color(0xFFFFC07F),
    chipColor: Color(0x33FFAB40),
    heroHighlight: Color(0x1AFFE0B2),
  ),
  AppThemeStyle.midnight: ThemePalette(
    gradients: [
      [Color(0xFF141E30), Color(0xFF243B55), Color(0xFF232526)],
      [Color(0xFF240B36), Color(0xFF2C5364), Color(0xFF283048)],
      [Color(0xFF000428), Color(0xFF004E92), Color(0xFF2C3E50)],
    ],
    panelColor: Color(0x66101425),
    cardColor: Color(0x3320324A),
    cardBorder: Color(0x332C82C9),
    navBackground: Color(0xAA101528),
    navBorder: Color(0x222C82C9),
    navIndicator: Color(0x442C82C9),
    accent: Color(0xFF5CC6FF),
    chipColor: Color(0x332C82C9),
    heroHighlight: Color(0x1A5CC6FF),
  ),
  AppThemeStyle.forest: ThemePalette(
    gradients: [
      [Color(0xFF0B486B), Color(0xFFF56217), Color(0xFF4ECDC4)],
      [Color(0xFF005C97), Color(0xFF363795), Color(0xFF56AB2F)],
      [Color(0xFF134E5E), Color(0xFF71B280), Color(0xFF3D7E91)],
    ],
    panelColor: Color(0x660E2A1D),
    cardColor: Color(0x333D614A),
    cardBorder: Color(0x334ED0C0),
    navBackground: Color(0xAA0F211A),
    navBorder: Color(0x224ED0C0),
    navIndicator: Color(0x444ED0C0),
    accent: Color(0xFF7EF29D),
    chipColor: Color(0x334ED0C0),
    heroHighlight: Color(0x1A7EF29D),
  ),
  AppThemeStyle.royal: ThemePalette(
    gradients: [
      [Color(0xFF240046), Color(0xFF5A189A), Color(0xFFF15BB5)],
      [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFDC830)],
      [Color(0xFF3A1C71), Color(0xFFD76D77), Color(0xFFFFAF7B)],
    ],
    panelColor: Color(0x661A0F29),
    cardColor: Color(0x333D284B),
    cardBorder: Color(0x33F15BB5),
    navBackground: Color(0xAA1A0F29),
    navBorder: Color(0x33F15BB5),
    navIndicator: Color(0x44F15BB5),
    accent: Color(0xFFFFC857),
    chipColor: Color(0x33F15BB5),
    heroHighlight: Color(0x1AFFC857),
  ),
};

const Map<AppThemeStyle, String> kThemeNames = {
  AppThemeStyle.aurora: 'Aurora',
  AppThemeStyle.dune: 'Dune',
  AppThemeStyle.midnight: 'Midnight',
  AppThemeStyle.forest: 'Forest',
  AppThemeStyle.royal: 'Royal',
};

class AppStrings {
  const AppStrings({
    required this.appTitle,
    required this.tagline,
    required this.listenLabel,
    required this.readLabel,
    required this.aboutLabel,
    required this.qiblahLabel,
    required this.namesLabel,
    required this.namesSubtitle,
    required this.settingsLabel,
    required this.zikrLabel,
    required this.zikrMorningLabel,
    required this.zikrEveningLabel,
    required this.zikrGeneralLabel,
    required this.zikrCounterLabel,
    required this.zikrSubtitle,
    required this.nowPlaying,
    required this.selectInstruction,
    required this.audioSubtitle,
    required this.creatorTitle,
    required this.creatorName,
    required this.creatorDescription,
    required this.offlineTitle,
    required this.offlineDesc,
    required this.aboutTitle,
    required this.aboutDesc,
    required this.purposeTitle,
    required this.purposeDesc,
    required this.languageLabel,
    required this.languageName,
    required this.pageLabelFormat,
    required this.previousPage,
    required this.nextPage,
    required this.noAudioMessage,
    required this.direction,
    required this.lockReadingLabel,
    required this.unlockReadingLabel,
    required this.preparingAudio,
    required this.retryLabel,
    required this.findMeLabel,
    required this.facebookLabel,
    required this.whatsappLabel,
    required this.recitationLabel,
    required this.recitationSubtitle,
    required this.englishTranslationLabel,
    required this.englishTranslationSubtitle,
    required this.kurdishTranslationLabel,
    required this.kurdishTranslationSubtitle,
    required this.translationLabel,
    required this.transliterationLabel,
    required this.meaningLabel,
    required this.copyLabel,
    required this.resetLabel,
    required this.copiedMessage,
    required this.zikrAllLabel,
    required this.namesSearchHint,
    required this.namesEmptyLabel,
    required this.openSettingsLabel,
    required this.enableLocationLabel,
    required this.qiblahServiceDisabledMessage,
    required this.qiblahPermissionForeverMessage,
    required this.qiblahPermissionDeniedMessage,
    required this.qiblahLocationUnavailableMessage,
    required this.qiblahCalibratingLabel,
    required this.qiblahHeadingLabel,
    required this.qiblahGuidanceLabel,
    required this.qiblahCompassUnavailableMessage,
    required this.qiblahLocationSnapshotLabel,
    required this.qiblahLatitudeLabel,
    required this.qiblahLongitudeLabel,
    required this.qiblahDistanceLabel,
    required this.qiblahInstructionLabel,
    required this.qiblahCalibratePrompt,
    required this.qiblahAlignedLabel,
    required this.qiblahTurnLeftFormat,
    required this.qiblahTurnRightFormat,
    required this.qariSharifLabel,
    required this.qariSharifSubtitle,
    required this.mushafArabicLabel,
    required this.mushafEnglishLabel,
    required this.mushafKurdishLabel,
    required this.reciterCommonLabel,
    required this.reciterNames,
  });

  final String appTitle;
  final String tagline;
  final String listenLabel;
  final String readLabel;
  final String aboutLabel;
  final String qiblahLabel;
  final String namesLabel;
  final String namesSubtitle;
  final String settingsLabel;
  final String zikrLabel;
  final String zikrMorningLabel;
  final String zikrEveningLabel;
  final String zikrGeneralLabel;
  final String zikrCounterLabel;
  final String zikrSubtitle;
  final String nowPlaying;
  final String selectInstruction;
  final String audioSubtitle;
  final String creatorTitle;
  final String creatorName;
  final String creatorDescription;
  final String offlineTitle;
  final String offlineDesc;
  final String aboutTitle;
  final String aboutDesc;
  final String purposeTitle;
  final String purposeDesc;
  final String languageLabel;
  final String languageName;
  final String pageLabelFormat;
  final String previousPage;
  final String nextPage;
  final String noAudioMessage;
  final TextDirection direction;
  final String lockReadingLabel;
  final String unlockReadingLabel;
  final String preparingAudio;
  final String retryLabel;
  final String findMeLabel;
  final String facebookLabel;
  final String whatsappLabel;
  final String recitationLabel;
  final String recitationSubtitle;
  final String englishTranslationLabel;
  final String englishTranslationSubtitle;
  final String kurdishTranslationLabel;
  final String kurdishTranslationSubtitle;
  final String translationLabel;
  final String transliterationLabel;
  final String meaningLabel;
  final String copyLabel;
  final String resetLabel;
  final String copiedMessage;
  final String zikrAllLabel;
  final String namesSearchHint;
  final String namesEmptyLabel;
  final String openSettingsLabel;
  final String enableLocationLabel;
  final String qiblahServiceDisabledMessage;
  final String qiblahPermissionForeverMessage;
  final String qiblahPermissionDeniedMessage;
  final String qiblahLocationUnavailableMessage;
  final String qiblahCalibratingLabel;
  final String qiblahHeadingLabel;
  final String qiblahGuidanceLabel;
  final String qiblahCompassUnavailableMessage;
  final String qiblahLocationSnapshotLabel;
  final String qiblahLatitudeLabel;
  final String qiblahLongitudeLabel;
  final String qiblahDistanceLabel;
  final String qiblahInstructionLabel;
  final String qiblahCalibratePrompt;
  final String qiblahAlignedLabel;
  final String qiblahTurnLeftFormat;
  final String qiblahTurnRightFormat;
  final String qariSharifLabel;
  final String qariSharifSubtitle;
  final String mushafArabicLabel;
  final String mushafEnglishLabel;
  final String mushafKurdishLabel;
  final String reciterCommonLabel;
  final Map<String, String> reciterNames;

  String pageStatus(int current, int total) {
    return pageLabelFormat
        .replaceAll('{current}', '$current')
        .replaceAll('{total}', '$total');
  }
}

const Map<AppLanguage, AppStrings> localizedStrings = {
  AppLanguage.kurdish: AppStrings(
    appTitle: 'رەتیل',
    tagline: 'گوێبگرە، بخوێنەوە و فێربە .',
    listenLabel: 'گوێگرتن',
    readLabel: 'خوێندنەوە',
    aboutLabel: 'دەربارە',
    qiblahLabel: 'قیبلە',
    namesLabel: '99 ناو',
    namesSubtitle: 'ناوە جوانەکانی خوای گەورە بگەڕێ.',
    settingsLabel: 'ڕێکخستن',
    zikrLabel: 'دوعاکان',
    zikrMorningLabel: 'دوعاکانی بەیانی',
    zikrEveningLabel: 'دوعاکانی ئیوارە',
    zikrGeneralLabel: 'ڕۆژانە',
    zikrCounterLabel: 'ژمێرەر',
    zikrSubtitle: 'کۆمەڵەی ئەذکار بە ژمێرەری دووبارەکردنەوە.',
    nowPlaying: 'ئێستا دەخوێندرێت',
    selectInstruction: 'سوڕەتێک هەڵبژێرە بۆ دەستپێکردنی قورئانی پیرۆز.',
    audioSubtitle: 'قاری عبدالباسط عبدالصمد',
    creatorTitle: 'دروستکراوە',
    creatorName: 'فەرهەنگ فاتیح',
    creatorDescription: 'فەرهەنگ فاتیح - گەشەپێدەر و دروستکەری ئەپەکە',
    offlineTitle: 'کاری بێ ئینتەرنێت',
    offlineDesc:
        'هەموو تێلاوەتەکان و موسحەفی تەواو لەناو ئەپەکە خەزن کراون بۆ ئەوەی لە هەر شوێنێک کار بکەن.',
    aboutTitle: 'دەربارەی ئەپەکە',
    aboutDesc:
        'ئەم ئەپە تەواو بەخۆڕاییە و هیچ بازرگانی نییە؛ هەموو شت بەبێ ئینتەرنێت کاردەکات و هیچ پارەدان یان یارمەتی لە ناو ئەپەکەدا نییە.',
    purposeTitle: 'ئامانج',
    purposeDesc:
        'بۆ یارمەتیدانی پەرتاوە کردن، خوێندنەوەی ڕۆژانە و تێکۆشان بۆ ڕابردووی سورەت کردنی قورئان.',
    languageLabel: 'زمان',
    languageName: 'کوردی',
    pageLabelFormat: 'پەڕە {current} / {total}',
    previousPage: 'پەڕەی پێشوو',
    nextPage: 'پەڕەی داهاتوو',
    noAudioMessage: 'هیچ دەنگێک نەدۆزرایەوە لە بوخچەی قورئان.',
    direction: TextDirection.rtl,
    lockReadingLabel: 'قوفڵکردنی لاپەڕەی خوێندن',
    unlockReadingLabel: 'کردنەوەی قوفڵی خوێندن',
    preparingAudio: 'دەنگ ئامادە دەبێت، تکایە چاوەڕێ بکە...',
    retryLabel: 'هەوڵدانەوە',
    findMeLabel: 'بەدوای من بگەڕێ',
    facebookLabel: 'فەیسبووک',
    whatsappLabel: 'واتساپ',
    recitationLabel: 'قاری عەبدولباست',
    recitationSubtitle: 'قاری عەبدولباست',
    englishTranslationLabel: 'وەرگێڕانی ئینگلیزی',
    englishTranslationSubtitle: 'وەرگێڕانی ئینگلیزی',
    kurdishTranslationLabel: 'وەرگێڕانی کوردی',
    kurdishTranslationSubtitle: 'وەرگێڕانی کوردی',
    translationLabel: 'وەرگێڕان',
    transliterationLabel: 'نووسینی پیتە لاتینییەکان',
    meaningLabel: 'مانا',
    copyLabel: 'کۆپی',
    resetLabel: 'ڕێکخستنەوە',
    copiedMessage: 'بۆ کلیپبۆرد هێنرا.',
    zikrAllLabel: 'هەموو',
    namesSearchHint: 'گەڕان بۆ مانا',
    namesEmptyLabel: 'هیچ ناوێک نەدۆزرایەوە.',
    openSettingsLabel: 'کردنەوەی ڕێکخستنەکان',
    enableLocationLabel: 'چالاککردنی ناونیشان',
    qiblahServiceDisabledMessage:
        'تکایە خزمەتگوزاری ناونیشان چالاک بکە بۆ دیاریکردنی ئاراستەی قبڵە.',
    qiblahPermissionForeverMessage:
        'مۆڵەتی ناونیشان بە تەواوی ڕەتکرایەوە. تکایە لە ڕێکخستنەکانی سیستەمەوە چالاکی بکە.',
    qiblahPermissionDeniedMessage:
        'پێویستە مۆڵەتی ناونیشان بدەیت بۆ دیاریکردنی قبڵە.',
    qiblahLocationUnavailableMessage:
        'نەتوانرا شوێنت دیاربکرێت، تکایە جارێکی تر هەوڵ بدە.',
    qiblahCalibratingLabel: 'دەستکاریکردن...',
    qiblahHeadingLabel: 'ئاراستە',
    qiblahGuidanceLabel: 'ڕێنمایی',
    qiblahCompassUnavailableMessage:
        'سەنسەری کەمپاس لەسەر ئەم ئامێرە نییە.',
    qiblahLocationSnapshotLabel: 'کورتەی شوێن',
    qiblahLatitudeLabel: 'لاتیتوود',
    qiblahLongitudeLabel: 'لۆنگیتوود',
    qiblahDistanceLabel: 'دووری بۆ مەککە',
    qiblahInstructionLabel:
        'دوورگە بگرە و ئامێرەکەت بگردەوە تا تیرەی شین ڕو بە پێشەوە بکات بۆ قبڵە.',
    qiblahCalibratePrompt: 'ئامێرەکەت دەستکاریکەن',
    qiblahAlignedLabel: 'هاوتەنگ',
    qiblahTurnLeftFormat: 'بچۆ بۆ چەپ {degrees}',
    qiblahTurnRightFormat: 'بچۆ بۆ ڕاست {degrees}',
    qariSharifLabel: 'قاری موستافا شریف',
    qariSharifSubtitle: 'قاری موستافا شریف',
    mushafArabicLabel: 'مصحەف (عەرەبی)',
    mushafEnglishLabel: 'قورئان بە وەرگێڕانی ئینگلیزی',
    mushafKurdishLabel: 'قورئان بە وەرگێڕانی کوردی',
    reciterCommonLabel: 'قاری',
    reciterNames: {
      'yasser': 'قاری یاسر الدوسری',
      'raad': 'قاری رعد الکوردی',
      'maher': 'قاری ماهر المعیقلی',
      'khalid': 'قاری خالد الجلیل',
      'hazaa': 'قاری هزاع البلوشی',
      'mosad': 'قاری عبدالرحمن مسعد',
      'fares': 'قاری فارس عباد',
      'ali': 'قاری علی الحذیفی',
      'ghamdi': 'قاری سعد الغامدی',
      'agamy': 'قاری أحمد العجمی',
      'sharif': 'قاری شریف مصطفی',
      'minshawi': 'قاری محەمەد سەدیق مەنشاوی',
    },
  ),
  AppLanguage.arabic: AppStrings(
    appTitle: 'رفيق القرآن',
    tagline: 'استمع واقرأ وتعلّم .',
    listenLabel: 'استماع',
    readLabel: 'قراءة',
    aboutLabel: 'حول التطبيق',
    qiblahLabel: 'القبلة',
    namesLabel: 'أسماء الله الحسنى',
    namesSubtitle: 'اكتشف الأسماء التسعة والتسعين.',
    settingsLabel: 'الإعدادات',
    zikrLabel: 'الأذكار',
    zikrMorningLabel: 'أذكار الصباح',
    zikrEveningLabel: 'أذكار المساء',
    zikrGeneralLabel: 'أذكار يومية',
    zikrCounterLabel: 'العداد',
    zikrSubtitle: 'مجموعة أذكار مختارة مع عدادات للتكرار.',
    nowPlaying: 'جاري التشغيل',
    selectInstruction: 'اختر سورة للبدء بالاستماع دون اتصال.',
    audioSubtitle: 'الشيخ عبد الباسط عبد الصمد',
    creatorTitle: 'المطوّر',
    creatorName: 'Farhang Fatih',
    creatorDescription: 'Farhang Fatih - مطوّر هذا التطبيق',
    offlineTitle: 'يعمل بلا إنترنت',
    offlineDesc:
        'جميع التلاوات والمصحف الكامل مرفقة داخل التطبيق لتستفيد بها أينما كنت.',
    aboutTitle: 'عن التطبيق',
    aboutDesc:
        'هذا التطبيق مجاني بالكامل وغير تجاري، ويعمل دون اتصال ولا يوفّر أي مدفوعات أو تبرعات داخل التطبيق.',
    purposeTitle: 'الغاية',
    purposeDesc:
        'مصمّم للحفظ، والتلاوة اليومية، والمراجعة السريعة بين الصوت والنص.',
    languageLabel: 'اللغة',
    languageName: 'العربية',
    pageLabelFormat: 'الصفحة {current} من {total}',
    previousPage: 'الصفحة السابقة',
    nextPage: 'الصفحة التالية',
    noAudioMessage: 'لا توجد ملفات صوتية داخل مجلد القرآن.',
    direction: TextDirection.rtl,
    lockReadingLabel: 'قفل وضع القراءة',
    unlockReadingLabel: 'إلغاء قفل وضع القراءة',
    preparingAudio: 'جارٍ تحضير الصوت، يرجى الانتظار...',
    retryLabel: 'إعادة المحاولة',
    findMeLabel: 'تواصل معي',
    facebookLabel: 'فيسبوك',
    whatsappLabel: 'واتساب',
    recitationLabel: 'القارئ عبد الباسط',
    recitationSubtitle: 'القارئ عبد الباسط',
    englishTranslationLabel: 'ترجمة إنكليزية',
    englishTranslationSubtitle: 'ترجمة إنكليزية',
    kurdishTranslationLabel: 'ترجمة كردية',
    kurdishTranslationSubtitle: 'ترجمة كردية',
    translationLabel: 'الترجمة',
    transliterationLabel: 'النطق بالحروف اللاتينية',
    meaningLabel: 'المعنى',
    copyLabel: 'نسخ',
    resetLabel: 'إعادة الضبط',
    copiedMessage: 'تم النسخ إلى الحافظة',
    zikrAllLabel: 'الكل',
    namesSearchHint: 'ابحث باللفظ أو المعنى',
    namesEmptyLabel: 'لا توجد أسماء مطابقة.',
    openSettingsLabel: 'فتح الإعدادات',
    enableLocationLabel: 'تفعيل الموقع',
    qiblahServiceDisabledMessage:
        'يرجى تفعيل خدمات تحديد الموقع لحساب اتجاه القبلة.',
    qiblahPermissionForeverMessage:
        'تم رفض إذن الموقع بشكل دائم. يرجى تفعيله من إعدادات النظام.',
    qiblahPermissionDeniedMessage:
        'إذن الموقع مطلوب لتحديد اتجاه القبلة.',
    qiblahLocationUnavailableMessage:
        'تعذّر تحديد موقعك. الرجاء المحاولة مرة أخرى.',
    qiblahCalibratingLabel: 'جاري المعايرة...',
    qiblahHeadingLabel: 'الاتجاه',
    qiblahGuidanceLabel: 'الإرشاد',
    qiblahCompassUnavailableMessage:
        'مستشعر البوصلة غير متوفر على هذا الجهاز.',
    qiblahLocationSnapshotLabel: 'لقطة عن الموقع',
    qiblahLatitudeLabel: 'خط العرض',
    qiblahLongitudeLabel: 'خط الطول',
    qiblahDistanceLabel: 'المسافة إلى مكة',
    qiblahInstructionLabel:
        'قف بثبات ودوّر جهازك حتى يشير السهم الفيروزي إلى الأمام لمواجهة القبلة.',
    qiblahCalibratePrompt: 'عاير جهازك',
    qiblahAlignedLabel: 'متطابق',
    qiblahTurnLeftFormat: 'استدر يساراً {degrees}',
    qiblahTurnRightFormat: 'استدر يميناً {degrees}',
    qariSharifLabel: 'القارئ مصطفى شريف',
    qariSharifSubtitle: 'القارئ مصطفى شريف',
    mushafArabicLabel: 'مصحف (عربي)',
    mushafEnglishLabel: 'القرآن مع الترجمة الإنجليزية',
    mushafKurdishLabel: 'القرآن مع الترجمة الكردية',
    reciterCommonLabel: 'القارئ',
    reciterNames: {
      'yasser': 'القارئ ياسر الدوسري',
      'raad': 'القارئ رعد الكردي',
      'maher': 'القارئ ماهر المعيقلي',
      'khalid': 'القارئ خالد الجليل',
      'hazaa': 'القارئ هزاع البلوشي',
      'mosad': 'القارئ عبدالرحمن مسعد',
      'fares': 'القارئ فارس عباد',
      'ali': 'القارئ علي الحذيفي',
      'ghamdi': 'القارئ سعد الغامدي',
      'agamy': 'القارئ أحمد العجمي',
      'sharif': 'القارئ شريف مصطفى',
      'minshawi': 'القارئ محمد صديق المنشاوي',
    },
  ),
  AppLanguage.english: AppStrings(
    appTitle: 'Ratil',
    tagline: 'Listen, read, and learn.',
    listenLabel: 'Listen',
    readLabel: 'Read',
    aboutLabel: 'About',
    qiblahLabel: 'Qiblah',
    namesLabel: '99 Names',
    namesSubtitle: 'The beautiful names of Allah.',
    settingsLabel: 'Settings',
    zikrLabel: 'Adhkar',
    zikrMorningLabel: 'Morning',
    zikrEveningLabel: 'Evening',
    zikrGeneralLabel: 'Daily',
    zikrCounterLabel: 'Count',
    zikrSubtitle: 'Curated adhkar collections with repeat counters.',
    nowPlaying: 'Now Playing',
    selectInstruction: 'Choose a surah below to start offline listening.',
    audioSubtitle: 'Qari Abdul Basit Abdul Samad',
    creatorTitle: 'Creator',
    creatorName: 'Farhang Fatih',
    creatorDescription: 'Farhang Fatih – Developer of this app',
    offlineTitle: 'Offline Mode',
    offlineDesc:
        'All recitations and the full Mushaf are bundled inside the app so you never need an internet connection.',
    aboutTitle: 'About the App',
    aboutDesc:
        'Free, non-commercial Quran companion. Everything works offline and no donations or payments are collected inside the app.',
    purposeTitle: 'Purpose',
    purposeDesc:
        'Designed to assist memorization, daily recitation, and study sessions by pairing audio with the full text.',
    languageLabel: 'Language',
    languageName: 'English',
    pageLabelFormat: 'Page {current} of {total}',
    previousPage: 'Previous page',
    nextPage: 'Next page',
    noAudioMessage: 'No audio files were found inside the Quran folder.',
    direction: TextDirection.ltr,
    lockReadingLabel: 'Lock reading tab',
    unlockReadingLabel: 'Unlock reading tab',
    preparingAudio: 'Preparing audio, please wait...',
    retryLabel: 'Retry',
    findMeLabel: 'Find me',
    facebookLabel: 'Facebook',
    whatsappLabel: 'WhatsApp',
    recitationLabel: 'Qari Abdul Basit',
    recitationSubtitle: 'Qari Abdul Basit',
    englishTranslationLabel: 'English Translation',
    englishTranslationSubtitle: 'English translation',
    kurdishTranslationLabel: 'Kurdish Translation',
    kurdishTranslationSubtitle: 'Kurdish translation',
    translationLabel: 'Translation',
    transliterationLabel: 'Transliteration (Latin letters)',
    meaningLabel: 'Meaning',
    copyLabel: 'Copy',
    resetLabel: 'Reset',
    copiedMessage: 'Copied to clipboard',
    zikrAllLabel: 'All',
    namesSearchHint: 'Search transliteration or meaning',
    namesEmptyLabel: 'No names found.',
    openSettingsLabel: 'Open settings',
    enableLocationLabel: 'Enable location',
    qiblahServiceDisabledMessage:
        'Enable location services to calculate the Qiblah direction.',
    qiblahPermissionForeverMessage:
        'Location permission is permanently denied. Please enable it from system settings.',
    qiblahPermissionDeniedMessage:
        'Location permission is required to determine the Qiblah direction.',
    qiblahLocationUnavailableMessage:
        'Unable to determine your location. Please try again.',
    qiblahCalibratingLabel: 'Calibrating...',
    qiblahHeadingLabel: 'Heading',
    qiblahGuidanceLabel: 'Guidance',
    qiblahCompassUnavailableMessage:
        'Compass sensor unavailable on this device.',
    qiblahLocationSnapshotLabel: 'Location snapshot',
    qiblahLatitudeLabel: 'Latitude',
    qiblahLongitudeLabel: 'Longitude',
    qiblahDistanceLabel: 'Distance to Makkah',
    qiblahInstructionLabel:
        'Stand still and rotate your device until the teal arrow points forward to face the Qiblah.',
    qiblahCalibratePrompt: 'Calibrate your device',
    qiblahAlignedLabel: 'Aligned',
    qiblahTurnLeftFormat: 'Turn left {degrees}',
    qiblahTurnRightFormat: 'Turn right {degrees}',
    qariSharifLabel: 'Qari Mostafa Sharif',
    qariSharifSubtitle: 'Qari Mostafa Sharif',
    mushafArabicLabel: 'Mushaf (Arabic)',
    mushafEnglishLabel: 'Quran with English translation',
    mushafKurdishLabel: 'Quran with Kurdish translation',
    reciterCommonLabel: 'Reciter',
    reciterNames: {
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
      'sharif': 'Qari Sharif Mustafa',
      'minshawi': 'Al-Minshawi',
    },
  ),
};

late final AudioPlayer sharedPlayer;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPlayer = AudioPlayer();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ratil',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.black,
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          indicatorColor: Colors.white24,
          iconTheme: WidgetStatePropertyAll(
            IconThemeData(color: Colors.white.withValues(alpha: 0.9)),
          ),
          labelTextStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        fontFamily: 'Roboto',
      ),
      home: const QuranHomePage(),
    );
  }
}

class QuranHomePage extends StatefulWidget {
  const QuranHomePage({super.key});

  @override
  State<QuranHomePage> createState() => _QuranHomePageState();
}

class _QuranHomePageState extends State<QuranHomePage> {
  static const int _readTabIndex = 1;

  late Timer _timer;
  int _gradientIndex = 0;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  AppLanguage _language = AppLanguage.kurdish;
  bool _isReadLocked = false;
  AppThemeStyle _themeStyle = AppThemeStyle.aurora;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 7), (_) {
      setState(() {
        final gradients = _activeGradients;
        if (gradients.isEmpty) return;
        _gradientIndex = (_gradientIndex + 1) % gradients.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = kThemePalettes[_themeStyle]!;
    final gradients = palette.gradients;
    final colors = gradients[_gradientIndex % gradients.length];
    final strings = localizedStrings[_language]!;
    return Directionality(
      textDirection: strings.direction,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: AnimatedContainer(
          duration: const Duration(seconds: 6),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.appTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    strings.tagline,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: palette.panelColor,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: palette.cardBorder),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: PageView(
                          controller: _pageController,
                          physics: _isLockActive
                              ? const NeverScrollableScrollPhysics()
                              : const BouncingScrollPhysics(),
                          onPageChanged: _onPageChanged,
                          children: [
                            QuranAudioTab(
                              strings: strings,
                              language: _language,
                            ),
                            QuranPdfTab(
                              strings: strings,
                              isLocked: _isReadLocked,
                              onLockChanged: _updateReadLock,
                            ),
                            QiblahTab(strings: strings),
                            ZikrTab(
                              strings: strings,
                              palette: palette,
                              language: _language,
                            ),
                            AsmaulHusnaTab(
                              strings: strings,
                              language: _language,
                            ),
                            SettingsTab(
                              strings: strings,
                              currentLanguage: _language,
                              onLanguageChanged: _handleLanguageChanged,
                              currentThemeStyle: _themeStyle,
                              onThemeChanged: _handleThemeChanged,
                              palette: palette,
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
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.only(left: 18, right: 18, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
              color: palette.navBackground,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: palette.navBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Theme(
                data: Theme.of(context).copyWith(
                  navigationBarTheme: NavigationBarThemeData(
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    indicatorColor: palette.navIndicator,
                    labelTextStyle: const WidgetStatePropertyAll(
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    iconTheme: const WidgetStatePropertyAll(
                      IconThemeData(color: Colors.white),
                    ),
                  ),
                ),
                child: NavigationBar(
                  height: 72,
                  backgroundColor: Colors.transparent,
                  labelBehavior:
                      NavigationDestinationLabelBehavior.alwaysShow,
                  selectedIndex: _currentPage,
                  onDestinationSelected: _handleNavigationTap,
                  destinations: [
                    NavigationDestination(
                      icon: const Icon(Icons.headphones_outlined),
                      selectedIcon: const Icon(Icons.headphones),
                      label: strings.listenLabel,
                    ),
                    NavigationDestination(
                      icon: _buildNavIcon(
                        Icons.menu_book_outlined,
                        emphasizeLockIcon: true,
                      ),
                      selectedIcon: _buildNavIcon(
                        Icons.menu_book,
                        emphasizeLockIcon: true,
                      ),
                      label: strings.readLabel,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.explore_outlined),
                      selectedIcon: const Icon(Icons.explore),
                      label: strings.qiblahLabel,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.self_improvement_outlined),
                      selectedIcon: const Icon(Icons.self_improvement),
                      label: strings.zikrLabel,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.auto_awesome_outlined),
                      selectedIcon: const Icon(Icons.auto_awesome),
                      label: strings.namesLabel,
                    ),
                    NavigationDestination(
                      icon: const Icon(Icons.settings_outlined),
                      selectedIcon: const Icon(Icons.settings),
                      label: strings.settingsLabel,
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

  bool get _isLockActive => _isReadLocked && _currentPage == _readTabIndex;

  List<List<Color>> get _activeGradients =>
      kThemePalettes[_themeStyle]!.gradients;

  void _updateReadLock(bool locked) {
    setState(() => _isReadLocked = locked);
  }

  void _onPageChanged(int index) {
    if (_isReadLocked && index != _readTabIndex) {
      _pageController.animateToPage(
        _readTabIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      if (_currentPage != _readTabIndex) {
        setState(() => _currentPage = _readTabIndex);
      }
      return;
    }
    setState(() => _currentPage = index);
  }

  void _goToPage(int index) {
    if (_isReadLocked && index != _readTabIndex) {
      return;
    }
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _handleNavigationTap(int index) {
    if (_isReadLocked && index != _readTabIndex) {
      return;
    }
    _goToPage(index);
  }

  void _handleLanguageChanged(AppLanguage lang) {
    if (_language == lang) return;
    setState(() => _language = lang);
  }

  void _handleThemeChanged(AppThemeStyle style) {
    if (_themeStyle == style) return;
    setState(() {
      _themeStyle = style;
      _gradientIndex = 0;
    });
  }

  Widget _buildNavIcon(IconData icon, {bool emphasizeLockIcon = false}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (emphasizeLockIcon && _isReadLocked)
          const Positioned(
            right: -6,
            top: -4,
            child: Icon(Icons.lock, size: 14, color: Colors.amberAccent),
          ),
      ],
    );
  }

  Widget _buildHeroSection(AppStrings strings, ThemePalette palette) {
    final features = [
      (icon: Icons.graphic_eq, label: strings.listenLabel),
      (icon: Icons.menu_book_rounded, label: strings.readLabel),
      (icon: Icons.self_improvement, label: strings.zikrLabel),
      (icon: Icons.offline_bolt, label: strings.offlineTitle),
    ];
    final stats = [
      (
        icon: Icons.library_music,
        value: '14',
        label: strings.reciterCommonLabel,
      ),
      (
        icon: Icons.self_improvement,
        value: '${kAdhkarItems.length}',
        label: strings.zikrLabel,
      ),
      (icon: Icons.translate, value: '3', label: strings.languageLabel),
    ];
    final styleName = kThemeNames[_themeStyle] ?? 'Aurora';

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: palette.cardBorder),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: palette.gradients.first,
        ),
        boxShadow: [
          BoxShadow(
            color: palette.accent.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.appTitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strings.tagline,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: palette.heroHighlight,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.palette, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      styleName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: features
                .map((f) => _buildHighlightChip(f.label, f.icon, palette))
                .toList(),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              for (var i = 0; i < stats.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(
                  child: _buildStatBadge(
                    stats[i].value,
                    stats[i].label,
                    stats[i].icon,
                    palette,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightChip(
    String label,
    IconData icon,
    ThemePalette palette,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: palette.chipColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(
    String value,
    String label,
    IconData icon,
    ThemePalette palette,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.heroHighlight),
      ),
      child: Row(
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: palette.heroHighlight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
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

  late List<AudioCollection> _collections;
  late AppLanguage _currentLanguage;

  static const Map<String, String> _collectionManifests = {
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
  };

  static const Map<String, String> _collectionNames = {
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
  };

  static const Map<String, List<int>> _customSurahIndexes = {
    'yasser': kFullSurahIndexes,
    'raad': kRaadSurahIndexes,
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
  };

  List<AudioCollection> _buildCollections(AppStrings strings) {
    final List<AudioCollection> base = [
      AudioCollection(
        id: 'recitation',
        label: strings.recitationLabel,
        manifestAsset: _collectionManifests['recitation']!,
        subtitleBuilder: (s) => s.recitationSubtitle,
      ),
      AudioCollection(
        id: 'english',
        label: strings.englishTranslationLabel,
        manifestAsset: _collectionManifests['english']!,
        subtitleBuilder: (s) => s.englishTranslationSubtitle,
      ),
      AudioCollection(
        id: 'kurdish',
        label: strings.kurdishTranslationLabel,
        manifestAsset: _collectionManifests['kurdish']!,
        subtitleBuilder: (s) => s.kurdishTranslationSubtitle,
      ),
      AudioCollection(
        id: 'sharif',
        label: strings.qariSharifLabel,
        manifestAsset: _collectionManifests['sharif']!,
        subtitleBuilder: (s) => s.qariSharifSubtitle,
      ),
    ];

    for (final entry in _collectionManifests.entries) {
      if (entry.key == 'recitation' ||
          entry.key == 'english' ||
          entry.key == 'kurdish' ||
          entry.key == 'sharif') {
        continue;
      }
      final fallbackName = _collectionNames[entry.key] ?? entry.key;
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

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _collections = _buildCollections(widget.strings);
    _currentLanguage = widget.language;
    _selectedCollection = _collections.first;
    _initAsync();
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
      final updated = _buildCollections(widget.strings);
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
    await _configureAudioSession();
    await _loadAudioAssets();
  }

  Future<void> _loadAudioAssets() async {
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
        final urls = linksRaw
            .split('\n')
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty && l.startsWith('http'))
            .toList();
        final tracks = <SurahAudio>[];
        for (var i = 0; i < urls.length; i++) {
          final sourceUrl = urls[i];
          String? localPath;
          if (basePath != null) {
            final localFile = File('$basePath/${_fileNameForUrl(sourceUrl)}');
            final exists = await localFile.exists();
            if (exists) {
              localPath = localFile.path;
              _downloadedPaths[sourceUrl] = localPath;
            }
          }
          final title = _titleFor(_currentLanguage, collection.id, i);
          final resolvedUrl = _resolveAudioUrl(sourceUrl);
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
    } catch (e) {
      setState(() {
        _initError = true;
        _playlistReady = false;
        _errorMessage =
            'Failed to load audio assets. Please reinstall or clear app data.';
      });
      if (kDebugMode) {
        debugPrint('Audio init failed: $e');
      }
      // Attempt lightweight reset to keep the player usable.
      try {
        await _player.stop();
      } catch (_) {}
    }
  }

  String _fileNameForUrl(String url) {
    final safe = base64Url.encode(utf8.encode(url));
    return 'audio_$safe.mp3';
  }

  String _resolveAudioUrl(String url) {
    final normalized = _normalizeGoogleDriveUrl(url);
    if (kIsWeb) {
      final encoded = Uri.encodeComponent(normalized);
      return 'https://corsproxy.io/?$encoded';
    }
    return normalized;
  }

  String _normalizeGoogleDriveUrl(String url) {
    Uri? parsed;
    try {
      parsed = Uri.parse(url);
    } catch (_) {
      return url;
    }

    if (parsed.host.contains('drive.google.com')) {
      final fileId = parsed.queryParameters['id'];
      if (fileId != null && fileId.isNotEmpty) {
        return Uri.https(
          'drive.usercontent.google.com',
          '/download',
          {
            'id': fileId,
            'export': 'download',
            'confirm': 't',
          },
        ).toString();
      }
    }

    if (parsed.host.contains('drive.usercontent.google.com')) {
      final params = Map<String, String>.from(parsed.queryParameters);
      final fileId = params['id'];
      if (fileId != null && fileId.isNotEmpty) {
        params['export'] = params['export'] ?? 'download';
        params['confirm'] = params['confirm'] ?? 't';
        return Uri.https(
          parsed.host,
          parsed.path,
          params,
        ).toString();
      }
    }

    return url;
  }

  String _titleFor(AppLanguage language, String collectionId, int index) {
    final custom = _customSurahIndexes[collectionId];
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

  Future<void> _configureAudioSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(
        AudioSessionConfiguration(
          androidAudioAttributes: AndroidAudioAttributes(
            contentType: AndroidAudioContentType.music,
            usage: AndroidAudioUsage.media,
            flags: AndroidAudioFlags.none, // disable offload
          ),
          androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
          androidWillPauseWhenDucked: true,
          avAudioSessionCategory: AVAudioSessionCategory.playback,
          avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.none,
          avAudioSessionMode: AVAudioSessionMode.defaultMode,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AudioSession config failed: $e');
      }
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

    try {
      final response = await http.Client().send(
        http.Request('GET', Uri.parse(url)),
      );
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
    }
  }

  Widget _buildCollectionSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<AudioCollection>(
          value: _selectedCollection,
          isExpanded: true,
          dropdownColor: Colors.black87,
          iconEnabledColor: Colors.white,
          style: const TextStyle(
            color: Colors.white,
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
            _switchCollection(collection);
          },
        ),
      ),
    );
  }

  Future<void> _switchCollection(AudioCollection collection) async {
    if (collection.id == _selectedCollection.id) return;
    final tracks = _tracksByCollection[collection.id] ?? const <SurahAudio>[];
    setState(() {
      _selectedCollection = collection;
      _tracks = tracks;
      _currentTrack = tracks.isNotEmpty ? tracks.first : null;
      _playlistReady = false;
      _initError = false;
      _errorMessage = null;
    });
    if (tracks.isEmpty) {
      setState(() {
        _initError = true;
        _errorMessage = widget.strings.noAudioMessage;
      });
      await _player.stop();
      return;
    }
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final errorText = _initError
        ? _errorMessage ??
              'Failed to load audio assets. Please reinstall or check storage.'
        : null;
    final hasTracks = _tracks.isNotEmpty;

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
                  style: const TextStyle(
                    color: Colors.white70,
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
        const SizedBox(height: 12),
        Expanded(
          child: hasTracks
              ? ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: _tracks.length,
                  itemBuilder: (context, index) {
                    final track = _tracks[index];
                    final isSelected = track.url == _currentTrack?.url;
                    final isPlaying = isSelected && _isPlaying;
                    final localPath =
                        _downloadedPaths[track.url] ?? track.localPath;
                    final downloading = _downloadProgress[track.url];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.18)
                              : Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected ? Colors.white70 : Colors.white24,
                            width: 1.2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                              : null,
                        ),
                        child: ListTile(
                          title: Text(
                            track.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            _selectedCollection.subtitle(widget.strings),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (downloading != null)
                                SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: CircularProgressIndicator(
                                    value: downloading,
                                    strokeWidth: 3,
                                    color: Colors.tealAccent,
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
                                      ? Colors.tealAccent
                                      : Colors.white70,
                                  onPressed: localPath != null
                                      ? null
                                      : () => _downloadAndSave(track),
                                ),
                              IconButton(
                                iconSize: 36,
                                icon: Icon(
                                  isPlaying
                                      ? Icons.pause_circle
                                      : Icons.play_circle,
                                ),
                                color: Colors.white,
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
                      widget.strings.noAudioMessage,
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildNowPlayingCard() {
    if (_currentTrack == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white70),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.strings.selectInstruction,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      );
    }
    if (!_playlistReady) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            const Icon(Icons.hourglass_bottom, color: Colors.white70),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.strings.preparingAudio,
                style: const TextStyle(color: Colors.white70),
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
    final displayPosition =
        Duration(milliseconds: clampedSliderValue.round());

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.strings.nowPlaying,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            _currentTrack!.title,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            _selectedCollection.subtitle(widget.strings),
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Slider(
            value: sliderValue,
            min: 0,
            max: maxMillis.toDouble(),
            activeColor: Colors.tealAccent,
            inactiveColor: Colors.white24,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(displayPosition),
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                _formatDuration(_totalDuration),
                style: const TextStyle(color: Colors.white70),
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

class _PdfAsset {
  const _PdfAsset({
    required this.labelBuilder,
    required this.localFileName,
    this.downloadUrl,
    this.assetPath,
  });

  final String Function(AppStrings) labelBuilder;
  final String localFileName;
  final String? downloadUrl;
  final String? assetPath;

  String label(AppStrings strings) => labelBuilder(strings);
}

class QuranPdfTab extends StatefulWidget {
  const QuranPdfTab({
    super.key,
    required this.strings,
    required this.isLocked,
    required this.onLockChanged,
  });

  final AppStrings strings;
  final bool isLocked;
  final ValueChanged<bool> onLockChanged;

  @override
  State<QuranPdfTab> createState() => _QuranPdfTabState();
}

class _QuranPdfTabState extends State<QuranPdfTab> {
  PdfControllerPinch? _pdfController;
  int? _totalPages;
  String? _pdfError;
  late _PdfAsset _selectedPdf;
  double? _downloadProgress;
  bool _isDownloading = false;
  bool _pdfOptionsReady = false;
  late List<_PdfAsset> _pdfOptions;

  @override
  void initState() {
    super.initState();
    _initPdfOptions();
  }

  Future<void> _initPdfOptions() async {
    final links = await _loadBigQuranLinks();
    final englishUrl = links.isNotEmpty ? links[0] : null;
    final kurdishUrl = links.length > 1 ? links[1] : null;

    _pdfOptions = [
      _PdfAsset(
        labelBuilder: (s) => s.mushafArabicLabel,
        localFileName: 'mushaf_arabic.pdf',
        assetPath: 'big-quran/arabic quran.pdf',
      ),
      _PdfAsset(
        labelBuilder: (s) => s.mushafEnglishLabel,
        localFileName: 'mushaf_english.pdf',
        downloadUrl: englishUrl,
      ),
      _PdfAsset(
        labelBuilder: (s) => s.mushafKurdishLabel,
        localFileName: 'mushaf_kurdish.pdf',
        downloadUrl: kurdishUrl,
      ),
    ];

    setState(() {
      _pdfOptionsReady = true;
      _selectedPdf = _pdfOptions.first;
    });
    _loadPdf(_selectedPdf);
  }

  Future<List<String>> _loadBigQuranLinks() async {
    try {
      final raw =
          await rootBundle.loadString('link/big-quran.txt');
      return raw
          .split(RegExp(r'\r?\n'))
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty && !line.startsWith('#'))
          .toList();
    } catch (e) {
      debugPrint('Failed to load big-quran links: $e');
      return const [];
    }
  }

  Future<void> _loadPdf(_PdfAsset option) async {
    _pdfController?.dispose();
    setState(() {
      _pdfController = null;
      _totalPages = null;
      _pdfError = null;
      _selectedPdf = option;
    });
    try {
      Future<PdfDocument> documentFuture;
      if (option.assetPath != null) {
        final bytes = await rootBundle.load(option.assetPath!);
        documentFuture = PdfDocument.openData(bytes.buffer.asUint8List());
      } else if (kIsWeb) {
        final bytes = await _downloadPdfToMemory(option);
        documentFuture = PdfDocument.openData(bytes);
      } else {
        final file = await _ensurePdfAvailable(option);
        documentFuture = PdfDocument.openFile(file.path);
      }
      final document = await documentFuture;
      if (!mounted) return;
      setState(() {
        _totalPages = document.pagesCount;
        _pdfController = PdfControllerPinch(document: documentFuture);
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('PDF load failed: $e');
      }
      if (!mounted) return;
      setState(() {
        _pdfError = 'Unable to open ${option.label(widget.strings)}.\n$e';
      });
    }
  }

  Future<File> _ensurePdfAvailable(_PdfAsset option) async {
    final downloadUrl = option.downloadUrl;
    if (downloadUrl == null) {
      throw StateError('No download URL configured for ${option.localFileName}');
    }
    final directory = await getApplicationSupportDirectory();
    final file = File('${directory.path}/${option.localFileName}');
    if (await file.exists()) {
      return file;
    }

    await file.parent.create(recursive: true);
    final uri = Uri.parse(downloadUrl);
    final client = http.Client();
    IOSink? sink;
    try {
      if (mounted) {
        setState(() {
          _isDownloading = true;
          _downloadProgress = 0;
        });
      }
      final response = await _sendDownloadRequest(client, uri);
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'Download failed (${response.statusCode})',
          uri: uri,
        );
      }
      final totalBytes = response.contentLength;
      var receivedBytes = 0;
      sink = file.openWrite();
      await for (final chunk in response.stream) {
        receivedBytes += chunk.length;
        sink.add(chunk);
        if (mounted) {
          setState(() {
            _downloadProgress = (totalBytes == null || totalBytes <= 0)
                ? null
                : (receivedBytes / totalBytes).clamp(0.0, 1.0);
          });
        }
      }
      await sink.flush();
      await sink.close();
      sink = null;
      return file;
    } catch (e) {
      await sink?.close();
      if (await file.exists()) {
        await file.delete();
      }
      rethrow;
    } finally {
      client.close();
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadProgress = null;
        });
      }
    }
  }

  Future<Uint8List> _downloadPdfToMemory(_PdfAsset option) async {
    final downloadUrl = option.downloadUrl;
    if (downloadUrl == null) {
      throw StateError('No download URL configured for ${option.localFileName}');
    }
    final uri = Uri.parse(downloadUrl);
    final client = http.Client();
    final builder = BytesBuilder(copy: false);
    try {
      if (mounted) {
        setState(() {
          _isDownloading = true;
          _downloadProgress = 0;
        });
      }
      final response = await _sendDownloadRequest(client, uri);
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'Download failed (${response.statusCode})',
          uri: uri,
        );
      }
      final totalBytes = response.contentLength;
      var receivedBytes = 0;
      await for (final chunk in response.stream) {
        receivedBytes += chunk.length;
        builder.add(chunk);
        if (mounted) {
          setState(() {
            _downloadProgress = (totalBytes == null || totalBytes <= 0)
                ? null
                : (receivedBytes / totalBytes).clamp(0.0, 1.0);
          });
        }
      }
      return builder.takeBytes();
    } finally {
      client.close();
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadProgress = null;
        });
      }
    }
  }

  Future<http.StreamedResponse> _sendDownloadRequest(
    http.Client client,
    Uri uri,
  ) async {
    http.StreamedResponse response = await client.send(
      http.Request('GET', uri),
    );
    if (_looksLikeGoogleDriveWarning(uri, response)) {
      final html = await response.stream.bytesToString();
      final confirmToken = _extractDriveConfirmToken(html);
      if (confirmToken == null) {
        throw HttpException(
          'Unable to confirm Google Drive download',
          uri: uri,
        );
      }
      final newUri = _withUpdatedQuery(uri, {'confirm': confirmToken});
      final request = http.Request('GET', newUri);
      final cookieHeader = response.headers['set-cookie'];
      if (cookieHeader != null) {
        request.headers['cookie'] = _cookieHeaderValue(cookieHeader);
      }
      response = await client.send(request);
    }
    return response;
  }

  bool _looksLikeGoogleDriveWarning(Uri uri, http.StreamedResponse response) {
    final host = uri.host;
    final isDriveHost = host.contains('google') && host.contains('drive');
    final contentType = response.headers['content-type'] ?? '';
    final disposition = response.headers['content-disposition'] ?? '';
    final isHtml = contentType.contains('text/html');
    final hasAttachment = disposition.contains('attachment');
    return isDriveHost && isHtml && !hasAttachment;
  }

  String? _extractDriveConfirmToken(String html) {
    // Try multiple patterns for Google Drive confirmation token
    final patternStrings = [
      r'confirm=([0-9A-Za-z_-]+)',  // Original pattern
      r'name="confirm"\s+value="([^"]+)',  // Form input
    ];

    for (final patternStr in patternStrings) {
      final pattern = RegExp(patternStr);
      final match = pattern.firstMatch(html);
      if (match != null && match.groupCount >= 1) {
        final token = match.group(1);
        if (token != null && token.isNotEmpty) {
          return token;
        }
      }
    }
    return null;
  }

  Uri _withUpdatedQuery(Uri original, Map<String, String> updates) {
    final params = Map<String, String>.from(original.queryParameters);
    params.addAll(updates);
    return original.replace(queryParameters: params);
  }

  String _cookieHeaderValue(String rawHeader) {
    final segments = _splitSetCookieHeader(rawHeader);
    final cookies = segments
        .map((segment) {
          try {
            final cookie = Cookie.fromSetCookieValue(segment);
            return '${cookie.name}=${cookie.value}';
          } catch (_) {
            return segment.split(';').first.trim();
          }
        })
        .where((value) => value.isNotEmpty);
    return cookies.join('; ');
  }

  List<String> _splitSetCookieHeader(String header) {
    final result = <String>[];
    final lowerHeader = header.toLowerCase();
    final buffer = StringBuffer();
    var inExpires = false;
    for (var i = 0; i < header.length; i++) {
      final char = header[i];
      if (char == ',' && !inExpires) {
        result.add(buffer.toString().trim());
        buffer.clear();
        continue;
      }
      buffer.write(char);
      if (!inExpires) {
        if (lowerHeader.startsWith('expires=', i)) {
          inExpires = true;
        }
      } else if (char == ';') {
        inExpires = false;
      }
    }
    final tail = buffer.toString().trim();
    if (tail.isNotEmpty) {
      result.add(tail);
    }
    return result;
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_pdfOptionsReady) {
      return const Center(child: CircularProgressIndicator());
    }
    final isLoading =
        !_isDownloading && _pdfController == null && _pdfError == null;
    final hasError = _pdfError != null;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              _LockToggleButton(
                strings: widget.strings,
                isLocked: widget.isLocked,
                onTap: () => widget.onLockChanged(!widget.isLocked),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildPdfSelector()),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatusToolbar(hasError: hasError, isLoading: isLoading),
          const SizedBox(height: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: hasError
                  ? _buildPdfErrorCard()
                  : (_pdfController == null)
                      ? const Center(child: CircularProgressIndicator())
                      : PdfViewPinch(
                          controller: _pdfController!,
                          backgroundDecoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusToolbar({
    required bool hasError,
    required bool isLoading,
  }) {
    if (hasError) {
      return _buildErrorBanner();
    }
    if (_isDownloading) {
      return _buildDownloadProgress();
    }
    if (isLoading) {
      return _buildLoadingToolbar();
    }
    if (_pdfController != null) {
      return ValueListenableBuilder<int>(
        valueListenable: _pdfController!.pageListenable,
        builder: (context, page, child) {
          final total = _totalPages ?? 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                IconButton(
                  tooltip: widget.strings.previousPage,
                  onPressed: () => _pdfController!.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    widget.strings.pageStatus(page, total),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  tooltip: widget.strings.nextPage,
                  onPressed: () => _pdfController!.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          );
        },
      );
    }
    return _buildLoadingToolbar();
  }

  Widget _buildPdfSelector() {
    if (_pdfOptions.isEmpty) {
      return const Text(
        'No PDFs available',
        style: TextStyle(color: Colors.white70),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<_PdfAsset>(
          value: _selectedPdf,
          isExpanded: true,
          dropdownColor: Colors.black87,
          iconEnabledColor: Colors.white,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          items: _pdfOptions
              .map(
                (option) => DropdownMenuItem<_PdfAsset>(
                  value: option,
                  child: Text(
                    option.label(widget.strings),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: (option) {
            if (option == null || option == _selectedPdf) return;
            _loadPdf(option);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingToolbar() {
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildDownloadProgress() {
    final progress = _downloadProgress;
    final percentText = progress != null
        ? '${(progress * 100).clamp(0, 100).toStringAsFixed(0)}%'
        : '...';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Downloading ${_selectedPdf.label(widget.strings)}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              color: Colors.tealAccent,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            percentText,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfErrorCard() {
    final card = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.6)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _pdfError ?? 'Failed to load PDF.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _loadPdf(_selectedPdf),
              icon: const Icon(Icons.refresh),
              label: Text(widget.strings.retryLabel),
            ),
          ],
        ),
      ),
    );
    return Center(child: card);
  }

  Widget _buildErrorBanner() {
    final message = _pdfError ?? 'Failed to load PDF.';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: widget.strings.retryLabel,
            onPressed: () => _loadPdf(_selectedPdf),
            icon: const Icon(Icons.refresh),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _LockToggleButton extends StatelessWidget {
  const _LockToggleButton({
    required this.strings,
    required this.isLocked,
    required this.onTap,
  });

  final AppStrings strings;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tooltip = isLocked
        ? strings.unlockReadingLabel
        : strings.lockReadingLabel;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: IconButton(
        tooltip: tooltip,
        icon: Icon(isLocked ? Icons.lock : Icons.lock_open),
        color: Colors.white,
        onPressed: onTap,
      ),
    );
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
                const _CompassBackground(),
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
                style: const TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 12,
                ),
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
            widget.strings.qiblahLocationSnapshotLabel,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
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
            Colors.white.withValues(alpha: 0.05),
            Colors.black.withValues(alpha: 0.3),
          ],
        ),
        border: Border.all(color: Colors.white24),
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white70,
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

  @override
  Widget build(BuildContext context) {
    final filtered = kAsmaulHusna.where((entry) {
      final q = _query.trim().toLowerCase();
      if (q.isEmpty) return true;
      return entry.transliteration.toLowerCase().contains(q) ||
          entry.meaning.toLowerCase().contains(q) ||
          entry.number.toString().startsWith(q);
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.strings.namesLabel,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            widget.strings.namesSubtitle,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: widget.strings.namesSearchHint,
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.tealAccent),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      widget.strings.namesEmptyLabel,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final entry = filtered[index];
                      return _AsmaNameCard(
                        entry: entry,
                        strings: widget.strings,
                        language: widget.language,
                      );
                    },
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
  });

  final AsmaulHusnaEntry entry;
  final AppStrings strings;
  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    final meaning = entry.meaningFor(language);
    final meaningLabelText =
        '${strings.meaningLabel} (${strings.languageName})';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white24),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.12),
            Colors.white.withValues(alpha: 0.04),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.teal.withValues(alpha: 0.35),
            child: Text(
              entry.number.toString().padLeft(2, '0'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    entry.arabic,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  strings.transliterationLabel,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.transliteration,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                if (meaning.isNotEmpty) ...[
                  Text(
                    meaningLabelText,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meaning,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
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
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 10),
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
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: categories
                    .map(
                      (cat) => ChoiceChip(
                        selectedColor: widget.palette.accent.withValues(
                          alpha: 0.25,
                        ),
                        backgroundColor: widget.palette.cardColor,
                        side: BorderSide(
                          color: cat.key == _selectedCategory
                              ? widget.palette.accent
                              : Colors.white24,
                        ),
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(cat.icon, size: 16),
                            const SizedBox(width: 6),
                            Text(cat.label),
                          ],
                        ),
                        selected: cat.key == _selectedCategory,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = cat.key),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: palette.cardBorder),
        color: palette.cardColor,
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
                  borderRadius: BorderRadius.circular(14),
                  color: palette.heroHighlight,
                ),
                child: Text(
                  categoryLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
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
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          if (translationText.isNotEmpty) ...[
            Text(
              translationLabel,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              translationText,
              style: const TextStyle(color: Colors.white70, height: 1.4),
            ),
          ],
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white12,
              color: palette.accent,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${widget.strings.zikrCounterLabel}: $current / $target',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.strings.copiedMessage)),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SettingsTab extends StatefulWidget {
  const SettingsTab({
    super.key,
    required this.strings,
    required this.currentLanguage,
    required this.onLanguageChanged,
    required this.currentThemeStyle,
    required this.onThemeChanged,
    required this.palette,
  });

  final AppStrings strings;
  final AppLanguage currentLanguage;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final AppThemeStyle currentThemeStyle;
  final ValueChanged<AppThemeStyle> onThemeChanged;
  final ThemePalette palette;

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  SettingsSection _selectedSection = SettingsSection.appearance;

  @override
  Widget build(BuildContext context) {
    final strings = widget.strings;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          strings.settingsLabel,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(strings.tagline, style: const TextStyle(color: Colors.white70)),
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
      SettingsSection.appearance => _buildAppearanceCard(context),
      SettingsSection.language => _buildLanguageCard(context),
      SettingsSection.about => _buildAboutSection(context),
    };
    return Container(
      key: ValueKey(_selectedSection),
      child: content,
    );
  }

  Widget _buildSectionSelector() {
    final strings = widget.strings;
    final palette = widget.palette;
    final sections = [
      (
        section: SettingsSection.appearance,
        label: 'Appearance',
        icon: Icons.palette,
      ),
      (
        section: SettingsSection.language,
        label: strings.languageLabel,
        icon: Icons.language,
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
          selectedColor: palette.accent.withValues(alpha: 0.25),
          backgroundColor: palette.cardColor,
          side: BorderSide(
            color: selected ? palette.accent : Colors.white24,
          ),
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(option.icon, size: 18),
              const SizedBox(width: 6),
              Text(option.label),
            ],
          ),
          onSelected: (_) {
            setState(() => _selectedSection = option.section);
          },
        );
      }).toList(),
    );
  }

  Widget _buildLanguageCard(BuildContext context) {
    final palette = widget.palette;
    final strings = widget.strings;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.language, color: palette.accent),
              const SizedBox(width: 10),
              Text(
                strings.languageLabel,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${strings.languageLabel}: ${strings.languageName}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: palette.heroHighlight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: palette.cardBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<AppLanguage>(
                value: widget.currentLanguage,
                dropdownColor: Colors.black87,
                iconEnabledColor: Colors.white,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                items: AppLanguage.values
                    .map(
                      (lang) => DropdownMenuItem<AppLanguage>(
                        value: lang,
                        child: Text(localizedStrings[lang]!.languageName),
                      ),
                    )
                    .toList(),
                onChanged: (lang) {
                  if (lang != null) {
                    widget.onLanguageChanged(lang);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceCard(BuildContext context) {
    final palette = widget.palette;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.cardColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: palette.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette, color: palette.accent),
              const SizedBox(width: 10),
              Text(
                'Appearance',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AppThemeStyle.values.map((style) {
              final stylePalette = kThemePalettes[style]!;
              final selected = style == widget.currentThemeStyle;
              final name = kThemeNames[style]!;
              return GestureDetector(
                onTap: () => widget.onThemeChanged(style),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 150,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? stylePalette.accent : Colors.white24,
                      width: selected ? 2 : 1,
                    ),
                    gradient: LinearGradient(
                      colors: stylePalette.gradients.first,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            selected
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: LinearGradient(
                            colors: stylePalette.gradients.last,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
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
          icon: Icons.offline_bolt,
          title: strings.offlineTitle,
          description: strings.offlineDesc,
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
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: link.color ?? Colors.white.withValues(alpha: 0.12),
      ),
      onPressed: () => _launchExternal(link.url),
      icon: Icon(link.icon, color: Colors.white),
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
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: Colors.tealAccent),
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
                  style: const TextStyle(color: Colors.white70, height: 1.4),
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
