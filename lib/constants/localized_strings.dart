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
    required this.prayerTimesLabel,
    required this.prayerTimesSubtitle,
    required this.nextPrayerLabel,
    required this.prayerNotificationsLabel,
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
    required this.appearanceLabel,
    required this.systemThemeLabel,
    required this.lightThemeLabel,
    required this.darkThemeLabel,
    required this.fastingLabel,
    required this.iftarLabel,
    required this.suhoorLabel,
    required this.trackerLabel,
    required this.khatmahLabel,
    required this.deedLabel,
    required this.questLabel,
    required this.notificationUnavailable,
    required this.permissionRequest,
    required this.alertsScheduled,
    required this.loadError,
    required this.fajrLabel,
    required this.sunriseLabel,
    required this.dhuhrLabel,
    required this.asrLabel,
    required this.maghribLabel,
    required this.ishaLabel,
    required this.tasbeehLabel,
    required this.fardLabel,
    required this.sunnahLabel,
    required this.quranGoalsLabel,
    required this.charityLabel,
    required this.dailyProgressLabel,
    required this.iftarInLabel,
    required this.suhoorInLabel,
    required this.imsakLabel,
    required this.loadingLabel,
    required this.waterLabel,
    required this.sleepLabel,
    required this.fastedLabel,
    required this.logFastLabel,
    required this.alhamdulillahLabel,
    required this.tapToCompleteLabel,
    required this.duaLabel,
    required this.supplicationsLabel,
    required this.glassesLabel,
    required this.counterLabel,
    required this.duaForFastingTitle,
    required this.fastingDuaArabic,
    required this.fastingDuaTranslation,
    required this.locationAccessTitle,
    required this.notificationAccessTitle,
    required this.locationAccessDesc,
    required this.notificationAccessDesc,
    required this.continueLabel,
    required this.internetConnectionError,
    required this.locationServiceDisabledError,
    required this.retryAction,
    required this.selectLanguageTitle,
    required this.zikrPrayerLabel,
    required this.streakLabel,
    required this.shareLabel,
    required this.rateAppLabel,
    required this.khatmahPilotTitle,
    required this.catchUpPaceLabel,
    required this.steadyPaceLabel,
    required this.logPageLabel,
    required this.pagesReadFormat,
    required this.pageDoneFormat,
    required this.readPagesHint,
    required this.imsakiyaTitle,
    required this.dayHeader,
    required this.khatmahPlannerTitle,
    required this.khatmahPlannerQuestion,
    required this.khatmahPlannerHint,
    required this.khatmahPlannerButton,
    required this.pagesLabel,
    required this.readNowLabel,
    required this.samsungAlertTitle,
    required this.samsungAlertContent,
    required this.fixNowButton,
    required this.laterButton,
    required this.deedOfTheDayLabel,
    required this.shuffleDeedTooltip,
    required this.iDidThisButton,
    required this.goodDeedAcceptedMessage,
    required this.taskFast,
    required this.taskPrayers,
    required this.taskSuhoor,
    required this.taskTarawih,
    required this.taskQuran,
    required this.taskSadaqah,
    required this.deedSmile,
    required this.deedCall,
    required this.deedFeed,
    required this.deedObstacle,
    required this.deedSalam,
    required this.deedDua,
    required this.deedForgive,
    required this.deedIkhlas,
    required this.deedCharity,
    required this.deedChores,
    required this.tasbeehDoneButton,
    required this.recitersLabel,
    required this.surahListLabel,
    required this.downloadLabel,
    required this.streamLabel,
    required this.favoritesLabel,
    required this.playNextLabel,
    required this.removeFromDeviceLabel,
    required this.qualityLabel,
    required this.audioQualityHigh,
    required this.audioQualityLow,
    required this.juzLabel,
    required this.pageLabel,
    required this.surahLabel,
    required this.ayahLabel,
    required this.bookmarkPageLabel,
    required this.gotoPageLabel,
    required this.tafseerLabel,
    required this.fontSizeLabel,
    required this.nightModeLabel,
    required this.lastReadLabel,
    required this.calibrateCompassLabel,
    required this.rotateDeviceLabel,
    required this.locationPermissionNeededLabel,
    required this.kaabaLabel,
    required this.degreesLabel,
    required this.monthlyScheduleLabel,
    required this.hijriDateLabel,
    required this.midnightLabel,
    required this.lastThirdNightLabel,
    required this.sleepAdhkarLabel,
    required this.targetLabel,
    required this.completionStreakLabel,
    required this.virtueLabel,
    required this.kidsLearningLabel,
    required this.learnWuduLabel,
    required this.learnPrayerLabel,
    required this.prophetStoriesLabel,
    required this.quizLabel,
    required this.correctLabel,
    required this.tryAgainLabel,
    required this.levelUpLabel,
    required this.badgesLabel,
    required this.generalLabel,
    required this.notificationsLabel,
    required this.adhanSoundLabel,
    required this.calculationMethodLabel,
    required this.madhabLabel,
    required this.aboutUsLabel,
    required this.contactSupportLabel,
    required this.privacyPolicyLabel,
    required this.shareAppLabel,
    required this.quranReadHint,
    required this.quranTabLabel,
    required this.bookmarksLabel,
    required this.searchHint,
    required this.searchHelper,
    required this.searchResultsLabel,
    required this.noResultsLabel,
    required this.noBookmarksLabel,
    required this.medinanLabel,
    required this.meccanLabel,
    required this.verseLabel,
    required this.versesLabel,
    required this.surahsLabel,
    required this.firstWordLabel,
    required this.translationUnavailableMessage,
    required this.bookmarkLabel,
    required this.savedLabel,
    required this.stopLabel,
    required this.previousLabel,
    required this.nextLabel,
    required this.selectSurahLabel,
    required this.audioUnavailableMessage,
    required this.audioErrorMessage,
    required this.add100DeedsLabel,
    required this.totalDeedsFormat,
    required this.khatmahSetupTitle,
    required this.khatmah30DaysLabel,
    required this.khatmah15DaysLabel,
    required this.khatmahCustomDaysLabel,
  });

  final String appTitle;
  final String tagline;
  final String listenLabel;
  final String readLabel;
  final String aboutLabel;
  final String qiblahLabel;
  final String prayerTimesLabel;
  final String prayerTimesSubtitle;
  final String nextPrayerLabel;
  final String prayerNotificationsLabel;
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
  final String appearanceLabel;
  final String systemThemeLabel;
  final String lightThemeLabel;
  final String darkThemeLabel;
  final String fastingLabel;
  final String iftarLabel;
  final String suhoorLabel;
  final String trackerLabel;
  final String khatmahLabel;
  final String deedLabel;
  final String questLabel;
  final String notificationUnavailable;
  final String permissionRequest;
  final String alertsScheduled;
  final String loadError;
  final String fajrLabel;
  final String sunriseLabel;
  final String dhuhrLabel;
  final String asrLabel;
  final String maghribLabel;
  final String ishaLabel;
  final String tasbeehLabel;
  final String fardLabel;
  final String sunnahLabel;
  final String quranGoalsLabel;
  final String charityLabel;
  final String dailyProgressLabel;
  final String iftarInLabel;
  final String suhoorInLabel;
  final String imsakLabel; // New Key
  final String loadingLabel;
  final String waterLabel;
  final String sleepLabel;
  final String fastedLabel;
  final String logFastLabel;
  final String alhamdulillahLabel;
  final String tapToCompleteLabel;
  final String duaLabel;
  final String supplicationsLabel;
  final String glassesLabel;
  final String counterLabel;
  final String duaForFastingTitle;
  final String fastingDuaArabic;
  final String fastingDuaTranslation;
  final String locationAccessTitle;
  final String notificationAccessTitle;
  final String locationAccessDesc;
  final String notificationAccessDesc;
  final String continueLabel;
  final String internetConnectionError;
  final String locationServiceDisabledError;
  final String retryAction;
  final String selectLanguageTitle;

  // Adhkar & Engagement
  final String zikrPrayerLabel;
  final String streakLabel;
  final String shareLabel;
  final String rateAppLabel;

  // Khatmah Pilot
  final String khatmahPilotTitle;
  final String catchUpPaceLabel;
  final String steadyPaceLabel;
  final String logPageLabel;
  final String pagesReadFormat;
  final String pageDoneFormat;
  final String readPagesHint;

  // Imsakiya
  final String imsakiyaTitle;
  final String dayHeader;

  // Khatmah Planner
  final String khatmahPlannerTitle;
  final String khatmahPlannerQuestion;
  final String khatmahPlannerHint;
  final String khatmahPlannerButton;
  final String pagesLabel; // "pages"
  final String readNowLabel; // "Read Now"

  // Samsung Fix
  final String samsungAlertTitle;
  final String samsungAlertContent;
  final String fixNowButton;
  final String laterButton;

  // Good Deeds
  final String deedOfTheDayLabel;
  final String shuffleDeedTooltip;
  final String iDidThisButton;
  final String goodDeedAcceptedMessage;

  // Tasks (IDs from RamadanService)
  final String taskFast;
  final String taskPrayers;
  final String taskSuhoor;
  final String taskTarawih;
  final String taskQuran;
  final String taskSadaqah;

  // Deed Content
  final String deedSmile;
  final String deedCall;
  final String deedFeed;
  final String deedObstacle;
  final String deedSalam;
  final String deedDua;
  final String deedForgive;
  final String deedIkhlas;
  final String deedCharity;
  final String deedChores;

  // Tasbeeh Dialog
  final String tasbeehDoneButton;

  final String recitersLabel;
  final String surahListLabel;
  final String downloadLabel;
  final String streamLabel;
  final String favoritesLabel;
  final String playNextLabel;
  final String removeFromDeviceLabel;
  final String qualityLabel;
  final String audioQualityHigh;
  final String audioQualityLow;
  final String juzLabel;
  final String pageLabel;
  final String surahLabel;
  final String ayahLabel;
  final String bookmarkPageLabel;
  final String gotoPageLabel;
  final String tafseerLabel;
  final String fontSizeLabel;
  final String nightModeLabel;
  final String lastReadLabel;
  final String calibrateCompassLabel;
  final String rotateDeviceLabel;
  final String locationPermissionNeededLabel;
  final String kaabaLabel;
  final String degreesLabel;
  final String monthlyScheduleLabel;
  final String hijriDateLabel;
  final String midnightLabel;
  final String lastThirdNightLabel;
  final String sleepAdhkarLabel;
  final String targetLabel;
  final String completionStreakLabel;
  final String virtueLabel;
  final String kidsLearningLabel;
  final String learnWuduLabel;
  final String learnPrayerLabel;
  final String prophetStoriesLabel;
  final String quizLabel;
  final String correctLabel;
  final String tryAgainLabel;
  final String levelUpLabel;
  final String badgesLabel;
  final String generalLabel;
  final String notificationsLabel;
  final String adhanSoundLabel;
  final String calculationMethodLabel;
  final String madhabLabel;
  final String aboutUsLabel;
  final String contactSupportLabel;
  final String privacyPolicyLabel;
  final String shareAppLabel;
  final String quranReadHint;
  final String quranTabLabel;
  final String bookmarksLabel;
  final String searchHint;
  final String searchHelper;
  final String searchResultsLabel;
  final String noResultsLabel;
  final String noBookmarksLabel;
  final String medinanLabel;
  final String meccanLabel;
  final String verseLabel;
  final String versesLabel;
  final String surahsLabel;
  final String firstWordLabel;
  final String translationUnavailableMessage;
  final String bookmarkLabel;
  final String savedLabel;
  final String stopLabel;
  final String previousLabel;
  final String nextLabel;
  final String selectSurahLabel;
  final String audioUnavailableMessage;
  final String audioErrorMessage;
  final String add100DeedsLabel;
  final String totalDeedsFormat;
  final String khatmahSetupTitle;
  final String khatmah30DaysLabel;
  final String khatmah15DaysLabel;
  final String khatmahCustomDaysLabel;

  // Methods
  String getTaskTitle(String id) {
    switch (id) {
      case 'Fast (Sawm)':
        return taskFast;
      case '5 Daily Prayers':
        return taskPrayers;
      case 'Suhoor Meal':
        return taskSuhoor;
      case 'Tarawih Prayer':
        return taskTarawih;
      case 'Read 1 Juz':
        return taskQuran;
      case 'Give Sadaqah':
        return taskSadaqah;
      default:
        return id;
    }
  }

  String getDeedTitle(String id) {
    switch (id) {
      case 'Smile at a stranger':
        return deedSmile;
      case 'Call a relative/friend':
        return deedCall;
      case 'Feed a bird/cat':
        return deedFeed;
      case 'Remove an obstacle from the path':
        return deedObstacle;
      case 'Say Salam to everyone you meet':
        return deedSalam;
      case 'Make a sincere Dua for someone':
        return deedDua;
      case 'Forgive someone who upset you':
        return deedForgive;
      case 'Read Surah Al-Ikhlas 3 times':
        return deedIkhlas;
      case 'Give a small charity':
        return deedCharity;
      case 'Help with household chores':
        return deedChores;
      default:
        return id;
    }
  }

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
    qiblahLabel: 'قیبلە',
    prayerTimesLabel: 'کاتی نوێژ',
    prayerTimesSubtitle: 'خشتەی ڕوژانەی کاتەکانی نوێژ بە ئاگادارکردنەوەکان.',
    nextPrayerLabel: 'نوێژی داهاتوو',
    prayerNotificationsLabel: 'ئاگادارکردنەوەکانی نوێژ',
    namesLabel: '99 ناو',
    namesSubtitle: 'گەڕان بەناو ناوە پیرۆزەکانی خودا.',
    settingsLabel:
        'ڕێکخستنەکان', // Current is correct (Plural). User asked for 'Rêkxistin' (Singular/Root) or 'Danana' fix. 'ڕێکخستن' is singular. 'ڕێکخستنەکان' is plural. I will keep plural as it is standard app UI. User said change from 'Danana'.
    zikrLabel: 'دوعاکان',
    zikrMorningLabel: 'دوعای بەیانیان', // Fixed: Beyani -> بەیانیان
    zikrEveningLabel: 'دوعای ئێواران', // Fixed: Eware -> ئێواران
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
        'تکایە خزمەتگوزاری ناونیشان چالاک بکە بۆ دیاریکردنی ئاراستەی قیبلە.',
    qiblahPermissionForeverMessage:
        'مۆڵەتی ناونیشان بە تەواوی ڕەتکرایەوە. تکایە لە ڕێکخستنەکانی سیستەمەوە چالاکی بکە.',
    qiblahPermissionDeniedMessage:
        'پێویستە مۆڵەتی ناونیشان بدەیت بۆ دیاریکردنی قیبلە.',
    qiblahLocationUnavailableMessage:
        'نەتوانرا شوێنت دیاربکرێت، تکایە جارێکی تر هەوڵ بدە.',
    qiblahCalibratingLabel: 'دەستکاریکردن...',
    qiblahHeadingLabel: 'ئاراستە',
    qiblahGuidanceLabel: 'ڕێنمایی',
    qiblahCompassUnavailableMessage: 'سەنسەری کەمپاس لەسەر ئەم ئامێرە نییە.',
    qiblahLocationSnapshotLabel: 'کورتەی شوێن',
    qiblahLatitudeLabel: 'لاتیتوود',
    qiblahLongitudeLabel: 'لۆنگیتوود',
    qiblahDistanceLabel: 'دووری بۆ مەککە',
    qiblahInstructionLabel:
        'دوورگە بگرە و ئامێرەکەت بگردەوە تا تیرەی شین ڕو بە پێشەوە بکات بۆ قیبلە.',
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
      'allheadan': 'قاری عبدالله الحيدان',
      'ayman': 'قاری أيمن رشدي سويد',
      'majid': 'قاری ماجد الزامل',
      'tariq': 'قاری طارق محمد',
      'khader': 'قاری أحمد خضر',
    },
    appearanceLabel: 'ڕووکار',
    systemThemeLabel: 'سیستم',
    lightThemeLabel: 'ڕووناک',
    darkThemeLabel: 'تاریک',
    fastingLabel: 'ڕۆژوو',
    iftarLabel: 'بەربانگ',
    suhoorLabel: 'پارشێو',
    trackerLabel: 'ژمێرەر',
    khatmahLabel: 'خەتەمە',
    deedLabel: 'کاری باشە',
    questLabel: 'ئەرکی ڕۆژانە',
    notificationUnavailable: 'ئاگادارکردنەوەکان پەیڕەو ناکرێت لەسەر وێب.',
    permissionRequest: 'ڕێگە بدە بە ئاگادارکردنەوەکان.',
    alertsScheduled: 'ئاگادارکردنەوەکان ڕێکخران.',
    loadError: 'هەڵە لە بارکردنی کاتەکان.',
    fajrLabel: 'بەیانی', // Strict Dict: Fajr -> KU: بەیانی
    sunriseLabel: 'خۆرھەڵات', // Strict Dict: Sunrise -> KU: خۆرھەڵات
    dhuhrLabel: 'نیوەڕۆ',
    asrLabel: 'عەسر',
    maghribLabel: 'مەغریب',
    ishaLabel: 'عیشا',
    tasbeehLabel: 'تەسبیح',
    fardLabel: 'فەرزەکان',
    sunnahLabel: 'سوننەتەکان',
    quranGoalsLabel: 'ئامانجەکانی قورئان',
    charityLabel: 'خێرخوازی',
    dailyProgressLabel: 'بەرەوپێشچوونی ڕۆژانە',
    iftarInLabel: 'بەربانگ لە',
    suhoorInLabel: 'پارشێو لە',
    imsakLabel: 'پاشێو/ئیمساک', // Strict Dict: Imsak -> KU
    loadingLabel: 'بارکردن...',
    waterLabel: 'ئاو',
    sleepLabel: 'خەوتن', // Fixed: Xaw -> خەوتن
    fastedLabel: 'بەڕۆژوو بووم!',
    logFastLabel: 'تۆمارکردنی ڕۆژوو',
    alhamdulillahLabel: 'الحمد لله',
    tapToCompleteLabel: 'کرتە بکە بۆ تەواوکردن',
    duaLabel: 'دوعا',
    supplicationsLabel: 'دوعاکان',
    glassesLabel: 'پەرداخ',
    counterLabel: 'ژمێرەر',
    duaForFastingTitle: 'دوعای بەربانگکردنەوە',
    fastingDuaArabic: 'اللَّهُمَّ لَكَ صُمْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ',
    fastingDuaTranslation:
        'خوایە بۆ تۆ ڕۆژووم گرت و بە ڕۆزی تۆ بەربانگم کردەوە.',
    locationAccessTitle: 'دەستڕاگەیشتن بە ناونیشان',
    notificationAccessTitle: 'ئاگادارکردنەوەکان',
    locationAccessDesc:
        'رتیل پێویستی بە ناونیشانی تۆیە بۆ دیاریکردنی کاتی نوێژ و قیبلە بە وردی بۆ شارەکەت.',
    notificationAccessDesc:
        'ئاگادارکردنەوەکان چالاک بکە بۆ وەرگرتنی بانگ و بیرخەرەوەکانی کاتی نوێژ.',
    continueLabel: 'بەردەوام بە',
    internetConnectionError: 'پەیوەندی ئینتەرنێت نییە',
    locationServiceDisabledError: 'خزمەتگوزاری ناونیشان ناچالاکە',
    retryAction: 'هەوڵدانەوە',
    selectLanguageTitle: 'زمان هەڵبژێرە',
    zikrPrayerLabel: 'دوای نوێژ',
    streakLabel: 'زینجیرەی تەواوکردن',
    shareLabel: 'بڵاوکردنەوە',
    rateAppLabel: 'نرخاندن',
    khatmahPilotTitle: 'خەتەمە',
    catchUpPaceLabel: 'خێراکردن',
    steadyPaceLabel: 'لە سەرخۆ',
    logPageLabel: 'تۆمارکردن',
    pagesReadFormat: 'خوێندنەوەی {pages} پەڕە ئەمڕۆ',
    pageDoneFormat: '%{percent} تەواو بووە',
    readPagesHint: '{daily} پەڕە بخوێنە بۆ تەواوکردنی لە کاتی خۆی.',
    imsakiyaTitle: 'ئیمساکیە',
    dayHeader: 'ڕۆژ',
    khatmahPlannerTitle: 'پلانەرى خەتەمە',
    khatmahPlannerQuestion: 'چەند کاتت هەیە؟',
    khatmahPlannerHint: 'نموونە ٢٠',
    khatmahPlannerButton: 'پلان',
    pagesLabel: 'پەڕە',
    readNowLabel: 'دەستپێک',
    samsungAlertTitle: 'ئاگادارکردنەوەی سامسۆنگ',
    samsungAlertContent:
        'ئامێرەکانی سامسۆنگ ڕێگری لە گەیشتنی بانگ دەکەن. تکایە "چاککردن" داگرە بۆ چارەسەر.',
    fixNowButton: 'چاککردن',
    laterButton: 'دوایی',
    deedOfTheDayLabel: 'کاری چاکەی ڕۆژ',
    shuffleDeedTooltip: 'گۆڕینی کار',
    iDidThisButton: 'ئەمەم کرد!',
    goodDeedAcceptedMessage: 'کاری چاکەت قبوڵ کرا! خوای گەورە پاداشتت بداتەوە.',
    taskFast: 'ڕۆژووگرتن',
    taskPrayers: '٥ نوێژە فەرزەکە',
    taskSuhoor: 'پارشێو',
    taskTarawih: 'نوێژی تەراویح',
    taskQuran: 'خوێندنی ١ جزء',
    taskSadaqah: 'خێرکردن',
    deedSmile: 'زەردەخەنە بۆ نامۆیەک',
    deedCall: 'تەلەفۆن بۆ خزم/هاوڕێ',
    deedFeed: 'نان دانی باڵندە/پسیلە',
    deedObstacle: 'لابردنی ڕێگر لە ڕێگا',
    deedSalam: 'سەلامکردن لە هەمووان',
    deedDua: 'دوعای خێر بۆ کەسێک',
    deedForgive: 'لێخۆشبوون لە کەسێک',
    deedIkhlas: 'خوێندنی ئیخڵاس ٣ جار',
    deedCharity: 'بەخشینی خێرێکی کەم',
    deedChores: 'یارمەتیدانی ناوماڵ',
    tasbeehDoneButton: 'تەواو',
    recitersLabel: 'خوێنەران',
    surahListLabel: 'لیستی سورەتەکان',
    downloadLabel: 'داگرتن',
    streamLabel: 'پەخشکردن',
    favoritesLabel: 'دڵخوازەکان',
    playNextLabel: 'دواتر لێبدە',
    removeFromDeviceLabel: 'لە ئامێرەکە بیسڕەوە',
    qualityLabel: 'جۆرێتی',
    audioQualityHigh: 'بەرز',
    audioQualityLow: 'نزم',
    juzLabel: 'جوزء',
    pageLabel: 'پەڕە',
    surahLabel: 'سورەت',
    ayahLabel: 'ئایەت',
    bookmarkPageLabel: 'نیشانە دانی پەرە',
    gotoPageLabel: 'بڕۆ بۆ پەڕەی',
    tafseerLabel: 'تەفسیر',
    fontSizeLabel: 'قەبارەی دەق',
    nightModeLabel: 'دۆخی شەو',
    lastReadLabel: 'دوا خوێندنەوە',
    calibrateCompassLabel: 'ڕاژەکردنی قیبلەنما',
    rotateDeviceLabel: 'ئامێرەکەت بخولێنەوە',
    locationPermissionNeededLabel: 'ڕێپێدانی شوێن پێویستە',
    kaabaLabel: 'کەعبە',
    degreesLabel: 'پلە',
    monthlyScheduleLabel: 'خشتەی مانگانە',
    hijriDateLabel: 'بەرواری هیجری',
    midnightLabel: 'نیوەشەو',
    lastThirdNightLabel: 'سێیەکی کۆتایی شەو',
    sleepAdhkarLabel: 'زیکرەکانی خەوتن',
    targetLabel: 'ئامانج',
    completionStreakLabel: 'زنجیرەی تەواوکار',
    virtueLabel: 'فەزڵی ئەم زیکرە',
    kidsLearningLabel: 'منداڵان',
    learnWuduLabel: 'فێربوونی دەستنوێژ',
    learnPrayerLabel: 'فێربوونی نوێژ',
    prophetStoriesLabel: 'چیرۆکی پێغەمبەران',
    quizLabel: 'پرسیار و وەڵام',
    correctLabel: 'ڕاستە!',
    tryAgainLabel: 'دووبارە هەوڵبدەوە',
    levelUpLabel: 'بەرزبوونەوەی ئاست',
    badgesLabel: 'نیشانەکان',
    generalLabel: 'گشتی',
    notificationsLabel: 'ئاگانامەکان',
    adhanSoundLabel: 'دەنگی بانگ',
    calculationMethodLabel: 'شێوازی ئەژمارکردن',
    madhabLabel: 'مەزهەب (شافعی/حەنەفی)',
    aboutUsLabel: 'دەربارەی ئێمە',
    contactSupportLabel: 'پەیوەندی بە پشتگیرییەوە',
    privacyPolicyLabel: 'سياسەتی تایبەتمەندێتی',
    shareAppLabel: 'بڵاوکردنەوەی ئەپ',
    quranReadHint:
        'جزء یان نیشانە هەڵبژێرە، پاشان لەسەر سوورە دابگرە بۆ خوێندن.',
    quranTabLabel: 'قورئان',
    bookmarksLabel: 'نیشانەکان',
    searchHint: 'گەڕان بە سوورە، عەرەبی یان وەرگێڕان',
    searchHelper: 'بە بەشەکان بگەڕێ یان هەر ئایەتێک بگەڕێ.',
    searchResultsLabel: 'ئەنجامەکانی گەڕان',
    noResultsLabel: 'هیچ ئەنجامێک لەگەڵ گەڕانەکەت ناگات.',
    noBookmarksLabel:
        'هێشتا نیشانە نییە. لەسەر ئایکۆنی نیشانەی هەر ئایەتێک دابگرە بۆ هەڵگرتن.',
    medinanLabel: 'مەدینەیی',
    meccanLabel: 'مەکّی',
    verseLabel: 'ئایەت',
    versesLabel: 'ئایەت',
    surahsLabel: 'سوورە',
    firstWordLabel: 'یەکەم وشە',
    translationUnavailableMessage: 'وەرگێڕان بەردەست نییە.',
    bookmarkLabel: 'نیشانە',
    savedLabel: 'هەڵگیرا',
    stopLabel: 'وەستاندن',
    previousLabel: 'پێشوو',
    nextLabel: 'داهاتوو',
    selectSurahLabel: 'سوورەیەک بۆ گوێگرتن هەڵبژێرە',
    audioUnavailableMessage: 'دەنگ بەردەست نییە',
    audioErrorMessage: 'ئێستا ناتوانرێت ئەم قەرأەتە دەربکرێت.',
    add100DeedsLabel: '+100 چاکە',
    totalDeedsFormat: 'کۆی گشتی: {total}',
    khatmahSetupTitle: 'خەتمەی قورئان دابنێ',
    khatmah30DaysLabel: '٣٠ ڕۆژ (١ خەتمە)',
    khatmah15DaysLabel: '١٥ ڕۆژ (٢ خەتمە)',
    khatmahCustomDaysLabel: 'کاتی تایبەت',
  ),
  AppLanguage.arabic: AppStrings(
    appTitle: 'رفيق القرآن',
    tagline: 'استمع واقرأ وتعلّم .',
    listenLabel: 'استماع',
    readLabel: 'قراءة',
    aboutLabel: 'حول التطبيق',
    qiblahLabel: 'القبلة',
    prayerTimesLabel: 'مواقيت الصلاة',
    prayerTimesSubtitle: 'جدول الصلوات اليومية مع التنبيهات.',
    nextPrayerLabel: 'الصلاة القادمة',
    prayerNotificationsLabel: 'إشعارات الصلاة',
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
    qiblahPermissionDeniedMessage: 'إذن الموقع مطلوب لتحديد اتجاه القبلة.',
    qiblahLocationUnavailableMessage:
        'تعذّر تحديد موقعك. الرجاء المحاولة مرة أخرى.',
    qiblahCalibratingLabel: 'جاري المعايرة...',
    qiblahHeadingLabel: 'الاتجاه',
    qiblahGuidanceLabel: 'الإرشاد',
    qiblahCompassUnavailableMessage: 'مستشعر البوصلة غير متوفر على هذا الجهاز.',
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
      'allheadan': 'القارئ عبدالله الحيدان',
      'ayman': 'القارئ أيمن رشدي سويد',
      'majid': 'القارئ ماجد الزامل',
      'tariq': 'القارئ طارق محمد',
      'khader': 'القارئ أحمد خضر',
    },
    appearanceLabel: 'المظهر',
    systemThemeLabel: 'تلقائي',
    lightThemeLabel: 'فاتح',
    darkThemeLabel: 'داكن',
    fastingLabel: 'الصيام',
    iftarLabel: 'الإفطار',
    suhoorLabel: 'السحور',
    trackerLabel: 'المتتبع',
    khatmahLabel: 'الخاتمة',
    deedLabel: 'فعل خير',
    questLabel: 'تحدي اليوم',
    notificationUnavailable: 'الإشعارات غير متاحة على الويب.',
    permissionRequest: 'يرجى تفعيل الإشعارات.',
    alertsScheduled: 'تمت جدولة التنبيهات.',
    loadError: 'فشل في تحميل الأوقات.',
    fajrLabel: 'الفجر', // Strict Dict: Fajr -> AR: الفجر (Correct)
    sunriseLabel: 'الشروق', // Strict Dict: Sunrise -> AR: الشروق (Correct)
    dhuhrLabel: 'الظهر',
    asrLabel: 'العصر',
    maghribLabel: 'المغرب',
    ishaLabel: 'العشاء',
    tasbeehLabel: 'التسبيح',
    fardLabel: 'الفرائض',
    sunnahLabel: 'السنن',
    quranGoalsLabel: 'أهداف القرآن',
    charityLabel: 'العمل الخيري',
    dailyProgressLabel: 'تقدم اليوم',
    iftarInLabel: 'الإفطار بعد',
    suhoorInLabel: 'السحور بعد',
    imsakLabel: 'الإمساك', // Strict Dict: Imsak -> AR
    loadingLabel: 'جاري التحميل...',
    waterLabel: 'الماء',
    sleepLabel: 'النوم',
    fastedLabel: 'تم الصيام!',
    logFastLabel: 'تسجيل الصيام',
    alhamdulillahLabel: 'الحمد لله',
    tapToCompleteLabel: 'انقر للإكمال',
    duaLabel: 'دعاء',
    supplicationsLabel: 'الأدعية',
    glassesLabel: 'أكواب',
    counterLabel: 'عداد',
    duaForFastingTitle: 'دعاء الإفطار',
    fastingDuaArabic: 'اللَّهُمَّ لَكَ صُمْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ',
    fastingDuaTranslation: 'اللهم إني لك صمت، وبك آمنت، وعلى رزقك أفطرت.',
    locationAccessTitle: 'الوصول إلى الموقع',
    notificationAccessTitle: 'الإشعارات',
    locationAccessDesc:
        'يحتاج رتيل إلى موقعك لحساب مواقيت الصلاة واتجاه القبلة بدقة لمدينتك.',
    notificationAccessDesc:
        'قم بتفعيل الإشعارات لتلقي تنبيهات الأذان وتذكيرات أوقات الصلاة.',
    continueLabel: 'متابعة',
    internetConnectionError: 'فشل الاتصال بالإنترنت',
    locationServiceDisabledError: 'خدمة الموقع غير مفعلة',
    retryAction: 'إعادة المحاولة',
    selectLanguageTitle: 'اختر اللغة',
    zikrPrayerLabel: 'أذكار الصلاة',
    streakLabel: 'تتابع الختمة',
    shareLabel: 'مشاركة',
    rateAppLabel: 'تقييم التطبيق',
    khatmahPilotTitle: 'طيار الختمة',
    catchUpPaceLabel: 'وتيرة سريعة',
    steadyPaceLabel: 'وتيرة ثابتة',
    logPageLabel: 'تسجيل الصفحة',
    pagesReadFormat: 'قرأت {pages} صفحة اليوم',
    pageDoneFormat: '%{percent} منجز',
    readPagesHint: 'اقرأ {daily} صفحة لإنهاء الختمة في الوقت المحدد.',
    imsakiyaTitle: 'إمساكية',
    dayHeader: 'اليوم',
    khatmahPlannerTitle: 'مخطط الختمة',
    khatmahPlannerQuestion: 'كم من الوقت لديك؟',
    khatmahPlannerHint: 'مثال ٢٠',
    khatmahPlannerButton: 'خطط',
    pagesLabel: 'صفحات',
    readNowLabel: 'اقرأ الآن',
    samsungAlertTitle: 'تنبيه سامسونج',
    samsungAlertContent:
        'أجهزة سامسونج قد تمنع وصول الآذان. يرجى الضغط على "إصلاح الآن" لضمان وصول التنبيهات.',
    fixNowButton: 'إصلاح الآن',
    laterButton: 'لاحقاً',
    deedOfTheDayLabel: 'عمل اليوم',
    shuffleDeedTooltip: 'تغيير العمل',
    iDidThisButton: 'أنجزته!',
    goodDeedAcceptedMessage: 'تقبل الله عملك وأثابك خيراً.',
    taskFast: 'الصيام',
    taskPrayers: 'الصلوات الخمس',
    taskSuhoor: 'وجبة السحور',
    taskTarawih: 'صلاة التراويح',
    taskQuran: 'قراءة جزء',
    taskSadaqah: 'إعطاء صدقة',
    deedSmile: 'ابتسم لغريب',
    deedCall: 'صل رحمك أو صديقاً',
    deedFeed: 'أطعم طيراً أو قطة',
    deedObstacle: 'أماطة الأذى عن الطريق',
    deedSalam: 'أفش السلام',
    deedDua: 'دعو بظهر الغيب',
    deedForgive: 'سامح من أخطأ بحقك',
    deedIkhlas: 'سورة الإخلاص ٣ مرات',
    deedCharity: 'صدقة يسيرة',
    deedChores: 'ساعد في أعمال المنزل',
    tasbeehDoneButton: 'تم',
    recitersLabel: 'القراء',
    surahListLabel: 'قائمة السور',
    downloadLabel: 'تحميل',
    streamLabel: 'بث مباشر',
    favoritesLabel: 'المفضلة',
    playNextLabel: 'تشغيل التالي',
    removeFromDeviceLabel: 'إزالة من الجهاز',
    qualityLabel: 'الجودة',
    audioQualityHigh: 'عالية',
    audioQualityLow: 'منخفضة',
    juzLabel: 'الجزء',
    pageLabel: 'الصفحة',
    surahLabel: 'السورة',
    ayahLabel: 'الآية',
    bookmarkPageLabel: 'إشارة مرجعية',
    gotoPageLabel: 'انتقل إلى الصفحة',
    tafseerLabel: 'التفسير',
    fontSizeLabel: 'حجم الخط',
    nightModeLabel: 'الوضع الليلي',
    lastReadLabel: 'آخر قراءة',
    calibrateCompassLabel: 'معايرة البوصلة',
    rotateDeviceLabel: 'قم بتدوير جهازك',
    locationPermissionNeededLabel: 'إذن الموقع مطلوب',
    kaabaLabel: 'الكعبة',
    degreesLabel: 'درجة',
    monthlyScheduleLabel: 'الجدول الشهري',
    hijriDateLabel: 'التاريخ الهجري',
    midnightLabel: 'منتصف الليل',
    lastThirdNightLabel: 'الثلث الأخير',
    sleepAdhkarLabel: 'أذكار النوم',
    targetLabel: 'الهدف',
    completionStreakLabel: 'سلسلة الإكمال',
    virtueLabel: 'فضل هذا الذكر',
    kidsLearningLabel: 'قسم الأطفال',
    learnWuduLabel: 'تعلم الوضوء',
    learnPrayerLabel: 'تعلم الصلاة',
    prophetStoriesLabel: 'قصص الأنبياء',
    quizLabel: 'اختبار',
    correctLabel: 'صحيح!',
    tryAgainLabel: 'حاول مرة أخرى',
    levelUpLabel: 'ارتقاء بالمستوى',
    badgesLabel: 'الشارات',
    generalLabel: 'عام',
    notificationsLabel: 'الإشعارات',
    adhanSoundLabel: 'صوت الأذان',
    calculationMethodLabel: 'طريقة الحساب',
    madhabLabel: 'المذهب (حنفي/شافعي)',
    aboutUsLabel: 'من نحن',
    contactSupportLabel: 'التواصل مع الدعم',
    privacyPolicyLabel: 'سياسة الخصوصية',
    shareAppLabel: 'شارك التطبيق',
    quranReadHint: 'اختر جزءًا أو علامة ثم اضغط على السورة للقراءة.',
    quranTabLabel: 'القرآن',
    bookmarksLabel: 'العلامات',
    searchHint: 'ابحث عن السورة أو العربية أو الترجمة',
    searchHelper: 'تصفح حسب الجزء أو ابحث عن أي آية.',
    searchResultsLabel: 'نتائج البحث',
    noResultsLabel: 'لا توجد نتائج مطابقة لبحثك.',
    noBookmarksLabel:
        'لا توجد علامات بعد. اضغط على أيقونة العلامة في أي آية للحفظ.',
    medinanLabel: 'مدني',
    meccanLabel: 'مكي',
    verseLabel: 'آية',
    versesLabel: 'آيات',
    surahsLabel: 'سور',
    firstWordLabel: 'أول كلمة',
    translationUnavailableMessage: 'الترجمة غير متاحة.',
    bookmarkLabel: 'إشارة',
    savedLabel: 'محفوظ',
    stopLabel: 'إيقاف',
    previousLabel: 'السابق',
    nextLabel: 'التالي',
    selectSurahLabel: 'اختر سورة للاستماع',
    audioUnavailableMessage: 'الصوت غير متاح',
    audioErrorMessage: 'تعذر تشغيل التلاوة الآن.',
    add100DeedsLabel: '+100 حسنة',
    totalDeedsFormat: 'الإجمالي: {total}',
    khatmahSetupTitle: 'إعداد ختمة القرآن',
    khatmah30DaysLabel: '30 يوماً (ختمة واحدة)',
    khatmah15DaysLabel: '15 يوماً (ختمتان)',
    khatmahCustomDaysLabel: 'أيام مخصصة',
  ),
  AppLanguage.english: AppStrings(
    appTitle: 'Ratil',
    tagline: 'Listen, read, and learn.',
    listenLabel: 'Listen',
    readLabel: 'Read',
    aboutLabel: 'About',
    qiblahLabel: 'Qiblah',
    prayerTimesLabel: 'Prayer Times',
    prayerTimesSubtitle:
        'Daily salat schedule with ambient visuals and alerts.',
    nextPrayerLabel: 'Next prayer',
    prayerNotificationsLabel: 'Prayer notifications',
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
      'allheadan': 'Abdullah Al-Haydan',
      'ayman': 'Ayman Rushdi Sweed',
      'majid': 'Majid Al Zamil',
      'tariq': 'Tariq Muhammad',
      'khader': 'Ahmed Khader',
    },
    appearanceLabel: 'Appearance',
    systemThemeLabel: 'System',
    lightThemeLabel: 'Light',
    darkThemeLabel: 'Dark',
    fastingLabel: 'Fasting',
    iftarLabel: 'Iftar',
    suhoorLabel: 'Suhoor',
    trackerLabel: 'Tracker',
    khatmahLabel: 'Khatmah',
    deedLabel: 'Good Deed',
    questLabel: 'Daily Quest',
    notificationUnavailable: 'Notifications are unavailable on web.',
    permissionRequest: 'Please allow notifications for alerts.',
    alertsScheduled: 'Prayer alerts scheduled.',
    loadError: 'Unable to load prayer times.',
    fajrLabel: 'Fajr',
    sunriseLabel: 'Sunrise',
    dhuhrLabel: 'Dhuhr',
    asrLabel: 'Asr',
    maghribLabel: 'Maghrib',
    ishaLabel: 'Isha',
    tasbeehLabel: 'Tasbeeh',
    fardLabel: 'Fard (Obligatory)',
    sunnahLabel: 'Sunnah Habits',
    quranGoalsLabel: 'Quran Goals',
    charityLabel: 'Charity & Social',
    dailyProgressLabel: 'Daily Progress',
    iftarInLabel: 'IFTAR IN',
    suhoorInLabel: 'SUHOOR IN',
    imsakLabel: 'Imsak', // EN
    loadingLabel: 'Loading...',
    waterLabel: 'Water',
    sleepLabel: 'Sleep',
    fastedLabel: 'Fasted!',
    logFastLabel: 'Log Fast',
    alhamdulillahLabel: 'Alhamdulillah',
    tapToCompleteLabel: 'Tap to complete',
    duaLabel: 'Dua',
    supplicationsLabel: 'Supplications',
    glassesLabel: 'glasses',
    counterLabel: 'Counter',
    duaForFastingTitle: 'Dua for Fasting',
    fastingDuaArabic: 'اللَّهُمَّ لَكَ صُمْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ',
    fastingDuaTranslation:
        "O Allah, I fasted for You and I break my fast with Your sustenance.",
    locationAccessTitle: 'Location Access',
    notificationAccessTitle: 'Notifications',
    locationAccessDesc:
        'Ratil needs your location to calculate accurate prayer times and Qiblah direction for your city.',
    notificationAccessDesc:
        'Enable notifications to receive Adhan alerts and reminders for prayer times.',
    continueLabel: 'Continue',
    internetConnectionError: 'Internet Connection Failed',
    locationServiceDisabledError: 'Location Service Disabled',
    retryAction: 'Please retry',
    selectLanguageTitle: 'Select Language',
    zikrPrayerLabel: 'Prayer Adhkar',
    streakLabel: 'Streak',
    shareLabel: 'Share',
    rateAppLabel: 'Rate App',
    khatmahPilotTitle: 'Khatmah Pilot',
    catchUpPaceLabel: 'Catch Up Mode',
    steadyPaceLabel: 'Steady Pace',
    logPageLabel: 'Log Page',
    pagesReadFormat: 'Read {pages} pages today',
    pageDoneFormat: '%{percent} Done',
    readPagesHint: 'Read {daily} pages to finish on time.',
    imsakiyaTitle: 'Imsakiya',
    dayHeader: 'Day',
    khatmahPlannerTitle: 'Smart Khatmah Planner',
    khatmahPlannerQuestion: 'How much time do you have?',
    khatmahPlannerHint: 'e.g. 20',
    khatmahPlannerButton: 'Plan',
    pagesLabel: 'pages',
    readNowLabel: 'Read Now',
    samsungAlertTitle: 'Samsung Device Detected',
    samsungAlertContent:
        'Samsung devices aggressively kill prayer notifications. Please tap "Fix Now" to ensure you receive Adhan alerts.',
    fixNowButton: 'Fix Now',
    laterButton: 'Later',
    deedOfTheDayLabel: 'Deed of the Day',
    shuffleDeedTooltip: 'Shuffle Deed',
    iDidThisButton: 'I did this!',
    goodDeedAcceptedMessage: 'Good deed accepted! May Allah reward you.',
    taskFast: 'Fast (Sawm)',
    taskPrayers: '5 Daily Prayers',
    taskSuhoor: 'Suhoor Meal',
    taskTarawih: 'Tarawih Prayer',
    taskQuran: 'Read 1 Juz',
    taskSadaqah: 'Give Sadaqah',
    deedSmile: 'Smile at a stranger',
    deedCall: 'Call a relative/friend',
    deedFeed: 'Feed a bird/cat',
    deedObstacle: 'Remove an obstacle from the path',
    deedSalam: 'Say Salam to everyone you meet',
    deedDua: 'Make a sincere Dua for someone',
    deedForgive: 'Forgive someone who upset you',
    deedIkhlas: 'Read Surah Al-Ikhlas 3 times',
    deedCharity: 'Give a small charity',
    deedChores: 'Help with household chores',
    tasbeehDoneButton: 'Done',
    recitersLabel: 'Reciters',
    surahListLabel: 'Surah List',
    downloadLabel: 'Download',
    streamLabel: 'Stream',
    favoritesLabel: 'Favorites',
    playNextLabel: 'Play Next',
    removeFromDeviceLabel: 'Remove from device',
    qualityLabel: 'Quality',
    audioQualityHigh: 'High',
    audioQualityLow: 'Low',
    juzLabel: 'Juz',
    pageLabel: 'Page',
    surahLabel: 'Surah',
    ayahLabel: 'Ayah',
    bookmarkPageLabel: 'Bookmark this page',
    gotoPageLabel: 'Go to page',
    tafseerLabel: 'Tafseer',
    fontSizeLabel: 'Font Size',
    nightModeLabel: 'Night Mode',
    lastReadLabel: 'Last Read',
    calibrateCompassLabel: 'Calibrate Compass',
    rotateDeviceLabel: 'Rotate your device',
    locationPermissionNeededLabel: 'Location permission needed',
    kaabaLabel: 'Kaaba',
    degreesLabel: 'Degrees',
    monthlyScheduleLabel: 'Monthly Schedule',
    hijriDateLabel: 'Hijri Date',
    midnightLabel: 'Midnight',
    lastThirdNightLabel: 'Last Third of Night',
    sleepAdhkarLabel: 'Sleep Adhkar',
    targetLabel: 'Target',
    completionStreakLabel: 'Completion Streak',
    virtueLabel: 'Virtue of this Dhikr',
    kidsLearningLabel: 'Kids',
    learnWuduLabel: 'Learn Ablution (Wudu)',
    learnPrayerLabel: 'Learn Prayer',
    prophetStoriesLabel: 'Prophet Stories',
    quizLabel: 'Quiz',
    correctLabel: 'Correct!',
    tryAgainLabel: 'Try Again',
    levelUpLabel: 'Level Up',
    badgesLabel: 'Badges',
    generalLabel: 'General',
    notificationsLabel: 'Notifications',
    adhanSoundLabel: 'Adhan Sound',
    calculationMethodLabel: 'Calculation Method',
    madhabLabel: 'Madhab (Hanafi/Shafi)',
    aboutUsLabel: 'About Us',
    contactSupportLabel: 'Contact Support',
    privacyPolicyLabel: 'Privacy Policy',
    shareAppLabel: 'Share App',
    quranReadHint: 'Choose a Juz or bookmark, then tap a surah to read.',
    quranTabLabel: 'Quran',
    bookmarksLabel: 'Bookmarks',
    searchHint: 'Search surah, Arabic, or translation',
    searchHelper: 'Browse by Juz or search any verse.',
    searchResultsLabel: 'Search results',
    noResultsLabel: 'No results match your search.',
    noBookmarksLabel:
        'No bookmarks yet. Tap the bookmark icon on any verse to save it.',
    medinanLabel: 'Medinan',
    meccanLabel: 'Meccan',
    verseLabel: 'verse',
    versesLabel: 'verses',
    surahsLabel: 'surahs',
    firstWordLabel: 'First word',
    translationUnavailableMessage: 'Translation unavailable.',
    bookmarkLabel: 'Bookmark',
    savedLabel: 'Saved',
    stopLabel: 'Stop',
    previousLabel: 'Previous',
    nextLabel: 'Next',
    selectSurahLabel: 'Select a surah to listen',
    audioUnavailableMessage: 'Audio not available',
    audioErrorMessage: 'Unable to play this recitation right now.',
    add100DeedsLabel: '+100 Deeds',
    totalDeedsFormat: 'Total: {total}',
    khatmahSetupTitle: 'Setup Khatmah',
    khatmah30DaysLabel: '30 Days (1 Khatmah)',
    khatmah15DaysLabel: '15 Days (2 Khatmah)',
    khatmahCustomDaysLabel: 'Custom Date',
  ),
};
