import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutwiz/screens/exercise_list_screen.dart';
import 'package:workoutwiz/screens/setup_screen.dart';
import 'package:workoutwiz/services/api_service.dart';
import 'package:workoutwiz/services/theme_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<String>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _apiService.fetchExerciseCategories();
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _SettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Mesh
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [const Color(0xFF020617), const Color(0xFF0F172A)]
                    : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'WorkoutWiz',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                ),
                actions: [
                  IconButton(
                    onPressed: _showSettings,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.settings_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target your body',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Choose a category to start your session',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FutureBuilder<List<String>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return SliverFillRemaining(
                      child: Center(child: Text('Error: ${snapshot.error}')),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('No categories found.')),
                    );
                  }

                  final categories = snapshot.data!;
                  return SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.85,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final category = categories[index];
                        final displayTitle = category
                            .split(' ')
                            .map(
                              (word) =>
                                  word[0].toUpperCase() + word.substring(1),
                            )
                            .join(' ');
                        return _CategoryGridCard(
                          title: displayTitle,
                          rawName: category,
                        );
                      }, childCount: categories.length),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryGridCard extends StatelessWidget {
  final String title;
  final String rawName;

  const _CategoryGridCard({required this.title, required this.rawName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseListScreen(category: rawName),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconForCategory(rawName),
                    color: Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Explore',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForCategory(String name) {
    switch (name.toLowerCase()) {
      case 'back':
        return Icons.accessibility_new;
      case 'cardio':
        return Icons.directions_run;
      case 'chest':
        return Icons.fitness_center;
      case 'lower arms':
        return Icons.handyman_outlined;
      case 'lower legs':
        return Icons.nordic_walking;
      case 'neck':
        return Icons.person_outline;
      case 'shoulders':
        return Icons.architecture;
      case 'upper arms':
        return Icons.sports_gymnastics;
      case 'upper legs':
        return Icons.keyboard_double_arrow_up;
      case 'waist':
        return Icons.vibration;
      default:
        return Icons.bolt;
    }
  }
}

class _SettingsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0F172A)
            : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Settings',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Appearance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ThemeOption(
                label: 'Light',
                icon: Icons.light_mode_outlined,
                mode: ThemeMode.light,
              ),
              _ThemeOption(
                label: 'Dark',
                icon: Icons.dark_mode_outlined,
                mode: ThemeMode.dark,
              ),
              _ThemeOption(
                label: 'System',
                icon: Icons.settings_brightness,
                mode: ThemeMode.system,
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'Profile',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SetupScreen(isEditing: true),
                ),
              );
            },
            leading: Icon(
              Icons.person_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text(
              'Edit Personal Info',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final ThemeMode mode;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final isSelected = themeService.themeMode == mode;
    return GestureDetector(
      onTap: () => themeService.setThemeMode(mode),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
