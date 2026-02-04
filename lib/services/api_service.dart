import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:workoutwiz/models/exercise.dart';

class ApiService {
  String get baseUrl {
    return dotenv.env['BASE_URL'] ??
        'https://exercise-backend-nwhr.onrender.com';
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

  Future<List<Exercise>> fetchExercisesByBodyPart(String bodyPart) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/exercises'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final allExercises = data
            .map((json) => Exercise.fromJson(json))
            .toList();

        return allExercises
            .where((e) => e.bodyPart.toLowerCase() == bodyPart.toLowerCase())
            .toList();
      } else {
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      throw Exception('Error fetching exercises: $e');
    }
  }
}
