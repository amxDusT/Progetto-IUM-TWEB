import 'package:flutter/material.dart';
import 'package:flutter_progetto/controllers/corso_controller.dart';
import 'package:flutter_progetto/models/corso.dart';
import 'package:flutter_progetto/pages/booking_page.dart';
import 'package:get/get.dart';

class CorsoPage extends StatelessWidget {
  final Corso corso;
  final CorsoController corsoController;
  CorsoPage({super.key, required this.corso})
      : corsoController = Get.put(CorsoController(corso: corso));

  String _getTestoButton() {
    if (corso.docentiNum == 0) {
      return 'no_teacher_available'.tr;
    } else if (corsoController.isAlreadyBooked.isTrue) {
      return 'course_already_booked'.tr;
    } else {
      return 'book'.tr;
    }
  }

  bool _isButtonActive() {
    if (corso.docentiNum == 0) {
      return false;
    } else if (corsoController.isAlreadyBooked.isTrue) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'HeroCorso${corso.nome}',
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(corso.nome),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20)
                      .copyWith(
                bottom: 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${'course_info'.tr}:',
                    style: Get.theme.textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    corso.descrizione,
                    style: Get.theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    height: 5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${'available_teachers'.tr}:',
                    style: Get.theme.textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    child: GetBuilder<CorsoController>(
                      builder: (controller) => controller.docenti.isEmpty
                          ? _nonTrovato()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.docenti.length,
                              itemBuilder: (context, index) {
                                //print(index);
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blueGrey,
                                    child: Text(
                                      controller.docenti[index].nome
                                          .substring(0, 1),
                                    ),
                                  ),
                                  // trailing: const Text('*****'),
                                  title: Text(
                                    '${controller.docenti[index].nome} ${controller.docenti[index].cognome}',
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_isButtonActive() ? Colors.grey : null,
                    //elevation: ,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(_getTestoButton()),
                  onPressed: () {
                    if (_isButtonActive()) {
                      Get.to(() => BookingPage(corso: corso));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nonTrovato() {
    return Align(
        alignment: Alignment.topCenter,
        child: Text(
          'no_teacher_available'.tr,
          style: Get.theme.textTheme.labelLarge,
          //style: Get.theme.textTheme.labelMedium,
        ));
  }
}
