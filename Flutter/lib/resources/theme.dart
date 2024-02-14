import 'package:flutter/material.dart';
import 'package:flutter_progetto/resources/storage.dart';
import 'package:get/get.dart';

class ThemeHandler {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue[200],
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
      background: const Color.fromARGB(255, 202, 231, 255),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.blue[200],
      elevation: 5,
      shadowColor: Colors.grey[700],
    ),
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
  );
  static void changeTheme(bool dark) async {
    if (dark) {
      Get.changeTheme(ThemeData.dark(useMaterial3: true));
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      Get.changeTheme(lightTheme);
      Get.changeThemeMode(ThemeMode.light);
    }
    await Storage.setParam('theme', dark ? 'dark' : 'light');
  }
}
