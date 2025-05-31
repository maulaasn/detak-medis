import 'package:detak_medis/data/api/auth/login_api.dart';
import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;

  /// Fungsi login dengan email dan password
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final responseData = await LoginApi.login(email, password);

      debugPrint("Login response: $responseData");

      if (responseData != null && responseData is Map<String, dynamic>) {
        _userData = responseData;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = "Login gagal: format data tidak dikenali.";
      }
    } catch (e) {
      _errorMessage = "Login gagal: ${e.toString()}";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _userData = null;
    notifyListeners();
  }
}
