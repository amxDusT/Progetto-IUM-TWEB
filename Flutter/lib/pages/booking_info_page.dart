import 'package:flutter/material.dart';
import 'package:flutter_progetto/controllers/my_bookings_controller.dart';
import 'package:flutter_progetto/models/prenotazione.dart';
import 'package:flutter_progetto/utils/global_variables.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingInfoPage extends StatelessWidget {
  final Prenotazione prenotazione;
  final _myBookingsController = Get.find<MyBookingsController>();
  BookingInfoPage({super.key, required this.prenotazione});

  DateTime getGiornoDate(int weekday) {
    final now = DateTime.now();
    int daysToAdd = (weekday - now.weekday + 7) % 7;
    return now.add(Duration(days: daysToAdd));
  }

  Color _getColor() {
    if (prenotazione.state! == PrenotazioneState.active) {
      return Colors.blue;
    } else if (prenotazione.state! == PrenotazioneState.done) {
      return Colors.green[400]!;
    }
    return Get.theme.colorScheme.errorContainer;
  }

  Widget _getTextFromState({double? size}) {
    if (prenotazione.state == PrenotazioneState.active) {
      return Text(
        'active'.tr,
        style: Get.textTheme.bodySmall!.copyWith(
          fontSize: size,
          //color: Colors.green,
        ),
      );
    } else if (prenotazione.state == PrenotazioneState.done) {
      return Text(
        'done'.tr,
        style: Get.textTheme.bodySmall!.copyWith(
          fontSize: size,
          //color: Colors.green,
        ),
      );
    }
    return Text(
      'cancelled'.tr,
      style: Get.textTheme.bodySmall!.copyWith(
        fontSize: size,
        //color: Colors.red,
      ),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('info_booking'.tr),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GetBuilder<MyBookingsController>(
                  builder: (controller) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.bounceInOut,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    alignment: Alignment.topCenter,
                    //height: 100,
                    decoration: BoxDecoration(
                      color: _getColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _getTextFromState(size: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  alignment: Alignment.topCenter,
                  //height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Get.theme.colorScheme.primaryContainer,
                      width: 2,
                    ),
                  ),
                  child: Column(children: [
                    Text(
                      prenotazione.corso!.nome,
                      style: Get.textTheme.headlineSmall,
                    ),
                    Text(
                      '${prenotazione.docente!.nome} ${prenotazione.docente!.cognome}',
                      style: Get.textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      prenotazione.corso!.descrizione,
                      style: Get.textTheme.bodyMedium!
                          .copyWith(letterSpacing: 0.5),
                    ),
                  ]),
                ),
                Container(
                  //margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  alignment: Alignment.topCenter,
                  //height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Get.theme.colorScheme.primaryContainer,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Expanded(
                            flex: 2, child: Icon(Icons.calendar_month)),
                        //SizedBox(width: 10,),
                        Expanded(
                          flex: 7,
                          child: Text(
                              DateFormat('EEEE', Get.locale?.languageCode)
                                  .format(getGiornoDate(prenotazione.giorno!))
                                  .toUpperCase()),
                        ),

                        Expanded(
                            flex: 2, child: Text(prenotazione.orario!.start)),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          ),
          GetBuilder<MyBookingsController>(builder: (controller) {
            if (prenotazione.state! == PrenotazioneState.active) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      //width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            'cancel'.tr,
                            style: Get.textTheme.titleSmall!.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            await _myBookingsController.getDeleteDialog(() {
                              Get.back();
                              controller.changePrenotazioneState(
                                  prenotazione, PrenotazioneState.deleted);
                            });
                          }),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      //width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          //elevation: ,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(
                          'done'.tr,
                          style: Get.textTheme.titleSmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          await _myBookingsController.getDoneDialog(() {
                            Get.back();
                            controller.changePrenotazioneState(
                                prenotazione, PrenotazioneState.done);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          }),
        ],
      ),
    );
  }
}
