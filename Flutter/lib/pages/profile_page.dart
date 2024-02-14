import 'package:flutter/material.dart';
import 'package:flutter_progetto/controllers/profile_controller.dart';
import 'package:flutter_progetto/models/User.dart';
import 'package:flutter_progetto/pages/login_page.dart';
import 'package:flutter_progetto/resources/auth_methods.dart';
import 'package:flutter_progetto/resources/lang.dart';
import 'package:flutter_progetto/resources/session.dart';
import 'package:flutter_progetto/resources/theme.dart';
import 'package:flutter_progetto/utils/utils.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final User? _user = Session.user;
  final ProfileController _profileController = Get.put(ProfileController());
  void logOut() {
    final String? username = _user?.username;
    Get.deleteAll();
    Get.off(() => LoginPage(),
        transition: Transition.upToDown,
        duration: const Duration(milliseconds: 300),
        arguments: {'lastUsername': username});
    AuthMethods().logOut();
  }

  void switchTheme() {
    ThemeHandler.changeTheme(_profileController.isDarkMode.isFalse);
    _profileController.isDarkMode.value = _profileController.isDarkMode.isFalse;
  }

  void changeLang(BuildContext context) {
    changeLanguageDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.3,
          child: Placeholder(
            child: Center(
              child: Text(
                'hello'.trParams({
                  'name': _user?.username ?? 'User',
                }),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text('language'.trParams({
                  'lang': Lang.currentLanguage.toLowerCase().tr,
                })),
                onTap: () => changeLang(context),
              ),
              const Divider(),
              Obx(
                () => ListTile(
                  leading: const Icon(Icons.palette),
                  title: Text('theme'.trParams({
                    'theme': _profileController.isDarkMode.isTrue
                        ? 'dark'.tr
                        : 'light'.tr,
                  })),
                  trailing: InkWell(
                    onTap: switchTheme,
                    child: Icon(
                      _profileController.isDarkMode.isTrue
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                  ),
                  onTap: switchTheme,
                ),
              ),
              const Divider(),
              ListTile(
                onTap: logOut,
                leading: const Icon(Icons.logout),
                title: Text('log_out'.tr),
              )
            ],
          ),
        ),
      ],
    );
  }
}
