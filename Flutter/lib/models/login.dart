import 'package:flutter_progetto/models/User.dart';
import 'package:flutter_progetto/models/response.dart';

class LoginRequest {
  final String email;
  final String password;
  final String action;
  final bool remember;
  final bool login;
  const LoginRequest({
    this.email = '',
    this.password = '',
    this.login = true,
    this.remember = false,
    
  }) : action = login? 'login':'logout';

  Map<String, dynamic> toJson() => {
        'username': email,
        'password': password,
        'action': action,
        'remember': remember? '1':'0',
      };
}

class LoginResponse extends Response{
  final User? user;
  const LoginResponse({
    required super.success,
    required super.error,
    this.user,
  });
  factory LoginResponse.fromJson(Map<String, dynamic> jsonMap) {
    return LoginResponse(
      success: jsonMap['success'] ?? '',
      error: jsonMap['error'] ?? '',
      user: jsonMap.containsKey('utente') ? User.fromJson(jsonMap['utente']) : null,
    );
  }
}
