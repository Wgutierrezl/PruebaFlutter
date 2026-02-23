import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

class ApiClient {
  static const String baseUrl = 'http://localhost:3000/api';

  static Future<http.Response> get(String path) async {
    return http.get(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
    );
  }

  static Future<http.Response> post(
    String path, {
    Object? body,
  }) async {
    return http.post(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> put(
    String path, {
    Object? body,
  }) async {
    return http.put(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(String path) async {
    return http.delete(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
    );
  }

  static Future<Map<String, String>> _headers() async {
    final headers = {
      'Content-Type': 'application/json',
    };

    final token = await TokenStorage.get();

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}