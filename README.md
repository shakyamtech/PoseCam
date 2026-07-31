# PoseSnap AI 📸✨

**PoseSnap AI** is a modern, AI-powered Flutter camera application designed to assist users in capturing stunning photos with real-time, trendy pose guidance and aesthetic suggestions.

## 🚀 Architecture & Tech Stack

- **Framework**: Flutter (Latest Stable, Dart Null Safety)
- **Design System**: Material 3 with HSL-Tailored Dynamic Dark & Light themes
- **Architecture**: Clean Architecture (Feature-First pattern)
- **State Management & DI**: Riverpod 2.x
- **Routing**: GoRouter (Declarative, type-safe navigation)
- **Responsiveness**: Adaptive layout scaling service (`ResponsiveUtils`)
- **Backend Readiness**: Prepared Firebase initialization service wrapper

## 📁 Directory Structure

```
lib/
├── core/
│   ├── constants/       # App Colors, Typography, Assets, Constants
│   ├── theme/           # Material 3 Light & Dark Theme definitions
│   ├── routes/          # GoRouter configuration & Route names
│   ├── services/        # Storage, Firebase & API readiness services
│   ├── utils/           # Responsive scaling & Result monad
│   └── widgets/         # Reusable UI Components (Buttons, Cards, Loaders)
├── features/
│   ├── splash/          # Animated Launch Screen
│   ├── onboarding/      # Welcome & Feature Showcase
│   ├── home/            # Main Dashboard & Trendy Poses
│   ├── camera/          # AI Camera Viewfinder (Placeholder)
│   ├── pose/            # Pose Library & Category Viewers
│   ├── editor/          # Photo Filter & Enhancement Studio
│   ├── profile/         # User Profile & Saved Shots
│   └── settings/        # App Preferences & Theme Toggle
├── models/              # Core Data Models
├── repositories/        # Data Sources & Repositories
├── providers/           # App-wide Riverpod State & DI
├── app.dart             # MaterialApp Router wrapper
└── main.dart            # Entry point
```

## 🛠️ Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Run the application:
   ```bash
   flutter run
   ```
