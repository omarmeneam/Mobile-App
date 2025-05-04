# CampusCart

A mobile application for the University of Toronto Mississauga community to buy, sell, and exchange goods and services.

## Overview

CampusCart is a Flutter-based application that provides a platform for UTM students to connect and trade items within the campus community. The app features user authentication, product listings, messaging, and more.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.7.0 or higher)
  - [Windows installation guide](https://docs.flutter.dev/get-started/install/windows)
  - [macOS installation guide](https://docs.flutter.dev/get-started/install/macos)
- [Dart SDK](https://dart.dev/get-dart) (v3.0.0 or higher)
- [Git](https://git-scm.com/downloads)
- [VS Code](https://code.visualstudio.com/) with the following extensions:
  - [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
  - [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)
  - Recommended: [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
- For iOS development: Xcode (Mac only)
- For Android development: 
  - [Android Studio](https://developer.android.com/studio) (to install Android SDK)
  - [Java Development Kit (JDK)](https://www.oracle.com/java/technologies/downloads/)
- [Firebase CLI](https://firebase.google.com/docs/cli) (for Firebase functionality)

## Environment Setup (Platform-Specific)

### Windows Setup

1. Install Flutter by downloading the [Flutter SDK](https://docs.flutter.dev/get-started/install/windows)
2. Extract the zip file in a desired location (avoid paths with special characters or spaces)
3. Add Flutter to your PATH:
   - Search for "Environment Variables" in Windows search
   - Under "User variables" select Path > Edit > New
   - Add the full path to `flutter\bin` directory
   - Click OK to save
4. Install Android Studio to get the Android SDK
5. Run `flutter doctor` in Command Prompt to verify installation and identify any issues

### macOS Setup

1. Install Flutter using [Homebrew](https://brew.sh/):
   ```bash
   brew install flutter
   ```
   Or download the [Flutter SDK](https://docs.flutter.dev/get-started/install/macos) directly
2. Install Xcode from the Mac App Store
3. Run `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
4. Run `sudo xcodebuild -runFirstLaunch` to accept licenses
5. Run `flutter doctor` in Terminal to verify installation and identify any issues

## Getting Started

Follow these steps to set up the project on your local machine:

1. **Clone the repository**

   ```bash
   git clone https://github.com/your-username/campuscart.git
   cd campuscart
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**

   This app uses Firebase for authentication and database services. You'll need to set up Firebase for this project:

   1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   2. Add Android, iOS, and web apps to your Firebase project
   3. Download the configuration files:
      - `google-services.json` for Android
      - `GoogleService-Info.plist` for iOS/macOS
   4. Place these files in their respective directories:
      - Android: `android/app/`
      - iOS: `ios/Runner/`
      - macOS: `macos/Runner/`

   Note: These configuration files are intentionally excluded from Git via `.gitignore`.

4. **Configure Firebase CLI** (optional for advanced Firebase features)

   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   # Login to Firebase
   firebase login
   # List your Firebase projects
   firebase projects:list
   # Set your project
   firebase use your-project-id
   ```

5. **VS Code Configuration**

   1. Open the project in VS Code
   2. Install recommended extensions (Flutter, Dart)
   3. Set up your Flutter SDK path in VS Code settings:
      - Press `Ctrl+,` (Windows) or `Cmd+,` (macOS)
      - Search for "Flutter SDK Path"
      - Enter the path to your Flutter SDK installation

6. **Run the application**

   ```bash
   flutter run
   ```
   
   Alternatively, in VS Code:
   1. Open the command palette (`Ctrl+Shift+P` on Windows or `Cmd+Shift+P` on macOS)
   2. Type "Flutter: Select Device" and choose your target device
   3. Press F5 or click the "Run" button in the Debug panel

## Cross-Platform Development Notes

### Git Line Endings

To avoid line ending issues between Windows and macOS:

- Windows users should run:
  ```bash
  git config --global core.autocrlf true
  ```
- macOS users should run:
  ```bash
  git config --global core.autocrlf input
  ```

### Path Differences

- Windows uses backslashes (`\`) for file paths
- macOS uses forward slashes (`/`) for file paths
- Always use forward slashes in code/configuration when referring to file paths

### iOS Development (macOS only)

iOS app development and testing can only be done on macOS. Windows users can still contribute to the project, but cannot test on iOS devices or simulators.

## Project Structure

```
lib/
├── firebase_options.dart - Firebase configuration
├── main.dart - Entry point of the application
├── models/ - Data models
├── screens/ - UI screens
├── services/ - Business logic and services
├── widgets/ - Reusable UI components
└── utils/ - Utility functions and constants
```

## Contributing

1. Create a new branch for your feature or bugfix
2. Make your changes
3. Test thoroughly
4. Create a pull request with a clear description of changes
5. Wait for code review and approval

## Troubleshooting

- If you encounter build errors, try:
  ```bash
  flutter clean
  flutter pub get
  ```

- For Firebase configuration issues, verify your configuration files are correctly placed and your app's bundle ID/package name matches what's registered in Firebase.

- For platform-specific issues:
  - iOS (macOS only): Ensure you have run `cd ios && pod install` in the iOS directory
  - Android: Check your Android SDK paths and versions in the Flutter settings

- Windows-specific issues:
  - Path length limitations: Keep project paths relatively short
  - Permissions: Try running VS Code as administrator if you face permission issues

- macOS-specific issues:
  - If you get "command not found": Make sure your PATH environment variable includes Flutter
  - For iOS simulator issues: Update Xcode and run `sudo xcodebuild -runFirstLaunch`

## License

This project is licensed under the MIT License - see the LICENSE file for details.