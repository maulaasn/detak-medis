import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ChatApi {
  // static const String baseUrl = 'http://192.168.127.87:8000'; // untuk Android emulator
  static const String baseUrl = 'http://192.168.210.87:8000';

  static Future<dynamic> sendMessage(String message) async {
    try {
      final url = Uri.parse('$baseUrl/chat/');
      
      debugPrint("Sending request to: $url");
      debugPrint("Request body: ${jsonEncode({'query': message})}");
      
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'query': message}),
      ).timeout(
        const Duration(seconds: 60), // timeout
        onTimeout: () {
          throw Exception('Request timeout - server took too long to respond');
        },
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response headers: ${response.headers}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final result = jsonDecode(response.body);
          debugPrint("Parsed result: $result");
          return result;
        } catch (parseError) {
          debugPrint("JSON parsing error: $parseError");
          // If JSON parsing fails, return the raw response
          return {'response': response.body};
        }
      } else {
        debugPrint("HTTP Error ${response.statusCode}: ${response.body}");
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint("Network error in ChatApi.sendMessage: $e");
      rethrow;
    }
  }
}