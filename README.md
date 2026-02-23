# 🦅 WorkoutWiz

**The Ultimate Premium AI Fitness Companion**

WorkoutWiz is a high-performance, aesthetically stunning fitness application built with Flutter. It combines a premium "Crystal Slate" design with robust AI-powered training protocols to deliver a world-class workout experience.

---

## ✨ Key Features

### 🧠 AI Pro Plan Generator

- **Personalized Protocols**: Generates comprehensive 7-day high-performance training schedules based on target muscle groups and desired session duration.
- **Smart Logic**: Every plan includes scientific rest intervals, optimized set/rep schemes, and advanced pro-level techniques.
- **Persistent Intelligence**: Generated plans are saved locally using **SharedPreferences**, allowing you to access your custom strategy instantly even after restarting the app.

### 🎨 Unified Premium Aesthetics

- **Professional Brand Identity**: Transitioned to a unified "Professional Cyan/Slate" color palette for a more cohesive, high-end feel.
- **High-Visibility Redesign**: Feature cards now utilize sophisticated gradients, large-scale icon watermarks, and crisp "AI-POWERED" badges.
- **Immersive Glassmorphism**: UI elements feature sophisticated translucent effects with dynamic blurs and refined borders.
- **Dynamic Theming**: Seamlessly switch between **Midnight Glass (Dark)** and **Crystal Professional (Light)** modes with 100% UI synchronization.

### 🏋️‍♂️ Multi-Source Exercise Library

- **Offline-First Resilience**: Prioritizes local JSON data for key muscle groups, with seamless fallbacks to the ExerciseDB API for an uninterrupted experience.
- **Visual Discovery**: Browse exercises by body part using a refined, high-performance grid.
- **Instructional Focus**: Access thousands of exercises with animated GIFs, equipment requirements, and step-by-step technical guides.

### 👤 Advanced User-Centricity

- **Metric Persistence**: Locally store and refine your biological metrics (Height, Weight, Age) for a personalized journey.
- **One-Tap Access**: A dedicated "View Saved Plan" action allows you to bypass generation and jump straight into your existing training routine.
- **Universal Build**: Optimized for maximum device compatibility with a universal "fat" APK deployment.

---

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: `Provider` (ChangeNotifier Architecture)
- **Networking**: `http` package with dedicated `ApiService`
- **Persistence**: `shared_preferences` for local plan and profile storage
- **Environment**: `flutter_dotenv` for secure endpoint management
- **CI/CD**: GitHub Actions (Automated builds for Android & iOS)

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (v3.0+)
- Dart SDK
- Android Studio / VS Code

### 1. Clone the Repository

```bash
git clone https://github.com/itzsaad09/workoutwiz.git
cd workoutwiz
```

### 2. Environment Setup

Create a `.env` file in the root directory and add your credentials:

```env
BASE_URL=YOUR_BASE_URL
API_KEY=YOUR_API_KEY
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run
```

---

## 📦 Building for Production

This project uses a tailored CI/CD pipeline to produce universal APKs.

**Android**:

```bash
flutter build apk --release
```

_Note: The GitHub workflow automatically produces a `WorkoutWiz-v1.0.X.apk` universal build._

**iOS**:

```bash
flutter build ios --release
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the project.
2. Create feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit changes (`git commit -m 'Add AmazingFeature'`).
4. Push to branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

---

**Developed with ❤️ by Hafiz Muhammad Saad**
Linkedin: [Hafiz Muhammad Saad](https://www.linkedin.com/in/itzsaad09)
Github: [Hafiz Muhammad Saad](https://github.com/itzsaad09)
