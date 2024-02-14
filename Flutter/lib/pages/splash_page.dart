import 'package:flutter/material.dart';
import 'package:flutter_progetto/pages/home_page.dart';
import 'package:flutter_progetto/pages/login_page.dart';
import 'package:flutter_progetto/resources/auth_methods.dart';
import 'package:flutter_progetto/resources/error_handler.dart';
import 'package:flutter_progetto/utils/error_codes.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Get.off fixes problem when changing language that it resets
  // the pageView
  void loadData() async {
    try {
      bool isLogged = await AuthMethods().isLoggedIn();
      await Future.delayed(const Duration(milliseconds: 1000));

      if (isLogged) {
        Get.off(() => HomePage());
      } else {
        Get.off(() => LoginPage());
      }
    } on ErrorException catch (e) {
      //ErrorHandler.handleError(e);
      if (e.errCode == ErrorCodes.ERROR_CONNECTION) {
        Get.snackbar('error'.tr, e.toString());
      }
      Get.off(() => LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'TeachMeNow',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: const LinearProgressIndicator(),
          )
        ],
      ),
    );
  }
}
