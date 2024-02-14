import 'package:flutter/material.dart';
import 'package:flutter_progetto/controllers/main_page_controller.dart';
import 'package:flutter_progetto/widgets/subject_card.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final MainPageController mainPageController = Get.put(MainPageController());
  @override
  Widget build(BuildContext context) {
    //mainPageController.getCorsi();
    return Obx(() => RefreshIndicator(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, left: 15, bottom: 5),
                //height: 30,
                width: double.maxFinite,
                child: Text(
                  'courses'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: mainPageController.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : GetBuilder<MainPageController>(
                        builder: (controller) => ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: controller.corsi.length,
                          itemBuilder: (context, index) {
                            return SubjectCard(corso: controller.corsi[index]);
                          },
                        ),
                      ),
              ),
            ],
          ),
          onRefresh: () async {
            mainPageController.getCorsi();
            //await Future.delayed(const Duration(milliseconds: 800));
          },
        ));
  }
}
