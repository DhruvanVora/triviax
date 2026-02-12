import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question_model.dart';

class ApiService {
  static const String baseUrl = 'https://the-trivia-api.com/api/questions';

  Future<List<Question>> fetchQuestions({int limit = 10, String difficulty = 'easy'}) async {
    final response = await http.get(Uri.parse('$baseUrl?limit=$limit&difficulty=$difficulty'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }
}
