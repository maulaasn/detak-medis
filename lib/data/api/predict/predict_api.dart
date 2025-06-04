import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:detak_medis/data/models/predict_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PredictApi {
  // static const String baseUrl = 'http://192.168.127.87:8000/diagnoses/';
  static const String baseUrl = 'http://192.168.210.87:8000/diagnoses/';
  static const Duration requestTimeout = Duration(seconds: 300);

  static Future<DiagnosisResult?> sendDiagnosis({
    required File imageFile,
    required String query,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      
      print('=== DEBUG INFO ===');
      print('Token yang digunakan: ${token?.substring(0, 20)}...'); // Only show first 20 chars for security
      print('Base URL: $baseUrl');
      print('Query: $query');
      print('Image path: ${imageFile.path}');
      print('Image exists: ${await imageFile.exists()}');
      print('Image size: ${await imageFile.length()} bytes');
      
      if (token == null) {
        print('Token tidak ditemukan. Silakan login terlebih dahulu.');
        return null;
      }

      // Check if image file exists and has content
      if (!await imageFile.exists()) {
        print('File gambar tidak ditemukan');
        return null;
      }

      final fileSize = await imageFile.length();
      if (fileSize == 0) {
        print('File gambar kosong');
        return null;
      }

      final uri = Uri.parse(baseUrl);
      print('Mengirim request ke $baseUrl');

      final request = http.MultipartRequest('POST', uri);
      
      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });
      
      // Add fields
      request.fields['query'] = query;
      
      // Add file with proper content type detection
      String mimeType = 'image/jpeg';
      String extension = imageFile.path.toLowerCase().split('.').last;
      
      switch (extension) {
        case 'png':
          mimeType = 'image/png';
          break;
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
      }
      
      request.files.add(await http.MultipartFile.fromPath(
        'image_file', // Make sure this matches your API endpoint parameter name
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      ));

      print('Mengirim request dengan timeout ${requestTimeout.inSeconds} detik...');
      
      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        requestTimeout,
        onTimeout: () {
          print('Request timeout setelah ${requestTimeout.inSeconds} detik');
          throw TimeoutException('Request timeout', requestTimeout);
        },
      );
      
      print('Menerima response stream...');
      final response = await http.Response.fromStream(streamedResponse);

      print('=== RESPONSE INFO ===');
      print('Status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body length: ${response.body.length}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = jsonDecode(response.body);
          print('JSON decoded successfully');
          print('Data structure: ${data.runtimeType}');
          print('Data keys: ${data is Map ? data.keys.toList() : 'Not a Map'}');
          
          final result = DiagnosisResult.fromJson(data);
          print(' DiagnosisResult created successfully');
          return result;
        } catch (jsonError) {
          print(' Error parsing JSON: $jsonError');
          print('Raw response: ${response.body}');
          return null;
        }
      } else if (response.statusCode == 401) {
        print(' Unauthorized. Token mungkin expired atau invalid.');
        return null;
      } else if (response.statusCode == 422) {
        print(' Validation error. Check request format.');
        try {
          final errorData = jsonDecode(response.body);
          print('Validation errors: $errorData');
        } catch (e) {
          print('Could not parse error response');
        }
        return null;
      } else {
        print(' Request failed with status: ${response.statusCode}');
        print('Error body: ${response.body}');
        return null;
      }
    } on TimeoutException catch (e) {
      print(' Timeout error: $e');
      return null;
    } on SocketException catch (e) {
      print(' Network error: $e');
      print('Pastikan server berjalan dan dapat diakses');
      return null;
    } on FormatException catch (e) {
      print(' Format error: $e');
      return null;
    } catch (e, stackTrace) {
      print(' Unexpected error: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  // Helper method to test connection
  static Future<bool> testConnection() async {
    try {
      final uri = Uri.parse(baseUrl.replaceAll('/diagnoses/', '/'));
      final response = await http.get(uri).timeout(Duration(seconds: 10));
      print('Connection test - Status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }
}