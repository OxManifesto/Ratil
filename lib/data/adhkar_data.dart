import '../constants/app_language.dart';

class AdhkarItem {
  final String arabic;
  final String transliteration;
  final String translation;
  final String? translationKurdish;
  final String? translationArabic;
  final String category;
  final int repeat;

  const AdhkarItem({
    required this.arabic,
    required this.transliteration,
    required this.translation,
    this.translationKurdish,
    this.translationArabic,
    required this.category,
    required this.repeat,
  });

  String translationFor(AppLanguage language) {
    switch (language) {
      case AppLanguage.kurdish:
        return (translationKurdish != null &&
                translationKurdish!.trim().isNotEmpty)
            ? translationKurdish!
            : translation;
      case AppLanguage.arabic:
        return (translationArabic != null &&
                translationArabic!.trim().isNotEmpty)
            ? translationArabic!
            : translation;
      case AppLanguage.english:
        return translation;
    }
  }
}

const List<AdhkarItem> kAdhkarItems = [
  AdhkarItem(
    arabic:
        'اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك، وأنا على عهدك ووعدك ما استطعت، أعوذ بك من شر ما صنعت، أبوء لك بنعمتك علي، وأبوء بذنبي فاغفر لي فإنه لا يغفر الذنوب إلا أنت.',
    transliteration:
        'Allahumma anta rabbi la ilaha illa anta, khalaqtani wa ana abduka, wa ana ala ahdika wa wa\'dika mastata\'t. A\'udhu bika min sharri ma sana\'t, abuu laka bini\'matika alayya wa abuu laka bidhanbi faghfir li fa innahu la yaghfiru adh-dhunuba illa ant.',
    translation:
        'O Allah, You are my Lord, there is no deity except You. You created me and I am Your servant, and I abide to Your covenant and promise as best as I can. I seek refuge in You from the evil of what I have done. I acknowledge Your favor upon me and I acknowledge my sin, so forgive me, for verily none can forgive sin except You.',
    translationKurdish:
        'خوایە گیان تۆ پەروەردگارمیت جگە لە تۆ هیچ خودایەک نییە. تۆ من دروست کردووە و من بەندەی تۆم، منیش بە باشترین شێوە پابەندم بە پەیمان و بەڵێنەکەتەوە. پەنات بۆ دەگرم لە خراپەی ئەو کارانەی کردوومە. دان بە نیعمەتەکەتدا دەنێم و دان بە تاوانەکەمدا دەنێم، بۆیە لێم خۆشبە چونکە بەڕاستی کەس ناتوانێت لە گوناه خۆش بێت جگە لە تۆ.',
    category: 'morning',
    repeat: 1,
  ),
  AdhkarItem(
    arabic:
        'أمسينا وأمسى الملك لله والحمد لله، لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.',
    transliteration:
        'Amsayna wa amsa al-mulku lillahi wal-hamdu lillah, la ilaha illa Allahu wahdahu la sharika lah, lahul mulku wa lahul hamdu wahuwa ala kulli shay\'in qadir.',
    translation:
        'We have reached the evening and the dominion all belongs to Allah. Praise be to Allah, there is no deity but Allah, alone without partner. His is the dominion and to Him belong all praise and He is over all things competent.',
    translationKurdish:
        'ئێمە گەیشتینە ئێوارە و حکمرانی هەمووی هی خوایە. هیچ خودایەک نییە جگە لە خوای یەکتا، بێ هاوەڵ. حکمرانی و هەموو ستایشەکان هی ئەوە و ئەو بەسەر هەموو شتێک کارامەیە.',
    category: 'evening',
    repeat: 1,
  ),
  AdhkarItem(
    arabic: 'سبحان الله وبحمده.',
    transliteration: 'SubhanAllahi wa bihamdih.',
    translation: 'Glory is to Allah and praise to Him.',
    translationKurdish: 'شکۆمەندی بۆ خوایە و ستایش بۆ ئەو.',
    category: 'daily',
    repeat: 100,
  ),
  AdhkarItem(
    arabic:
        'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.',
    transliteration:
        'La ilaha illa Allahu wahdahu la sharika lah, lahul mulku wa lahul hamdu wahuwa ala kulli shay\'in qadir.',
    translation:
        'There is no deity except Allah, alone, without partner. His is the dominion and to Him belong all praise, and He is over all things competent.',
    translationKurdish:
        'هیچ خودایەک نییە جگە لە خوای گەورە، بەتەنها، بێ هاوەڵ. حکمرانی هی ئەوە و هەموو ستایشەکان هی ئەوە و ئەو بەسەر هەموو شتێک کارامەیە.',
    category: 'daily',
    repeat: 100,
  ),
  AdhkarItem(
    arabic: 'أستغفر الله وأتوب إليه.',
    transliteration: 'Astaghfirullaha wa atubu ilayh.',
    translation: 'I seek forgiveness from Allah and repent to Him.',
    translationKurdish: 'داوای لێبوردن لە خوای گەورە دەخوازم و تەوبەی لێ دەکەم.',
    category: 'daily',
    repeat: 100,
  ),
  AdhkarItem(
    arabic:
        'رضيت بالله ربًا وبالإسلام دينًا وبمحمد صلى الله عليه وسلم نبيًا.',
    transliteration:
        'Radheetu billahi rabban, wabil-islami dinan, wabimuhammadin sallallahu alayhi wa sallam nabiyya.',
    translation:
        'I am pleased with Allah as my Lord, with Islam as my religion and with Muhammad as my Prophet.',
    translationKurdish:
        'من ڕازیم لە خوای گەورە وەک پەروەردگارم، بە ئیسلام وەک دین و بە محمد وەک پێغەمبەرم.',
    category: 'morning',
    repeat: 3,
  ),
  AdhkarItem(
    arabic:
        'حسبي الله لا إله إلا هو، عليه توكلت وهو رب العرش العظيم.',
    transliteration:
        'Hasbiyallahu la ilaha illa huwa alayhi tawakkaltu wahuwa rabbul arshil azeem.',
    translation:
        'Allah is sufficient for me; there is no deity except Him. I have placed my trust in Him, and He is the Lord of the Mighty Throne.',
    translationKurdish:
        'خوای گەورە بەسە بۆ من؛ جگە لە ئەو هیچ خوداوەندێک نییە. متمانەم پێی داناوە و ئەویش پەروەردگاری عەرشی بەهێزە.',
    category: 'evening',
    repeat: 7,
  ),
];
