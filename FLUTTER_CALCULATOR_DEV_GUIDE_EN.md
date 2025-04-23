# 🧮 Flutter Advanced Scientific Calculator Project Development Guide

[⬇️ **Android Latest Download**](https://github.com/HuQingyepersonalprojectsummary/flutterjisuanqqi20250421/releases/latest)

## 📚 Table of Contents
- [📖 Project Overview](#project-overview)
- [🛠️ Development Environment Setup](#development-environment-setup)
- [🗂️ Project Structure](#project-structure)
- [🧰 Tech Stack](#tech-stack)
- [🎨 UI Design & Features](#ui-design--features)
- [🧩 Core Components & Naming](#core-components--naming)
- [🔄 State Management (Provider/Riverpod Example)](#state-management-providerriverpod-example)
- [🌏 Internationalization & Language Switch](#internationalization--language-switch)
- [🧪 Testing & QA](#testing--qa)
- [📦 Packaging & Release](#packaging--release)
- [☁️ Auto Upload Release](#auto-upload-release)
- [❓ FAQ & Suggestions](#faq--suggestions)
- [📎 Appendix: Code Snippets & Advanced Usage](#appendix-code-snippets--advanced-usage)

---

## 📖 Project Overview
This project is a Flutter-based advanced scientific calculator app supporting basic and scientific calculations, memory operations, history, theme switching, and more. It features a modern, responsive UI and supports Windows, macOS, Linux, Android, and iOS platforms.

---

## 🛠️ Development Environment Setup
1. Install Flutter SDK
   - Official: https://flutter.dev
   - Recommended version: 3.x+
2. Dart SDK (bundled with Flutter)
3. Set environment variables (`flutter/bin` in PATH)
4. Install IDE (VSCode, Android Studio, IntelliJ IDEA)
5. Install dependencies:
   ```bash
   flutter pub get
   ```

---

## 🗂️ Project Structure
```
├── lib/
│   ├── main.dart           # Entry point
│   ├── screens/            # Screens
│   ├── widgets/            # Reusable widgets
│   ├── models/             # Data models
│   ├── services/           # Business logic/services
│   └── utils/              # Utilities
├── assets/                 # Images, fonts, etc.
├── test/                   # Unit tests
├── pubspec.yaml            # Dependencies & assets
├── README.md               # Project overview
└── FLUTTER_CALCULATOR_DEV_GUIDE_EN.md # This guide
```

---

## 🧰 Tech Stack
- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider / Riverpod / Bloc (Provider recommended)
- **Local Storage**: shared_preferences / hive
- **Packaging**: Flutter build, FVM, scripts
- **Testing**: Flutter test

---

## 🎨 UI Design & Features
### 1. Main Layout
#### 1.1 Display Area
- Large font for current input/result, auto-shrinks if overflow
- Expression area: smaller font, multi-line scroll
- Status indicators: degree/radian, memory stored, etc.

#### 1.2 Scientific Functions
- First row: sin, cos, tan, ln, log, π, e
- Second row: x², xʸ, √, ∛, 1/x, |x|, ( )
- Degree/radian toggle, bracket pairing hints, error highlight

#### 1.3 Numeric & Basic Operations
- Layout:
  ```
  [ 7 ] [ 8 ] [ 9 ] [ ÷ ]
  [ 4 ] [ 5 ] [ 6 ] [ × ]
  [ 1 ] [ 2 ] [ 3 ] [ - ]
  [ 0 ] [ . ] [ = ] [ + ]
  ```
- Function keys: C/AC, ⌫, +/-

#### 1.4 Memory & History
- Memory: MC, MR, M+, M-, MS
- History: popup, click to refill, delete, clear all

#### 1.5 Theme & Settings
- Theme switch: light/dark, follow system/manual
- Settings: precision, history length, sound, etc.

#### 1.6 Responsive Design
- Desktop: large buttons, keyboard shortcuts
- Mobile: adaptive width, gestures

---

## Feature Details
### 2.1 Basic Operations
- Continuous input, auto operator precedence
- Decimals, negatives, nested brackets
- Illegal input check

### 2.2 Scientific Operations
- Trig (sin, cos, tan), degree/radian switch
- Inverse trig (asin, acos, atan) via long press or menu
- Log, exp, power, root, constants π/e, abs, reciprocal

### 2.3 Memory
- MC, MR, MS, M+/M-, status indicator

### 2.4 History
- Auto-save last N (e.g. 20, configurable)
- Popup, click to refill, delete, clear all, persistent

### 2.5 Theme & Settings
- Light/dark, follow system, custom settings

### 2.6 Keyboard & Touch
- Desktop: keyboard input, shortcuts
- Mobile: long press, swipe, animation, sound

### 2.7 Error Handling
- Highlight illegal input, overflow, zero division, bracket mismatch

### 2.8 i18n & Extensibility
- Chinese/English switch, componentized code, easy to extend (e.g. graphing, unit conversion)

---

## 🧩 Core Components & Naming
- `CalculatorScreen`: main container
  - `DisplayPanel`: expression/result/status
  - `ScientificPad`: scientific buttons
  - `NumberPad`: numeric/basic buttons
  - `MemoryPanel`: memory buttons
  - `HistoryPanel`: history popup/sidebar
  - `ThemeSwitcher`: theme toggle
  - `SettingsDrawer`: settings

| Component         | Description                           |
|-------------------|---------------------------------------|
| DisplayPanel      | Shows expression, result, status      |
| ScientificPad     | sin/cos/tan, power, π, e, etc.        |
| NumberPad         | 0-9, ., +, -, ×, ÷, =, C/AC, ⌫, ±     |
| MemoryPanel       | MC, MR, MS, M+, M-                    |
| HistoryPanel      | Show/refill/delete history             |
| ThemeSwitcher     | Light/dark toggle                     |
| SettingsDrawer    | Settings (history, precision, sound)  |

---

## 🔄 State Management (Provider/Riverpod Example)
- Use Provider or Riverpod for global state:
  - Expression, result, history, memory, theme, mode, errors
- Separate business logic (e.g. `services/calculator_service.dart`)

### Riverpod Example
```dart
final calculatorProvider = StateNotifierProvider<CalculatorNotifier, CalculatorState>(
  (ref) => CalculatorNotifier(),
);
```

---

## 🧪 Testing & QA
- Unit tests for calculation logic (test/services/calculator_service_test.dart)
- Widget tests for UI (test/widgets/)
- Integration tests on all platforms

---

## Extensibility & Maintenance
- Modular design for easy feature addition
- Use flutter_localizations for i18n
- Unified code style (`flutter format`, `dart analyze`)
- Keep docs updated

---

## Typical Development Flow
1. Build static UI, ensure responsive
2. Implement core features step by step
3. Add tests alongside development
4. Test on all platforms
5. Prepare `releases/` for packaging

---

## 📦 Packaging & Release

### ☁️ Upload to GitHub Release and Distribute Installer

1. Make sure your local repo is pushed to GitHub:
   ```bash
   git add .
   git commit -m "release: add app-release"
   git push
   ```
2. Use GitHub CLI to create a Release and upload the installer (requires gh):
   ```bash
   gh release create v1.0.0 releases/app-release.apk --title "Calculator v1.0.0" --notes "Flutter Android APK"
   ```
   - `v1.0.0` is the release version, change as needed.
   - `releases/app-release.apk` is the installer path, ensure it's correct.
   - This will generate a Release page.
3. Visit your Release page or download the latest:
   - [Release page (v1.0.0 example)](https://github.com/HuQingyepersonalprojectsummary/flutterjisuanqqi20250421/releases/tag/v1.0.0)
   - [⬇️ Android Latest Download](https://github.com/HuQingyepersonalprojectsummary/flutterjisuanqqi20250421/releases/latest)

> For new versions, just update the version and file, and repeat the above commands.

- Set version in `pubspec.yaml`
- Desktop: `flutter build windows/macos/linux --release`
- Android: `flutter build apk/appbundle`
- iOS: `flutter build ios/ipa`
- Output paths: see Chinese doc for details

---

## ☁️ Auto Upload Release
- Install GitHub CLI, login
- Use `gh release create` and `gh release upload`

---

## ❓ FAQ & Suggestions
- Setup dependencies for each platform
- Android/iOS: signing required
- Use English filenames
- Use `flutter pub upgrade` for conflicts
- Use `flutter clean` for build issues

---

## Appendix: Provider/Riverpod & i18n
- See Chinese doc for full code examples

---

For more details, refer to the Chinese development guide or ask for specific code samples!
