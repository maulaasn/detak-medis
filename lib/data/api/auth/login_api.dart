import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/auth/login_model.dart';

class LoginApi {
  // static const String baseUrl = 'http://192.168.1.30:8000';
  // static const String baseUrl = 'http://10.252.129.212:8000';
   static const String baseUrl = 'http://192.168.127.87:8000';
  // static const String loginEndpoint = '/auth/login';

  static Future<LoginResponse> login(LoginRequest request) async {
    try {
      print('[DEBUG] Sending login request for email: ${request.email}');
      final response = await http.post(
        // Uri.parse('http://192.168.127.87:8000/auth/login'),
        Uri.parse('http://192.168.210.87:8000/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': request.email,
          'password': request.password,
        }),
      );

      print('[DEBUG] Response status: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final accessToken = data['access_token'];
        final tokenType = data['token_type'];
        
        print('[DEBUG] Login successful. Access token: $accessToken');
        print('[DEBUG] Token type: $tokenType');
        
        if (accessToken != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', accessToken);
          await prefs.setString('token_type', tokenType ?? 'Bearer');
        }

        return LoginResponse.fromJson(responseData);
      } else if (response.statusCode == 401) {
        print('[DEBUG] Login failed: Unauthorized');
        return LoginResponse(
          success: false,
          message: 'Email atau password salah!',
        );
      } else if (response.statusCode == 400) {
        print('[DEBUG] Login failed: Bad request');
        return LoginResponse(
          success: false,
          message:
              responseData['detail'] ??
              responseData['message'] ??
              'Data tidak valid!',
        );
      } else if (response.statusCode == 422) {
        // Validation error
        String errorMessage = 'Data tidak valid!';
        if (responseData['detail'] is List) {
          final errors = responseData['detail'] as List;
          if (errors.isNotEmpty) {
            errorMessage = errors.first['msg'] ?? errorMessage;
          }
        }
        print('[DEBUG] Login failed: Validation error - $errorMessage');
        return LoginResponse(success: false, message: errorMessage);
      } else {
        print('[DEBUG] Login failed: Server error');
        return LoginResponse(
          success: false,
          message: 'Terjadi kesalahan server. Coba lagi nanti.',
        );
      }
    } catch (e) {
      print('[DEBUG] Exception during login: $e');
      return LoginResponse(
        success: false,
        message:
            'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      );
    }
  }

  // Method untuk mendapatkan access token yang tersimpan
  static Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    print('[DEBUG] Retrieved stored access token: $token');
    return token;
  }

  // Method untuk mendapatkan token type yang tersimpan
  static Future<String?> getStoredTokenType() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenType = prefs.getString('token_type');
    print('[DEBUG] Retrieved stored token type: $tokenType');
    return tokenType;
  }

  // Method untuk mendapatkan full authorization header
  static Future<String?> getAuthorizationHeader() async {
    final token = await getStoredToken();
    final tokenType = await getStoredTokenType();
    
    if (token != null) {
      final header = '${tokenType ?? 'Bearer'} $token';
      print('[DEBUG] Authorization header: $header');
      return header;
    }
    print('[DEBUG] Authorization header: null');
    return null;
  }

  // Method untuk mengecek apakah token tersimpan
  static Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    print('[DEBUG] Has token: ${token != null && token.isNotEmpty}');
    return token != null && token.isNotEmpty;
  }

  // Method untuk menghapus token (logout)
  static Future<void> clearStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('token_type');
    print('[DEBUG] Cleared stored tokens');
  }
}