import 'package:flutter_progetto/pages/login_page.dart';
import 'package:flutter_progetto/resources/auth_methods.dart';
import 'package:flutter_progetto/utils/error_codes.dart';
import 'package:get/get.dart';

class ErrorException implements Exception {
  final ErrorCodes errCode;
  final String? message;
  ErrorException({required int errNum, this.message})
      : errCode = errorMessages[errNum] ?? ErrorCodes.ERROR_UNKNOWN;
  @override
  String toString() {
    if (message != null && message!.isNotEmpty) {
      return '${errCode.message.tr} \n $message';
    }
    return errCode.message.tr;
  }
}

class ErrorHandler {
  static void handleError(ErrorException e) {
    if (e.errCode == ErrorCodes.ERROR_LOGIN_NOT_LOGGED) {
      Get.offUntil(
        GetPageRoute(
            page: () => LoginPage(),
            transition: Transition.upToDown,
            transitionDuration: const Duration(milliseconds: 300)),
        (route) => false,
      );

      AuthMethods().logOut();
      Get.deleteAll();
    }

    Get
      ..closeCurrentSnackbar()
      ..snackbar(
        'error'.tr,
        e.errCode.errNum >= ErrorCodes.ERROR_DAY_ERROR.errNum
            ? '${e.toString()}. ${'retry_later'.tr}'
            : e.toString(),
        duration: const Duration(seconds: 2),
        animationDuration: const Duration(
          milliseconds: 300,
        ),
      );
  }
}
