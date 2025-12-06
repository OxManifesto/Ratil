import 'package:flutter/material.dart';

import 'app_language.dart';

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
    appTitle: 'رتیل',
    tagline: 'گوێبگرە، بخوێنەوە و فێربە .',
    listenLabel: 'گوێگرتن',
    readLabel: 'خوێندنەوە',
    aboutLabel: 'دەربارە',
    qiblahLabel: 'Qiblah',
    namesLabel: '99 Names',
    namesSubtitle: 'Explore the beautiful names of Allah.',
    settingsLabel: 'ڕێکخستن',
    zikrLabel: 'دەعاکان',
    zikrMorningLabel: 'دەعاکانی بەیانی',
    zikrEveningLabel: 'دەعاکانی ئیوارە',
    zikrGeneralLabel: 'ڕۆژانە',
    zikrCounterLabel: 'ژمێرەر',
    zikrSubtitle: 'کۆمەڵەی ئەذکار بە ژمێرەری دووبارەکردنەوە.',
    nowPlaying: 'ئێستا دەخوێندرێت',
    selectInstruction: 'سوڕەتێک هەڵبژێرە بۆ دەستپێکردنی قورئانی پیرۆز.',
    audioSubtitle: 'قاری عبدالباسط عبدالصمد',
    creatorTitle: 'دروستکراوە',
    creatorName: 'Farhang Fatih',
    creatorDescription: 'Farhang Fatih - گەشەپێدەر و دروستکەری ئەپەکە',
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
    namesSearchHint: 'گەڕان بۆ لەه‌جن یان مانا',
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
