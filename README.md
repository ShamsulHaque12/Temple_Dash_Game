# 🏛️ Temple Dash - Endless Runner Game

A high-performance, action-packed 2D Endless Runner game built with **Flutter**, **Flame Engine**, and **GetX**.

---

## 📲 Download & Install APK

Want to play **Temple Dash** directly on your Android device without building from source? You can download and install the pre-compiled release APK:

[![Download APK](https://img.shields.io/badge/Download-Temple__Dash__Game.apk-success?style=for-the-badge&logo=android&logoColor=white)](https://drive.google.com/file/d/1rkigWjzL9ClQdl7IaBfkY_nn1SkW100x/view?usp=sharing)

> 📥 **[Click Here to Download Release APK (Google Drive)](https://drive.google.com/file/d/1rkigWjzL9ClQdl7IaBfkY_nn1SkW100x/view?usp=sharing)**

### 📱 Quick Installation Guide:

1. Tap the download link above to get the `app-release.apk` file from Google Drive.
2. Open the downloaded file on your Android mobile device.
3. If prompted by Android security, enable **"Allow installation from unknown sources"** for your browser or file manager.
4. Tap **Install**, open the game, and enjoy playing **Temple Dash**!

---

## 📌 Project Overview

**Temple Dash** is an immersive mobile endless runner where players navigate treacherous temple pathways, jump over obstacles, slide under barriers, and collect precious gold coins and emerald gems while dodging ancient traps.

The application follows clean architectural patterns using **GetX** for state management and routing, **GetStorage** for lightweight persistent database storage, and **Flame Engine** for high-fps 2D game loops and physics-based collision detection.

---

## ✨ Key Features

- 🏃 **Dynamic Endless Gameplay**: Fluid player movement with jump, slide, lane-shifting, and progressive speed scaling.
- 💎 **Collectibles System**: Collect Gold Coins and Emerald Gems to boost overall high scores and run statistics.
- ⚡ **Power-Ups & Boosters**:
  - 🛡️ **Shield**: Temporary invincibility against collision damage.
  - 🧲 **Coin Magnet**: Automatically attracts nearby gold coins.
  - 🚀 **Speed Boost**: Blitz through obstacles at hyper speed.
  - ✖️ **Score Multiplier**: Quadruple points earned during active duration.
- 🏆 **Persisted Leaderboard**: Local high score tracking and ranking system saved automatically via `GetStorage`.
- ⚙️ **Audio & Game Controls**:
  - Sound Effects (SFX) & Background Music (BGM) toggle via `audioplayers`.
  - Comprehensive **"Reset All Progress"** feature with data synchronization.
- 🎨 **Modern Obsidian Gold UI**: Custom-designed dark theme UI using `flutter_animate` for smooth micro-animations.

---

## 🛠️ Tech Stack & Architecture

| Layer                | Technology / Package                                                   | Purpose                                                   |
| :------------------- | :--------------------------------------------------------------------- | :-------------------------------------------------------- |
| **Framework**        | [Flutter](https://flutter.dev) (SDK >= 3.0.0)                          | Cross-platform UI development                             |
| **Game Engine**      | [Flame](https://flame-engine.org) (`^1.18.0`)                          | 2D game loop, rendering, collision detection              |
| **State Management** | [GetX](https://pub.dev/packages/get) (`^4.6.6`)                        | Reactive state management, dependency injection & routing |
| **Local Storage**    | [GetStorage](https://pub.dev/packages/get_storage) (`^2.1.1`)          | Key-value database storage for high scores & settings     |
| **Audio**            | [audioplayers](https://pub.dev/packages/audioplayers) (`^6.0.0`)       | Background music & interactive sound effects              |
| **UI Animations**    | [flutter_animate](https://pub.dev/packages/flutter_animate) (`^4.5.0`) | Dynamic UI entrance effects and shimmer animations        |

---

## 📂 Project Structure

```
lib/
├── app/
│   ├── app.dart                   # GetMaterialApp configuration
│   ├── routes/                    # AppRoutes & AppPages routing system
│   └── theme/                     # AppColors palette & dark obsidian design system
├── core/
│   ├── constants/                 # AssetConstants, StorageKeys, GameConstants
│   ├── enums/                     # GameState, PowerUpType, ObstacleType
│   ├── services/                  # StorageService (GetStorage) & AudioService
│   └── utils/                     # Score & distance formatting utilities
├── features/
│   ├── game/                      # Flame engine instance, game loop & overlays
│   │   ├── bindings/              # GameBinding dependency injection
│   │   ├── controllers/           # GameController reactive state
│   │   ├── game/                  # Game components, player, obstacles & items
│   │   ├── views/                 # GameScreen layout
│   │   └── widgets/               # Pause, Game Over, and HUD overlays
│   ├── home/                      # Dashboard, best scores & currency badges
│   ├── leaderboard/               # Real-time database ranking screen
│   └── settings/                  # SFX/BGM settings & progress reset
└── main.dart                      # App entry point & core service initialization
```

---

## 🚀 Getting Started (Development Setup)

### Prerequisites

Ensure you have the following installed on your machine:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.0.0`)
- [Dart SDK](https://dart.dev/get-dart) (`>= 3.0.0`)
- Android Studio / VS Code with Flutter extension enabled
- Android Emulator or connected physical device

### Installation & Run

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/ShamsulHaque12/Temple_Dash_Game.git
   cd Temple_Dash_Game
   ```

2. **Install Dependencies**:

   ```bash
   flutter pub get
   ```

3. **Check Code Health**:

   ```bash
   flutter analyze
   ```

4. **Launch the Game**:

   ```bash
   flutter run
   ```

5. **Build Release APK**:
   ```bash
   flutter build apk --release
   ```

---

## 📱 Screenshots & UI Design

|    Home Screen    |    Gameplay     |    Leaderboard    |     Settings     |
| :---------------: | :-------------: | :---------------: | :--------------: |
| Main Menu & Stats | Flame 2D Runner | Database Rankings | SFX & Data Reset |

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/ShamsulHaque12/Temple_Dash_Game/issues) or submit a pull request.

---

## 📝 License

This project is open-source and available under the [MIT License](LICENSE).
