import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_progetto/pages/splash_page.dart';
import 'package:flutter_progetto/resources/lang.dart';
import 'package:flutter_progetto/resources/storage.dart';
import 'package:flutter_progetto/resources/theme.dart';
import 'package:flutter_progetto/utils/lang_messages.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  //debugPaintSizeEnabled = true;
  runApp(const MyApp());
  await FlutterDisplayMode.setHighRefreshRate();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  void runPreferences() {
    setLanguage();
    setTheme();
  }

  bool isDark(String theme) {
    return theme == 'dark';
  }

  void setTheme() async {
    String? theme = await Storage.getParam('theme');
    if (theme != null && isDark(theme) != Get.isDarkMode) {
      ThemeHandler.changeTheme(isDark(theme));
    }
  }

  void setLanguage() async {
    String? lang = await Storage.getParam('lang');
    if (lang != null && Lang.availableLanguages.contains(lang)) {
      Lang.changeLanguage(lang);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      onInit: runPreferences,
      title: 'TeachMeNow',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('it', 'IT'),
        Locale('en', 'US'),
      ],
      translations: LangMessages(),
      locale: const Locale('it', 'IT'),
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(
        useMaterial3: true,
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 72, 72, 72),
          indicatorColor: Colors.white,
          elevation: 0,
        ),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 72, 72, 72),
          elevation: 5,
          shadowColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        cardTheme: const CardTheme(
          color: Color.fromARGB(255, 72, 72, 72),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          //background: Colors.grey,
          background: const Color.fromARGB(255, 50, 50, 50),
          primary: Colors.white,
          secondary: Colors.grey,
          primaryContainer: Colors.grey,
          secondaryContainer: Colors.blue,
          seedColor: Colors.blue,
          // ···
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.dark,

      //initialRoute: Routes.loginPage,
      //getPages: getPages,
      //home: const TestingPage(),
      home: const SplashPage(),
    );
  }
}
