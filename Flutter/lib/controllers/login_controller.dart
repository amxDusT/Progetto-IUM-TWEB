import 'package:flutter/material.dart';
import 'package:flutter_progetto/models/login.dart';
import 'package:flutter_progetto/pages/home_page.dart';
import 'package:flutter_progetto/resources/auth_methods.dart';
import 'package:flutter_progetto/resources/error_handler.dart';
import 'package:flutter_progetto/resources/session.dart';
import 'package:flutter_progetto/resources/storage.dart';
import 'package:flutter_progetto/utils/error_codes.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController userController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  //bool isLoading = false;
  final RxBool isLoading = false.obs;
  final RxBool isRemember = false.obs;
  final RxBool isPasswordVisible = false.obs;

  void loginUser() async {
    changeLoading(true);
    try {
      LoginResponse response = await AuthMethods().loginUser(
        LoginRequest(
          email: userController.text.trim(),
          password: pwController.text.trim(),
          login: true,
        ),
      );
      if (response.error.isNotEmpty) {
        ErrorHandler.handleError(ErrorException(
          errNum: ErrorCodes.ERROR_SERVER.errNum,
          message: response.error,
        ));
      } else {
        Session.updateToken(response.success);
        Session.updateUser(response.user);
        Storage.setToken(response.success);
        await Storage.setParam('lastUsername', response.user?.username ?? '');
        Get.off(() => HomePage(),
            transition: Transition.downToUp,
            duration: const Duration(milliseconds: 300));
        // HACK: sometimes it doesn't delete automatically ???
        Get.delete<LoginController>();
      }
    } on ErrorException catch (e) {
      ErrorHandler.handleError(e);
    } catch (e) {
      ErrorHandler.handleError(ErrorException(
        errNum: ErrorCodes.ERROR_UNKNOWN.errNum,
      ));
    } finally {
      changeLoading(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    userController.dispose();
    pwController.dispose();
  }

  void changeLoading(bool state) {
    isLoading.value = state;
  }

  void changeRemember(bool state) {
    isRemember.value = state;
  }

  void switchPasswordVisible() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onInit() async {
    super.onInit();
    userController.text = Get.arguments?['lastUsername'] ??
        await Storage.getParam('lastUsername') ??
        '';
  }
}
