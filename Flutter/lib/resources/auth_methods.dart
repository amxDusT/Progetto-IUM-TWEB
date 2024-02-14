import 'package:flutter_progetto/models/login.dart';
import 'package:flutter_progetto/resources/error_handler.dart';
import 'package:flutter_progetto/resources/storage.dart';
import 'package:flutter_progetto/resources/session.dart';
import 'dart:convert';

class AuthMethods {
  final String loginApi = 'login/api';
  Future<LoginResponse> loginUser(LoginRequest loginRequest) async {
    final response =
        await Session.post(loginApi, loginRequest.toJson()).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw ErrorException(errNum: 499);
      },
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw ErrorException(errNum: response.statusCode);
    }
  }

  Future<void> logOut() async {
    await Storage.clearToken();
    await Session.post(loginApi, const LoginRequest(login: false).toJson());
    // await Session.port(logoutURL, logout)
    Session.invalidate();
  }

  Future<bool> isLoggedIn() async {
    String? token = await Storage.getToken();
    if (token != null) {
      Session.updateToken(token);
    }

    LoginResponse loginResponse = await loginUser(const LoginRequest());
    if (loginResponse.error.isNotEmpty) {
      return false;
    }
    Session.updateUser(loginResponse.user);
    return true;
  }
}
