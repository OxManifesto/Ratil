import '../constants/app_language.dart';

class AdhkarItem {
  final int id;
  final String arabic;
  final String transliteration;
  final Map<AppLanguage, String> translations;
  final String category;
  final int repeat;
  final String reference;

  const AdhkarItem({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translations,
    required this.category,
    required this.repeat,
    required this.reference,
  });

  String translationFor(AppLanguage language) =>
      translations[language] ?? translations[AppLanguage.english] ?? '';
}

const List<AdhkarItem> kAdhkarItems = [
  AdhkarItem(
    id: 1,
    arabic:
        'اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك، وأنا على عهدك ووعدك ما استطعت، أعوذ بك من شر ما صنعت، أبوء لك بنعمتك علي، وأبوء بذنبي فاغفر لي فإنه لا يغفر الذنوب إلا أنت.',
    transliteration:
        "Allahumma anta rabbi la ilaha illa anta, khalaqtani wa ana abduka, wa ana ala ahdika wa wa'dika mastata't. A'udhu bika min sharri ma sana't, abuu laka bini'matika alayya wa abuu laka bidhanbi faghfir li fa innahu la yaghfiru adh-dhunuba illa ant.",
    translations: {
      AppLanguage.english:
          "O Allah, You are my Lord, none has the right to be worshipped except You, You created me and I am Your servant and I abide to Your covenant and promise as best I can, I take refuge in You from the evil of which I have committed. I acknowledge Your favor upon me and I acknowledge my sin, so forgive me, for verily none can forgive sin except You.",
      AppLanguage.kurdish:
          "خوایە تۆ پەروەردگاری منی، هیچ پەرستراوێک نییە بە حەق جگە لە تۆ، تۆ منت دروست کردووە و من بەندەی تۆم، و من لەسەر پەیمان و بەڵێنی تۆم ئەوەندەی لە توانامدا بێت، پەنات پێ دەگرم لە شەڕی ئەوەی کە کردوومە، دان دەنێم بە نیعمەتەکانت بەسەرمەوە و دان دەنێم بە گوناهەکانمدا، دەی لێم خۆشبە، چونکە بەڕاستی کەس لە گوناهەکان خۆش نابێت جگە لە تۆ.",
    },
    category: 'morning',
    repeat: 1,
    reference: 'Bukhari',
  ),
  AdhkarItem(
    id: 2,
    arabic:
        'أمسينا وأمسى الملك لله والحمد لله، لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.',
    transliteration:
        "Amsayna wa amsa al-mulku lillahi wal-hamdu lillah, la ilaha illa Allahu wahdahu la sharika lah, lahul mulku wa lahul humdu wahuwa ala kulli shay'in qadir.",
    translations: {
      AppLanguage.english:
          "We have reached the evening and at this very time unto Allah belongs all sovereignty, and all praise is for Allah. None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.",
      AppLanguage.kurdish:
          "ئێوارەمان بەسەردا هات و پاشایەتی و حەمد و سەنا هەموو بۆ خودایە، هیچ پەرستراوێک نییە بە حەق جگە لە ئەڵڵای تاقانە کە هیچ شەریکێکی نییە، پاشایەتی و ستایش هەر بۆ ئەوە و ئەویش بەسەر هەموو شتێکدا بەدەسەڵاتە.",
    },
    category: 'evening',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 3,
    arabic: 'سبحان الله وبحمده.',
    transliteration: 'SubhanAllahi wa bihamdih.',
    translations: {
      AppLanguage.english: "Glory is to Allah and praise is to Him.",
      AppLanguage.kurdish: "پاک و بێگەردی بۆ خودا و ستایش بۆ ئەوە.",
    },
    category: 'daily',
    repeat: 100,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 4,
    arabic:
        'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.',
    transliteration:
        "La ilaha illa Allahu wahdahu la sharika lah, lahul mulku wa lahul humdu wahuwa ala kulli shay'in qadir.",
    translations: {
      AppLanguage.english:
          "None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.",
      AppLanguage.kurdish:
          "هیچ پەرستراوێک نییە بە حەق جگە لە ئەڵڵای تاقانە کە هیچ شەریکێکی نییە، پاشایەتی و ستایش هەر بۆ ئەوە و ئەویش بەسەر هەموو شتێکدا بەدەسەڵاتە.",
    },
    category: 'daily',
    repeat: 100,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 5,
    arabic: 'أستغفر الله وأتوب إليه.',
    transliteration: 'Astaghfirullaha wa atubu ilayh.',
    translations: {
      AppLanguage.english:
          "I seek Allah's forgiveness and turn to Him in repentance.",
      AppLanguage.kurdish:
          "داوای لێخۆشبوون لە خودا دەکەم و بۆ لای ئەو دەگەڕێمەوە.",
    },
    category: 'daily',
    repeat: 100,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 6,
    arabic: 'رضيت بالله ربًا وبالإسلام دينًا وبمحمد صلى الله عليه وسلم نبيًا.',
    transliteration:
        'Radheetu billahi rabban, wabil-islami dinan, wabimuhammadin sallallahu alayhi wa sallam nabiyya.',
    translations: {
      AppLanguage.english:
          "I am pleased with Allah as my Lord, with Islam as my religion and with Muhammad (peace and blessings of Allah be upon him) as my Prophet.",
      AppLanguage.kurdish:
          "ڕازیم کە خودا پەروەردگارم بێت و ئیسلام ئایینم بێت و محەمەد (سەلامی خوای لەسەر بێت) پێغەمبەرم بێت.",
    },
    category: 'morning',
    repeat: 3,
    reference: 'Abu Dawud, Tirmidhi',
  ),
  AdhkarItem(
    id: 7,
    arabic: 'حسبي الله لا إله إلا هو، عليه توكلت وهو رب العرش العظيم.',
    transliteration:
        'Hasbiyallahu la ilaha illa huwa alayhi tawakkaltu wahuwa rabbul arshil azeem.',
    translations: {
      AppLanguage.english:
          "Allah is sufficient for me. None has the right to be worshipped except Him. In Him I put my trust and He is the Lord of the Mighty Throne.",
      AppLanguage.kurdish:
          "خودا بەسمە، هیچ پەرستراوێک نییە بە حەق جگە لە ئەو، پشتم بە ئەو بەستووە و ئەویش پەروەردگاری عەرشی گەورەیە.",
    },
    category: 'evening',
    repeat: 7,
    reference: 'Abu Dawud',
  ),
  AdhkarItem(
    id: 8,
    arabic:
        'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ.',
    transliteration:
        "Bismillahi alladhi la yadurru ma'asmihi shay'un fil-ardi wa la fis-sama'i wa huwa as-sami' ul-'alim.",
    translations: {
      AppLanguage.english:
          "In the Name of Allah with Whose Name there is protection against every kind of harm in the earth or in the heaven, and He is the All-Hearing and All-Knowing.",
      AppLanguage.kurdish:
          "بە ناوی خودایەک کە بە ناوی ئەو هیچ شتێک لە زەوی و لە ئاسماندا زیان ناگەیەنێت، و ئەویش بیسەر و زانایە.",
    },
    category: 'morning',
    repeat: 3,
    reference: 'Abu Dawud, Tirmidhi',
  ),
  AdhkarItem(
    id: 9,
    arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ.',
    transliteration: 'SubhanAllahi wa bihamdih, subhanAllahil azeem.',
    translations: {
      AppLanguage.english:
          "Glory is to Allah and praise is to Him, Glory is to Allah the Most Great.",
      AppLanguage.kurdish:
          "پاک و بێگەردی و ستایش بۆ خودا، پاک و بێگەردی بۆ خودای گەورە.",
    },
    category: 'daily',
    repeat: 100,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 10,
    arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ.',
    transliteration: 'La hawla wa la quwwata illa billah.',
    translations: {
      AppLanguage.english: "There is no might nor power except with Allah.",
      AppLanguage.kurdish:
          "هیچ گۆڕانکاری و دەسەڵاتێک نییە مەگەر بە ویستی خودا نەبێت.",
    },
    category: 'daily',
    repeat: 50,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 11,
    arabic: 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّد.',
    transliteration: 'Allahumma salli wa sallim ala nabiyyina Muhammad.',
    translations: {
      AppLanguage.english:
          "O Allah, send prayers and peace upon our Prophet Muhammad.",
      AppLanguage.kurdish:
          "خودایە سەڵاوات و سەلام بنێرە بۆ سەر پێغەمبەرەکەمان محەمەد.",
    },
    category: 'daily',
    repeat: 10,
    reference: 'Tabarani',
  ),
  AdhkarItem(
    id: 12,
    arabic:
        'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهما ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
    transliteration:
        'Allahu la ilaha illa huwa al-hayyu al-qayyum, la ta\'khudhuhu sinatun wala nawm, lahu ma fi as-samawati wama fi al-ard, man dha alladhi yashfa\'u indahu illa bi-idhnih, ya\'lamu ma bayna aydihim wama khalfahum, wala yuhituna bishay\'in min ilmihi illa bima sha\'a, wasi\'a kursiyyuhu as-samawati wal-ard, wala ya\'uduhu hifzuhuma, wahuwa al-aliyyul-azim.',
    translations: {
      AppLanguage.english:
          "Allah! There is no god but He - the Living, the Self-subsisting, Eternal. No slumber can seize Him nor sleep. His are all things in the heavens and on earth. Who is there can intercede in His presence except as he permitteth? He knoweth what (appeareth to His creatures as) Before or After or Behind them. Nor shall they compass aught of his knowledge except as he willeth. His throne doth extend over the heavens and on earth, and he feeleth no fatigue in guarding and preserving them, For he is the Most High. the Supreme (in glory).",
      AppLanguage.kurdish:
          "خوا که پەرسترایەکە جگە لە ئەو کەسی تر نییە، هەر ئەویشە زیندویە و نەمرە و هەڵسوڕێنەری هەموو بونەوەرە... هیچ ماندوێتیەک نیە بۆ ئەو لە پاراستنی ئاسمانەکان و زەوی، و هەر ئەویشە بەرز و بڵند و گەورە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Quran 2:255',
  ),
  AdhkarItem(
    id: 13,
    arabic: 'اللهم أنت السلام ومنك السلام، تباركت يا ذا الجلال والإكرام.',
    transliteration:
        'Allahumma anta as-salam wa minka as-salam, tabarakta ya dhal-jalali wal-ikram.',
    translations: {
      AppLanguage.english:
          "O Allah, You are As-Salam (the One Who is free from all defects and deficiencies) and from You is all peace, blessed are You, O Possessor of majesty and honor.",
      AppLanguage.kurdish:
          "خوایە تۆ سەلامی (بێگەردی لە هەموو کەموکوڕیەک) و سەلامەتی و ئاشتی هەر لەلای تۆوەیە، پیرۆزی و بەرەکەتی تۆ زۆرە ئەی خاوەن گەورەیی و ڕێز.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 14,
    arabic: 'اللهم أعني على ذكرك وشكرك وحسن عبادتك.',
    transliteration:
        "Allahumma a'inni ala dhikrika wa shukrika wa husni ibadatik.",
    translations: {
      AppLanguage.english:
          "O Allah, help me to remember You, to give thanks to You, and to worship You in an excellent manner.",
      AppLanguage.kurdish:
          "خوایە یارمەتیم بدە لەسەر زیکر و یادی تۆ و شوکر و سوپاسگوزاریت و بەجێهێنانی پەرستنەکانت بە جوانترین شێوە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Abu Dawud, Nasai',
  ),
  AdhkarItem(
    id: 15,
    arabic: 'اللهم إني أسألك علماً نافعاً، ورزقاً طيباً، وعملاً متقبلاً.',
    transliteration:
        "Allahumma inni as'aluka ilman nafi'an, wa rizqan tayyiban, wa amalan mutaqabbalan.",
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for useful knowledge, provision that is good (pure), and deeds that will be accepted.",
      AppLanguage.kurdish:
          "خوایە من داوای زانیاریەکی سوودبەخش و ڕۆزیەکی پاک و حەڵاڵ و کارێکی لێ وەرگیراوت لێ دەکەم.",
    },
    category: 'morning',
    repeat: 1,
    reference: 'Ibn Majah',
  ),
  AdhkarItem(
    id: 16,
    arabic:
        'يا حي يا قيوم برحمتك أستغيث، أصلح لي شأني كله ولا تكلني إلى نفسي طرفة عين.',
    transliteration:
        "Ya Hayyu Ya Qayyum birahmatika astaghith, aslih li sha'ni kullahu wa la takilni ila nafsi tarfata ayn.",
    translations: {
      AppLanguage.english:
          "O Ever Living One, O Self-Sustaining One, in Your mercy I seek relief. Set all my affairs right for me and do not leave me to myself even for the blink of an eye.",
      AppLanguage.kurdish:
          "ئەی ئەو کەسەی کە زیندویت و نەبریت و هەڵسوڕێنەری هەموو بونەوەرەکەیت، بە بەزەیی تۆ هاوار دەکەم، هەموو بارودۆخەکانم بۆ چاک بکە و من مەسپێرە بە نەفسی خۆم بۆ چاو تروکاندنێکیش.",
    },
    category: 'morning',
    repeat: 1,
    reference: 'Hakim',
  ),
  AdhkarItem(
    id: 17,
    arabic: 'اللهم بك أصبحنا، وبك أمسينا، وبك نحيا، وبك نموت، وإليك النشور.',
    transliteration:
        "Allahumma bika asbahna, wa bika amsayna, wa bika nahya, wa bika namut, wa ilaykan-nushur.",
    translations: {
      AppLanguage.english:
          "O Allah, by You we enter the morning and by You we enter the evening, by You we live and by You we die, and to You is the Final Return.",
      AppLanguage.kurdish:
          "خوایە گەیشتنمان بە بەیانیان هەر بە تۆ بوو، و گەیشتنمان بە ئێوارەش هەر بە تۆیە، و هەر بە تۆش دەژین و دەمرین، و گەڕانەوەی کۆتاییش هەر بەرەو لای تۆیە.",
    },
    category: 'morning',
    repeat: 1,
    reference: 'Tirmidhi',
  ),
  AdhkarItem(
    id: 18,
    arabic: 'اللهم قني عذابك يوم تبعث عبادك.',
    transliteration: "Allahumma qini adhabaka yawma tab'athu ibadak.",
    translations: {
      AppLanguage.english:
          "O Allah, protect me from Your punishment on the Day You resurrect Your servants.",
      AppLanguage.kurdish:
          "خوایە بمپارێزە لە سزای خۆت لەو ڕۆژەی کە بەندەکانت زیندوو دەکەیتەوە.",
    },
    category: 'daily',
    repeat: 3,
    reference: 'Abu Dawud, Tirmidhi',
  ),
  AdhkarItem(
    id: 19,
    arabic: 'باسمك اللهم أموت وأحيا.',
    transliteration: "Bismika Allahumma amutu wa ahya.",
    translations: {
      AppLanguage.english: "In Your Name, O Allah, I die and I live.",
      AppLanguage.kurdish:
          "خوایە بە ناوی تۆوە دەمرم (ئەخەوم) و دەژیم (بە ئاگا دێمەوە).",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 20,
    arabic: 'الحمد لله الذي أحيانا بعد ما أماتنا وإليه النشور.',
    transliteration:
        "Alhamdu lillahi alladhi ahyana ba'da ma amatana wa ilayhin-nushur.",
    translations: {
      AppLanguage.english:
          "All praise is for Allah who gave us life after having taken it from us and unto Him is the resurrection.",
      AppLanguage.kurdish:
          "سوپاس و ستایش بۆ ئەو خودایەی کە زیندووی کردینەوە دوای ئەوەی کە مراندبووینی (خەوتبووین) و زیندووبوونەوەی کۆتاییش هەر بەرەو لای ئەوە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 21,
    arabic:
        'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد يحيي ويميت وهو على كل شيء قدير.',
    transliteration:
        "La ilaha illa Allahu wahdahu la sharika lah, lahul mulku wa lahul hamdu yuhyi wa yumitu wa huwa ala kulli shay'in qadir.",
    translations: {
      AppLanguage.english:
          "None has the right to be worshipped except Allah alone, without partner. To Him belongs all sovereignty and praise, He gives life and causes death and He is over all things omnipotent.",
      AppLanguage.kurdish:
          "هیچ پەرستراوێک نییە بە حەق جگە لە ئەڵڵای تاقانە کە هیچ شەریکێکی نییە، پاشایەتی و ستایش هەر بۆ ئەوە، ئەو دەژێنێت و دەمرێنێت و ئەویش بەسەر هەموو شتێکدا بەدەسەڵاتە.",
    },
    category: 'daily',
    repeat: 10,
    reference: 'Tirmidhi',
  ),
  AdhkarItem(
    id: 22,
    arabic:
        'اللهم إني أعوذ بك من الكفر والفقر، وأعوذ بك من عذاب القبر، لا إله إلا أنت.',
    transliteration:
        "Allahumma inni a'udhu bika minal-kufri wal-faqr, wa a'udhu bika min adhabil-qabr, la ilaha illa ant.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from disbelief and poverty and I seek refuge in You from the punishment of the grave. None has the right to be worshipped except You.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە بێبڕوایی و هەژاری، و پەنات پێ دەگرم لە سزای ناو گۆڕ، هیچ پەرستراوێک نییە بە حەق جگە لە تۆ.",
    },
    category: 'morning',
    repeat: 3,
    reference: 'Abu Dawud, Ahmad',
  ),
  AdhkarItem(
    id: 23,
    arabic:
        'اللهم عافني في بدني، اللهم عافني في سمعي، اللهم عافني في بصري، لا إله إلا أنت.',
    transliteration:
        "Allahumma afini fi badani, Allahumma afini fi sam'i, Allahumma afini fi basari, la ilaha illa ant.",
    translations: {
      AppLanguage.english:
          "O Allah, make me healthy in my body. O Allah, make me healthy in my hearing. O Allah, make me healthy in my sight. None has the right to be worshipped except You.",
      AppLanguage.kurdish:
          "خوایە لەشساغم بکە لە جەستەمدا، خوایە لەشساغم بکە لە بیستنمدا، خوایە لەشساغم بکە لە بینینمدا، هیچ پەرستراوێک نییە بە حەق جگە لە تۆ.",
    },
    category: 'morning',
    repeat: 3,
    reference: 'Abu Dawud, Ahmad',
  ),
  AdhkarItem(
    id: 24,
    arabic: 'اللهم إني أسألك العفو والعافية في الدنيا والآخرة.',
    transliteration:
        "Allahumma inni as'alukal-afwa wal-afiyata fid-dunya wal-akhirah.",
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for forgiveness and well-being in this world and the Hereafter.",
      AppLanguage.kurdish:
          "خوایە من داوای لێخۆشبوون و لەشساغی و تەندروستیت لێ دەکەم لە دونیا و لە قیامەتدا.",
    },
    category: 'morning',
    repeat: 1,
    reference: 'Abu Dawud, Ibn Majah',
  ),
  AdhkarItem(
    id: 25,
    arabic: 'اللهم استر عوراتي وآمن روعاتي.',
    transliteration: "Allahumma-stur awrati wa amin raw'ati.",
    translations: {
      AppLanguage.english:
          "O Allah, veil my weaknesses and set at ease my dismay.",
      AppLanguage.kurdish:
          "خوایە عەیبەکانم دابپۆشە و لە تەنگانە و ترسان دڵنیام بکەرەوە.",
    },
    category: 'morning',
    repeat: 1,
    reference: 'Abu Dawud, Ibn Majah',
  ),
  AdhkarItem(
    id: 26,
    arabic:
        'اللهم احفظني من بين يدي ومن خلفي وعن يميني وعن شمالي ومن فوقي، وأعوذ بعظمتك أن أغتال من تحتي.',
    transliteration:
        "Allahummah-fazni min bayni yadayya wa min khalfi wa an yamini wa an shimali wa min fawqi, wa a'udhu bi-azamatika an ughtala min tahti.",
    translations: {
      AppLanguage.english:
          "O Allah, protect me from before me and from behind me and from my right and from my left and from above me, and I seek refuge in Your greatness from being swallowed up from below me.",
      AppLanguage.kurdish:
          "خوایە بمپارێزە لە بەردەمم و لە دوام و لەلای ڕاستم و لەلای چەپم و لە سەروومەوە، و پەنا دەگرم بە گەورەیی تۆ لەوەی کە لە ژێرمەوە تیابچم.",
    },
    category: 'morning',
    repeat: 1,
    reference: 'Abu Dawud, Ibn Majah',
  ),
  AdhkarItem(
    id: 27,
    arabic:
        'اللهم عالم الغيب والشهادة، فاطر السماوات والأرض، رب كل شيء ومليكه، أشهد أن لا إله إلا أنت.',
    transliteration:
        "Allahumma alimal-ghaybi wash-shahadah, fatiras-samawati wal-ard, rabba kulli shay'in wa malikah, ash-hadu an la ilaha illa ant.",
    translations: {
      AppLanguage.english:
          "O Allah, Knower of the unseen and the seen, Creator of the heavens and the earth, Lord and Sovereign of all things, I bear witness that none has the right to be worshipped except You.",
      AppLanguage.kurdish:
          "خوایە ئەی زانای نهێنی و ئاشکرا، ئەی دروستکەری ئاسمانەکان و زەوی، پەروەردگار و خاوەنی هەموو شتێک، شایەتی دەدەم کە هیچ پەرستراوێک نییە بە حەق جگە لە تۆ.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Abu Dawud, Tirmidhi',
  ),
  AdhkarItem(
    id: 28,
    arabic: 'أعوذ بكلمات الله التامات من شر ما خلق.',
    transliteration: "A'udhu bikalimatillahit-tammati min sharri ma khalaq.",
    translations: {
      AppLanguage.english:
          "I seek refuge in the perfect words of Allah from the evil of what He has created.",
      AppLanguage.kurdish:
          "پەنا دەگرم بە وشە تەواوەکانی خودا لە شەڕی ئەو شتانەی کە دروستی کردوون.",
    },
    category: 'evening',
    repeat: 3,
    reference: 'Muslim, Tirmidhi',
  ),
  AdhkarItem(
    id: 29,
    arabic: 'بسم الله توكلت على الله، ولا حول ولا قوة إلا بالله.',
    transliteration:
        "Bismillahi tawakkaltu alallahi, wa la hawla wa la quwwata illa billah.",
    translations: {
      AppLanguage.english:
          "In the Name of Allah, I have placed my trust in Allah, there is no might or power except by Allah.",
      AppLanguage.kurdish:
          "بە ناوی خودا، پشتم بە خودا بەست، و هیچ گۆڕانکاری و دەسەڵاتێک نییە مەگەر بە ویستی خودا نەبێت.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Abu Dawud, Tirmidhi',
  ),
  AdhkarItem(
    id: 30,
    arabic:
        'اللهم إني أعوذ بك أن أضِل أو أُضَل، أو أزِل أو أُزَل، أو أظلم أو أُظلم، أو أجهل أو يُجهل علي.',
    transliteration:
        "Allahumma inni a'udhu bika an adilla aw udalla, aw azilla aw uzalla, aw azlima aw uzlama, aw ajhala aw yujhala alayya.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from leading others astray or being led astray, from causing others to slip or being caused to slip, from oppressing or being oppressed, and from behaving foolishly or being behaved foolishly towards.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لەوەی کە گومڕا بم یان گومڕا بکرێم، یان گومڕا ببم یان گومڕا بکرێم، یان زوڵم بکەم یان زوڵمم لێ بکرێت، یان نەزان بم یان بەرامبەرم بە نەزانی ڕەبەربانگ بکرێت.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Abu Dawud, Tirmidhi',
  ),
  AdhkarItem(
    id: 31,
    arabic:
        'اللهم اغفر لي، وارحمني، واهدني، واجبرني، وعافني، وارزقني، وارفعني.',
    transliteration:
        "Allahummagh-fir li, warhamni, wahdini, wajburni, wa'afini, warzuqni, warfa'ni.",
    translations: {
      AppLanguage.english:
          "O Allah, forgive me, have mercy on me, guide me, support me, protect me, provide for me and elevate me.",
      AppLanguage.kurdish:
          "خوایە لێم خۆشبە، و ڕەحمم پێ بکە، و هیدایەتم بدە، و یارمەتیم بدە، و لەشساغم بکە، و ڕۆزیم بدە، و بەرزم بکەرەوە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Abu Dawud, Tirmidhi',
  ),
  AdhkarItem(
    id: 32,
    arabic: 'سبحان الله وبحمده عدد خلقه، ورضا نفسه، وزنة عرشه، ومداد كلماته.',
    transliteration:
        "SubhanAllahi wa bihamdih, adada khalqihi, wa rida nafsihi, wa zinata arshihi, wa midada kalimatih.",
    translations: {
      AppLanguage.english:
          "Glory and praise is to Allah as many times as the number of His creation, in accordance with His pleasure, equal to the weight of His throne and as many as the ink of His words.",
      AppLanguage.kurdish:
          "پاک و بێگەردی و ستایش بۆ خودا بە ئەندازەی ژمارەی دروستکراوەکانی، و بە ئەندازەی ڕەزامەندی نەفسی خۆی، و بە کێشی عەرشەکەی، و بە پڕی وشەکانی.",
    },
    category: 'morning',
    repeat: 3,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 33,
    arabic: 'اللهم إني أسألك الجنة وأعوذ بك من النار.',
    transliteration:
        "Allahumma inni as'alukal-jannata wa a'udhu bika minan-nar.",
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for Paradise and I seek refuge in You from the Fire.",
      AppLanguage.kurdish:
          "خوایە من داوای بەهەشتت لێ دەکەم و پەنات پێ دەگرم لە ئاگری دۆزەخ.",
    },
    category: 'daily',
    repeat: 3,
    reference: 'Abu Dawud, Ibn Majah',
  ),
  AdhkarItem(
    id: 34,
    arabic: 'اللهم اغفر لي ذنبي كله، دِقه وجِله، وأوله وآخره، وعلانيته وسره.',
    transliteration:
        "Allahummagh-fir li dhanbi kullahu, diqqahu wa jillahu, wa awwalahu wa akhirahu, wa alaniyatahu wa sirrah.",
    translations: {
      AppLanguage.english:
          "O Allah, forgive me all my sins, the small and the great, the first and the last, the open and the secret.",
      AppLanguage.kurdish:
          "خوایە هەموو گوناهەکانم بۆ خۆشبە، ورد و درشتی، یەکەم و کۆتایی، ئاشکرا و نهێنی.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 35,
    arabic: 'أستغفر الله العظيم الذي لا إله إلا هو الحي القيوم وأتوب إليه.',
    transliteration:
        "Astaghfirullahal-azim alladhi la ilaha illa huwal-hayyul-qayyum wa atubu ilayh.",
    translations: {
      AppLanguage.english:
          "I seek the forgiveness of Allah the Mighty, whom there is no god except Him, the Living, the Eternal, and I repent to Him.",
      AppLanguage.kurdish:
          "داوای لێخۆشبوون لە خودای گەورە دەکەم کە هیچ پەرستراوێک نییە جگە لە ئەو، کە زیندووی و ڕاگرە، و دەگەڕێمەوە بۆ لای ئەو.",
    },
    category: 'daily',
    repeat: 3,
    reference: 'Abu Dawud, Tirmidhi',
  ),
  AdhkarItem(
    id: 36,
    arabic:
        'اللهم إني أعوذ بك من الهم والحزن، والعجز والكسل، والبخل والجبن، وضلع الدين وغلبة الرجال.',
    transliteration:
        "Allahumma inni a'udhu bika minal-hammi wal-hazan, wal-ajzi wal-kasal, wal-bukhli wal-jubn, wa dala'id-dayni wa ghalabatir-rijal.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from anxiety and sorrow, weakness and laziness, miserliness and cowardice, the burden of debts and from being overpowered by men.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە خەم و پەژارە، و بێدەسەڵاتی و تەمبەڵی، و ڕەزیلی و ترسنۆکی، و قورسایی قەرز و ژێردەستەیی پیاوان.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Bukhari',
  ),
  AdhkarItem(
    id: 37,
    arabic: 'لا إله إلا أنت سبحانك إني كنت من الظالمين.',
    transliteration: "La ilaha illa anta subhanaka inni kuntu minaz-zalimin.",
    translations: {
      AppLanguage.english:
          "None has the right to be worshipped except You, Glory is to You, surely I was among the wrongdoers.",
      AppLanguage.kurdish:
          "هیچ پەرستراوێک نییە جگە لە تۆ، تۆ پاک و بێگەردیت، بەڕاستی من لە زوڵمکاران بووم.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Tirmidhi, Hakim',
  ),
  AdhkarItem(
    id: 38,
    arabic: 'اللهم إني أسألك الهدى، والتقى، والعفاف، والغنى.',
    transliteration:
        'Allahumma inni as\'alukal-huda, wat-tuqa, wal-afafa, wal-ghina.',
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for guidance, piety, chastity and self-sufficiency.",
      AppLanguage.kurdish:
          "خوایە من داوای هیدایەت و پارێزگاری و داوێنپاکی و دەوڵەمەندی ڕووحت لێ دەکەم.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 39,
    arabic: 'اللهم مصرف القلوب صرف قلوبنا على طاعتك.',
    transliteration: "Allahumma musarrifal-qulubi sarrif qulubana ala ta'atik.",
    translations: {
      AppLanguage.english:
          "O Allah, Turner of the hearts, direct our hearts to Your obedience.",
      AppLanguage.kurdish:
          "خوایە ئەی وەرگێڕەری دڵەکان، دڵەکانمان وەرگێڕە بۆ سەر گوڕایەڵی و پەرستنی خۆت.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 40,
    arabic: 'يا مقلب القلوب ثبت قلبي على دينك.',
    transliteration: "Ya muqallibal-qulubi thabbit qalbi ala dinik.",
    translations: {
      AppLanguage.english:
          "O Turner of the hearts, make my heart steadfast upon Your religion.",
      AppLanguage.kurdish: "ئەی گۆڕەری دڵەکان، دڵم جێگیر بکە لەسەر ئایینەکەت.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Tirmidhi',
  ),
  AdhkarItem(
    id: 41,
    arabic:
        'اللهم إني أعوذ بك من العجز، والكسل، والجبن، والبخل، والهرم، وعذاب القبر.',
    transliteration:
        "Allahumma inni a'udhu bika minal-ajzi, wal-kasal, wal-jubn, wal-bukhl, wal-haram, wa adhabil-qabr.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from weakness, laziness, cowardice, miserliness, senility and the punishment of the grave.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە بێدەسەڵاتی و تەمبەڵی و ترسنۆکی و ڕەزیلی و پیری و سزای ناو گۆڕ.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 42,
    arabic: 'اللهم آتِ نفسي تقواها، وزكها أنت خير من زكاها، أنت وليها ومولاها.',
    transliteration:
        "Allahumma ati nafsi taqwaha, wa zakkiha anta khayru man zakkaha, anta waliyyuha wa mawlaha.",
    translations: {
      AppLanguage.english:
          "O Allah, grant my soul its piety and purify it, for You are the best of those who purify it. You are its Protector and its Lord.",
      AppLanguage.kurdish:
          "خوایە تەقوای نەفسم پێ بدە و پاکی بکەرەوە، چونکە تۆ باشترینی لەوانەی کە پاکی دەکەنەوە، تۆ پارێزەر و خاوەن و گەورەیت.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 43,
    arabic:
        'اللهم إني أعوذ بك من علم لا ينفع، ومن قلب لا يخشع، ومن نفس لا تشبع، ومن دعوة لا يستجاب لها.',
    transliteration:
        "Allahumma inni a'udhu bika min ilmin la yanfa', wa min qalbin la yakhsha', wa min nafsin la tashba', wa min da'watin la yustajabu laha.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from knowledge that does not benefit, from a heart that does not fear (You), from a soul that is never satisfied and from a supplication that is not answered.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە زانیاریەک کە سوودی نەبێت، و لە دڵێک کە ملکەچی تۆ نەبێت، و لە نەفسێک کە تێر نەبێت، و لە دوعایەک کە وەڵام نەدرێتەوە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 44,
    arabic:
        'اللهم إني أسألك من الخير كله عاجله وآجله، ما علمت منه وما لم أعلم.',
    transliteration:
        "Allahumma inni as'aluka minal-khayri kullihi ajilihi wa ajilih, ma alimtu minhu wa ma lam a'lam.",
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for all the good, both now and in the future, what I know of it and what I do not know.",
      AppLanguage.kurdish:
          "خوایە من داوای هەموو خێر و چاکەیەکت لێ دەکەم، ئەوەی کە زووە (لە دونیا) و ئەوەی کە دواترە (لە قیامەت)، ئەوەی لێی دەزانم و ئەوەی لێشی نازانم.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Ibn Majah',
  ),
  AdhkarItem(
    id: 45,
    arabic:
        'اللهم إني أعوذ بك من الشر كله عاجله وآجله، ما علمت منه وما لم أعلم.',
    transliteration:
        "Allahumma inni a'udhu bika minash-sharri kullihi ajilihi wa ajilih, ma alimtu minhu wa ma lam a'lam.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from all evil, both now and in the future, what I know of it and what I do not know.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە هەموو شەڕ و خراپەیەک، ئەوەی کە زووە و ئەوەی کە دواترە، ئەوەی لێی دەزانم و ئەوەی لێشی نازانم.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Ibn Majah',
  ),
  AdhkarItem(
    id: 46,
    arabic:
        'اللهم إني أسألك الجنة وما قرب إليها من قول أو عمل، وأعوذ بك من النار وما قرب إليها من قول أو عمل.',
    transliteration:
        "Allahumma inni as'alukal-jannata wa ma qarraba ilayha min qawlin aw amal, wa a'udhu bika minan-nari wa ma qarraba ilayha min qawlin aw amal.",
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for Paradise and what brings me near to it of speech or deed, and I seek refuge in You from the Fire and what brings me near to it of speech or deed.",
      AppLanguage.kurdish:
          "خوایە داوای بەهەشتت لێ دەکەم و هەر قسە و کارێک کە لێی نزیکم دەکاتەوە، و پەنات پێ دەگرم لە ئاگری دۆزەخ و هەر قسە و کارێک کە لێی نزیکم دەکاتەوە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Ibn Majah',
  ),
  AdhkarItem(
    id: 47,
    arabic:
        'اللهم إني أعوذ بك من زوال نعمتك، وتحول عافيتك، وفجاءة نقمتك، وجميع سخطك.',
    transliteration:
        "Allahumma inni a'udhu bika min zawali ni'matik, wa tahawwuli afiyatik, wa fuja'ati niqmatik, wa jami'i sakhatik.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from the withdrawal of Your blessing, the change of Your protection (from good to bad), the suddenness of Your punishment and all Your wrath.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە نەمانی نیعمەتەکانت، و گۆڕانی لەشساغیت، و سزای لەناکاوت، و هەموو تووڕەبوونی خۆت.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 48,
    arabic:
        'اللهم إني أعوذ بك من جهد البلاء، ودرك الشقاء، وسوء القضاء، وشماتة الأعداء.',
    transliteration:
        "Allahumma inni a'udhu bika min jahdil-balai, wa darkish-shaqai, wa su'il-qadai, wa shamatatil-adai.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from the distress of trial, from the depth of misery, from the evil of destiny, and from the ridicule of enemies.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە تاقیکردنەوەی سەخت، و لە گەیشتن بە بەدبەختی، و لە قەزا و قەدەری خراپ، و لە خۆشی دەربڕینی دوژمنان بەسەرمدا.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 49,
    arabic:
        'اللهم أصلح لي ديني الذي هو عصمة أمري، وأصلح لي دنياي التي فيها معاشي.',
    transliteration:
        "Allahumma aslih li dini alladhi huwa ismatu amri, wa aslih li dunyayallati fiha ma'ashi.",
    translations: {
      AppLanguage.english:
          "O Allah, set right for me my religion which is the safeguard of my affairs, and set right for me my world in which is my livelihood.",
      AppLanguage.kurdish:
          "خوایە ئایینەکەم بۆ چاک بکە کە قەڵای پاراستنی منە، و دونیایەکەم بۆ چاک بکە کە ژیانی منی تێدایە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 50,
    arabic:
        'اللهم أصلح لي آخرتي التي فيها معادي، واجعل الحياة زيادة لي في كل خير، واجعل الموت راحة لي من كل شر.',
    transliteration:
        "Allahumma aslih li akhirati allati fiha ma'adi, waj'alil-hayata ziyadatan li fi kulli khayr, waj'alil-mawta rahatan li min kulli shar.",
    translations: {
      AppLanguage.english:
          "And set right for me my Hereafter to which is my return, and make life for me an increase in all good and make death for me a rest from all evil.",
      AppLanguage.kurdish:
          "و قیامەتەکەم بۆ چاک بکە کە گەڕانەوەم بۆ لای ئەوە، و ژیانم بۆ بکە بە زیادبوون لە هەموو خێر و چاکەیەک، و مردنم بۆ بکە بە حەسانەوە لە هەموو شەڕ و خراپەیەک.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 51,
    arabic:
        'اللهم اغفر لي خطيئتي، وجهلي، وإسرافي في أمري، وما أنت أعلم به مني.',
    transliteration:
        "Allahummagh-fir li khati'ati, wa jahli, wa israfi fi amri, wa ma anta a'lamu bihi minni.",
    translations: {
      AppLanguage.english:
          "O Allah, forgive me my sins, my ignorance, my immoderation in my affairs and all that You know better than I.",
      AppLanguage.kurdish:
          "خوایە لە هەڵەکانم و نەزانینەکانم و ئیسراف و زیادەڕۆییەکانم لە کارەکانمدا خۆشبە، و لەوەش کە تۆ لە من باشتر دەیزانیت.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 52,
    arabic: 'اللهم اغفر لي جدي وهزلي، وخطئي وعمدي، وكل ذلك عندي.',
    transliteration:
        "Allahummagh-fir li jiddi wa hazli, wa khata'i wa amdi, wa kullu dhalika indi.",
    translations: {
      AppLanguage.english:
          "O Allah, forgive me (the sins of) my seriousness and my joking, my errors and my deliberate acts, and I am guilty of all that.",
      AppLanguage.kurdish:
          "خوایە لە (گوناهی) بە ئەنقەست و بە گاڵتە و بە هەڵە و بە زانینم خۆشبە، کە هەموو ئەمانە لە مندا هەن.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 53,
    arabic:
        'اللهم أنت الملك لا إله إلا أنت، أنت ربي وأنا عبدك، ظلمت نفسي واعترفت بذنبي فاغفر لي ذنوبي جميعاً.',
    transliteration:
        "Allahumma antal-maliku la ilaha illa ant, anta rabbi wa ana abduk, zalamtu nafsi wa'taraftu bidhanbi faghfir li dhunubi jami'a.",
    translations: {
      AppLanguage.english:
          "O Allah, You are the King, none has the right to be worshipped except You. You are my Lord and I am Your servant, I have wronged my soul and I confess my sin, so forgive me all my sins.",
      AppLanguage.kurdish:
          "خوایە تۆ پاشایت و هیچ پەرستراوێک نییە جگە لە تۆ، تۆ پەروەردگارمی و منیش بەندەی تۆم، زوڵمم لە خۆم کردووە و دان دەنێم بە گوناهەکانمدا، دەی لە هەموو گوناهەکانم خۆشبە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 54,
    arabic:
        'اللهم اهدني لأحسن الأخلاق لا يهدي لأحسنها إلا أنت، واصرف عني سيئها لا يصرف عني سيئها إلا أنت.',
    transliteration:
        "Allahummah-dini li-ahsanil-akhlaqi la yahdi li-ahsaniha illa ant, wasrif anni sayyi'aha la yasrifu anni sayyi'aha illa ant.",
    translations: {
      AppLanguage.english:
          "O Allah, guide me to start excellent character for none guides to it except You, and turn away from me bad character for none turns it away except You.",
      AppLanguage.kurdish:
          "خوایە ڕێنماییم بکە بۆ باشترین ڕەوشتەکان چونکە کەس ڕێنمایی ناکات بۆ لایان جگە لە تۆ، و ڕەوشتە خراپەکانم لێ دوور بخەرەوە چونکە کەس دووریان ناخاتەوە جگە لە تۆ.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 55,
    arabic: 'لبيك وسعديك والخير كله في يديك، والشر ليس إليك.',
    transliteration:
        "Labbaika wa sa'daika wal-khayru kulluhu fi yadaik, wash-sharru laysa ilaik.",
    translations: {
      AppLanguage.english:
          "At Your service and at Your pleasure, and all good is in Your hands, and evil is not attributed to You.",
      AppLanguage.kurdish:
          "هاتووم بۆ لات و وەڵامی بانگەوازی تۆ دەدەمەوە، و هەموو خێر و چاکەیەک لە دەستی تۆدایە، و هیچ شەڕ و خراپەیەک بۆ تۆ ناگەڕێتەوە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 56,
    arabic: 'تباركت وتعاليت، أستغفرك وأتوب إليك.',
    transliteration: "Tabarakta wa ta'alait, astaghfiruka wa atubu ilaik.",
    translations: {
      AppLanguage.english:
          "Blessed are You and Exalted, I seek Your forgiveness and turn to You in repentance.",
      AppLanguage.kurdish:
          "بەرز و پیرۆزیت، داوای لێخۆشبوونت لێ دەکەم و بۆ لای تۆ دەگەڕێمەوە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 57,
    arabic: 'اللهم إني أعوذ برضاك من سخطك، وبمعافاتك من عقوبتك.',
    transliteration:
        "Allahumma inni a'udhu biridaka min sakhatik, wa bimu'afatika min uqubatik.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in Your pleasure from Your wrath, and in Your protection from Your punishment.",
      AppLanguage.kurdish:
          "خوایە من پەنا دەگرم بە ڕەزامەندی تۆ لە تووڕەبوونت، و بە لێخۆشبوونت لە سزات.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 58,
    arabic: 'اللهم إني أعوذ بك منك، لا أحصي ثناءً عليك أنت كما أثنيت على نفسك.',
    transliteration:
        "Allahumma inni a'udhu bika minka, la uhsi thana'an alaika anta kama athnaita ala nafsik.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from You. I cannot enumerate Your praise, You are as You have praised Yourself.",
      AppLanguage.kurdish:
          "خوایە من پەنا دەگرم بە خۆت لە (سزای) خۆت، ناتوانم ستایشی تۆ بکەم وەک ئەوەی کە شایستەیت، تۆ هەر وەک ئەوەیت کە ستایشی نەفسی خۆتت کردووە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 59,
    arabic: 'اللهم إني أسألك الهدى والسداد.',
    transliteration: "Allahumma inni as'alukal-huda was-sadad.",
    translations: {
      AppLanguage.english: "O Allah, I ask You for guidance and correctness.",
      AppLanguage.kurdish:
          "خوایە داوای هیدایەت و بەڕاست چوون و جێگیریم لێ دەکەم.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 60,
    arabic:
        'اللهم حبب إلينا الإيمان وزينه في قلوبنا، وكره إلينا الكفر والفسوق والعصيان، واجعلنا من الراشدين.',
    transliteration:
        "Allahumma habbib ilaynal-imana wa zayyinhu fi qulubina, wa karrih ilaynal-kufra wal-fusuqa wal-isyan, waj'alna minal-rashidin.",
    translations: {
      AppLanguage.english:
          "O Allah, make faith dear to us and beautify it in our hearts, and make disbelief, sin and rebellion hateful to us, and make us among the rightly guided.",
      AppLanguage.kurdish:
          "خوایە ئیمانمان لا خۆشەویست بکە و لە دڵماندا بیڕازێنەرەوە، و بێبڕوایی و فیسق و سەرپێچیمان لا ناشرین بکە، و بمانکەیت لە ڕێنمایی کراوان.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Hakim',
  ),
  AdhkarItem(
    id: 61,
    arabic:
        'اللهم توفنا مسلمين، وأحينا مسلمين، وألحقنا بالصالحين، غير خزايا ولا مفتونين.',
    transliteration:
        "Allahumma tawaffana muslimin, wa ahyina muslimin, wa al-hiqna bis-salihin, ghayra khazaya wala maftunin.",
    translations: {
      AppLanguage.english:
          "O Allah, make us die as Muslims, live as Muslims, and join us with the righteous, not being disgraced or tried.",
      AppLanguage.kurdish:
          "خوایە بە موسڵمانی بمانمرێنە، و بە موسڵمانی بمانژیێنە، و بە پیاوچاکانمان بگەیەنە، بەبێ ئەوەی ڕیسوا بین یان تووشی فیتنە بین.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Hakim',
  ),
  AdhkarItem(
    id: 62,
    arabic:
        'اللهم إني أسألك نفساً بك مطمئنة، تؤمن بلقائك، وترضى بقضائك، وتقنع بعطائك.',
    transliteration:
        "Allahumma inni as'aluka nafsan bika mutma'innatan, tu'minu biliqaik, wa tardu biqadaik, wa taqna'u bi-ata'ik.",
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for a soul that finds rest in You, believes in meeting You, is pleased with Your decree, and is satisfied with Your giving.",
      AppLanguage.kurdish:
          "خوایە من داوای نەفسێکی ئارامت لێ دەکەم کە بە تۆ دڵنیابێت، و باوەڕی بە گەیشتن بە تۆ هەبێت، و بە قەزا و قەدەرت ڕازی بێت، و بە بەخشیشی تۆ قەناعەتی هەبێت.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Tabarani',
  ),
  AdhkarItem(
    id: 63,
    arabic: 'اللهم إني أسألك الثبات في الأمر، والعزيمة على الرشد.',
    transliteration:
        'Allahumma inni as\'alukath-thubata fil-amr, wal-azimata alar-rushd.',
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for steadfastness in my affairs and the resolution to follow the right path.",
      AppLanguage.kurdish:
          "خوایە من داوای جێگیریم لێ دەکەم لە کارەکانمدا، و داوای بڕیاری سوور لەسەر ڕێگای ڕاست و دروست.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Nasai',
  ),
  AdhkarItem(
    id: 64,
    arabic: 'اللهم إني أسألك شكر نعمتك، وحسن عبادتك.',
    transliteration:
        "Allahumma inni as'aluka shukra ni'matik, wa husna ibadatik.",
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for (the ability to) give thanks for Your blessings and for excellence in Your worship.",
      AppLanguage.kurdish:
          "خوایە من داوای سوپاسگوزاری نیعمەتەکانت و جوانی لە پەرستنت لێ دەکەم.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Nasai',
  ),
  AdhkarItem(
    id: 65,
    arabic: 'اللهم إني أسألك قلباً سليماً، ولساناً صادقاً.',
    transliteration:
        "Allahumma inni as'aluka qalban saliman, wa lisanan sadiqan.",
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for a sound heart and a truthful tongue.",
      AppLanguage.kurdish:
          "خوایە من داوای دڵێکی پاک و بێگەرد، و زمانێکی ڕاستگۆت لێ دەکەم.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Nasai',
  ),
  AdhkarItem(
    id: 66,
    arabic: 'اللهم إني أسألك من خير ما تعلم، وأعوذ بك من شر ما تعلم.',
    transliteration:
        "Allahumma inni as'aluka min khayri ma ta'lam, wa a'udhu bika min sharri ma ta'lam.",
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for the best of what You know, and I seek refuge in You from the evil of what You know.",
      AppLanguage.kurdish:
          "خوایە من داوای خێر و چاکەی ئەو شتانەت لێ دەکەم کە تۆ دەیزانیت، و پەنات پێ دەگرم لە شەڕ و خراپەی ئەو شتانەی کە تۆ دەیزانیت.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Nasai',
  ),
  AdhkarItem(
    id: 67,
    arabic: 'اللهم إني أستغفرك لما تعلم، إنك أنت علام الغيوب.',
    transliteration:
        "Allahumma inni astaghfiruka lima ta'lam, innaka anta allamul-ghuyub.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek Your forgiveness for what You know, for You are the Knower of the unseen.",
      AppLanguage.kurdish:
          "خوایە من داوای لێخۆشبوون لەو شتانە دەکەم کە تۆ دەیزانیت، چونکە بەڕاستی تۆ زانای نهێنی و غەیبەکانت.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Nasai',
  ),
  AdhkarItem(
    id: 68,
    arabic:
        'اللهم أعنا ولا تعن علينا، وانصرنا ولا تنصر علينا، وامكر لنا ولا تمكر علينا.',
    transliteration:
        "Allahumma ainna wala tuin alaina, wansurna wala tansur alaina, wamkur lana wala tamkur alaina.",
    translations: {
      AppLanguage.english:
          "O Allah, help us and do not help against us, give us victory and do not give victory against us, plan for us and do not plan against us.",
      AppLanguage.kurdish:
          "خوایە یارمەتیمان بدە و یارمەتی کەس مەدە بەسەرماندا، و سەرکەوتنمان پێ ببەخشە و سەرکەوتن مەبەخشە بە کەس بەسەرماندا، و فێڵ و پلانمان بۆ بکە و فێڵ و پلان لە ئێمە مەکە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Abu Dawud, Tirmidhi',
  ),
  AdhkarItem(
    id: 69,
    arabic: 'اللهم اهدنا ويسر الهدى لنا، وانصرنا على من بغى علينا.',
    transliteration:
        "Allahummah-dina wa yassiril-huda lana, wansurna ala man bagha alaina.",
    translations: {
      AppLanguage.english:
          "O Allah, guide us and make guidance easy for us, and give us victory over those who oppress us.",
      AppLanguage.kurdish:
          "خوایە هیدایەتمان بدە و هیدایەتمان بۆ ئاسان بکە، و سەرکەوتنمان پێ ببەخشە بەسەر ئەو کەسانەی کە زوڵممان لێ دەکەن.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Abu Dawud, Tirmidhi',
  ),
  AdhkarItem(
    id: 70,
    arabic: 'اللهم اجعلنا لك شاكرين، لك ذاكرين، لك راهبين، لك مطواعين.',
    transliteration:
        "Allahummaj-alna laka shakirin, laka dhakirin, laka rahibin, laka mitwa'in.",
    translations: {
      AppLanguage.english:
          "O Allah, make us grateful to You, mindful of You, fearful of You, and obedient to You.",
      AppLanguage.kurdish:
          "خوایە بمانکە بە سوپاسگوزاری خۆت، و یادی تۆ بکەین، و لە تۆ بترسین، و بۆ تۆ ملکەچ بین.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Abu Dawud, Tirmidhi',
  ),
  AdhkarItem(
    id: 71,
    arabic: 'إليك مخبتين، إليك أواهين منيبين.',
    transliteration: "Ilaika mukhbitin, ilaika awwahin munibin.",
    translations: {
      AppLanguage.english:
          "Humble before You, crying out and turning to You in repentance.",
      AppLanguage.kurdish:
          "بۆ لای تۆ ملکەچ و زەلیل بین، و بە بێزاری هاوارت بۆ بکەین و بۆ لای تۆ بگەڕێینەوە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Abu Dawud, Tirmidhi',
  ),
  AdhkarItem(
    id: 72,
    arabic: 'رب تقبل توبتنا، واغسل حوبتنا، وأجب دعوتنا.',
    transliteration:
        "Rabbi taqabbal tawbatana, waghsil hubbatana, wa-ajib da'watana.",
    translations: {
      AppLanguage.english:
          "Lord, accept our repentance, wash away our sins, and answer our supplication.",
      AppLanguage.kurdish:
          "پەروەردگارە تۆبەکەمان لێ وەرگرە، و گوناهەکانمان بشۆرەوە، و دوعاکەمان وەڵام بدەرەوە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Abu Dawud, Tirmidhi',
  ),
  AdhkarItem(
    id: 73,
    arabic: 'ثبت حجتنا، واهد قلوبنا، وسدد ألسنتنا، واسلل سخيمة صدورنا.',
    transliteration:
        "Thabbit hujjattana, wahdi qulubana, wa saddid alsinattana, waslul sakhimata sudurina.",
    translations: {
      AppLanguage.english:
          "Make our proof firm, guide our hearts, make our tongues speak the truth, and draw out the malice from our breasts.",
      AppLanguage.kurdish:
          "بەڵگەکانمان جێگیر بکە، و دڵەکانمان هیدایەت بدە، و زمانمان ڕاست بکەرەوە، و کینە و خراپەی ناو دڵمان دەربکە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Abu Dawud, Tirmidhi',
  ),
  AdhkarItem(
    id: 74,
    arabic: 'اللهم إني أعوذ بك من البرص، والجنون، والجذام، ومن سيئ الأسقام.',
    transliteration:
        "Allahumma inni a'udhu bika minal-barasi, wal-jununi, wal-judhami, wa min sayyi'il-asqam.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from leprosy, madness, elephantiasis and all evil diseases.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە بەڵەکبوون و شێتی و خۆرەک و نەخۆشیە خراپەکان.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Abu Dawud, Nasai',
  ),
  AdhkarItem(
    id: 75,
    arabic: 'اللهم إني أعوذ بك من منكرات الأخلاق، والأعمال، والأهواء.',
    transliteration:
        "Allahumma inni a'udhu bika min munkaratil-akhlaqi, wal-amali, wal-ahwai.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from evil character, evil deeds and evil desires.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە ڕەوشتی ناشرین و کاری خراپ و ئارەزووی بەد.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Tirmidhi, Hakim',
  ),
  AdhkarItem(
    id: 76,
    arabic: 'اللهم إنك عفو كريم تحب العفو فاعف عني.',
    transliteration:
        "Allahumma innaka afuwwun karimun tuhibbul-afwa fa'fu anni.",
    translations: {
      AppLanguage.english:
          "O Allah, You are the Most Forgiving, most Generous, You love to forgive, so forgive me.",
      AppLanguage.kurdish:
          "خوایە بەڕاستی تۆ لێبووردە و بەخشندەیت، لێبووردنت خۆش دەوێت دەی لێم خۆشبە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Tirmidhi, Ibn Majah',
  ),
  AdhkarItem(
    id: 77,
    arabic: 'اللهم إني أسألك حبك، وحب من يحبك، والعمل الذي يبلغني حبك.',
    transliteration:
        "Allahumma inni as'aluka hubbaka, wa hubba man yuhibbuka, wal-amala alladhi yuballighuni hubbak.",
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for Your love, the love of those who love You, and those deeds which will cause me to attain Your love.",
      AppLanguage.kurdish:
          "خوایە من داوای خۆشەویستی تۆ دەکەم، و خۆشەویستی ئەو کەسانەی کە تۆیان خۆش دەوێت، و ئەو کارەی کە دەمگەیەنێتە خۆشەویستی تۆ.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Tirmidhi',
  ),
  AdhkarItem(
    id: 78,
    arabic: 'اللهم اجعل حبك أحب إلي من نفسي، وأهلي، ومن الماء البارد.',
    transliteration:
        "Allahummaj-al hubbaka ahabba ilayya min nafsi, wa ahli, wa minal-ma'il-baridi.",
    translations: {
      AppLanguage.english:
          "O Allah, make Your love dearer to me than my own self, my family and cold water.",
      AppLanguage.kurdish:
          "خوایە خۆشەویستی خۆت لا من خۆشەویستتر بکە لە خۆم و ماڵ و منداڵم و لە ئاوی سارد لە کاتی تینوێتیدا.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Tirmidhi',
  ),
  AdhkarItem(
    id: 79,
    arabic:
        'اللهم إني أسألك الهدى والسداد، اللهم إني أسألك الهدى والعفاف والغنى.',
    transliteration:
        "Allahumma inni as'alukal-huda was-sadad, Allahumma inni as'alukal-huda wal-afafa wal-ghina.",
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for guidance and correctness. O Allah, I ask You for guidance, chastity and self-sufficiency.",
      AppLanguage.kurdish:
          "خوایە من داوای هیدایەت و جێگیربوون دەکەم، خوایە من داوای هیدایەت و داوێنپاکی و دەوڵەمەندی ڕووحت لێ دەکەم.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 80,
    arabic: 'أعوذ بالله من فتنة النار وعذاب النار، وفتنة القبر وعذاب القبر.',
    transliteration:
        "A'udhu billahi min fitnatin-nari wa adhabin-nar, wa fitnatil-qabri wa adhabil-qabr.",
    translations: {
      AppLanguage.english:
          "I seek refuge in Allah from the trial of the Fire and the punishment of the Fire, and from the trial of the grave and the punishment of the grave.",
      AppLanguage.kurdish:
          "پەنا دەگرم بە خودا لە فیتنەی ئاگر و سزای ئاگر، و لە فیتنەی ناو گۆڕ و سزای ناو گۆڕ.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 81,
    arabic: 'ومن شر فتنة الغنى، ومن شر فتنة الفقر.',
    transliteration:
        "Wa min sharri fitnatil-ghina, wa min sharri fitnatil-faqr.",
    translations: {
      AppLanguage.english:
          "And from the evil of the trial of wealth, and from the evil of the trial of poverty.",
      AppLanguage.kurdish:
          "و لە شەڕی تاقیکردنەوەی دەوڵەمەندی، و لە شەڕی تاقیکردنەوەی هەژاری.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 82,
    arabic: 'اللهم إني أعوذ بك من شر فتنة المسيح الدجال.',
    transliteration:
        "Allahumma inni a'udhu bika min sharri fitnatil-masihid-dajjal.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from the evil of the trial of the False Messiah.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە شەڕی فیتنەی مەسیحی دەجال.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 83,
    arabic:
        'اللهم اغسل خطاياي بماء الثلج والبرد، ونق قلبي من الخطايا كما نقيت الثوب الأبيض من الدنس.',
    transliteration:
        "Allahummagh-sil khatayaya bi-ma'ith-thalji wal-baradi, wa naqqi qalbi minal-khataya kama naqqaitath-thawbal-abyada minad-danas.",
    translations: {
      AppLanguage.english:
          "O Allah, wash away my sins with snow and hail water, and purify my heart from sins as a white garment is purified from dirt.",
      AppLanguage.kurdish:
          "خوایە گوناهەکانم بشۆرەوە بە ئاوی بەفر و تەرزە، و دڵم پاک بکەرەوە لە گوناهەکان وەک چۆن جلی سپی پاک دەکرێتەوە لە پیسی.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 84,
    arabic: 'اللهم إني أعوذ بك من الكسل والهرم، والمأثم والمغرم.',
    transliteration:
        "Allahumma inni a'udhu bika minal-kasali wal-harami, wal-ma'thami wal-maghram.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from laziness and senility, and from sin and debt.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە تەمبەڵی و پیری، و لە گوناه و قەرزاری.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 85,
    arabic: 'اللهم إني أعوذ بك من القسوة، والغفلة، والعيلة، والذلة، والمسكنة.',
    transliteration:
        "Allahumma inni a'udhu bika minal-qaswati, wal-ghaflati, wal-ailati, wadh-dhillati, wal-maskanah.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from hardheartedness, heedlessness, destitution, humiliation, and poverty.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە دڵڕەقی و بێئاگایی و هەژاری و سەرشۆڕی و نەداری.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Hakim, Tabarani',
  ),
  AdhkarItem(
    id: 86,
    arabic:
        'اللهم إني أعوذ بك من الفقر، والكفر، والفسوق، والشقاق، والنفاق، والسمعة، والرياء.',
    transliteration:
        "Allahumma inni a'udhu bika minal-faqri, wal-kufri, wal-fusuqi, wash-shiqaqi, wan-nifaqi, was-sumati, war-riya.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from poverty, disbelief, sin, disagreement, hypocrisy, status-seeking, and showing off.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە هەژاری و بێبڕوایی و فیسق و ناکۆکی و دووڕوویی و ناوپەیداکردن و ڕیاکاری.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Hakim',
  ),
  AdhkarItem(
    id: 87,
    arabic:
        'اللهم إني أعوذ بك من الصمم، والبكم، والجنون، والجذام، والبرص، وسيئ الأسقام.',
    transliteration:
        "Allahumma inni a'udhu bika minas-samami, wal-bukumi, wal-jununi, wal-judhami, wal-barasi, wa sayyi'il-asqam.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from deafness, being mute, madness, elephantiasis, leprosy, and all evil diseases.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە کەڕی و لاڵی و شێتی و خۆرەک و بەڵەکبوون و نەخۆشیە خراپەکان.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Hakim',
  ),
  AdhkarItem(
    id: 88,
    arabic:
        'اللهم إني أعوذ بك من العجز، والكسل، والجبن، والبخل، والهرم، والقسوة، والغفلة، والعيلة، والذلة، والمسكنة.',
    transliteration:
        "Allahumma inni a'udhu bika minal-ajzi, wal-kasali, wal-jubni, wal-bukhli, wal-harami, wal-qaswati, wal-ghaflati, wal-ailati, wadh-dhillati, wal-maskanah.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from weakness, laziness, cowardice, miserliness, senility, hardheartedness, heedlessness, destitution, humiliation and poverty.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە بێدەسەڵاتی، تەمبەڵی، ترسنۆکی، ڕەزیلی، پیری، دڵڕەقی، بێئاگایی، هەژاری، سەرشۆڕی و نەداری.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Hakim, Tabarani',
  ),
  AdhkarItem(
    id: 89,
    arabic:
        'اللهم إني أعوذ بك من الفقر، والقلة، والذلة، وأعوذ بك من أن أظلم أو أُظلم.',
    transliteration:
        "Allahumma inni a'udhu bika minal-faqri, wal-qillati, wadh-dhillati, wa a'udhu bika min ان azlima aw uzlama.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from poverty, scarcity and humiliation, and I seek refuge in You from oppressing others or being oppressed.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە هەژاری و کەمبوونی (ڕۆزی) و سەرشۆڕی، و پەنات پێ دەگرم لەوەی زوڵم بکەم یان زوڵمم لێ بکرێت.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Abu Dawud, Nasai',
  ),
  AdhkarItem(
    id: 90,
    arabic:
        'اللهم إني أعوذ بك من جار السوء في دار المقامة؛ فإن جار البادية يتحول.',
    transliteration:
        "Allahumma inni a'udhu bika min jaris-su'i fi daril-muqamah; fa-inna jaral-badiyati yatahawwal.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from a bad neighbor in the place of permanent residence; for the neighbor of the desert (travel) changes.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە هاوسێی خراپ لە شوێنی نیشتەجێبوونی هەمیشەییمدا، چونکە هاوسێی سەفەر و بیابان دەگۆڕێت.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Nasai, Hakim',
  ),
  AdhkarItem(
    id: 91,
    arabic:
        'اللهم إني أعوذ بك من قلب لا يخشع، ومن دعاء لا يُسمع، ومن نفس لا تشبع، ومن علم لا ينفع.',
    transliteration:
        "Allahumma inni a'udhu bika min qalbin la yakhsha', wa min dua'in la yusma', wa min nafsin la tashba', wa min ilmin la yanfa'.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from a heart that does not fear You, from a supplication that is not heard, from a soul that is never satisfied and from knowledge that does not benefit.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە دڵێک کە ملکەچ نەبێت، و لە دوعایەک کە وەڵام نەدرێتەوە، و لە نەفسێک کە تێر نەبێت، و لە زانیاریەک کە سوودی نەبێت.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Abu Dawud, Tirmidhi, Nasai',
  ),
  AdhkarItem(
    id: 92,
    arabic: 'أعوذ بك من هؤلاء الأربع.',
    transliteration: "A'udhu bika min ha'ula'il-arba'.",
    translations: {
      AppLanguage.english: "I seek refuge in You from these four.",
      AppLanguage.kurdish: "پەنات پێ دەگرم لەو چوار شتەی کە باسم کرد.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Abu Dawud, Tirmidhi, Nasai',
  ),
  AdhkarItem(
    id: 93,
    arabic:
        'اللهم إني أعوذ بك من يوم السوء، ومن ليلة السوء، ومن ساعة السوء، ومن صاحب السوء، ومن جار السوء في دار المقامة.',
    transliteration:
        "Allahumma inni a'udhu bika min yawmis-su'i, wa min laylatis-su'i, wa min sa'atis-su'i, wa min sahibis-su'i, wa min jaris-su'i fi daril-muqamah.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from an evil day, an evil night, an evil hour, an evil companion, and an evil neighbor in the place of permanent residence.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە ڕۆژی خراپ، و لە شەوی خراپ، و لە سەعاتی خراپ، و لە هاوەڵی خراپ، و لە هاوسێی خراپ لە ماڵی نیشتەجێبووندا.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Tabarani',
  ),
  AdhkarItem(
    id: 94,
    arabic: 'اللهم إني أسألك الجنة، وأستجير بك من النار.',
    transliteration:
        "Allahumma inni as'alukal-jannata, wa astajiru bika minan-nar.",
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for Paradise and I seek Your protection from the Fire.",
      AppLanguage.kurdish:
          "خوایە من داوای بەهەشتت لێ دەکەم و پەنات پێ دەگرم لە ئاگری دۆزەخ.",
    },
    category: 'daily',
    repeat: 3,
    reference: 'Tirmidhi, Nasai, Ibn Majah',
  ),
  AdhkarItem(
    id: 95,
    arabic: 'اللهم فقهني في الدين.',
    transliteration: "Allahumma faqqihni fid-din.",
    translations: {
      AppLanguage.english: "O Allah, grant me understanding of the religion.",
      AppLanguage.kurdish: "خوایە من شارەزا و تێگەیشتوو بکە لە ئاییندا.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 96,
    arabic: 'اللهم إني أعوذ بك أن أشرك بك وأنا أعلم، وأستغفرك لما لا أعلم.',
    transliteration:
        "Allahumma inni a'udhu bika an ushrika bika wa ana a'lam, wa astaghfiruka lima la a'lam.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You lest I associate anything with You while I know it, and I seek Your forgiveness for what I do not know.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لەوەی هاتوچۆ و هاوبەشت بۆ بڕیار بدەم بە زانینەوە، و داوای لێخۆشبوونت لێ دەکەم لەوەی کە نایزانم.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad',
  ),
  AdhkarItem(
    id: 97,
    arabic: 'اللهم انفعني بما علمتني، وعلمني ما ينفعني، وزدني علماً.',
    transliteration:
        "Allahumma-nfa'ni bima allamtani, wa allimni ma yanfa'uni, wa zidni ilman.",
    translations: {
      AppLanguage.english:
          "O Allah, benefit me with what You have taught me, and teach me that which will benefit me, and increase me in knowledge.",
      AppLanguage.kurdish:
          "خوایە سوودم پێ بگەیەنە بەوەی فێرت کردووم، و فێرم بکە ئەوەی کە سوودم پێ دەگەیەنێت، و زانیاریم زیاد بکە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Tirmidhi, Ibn Majah',
  ),
  AdhkarItem(
    id: 98,
    arabic:
        'اللهم إني أسألك إيماناً لا يرتد، ونعيماً لا ينفد، ومرافقة محمد صلى الله عليه وسلم في أعلى جنة الخلد.',
    transliteration:
        "Allahumma inni as'aluka imanan la yartadd, wa na'iman la yanfad, wa murafaqata Muhammadin sallallahu alayhi wa sallam fi ala jannatil-khuld.",
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for faith that does not waver, blessing that never ends, and the company of Muhammad (peace and blessings of Allah be upon him) in the highest part of the Eternal Paradise.",
      AppLanguage.kurdish:
          "خوایە من داوای ئیمانێکی جێگیرت لێ دەکەم کە پاشەکشە نەکات، و نیعمەتێک کە تەواو نەبێت، و هاوەڵی محەمەد (سڵاوی خوای لەسەر بێت) لە بەرزترین بەشی بەهەشتی هەمیشەییدا.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Nasai',
  ),
  AdhkarItem(
    id: 99,
    arabic: 'اللهم قني شر نفسي، واعزم لي على أرشد أمري.',
    transliteration: "Allahumma qini sharra nafsi, wa'zim li ala arshadi amri.",
    translations: {
      AppLanguage.english:
          "O Allah, protect me from the evil of my own self, and grant me the resolution to do that which is most correct in my affairs.",
      AppLanguage.kurdish:
          "خوایە بمپارێزە لە شەڕی نەفسی خۆم، و بڕیاری جێگیرم پێ ببەخشە لەسەر چاکترین لە کارەکانمدا.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad, Hakim',
  ),
  AdhkarItem(
    id: 100,
    arabic:
        'اللهم اغفر لي ما قدمت وما أخرت، وما أسررت وما أعلنت، وما أسرفت وما أنت أعلم به مني، أنت المقدم وأنت المؤخر لا إله إلا أنت.',
    transliteration:
        "Allahummagh-fir li ma qaddamtu wa ma akhkhartu, wa ma asrartu wa ma a'lantu, wa ma asraftu wa ma anta a'lamu bihi minni, antal-muqaddimu wa antal-mu'akhkhiru la ilaha illa ant.",
    translations: {
      AppLanguage.english:
          "O Allah, forgive me for those (sins) which I committed in the past and those I will commit in the future, those which I committed in secret and those I committed in public, and those in which I exceeded all bounds, and those which You are better aware of than I. You are the One Who brings forward (everything) and the One Who delays (everything), none has the right to be worshipped except You.",
      AppLanguage.kurdish:
          "خوایە لێم خۆشبە لەوەی لە پێشوودا کردوومە و لەوەش کە لە داهاتوودا دەیکەم، و لەوەی بە نهێنی کردوومە و لەوەش بە ئاشکرا کردوومە، و لەوەش کە ئیسرانی لێ کردوومە، و لەوەش کە تۆ لە من باشتر دەیزانیت، تۆ پێشخەر و پاشخەریت، هیچ پەرستراوێک نییە جگە لە تۆ.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 101,
    arabic:
        'للهم إني أعوذ بك من فتنة القبر، ومن فتنة الدجال، ومن فتنة المحيا والممات.',
    transliteration:
        "Allahumma inni a'udhu bika min fitnatil-qabri, wa min fitnatid-dajjali, wa min fitnatil-mahyā wal-mamāt.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from the trial of the grave, from the trial of the Dajjal (Anti-Christ), and from the trials of life and death.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە فیتنەی ناو گۆڕ، و لە فیتنەی دەجال، و لە فیتنەی ژیان و مردن.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 102,
    arabic: 'اللهم إني أعوذ بك من المأثم والمغرم.',
    transliteration: "Allahumma inni a'udhu bika minal-ma'thami wal-maghram.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from sin and from being in debt.",
      AppLanguage.kurdish: "خوایە من پەنات پێ دەگرم لە گوناهباری و قەرزاری.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 103,
    arabic: 'اللهم إني أسألك الهدى والتقى والعفاف والغنى.',
    transliteration:
        "Allahumma inni as'alukal-huda wat-tuqa wal-afafa wal-ghina.",
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for guidance, piety, chastity and self-sufficiency.",
      AppLanguage.kurdish:
          "خوایە من داوای هیدایەت و پارێزگاری و داوێنپاکی و دەوڵەمەندی ڕووحت لێ دەکەم.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 104,
    arabic: 'للهم اغفر لي ذنبي، ووسع لي في داري، وبارك لي في رزقي.',
    transliteration:
        "Allahummagh-fir li dhanbi, wa wassi' li fi dari, wa barik li fi rizqi.",
    translations: {
      AppLanguage.english:
          "O Allah, forgive me my sin, make my house spacious for me and bless me in my provision.",
      AppLanguage.kurdish:
          "خوایە لە گوناهەکانم خۆشبە، و ماڵەکەم بۆ فراوان بکە، و بەرەکەت بخەرە ڕۆزیەکەمەوە.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Ahmad',
  ),
  AdhkarItem(
    id: 105,
    arabic: 'للهم إني أسألك من فضلك ورحمتك، فإنه لا يملكها إلا أنت.',
    transliteration:
        "Allahumma inni as'aluka min fadlika wa rahmatik, fa-innahu la yamlikuha illa ant.",
    translations: {
      AppLanguage.english:
          "O Allah, I ask You for Your favor and Your mercy, for none possesses them except You.",
      AppLanguage.kurdish:
          "خوایە من داوای فەزڵ و ڕەحمەتی تۆ دەکەم، چونکە کەس نییە خاوەنیان بێت جگە لە تۆ.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Tabarani',
  ),
  AdhkarItem(
    id: 106,
    arabic:
        'اللهم إني أعوذ بك من التردي، والهدم، والغرق، والحرق، وأعوذ بك أن يتخبطني الشيطان عند الموت.',
    transliteration:
        "Allahumma inni a'udhu bika minat-taraddi, wal-hadmi, wal-gharaqi, wal-harqi, wa a'udhu bika ان yatakhabbatanish-shaitanu indal-mawt.",
    translations: {
      AppLanguage.english:
          "O Allah, I seek refuge in You from falling (from high places), from being crushed by a falling wall, from drowning and from being burned; and I seek refuge in You from Satan misguiding me at the time of death.",
      AppLanguage.kurdish:
          "خوایە من پەنات پێ دەگرم لە کەوتنە خوارەوە، و ڕووخان، و خنکان، و سووتان، و پەنات پێ دەگرم لەوەی شەیتان لەکاتی مردندا گومڕام بکات.",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Abu Dawud, Nasai',
  ),
  AdhkarItem(
    id: 107,
    arabic: 'وأعوذ بك أن أموت في سبيلك مدبراً، وأعوذ بك أن أموت لديغاً.',
    transliteration:
        "Wa a'udhu bika an amuta fi sabilika mudbiran, wa a'udhu bika an amuta ladigha.",
    translations: {
      AppLanguage.english:
          "And I seek refuge in You from dying in Your cause while fleeing (from the battlefield), and I seek refuge in You from dying from the sting of a poisonous creature.",
      AppLanguage.kurdish:
          "و پەنات پێ دەگرم لەوەی بمرم لە ڕێگای تۆدا لەکاتێکدا پشت هەڵدەکەم (لە بەرەی جەنگ)، و پەنات پێ دەگرم لەوەی بمرم بە پێوەدان (مار یان دووپشک).",
    },
    category: 'daily',
    repeat: 1,
    reference: 'Abu Dawud, Nasai',
  ),
  AdhkarItem(
    id: 139,
    arabic: 'أستغفر الله وأتوب إليه.',
    transliteration: 'Astaghfirullaha wa atubu ilayh.',
    translations: {
      AppLanguage.english:
          "I seek Allah's forgiveness and turn to Him in repentance.",
      AppLanguage.kurdish:
          "داوای لێخۆشبوون لە خودا دەکەم و بۆ لای ئەو دەگەڕێمەوە.",
    },
    category: 'morning',
    repeat: 100,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 140,
    arabic: 'سبحان الله وبحمده.',
    transliteration: 'SubhanAllahi wa bihamdih.',
    translations: {
      AppLanguage.english: "Glory is to Allah and praise is to Him.",
      AppLanguage.kurdish: "پاک و بێگەردی بۆ خودا و ستایش بۆ ئەوە.",
    },
    category: 'morning',
    repeat: 100,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 141,
    arabic: 'اللھم صَل وسلم علَى نَبِينا مُحمد.',
    transliteration: 'Allahumma salli wa sallim ala nabiyyina Muhammad.',
    translations: {
      AppLanguage.english:
          "O Allah, send prayers and peace upon our Prophet Muhammad.",
      AppLanguage.kurdish:
          "خودایە سەڵاوات و سەلام بنێرە بۆ سەر پێغەمبەرەکەمان محەمەد.",
    },
    category: 'morning',
    repeat: 10,
    reference: 'Tabarani',
  ),
  AdhkarItem(
    id: 142,
    arabic:
        'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.',
    transliteration:
        "La ilaha illa Allahu wahdahu la sharika lah, lahul mulku wa lahul humdu wahuwa ala kulli shay'in qadir.",
    translations: {
      AppLanguage.english:
          "None has the right to be worshipped except Allah, alone, without partner, to Him belongs all sovereignty and praise and He is over all things omnipotent.",
      AppLanguage.kurdish:
          "هیچ پەرستراوێک نییە بە حەق جگە لە ئەڵڵای تاقانە کە هیچ شەریکێکی نییە، پاشایەتی و ستایش هەر بۆ ئەوە و ئەویش بەسەر هەموو شتێکدا بەدەسەڵاتە.",
    },
    category: 'morning',
    repeat: 100,
    reference: 'Bukhari & Muslim',
  ),
  AdhkarItem(
    id: 143,
    arabic: 'سبحان الله وبحمده عدد خلقه، ورضا نفسه، وزنة عرشه، ومداد كلماته.',
    transliteration:
        "SubhanAllahi wa bihamdih, adada khalqihi, wa rida nafsihi, wa zinata arshihi, wa midada kalimatih.",
    translations: {
      AppLanguage.english:
          "Glory and praise is to Allah as many times as the number of His creation, in accordance with His pleasure, equal to the weight of His throne and as many as the ink of His words.",
      AppLanguage.kurdish:
          "پاک و بێگەردی و ستایش بۆ خودا بە ئەندازەی ژمارەی دروستکراوەکانی، و بە ئەندازەی ڕەزامەندی نەفسی خۆی، و بە کێشی عەرشەکەی، و بە پڕی وشەکانی.",
    },
    category: 'morning',
    repeat: 3,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 144,
    arabic: 'أعوذ بكلمات الله التامات من شر ما خلق.',
    transliteration: "A'udhu bikalimatillahit-tammati min sharri ma khalaq.",
    translations: {
      AppLanguage.english:
          "I seek refuge in the perfect words of Allah from the evil of what He has created.",
      AppLanguage.kurdish:
          "پەنا دەگرم بە وشە تەواوەکانی خودا لە شەڕی ئەو شتانەی کە دروستی کردوون.",
    },
    category: 'evening',
    repeat: 3,
    reference: 'Muslim',
  ),
  AdhkarItem(
    id: 145,
    arabic:
        'اللهم إني أصبحت أشهدك وأشهد حملة عرشك، وملائكتك وجميع خلقك، أنك أنت الله لا إله إلا أنت وحدك لا شريك لك، وأن محمداً عبدك ورسولك.',
    transliteration:
        "Allahumma inni asbahtu ash-haduka wa ash-hadu hamalata arshika, wa mala'ikataka wa jami'a khalqika, annaka antal-lahu la ilaha illa anta wahdaha la sharika laka, wa anna Muhammadan abduka wa rasuluk.",
    translations: {
      AppLanguage.english:
          "O Allah, I have entered the morning calling You as a witness, and the bearers of Your Throne, and Your angels and all Your creation, that You are Allah, none has the right to be worshipped except You, alone, without partner, and that Muhammad is Your slave and Messenger.",
      AppLanguage.kurdish:
          "خوایە من بەیانیم کردەوە و تۆ و هەڵگرانی عەرشەکەت و فریشتەکانت و هەموو دروستکراوەکانت دەکەم بە شایەت، کە تۆ خودایت و هیچ پەرستراوێک نییە جگە لە تۆ، تاقانەیت و بێ شەریکیت، و محەمەد بەندە و پێغەمبەری تۆیە.",
    },
    category: 'evening',
    repeat: 4,
    reference: 'Abu Dawud',
  ),
  AdhkarItem(
    id: 146,
    arabic:
        'اللهم ما أمسى بي من نعمة أو بأحد من خلقك فمنك وحدك لا شريك لك، فلك الحمد ولك الشكر.',
    transliteration:
        "Allahumma ma amsa bi min ni'matin aw bi-ahadin min khalqika faminka wahdaka la sharika laka, falakal-hamdu wa lakash-shukr.",
    translations: {
      AppLanguage.english:
          "O Allah, whatever blessing has been received by me or anyone of Your creation is from You alone, You have no partner, so to You belongs all praise and to You belongs all thanks.",
      AppLanguage.kurdish:
          "خوایە هەر نیعمەتێک کە لە ئێواراندا بە من یان بە هەر یەکێک لە دروستکراوەکانت گەیشتووە، تەنها لە تۆوەیە و بێ شەریکیت، بۆیە ستایش و سوپاس هەر بۆ تۆیە.",
    },
    category: 'evening',
    repeat: 1,
    reference: 'Abu Dawud',
  ),
  AdhkarItem(
    id: 147,
    arabic: 'حسبي الله لا إله إلا هو عليه توكلت وهو رب العرش العظيم.',
    transliteration:
        "Hasbiyallahu la ilaha illa huwa alayhi tawakkaltu wahuwa rabbul-arshil-azim.",
    translations: {
      AppLanguage.english:
          "Allah is sufficient for me. None has the right to be worshipped except Him. In Him I put my trust and He is the Lord of the Mighty Throne.",
      AppLanguage.kurdish:
          "خودا بەسمە، هیچ پەرستراوێک نییە بە حەق جگە لە ئەو، پشتم بە ئەو بەستووە و ئەویش پەروەردگاری عەرشی گەورەیە.",
    },
    category: 'evening',
    repeat: 7,
    reference: 'Abu Dawud',
  ),
  AdhkarItem(
    id: 148,
    arabic:
        'اللهم عافني في بدني، اللهم عافني في سمعي، اللهم عافني في بصري، لا إله إلا أنت.',
    transliteration:
        "Allahumma afini fi badani, Allahumma afini fi sam'i, Allahumma afini fi basari, la ilaha illa ant.",
    translations: {
      AppLanguage.english:
          "O Allah, make me healthy in my body. O Allah, make me healthy in my hearing. O Allah, make me healthy in my sight. None has the right to be worshipped except You.",
      AppLanguage.kurdish:
          "خوایە لەشساغم بکە لە جەستەمدا، خوایە لەشساغم بکە لە بیستنمدا، خوایە لەشساغم بکە لە بینینمدا، هیچ پەرستراوێک نییە بە حەق جگە لە تۆ.",
    },
    category: 'evening',
    repeat: 3,
    reference: 'Abu Dawud',
  ),
];
