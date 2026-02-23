import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:workoutwiz/models/exercise.dart';
import 'package:workoutwiz/models/workout_plan.dart';

WorkoutPlanResponse parseWorkoutPlan(String responseBody) {
  return WorkoutPlanResponse.fromJson(json.decode(responseBody));
}

class ApiService {
  String get baseUrl {
    return dotenv.env['BASE_URL'] ??
        'https://exercise-backend-gemini.onrender.com';
  }

  String? get apiKey {
    final key = dotenv.env['API_KEY'];
    if (key == null || key == 'YOUR_API_KEY_HERE' || key.isEmpty) return null;
    return key;
  }

  Future<List<String>> fetchExerciseCategories() async {
    return [
      "back",
      "cardio",
      "chest",
      "lower arms",
      "lower legs",
      "neck",
      "shoulders",
      "upper arms",
      "upper legs",
      "waist",
    ];
  }

  Future<WorkoutPlanResponse> generateWeeklyWorkoutPlan({
    required String targetMuscle,
    required int durationMinutes,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/workout/generate'),
        headers: {
          'Content-Type': 'application/json',
          if (apiKey != null) 'x-api-key': apiKey!,
        },
        body: json.encode({
          'target_muscle': targetMuscle,
          'duration_minutes': durationMinutes,
        }),
      );

      if (response.statusCode == 200) {
        return await compute(parseWorkoutPlan, response.body);
      } else {
        throw Exception(
          'Failed to generate weekly plan: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error generating weekly plan: $e');
    }
  }

  Future<List<Exercise>> fetchExercisesByBodyPart(
    String bodyPart, {
    int limit = 20,
    int offset = 0,
  }) async {
    // Priority: Try loading from local category-specific JSON first
    try {
      // Map category name to file name (e.g. "lower arms" -> "lowerarms")
      final fileName = bodyPart.toLowerCase().replaceAll(' ', '');
      final localExercises = await _loadExercisesFromLocalJson(
        'assets/excersies/$fileName.json',
      );

      if (localExercises.isNotEmpty) {
        final start = offset.clamp(0, localExercises.length);
        final end = (offset + limit).clamp(0, localExercises.length);
        return localExercises.sublist(start, end);
      }
    } catch (e) {
      debugPrint('Error using local exercises for $bodyPart: $e');

      // Secondary fallback to the original response.json if the specific one fails
      if (bodyPart.toLowerCase() == 'chest') {
        try {
          final chestEx = await _loadExercisesFromLocalJson('response.json');
          if (chestEx.isNotEmpty) {
            final start = offset.clamp(0, chestEx.length);
            final end = (offset + limit).clamp(0, chestEx.length);
            return chestEx.sublist(start, end);
          }
        } catch (_) {}
      }
    }

    // Final fallback to API if local data not found or failed
    try {
      final uri = Uri.parse('$baseUrl/api/workout/exercises').replace(
        queryParameters: {
          'bodyPart': bodyPart,
          'limit': limit.toString(),
          'offset': offset.toString(),
        },
      );
      final response = await http.get(
        uri,
        headers: {if (apiKey != null) 'x-api-key': apiKey!},
      );

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        List<dynamic> items = [];
        if (decoded is List) {
          items = decoded;
        } else if (decoded is Map) {
          for (final key in ['data', 'exercises', 'items', 'results', 'body']) {
            if (decoded[key] is List) {
              items = decoded[key] as List;
              break;
            }
          }
          if (items.isEmpty && decoded.values.first is List) {
            items = decoded.values.first as List;
          }
        }
        return items
            .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load exercises: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exercises: $e');
    }
  }

  Future<List<Exercise>> _loadExercisesFromLocalJson(String assetPath) async {
    try {
      final String response = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> data = json.decode(response);
      final List<Exercise> exercises = [];

      if (data['data'] != null && data['data']['plan'] != null) {
        final plan = data['data']['plan'] as List;
        for (var day in plan) {
          if (day['exercises'] != null) {
            final dayExercises = day['exercises'] as List;
            for (var ex in dayExercises) {
              if (ex['details'] != null) {
                exercises.add(Exercise.fromJson(ex['details']));
              }
            }
          }
        }
      }
      return exercises;
    } catch (e) {
      debugPrint('Error reading $assetPath: $e');
      return [];
    }
  }

  Future<Exercise> fetchExerciseById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/workout/exercises/$id'),
        headers: {if (apiKey != null) 'x-api-key': apiKey!},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Exercise.fromJson(data);
      } else {
        throw Exception('Failed to load detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching details: $e');
    }
  }
}
