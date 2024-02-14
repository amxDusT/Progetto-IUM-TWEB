import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const _storage = FlutterSecureStorage();

  static const _token = 'token';
  static Future<void> setToken(String token) async =>
      await _storage.write(key: _token, value: token);

  static Future<String?> getToken() async => await _storage.read(key: _token);
  static Future<void> clearToken() async => await _storage.delete(key: _token);

  static Future<void> setParam(String key, String value) async => await _storage.write(key: key, value: value);
  static Future<String?> getParam(String key) async => await _storage.read(key: key);
  static Future<void> clearParam(String key) async => await _storage.delete(key: key);
}
