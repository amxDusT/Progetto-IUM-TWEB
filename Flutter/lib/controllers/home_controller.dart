import 'package:flutter/material.dart';
import 'package:flutter_progetto/pages/main_page.dart';
import 'package:flutter_progetto/pages/my_bookings_page.dart';
import 'package:flutter_progetto/pages/profile_page.dart';
import 'package:flutter_progetto/resources/session.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var key = const PageStorageKey('testingKeyasd');
  late PageController pageController;
  RxInt currentPage = 0.obs;
  late bool isAdmin;

  List<Widget> homeScreenItems = [
    MainPage(),
    MyBookingPage(),
    ProfilePage(),
  ];

  List<IconData> icons = [
    Icons.home,
    Icons.add_circle,
    Icons.person,
  ];
  List<String> labels = ['Home', 'bookings'.tr, 'profile'.tr];
  void changePage(int page) {
    currentPage.value = page;
  }

  void navigationTapped(int page) {
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentPage.value);
    isAdmin = (Session.user?.role.toLowerCase() ?? 'guest') == 'admin';
    if (isAdmin) {
      //homeScreenItems.insert(2, const AdminPage());
      //icons.insert(2, Icons.admin_panel_settings);
      //labels.insert(2, 'Admin');
    }
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }
}
