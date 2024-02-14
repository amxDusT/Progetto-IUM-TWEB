import 'package:flutter/material.dart';
import 'package:flutter_progetto/controllers/my_bookings_controller.dart';
import 'package:flutter_progetto/widgets/my_booking_card.dart';
import 'package:get/get.dart';

class MyBookingPage extends StatelessWidget {
  MyBookingPage({super.key});
  final bookingController = Get.put(MyBookingsController());
  @override
  Widget build(BuildContext context) {
    bookingController.startAnimation();
    return RefreshIndicator(
      onRefresh: () async {
        bookingController.getPrenotazioni();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, left: 15, bottom: 5),
              //height: 30,
              width: double.maxFinite,
              child: Text(
                '${'active_bookings'.tr}: ',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            GetBuilder<MyBookingsController>(
              builder: (controller) => controller.prenotazioniAttive.isEmpty
                  ? Center(
                      child: Text('no_active_bookings'.tr),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      //physics: const BouncingScrollPhysics(),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.prenotazioniAttive.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Stack(
                            children: [
                              Obx(
                                () => Visibility(
                                  //visible: true,
                                  visible: controller.isVisible.value,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.green,
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    height: 71,
                                    width: Get.size.width,
                                  ),
                                ),
                              ),
                              Obx(
                                () => Visibility(
                                  visible: controller.isVisible.value,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.red,
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    height: 71,
                                    width: Get.size.width / 2,
                                  ),
                                ),
                              ),
                              Obx(
                                () => SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(
                                        0, 0), // Slide from the right
                                    end: Offset(
                                        controller.isRight.value ? 0.2 : -0.2,
                                        0),
                                  ).animate(controller.animation),
                                  child: MyBookingCard(
                                    prenotazione:
                                        controller.prenotazioniAttive[index],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return MyBookingCard(
                          prenotazione: controller.prenotazioniAttive[index],
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40, left: 15, bottom: 5),
              //height: 30,
              width: double.maxFinite,
              child: Text(
                '${'ended_bookings'.tr }: ',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            GetBuilder<MyBookingsController>(
              builder: (controller) => controller.prenotazioniScadute.isEmpty
                  ? Container(
                    alignment: Alignment.topCenter,
                    height: controller.prenotazioniAttive.length<5? Get.size.height*0.5:null,
                    child: Text('no_ended_bookings'.tr),
                  )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.prenotazioniScadute.length,
                      itemBuilder: (context, index) {
                        return MyBookingCard(
                          prenotazione: controller.prenotazioniScadute[index],
                        );
                      },
                    ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
