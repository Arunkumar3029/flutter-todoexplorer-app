import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ApiService {
  static Future<List<Todo>> fetchTodos(int page, int limit) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://jsonplaceholder.typicode.com/todos?_page=$page&_limit=$limit',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return data.map((e) => Todo.fromJson(e)).toList();
      } else {
        throw ApiException('Failed to load todos from server',
            statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Network error or invalid data format: $e');
    }
  }
}
