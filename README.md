# 🕌 Qurantom — Quran Audio Player

A beautiful, minimal Quran audio player built with Flutter. Stream all 114 Surahs with a clean Islamic-inspired dark UI.

---
 
## 📱 Demo
 
[![Demo Qurantom](https://img.youtube.com/vi/lpofgvmGIL0/0.jpg)](https://youtube.com/shorts/lpofgvmGIL0)
 
---


## ✨ Features

- 📖 **Browse all 114 Surahs** — with Arabic name, English name, translation, and number of Ayahs
- 🔍 **Real-time search** — search by Surah name, translation, or number
- 🎵 **Audio streaming** — stream Surah audio directly from the internet
- ⏯️ **Full playback controls** — play, pause, seek, rewind/forward 10 seconds
- 📊 **Progress bar** — live position and duration display
- 🎛️ **Mini player** — persistent bottom bar while browsing the Surah list
- 🌙 **Dark Islamic-inspired theme** — deep navy, gold accents

---

## 📸 Screenshots

> Add your screenshots here after running the app.

| Surah List | Player Screen |
|---|---|
| <img src="https://raw.githubusercontent.com/tomflutter/alurantom/refs/heads/master/assets/screenshots/surah_list.png" width="180"/> | <img src="https://raw.githubusercontent.com/tomflutter/alurantom/refs/heads/master/assets/screenshots/player.png" width="180"/> |

---

## 🏗️ Architecture

This app uses the **BLoC pattern** for state management.

```
lib/
├── blocs/
│   ├── surah_bloc.dart         # Surah list logic
│   ├── player_bloc.dart        # Audio playback logic
│   ├── surah/
│   │   ├── surah_event.dart
│   │   └── surah_state.dart
│   ├── player_event.dart
│   └── player_state.dart
├── models/
│   └── surah.dart              # Surah data model
├── repositories/
│   └── quran_repository.dart   # API calls
├── screens/
│   ├── surah_list_screen.dart  # Main screen
│   └── player_screen.dart      # Full player screen
├── widgets/
│   ├── mini_player_bar.dart    # Persistent bottom player
│   ├── surah_list_tile.dart    # Surah list item
│   └── shimmer_list.dart       # Loading skeleton
└── utils/
    ├── app_theme.dart          # Theme & colors
    └── duration_formatter.dart # Time formatting
```

---

## 🔄 State Management

### SurahBloc
| State | Description |
|---|---|
| `SurahInitial` | Before any data is loaded |
| `SurahLoading` | Fetching Surahs from API |
| `SurahLoaded` | Surahs loaded, supports search filtering |
| `SurahError` | Failed to fetch data |

### PlayerBloc
| State | Description |
|---|---|
| `PlayerInitial` | Player not yet used |
| `PlayerActive` | Player active with full playback info |

#### PlayerStatus (enum)
`initial` · `loading` · `playing` · `paused` · `completed` · `error`

---

## 📦 Dependencies

```yaml
dependencies:
  flutter_bloc: # State management
  equatable:    # Value equality for BLoC states
  just_audio:   # Audio streaming
```

---

## 🚀 Getting Started

```bash
# Clone the project
git clone https://github.com/yourusername/qurantom.git

# Install dependencies
flutter pub get

# Run the app
flutter run
```

> Requires Flutter 3.x and an internet connection for audio streaming.

---

## 📥 Download

[![Download APK](https://img.shields.io/badge/Download-APK-brightgreen?style=for-the-badge&logo=android)](https://github.com/tomflutter/alurantom/releases/latest/download/qurantom.apk)

## 🎨 Theme Colors

| Name | Hex | Usage |
|---|---|---|
| Background Dark | `#0D1117` | Main background |
| Background Card | `#161B22` | Cards & surfaces |
| Accent Gold | `#D4AF37` | Primary accent |
| Text Primary | `#E6EDF3` | Main text |
| Text Secondary | `#8B949E` | Subtitles |

---

## 🤲 Credits

- Quran data & audio from [AlQuran Cloud API](https://alquran.cloud/api)
- Built with [Flutter](https://flutter.dev) & [BLoC](https://bloclibrary.dev)
