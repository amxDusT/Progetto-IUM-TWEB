import 'package:flutter/material.dart';
import 'package:flutter_progetto/controllers/main_page_controller.dart';
import 'package:flutter_progetto/widgets/subject_card.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController textSearchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textSearchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MainPageController mainPageController = Get.find();
  
    mainPageController.resetSearch();

    final Debouncer debouncer =
        Debouncer(delay: const Duration(milliseconds: 500));
    return WillPopScope(
      onWillPop: () async {
        Get.focusScope!.unfocus();
        Future.delayed(const Duration(milliseconds: 100), ()=>Get.back());
        

        return Future.value(false);
      },
      child: Obx(
        () => Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            // The search area here
            title: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Get.theme.colorScheme.background,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Hero(
                  tag: 'searchBarHero',
                  flightShuttleBuilder: (flightContext, animation,
                          flightDirection, fromHeroContext, toHeroContext) =>
                      Material(
                    type: MaterialType.transparency,
                    child: toHeroContext.widget,
                  ),
                  child: TextField(
                    canRequestFocus: true,
                    autofocus: true,
                    controller: textSearchController,
                    onChanged: (value) => debouncer.call(() {
                      mainPageController.searchCorsi(textSearchController.text);
                      //BookingMethods().searchCorso(textSearchController.text);
                    }),
                    //onSubmitted:
                    decoration: InputDecoration(
                      //filled: true,
                        prefixIcon: const Icon(
                          Icons.search,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              mainPageController.searchCorsi('');
                              textSearchController.text = '';
                            });
                          },
                        ),
                        hintText: 'search'.tr,
                        border: InputBorder.none),
                  ),
                ),
              ),
            ),
          ),
          body: mainPageController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GetBuilder<MainPageController>(
                builder: (controller) => controller.searchedCorsi.isEmpty
                    ? _nonTrovato()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemCount: controller.searchedCorsi.length + 1,
                        itemBuilder: (context, index) {
                          //print(controller.searchedCorsi.isEmpty);
                          if (index == 0) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 12, bottom: 5),
                              //height: 30,
                              width: double.maxFinite,
                              child: Text(
                                'courses'.tr,
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                            );
                          }
                          return SubjectCard(
                              corso: controller.searchedCorsi[index - 1],
                              );
                        },
                      ),
              ),
        ),
      ),
    );
  }

  Widget _nonTrovato() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(flex: 2, child: Container()),
          const Icon(
            Icons.search_off_outlined,
            size: 80,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'not_found'.tr,
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
          Flexible(flex: 3, child: Container()),
        ],
      ),
    );
  }
}
