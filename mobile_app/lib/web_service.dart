// services/web_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_app/quiz_model.dart';

class WebService {
  final String _baseUrl;

  // Constructor: Initialize with the base URL of your API
  WebService({required String baseUrl}) : _baseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;


  // --- Generic GET Request ---
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    final Uri url = Uri.parse('$_baseUrl/$endpoint');
    try {
      final response = await http.get(url, headers: _prepareHeaders(headers));
      return _handleResponse(response);
    } catch (e) {
      print('GET Request Error ($endpoint): $e');
      throw _handleError(e);
    }
  }

  // --- Generic POST Request ---
  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    final Uri url = Uri.parse('$_baseUrl/$endpoint');
    try {
      final response = await http.post(
        url,
        headers: _prepareHeaders(headers, contentType: 'application/json; charset=UTF-8'),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      print('POST Request Error ($endpoint): $e');
      throw _handleError(e);
    }
  }

  // --- Specific Method: Get Quiz ---
  // Example: GET /quiz/{quizId} or /quizzes/random
  Future<List<QuizQuestion>> getQuiz({String quizId = 'default'}) async {
    // Adjust the endpoint based on your API structure
    // For example, if you fetch a specific quiz by ID:
    // final String endpoint = 'quizzes/$quizId';
    // Or if you fetch a list of questions for a generic quiz:
    final String endpoint = 'quiz/questions'; // Example endpoint

    try {
      // Assuming the API returns a list of questions directly
      // Or a JSON object with a key like "questions": []
      final responseData = await get(endpoint);


      // If the questions are nested under a key, e.g., "data" or "questions"
      // final List<dynamic> questionsJson = responseData['questions'] as List;

      // If the API directly returns a list of questions:
      if (responseData['data'] is List) { // Adjust 'data' if your API uses a different key
        final List<dynamic> questionsJson = responseData['data'] as List;
        return questionsJson.map((json) => QuizQuestion.fromJson(json)).toList();
      } else if (responseData is List) { // If the root is a list
        final List<dynamic> questionsJson = responseData as List;
        return questionsJson.map((json) => QuizQuestion.fromJson(json)).toList();
      }
      else {
        throw Exception('Unexpected response format for quiz questions.');
      }

    } catch (e) {
      print('Error fetching quiz: $e');
      // You might want to return an empty list or re-throw a more specific error
      throw Exception('Failed to load quiz: $e');
    }
  }


  // --- Specific Method: Submit Quiz Answers (Example) ---
  // Example: POST /quiz/submit
  Future<Map<String, dynamic>> submitQuizAnswers(String quizId, List<Map<String, dynamic>> answers) async {
    final String endpoint = 'quiz/$quizId/submit';
    try {
      final responseData = await post(endpoint, body: {'answers': answers});
      // Process response, e.g., score, corrections
      return responseData;
    } catch (e) {
      print('Error submitting quiz answers: $e');
      throw Exception('Failed to submit quiz answers: $e');
    }
  }


  // --- Helper Methods ---
  Map<String, String> _prepareHeaders(Map<String, String>? customHeaders, {String? contentType}) {
    final Map<String, String> headers = {
      // Add any common headers here, like Authorization
      // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
    };
    if (contentType != null) {
      headers['Content-Type'] = contentType;
    }
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = response.body;
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      if (body.isEmpty) return {}; // Handle empty successful responses
      try {
        return jsonDecode(body) as Map<String, dynamic>;
      } catch (e) {
        // If the body is not JSON but the request was successful (e.g. 204 No Content)
        // or if it's a list at the root.
        if (body.startsWith('[')) { // Crude check for list
          try {
            // Wrap the list in a map for consistency if your _handleResponse expects a Map
            return {'data': jsonDecode(body)};
          } catch (listError) {
            throw Exception('Failed to parse successful response (list): $listError');
          }
        }
        // For 204 No Content, an empty map is fine. For others, it might be an issue.
        if (statusCode == 204) return {};
        print('Warning: Successful response with non-JSON body (Status $statusCode): $body');
        throw Exception('Failed to parse successful response: $e. Body: $body');
      }
    } else if (statusCode == 401 || statusCode == 403) {
      throw UnauthorizedException('Unauthorized or Forbidden (Status $statusCode). Body: $body');
    } else if (statusCode >= 400 && statusCode < 500) {
      throw ClientErrorException('Client Error (Status $statusCode). Body: $body', statusCode);
    } else if (statusCode >= 500) {
      throw ServerErrorException('Server Error (Status $statusCode). Body: $body', statusCode);
    } else {
      throw UnknownErrorException('Unknown Error (Status $statusCode). Body: $body', statusCode);
    }
  }

  Exception _handleError(dynamic e) {
    if (e is http.ClientException) {
      return NetworkException('Network error: ${e.message}');
    }
    // You can add more specific error handling here if needed
    return Exception('An unexpected error occurred: $e');
  }
}

// --- Custom Exception Classes (Optional but Recommended) ---
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => "ApiException: $message ${statusCode != null ? '(Status $statusCode)' : ''}";
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message, 401);
}

class ClientErrorException extends ApiException {
  ClientErrorException(String message, int statusCode) : super(message, statusCode);
}

class ServerErrorException extends ApiException {
  ServerErrorException(String message, int statusCode) : super(message, statusCode);
}

class UnknownErrorException extends ApiException {
  UnknownErrorException(String message, int statusCode) : super(message, statusCode);
}

class NetworkException extends ApiException {
  NetworkException(String message) : super(message);
}
