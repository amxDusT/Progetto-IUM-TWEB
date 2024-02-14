import 'package:flutter_progetto/models/User.dart';
import 'package:flutter_progetto/utils/error_codes.dart';
import 'package:http/http.dart' as http;

class Session {
  static const String urlBase =
      "http://192.168.244.128:8081/ServizioRipetizioniWeb_war_exploded/";
  static const String _cookieName = "JSESSIONID";
  static final Map<String, String> _headers = {};
  static User? user;

  static Future<http.Response> post(String url, dynamic data) async {
    http.Response response = await http
        .post(Uri.parse('$urlBase$url'), body: data, headers: _headers)
        .timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        return http.Response('Error', ErrorCodes.ERROR_CONNECTION.errorCode);
      },
    );
    return response;
  }

  static void updateToken(String token) {
    _headers['cookie'] = '$_cookieName=$token';
  }

  static void updateUser(User? loggedUser) {
    user = loggedUser;
  }

  static void invalidate() {
    _headers.clear();
    user = null;
  }
}
