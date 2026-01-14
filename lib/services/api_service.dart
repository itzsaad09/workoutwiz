import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workoutwiz/models/exercise.dart';

class ApiService {
  final String baseUrl = dotenv.get('BASE_URL');
  final String apiKey = dotenv.get('RAPIDAPI_KEY');
  final String apiHost = dotenv.get('RAPIDAPI_HOST');

  Future<List<String>> fetchExerciseCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exercises/bodyPartList'),
        headers: {'x-rapidapi-key': apiKey, 'x-rapidapi-host': apiHost},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<String>();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      // Fallback to body parts from screenshot
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
  }

  Future<List<Exercise>> fetchExercisesByBodyPart(String bodyPart) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exercises/bodyPart/$bodyPart'),
        headers: {'x-rapidapi-key': apiKey, 'x-rapidapi-host': apiHost},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Exercise.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load exercises for $bodyPart');
      }
    } catch (e) {
      return [];
    }
  }
}
