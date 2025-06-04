class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginResponse {
  final bool success;
  final String message;
  final String? accessToken;
  final String? tokenType;

  LoginResponse({
    required this.success,
    required this.message,
    this.accessToken,
    this.tokenType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['access_token'] != null, // Jika ada access_token berarti sukses
      message: json['access_token'] != null ? 'Login berhasil!' : (json['message'] ?? 'Login gagal'),
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }
}