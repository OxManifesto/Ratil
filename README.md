<div align="center">

<img src="asset/icon/app_icon.png" alt="Ratil Logo" width="120" height="120" style="border-radius: 24px;" />

# Ratil — رتیل

**A beautifully crafted, offline-first Holy Quran companion**  
*Read. Listen. Reflect. Anytime. Anywhere.*

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-00B4AB?logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-purple)](https://flutter.dev/multi-platform)

</div>

---

## ✨ What Is Ratil?

Ratil (رتیل — meaning *"to recite beautifully"*) is a free, open-source Quran application built with Flutter. It's designed for Muslims who want a clean, distraction-free experience when reading or listening to the Holy Quran — without needing an internet connection.

The app bundles the complete Arabic text, multiple translations, Tajweed color-coding, and audio recitations from world-renowned reciters — all in a single, offline-ready package.

---

## 🌟 Features

### 📖 Reading
- Full Arabic Quran text — all 114 surahs, 6,236 verses
- **Tajweed color-coding** — each rule highlighted in its own color (Ghunnah, Madd, Ikhfa, Qalqalah, and more)
- Side-by-side translations in **Arabic, English, and Kurdish (Sorani)**
- Adjustable text scale for comfortable reading
- Browse by **Surah**, **Juz**, or **Page**
- Bookmark verses and jump back instantly

### 🎧 Listening
- **14+ world-class reciters** — Abdul Basit, Maher Al Muaiqly, Mishary Rashid Al Afasy, Yasser Al Dosari, Raad Al Kurdi, Al-Ghamdi, Al-Minshawi, Ali Al-Huthaifi, Khalid Al Jalil, Hazaa Al Balushi, Fares Abbad, Ahmed El Agamy, Abdulrahman Mosad, and more
- Continuous playback with lock-screen controls and notification media bar
- Download surahs for fully offline listening

### 🕌 Prayer Times
- Accurate prayer times using **Adhan calculation** (with multiple method support)
- GPS-based automatic location or 20+ preset cities across the Muslim world
- Adhan notifications with **6 different Adhan sounds** to choose from
- Background daily reschedule via WorkManager (Android)
- Supports respecting silent/DND mode

### 🧭 Qibla Direction
- Live compass needle pointing toward Makkah
- Works with the phone's magnetometer sensor

### 📿 Dhikr & Adhkar
- Morning and evening Adhkar collection
- Daily progress tracking with reset at midnight
- Asma ul-Husna (99 Names of Allah) with meanings in three languages

### 🎨 Theming & Personalization
- Dark / Light / System theme
- App language: Arabic, English, Kurdish
- Hijri calendar display

---

## 🏗️ Architecture

```
lib/
├── constants/        # App-wide constants, colors, language enums, localized strings
├── data/             # Static data — Adhkar, Asma ul-Husna, Surah database
├── models/           # Dart data models
├── providers/        # ChangeNotifier state providers (Theme, Navigation, Prayer Times)
├── screens/          # Full-page screens (Prayer Times, Qiblah)
├── services/         # Background services (SecurityService, DailyResetService)
├── theme/            # AppTheme, ThemePalette
├── utils/            # Platform utilities (Samsung compatibility fix)
├── widgets/          # Reusable UI components (Compass, Imsakiya, Permission Onboarding)
└── main.dart         # App entry point + all main feature screens
```

**State Management:** Provider + BLoC (flutter_bloc)  
**Local Storage:** SharedPreferences (non-sensitive) + FlutterSecureStorage (sensitive)  
**Background Tasks:** WorkManager (Android)  
**Audio:** just_audio + just_audio_background  
**Prayer Calculation:** adhan_dart + muslim_data_flutter  
**Notifications:** flutter_local_notifications

---

## 🚀 Getting Started

### Prerequisites

| Tool | Minimum Version |
|------|----------------|
| Flutter SDK | 3.x |
| Dart SDK | 3.x |
| Android SDK | API 21+ (Android 5.0) |
| Xcode (iOS/macOS) | 14+ |

### Clone & Run

```bash
# 1. Clone the repo
git clone https://github.com/MrGuevar4/Ratil.git
cd Ratil

# 2. Install dependencies
flutter pub get

# 3. Run on your device or emulator
flutter run
```

---

## 📦 Building

### Android (APK / AAB)

Before building a release, you need to create your own signing keystore:

```bash
# Copy the example file and fill in your values
cp android/key.properties.example android/key.properties
```

Edit `android/key.properties` with your actual keystore path and passwords. **Never commit this file.**

```bash
# Build a release APK
flutter build apk --release

# Build an App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
# Open ios/Runner.xcworkspace in Xcode to archive and distribute
```

### Web (GitHub Pages)

```bash
flutter build web --release --base-href /Ratil/
# Deploy build/web/ to your gh-pages branch
```

### Web (Cloudflare Pages)

```bash
flutter build web --release
# Deploy build/web/ — Cloudflare handles routing via the included web/_redirects file
```

> **Note:** For best web results, serve over HTTPS so geolocation and audio download work without mixed-content blocks.

### Desktop (Linux / Windows / macOS)

```bash
flutter build linux   --release
flutter build windows --release
flutter build macos   --release
```

---

## ⚙️ Configuration

### PDF Quran (Big Quran)

The app can optionally link to hosted PDF mushaf files. No PDF is bundled — links are loaded from `link/big-quran.txt`:

```
arabic=https://your-host.com/arabic-quran.pdf
english=https://your-host.com/english-quran.pdf
kurdish=https://your-host.com/kurdish-quran.pdf
```

Use a host that allows CORS GET requests. Google Drive public share links typically fail in browsers; a direct CDN URL works best.

### Reciter Audio URLs

Each reciter's per-surah audio links live in a corresponding `.txt` file inside `link/`. The format is one URL per line, ordered by surah number. See any existing file (e.g. `link/maher.txt`) for the expected format.

A helper script is provided at `tools/convert_drive_links.py` to convert Google Drive share links to direct download URLs.

---

## 🔒 Security

| Layer | Implementation |
|-------|---------------|
| Sensitive preferences | `FlutterSecureStorage` with `encryptedSharedPreferences` (Android) and Keychain (iOS) |
| Rooted / Jailbroken detection | `root_checker_plus` — warns the user if the device is compromised |
| Android network policy | `network_security_config.xml` restricts cleartext traffic |
| Signing credentials | `android/key.properties` and `android/app/*.jks` are gitignored — never committed |
| WebView telemetry | `android.webkit.WebView.MetricsOptOut = true` in AndroidManifest |

---

## 🗺️ Supported Prayer Calculation Cities

The app ships with **20 preset locations** covering major Muslim cities worldwide:

Makkah · Madinah · Cairo · Istanbul · Dubai · Doha · Erbil · Sulaymaniyah · Duhok · Halabja · Kirkuk · Zakho · Ranya · Hajiawa · Chawarqurna · Tehran · Kuala Lumpur · Jakarta · London · New York

…plus any GPS location anywhere in the world.

---

## 🎙️ Reciters

| Reciter | Language |
|---------|----------|
| Qari Abdul Basit Abdul Samad | Arabic |
| Maher Al Muaiqly | Arabic |
| Mishary Rashid Al Afasy | Arabic |
| Yasser Al Dosari | Arabic |
| Sa'ad Al-Ghamdi | Arabic |
| Al-Minshawi | Arabic |
| Ali Al-Huthaifi | Arabic |
| Khalid Al Jalil | Arabic |
| Hazaa Al Balushi | Arabic |
| Fares Abbad | Arabic |
| Ahmed El Agamy | Arabic |
| Abdulrahman Mosad | Arabic |
| Ahmed Khader | Arabic |
| Ayman Roshdy Sweed | Arabic |
| Majid Al-Zamil | Arabic |
| Tariq Muhammad | Arabic |
| Raad Al-Kurdi | Kurdish |
| Quran Al-Qari Sharif | Kurdish |
| Al-Quran Kurdish Translation | Kurdish |
| Al-Quran English Translation | English |

---

## 🤝 Contributing

Contributions are welcome! Whether it's fixing a bug, adding a new reciter, improving translations, or enhancing the UI — every bit helps.

1. **Fork** this repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. **Never commit** `android/key.properties`, `android/local.properties`, or any `.jks` files
4. Make your changes and test on at least one platform
5. Open a **Pull Request** with a clear description of what you changed and why

### Code Style

This project follows the `flutter_lints` ruleset. Run the analyzer before submitting:

```bash
flutter analyze
```

---

## 🐛 Reporting Issues

Found a bug? Please [open an issue](https://github.com/MrGuevar4/Ratil/issues) and include:

- Your device model and OS version
- Flutter/Dart version (`flutter --version`)
- Steps to reproduce the problem
- Any relevant error messages or logs

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 🌍 Languages

The app interface is fully localized in:

- 🇸🇦 **Arabic** (العربية)
- 🇬🇧 **English**
- 🏴 **Kurdish Sorani** (کوردی سۆرانی)

---

## 🙏 Credits & Acknowledgements

- **Quran Text:** Tanzil.net — The Noble Quran digital text
- **Prayer Calculations:** [adhan-dart](https://github.com/prayer-times/adhan-dart) library
- **Tajweed Data:** Community-maintained tajweed annotation files
- **Audio Reciters:** All reciters are credited within the app; audio links are served from publicly available Islamic archives
- **Flutter Team:** For the incredible cross-platform framework that made this possible

---

<div align="center">

**Made with ❤️ for the Muslim Ummah**

*May Allah accept this work and make it a source of benefit.*  
*اللهم تقبل منا إنك أنت السميع العليم*

</div>
