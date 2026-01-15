# 🦅 WorkoutWiz

**The Ultimate Premium Fitness Companion**

WorkoutWiz is a high-performance, aesthetically stunning fitness application built with Flutter. It combines a premium "Crystal Slate" design with robust API integration to deliver a seamless workout discovery experience.

---

## ✨ Key Features

### 🎨 Premium "Crystal Slate" Design
- **Immersive Glassmorphism**: Cards and UI elements feature a sophisticated glass effect with dynamic blurs and subtle borders.
- **Dynamic Theming**: Instantly switch between **Midnight Glass (Dark)** and **Crystal Professional (Light)** modes. The entire UI, including modal backgrounds, adapts in real-time.
- **System Sync**: Status bar icons and system overlays automatically synchronize with the active theme for a cohesive experience.

### 🏋️‍♂️ Smart Workout Discovery
- **Visual Categories**: Browse exercises by body part using a stunning 2-column grid.
- **Robust Visuals**: Features high-quality background assets for primary regions (Back, Cardio) and intelligent, large-scale icon fallbacks for others.
- **API Integration**: Powered by **ExerciseDB (RapidAPI)** to fetch thousands of exercises with animated GIFs and detailed instructions.

### 👤 User-Centric Experience
- **Profile Management**: Persist your physical metrics (Height, Weight, Age) locally using secure storage.
- **Onboarding Flow**: A seamless setup wizard ensures a personalized experience from the first launch.
- **Performance**: Optimized list rendering, cached visuals, and a universal "fat" APK for maximum device compatibility.

---

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: `Provider` (ChangeNotifier)
- **Networking**: `http` package
- **Local Storage**: `shared_preferences`
- **Environment**: `flutter_dotenv` for secure secret management
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
Create a `.env` file in the root directory and add your RapidAPI credentials:
```env
BASE_URL=YOUR_BASE_URL
RAPIDAPI_KEY=YOUR_RAPIDAPI_KEY
RAPIDAPI_HOST=YOUR_RAPIDAPI_HOST
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
*Note: The GitHub workflow automatically produces a `WorkoutWiz-v1.0.X.apk` universal build.*

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
