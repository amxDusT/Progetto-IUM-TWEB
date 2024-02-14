import 'package:get/get.dart';

class ProfileController extends GetxController{
  late RxBool isDarkMode;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    isDarkMode = Get.isDarkMode.obs;
  }
}