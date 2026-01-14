import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:workoutwiz/models/user_profile.dart';
import 'package:workoutwiz/services/theme_service.dart';
import 'package:workoutwiz/screens/setup_screen.dart';
import 'package:workoutwiz/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: const WorkoutWizApp(),
    ),
  );
}

class WorkoutWizApp extends StatelessWidget {
  const WorkoutWizApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final profileProvider = Provider.of<UserProfileProvider>(context);

    // Premium Midnight Glass Dark Theme
    final darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF00E5FF),
        brightness: Brightness.dark,
        surface: const Color(0xFF0F172A),
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF020617),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E293B).withValues(alpha: 0.7),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );

    // Premium Crystal Glass Light Theme
    final lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6366F1),
        brightness: Brightness.light,
        surface: Colors.white.withValues(alpha: 0.9),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.8),
        elevation: 5,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    );

    return MaterialApp(
      title: 'WorkoutWiz',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeService.themeMode,
      home: profileProvider.isSetupComplete
          ? const MainScreen()
          : const SetupScreen(),
    );
  }
}
