import 'package:flutter/material.dart';
import 'package:flutter_progetto/resources/storage.dart';
import 'package:get/get.dart';

class Lang {
  static const Map<String, dynamic> langs = {
    'Italian': Locale('it', 'IT'),
    'English': Locale('en', 'US'),
  };
  static List<String> get availableLanguages => langs.keys.toList();
  static String get currentLanguage =>
      (Get.locale?.languageCode ?? 'it') == 'it' ? 'Italian' : 'English';
  static Future<void> changeLanguage(String language) async {
    if (currentLanguage != language) {
      await Get.updateLocale(langs[language]);
      await Storage.setParam('lang', currentLanguage);
    }
  }
}
