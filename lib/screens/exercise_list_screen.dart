import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:workoutwiz/models/exercise.dart';
import 'package:workoutwiz/services/api_service.dart';

class ExerciseListScreen extends StatefulWidget {
  final String category;

  const ExerciseListScreen({super.key, required this.category});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Exercise>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _apiService.fetchExercisesByBodyPart(widget.category);
  }

  String _formatTitle(String text) {
    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final title = _formatTitle(widget.category);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('$title Exercises'),
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Theme.of(context).brightness == Brightness.dark
                    ? [const Color(0xFF020617), const Color(0xFF0F172A)]
                    : [const Color(0xFFF8FAFC), const Color(0xFFE2E8F0)],
              ),
            ),
          ),
          FutureBuilder<List<Exercise>>(
            future: _exercisesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No exercises found.'));
              }

              final exercises = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).padding.top + 70,
                  20,
                  20,
                ),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return _ExerciseGlassCard(exercise: exercise);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ExerciseGlassCard extends StatelessWidget {
  final Exercise exercise;

  const _ExerciseGlassCard({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (exercise.gifUrl.isNotEmpty)
              Stack(
                children: [
                  Image.network(
                    exercise.gifUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 250,
                        color: Colors.white10,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 250,
                      color: Colors.white10,
                      child: const Icon(Icons.image_not_supported, size: 50),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        exercise.target.toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        exercise.equipment
                            .split(' ')
                            .map((w) => w[0].toUpperCase() + w.substring(1))
                            .join(' '),
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  if (exercise.instructions.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'TECHNIQUE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...exercise.instructions
                        .take(3)
                        .map(
                          (instr) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 4,
                                    right: 12,
                                  ),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    instr,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.8),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
