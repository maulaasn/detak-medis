import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class RegisterApi {
  // static const String baseUrl = 'http://192.168.1.30:8000';
    // static const String baseUrl = 'http://192.168.127.87:8000';
    static const String baseUrl = 'http://192.168.210.87:8000';

  static Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/register');
    
    final requestBody = {
      'name': name,
      'email': email,
      'password': password,
    };

    try {
      debugPrint("Sending POST to $url with body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('Request timeout: Server tidak merespons dalam 60 detik.');
        },
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        // Tangani jika response body bukan JSON valid
        try {
          final errorBody = jsonDecode(response.body);
          throw Exception(errorBody['detail'] ?? 'Gagal register: HTTP ${response.statusCode}');
        } catch (_) {
          throw Exception('Gagal register: ${response.body}');
        }
      }
    } catch (e) {
      debugPrint("Error saat register: $e");
      rethrow;
    }
  }
}
