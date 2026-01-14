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
      isScrollControlled: true,
      builder: (context) => const _SettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Theme.of(context).scaffoldBackgroundColor),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                expandedHeight: 160,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'WORKOUTWIZ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 6,
                      fontSize: 14,
                    ),
                  ),
                  centerTitle: true,
                  background: Center(
                    child: Text(
                      'Training',
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.w900,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.03),
                        letterSpacing: -4,
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: _showSettings,
                    icon: Icon(
                      Icons.menu_open_rounded,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Performance Categories',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Select a specialized body part to begin.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w300,
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
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('ERROR LOAD')),
                    );
                  }

                  final categories = snapshot.data ?? [];
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                0.85, // Adjusted for image/icon space
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final category = categories[index];
                        final displayTitle = category.toUpperCase();
                        return _CategoryCard(
                          title: displayTitle,
                          rawName: category,
                        );
                      }, childCount: categories.length),
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String rawName;

  const _CategoryCard({required this.title, required this.rawName});

  IconData _getCategoryIcon(String rawName) {
    switch (rawName.toLowerCase()) {
      case 'back':
        return Icons.fitness_center;
      case 'cardio':
        return Icons.directions_run;
      case 'chest':
        return Icons.accessibility;
      case 'lower arms':
        return Icons.handyman_outlined;
      case 'lower legs':
        return Icons.directions_walk;
      case 'neck':
        return Icons.person_pin_circle_outlined;
      case 'shoulders':
        return Icons.architecture_outlined;
      case 'upper arms':
        return Icons.fitness_center;
      case 'upper legs':
        return Icons.nordic_walking;
      case 'waist':
        return Icons.accessibility_new;
      default:
        return Icons.fitness_center_rounded;
    }
  }

  String? _getCategoryAsset(String rawName) {
    final name = rawName.toLowerCase();
    // Only back and cardio have assets currently according to list_dir
    if (name == 'back' ||
        name == 'cardio' ||
        name == 'chest' ||
        name == 'lower arms' ||
        name == 'lower legs' ||
        name == 'neck' ||
        name == 'shoulders' ||
        name == 'upper arms' ||
        name == 'upper legs' ||
        name == 'waist') {
      return 'assets/$name.png';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String? assetPath = _getCategoryAsset(rawName);
    final IconData icon = _getCategoryIcon(rawName);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseListScreen(category: rawName),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
            width: 0.5,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: assetPath != null
                  ? Image.asset(
                      assetPath,
                      fit: BoxFit.cover,
                      opacity: AlwaysStoppedAnimation(isDark ? 0.3 : 0.4),
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          icon,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary
                              .withValues(alpha: isDark ? 0.15 : 0.12),
                        ),
                      ),
                    )
                  : Icon(
                      icon,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary.withValues(
                        alpha: isDark ? 0.15 : 0.12,
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'REGION',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Theme.of(context).colorScheme.primary
                              .withValues(alpha: isDark ? 0.6 : 0.8),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                          height: 1.1,
                          color: Theme.of(context).colorScheme.onSurface,
                          shadows: assetPath != null
                              ? [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 4,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 20,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SYSTEM',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 6,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _buildActionItem(
            context,
            icon: Icons.brightness_6_outlined,
            title: 'Appearance Mode',
            subtitle: 'Change interface aesthetics',
            onTap: () {
              Navigator.pop(context);
              _showThemePicker(context);
            },
          ),
          const SizedBox(height: 24),
          _buildActionItem(
            context,
            icon: Icons.person_outline_rounded,
            title: 'Physical Metrics',
            subtitle: 'Update your body statistics',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SetupScreen(isEditing: true),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.03)
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 0.5,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 12,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const _ThemePickerSheet(),
    );
  }
}

class _ThemePickerSheet extends StatelessWidget {
  const _ThemePickerSheet();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1117) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.05),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'SELECT THEME',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 32),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ThemeChip(label: 'LIGHT', mode: ThemeMode.light),
              _ThemeChip(label: 'DARK', mode: ThemeMode.dark),
              _ThemeChip(label: 'AUTO', mode: ThemeMode.system),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final String label;
  final ThemeMode mode;

  const _ThemeChip({required this.label, required this.mode});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final isSelected = themeService.themeMode == mode;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => themeService.setThemeMode(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : (isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.black.withValues(alpha: 0.03)),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: isSelected
                ? Colors.white
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
