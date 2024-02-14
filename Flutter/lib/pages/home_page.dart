import 'package:flutter/material.dart';
import 'package:flutter_progetto/controllers/home_controller.dart';
import 'package:flutter_progetto/controllers/my_bookings_controller.dart';
import 'package:flutter_progetto/pages/search_page.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _key = const PageStorageKey('vasd');

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          actions: [
            if (homeController.currentPage.value == 1)
              IconButton(
                  onPressed: () async {
                    final MyBookingsController controller =
                        Get.find<MyBookingsController>();
                    controller.showHelp();
                  },
                  icon: const Icon(Icons.help)),
          ],
          bottom: homeController.currentPage.value == 0
              ? AppBar(
                  primary: false,
                  title: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Get.theme.colorScheme.background,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Hero(
                        tag: 'searchBarHero',
                        flightShuttleBuilder: ((flightContext,
                                animation,
                                flightDirection,
                                fromHeroContext,
                                toHeroContext) =>
                            Material(
                              type: MaterialType.transparency,
                              child: toHeroContext.widget,
                            )),
                        child: TextField(
                          canRequestFocus: false,
                          readOnly: true,
                          onTap: () {
                            Get.to(() => const SearchPage(),
                                transition: Transition.fadeIn,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.bounceInOut);
                          },
                          //onSubmitted:
                          decoration: InputDecoration(
                            //filled: true,
                            //fillColor: Colors.gre,
                            prefixIcon: const Icon(
                              Icons.search,
                            ),
                            hintText: 'search'.tr,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : null,
          title: const Text('TeachMeNow'),
          centerTitle: true,
          //flexibleSpace: const Text('test'),
        ),
        body: PageView(
          key: _key,
          physics: const NeverScrollableScrollPhysics(),
          controller: homeController.pageController,
          onPageChanged: (page) => homeController.changePage(page),
          children: homeController.homeScreenItems,
        ),
        bottomNavigationBar: NavigationBar(
          indicatorColor: Colors.grey,
          backgroundColor: Colors.black,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          height: 60,
          onDestinationSelected: (page) =>
              homeController.navigationTapped(page),
          selectedIndex: homeController.currentPage.value,
          destinations: [
            ...homeController.icons
                .asMap()
                .entries
                .map((entry) => _navBarItem(icon: entry.value, page: entry.key))
                .toList(),
          ],
        ),
      ),
    );
  }

  NavigationDestination _navBarItem(
      {required IconData icon, required int page}) {
    return NavigationDestination(
      icon: Icon(
        icon,
        color: homeController.currentPage.value == page
            ? Get.theme.colorScheme.primary
            : Get.theme.colorScheme.primaryContainer,
      ),
      label: homeController.labels[page],
      tooltip: homeController.labels[page],
      //backgroundColor: primaryColor,
    );
  }
}
